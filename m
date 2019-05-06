Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BD5C14F43
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 17:09:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726658AbfEFPI4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 11:08:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:56138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727043AbfEFOf4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:35:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E3FE021479;
        Mon,  6 May 2019 14:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557153355;
        bh=78zibKYhiig/J4kVmq6XTXpHwwwZRz64lGOKhh4NTDo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DMxM2xtQJVDSGl6WTwiyaYpzow+wd91sIHn6riOc6C5UM6UBx+6I0TJc9+U4KnFfZ
         xj+W1eJ+l42CJ3bClWCRevvgAZ7EjsMZWwUygwpJLO3F0b9ApXQ4HnrcPYmarHTDzW
         dfBr/jpi7QJI9O/AnMg81BzX5C5LAYlTiQAkCLYA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Kemnade <andreas@kemnade.info>,
        Tony Lindgren <tony@atomide.com>,
        Lee Jones <lee.jones@linaro.org>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: [PATCH 5.0 058/122] mfd: twl-core: Disable IRQ while suspended
Date:   Mon,  6 May 2019 16:31:56 +0200
Message-Id: <20190506143100.226604550@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143054.670334917@linuxfoundation.org>
References: <20190506143054.670334917@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 20bb907f7dc82ecc9e135ad7067ac7eb69c81222 ]

Since commit 6e2bd956936 ("i2c: omap: Use noirq system sleep pm ops to idle device for suspend")
on gta04 we have handle_twl4030_pih() called in situations where pm_runtime_get()
in i2c-omap.c returns -EACCES.

[   86.474365] Freezing remaining freezable tasks ... (elapsed 0.002 seconds) done.
[   86.485473] printk: Suspending console(s) (use no_console_suspend to debug)
[   86.555572] Disabling non-boot CPUs ...
[   86.555664] Successfully put all powerdomains to target state
[   86.563720] twl: Read failed (mod 1, reg 0x01 count 1)
[   86.563751] twl4030: I2C error -13 reading PIH ISR
[   86.563812] twl: Read failed (mod 1, reg 0x01 count 1)
[   86.563812] twl4030: I2C error -13 reading PIH ISR
[   86.563873] twl: Read failed (mod 1, reg 0x01 count 1)
[   86.563903] twl4030: I2C error -13 reading PIH ISR

This happens when we wakeup via something behing twl4030 (powerbutton or rtc
alarm). This goes on for minutes until the system is finally resumed.
Disable the irq on suspend and enable it on resume to avoid
having i2c access problems when the irq registers are checked.

Fixes: 6e2bd956936 ("i2c: omap: Use noirq system sleep pm ops to idle device for suspend")
Signed-off-by: Andreas Kemnade <andreas@kemnade.info>
Tested-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 drivers/mfd/twl-core.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/mfd/twl-core.c b/drivers/mfd/twl-core.c
index 299016bc46d9..104477b512a2 100644
--- a/drivers/mfd/twl-core.c
+++ b/drivers/mfd/twl-core.c
@@ -1245,6 +1245,28 @@ twl_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	return status;
 }
 
+static int __maybe_unused twl_suspend(struct device *dev)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+
+	if (client->irq)
+		disable_irq(client->irq);
+
+	return 0;
+}
+
+static int __maybe_unused twl_resume(struct device *dev)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+
+	if (client->irq)
+		enable_irq(client->irq);
+
+	return 0;
+}
+
+static SIMPLE_DEV_PM_OPS(twl_dev_pm_ops, twl_suspend, twl_resume);
+
 static const struct i2c_device_id twl_ids[] = {
 	{ "twl4030", TWL4030_VAUX2 },	/* "Triton 2" */
 	{ "twl5030", 0 },		/* T2 updated */
@@ -1262,6 +1284,7 @@ static const struct i2c_device_id twl_ids[] = {
 /* One Client Driver , 4 Clients */
 static struct i2c_driver twl_driver = {
 	.driver.name	= DRIVER_NAME,
+	.driver.pm	= &twl_dev_pm_ops,
 	.id_table	= twl_ids,
 	.probe		= twl_probe,
 	.remove		= twl_remove,
-- 
2.20.1



