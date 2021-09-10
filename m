Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F717406342
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:46:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232681AbhIJArO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:47:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:48836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234435AbhIJAXV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:23:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EEA1A60FDA;
        Fri, 10 Sep 2021 00:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233331;
        bh=Kpa31K3doB6Hq0P1r2apkB11H4gAWQfqCmRUWNcc0AU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UuX2js3QUZX9PIp4BOui0/Wc0uNNETKSKq3pXC+5SLj7RtAkaUC6PdzUdeYDBCGqF
         CKaLK2z39dpKxzvfl4xylqJA1ZeZzrJ4XNKAw7PA05jOrAbRo5Y7X4Y4Ig+dWE2qqd
         Ht7Yntpf7uEPHQlhdFB2K+o1nOR9Yh0zBm8a4KDmHGdGDtyOVvOv+6NIBbC7lpw76a
         ofWN+4sPM3vyPhp3CzXAg6liiPUtzevMn74KCQgzwm8DWCbdCXp0aEYWhs9WDojSJ6
         lB03PKZaAjdLBkxQxeiyxWkvYiXgNso7mdAWl2agEG3hmeDiLL+VIZPf8bQp5iLnu9
         dwXT5bkbPGYtQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>, linux-mips@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 21/37] MIPS: mscc: ocelot: disable all switch ports by default
Date:   Thu,  9 Sep 2021 20:21:26 -0400
Message-Id: <20210910002143.175731-21-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910002143.175731-1-sashal@kernel.org>
References: <20210910002143.175731-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 0181f6f19c6c35b24f1516d8db22f3bbce762633 ]

The ocelot switch driver used to ignore ports which do not have a
phy-handle property and not probe those, but this is not quite ok since
it is valid to not have a phy-handle property if there is a fixed-link.

It seems that checking for a phy-handle was a proxy for the proper check
which is for the status, but that doesn't make a lot of sense, since the
ocelot driver already iterates using for_each_available_child_of_node
which skips the disabled ports, so I have no idea.

Anyway, a widespread pattern in device trees is for a SoC dtsi to
disable by default all hardware, and let board dts files enable what is
used. So let's do that and enable only the ports with a phy-handle in
the pcb120 and pcb123 device tree files.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/boot/dts/mscc/ocelot.dtsi       | 11 +++++++++++
 arch/mips/boot/dts/mscc/ocelot_pcb120.dts |  8 ++++++++
 arch/mips/boot/dts/mscc/ocelot_pcb123.dts |  4 ++++
 3 files changed, 23 insertions(+)

diff --git a/arch/mips/boot/dts/mscc/ocelot.dtsi b/arch/mips/boot/dts/mscc/ocelot.dtsi
index 797d336db54d..87821b4dfa50 100644
--- a/arch/mips/boot/dts/mscc/ocelot.dtsi
+++ b/arch/mips/boot/dts/mscc/ocelot.dtsi
@@ -148,36 +148,47 @@ ethernet-ports {
 
 				port0: port@0 {
 					reg = <0>;
+					status = "disabled";
 				};
 				port1: port@1 {
 					reg = <1>;
+					status = "disabled";
 				};
 				port2: port@2 {
 					reg = <2>;
+					status = "disabled";
 				};
 				port3: port@3 {
 					reg = <3>;
+					status = "disabled";
 				};
 				port4: port@4 {
 					reg = <4>;
+					status = "disabled";
 				};
 				port5: port@5 {
 					reg = <5>;
+					status = "disabled";
 				};
 				port6: port@6 {
 					reg = <6>;
+					status = "disabled";
 				};
 				port7: port@7 {
 					reg = <7>;
+					status = "disabled";
 				};
 				port8: port@8 {
 					reg = <8>;
+					status = "disabled";
 				};
 				port9: port@9 {
 					reg = <9>;
+					status = "disabled";
 				};
 				port10: port@10 {
 					reg = <10>;
+					status = "disabled";
 				};
 			};
 		};
diff --git a/arch/mips/boot/dts/mscc/ocelot_pcb120.dts b/arch/mips/boot/dts/mscc/ocelot_pcb120.dts
index 33991fd209f5..7da9ed2da248 100644
--- a/arch/mips/boot/dts/mscc/ocelot_pcb120.dts
+++ b/arch/mips/boot/dts/mscc/ocelot_pcb120.dts
@@ -59,40 +59,48 @@ phy4: ethernet-phy@3 {
 };
 
 &port0 {
+	status = "okay";
 	phy-handle = <&phy0>;
 };
 
 &port1 {
+	status = "okay";
 	phy-handle = <&phy1>;
 };
 
 &port2 {
+	status = "okay";
 	phy-handle = <&phy2>;
 };
 
 &port3 {
+	status = "okay";
 	phy-handle = <&phy3>;
 };
 
 &port4 {
+	status = "okay";
 	phy-handle = <&phy7>;
 	phy-mode = "sgmii";
 	phys = <&serdes 4 SERDES1G(2)>;
 };
 
 &port5 {
+	status = "okay";
 	phy-handle = <&phy4>;
 	phy-mode = "sgmii";
 	phys = <&serdes 5 SERDES1G(5)>;
 };
 
 &port6 {
+	status = "okay";
 	phy-handle = <&phy6>;
 	phy-mode = "sgmii";
 	phys = <&serdes 6 SERDES1G(3)>;
 };
 
 &port9 {
+	status = "okay";
 	phy-handle = <&phy5>;
 	phy-mode = "sgmii";
 	phys = <&serdes 9 SERDES1G(4)>;
diff --git a/arch/mips/boot/dts/mscc/ocelot_pcb123.dts b/arch/mips/boot/dts/mscc/ocelot_pcb123.dts
index ef852f382da8..7d7e638791dd 100644
--- a/arch/mips/boot/dts/mscc/ocelot_pcb123.dts
+++ b/arch/mips/boot/dts/mscc/ocelot_pcb123.dts
@@ -47,17 +47,21 @@ &mdio0 {
 };
 
 &port0 {
+	status = "okay";
 	phy-handle = <&phy0>;
 };
 
 &port1 {
+	status = "okay";
 	phy-handle = <&phy1>;
 };
 
 &port2 {
+	status = "okay";
 	phy-handle = <&phy2>;
 };
 
 &port3 {
+	status = "okay";
 	phy-handle = <&phy3>;
 };
-- 
2.30.2

