Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D489A41234C
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:21:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351607AbhITSXF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:23:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:43458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1377334AbhITSU6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:20:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6B79C61A83;
        Mon, 20 Sep 2021 17:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158636;
        bh=xqUCy2wEVPZvUXtjmkGDblgtfrUTuZshliEXW4STmvY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mMUCHfVtglwpmPoylLv22RrBjAIey/+XuWCSpxv93D2XCU0ZmJFeecHsFI4+S0wx2
         MCv94Oq3tVsTlXrZM+uzKLNSa+PjimveBG2qtmExx6SpC2G7KlWdF8wfkLCE0qFUBi
         3mYKlcnrlnYq/w/r/ZblXvD4eFCEej1tiOpqSu3E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Chen-Yu Tsai <wens@csie.org>, Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>, Clamshell <clamfly@163.com>
Subject: [PATCH 5.4 247/260] mfd: axp20x: Update AXP288 volatile ranges
Date:   Mon, 20 Sep 2021 18:44:25 +0200
Message-Id: <20210920163939.510042268@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163931.123590023@linuxfoundation.org>
References: <20210920163931.123590023@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit f949a9ebce7a18005266b859a17f10c891bb13d7 ]

On Cherry Trail devices with an AXP288 PMIC the external SD-card slot
used the AXP's DLDO2 as card-voltage and either DLDO3 or GPIO1LDO
(GPIO1 pin in low noise LDO mode) as signal-voltage.

These regulators are turned on/off and in case of the signal-voltage
also have their output-voltage changed by the _PS0 and _PS3 power-
management ACPI methods on the MMC-controllers ACPI fwnode as well as
by the _DSM ACPI method for changing the signal voltage.

The AML code implementing these methods is directly accessing the
PMIC through ACPI I2C OpRegion accesses, instead of using the special
PMIC OpRegion handled by drivers/acpi/pmic/intel_pmic_xpower.c .

This means that the contents of the involved PMIC registers can change
without the change being made through the regmap interface, so regmap
should not cache the contents of these registers.

Mark the regulator power on/off, the regulator voltage control and the
GPIO1 control registers as volatile, to avoid regmap caching them.

Specifically this fixes an issue on some models where the i915 driver
toggles another LDO using the same on/off register on/off through
MIPI sequences (through intel_soc_pmic_exec_mipi_pmic_seq_element())
which then writes back a cached on/off register-value where the
card-voltage is off causing the external sdcard slot to stop working
when the screen goes blank, or comes back on again.

The regulator register-range now marked volatile also includes the
buck regulator control registers. This is done on purpose these are
normally not touched by the AML code, but they are updated directly
by the SoC's PUNIT which means that they may also change without going
through regmap.

Note the AXP288 PMIC is only used on Bay- and Cherry-Trail platforms,
so even though this is an ACPI specific problem there is no need to
make the new volatile ranges conditional since these platforms always
use ACPI.

Fixes: dc91c3b6fe66 ("mfd: axp20x: Mark AXP20X_VBUS_IPSOUT_MGMT as volatile")
Fixes: cd53216625a0 ("mfd: axp20x: Fix axp288 volatile ranges")
Reported-and-tested-by: Clamshell <clamfly@163.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/axp20x.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/axp20x.c b/drivers/mfd/axp20x.c
index aa59496e4376..9db1000944c3 100644
--- a/drivers/mfd/axp20x.c
+++ b/drivers/mfd/axp20x.c
@@ -125,12 +125,13 @@ static const struct regmap_range axp288_writeable_ranges[] = {
 
 static const struct regmap_range axp288_volatile_ranges[] = {
 	regmap_reg_range(AXP20X_PWR_INPUT_STATUS, AXP288_POWER_REASON),
+	regmap_reg_range(AXP22X_PWR_OUT_CTRL1, AXP22X_ALDO3_V_OUT),
 	regmap_reg_range(AXP288_BC_GLOBAL, AXP288_BC_GLOBAL),
 	regmap_reg_range(AXP288_BC_DET_STAT, AXP20X_VBUS_IPSOUT_MGMT),
 	regmap_reg_range(AXP20X_CHRG_BAK_CTRL, AXP20X_CHRG_BAK_CTRL),
 	regmap_reg_range(AXP20X_IRQ1_EN, AXP20X_IPSOUT_V_HIGH_L),
 	regmap_reg_range(AXP20X_TIMER_CTRL, AXP20X_TIMER_CTRL),
-	regmap_reg_range(AXP22X_GPIO_STATE, AXP22X_GPIO_STATE),
+	regmap_reg_range(AXP20X_GPIO1_CTRL, AXP22X_GPIO_STATE),
 	regmap_reg_range(AXP288_RT_BATT_V_H, AXP288_RT_BATT_V_L),
 	regmap_reg_range(AXP20X_FG_RES, AXP288_FG_CC_CAP_REG),
 };
-- 
2.30.2



