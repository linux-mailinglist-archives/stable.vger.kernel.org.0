Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F1AD408F01
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:39:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240489AbhIMNir (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:38:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:33598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242319AbhIMNgo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:36:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E1290610A2;
        Mon, 13 Sep 2021 13:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539674;
        bh=dlJgEU/LiiujlEtdU6+nPOiWO91vFY5sWsb4L+sqyGc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kwXkCuYcS++4CqNuoobZeNcmV84y3G7mQ3SBiCZTYuPWRUhyEVeNimh5GRV5k0xrX
         m+5P52TBrMeyplS+31SvIWKs9DDcPnKqow9HzziVCY43R4BOcs3nqC9dhEjA/Ot/mg
         fL8sPi+R4dwhyWp0xkrfkBFcws6ljB/Vf4nK5dxI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 116/236] arm64: dts: renesas: rzg2: Convert EtherAVB to explicit delay handling
Date:   Mon, 13 Sep 2021 15:13:41 +0200
Message-Id: <20210913131104.303721006@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131100.316353015@linuxfoundation.org>
References: <20210913131100.316353015@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit a5200e63af57d05ed8bf0ffd9a6ffefc40e01e89 ]

Some EtherAVB variants support internal clock delay configuration, which
can add larger delays than the delays that are typically supported by
the PHY (using an "rgmii-*id" PHY mode, and/or "[rt]xc-skew-ps"
properties).

Historically, the EtherAVB driver configured these delays based on the
"rgmii-*id" PHY mode.  This was wrong, as these are meant solely for the
PHY, not for the MAC.  Hence properties were introduced for explicit
configuration of these delays.

Convert the RZ/G2 DTS files from the old to the new scheme:
  - Add default "rx-internal-delay-ps" and "tx-internal-delay-ps"
    properties to the SoC .dtsi files, to be overridden by board files
    where needed,
  - Convert board files from "rgmii-*id" PHY modes to "rgmii", adding
    the appropriate "rx-internal-delay-ps" and/or "tx-internal-delay-ps"
    overrides.

Notes:
  - RZ/G2E does not support TX internal delay handling.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/20200819134344.27813-8-geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/beacon-renesom-som.dtsi | 3 ++-
 arch/arm64/boot/dts/renesas/hihope-rzg2-ex.dtsi     | 2 +-
 arch/arm64/boot/dts/renesas/r8a774a1.dtsi           | 2 ++
 arch/arm64/boot/dts/renesas/r8a774b1.dtsi           | 2 ++
 arch/arm64/boot/dts/renesas/r8a774c0.dtsi           | 1 +
 arch/arm64/boot/dts/renesas/r8a774e1.dtsi           | 2 ++
 6 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/renesas/beacon-renesom-som.dtsi b/arch/arm64/boot/dts/renesas/beacon-renesom-som.dtsi
index e3773b05c403..3c73dfc430af 100644
--- a/arch/arm64/boot/dts/renesas/beacon-renesom-som.dtsi
+++ b/arch/arm64/boot/dts/renesas/beacon-renesom-som.dtsi
@@ -55,7 +55,8 @@
 	pinctrl-0 = <&avb_pins>;
 	pinctrl-names = "default";
 	phy-handle = <&phy0>;
-	phy-mode = "rgmii-id";
+	rx-internal-delay-ps = <1800>;
+	tx-internal-delay-ps = <2000>;
 	status = "okay";
 
 	phy0: ethernet-phy@0 {
diff --git a/arch/arm64/boot/dts/renesas/hihope-rzg2-ex.dtsi b/arch/arm64/boot/dts/renesas/hihope-rzg2-ex.dtsi
index b9e46aed5336..202c4fc88bd5 100644
--- a/arch/arm64/boot/dts/renesas/hihope-rzg2-ex.dtsi
+++ b/arch/arm64/boot/dts/renesas/hihope-rzg2-ex.dtsi
@@ -19,7 +19,7 @@
 	pinctrl-0 = <&avb_pins>;
 	pinctrl-names = "default";
 	phy-handle = <&phy0>;
-	phy-mode = "rgmii-txid";
+	tx-internal-delay-ps = <2000>;
 	status = "okay";
 
 	phy0: ethernet-phy@0 {
diff --git a/arch/arm64/boot/dts/renesas/r8a774a1.dtsi b/arch/arm64/boot/dts/renesas/r8a774a1.dtsi
index c58a0846db50..a5ebe574fbac 100644
--- a/arch/arm64/boot/dts/renesas/r8a774a1.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a774a1.dtsi
@@ -1131,6 +1131,8 @@
 			power-domains = <&sysc R8A774A1_PD_ALWAYS_ON>;
 			resets = <&cpg 812>;
 			phy-mode = "rgmii";
+			rx-internal-delay-ps = <0>;
+			tx-internal-delay-ps = <0>;
 			iommus = <&ipmmu_ds0 16>;
 			#address-cells = <1>;
 			#size-cells = <0>;
diff --git a/arch/arm64/boot/dts/renesas/r8a774b1.dtsi b/arch/arm64/boot/dts/renesas/r8a774b1.dtsi
index 9ebf6e58ba31..20003a41a706 100644
--- a/arch/arm64/boot/dts/renesas/r8a774b1.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a774b1.dtsi
@@ -1004,6 +1004,8 @@
 			power-domains = <&sysc R8A774B1_PD_ALWAYS_ON>;
 			resets = <&cpg 812>;
 			phy-mode = "rgmii";
+			rx-internal-delay-ps = <0>;
+			tx-internal-delay-ps = <0>;
 			iommus = <&ipmmu_ds0 16>;
 			#address-cells = <1>;
 			#size-cells = <0>;
diff --git a/arch/arm64/boot/dts/renesas/r8a774c0.dtsi b/arch/arm64/boot/dts/renesas/r8a774c0.dtsi
index f27d9b2eb996..e0e54342cd4c 100644
--- a/arch/arm64/boot/dts/renesas/r8a774c0.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a774c0.dtsi
@@ -960,6 +960,7 @@
 			power-domains = <&sysc R8A774C0_PD_ALWAYS_ON>;
 			resets = <&cpg 812>;
 			phy-mode = "rgmii";
+			rx-internal-delay-ps = <0>;
 			iommus = <&ipmmu_ds0 16>;
 			#address-cells = <1>;
 			#size-cells = <0>;
diff --git a/arch/arm64/boot/dts/renesas/r8a774e1.dtsi b/arch/arm64/boot/dts/renesas/r8a774e1.dtsi
index 708258696b4f..2e6c12a46daf 100644
--- a/arch/arm64/boot/dts/renesas/r8a774e1.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a774e1.dtsi
@@ -1233,6 +1233,8 @@
 			power-domains = <&sysc R8A774E1_PD_ALWAYS_ON>;
 			resets = <&cpg 812>;
 			phy-mode = "rgmii";
+			rx-internal-delay-ps = <0>;
+			tx-internal-delay-ps = <0>;
 			iommus = <&ipmmu_ds0 16>;
 			#address-cells = <1>;
 			#size-cells = <0>;
-- 
2.30.2



