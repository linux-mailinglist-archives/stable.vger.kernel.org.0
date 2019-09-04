Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBAC1A8C56
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:29:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732234AbfIDQMi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 12:12:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:34872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732561AbfIDQAK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 12:00:10 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 67C4C22CED;
        Wed,  4 Sep 2019 16:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567612809;
        bh=hepvH7SjapywPDPI2SBLLPFx6wumdhL0IWMJt9o1E0U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iLDTEoiBZmO063BT88eZuIuNGxr/Zu3Vuup4zAUOplNZLRwvLnwfAtDLdbG410iOq
         9X6HaWO/id/QRWqoCEPK3WA5qdBvnONHvja1O6I9r1g/8S0S85W+aXKQq4WbuaX4Na
         lwsS4yyqwT76FYI/RuB14HkiWipWp6L/2/CzNhd8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Faiz Abbas <faiz_abbas@ti.com>, Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 03/52] ARM: dts: am57xx: Disable voltage switching for SD card
Date:   Wed,  4 Sep 2019 11:59:15 -0400
Message-Id: <20190904160004.3671-3-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190904160004.3671-1-sashal@kernel.org>
References: <20190904160004.3671-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Faiz Abbas <faiz_abbas@ti.com>

[ Upstream commit fb59ee37cfe20d10d19568899d1458a58361246c ]

If UHS speed modes are enabled, a compatible SD card switches down to
1.8V during enumeration. If after this a software reboot/crash takes
place and on-chip ROM tries to enumerate the SD card, the difference in
IO voltages (host @ 3.3V and card @ 1.8V) may end up damaging the card.

The fix for this is to have support for power cycling the card in
hardware (with a PORz/soft-reset line causing a power cycle of the
card). Because the beaglebone X15 (rev A,B and C), am57xx-idks and
am57xx-evms don't have this capability, disable voltage switching for
these boards.

The major effect of this is that the maximum supported speed
mode is now high speed(50 MHz) down from SDR104(200 MHz).

commit 88a748419b84 ("ARM: dts: am57xx-idk: Remove support for voltage
switching for SD card") did this only for idk boards. Do it for all
affected boards.

Signed-off-by: Faiz Abbas <faiz_abbas@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/am571x-idk.dts                | 7 +------
 arch/arm/boot/dts/am572x-idk.dts                | 7 +------
 arch/arm/boot/dts/am574x-idk.dts                | 7 +------
 arch/arm/boot/dts/am57xx-beagle-x15-common.dtsi | 1 +
 arch/arm/boot/dts/am57xx-beagle-x15-revb1.dts   | 7 +------
 arch/arm/boot/dts/am57xx-beagle-x15-revc.dts    | 7 +------
 6 files changed, 6 insertions(+), 30 deletions(-)

diff --git a/arch/arm/boot/dts/am571x-idk.dts b/arch/arm/boot/dts/am571x-idk.dts
index d9a2049a1ea8a..6bebedfc0f35a 100644
--- a/arch/arm/boot/dts/am571x-idk.dts
+++ b/arch/arm/boot/dts/am571x-idk.dts
@@ -98,14 +98,9 @@
 };
 
 &mmc1 {
-	pinctrl-names = "default", "hs", "sdr12", "sdr25", "sdr50", "ddr50", "sdr104";
+	pinctrl-names = "default", "hs";
 	pinctrl-0 = <&mmc1_pins_default_no_clk_pu>;
 	pinctrl-1 = <&mmc1_pins_hs>;
-	pinctrl-2 = <&mmc1_pins_sdr12>;
-	pinctrl-3 = <&mmc1_pins_sdr25>;
-	pinctrl-4 = <&mmc1_pins_sdr50>;
-	pinctrl-5 = <&mmc1_pins_ddr50_rev20 &mmc1_iodelay_ddr50_conf>;
-	pinctrl-6 = <&mmc1_pins_sdr104 &mmc1_iodelay_sdr104_rev20_conf>;
 };
 
 &mmc2 {
diff --git a/arch/arm/boot/dts/am572x-idk.dts b/arch/arm/boot/dts/am572x-idk.dts
index 3ef9111d0e8ba..9235173edbd3a 100644
--- a/arch/arm/boot/dts/am572x-idk.dts
+++ b/arch/arm/boot/dts/am572x-idk.dts
@@ -20,14 +20,9 @@
 };
 
 &mmc1 {
-	pinctrl-names = "default", "hs", "sdr12", "sdr25", "sdr50", "ddr50", "sdr104";
+	pinctrl-names = "default", "hs";
 	pinctrl-0 = <&mmc1_pins_default_no_clk_pu>;
 	pinctrl-1 = <&mmc1_pins_hs>;
-	pinctrl-2 = <&mmc1_pins_sdr12>;
-	pinctrl-3 = <&mmc1_pins_sdr25>;
-	pinctrl-4 = <&mmc1_pins_sdr50>;
-	pinctrl-5 = <&mmc1_pins_ddr50 &mmc1_iodelay_ddr_rev20_conf>;
-	pinctrl-6 = <&mmc1_pins_sdr104 &mmc1_iodelay_sdr104_rev20_conf>;
 };
 
 &mmc2 {
diff --git a/arch/arm/boot/dts/am574x-idk.dts b/arch/arm/boot/dts/am574x-idk.dts
index 378dfa780ac17..ae43de3297f4f 100644
--- a/arch/arm/boot/dts/am574x-idk.dts
+++ b/arch/arm/boot/dts/am574x-idk.dts
@@ -24,14 +24,9 @@
 };
 
 &mmc1 {
-	pinctrl-names = "default", "hs", "sdr12", "sdr25", "sdr50", "ddr50", "sdr104";
+	pinctrl-names = "default", "hs";
 	pinctrl-0 = <&mmc1_pins_default_no_clk_pu>;
 	pinctrl-1 = <&mmc1_pins_hs>;
-	pinctrl-2 = <&mmc1_pins_default>;
-	pinctrl-3 = <&mmc1_pins_hs>;
-	pinctrl-4 = <&mmc1_pins_sdr50>;
-	pinctrl-5 = <&mmc1_pins_ddr50 &mmc1_iodelay_ddr_conf>;
-	pinctrl-6 = <&mmc1_pins_ddr50 &mmc1_iodelay_sdr104_conf>;
 };
 
 &mmc2 {
diff --git a/arch/arm/boot/dts/am57xx-beagle-x15-common.dtsi b/arch/arm/boot/dts/am57xx-beagle-x15-common.dtsi
index ad953113cefbd..d53532b479475 100644
--- a/arch/arm/boot/dts/am57xx-beagle-x15-common.dtsi
+++ b/arch/arm/boot/dts/am57xx-beagle-x15-common.dtsi
@@ -433,6 +433,7 @@
 
 	bus-width = <4>;
 	cd-gpios = <&gpio6 27 GPIO_ACTIVE_LOW>; /* gpio 219 */
+	no-1-8-v;
 };
 
 &mmc2 {
diff --git a/arch/arm/boot/dts/am57xx-beagle-x15-revb1.dts b/arch/arm/boot/dts/am57xx-beagle-x15-revb1.dts
index 5a77b334923d0..34c69965821bb 100644
--- a/arch/arm/boot/dts/am57xx-beagle-x15-revb1.dts
+++ b/arch/arm/boot/dts/am57xx-beagle-x15-revb1.dts
@@ -19,14 +19,9 @@
 };
 
 &mmc1 {
-	pinctrl-names = "default", "hs", "sdr12", "sdr25", "sdr50", "ddr50", "sdr104";
+	pinctrl-names = "default", "hs";
 	pinctrl-0 = <&mmc1_pins_default>;
 	pinctrl-1 = <&mmc1_pins_hs>;
-	pinctrl-2 = <&mmc1_pins_sdr12>;
-	pinctrl-3 = <&mmc1_pins_sdr25>;
-	pinctrl-4 = <&mmc1_pins_sdr50>;
-	pinctrl-5 = <&mmc1_pins_ddr50 &mmc1_iodelay_ddr_rev11_conf>;
-	pinctrl-6 = <&mmc1_pins_sdr104 &mmc1_iodelay_sdr104_rev11_conf>;
 	vmmc-supply = <&vdd_3v3>;
 	vqmmc-supply = <&ldo1_reg>;
 };
diff --git a/arch/arm/boot/dts/am57xx-beagle-x15-revc.dts b/arch/arm/boot/dts/am57xx-beagle-x15-revc.dts
index 17c41da3b55f1..ccd99160bbdfb 100644
--- a/arch/arm/boot/dts/am57xx-beagle-x15-revc.dts
+++ b/arch/arm/boot/dts/am57xx-beagle-x15-revc.dts
@@ -19,14 +19,9 @@
 };
 
 &mmc1 {
-	pinctrl-names = "default", "hs", "sdr12", "sdr25", "sdr50", "ddr50", "sdr104";
+	pinctrl-names = "default", "hs";
 	pinctrl-0 = <&mmc1_pins_default>;
 	pinctrl-1 = <&mmc1_pins_hs>;
-	pinctrl-2 = <&mmc1_pins_sdr12>;
-	pinctrl-3 = <&mmc1_pins_sdr25>;
-	pinctrl-4 = <&mmc1_pins_sdr50>;
-	pinctrl-5 = <&mmc1_pins_ddr50 &mmc1_iodelay_ddr_rev20_conf>;
-	pinctrl-6 = <&mmc1_pins_sdr104 &mmc1_iodelay_sdr104_rev20_conf>;
 	vmmc-supply = <&vdd_3v3>;
 	vqmmc-supply = <&ldo1_reg>;
 };
-- 
2.20.1

