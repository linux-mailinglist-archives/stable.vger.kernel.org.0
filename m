Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65F5A2D9FAD
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 19:57:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2501915AbgLNSzU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 13:55:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:48120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502253AbgLNRhh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Dec 2020 12:37:37 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 005/105] ASoC: Intel: bytcr_rt5640: Fix HP Pavilion x2 Detachable quirks
Date:   Mon, 14 Dec 2020 18:27:39 +0100
Message-Id: <20201214172555.543149862@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201214172555.280929671@linuxfoundation.org>
References: <20201214172555.280929671@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit fbdae7d6d04d2db36c687723920f612e93b2cbda ]

The HP Pavilion x2 Detachable line comes in many variants:

1. Bay Trail SoC + AXP288 PMIC, Micro-USB charging (10-k010nz, ...)
   DMI_SYS_VENDOR: "Hewlett-Packard"
   DMI_PRODUCT_NAME: "HP Pavilion x2 Detachable PC 10"
   DMI_BOARD_NAME: "8021"

2. Bay Trail SoC + AXP288 PMIC, Type-C charging (10-n000nd, 10-n010nl, ...)
   DMI_SYS_VENDOR: "Hewlett-Packard"
   DMI_PRODUCT_NAME: "HP Pavilion x2 Detachable"
   DMI_BOARD_NAME: "815D"

3. Cherry Trail SoC + AXP288 PMIC, Type-C charging (10-n101ng, ...)
   DMI_SYS_VENDOR: "HP"
   DMI_PRODUCT_NAME: "HP Pavilion x2 Detachable"
   DMI_BOARD_NAME: "813E"

4. Cherry Trail SoC + TI PMIC, Type-C charging (10-p002nd, 10-p018wm, ...)
   DMI_SYS_VENDOR: "HP"
   DMI_PRODUCT_NAME: "HP x2 Detachable 10-p0XX"
   DMI_BOARD_NAME: "827C"

5. Cherry Trail SoC + TI PMIC, Type-C charging (x2-210-g2, ...)
   DMI_SYS_VENDOR: "HP"
   DMI_PRODUCT_NAME: "HP x2 210 G2"
   DMI_BOARD_NAME: "82F4"

Variant 1 needs the exact same quirk as variant 2, so relax the DMI check
for the existing quirk a bit so that it matches both variant 1 and 2
(note the other variants will still not match).

Variant 2 already has an existing quirk (which now also matches variant 1)

Variant 3 uses a cx2072x codec, so is not applicable here.

Variant 4 almost works with the defaults, but it also needs a quirk to
fix jack-detection, add a new quirk for this.

Variant 5 does use a RT5640 codec (based on old dmesg output), but was
otherwise not tested, keep using the defaults for this variant.

Fixes: ec8e8418ff7d ("ASoC: Intel: bytcr_rt5640: Add quirks for various devices")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20201118121515.11441-1-hdegoede@redhat.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/bytcr_rt5640.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/sound/soc/intel/boards/bytcr_rt5640.c b/sound/soc/intel/boards/bytcr_rt5640.c
index fc202747ba837..b956e1675132a 100644
--- a/sound/soc/intel/boards/bytcr_rt5640.c
+++ b/sound/soc/intel/boards/bytcr_rt5640.c
@@ -521,10 +521,10 @@ static const struct dmi_system_id byt_rt5640_quirk_table[] = {
 		.driver_data = (void *)(BYT_RT5640_IN1_MAP |
 					BYT_RT5640_MCLK_EN),
 	},
-	{	/* HP Pavilion x2 10-n000nd */
+	{	/* HP Pavilion x2 10-k0XX, 10-n0XX */
 		.matches = {
-			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
-			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "HP Pavilion x2 Detachable"),
+			DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "HP Pavilion x2 Detachable"),
 		},
 		.driver_data = (void *)(BYT_RT5640_DMIC1_MAP |
 					BYT_RT5640_JD_SRC_JD2_IN4N |
@@ -533,6 +533,17 @@ static const struct dmi_system_id byt_rt5640_quirk_table[] = {
 					BYT_RT5640_SSP0_AIF1 |
 					BYT_RT5640_MCLK_EN),
 	},
+	{	/* HP Pavilion x2 10-p0XX */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "HP x2 Detachable 10-p0XX"),
+		},
+		.driver_data = (void *)(BYT_RT5640_DMIC1_MAP |
+					BYT_RT5640_JD_SRC_JD1_IN4P |
+					BYT_RT5640_OVCD_TH_1500UA |
+					BYT_RT5640_OVCD_SF_0P75 |
+					BYT_RT5640_MCLK_EN),
+	},
 	{	/* HP Stream 7 */
 		.matches = {
 			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
-- 
2.27.0



