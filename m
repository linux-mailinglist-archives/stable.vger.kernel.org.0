Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 292882D668D
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 20:33:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393423AbgLJTd0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 14:33:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:37582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729515AbgLJO3o (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 09:29:44 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 19/45] pinctrl: baytrail: Fix pin being driven low for a while on gpiod_get(..., GPIOD_OUT_HIGH)
Date:   Thu, 10 Dec 2020 15:26:33 +0100
Message-Id: <20201210142603.314470392@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201210142602.361598591@linuxfoundation.org>
References: <20201210142602.361598591@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit 156abe2961601d60a8c2a60c6dc8dd6ce7adcdaf upstream

The pins on the Bay Trail SoC have separate input-buffer and output-buffer
enable bits and a read of the level bit of the value register will always
return the value from the input-buffer.

The BIOS of a device may configure a pin in output-only mode, only enabling
the output buffer, and write 1 to the level bit to drive the pin high.
This 1 written to the level bit will be stored inside the data-latch of the
output buffer.

But a subsequent read of the value register will return 0 for the level bit
because the input-buffer is disabled. This causes a read-modify-write as
done by byt_gpio_set_direction() to write 0 to the level bit, driving the
pin low!

Before this commit byt_gpio_direction_output() relied on
pinctrl_gpio_direction_output() to set the direction, followed by a call
to byt_gpio_set() to apply the selected value. This causes the pin to
go low between the pinctrl_gpio_direction_output() and byt_gpio_set()
calls.

Change byt_gpio_direction_output() to directly make the register
modifications itself instead. Replacing the 2 subsequent writes to the
value register with a single write.

Note that the pinctrl code does not keep track internally of the direction,
so not going through pinctrl_gpio_direction_output() is not an issue.

This issue was noticed on a Trekstor SurfTab Twin 10.1. When the panel is
already on at boot (no external monitor connected), then the i915 driver
does a gpiod_get(..., GPIOD_OUT_HIGH) for the panel-enable GPIO. The
temporarily going low of that GPIO was causing the panel to reset itself
after which it would not show an image until it was turned off and back on
again (until a full modeset was done on it). This commit fixes this.

This commit also updates the byt_gpio_direction_input() to use direct
register accesses instead of going through pinctrl_gpio_direction_input(),
to keep it consistent with byt_gpio_direction_output().

Note for backporting, this commit depends on:
commit e2b74419e5cc ("pinctrl: baytrail: Replace WARN with dev_info_once
when setting direct-irq pin to output")

Cc: stable@vger.kernel.org
Fixes: 86e3ef812fe3 ("pinctrl: baytrail: Update gpio chip operations")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
[sudip: use byt_gpio and vg->pdev->dev for dev_info()]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/intel/pinctrl-baytrail.c | 67 +++++++++++++++++++-----
 1 file changed, 53 insertions(+), 14 deletions(-)

diff --git a/drivers/pinctrl/intel/pinctrl-baytrail.c b/drivers/pinctrl/intel/pinctrl-baytrail.c
index 23b3b3d541675..fc51922839f82 100644
--- a/drivers/pinctrl/intel/pinctrl-baytrail.c
+++ b/drivers/pinctrl/intel/pinctrl-baytrail.c
@@ -1017,6 +1017,21 @@ static void byt_gpio_disable_free(struct pinctrl_dev *pctl_dev,
 	pm_runtime_put(&vg->pdev->dev);
 }
 
+static void byt_gpio_direct_irq_check(struct byt_gpio *vg,
+				      unsigned int offset)
+{
+	void __iomem *conf_reg = byt_gpio_reg(vg, offset, BYT_CONF0_REG);
+
+	/*
+	 * Before making any direction modifications, do a check if gpio is set
+	 * for direct IRQ. On Bay Trail, setting GPIO to output does not make
+	 * sense, so let's at least inform the caller before they shoot
+	 * themselves in the foot.
+	 */
+	if (readl(conf_reg) & BYT_DIRECT_IRQ_EN)
+		dev_info_once(&vg->pdev->dev, "Potential Error: Setting GPIO with direct_irq_en to output");
+}
+
 static int byt_gpio_set_direction(struct pinctrl_dev *pctl_dev,
 				  struct pinctrl_gpio_range *range,
 				  unsigned int offset,
@@ -1024,7 +1039,6 @@ static int byt_gpio_set_direction(struct pinctrl_dev *pctl_dev,
 {
 	struct byt_gpio *vg = pinctrl_dev_get_drvdata(pctl_dev);
 	void __iomem *val_reg = byt_gpio_reg(vg, offset, BYT_VAL_REG);
-	void __iomem *conf_reg = byt_gpio_reg(vg, offset, BYT_CONF0_REG);
 	unsigned long flags;
 	u32 value;
 
@@ -1034,14 +1048,8 @@ static int byt_gpio_set_direction(struct pinctrl_dev *pctl_dev,
 	value &= ~BYT_DIR_MASK;
 	if (input)
 		value |= BYT_OUTPUT_EN;
-	else if (readl(conf_reg) & BYT_DIRECT_IRQ_EN)
-		/*
-		 * Before making any direction modifications, do a check if gpio
-		 * is set for direct IRQ.  On baytrail, setting GPIO to output
-		 * does not make sense, so let's at least inform the caller before
-		 * they shoot themselves in the foot.
-		 */
-		dev_info_once(vg->dev, "Potential Error: Setting GPIO with direct_irq_en to output");
+	else
+		byt_gpio_direct_irq_check(vg, offset);
 
 	writel(value, val_reg);
 
@@ -1382,19 +1390,50 @@ static int byt_gpio_get_direction(struct gpio_chip *chip, unsigned int offset)
 
 static int byt_gpio_direction_input(struct gpio_chip *chip, unsigned int offset)
 {
-	return pinctrl_gpio_direction_input(chip->base + offset);
+	struct byt_gpio *vg = gpiochip_get_data(chip);
+	void __iomem *val_reg = byt_gpio_reg(vg, offset, BYT_VAL_REG);
+	unsigned long flags;
+	u32 reg;
+
+	raw_spin_lock_irqsave(&byt_lock, flags);
+
+	reg = readl(val_reg);
+	reg &= ~BYT_DIR_MASK;
+	reg |= BYT_OUTPUT_EN;
+	writel(reg, val_reg);
+
+	raw_spin_unlock_irqrestore(&byt_lock, flags);
+	return 0;
 }
 
+/*
+ * Note despite the temptation this MUST NOT be converted into a call to
+ * pinctrl_gpio_direction_output() + byt_gpio_set() that does not work this
+ * MUST be done as a single BYT_VAL_REG register write.
+ * See the commit message of the commit adding this comment for details.
+ */
 static int byt_gpio_direction_output(struct gpio_chip *chip,
 				     unsigned int offset, int value)
 {
-	int ret = pinctrl_gpio_direction_output(chip->base + offset);
+	struct byt_gpio *vg = gpiochip_get_data(chip);
+	void __iomem *val_reg = byt_gpio_reg(vg, offset, BYT_VAL_REG);
+	unsigned long flags;
+	u32 reg;
 
-	if (ret)
-		return ret;
+	raw_spin_lock_irqsave(&byt_lock, flags);
 
-	byt_gpio_set(chip, offset, value);
+	byt_gpio_direct_irq_check(vg, offset);
 
+	reg = readl(val_reg);
+	reg &= ~BYT_DIR_MASK;
+	if (value)
+		reg |= BYT_LEVEL;
+	else
+		reg &= ~BYT_LEVEL;
+
+	writel(reg, val_reg);
+
+	raw_spin_unlock_irqrestore(&byt_lock, flags);
 	return 0;
 }
 
-- 
2.27.0



