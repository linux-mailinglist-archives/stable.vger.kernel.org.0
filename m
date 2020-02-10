Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5532A1577F1
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:04:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729675AbgBJMkP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:40:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:39876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729670AbgBJMkP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:40:15 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 968A92051A;
        Mon, 10 Feb 2020 12:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338414;
        bh=MMy5b1V1IL5uHCq9NfdoFe3WHzgaxpAqJCJ80qPZUTM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wk/scjW6gbEt2lt6DqydYlGn1OspQ1UlWhhecWqQOfqEU9sP7nXpHjN2/esyyK4Ge
         JXxr1xOzMYCjHdWNOsJHCl9fIyYACt0XTvQQTEn0l20eAZ1TQo/JWrL5oDw/hNxvR5
         3Nu79DfhXae98LBP/vVCXw7AsE419crgnsMLrbGE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Samuel Holland <samuel@sholland.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 5.5 128/367] power: supply: axp20x_ac_power: Fix reporting online status
Date:   Mon, 10 Feb 2020 04:30:41 -0800
Message-Id: <20200210122436.676761953@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Samuel Holland <samuel@sholland.org>

commit 1c51aad8475d670ad58ae60adc9d32342381df8d upstream.

AXP803/AXP813 have a flag that enables/disables the AC power supply
input. This flag does not affect the status bits in PWR_INPUT_STATUS.
Its effect can be verified by checking the battery charge/discharge
state (bit 2 of PWR_INPUT_STATUS), or by examining the current draw on
the AC input.

Take this flag into account when getting the ONLINE property of the AC
input, on PMICs where this flag is present.

Fixes: 7693b5643fd2 ("power: supply: add AC power supply driver for AXP813")
Cc: stable@vger.kernel.org
Signed-off-by: Samuel Holland <samuel@sholland.org>
Reviewed-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/power/supply/axp20x_ac_power.c |   31 +++++++++++++++++++++++++------
 1 file changed, 25 insertions(+), 6 deletions(-)

--- a/drivers/power/supply/axp20x_ac_power.c
+++ b/drivers/power/supply/axp20x_ac_power.c
@@ -23,6 +23,8 @@
 #define AXP20X_PWR_STATUS_ACIN_PRESENT	BIT(7)
 #define AXP20X_PWR_STATUS_ACIN_AVAIL	BIT(6)
 
+#define AXP813_ACIN_PATH_SEL		BIT(7)
+
 #define AXP813_VHOLD_MASK		GENMASK(5, 3)
 #define AXP813_VHOLD_UV_TO_BIT(x)	((((x) / 100000) - 40) << 3)
 #define AXP813_VHOLD_REG_TO_UV(x)	\
@@ -40,6 +42,7 @@ struct axp20x_ac_power {
 	struct power_supply *supply;
 	struct iio_channel *acin_v;
 	struct iio_channel *acin_i;
+	bool has_acin_path_sel;
 };
 
 static irqreturn_t axp20x_ac_power_irq(int irq, void *devid)
@@ -86,6 +89,17 @@ static int axp20x_ac_power_get_property(
 			return ret;
 
 		val->intval = !!(reg & AXP20X_PWR_STATUS_ACIN_AVAIL);
+
+		/* ACIN_PATH_SEL disables ACIN even if ACIN_AVAIL is set. */
+		if (val->intval && power->has_acin_path_sel) {
+			ret = regmap_read(power->regmap, AXP813_ACIN_PATH_CTRL,
+					  &reg);
+			if (ret)
+				return ret;
+
+			val->intval = !!(reg & AXP813_ACIN_PATH_SEL);
+		}
+
 		return 0;
 
 	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
@@ -224,21 +238,25 @@ static const struct power_supply_desc ax
 struct axp_data {
 	const struct power_supply_desc	*power_desc;
 	bool				acin_adc;
+	bool				acin_path_sel;
 };
 
 static const struct axp_data axp20x_data = {
-	.power_desc = &axp20x_ac_power_desc,
-	.acin_adc = true,
+	.power_desc	= &axp20x_ac_power_desc,
+	.acin_adc	= true,
+	.acin_path_sel	= false,
 };
 
 static const struct axp_data axp22x_data = {
-	.power_desc = &axp22x_ac_power_desc,
-	.acin_adc = false,
+	.power_desc	= &axp22x_ac_power_desc,
+	.acin_adc	= false,
+	.acin_path_sel	= false,
 };
 
 static const struct axp_data axp813_data = {
-	.power_desc = &axp813_ac_power_desc,
-	.acin_adc = false,
+	.power_desc	= &axp813_ac_power_desc,
+	.acin_adc	= false,
+	.acin_path_sel	= true,
 };
 
 static int axp20x_ac_power_probe(struct platform_device *pdev)
@@ -282,6 +300,7 @@ static int axp20x_ac_power_probe(struct
 	}
 
 	power->regmap = dev_get_regmap(pdev->dev.parent, NULL);
+	power->has_acin_path_sel = axp_data->acin_path_sel;
 
 	platform_set_drvdata(pdev, power);
 


