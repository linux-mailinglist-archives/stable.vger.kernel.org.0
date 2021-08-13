Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B57033EB8DA
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 17:26:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241986AbhHMPRe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 11:17:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:57690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242312AbhHMPP0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Aug 2021 11:15:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7FFFD604D7;
        Fri, 13 Aug 2021 15:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628867682;
        bh=LYGzPv9vuZNyAL2IV1hnZqXStAXSYWZq271uf7NndUk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L4/nRSRHOV/xFSQsa5IRaZiWXh5Iq+N4XaMhcU5xlIt3Xaqx+0epRk71M/bP/vZrF
         uQEj0psBVDpRvTdG8Dpa5D+n3pc+5n2/e9FMlu1vJvtXk84AOyFGAU3sLRygqLaeyy
         ap98GnDTcoc1Zd2vf+h65bW9en6DQ7Y236iqHxrI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adam Ford <aford173@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 5.10 08/19] arm64: dts: renesas: rzg2: Add usb2_clksel to RZ/G2 M/N/H
Date:   Fri, 13 Aug 2021 17:07:25 +0200
Message-Id: <20210813150522.900346161@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210813150522.623322501@linuxfoundation.org>
References: <20210813150522.623322501@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adam Ford <aford173@gmail.com>

commit e1076ce07b7736aed269c5d8154f2442970d9137 upstream

Per the reference manual for the RZ/G Series, 2nd Generation,
the RZ/G2M, RZ/G2N, and RZ/G2H have a bit that can be set to
choose between a crystal oscillator and an external oscillator.

Because only boards that need this should enable it, it's marked
as disabled by default for backwards compatibility with existing
boards.

Signed-off-by: Adam Ford <aford173@gmail.com>
Link: https://lore.kernel.org/r/20201228202221.2327468-2-aford173@gmail.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/renesas/r8a774a1.dtsi |   15 +++++++++++++++
 arch/arm64/boot/dts/renesas/r8a774b1.dtsi |   15 +++++++++++++++
 arch/arm64/boot/dts/renesas/r8a774e1.dtsi |   15 +++++++++++++++
 3 files changed, 45 insertions(+)

--- a/arch/arm64/boot/dts/renesas/r8a774a1.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a774a1.dtsi
@@ -836,6 +836,21 @@
 			status = "disabled";
 		};
 
+		usb2_clksel: clock-controller@e6590630 {
+			compatible = "renesas,r8a774a1-rcar-usb2-clock-sel",
+				     "renesas,rcar-gen3-usb2-clock-sel";
+			reg = <0 0xe6590630 0 0x02>;
+			clocks = <&cpg CPG_MOD 703>, <&cpg CPG_MOD 704>,
+				 <&usb_extal_clk>, <&usb3s0_clk>;
+			clock-names = "ehci_ohci", "hs-usb-if",
+				      "usb_extal", "usb_xtal";
+			#clock-cells = <0>;
+			power-domains = <&sysc R8A774A1_PD_ALWAYS_ON>;
+			resets = <&cpg 703>, <&cpg 704>;
+			reset-names = "ehci_ohci", "hs-usb-if";
+			status = "disabled";
+		};
+
 		usb_dmac0: dma-controller@e65a0000 {
 			compatible = "renesas,r8a774a1-usb-dmac",
 				     "renesas,usb-dmac";
--- a/arch/arm64/boot/dts/renesas/r8a774b1.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a774b1.dtsi
@@ -709,6 +709,21 @@
 			status = "disabled";
 		};
 
+		usb2_clksel: clock-controller@e6590630 {
+			compatible = "renesas,r8a774b1-rcar-usb2-clock-sel",
+				     "renesas,rcar-gen3-usb2-clock-sel";
+			reg = <0 0xe6590630 0 0x02>;
+			clocks = <&cpg CPG_MOD 703>, <&cpg CPG_MOD 704>,
+				 <&usb_extal_clk>, <&usb3s0_clk>;
+			clock-names = "ehci_ohci", "hs-usb-if",
+				      "usb_extal", "usb_xtal";
+			#clock-cells = <0>;
+			power-domains = <&sysc R8A774B1_PD_ALWAYS_ON>;
+			resets = <&cpg 703>, <&cpg 704>;
+			reset-names = "ehci_ohci", "hs-usb-if";
+			status = "disabled";
+		};
+
 		usb_dmac0: dma-controller@e65a0000 {
 			compatible = "renesas,r8a774b1-usb-dmac",
 				     "renesas,usb-dmac";
--- a/arch/arm64/boot/dts/renesas/r8a774e1.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a774e1.dtsi
@@ -890,6 +890,21 @@
 			status = "disabled";
 		};
 
+		usb2_clksel: clock-controller@e6590630 {
+			compatible = "renesas,r8a774e1-rcar-usb2-clock-sel",
+				     "renesas,rcar-gen3-usb2-clock-sel";
+			reg = <0 0xe6590630 0 0x02>;
+			clocks = <&cpg CPG_MOD 703>, <&cpg CPG_MOD 704>,
+				 <&usb_extal_clk>, <&usb3s0_clk>;
+			clock-names = "ehci_ohci", "hs-usb-if",
+				      "usb_extal", "usb_xtal";
+			#clock-cells = <0>;
+			power-domains = <&sysc R8A774E1_PD_ALWAYS_ON>;
+			resets = <&cpg 703>, <&cpg 704>;
+			reset-names = "ehci_ohci", "hs-usb-if";
+			status = "disabled";
+		};
+
 		usb_dmac0: dma-controller@e65a0000 {
 			compatible = "renesas,r8a774e1-usb-dmac",
 				     "renesas,usb-dmac";


