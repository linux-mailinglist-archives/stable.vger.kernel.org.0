Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B164F45D0D2
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 00:05:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352510AbhKXXIv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 18:08:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:51620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352517AbhKXXIu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 18:08:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F26F56102A;
        Wed, 24 Nov 2021 23:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637795140;
        bh=SkJuSVfYkPUC+RW7f2uVBDppXg+TaIUe/ny8ba9g3CA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M6FntWiQIaZMgiCV8V0m0tvHQMvpBwMZDJvrJB6K1CCfp+joFGdY3sJprOD/+UZjJ
         4Xygk2jltGjtcVgU6gAice6nCMIQOOvG4BAk9KLhaJs+T+wVLtfKaxifizrEwiCfFV
         1B5q7o4uHoXanQDd1gXlTMsRtVR6ZXTjmRsEBjdD5TtepxOKP5Y4SJlTKowAmQwJJC
         m/4p7fIv3sYG08Z+TR8i1ILgGN8hNFNNWB7H+TtGlNSZuXdfoWecEjrd/k7X91AmDe
         urBw99Z7U64sWJamcnbeKgPKet9PLksm8TIChiHXwekSkohtZ9/uuYoqF/QNyblrnL
         t4sXbo/I4kb0A==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     pali@kernel.org, stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>,
        Remi Pommarel <repk@triplefau.lt>,
        Tomasz Maciej Nowak <tmn505@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH 4.19 20/20] arm64: dts: marvell: armada-37xx: Set pcie_reset_pin to gpio function
Date:   Thu, 25 Nov 2021 00:05:00 +0100
Message-Id: <20211124230500.27109-21-kabel@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211124230500.27109-1-kabel@kernel.org>
References: <20211124230500.27109-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Behún <marek.behun@nic.cz>

commit 715878016984b2617f6c1f177c50039e12e7bd5b upstream.

We found out that we are unable to control the PERST# signal via the
default pin dedicated to be PERST# pin (GPIO2[3] pin) on A3700 SOC when
this pin is in EP_PCIE1_Resetn mode. There is a register in the PCIe
register space called PERSTN_GPIO_EN (D0088004[3]), but changing the
value of this register does not change the pin output when measuring
with voltmeter.

We do not know if this is a bug in the SOC, or if it works only when
PCIe controller is in a certain state.

Commit f4c7d053d7f7 ("PCI: aardvark: Wait for endpoint to be ready
before training link") says that when this pin changes pinctrl mode
from EP_PCIE1_Resetn to GPIO, the PERST# signal is asserted for a brief
moment.

So currently the situation is that on A3700 boards the PERST# signal is
asserted in U-Boot (because the code in U-Boot issues reset via this pin
via GPIO mode), and then in Linux by the obscure and undocumented
mechanism described by the above mentioned commit.

We want to issue PERST# signal in a known way, therefore this patch
changes the pcie_reset_pin function from "pcie" to "gpio" and adds the
reset-gpios property to the PCIe node in device tree files of
EspressoBin and Armada 3720 Dev Board (Turris Mox device tree already
has this property and uDPU does not have a PCIe port).

Signed-off-by: Marek Behún <marek.behun@nic.cz>
Cc: Remi Pommarel <repk@triplefau.lt>
Tested-by: Tomasz Maciej Nowak <tmn505@gmail.com>
Acked-by: Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Marek Behún <kabel@kernel.org>
---
 arch/arm64/boot/dts/marvell/armada-3720-db.dts          | 3 +++
 arch/arm64/boot/dts/marvell/armada-3720-espressobin.dts | 3 +++
 arch/arm64/boot/dts/marvell/armada-37xx.dtsi            | 2 +-
 3 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/marvell/armada-3720-db.dts b/arch/arm64/boot/dts/marvell/armada-3720-db.dts
index f2cc00594d64..3e5789f37206 100644
--- a/arch/arm64/boot/dts/marvell/armada-3720-db.dts
+++ b/arch/arm64/boot/dts/marvell/armada-3720-db.dts
@@ -128,6 +128,9 @@
 
 /* CON15(V2.0)/CON17(V1.4) : PCIe / CON15(V2.0)/CON12(V1.4) :mini-PCIe */
 &pcie0 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&pcie_reset_pins &pcie_clkreq_pins>;
+	reset-gpios = <&gpiosb 3 GPIO_ACTIVE_LOW>;
 	status = "okay";
 };
 
diff --git a/arch/arm64/boot/dts/marvell/armada-3720-espressobin.dts b/arch/arm64/boot/dts/marvell/armada-3720-espressobin.dts
index 1a3e6e3b04eb..f36089198243 100644
--- a/arch/arm64/boot/dts/marvell/armada-3720-espressobin.dts
+++ b/arch/arm64/boot/dts/marvell/armada-3720-espressobin.dts
@@ -55,6 +55,9 @@
 
 /* J9 */
 &pcie0 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&pcie_reset_pins &pcie_clkreq_pins>;
+	reset-gpios = <&gpiosb 3 GPIO_ACTIVE_LOW>;
 	status = "okay";
 };
 
diff --git a/arch/arm64/boot/dts/marvell/armada-37xx.dtsi b/arch/arm64/boot/dts/marvell/armada-37xx.dtsi
index 5299a16459f2..7500be1a11a3 100644
--- a/arch/arm64/boot/dts/marvell/armada-37xx.dtsi
+++ b/arch/arm64/boot/dts/marvell/armada-37xx.dtsi
@@ -256,7 +256,7 @@
 
 				pcie_reset_pins: pcie-reset-pins {
 					groups = "pcie1";
-					function = "pcie";
+					function = "gpio";
 				};
 
 				pcie_clkreq_pins: pcie-clkreq-pins {
-- 
2.32.0

