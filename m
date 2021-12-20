Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E34A47AF2F
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:10:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236138AbhLTPKf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:10:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239393AbhLTPJV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 10:09:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0E4DC061747;
        Mon, 20 Dec 2021 06:54:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8FE3C6118E;
        Mon, 20 Dec 2021 14:54:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BE31C36AE7;
        Mon, 20 Dec 2021 14:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640012070;
        bh=WfyfpR5fvRvlOV411UoApCC+4jveNtwOCev9KtRZGPA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QseJL+Ot7I1MN21dPyvweMEvKq9hiiFsM9D8jsXkMR6YEDIa6rpno6/qNIEVH4mnB
         tt6Pp0jOXzQDtYqReledY/7jfqgvrlKqLOJF14xlBUJpEbsZevUmI0vAbujtFPzoBu
         tbcHRojABYYEjSr0gfvhpjx5HmlF6hS0C4cL2SkE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joerie de Gram <j.de.gram@gmail.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.15 037/177] pinctrl: amd: Fix wakeups when IRQ is shared with SCI
Date:   Mon, 20 Dec 2021 15:33:07 +0100
Message-Id: <20211220143041.345915623@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mario Limonciello <mario.limonciello@amd.com>

commit 2d54067fcd23aae61e23508425ae5b29e973573d upstream.

On some Lenovo AMD Gen2 platforms the IRQ for the SCI and pinctrl drivers
are shared.  Due to how the s2idle loop handling works, this case needs
an extra explicit check whether the interrupt was caused by SCI or by
the GPIO controller.

To fix this rework the existing IRQ handler function to function as a
checker and an IRQ handler depending on the calling arguments.

BugLink: https://gitlab.freedesktop.org/drm/amd/-/issues/1738
Reported-by: Joerie de Gram <j.de.gram@gmail.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Acked-by: Basavaraj Natikar <Basavaraj.Natikar@amd.com>
Link: https://lore.kernel.org/r/20211101014853.6177-2-mario.limonciello@amd.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/pinctrl-amd.c |   29 ++++++++++++++++++++++++++---
 1 file changed, 26 insertions(+), 3 deletions(-)

--- a/drivers/pinctrl/pinctrl-amd.c
+++ b/drivers/pinctrl/pinctrl-amd.c
@@ -598,14 +598,14 @@ static struct irq_chip amd_gpio_irqchip
 
 #define PIN_IRQ_PENDING	(BIT(INTERRUPT_STS_OFF) | BIT(WAKE_STS_OFF))
 
-static irqreturn_t amd_gpio_irq_handler(int irq, void *dev_id)
+static bool do_amd_gpio_irq_handler(int irq, void *dev_id)
 {
 	struct amd_gpio *gpio_dev = dev_id;
 	struct gpio_chip *gc = &gpio_dev->gc;
-	irqreturn_t ret = IRQ_NONE;
 	unsigned int i, irqnr;
 	unsigned long flags;
 	u32 __iomem *regs;
+	bool ret = false;
 	u32  regval;
 	u64 status, mask;
 
@@ -627,6 +627,14 @@ static irqreturn_t amd_gpio_irq_handler(
 		/* Each status bit covers four pins */
 		for (i = 0; i < 4; i++) {
 			regval = readl(regs + i);
+			/* caused wake on resume context for shared IRQ */
+			if (irq < 0 && (regval & BIT(WAKE_STS_OFF))) {
+				dev_dbg(&gpio_dev->pdev->dev,
+					"Waking due to GPIO %d: 0x%x",
+					irqnr + i, regval);
+				return true;
+			}
+
 			if (!(regval & PIN_IRQ_PENDING) ||
 			    !(regval & BIT(INTERRUPT_MASK_OFF)))
 				continue;
@@ -650,9 +658,12 @@ static irqreturn_t amd_gpio_irq_handler(
 			}
 			writel(regval, regs + i);
 			raw_spin_unlock_irqrestore(&gpio_dev->lock, flags);
-			ret = IRQ_HANDLED;
+			ret = true;
 		}
 	}
+	/* did not cause wake on resume context for shared IRQ */
+	if (irq < 0)
+		return false;
 
 	/* Signal EOI to the GPIO unit */
 	raw_spin_lock_irqsave(&gpio_dev->lock, flags);
@@ -664,6 +675,16 @@ static irqreturn_t amd_gpio_irq_handler(
 	return ret;
 }
 
+static irqreturn_t amd_gpio_irq_handler(int irq, void *dev_id)
+{
+	return IRQ_RETVAL(do_amd_gpio_irq_handler(irq, dev_id));
+}
+
+static bool __maybe_unused amd_gpio_check_wake(void *dev_id)
+{
+	return do_amd_gpio_irq_handler(-1, dev_id);
+}
+
 static int amd_get_groups_count(struct pinctrl_dev *pctldev)
 {
 	struct amd_gpio *gpio_dev = pinctrl_dev_get_drvdata(pctldev);
@@ -1033,6 +1054,7 @@ static int amd_gpio_probe(struct platfor
 		goto out2;
 
 	platform_set_drvdata(pdev, gpio_dev);
+	acpi_register_wakeup_handler(gpio_dev->irq, amd_gpio_check_wake, gpio_dev);
 
 	dev_dbg(&pdev->dev, "amd gpio driver loaded\n");
 	return ret;
@@ -1050,6 +1072,7 @@ static int amd_gpio_remove(struct platfo
 	gpio_dev = platform_get_drvdata(pdev);
 
 	gpiochip_remove(&gpio_dev->gc);
+	acpi_unregister_wakeup_handler(amd_gpio_check_wake, gpio_dev);
 
 	return 0;
 }


