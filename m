Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACB9C45E5AF
	for <lists+stable@lfdr.de>; Fri, 26 Nov 2021 04:00:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358088AbhKZCoM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 21:44:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:50036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1357794AbhKZCmL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Nov 2021 21:42:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 585F4611C8;
        Fri, 26 Nov 2021 02:35:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637894102;
        bh=Or2JHnvOsj0/dLiVUtHOY0shn1ZeRgMfAYMObGd6hwY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m8OLot8JfA1FAoYSQ0o3EYItYKYoXaG+cq/brB/mJqbA9Ny5lcFAX01kepMYHlgIV
         1FlF5pnfxVxv6k6jAJzGLPx5RC2iTz9/GeardVhBaDWtvOTiZfDBJsw3363xpqSTux
         /fPgBdGzchlZKPdgUIsAwR+Hi1VCnfj+XqEKGTkvtggdrJFe5IitLlCSjPDsVVa0Cq
         eib8zNPG6Hvk5GOuEia9Ug+Od6ZvCwjYFKQZbl+fe/tRzobQ8pkNsQZgMfonSrmHN5
         VUYE3MlzNkZ4emoLeMHt0YtoHVmlupl7OX4Mty/hsE2kvOyI9b4tcy4ykjfvTOVhul
         P2ULArjZvPsMw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mario Limonciello <mario.limonciello@amd.com>,
        Joerie de Gram <j.de.gram@gmail.com>,
        Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, Shyam-sundar.S-k@amd.com,
        linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 08/19] pinctrl: amd: Fix wakeups when IRQ is shared with SCI
Date:   Thu, 25 Nov 2021 21:34:37 -0500
Message-Id: <20211126023448.442529-8-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211126023448.442529-1-sashal@kernel.org>
References: <20211126023448.442529-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 2d54067fcd23aae61e23508425ae5b29e973573d ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-amd.c | 29 ++++++++++++++++++++++++++---
 1 file changed, 26 insertions(+), 3 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-amd.c b/drivers/pinctrl/pinctrl-amd.c
index 4c02439d3776d..a7a2b8620fe8c 100644
--- a/drivers/pinctrl/pinctrl-amd.c
+++ b/drivers/pinctrl/pinctrl-amd.c
@@ -526,14 +526,14 @@ static struct irq_chip amd_gpio_irqchip = {
 
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
 
@@ -555,6 +555,14 @@ static irqreturn_t amd_gpio_irq_handler(int irq, void *dev_id)
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
@@ -580,9 +588,12 @@ static irqreturn_t amd_gpio_irq_handler(int irq, void *dev_id)
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
@@ -594,6 +605,16 @@ static irqreturn_t amd_gpio_irq_handler(int irq, void *dev_id)
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
@@ -934,6 +955,7 @@ static int amd_gpio_probe(struct platform_device *pdev)
 		goto out2;
 
 	platform_set_drvdata(pdev, gpio_dev);
+	acpi_register_wakeup_handler(gpio_dev->irq, amd_gpio_check_wake, gpio_dev);
 
 	dev_dbg(&pdev->dev, "amd gpio driver loaded\n");
 	return ret;
@@ -951,6 +973,7 @@ static int amd_gpio_remove(struct platform_device *pdev)
 	gpio_dev = platform_get_drvdata(pdev);
 
 	gpiochip_remove(&gpio_dev->gc);
+	acpi_unregister_wakeup_handler(amd_gpio_check_wake, gpio_dev);
 
 	return 0;
 }
-- 
2.33.0

