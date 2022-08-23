Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AB9A59E221
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:41:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355170AbiHWKnO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:43:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355658AbiHWKkX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:40:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C622BDB0;
        Tue, 23 Aug 2022 02:08:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3CEE761598;
        Tue, 23 Aug 2022 09:08:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30B62C433C1;
        Tue, 23 Aug 2022 09:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661245693;
        bh=pn7Xkki/c1OBI4ZWFGs7oupIMGY204Tf9wIvyQ/9v5c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ebh/g8kgOm7RdRDWfQogw3W455WYbH6uRDc5QB6iw8u5NIk3Bkhzpb2BoW2awtLSC
         jvZlhUt3lxwceiQxu27EcEJ7RYqkRu1X4tUTMWVz+1iPGKzi3I6Tb7DEvw6iARbNu+
         rBoE9gqnk0RANAacPOm+aauF0zo8y6Zjlyp4YDwI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Starke <daniel.starke@siemens.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 159/287] tty: n_gsm: fix missing corner cases in gsmld_poll()
Date:   Tue, 23 Aug 2022 10:25:28 +0200
Message-Id: <20220823080106.053513743@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080100.268827165@linuxfoundation.org>
References: <20220823080100.268827165@linuxfoundation.org>
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
index 727707e02551..f6d2be13b32e 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -2561,12 +2561,15 @@ static __poll_t gsmld_poll(struct tty_struct *tty, struct file *file,
 
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



