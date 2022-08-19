Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5D0959A222
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:37:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353035AbiHSQcr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:32:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353138AbiHSQal (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:30:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A55AF11C94B;
        Fri, 19 Aug 2022 09:05:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 076C9617A5;
        Fri, 19 Aug 2022 16:05:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03995C433C1;
        Fri, 19 Aug 2022 16:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660925106;
        bh=0PMcfGY2FU3afQYsNCtV0jBQJzvsw/EYDDZT+78GSdg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D6PE3jvwjbPw+R6n5gCO/RKUlLmVjP98jWb7Vf/rJ38MIQMEZyoFnMjJBqqpDPs7O
         R2+mOe+t7jEjUzoi5/Qj7NZZtXseOOWq8/0Is4paAHFIucvvQCQ9auecv6ZhdGflbZ
         Z/LRvEBuiLP61A3C6rPYr5dLjzfqDcuHpVnGWrRo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Starke <daniel.starke@siemens.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 386/545] tty: n_gsm: fix race condition in gsmld_write()
Date:   Fri, 19 Aug 2022 17:42:36 +0200
Message-Id: <20220819153846.683551196@linuxfoundation.org>
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
index b4cce5cd0e3d..969c0de788f8 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -2705,11 +2705,24 @@ static ssize_t gsmld_read(struct tty_struct *tty, struct file *file,
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



