Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB7B81B693D
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:21:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729421AbgDWXVg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:21:36 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48520 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728196AbgDWXGc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:32 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvL-0004bF-Eq; Fri, 24 Apr 2020 00:06:27 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvK-00E6jQ-GP; Fri, 24 Apr 2020 00:06:26 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Benjamin Adler" <benadler@gmx.net>,
        "Mika Westerberg" <mika.westerberg@linux.intel.com>,
        "Linus Walleij" <linus.walleij@linaro.org>
Date:   Fri, 24 Apr 2020 00:04:53 +0100
Message-ID: <lsq.1587683028.875034036@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 066/245] pinctrl: baytrail: Relax GPIO request rules
In-Reply-To: <lsq.1587683027.831233700@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.83-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Mika Westerberg <mika.westerberg@linux.intel.com>

commit f8323b6bb2cc7d26941d4838dd4375952980a88a upstream.

Zotac ZBOX PI320, a Baytrail based mini-PC, has power button connected to a
GPIO pin and it is exposed to the operating system as Windows 8 button
array. This is implemented in Linux as a driver using gpio_keys.

However, BIOS on this particula machine forgot to mux the pin to be a GPIO
instead of native function, which results following message to be seen on
the console:

 byt_gpio INT33FC:02: pin 16 cannot be used as GPIO.

This causes power button to not work as the driver was not able to request
the GPIO it needs.

So instead of completely preventing this we allow turning the pin as GPIO
but issue warning that something might be wrong.

Reported-by: Benjamin Adler <benadler@gmx.net>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
[bwh: Backported to 3.16: adjust filename]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/pinctrl/pinctrl-baytrail.c | 35 +++++++++++++++---------
 1 file changed, 22 insertions(+), 13 deletions(-)

--- a/drivers/pinctrl/pinctrl-baytrail.c
+++ b/drivers/pinctrl/pinctrl-baytrail.c
@@ -160,40 +160,49 @@ static void __iomem *byt_gpio_reg(struct
 	return vg->reg_base + reg_offset + reg;
 }
 
-static bool is_special_pin(struct byt_gpio *vg, unsigned offset)
+static u32 byt_get_gpio_mux(struct byt_gpio *vg, unsigned offset)
 {
 	/* SCORE pin 92-93 */
 	if (!strcmp(vg->range->name, BYT_SCORE_ACPI_UID) &&
 		offset >= 92 && offset <= 93)
-		return true;
+		return 1;
 
 	/* SUS pin 11-21 */
 	if (!strcmp(vg->range->name, BYT_SUS_ACPI_UID) &&
 		offset >= 11 && offset <= 21)
-		return true;
+		return 1;
 
-	return false;
+	return 0;
 }
 
 static int byt_gpio_request(struct gpio_chip *chip, unsigned offset)
 {
 	struct byt_gpio *vg = to_byt_gpio(chip);
 	void __iomem *reg = byt_gpio_reg(chip, offset, BYT_CONF0_REG);
-	u32 value;
-	bool special;
+	u32 value, gpio_mux;
 
 	/*
 	 * In most cases, func pin mux 000 means GPIO function.
 	 * But, some pins may have func pin mux 001 represents
-	 * GPIO function. Only allow user to export pin with
-	 * func pin mux preset as GPIO function by BIOS/FW.
+	 * GPIO function.
+	 *
+	 * Because there are devices out there where some pins were not
+	 * configured correctly we allow changing the mux value from
+	 * request (but print out warning about that).
 	 */
 	value = readl(reg) & BYT_PIN_MUX;
-	special = is_special_pin(vg, offset);
-	if ((special && value != 1) || (!special && value)) {
-		dev_err(&vg->pdev->dev,
-			"pin %u cannot be used as GPIO.\n", offset);
-		return -EINVAL;
+	gpio_mux = byt_get_gpio_mux(vg, offset);
+	if (WARN_ON(gpio_mux != value)) {
+		unsigned long flags;
+
+		spin_lock_irqsave(&vg->lock, flags);
+		value = readl(reg) & ~BYT_PIN_MUX;
+		value |= gpio_mux;
+		writel(value, reg);
+		spin_unlock_irqrestore(&vg->lock, flags);
+
+		dev_warn(&vg->pdev->dev,
+			 "pin %u forcibly re-configured as GPIO\n", offset);
 	}
 
 	pm_runtime_get(&vg->pdev->dev);

