Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FE5D2ABA11
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:16:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732903AbgKINPY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:15:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:42188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732902AbgKINPX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:15:23 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A111320867;
        Mon,  9 Nov 2020 13:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927723;
        bh=d37asfMGKYxtGpDyJ9BNnKRVpFFwKWby68pi9aJUuN8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ScDS+bvaSoyQcS8iQlLRtFR4qRp3CRk5Px3fi36QmIFhR9g0ljKbFVtKMWF7HIbf2
         ZHNbtiwGDRQrh3Yk9N3kwtqD6GR7v43kvsxsufQ27fn4uL/YPaafifzUIPFEJJ7vnH
         rI1eaTb5VNFXfGvgMgtrdLn3xZmQZI7ZBOCIRQv8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Andre Heider <a.heider@gmail.com>,
        Gregory CLEMENT <gregory.clement@bootlin.com>
Subject: [PATCH 5.4 85/85] arm64: dts: marvell: espressobin: Add ethernet switch aliases
Date:   Mon,  9 Nov 2020 13:56:22 +0100
Message-Id: <20201109125026.670807503@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125022.614792961@linuxfoundation.org>
References: <20201109125022.614792961@linuxfoundation.org>
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
[pali: Backported Espressobin rev V5 changes to 5.4 and 4.19 versions]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/boot/dts/marvell/armada-3720-espressobin.dts |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

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


