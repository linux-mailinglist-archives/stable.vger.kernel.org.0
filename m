Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3347A21FB61
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 21:01:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731304AbgGNS7u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 14:59:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:58498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731015AbgGNS7t (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 14:59:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5379D22507;
        Tue, 14 Jul 2020 18:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594753188;
        bh=gGqngXLxZ6te83rmocfV9FRaMKWOoNsT/Vgu4W0NCWY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0vZJSMkAkYjRD8UcWnUy9Rf7y9vmzvS0HgtIHE1PhciGJ0v9oRtdPsy6FAceG4PGm
         zkabfP2dbPLR5j7Hg8pzVdPcw7olfXhzDJnMTDubm7anAGiLgu+BIfpFDQ5s4+2S/n
         9k5n1PHl3kksfwfGapXFqQarGY0sUTEIsw4Tkzpo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 5.7 152/166] pinctrl: baytrail: Fix pin being driven low for a while on gpiod_get(..., GPIOD_OUT_HIGH)
Date:   Tue, 14 Jul 2020 20:45:17 +0200
Message-Id: <20200714184123.106466756@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714184115.844176932@linuxfoundation.org>
References: <20200714184115.844176932@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit 45c11a927606c612e4898a9484867b71318699f6 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pinctrl/intel/pinctrl-baytrail.c |   67 ++++++++++++++++++++++++-------
 1 file changed, 53 insertions(+), 14 deletions(-)

--- a/drivers/pinctrl/intel/pinctrl-baytrail.c
+++ b/drivers/pinctrl/intel/pinctrl-baytrail.c
@@ -800,6 +800,21 @@ static void byt_gpio_disable_free(struct
 	pm_runtime_put(vg->dev);
 }
 
+static void byt_gpio_direct_irq_check(struct intel_pinctrl *vg,
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
+		dev_info_once(vg->dev, "Potential Error: Setting GPIO with direct_irq_en to output");
+}
+
 static int byt_gpio_set_direction(struct pinctrl_dev *pctl_dev,
 				  struct pinctrl_gpio_range *range,
 				  unsigned int offset,
@@ -807,7 +822,6 @@ static int byt_gpio_set_direction(struct
 {
 	struct intel_pinctrl *vg = pinctrl_dev_get_drvdata(pctl_dev);
 	void __iomem *val_reg = byt_gpio_reg(vg, offset, BYT_VAL_REG);
-	void __iomem *conf_reg = byt_gpio_reg(vg, offset, BYT_CONF0_REG);
 	unsigned long flags;
 	u32 value;
 
@@ -817,14 +831,8 @@ static int byt_gpio_set_direction(struct
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
 
@@ -1165,19 +1173,50 @@ static int byt_gpio_get_direction(struct
 
 static int byt_gpio_direction_input(struct gpio_chip *chip, unsigned int offset)
 {
-	return pinctrl_gpio_direction_input(chip->base + offset);
+	struct intel_pinctrl *vg = gpiochip_get_data(chip);
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
+	struct intel_pinctrl *vg = gpiochip_get_data(chip);
+	void __iomem *val_reg = byt_gpio_reg(vg, offset, BYT_VAL_REG);
+	unsigned long flags;
+	u32 reg;
 
-	if (ret)
-		return ret;
+	raw_spin_lock_irqsave(&byt_lock, flags);
+
+	byt_gpio_direct_irq_check(vg, offset);
+
+	reg = readl(val_reg);
+	reg &= ~BYT_DIR_MASK;
+	if (value)
+		reg |= BYT_LEVEL;
+	else
+		reg &= ~BYT_LEVEL;
 
-	byt_gpio_set(chip, offset, value);
+	writel(reg, val_reg);
 
+	raw_spin_unlock_irqrestore(&byt_lock, flags);
 	return 0;
 }
 


