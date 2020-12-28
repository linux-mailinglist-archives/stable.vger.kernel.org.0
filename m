Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4F2E2E3B0A
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:46:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404784AbgL1NpI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:45:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:45900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404771AbgL1NpH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:45:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9AABD208B3;
        Mon, 28 Dec 2020 13:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163066;
        bh=2qRXxXIL7ph8LCFdR1cG5oj+QfXZ9jrc6DX+IJ4MZMQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HSRfoOtTFHqdxtRwYQOHpRY2A+sc1JQl6F0eIUVGsgNI6WMNTOxQbZM1m1zAvmyrQ
         /ukqqSBZzWAKpnaCYsOui3UNd7PXwFCT66PtRqyE59+zTWArPfRC3pSt86nxPkClHu
         922a0XlH45va9yi0tR4y3wqtaHrGyBdwN/PR75bU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Qilong <zhangqilong3@huawei.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 157/453] Input: omap4-keypad - fix runtime PM error handling
Date:   Mon, 28 Dec 2020 13:46:33 +0100
Message-Id: <20201228124944.762593006@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Qilong <zhangqilong3@huawei.com>

[ Upstream commit 59bbf83835f591b95c3bdd09d900f3584fa227af ]

In omap4_keypad_probe, the patch fix several bugs.

  1) pm_runtime_get_sync will increment pm usage counter even it
     failed. Forgetting to pm_runtime_put_noidle will result in
     reference leak.

  2) In err_unmap, forget to disable runtime of device,
     pm_runtime_enable will increase power disable depth. Thus a
     pairing decrement is needed on the error handling path to keep
     it balanced.

  3) In err_pm_disable, it will call pm_runtime_put_sync twice not
     one time.

To fix this we factor out code reading revision and disabling touchpad, and
drop PM reference once we are done talking to the device.

Fixes: f77621cc640a7 ("Input: omap-keypad - dynamically handle register offsets")
Fixes: 5ad567ffbaf20 ("Input: omap4-keypad - wire up runtime PM handling")
Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Link: https://lore.kernel.org/r/20201120133918.2559681-1-zhangqilong3@huawei.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/keyboard/omap4-keypad.c | 89 ++++++++++++++++-----------
 1 file changed, 53 insertions(+), 36 deletions(-)

diff --git a/drivers/input/keyboard/omap4-keypad.c b/drivers/input/keyboard/omap4-keypad.c
index d6c924032aaa8..dd16f7b3c7ef6 100644
--- a/drivers/input/keyboard/omap4-keypad.c
+++ b/drivers/input/keyboard/omap4-keypad.c
@@ -186,12 +186,8 @@ static int omap4_keypad_open(struct input_dev *input)
 	return 0;
 }
 
-static void omap4_keypad_close(struct input_dev *input)
+static void omap4_keypad_stop(struct omap4_keypad *keypad_data)
 {
-	struct omap4_keypad *keypad_data = input_get_drvdata(input);
-
-	disable_irq(keypad_data->irq);
-
 	/* Disable interrupts and wake-up events */
 	kbd_write_irqreg(keypad_data, OMAP4_KBD_IRQENABLE,
 			 OMAP4_VAL_IRQDISABLE);
@@ -200,7 +196,15 @@ static void omap4_keypad_close(struct input_dev *input)
 	/* clear pending interrupts */
 	kbd_write_irqreg(keypad_data, OMAP4_KBD_IRQSTATUS,
 			 kbd_read_irqreg(keypad_data, OMAP4_KBD_IRQSTATUS));
+}
+
+static void omap4_keypad_close(struct input_dev *input)
+{
+	struct omap4_keypad *keypad_data;
 
+	keypad_data = input_get_drvdata(input);
+	disable_irq(keypad_data->irq);
+	omap4_keypad_stop(keypad_data);
 	enable_irq(keypad_data->irq);
 
 	pm_runtime_put_sync(input->dev.parent);
@@ -223,13 +227,37 @@ static int omap4_keypad_parse_dt(struct device *dev,
 	return 0;
 }
 
+static int omap4_keypad_check_revision(struct device *dev,
+				       struct omap4_keypad *keypad_data)
+{
+	unsigned int rev;
+
+	rev = __raw_readl(keypad_data->base + OMAP4_KBD_REVISION);
+	rev &= 0x03 << 30;
+	rev >>= 30;
+	switch (rev) {
+	case KBD_REVISION_OMAP4:
+		keypad_data->reg_offset = 0x00;
+		keypad_data->irqreg_offset = 0x00;
+		break;
+	case KBD_REVISION_OMAP5:
+		keypad_data->reg_offset = 0x10;
+		keypad_data->irqreg_offset = 0x0c;
+		break;
+	default:
+		dev_err(dev, "Keypad reports unsupported revision %d", rev);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static int omap4_keypad_probe(struct platform_device *pdev)
 {
 	struct omap4_keypad *keypad_data;
 	struct input_dev *input_dev;
 	struct resource *res;
 	unsigned int max_keys;
-	int rev;
 	int irq;
 	int error;
 
@@ -269,41 +297,33 @@ static int omap4_keypad_probe(struct platform_device *pdev)
 		goto err_release_mem;
 	}
 
+	pm_runtime_enable(&pdev->dev);
 
 	/*
 	 * Enable clocks for the keypad module so that we can read
 	 * revision register.
 	 */
-	pm_runtime_enable(&pdev->dev);
 	error = pm_runtime_get_sync(&pdev->dev);
 	if (error) {
 		dev_err(&pdev->dev, "pm_runtime_get_sync() failed\n");
-		goto err_unmap;
-	}
-	rev = __raw_readl(keypad_data->base + OMAP4_KBD_REVISION);
-	rev &= 0x03 << 30;
-	rev >>= 30;
-	switch (rev) {
-	case KBD_REVISION_OMAP4:
-		keypad_data->reg_offset = 0x00;
-		keypad_data->irqreg_offset = 0x00;
-		break;
-	case KBD_REVISION_OMAP5:
-		keypad_data->reg_offset = 0x10;
-		keypad_data->irqreg_offset = 0x0c;
-		break;
-	default:
-		dev_err(&pdev->dev,
-			"Keypad reports unsupported revision %d", rev);
-		error = -EINVAL;
-		goto err_pm_put_sync;
+		pm_runtime_put_noidle(&pdev->dev);
+	} else {
+		error = omap4_keypad_check_revision(&pdev->dev,
+						    keypad_data);
+		if (!error) {
+			/* Ensure device does not raise interrupts */
+			omap4_keypad_stop(keypad_data);
+		}
+		pm_runtime_put_sync(&pdev->dev);
 	}
+	if (error)
+		goto err_pm_disable;
 
 	/* input device allocation */
 	keypad_data->input = input_dev = input_allocate_device();
 	if (!input_dev) {
 		error = -ENOMEM;
-		goto err_pm_put_sync;
+		goto err_pm_disable;
 	}
 
 	input_dev->name = pdev->name;
@@ -349,28 +369,25 @@ static int omap4_keypad_probe(struct platform_device *pdev)
 		goto err_free_keymap;
 	}
 
-	device_init_wakeup(&pdev->dev, true);
-	pm_runtime_put_sync(&pdev->dev);
-
 	error = input_register_device(keypad_data->input);
 	if (error < 0) {
 		dev_err(&pdev->dev, "failed to register input device\n");
-		goto err_pm_disable;
+		goto err_free_irq;
 	}
 
+	device_init_wakeup(&pdev->dev, true);
 	platform_set_drvdata(pdev, keypad_data);
+
 	return 0;
 
-err_pm_disable:
-	pm_runtime_disable(&pdev->dev);
+err_free_irq:
 	free_irq(keypad_data->irq, keypad_data);
 err_free_keymap:
 	kfree(keypad_data->keymap);
 err_free_input:
 	input_free_device(input_dev);
-err_pm_put_sync:
-	pm_runtime_put_sync(&pdev->dev);
-err_unmap:
+err_pm_disable:
+	pm_runtime_disable(&pdev->dev);
 	iounmap(keypad_data->base);
 err_release_mem:
 	release_mem_region(res->start, resource_size(res));
-- 
2.27.0



