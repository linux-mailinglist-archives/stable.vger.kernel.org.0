Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E21F1F05EF
	for <lists+stable@lfdr.de>; Sat,  6 Jun 2020 11:32:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728650AbgFFJb6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Jun 2020 05:31:58 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:37491 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725283AbgFFJb5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 6 Jun 2020 05:31:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591435915;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=WPYvKtAQCtTVFMEFm9HcgELx9JdP3kWVQkmiIOpQoqI=;
        b=BgpQCxLQJ3h4A7eFILHUYybwxvOVk57zumYg8cUtHbUIDWq3aNE6HvjkBUFrCAMVvmaA3+
        tl02rjDE12oKs5vKTvTjd6Bk8W+PWmwVs6/0YbO3w37c+fPULfIkkd7vNGagydw8Icu7/H
        S/84QSubn1KE3VKRkVZKsu2ZlI6NFzE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-461-Ed4nRy47NWmNGbr_pwUmqQ-1; Sat, 06 Jun 2020 05:31:53 -0400
X-MC-Unique: Ed4nRy47NWmNGbr_pwUmqQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A117C1853562;
        Sat,  6 Jun 2020 09:31:52 +0000 (UTC)
Received: from x1.localdomain.com (ovpn-112-50.ams2.redhat.com [10.36.112.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 586D210013D5;
        Sat,  6 Jun 2020 09:31:51 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     Mika Westerberg <mika.westerberg@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>
Cc:     Hans de Goede <hdegoede@redhat.com>, linux-gpio@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH v2] pinctrl: baytrail: Fix pin being driven low for a while on gpiod_get(..., GPIOD_OUT_HIGH)
Date:   Sat,  6 Jun 2020 11:31:50 +0200
Message-Id: <20200606093150.32882-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
Note the factoring out of the direct IRQ mode warning is deliberately not
split into a separate patch to make backporting this easier.

---
Changes in v2:
- Add fixes tag
- Also change byt_gpio_direction_input() to directly making the change
  itself for consistency
- Add a comment above byt_gpio_direction_output() to avoid someone doing
  a well intended cleanup in the future re-introducing the problem
---
 drivers/pinctrl/intel/pinctrl-baytrail.c | 67 +++++++++++++++++++-----
 1 file changed, 53 insertions(+), 14 deletions(-)

diff --git a/drivers/pinctrl/intel/pinctrl-baytrail.c b/drivers/pinctrl/intel/pinctrl-baytrail.c
index 9b821c9cbd16..b033f9d13fb4 100644
--- a/drivers/pinctrl/intel/pinctrl-baytrail.c
+++ b/drivers/pinctrl/intel/pinctrl-baytrail.c
@@ -800,6 +800,21 @@ static void byt_gpio_disable_free(struct pinctrl_dev *pctl_dev,
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
@@ -807,7 +822,6 @@ static int byt_gpio_set_direction(struct pinctrl_dev *pctl_dev,
 {
 	struct intel_pinctrl *vg = pinctrl_dev_get_drvdata(pctl_dev);
 	void __iomem *val_reg = byt_gpio_reg(vg, offset, BYT_VAL_REG);
-	void __iomem *conf_reg = byt_gpio_reg(vg, offset, BYT_CONF0_REG);
 	unsigned long flags;
 	u32 value;
 
@@ -817,14 +831,8 @@ static int byt_gpio_set_direction(struct pinctrl_dev *pctl_dev,
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
 
@@ -1165,19 +1173,50 @@ static int byt_gpio_get_direction(struct gpio_chip *chip, unsigned int offset)
 
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
 
-	byt_gpio_set(chip, offset, value);
+	reg = readl(val_reg);
+	reg &= ~BYT_DIR_MASK;
+	if (value)
+		reg |= BYT_LEVEL;
+	else
+		reg &= ~BYT_LEVEL;
 
+	writel(reg, val_reg);
+
+	raw_spin_unlock_irqrestore(&byt_lock, flags);
 	return 0;
 }
 
-- 
2.26.2

