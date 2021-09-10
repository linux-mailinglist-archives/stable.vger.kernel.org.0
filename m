Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C0FE4062BC
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:45:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242154AbhIJAqW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:46:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:48022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234000AbhIJAWU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:22:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 84F70610A3;
        Fri, 10 Sep 2021 00:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233270;
        bh=sqtme8uJweBGaICmFp7X+R6DJQICCl96FVYAcxPhTv4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jYJT9bvwYXJalHzFSiVjgzaRpBpRHv51rKkw+UrvyK2wKBuIvmuoAPANJO0+2+QQ7
         +hTfiReFY+h7Sniew62GFGXBq92/ILHBRzucybtglyF5SvmGkQQgmH2eavp1XUXIoH
         8OJw8/Ln2MS2AqmgWz5hz9IEIjTi0mMLrtWWcEZsNcGr4ibEh0FaNEu8qdP0uqAN8n
         4QqHkY/MhuljVIDuH4aYk4QO/vHgl8D3ZXOwy7cVcE2EvG9L5AKe9oujeqqRKgwNKm
         Id+yS9jCLUmM4NynxVYes4G5mqmR2ee05obybJxJQCWM6Or510ueQjjTwZwmGzNhEK
         VVMI6ecPkd2HQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>, linux-mips@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 30/53] MIPS: mscc: ocelot: disable all switch ports by default
Date:   Thu,  9 Sep 2021 20:20:05 -0400
Message-Id: <20210910002028.175174-30-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910002028.175174-1-sashal@kernel.org>
References: <20210910002028.175174-1-sashal@kernel.org>
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
index 535a98284dcb..e51db651af13 100644
--- a/arch/mips/boot/dts/mscc/ocelot.dtsi
+++ b/arch/mips/boot/dts/mscc/ocelot.dtsi
@@ -150,36 +150,47 @@ ethernet-ports {
 
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
index 897de5025d7f..d2dc6b3d923c 100644
--- a/arch/mips/boot/dts/mscc/ocelot_pcb120.dts
+++ b/arch/mips/boot/dts/mscc/ocelot_pcb120.dts
@@ -69,40 +69,48 @@ phy4: ethernet-phy@3 {
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

