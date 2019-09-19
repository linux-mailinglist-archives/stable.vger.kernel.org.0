Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5881AB86E4
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:33:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389394AbfISWMd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:12:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:51474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393636AbfISWMd (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:12:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7777E21929;
        Thu, 19 Sep 2019 22:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568931152;
        bh=hepvH7SjapywPDPI2SBLLPFx6wumdhL0IWMJt9o1E0U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lH5X21L3ZCyjLQIfFvPH5Rl9AKpiAEOehJjj6t1b8pN6LmMfnjWbJ6HwpW1tqa/jv
         y9BGDu9nZcFmWAVZ1qXt3M891674Joyfdj6cwVNuHd8bbCBWxhBpPwc0bKfxsB8xy3
         Z6FEj6XQId+7hDUHFZPg1AXSdbw7Bnk+zkx2qVKc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Faiz Abbas <faiz_abbas@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 21/79] ARM: dts: am57xx: Disable voltage switching for SD card
Date:   Fri, 20 Sep 2019 00:03:06 +0200
Message-Id: <20190919214809.863268663@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919214807.612593061@linuxfoundation.org>
References: <20190919214807.612593061@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



