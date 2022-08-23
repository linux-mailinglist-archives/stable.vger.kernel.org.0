Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2556E59E2CB
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:42:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347959AbiHWLdW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 07:33:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357775AbiHWLb4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 07:31:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2105C6B5E;
        Tue, 23 Aug 2022 02:26:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 17B7FB81C85;
        Tue, 23 Aug 2022 09:26:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C48BC433C1;
        Tue, 23 Aug 2022 09:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661246764;
        bh=yLnVnByEJNfJXieEJtxo3RfdRaW+VB9FFd0Spaj6f/M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LhedRmo6RB3rSmCqWI5vrB2+quns9dPyT2qhJNolqFDup86LEv3hKFi1eKedxjgH9
         cwO+GF+p91sgWMk9fGEQcDULoJsJ5l+xlBEOgpsriZ3K+BBfnDar9T2Rz9Zb10OYPk
         RiwNiEYu4lzQqGPPKGr8DX/TS+gUPzzIpQiC4rWs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Starke <daniel.starke@siemens.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 213/389] tty: n_gsm: fix race condition in gsmld_write()
Date:   Tue, 23 Aug 2022 10:24:51 +0200
Message-Id: <20220823080124.511484610@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080115.331990024@linuxfoundation.org>
References: <20220823080115.331990024@linuxfoundation.org>
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

[ Upstream commit 32dd59f96924f45e33bc79854f7a00679c0fa28e ]

The function may be used by the user directly and also by the n_gsm
internal functions. They can lead into a race condition which results in
interleaved frames if both are writing at the same time. The receiving side
is not able to decode those interleaved frames correctly.

Add a lock around the low side tty write to avoid race conditions and frame
interleaving between user originated writes and n_gsm writes.

Fixes: e1eaea46bb40 ("tty: n_gsm line discipline")
Signed-off-by: Daniel Starke <daniel.starke@siemens.com>
Link: https://lore.kernel.org/r/20220701061652.39604-9-daniel.starke@siemens.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/n_gsm.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index 893d6f502c2e..186f4633fd4a 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -2651,11 +2651,24 @@ static ssize_t gsmld_read(struct tty_struct *tty, struct file *file,
 static ssize_t gsmld_write(struct tty_struct *tty, struct file *file,
 			   const unsigned char *buf, size_t nr)
 {
-	int space = tty_write_room(tty);
+	struct gsm_mux *gsm = tty->disc_data;
+	unsigned long flags;
+	int space;
+	int ret;
+
+	if (!gsm)
+		return -ENODEV;
+
+	ret = -ENOBUFS;
+	spin_lock_irqsave(&gsm->tx_lock, flags);
+	space = tty_write_room(tty);
 	if (space >= nr)
-		return tty->ops->write(tty, buf, nr);
-	set_bit(TTY_DO_WRITE_WAKEUP, &tty->flags);
-	return -ENOBUFS;
+		ret = tty->ops->write(tty, buf, nr);
+	else
+		set_bit(TTY_DO_WRITE_WAKEUP, &tty->flags);
+	spin_unlock_irqrestore(&gsm->tx_lock, flags);
+
+	return ret;
 }
 
 /**
-- 
2.35.1



