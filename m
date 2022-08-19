Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 785DE59A22B
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:37:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353063AbiHSQc4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:32:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353362AbiHSQb0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:31:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9013411E903;
        Fri, 19 Aug 2022 09:05:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 82207B8281A;
        Fri, 19 Aug 2022 16:05:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E07FDC433D6;
        Fri, 19 Aug 2022 16:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660925140;
        bh=qpFce+Tb+zJ1EIH4VJ8KyblvgOQHtWdFvmTVlDgV8G0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ann5xachG5rs11jdoj1cAN0cbkm2gcH5H6+0UWnhQJA0TNvSBQP4JeCpJCiEqqESs
         X3OJ0f4S1AE8DU5m6G21cnX5yiv4tZ2PfvY9OJV6ezTQV6Sh0LgYGCakNcRZPkjQQ8
         l909ppyRO0tciiLz+/yB37+/THNrAoGHH72+BRnU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Starke <daniel.starke@siemens.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 396/545] tty: n_gsm: fix missing corner cases in gsmld_poll()
Date:   Fri, 19 Aug 2022 17:42:46 +0200
Message-Id: <20220819153847.134824715@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Starke <daniel.starke@siemens.com>

[ Upstream commit 7e5b4322cde067e1d0f1bf8f490e93f664a7c843 ]

gsmld_poll() currently fails to handle the following corner cases correctly:
- remote party closed the associated tty

Add the missing checks and map those to EPOLLHUP.
Reorder the checks to group them by their reaction.

Fixes: e1eaea46bb40 ("tty: n_gsm line discipline")
Signed-off-by: Daniel Starke <daniel.starke@siemens.com>
Link: https://lore.kernel.org/r/20220707113223.3685-4-daniel.starke@siemens.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/n_gsm.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index a6c0a1b76ddb..cb5ed4155a8d 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -2747,12 +2747,15 @@ static __poll_t gsmld_poll(struct tty_struct *tty, struct file *file,
 
 	poll_wait(file, &tty->read_wait, wait);
 	poll_wait(file, &tty->write_wait, wait);
+
+	if (gsm->dead)
+		mask |= EPOLLHUP;
 	if (tty_hung_up_p(file))
 		mask |= EPOLLHUP;
+	if (test_bit(TTY_OTHER_CLOSED, &tty->flags))
+		mask |= EPOLLHUP;
 	if (!tty_is_writelocked(tty) && tty_write_room(tty) > 0)
 		mask |= EPOLLOUT | EPOLLWRNORM;
-	if (gsm->dead)
-		mask |= EPOLLHUP;
 	return mask;
 }
 
-- 
2.35.1



