Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73D702065B4
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:51:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388168AbgFWUJm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:09:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:50776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388414AbgFWUJj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:09:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A618F2082F;
        Tue, 23 Jun 2020 20:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592942978;
        bh=PJMtt0xxUTnBcNn8PkOxI4tZwDmP9Cb79RTCVrICKn4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fNAwg/5uu8zV+lbOnmIncu4DMs9AaojutInukb2A3TRO+rMy036v3/WJG9k9LAIwl
         2rDiGxMAqxPmnHADqn/F9fL7H3jSFuZcPFECdLKlD0sXftLIYHKel2tfUInwRLRaPs
         9g9JLekvZJHyGwVP/Cq/NsRdnPg98EZg1LJM9s0w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>,
        Remi Pommarel <repk@triplefau.lt>,
        Tomasz Maciej Nowak <tmn505@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 211/477] arm64: dts: marvell: armada-37xx: Set pcie_reset_pin to gpio function
Date:   Tue, 23 Jun 2020 21:53:28 +0200
Message-Id: <20200623195417.555922682@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Behún <marek.behun@nic.cz>

[ Upstream commit 715878016984b2617f6c1f177c50039e12e7bd5b ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/marvell/armada-3720-db.dts           | 3 +++
 arch/arm64/boot/dts/marvell/armada-3720-espressobin.dtsi | 1 +
 arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts   | 4 ----
 arch/arm64/boot/dts/marvell/armada-37xx.dtsi             | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/boot/dts/marvell/armada-3720-db.dts b/arch/arm64/boot/dts/marvell/armada-3720-db.dts
index f2cc00594d64a..3e5789f372069 100644
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
 
diff --git a/arch/arm64/boot/dts/marvell/armada-3720-espressobin.dtsi b/arch/arm64/boot/dts/marvell/armada-3720-espressobin.dtsi
index 42e992f9c8a54..c92ad664cb0ec 100644
--- a/arch/arm64/boot/dts/marvell/armada-3720-espressobin.dtsi
+++ b/arch/arm64/boot/dts/marvell/armada-3720-espressobin.dtsi
@@ -47,6 +47,7 @@
 	phys = <&comphy1 0>;
 	pinctrl-names = "default";
 	pinctrl-0 = <&pcie_reset_pins &pcie_clkreq_pins>;
+	reset-gpios = <&gpiosb 3 GPIO_ACTIVE_LOW>;
 };
 
 /* J6 */
diff --git a/arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts b/arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts
index 0e0491ca2930d..1452c821f8c09 100644
--- a/arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts
+++ b/arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts
@@ -128,10 +128,6 @@
 	};
 };
 
-&pcie_reset_pins {
-	function = "gpio";
-};
-
 &pcie0 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pcie_reset_pins &pcie_clkreq_pins>;
diff --git a/arch/arm64/boot/dts/marvell/armada-37xx.dtsi b/arch/arm64/boot/dts/marvell/armada-37xx.dtsi
index 000c135e39b73..7909c146eabf7 100644
--- a/arch/arm64/boot/dts/marvell/armada-37xx.dtsi
+++ b/arch/arm64/boot/dts/marvell/armada-37xx.dtsi
@@ -317,7 +317,7 @@
 
 				pcie_reset_pins: pcie-reset-pins {
 					groups = "pcie1";
-					function = "pcie";
+					function = "gpio";
 				};
 
 				pcie_clkreq_pins: pcie-clkreq-pins {
-- 
2.25.1



