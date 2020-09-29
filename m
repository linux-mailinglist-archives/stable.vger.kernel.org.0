Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C46A527C540
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:33:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729073AbgI2Ldg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:33:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:50012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729604AbgI2Ld1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:33:27 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B4B3223B99;
        Tue, 29 Sep 2020 11:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378812;
        bh=2UQ9DFaxS2qeBIdJST9eYG/tl8Ou/LtUg3wFI3kjC04=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p4KGSPV4V0briqR1i9iF0gZjkvc45jHtiB7/iPdL7sGIjxi+R1JdvzLgR7jq++vH4
         ooR25f/ykC1XtIZ5N3wjSN8diOYp5sGD7d1nVWFHI1nbDOLsV5FLyM4eFrtA6Wegy1
         +hq/KAt67TnIktHa+fhdL2jhB7m5d9n4wRSnZgys=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 148/245] drivers: char: tlclk.c: Avoid data race between init and interrupt handler
Date:   Tue, 29 Sep 2020 12:59:59 +0200
Message-Id: <20200929105954.189934904@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105946.978650816@linuxfoundation.org>
References: <20200929105946.978650816@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>

[ Upstream commit 44b8fb6eaa7c3fb770bf1e37619cdb3902cca1fc ]

After registering character device the file operation callbacks can be
called. The open callback registers interrupt handler.
Therefore interrupt handler can execute in parallel with rest of the init
function. To avoid such data race initialize telclk_interrupt variable
and struct alarm_events before registering character device.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
Link: https://lore.kernel.org/r/20200417153451.1551-1-madhuparnabhowmik10@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/tlclk.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/char/tlclk.c b/drivers/char/tlclk.c
index 8eeb4190207d1..dce22b7fc5449 100644
--- a/drivers/char/tlclk.c
+++ b/drivers/char/tlclk.c
@@ -776,17 +776,21 @@ static int __init tlclk_init(void)
 {
 	int ret;
 
+	telclk_interrupt = (inb(TLCLK_REG7) & 0x0f);
+
+	alarm_events = kzalloc( sizeof(struct tlclk_alarms), GFP_KERNEL);
+	if (!alarm_events) {
+		ret = -ENOMEM;
+		goto out1;
+	}
+
 	ret = register_chrdev(tlclk_major, "telco_clock", &tlclk_fops);
 	if (ret < 0) {
 		printk(KERN_ERR "tlclk: can't get major %d.\n", tlclk_major);
+		kfree(alarm_events);
 		return ret;
 	}
 	tlclk_major = ret;
-	alarm_events = kzalloc( sizeof(struct tlclk_alarms), GFP_KERNEL);
-	if (!alarm_events) {
-		ret = -ENOMEM;
-		goto out1;
-	}
 
 	/* Read telecom clock IRQ number (Set by BIOS) */
 	if (!request_region(TLCLK_BASE, 8, "telco_clock")) {
@@ -795,7 +799,6 @@ static int __init tlclk_init(void)
 		ret = -EBUSY;
 		goto out2;
 	}
-	telclk_interrupt = (inb(TLCLK_REG7) & 0x0f);
 
 	if (0x0F == telclk_interrupt ) { /* not MCPBL0010 ? */
 		printk(KERN_ERR "telclk_interrupt = 0x%x non-mcpbl0010 hw.\n",
@@ -836,8 +839,8 @@ out3:
 	release_region(TLCLK_BASE, 8);
 out2:
 	kfree(alarm_events);
-out1:
 	unregister_chrdev(tlclk_major, "telco_clock");
+out1:
 	return ret;
 }
 
-- 
2.25.1



