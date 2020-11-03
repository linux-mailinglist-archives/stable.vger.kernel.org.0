Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D39372A57D1
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:46:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732036AbgKCUwG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:52:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:48032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731418AbgKCUwC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:52:02 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B246422226;
        Tue,  3 Nov 2020 20:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436722;
        bh=ht3LeBio6+cRc0XRV+RP1Vy/WvDlFFlCEtlcc46tvvM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0MMu6gfJ0X8yAm6n2moq2rsUKWLMVMLoQWGZVrazd9WVWzEffgKR3DObDnZuRMZo6
         sjUFk7/oo4l0tmHwbJeAlQO0jmwk1mmkm+JdqpcKapYvpqPFYdLdWuA/yt3SKHZ+HD
         nmQIIKa49toTkseC4WM/kjQCRyo8kALikdT03FfU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Andre Heider <a.heider@gmail.com>,
        Gregory CLEMENT <gregory.clement@bootlin.com>
Subject: [PATCH 5.9 373/391] arm64: dts: marvell: espressobin: Add ethernet switch aliases
Date:   Tue,  3 Nov 2020 21:37:04 +0100
Message-Id: <20201103203412.316278533@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

commit b64d814257b027e29a474bcd660f6372490138c7 upstream.

Espressobin boards have 3 ethernet ports and some of them got assigned more
then one MAC address. MAC addresses are stored in U-Boot environment.

Since commit a2c7023f7075c ("net: dsa: read mac address from DT for slave
device") kernel can use MAC addresses from DT for particular DSA port.

Currently Espressobin DTS file contains alias just for ethernet0.

This patch defines additional ethernet aliases in Espressobin DTS files, so
bootloader can fill correct MAC address for DSA switch ports if more MAC
addresses were specified.

DT alias ethernet1 is used for wan port, DT aliases ethernet2 and ethernet3
are used for lan ports for both Espressobin revisions (V5 and V7).

Fixes: 5253cb8c00a6f ("arm64: dts: marvell: espressobin: add ethernet alias")
Cc: <stable@vger.kernel.org> # a2c7023f7075c: dsa: read mac address
Signed-off-by: Pali Rohár <pali@kernel.org>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Andre Heider <a.heider@gmail.com>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/boot/dts/marvell/armada-3720-espressobin-v7-emmc.dts |   10 ++++++--
 arch/arm64/boot/dts/marvell/armada-3720-espressobin-v7.dts      |   10 ++++++--
 arch/arm64/boot/dts/marvell/armada-3720-espressobin.dtsi        |   12 ++++++----
 3 files changed, 24 insertions(+), 8 deletions(-)

--- a/arch/arm64/boot/dts/marvell/armada-3720-espressobin-v7-emmc.dts
+++ b/arch/arm64/boot/dts/marvell/armada-3720-espressobin-v7-emmc.dts
@@ -20,17 +20,23 @@
 	compatible = "globalscale,espressobin-v7-emmc", "globalscale,espressobin-v7",
 		     "globalscale,espressobin", "marvell,armada3720",
 		     "marvell,armada3710";
+
+	aliases {
+		/* ethernet1 is wan port */
+		ethernet1 = &switch0port3;
+		ethernet3 = &switch0port1;
+	};
 };
 
 &switch0 {
 	ports {
-		port@1 {
+		switch0port1: port@1 {
 			reg = <1>;
 			label = "lan1";
 			phy-handle = <&switch0phy0>;
 		};
 
-		port@3 {
+		switch0port3: port@3 {
 			reg = <3>;
 			label = "wan";
 			phy-handle = <&switch0phy2>;
--- a/arch/arm64/boot/dts/marvell/armada-3720-espressobin-v7.dts
+++ b/arch/arm64/boot/dts/marvell/armada-3720-espressobin-v7.dts
@@ -19,17 +19,23 @@
 	model = "Globalscale Marvell ESPRESSOBin Board V7";
 	compatible = "globalscale,espressobin-v7", "globalscale,espressobin",
 		     "marvell,armada3720", "marvell,armada3710";
+
+	aliases {
+		/* ethernet1 is wan port */
+		ethernet1 = &switch0port3;
+		ethernet3 = &switch0port1;
+	};
 };
 
 &switch0 {
 	ports {
-		port@1 {
+		switch0port1: port@1 {
 			reg = <1>;
 			label = "lan1";
 			phy-handle = <&switch0phy0>;
 		};
 
-		port@3 {
+		switch0port3: port@3 {
 			reg = <3>;
 			label = "wan";
 			phy-handle = <&switch0phy2>;
--- a/arch/arm64/boot/dts/marvell/armada-3720-espressobin.dtsi
+++ b/arch/arm64/boot/dts/marvell/armada-3720-espressobin.dtsi
@@ -13,6 +13,10 @@
 / {
 	aliases {
 		ethernet0 = &eth0;
+		/* for dsa slave device */
+		ethernet1 = &switch0port1;
+		ethernet2 = &switch0port2;
+		ethernet3 = &switch0port3;
 		serial0 = &uart0;
 		serial1 = &uart1;
 	};
@@ -120,7 +124,7 @@
 			#address-cells = <1>;
 			#size-cells = <0>;
 
-			port@0 {
+			switch0port0: port@0 {
 				reg = <0>;
 				label = "cpu";
 				ethernet = <&eth0>;
@@ -131,19 +135,19 @@
 				};
 			};
 
-			port@1 {
+			switch0port1: port@1 {
 				reg = <1>;
 				label = "wan";
 				phy-handle = <&switch0phy0>;
 			};
 
-			port@2 {
+			switch0port2: port@2 {
 				reg = <2>;
 				label = "lan0";
 				phy-handle = <&switch0phy1>;
 			};
 
-			port@3 {
+			switch0port3: port@3 {
 				reg = <3>;
 				label = "lan1";
 				phy-handle = <&switch0phy2>;


