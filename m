Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E1BA26F05B
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:44:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728672AbgIRCnD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:43:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:36188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727641AbgIRCLB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:11:01 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 80D2E21D92;
        Fri, 18 Sep 2020 02:11:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600395061;
        bh=2UQ9DFaxS2qeBIdJST9eYG/tl8Ou/LtUg3wFI3kjC04=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=APVRsGXZdsyAG/hnRK6EAbpIAyb5E55Jhw62+MrndrT18teDq9RqBh23G2voy9/m1
         ntAr2Iq4wg3un58Kd+u45UFAU39nZ3yhAWHS5ISXHW1LgcOXLDPQs0ktzMIR5fy/sF
         7q1DSqVY3YAf3vSPzBtXu66gLgwnK2OD4uAi/4ik=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 147/206] drivers: char: tlclk.c: Avoid data race between init and interrupt handler
Date:   Thu, 17 Sep 2020 22:07:03 -0400
Message-Id: <20200918020802.2065198-147-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020802.2065198-1-sashal@kernel.org>
References: <20200918020802.2065198-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

