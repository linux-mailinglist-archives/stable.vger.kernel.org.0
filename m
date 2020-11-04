Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00F962A63A1
	for <lists+stable@lfdr.de>; Wed,  4 Nov 2020 12:53:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729263AbgKDLxP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Nov 2020 06:53:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:32980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729227AbgKDLwj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Nov 2020 06:52:39 -0500
Received: from pali.im (pali.im [31.31.79.79])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E06C2072C;
        Wed,  4 Nov 2020 11:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604490758;
        bh=yAXLc8iBN2mG7YTFZmxcIqBclcOSBja2KYBbIkVlnz8=;
        h=From:To:Cc:Subject:Date:From;
        b=BJ2oJTpO0RhZRDV8RHGhvB8iH+b6cbx5R108fv+iuqWn9TDaTKau1lcKiA8jpx7AQ
         MiYBp+1pMcpYaTiVU+JbitSt2NZ6R6FquSyGSg9/LkyR5rdrsqzlIWcNFsVBFeiC/+
         cotH1AjYZ0x1Z6doMOAMdG0QBu8nYCXMATrwJurs=
Received: by pali.im (Postfix)
        id D863A64E; Wed,  4 Nov 2020 12:52:35 +0100 (CET)
From:   =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, a.heider@gmail.com, andrew@lunn.ch,
        gregory.clement@bootlin.com
Subject: [PATCH] arm64: dts: marvell: espressobin: Add ethernet switch aliases
Date:   Wed,  4 Nov 2020 12:52:09 +0100
Message-Id: <20201104115209.1282-1-pali@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
[pali: Backported Espressobin rev V5 changes to 5.4 and 4.19 versions]

---
This patch is backport for 5.4 and 4.19 stable releases. From original
patch were removed changes for Espressobin revision V7 as these older
kernel versions have DTS files only for Espressobin revision V5.

Note that this patch depends on commit a2c7023f7075c ("dsa: read mac
address") as stated on Cc: line and for 4.19 release needs to be
backported first.
---
 .../boot/dts/marvell/armada-3720-espressobin.dts     | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/marvell/armada-3720-espressobin.dts b/arch/arm64/boot/dts/marvell/armada-3720-espressobin.dts
index 05dc58c13fa4..6226e7e80980 100644
--- a/arch/arm64/boot/dts/marvell/armada-3720-espressobin.dts
+++ b/arch/arm64/boot/dts/marvell/armada-3720-espressobin.dts
@@ -21,6 +21,10 @@
 
 	aliases {
 		ethernet0 = &eth0;
+		/* for dsa slave device */
+		ethernet1 = &switch0port1;
+		ethernet2 = &switch0port2;
+		ethernet3 = &switch0port3;
 		serial0 = &uart0;
 		serial1 = &uart1;
 	};
@@ -147,7 +151,7 @@
 			#address-cells = <1>;
 			#size-cells = <0>;
 
-			port@0 {
+			switch0port0: port@0 {
 				reg = <0>;
 				label = "cpu";
 				ethernet = <&eth0>;
@@ -158,19 +162,19 @@
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
-- 
2.20.1

