Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56276594C9C
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 03:33:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344081AbiHPAom (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:44:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345397AbiHPAnI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:43:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 595D7D4191;
        Mon, 15 Aug 2022 13:40:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2B3B161185;
        Mon, 15 Aug 2022 20:40:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F9B8C433D6;
        Mon, 15 Aug 2022 20:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660596012;
        bh=uf6JlCQdeeCLNZvukkCqj/rwF7nUjJfD3aadEgWPqrs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QBxbO2WcWe9+BSqojLCwlkGXkeXaQ2au3WCp7g+OXgCfMNJbDD4i1T9xfya6Bo8c9
         lMKAms6a+SSOCOn/xVFTPWXbLgRJabo/VAx5SIjDwROisHAYJU2YVtjc/rtN+eB+yC
         /fgcPPlNYcx2K7tT5gF9JNLEacCwfsYRliRhnZxA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Starke <daniel.starke@siemens.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0946/1157] tty: n_gsm: fix missing corner cases in gsmld_poll()
Date:   Mon, 15 Aug 2022 20:05:02 +0200
Message-Id: <20220815180517.396806660@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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
index 51447ccccbab..caa5c14ed57f 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -3053,12 +3053,15 @@ static __poll_t gsmld_poll(struct tty_struct *tty, struct file *file,
 
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



