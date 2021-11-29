Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB17F461E12
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:29:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235998AbhK2ScH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:32:07 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:34822 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379059AbhK2SaG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:30:06 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 19054B815F8;
        Mon, 29 Nov 2021 18:26:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D8A1C53FCD;
        Mon, 29 Nov 2021 18:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210405;
        bh=8+B12Z2kLtdYTzTycUhAkA/ExSUrQLkZ5YM/3khJ8uw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R9u8nlK1N44/jsGFUUji2uR2zRoqPeDP9VnTjUTXMt50BMKWV/1f23kvMri3Lqt2s
         brxRJbTIhueCBdq+CVQAi2eYRgsfDFQZxedw5iciPyyV62LafBExpHtDufvE+0KICK
         5PCISCi2ZtB75WQX8GZXWGkfoxXLC5PUIFNEwGlM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>,
        Remi Pommarel <repk@triplefau.lt>,
        Tomasz Maciej Nowak <tmn505@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH 5.4 44/92] arm64: dts: marvell: armada-37xx: Set pcie_reset_pin to gpio function
Date:   Mon, 29 Nov 2021 19:18:13 +0100
Message-Id: <20211129181708.900926243@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181707.392764191@linuxfoundation.org>
References: <20211129181707.392764191@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Behún <kabel@kernel.org>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/marvell/armada-3720-db.dts          |    3 +++
 arch/arm64/boot/dts/marvell/armada-3720-espressobin.dts |    1 +
 arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts  |    4 ----
 arch/arm64/boot/dts/marvell/armada-37xx.dtsi            |    2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

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
 
--- a/arch/arm64/boot/dts/marvell/armada-3720-espressobin.dts
+++ b/arch/arm64/boot/dts/marvell/armada-3720-espressobin.dts
@@ -59,6 +59,7 @@
 	phys = <&comphy1 0>;
 	pinctrl-names = "default";
 	pinctrl-0 = <&pcie_reset_pins &pcie_clkreq_pins>;
+	reset-gpios = <&gpiosb 3 GPIO_ACTIVE_LOW>;
 };
 
 /* J6 */
--- a/arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts
+++ b/arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts
@@ -127,10 +127,6 @@
 	};
 };
 
-&pcie_reset_pins {
-	function = "gpio";
-};
-
 &pcie0 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pcie_reset_pins &pcie_clkreq_pins>;
--- a/arch/arm64/boot/dts/marvell/armada-37xx.dtsi
+++ b/arch/arm64/boot/dts/marvell/armada-37xx.dtsi
@@ -318,7 +318,7 @@
 
 				pcie_reset_pins: pcie-reset-pins {
 					groups = "pcie1";
-					function = "pcie";
+					function = "gpio";
 				};
 
 				pcie_clkreq_pins: pcie-clkreq-pins {


