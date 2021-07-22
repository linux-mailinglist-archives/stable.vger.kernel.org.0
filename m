Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 814C93D2995
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:06:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233391AbhGVQFj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 12:05:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:39712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234221AbhGVQE3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 12:04:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B0DFF61CD8;
        Thu, 22 Jul 2021 16:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626972294;
        bh=PqWs7fVbREsPcJyM0yVYpc7JRLXrbGHa4Ro020FmzzI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B/iJsiyebduWDvyKGEIoBxqnOBGG3CPjpRaddY5VLcYxcpSUpuHu+AjdVqgqPc5YM
         8CHBNmh5n8up0NLZRFngpcIPAWI3QAH4ySCo6iS3GvBUetED/O9TatkbfA7J/EGA92
         cwZ2ToaC7B8NWQhJY4rb+c/CiD0axthiVcENh1BA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eddie James <eajames@linux.ibm.com>,
        Santosh Puranik <santosh.puranik@in.ibm.com>,
        Joel Stanley <joel@jms.id.au>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 059/156] ARM: dts: aspeed: Everest: Fix cable card PCA chips
Date:   Thu, 22 Jul 2021 18:30:34 +0200
Message-Id: <20210722155630.315475405@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155628.371356843@linuxfoundation.org>
References: <20210722155628.371356843@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Santosh Puranik <santosh.puranik@in.ibm.com>

[ Upstream commit 010da3daf9278ed03d38b7dcb0422f1a7df1bdd3 ]

Correct two PCA chips which were placed on the wrong I2C bus and
address.

Signed-off-by: Eddie James <eajames@linux.ibm.com>
Signed-off-by: Santosh Puranik <santosh.puranik@in.ibm.com>
Signed-off-by: Joel Stanley <joel@jms.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/aspeed-bmc-ibm-everest.dts | 168 +++++++++----------
 1 file changed, 83 insertions(+), 85 deletions(-)

diff --git a/arch/arm/boot/dts/aspeed-bmc-ibm-everest.dts b/arch/arm/boot/dts/aspeed-bmc-ibm-everest.dts
index 3295c8c7c05c..27af28c8847d 100644
--- a/arch/arm/boot/dts/aspeed-bmc-ibm-everest.dts
+++ b/arch/arm/boot/dts/aspeed-bmc-ibm-everest.dts
@@ -353,10 +353,47 @@
 
 &i2c1 {
 	status = "okay";
+};
+
+&i2c2 {
+	status = "okay";
+};
 
-	pca2: pca9552@61 {
+&i2c3 {
+	status = "okay";
+
+	eeprom@54 {
+		compatible = "atmel,24c128";
+		reg = <0x54>;
+	};
+
+	power-supply@68 {
+		compatible = "ibm,cffps";
+		reg = <0x68>;
+	};
+
+	power-supply@69 {
+		compatible = "ibm,cffps";
+		reg = <0x69>;
+	};
+
+	power-supply@6a {
+		compatible = "ibm,cffps";
+		reg = <0x6a>;
+	};
+
+	power-supply@6b {
+		compatible = "ibm,cffps";
+		reg = <0x6b>;
+	};
+};
+
+&i2c4 {
+	status = "okay";
+
+	pca2: pca9552@65 {
 		compatible = "nxp,pca9552";
-		reg = <0x61>;
+		reg = <0x65>;
 		#address-cells = <1>;
 		#size-cells = <0>;
 
@@ -424,12 +461,54 @@
 			reg = <9>;
 			type = <PCA955X_TYPE_GPIO>;
 		};
+	};
 
+	i2c-switch@70 {
+		compatible = "nxp,pca9546";
+		reg = <0x70>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		status = "okay";
+		i2c-mux-idle-disconnect;
+
+		i2c4mux0chn0: i2c@0 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			reg = <0>;
+			eeprom@52 {
+				compatible = "atmel,24c64";
+				reg = <0x52>;
+			};
+		};
+
+		i2c4mux0chn1: i2c@1 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			reg = <1>;
+			eeprom@50 {
+				compatible = "atmel,24c64";
+				reg = <0x50>;
+			};
+		};
+
+		i2c4mux0chn2: i2c@2 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			reg = <2>;
+			eeprom@51 {
+				compatible = "atmel,24c64";
+				reg = <0x51>;
+			};
+		};
 	};
+};
 
-	pca3: pca9552@62 {
+&i2c5 {
+	status = "okay";
+
+	pca3: pca9552@66 {
 		compatible = "nxp,pca9552";
-		reg = <0x62>;
+		reg = <0x66>;
 		#address-cells = <1>;
 		#size-cells = <0>;
 
@@ -512,87 +591,6 @@
 
 	};
 
-};
-
-&i2c2 {
-	status = "okay";
-};
-
-&i2c3 {
-	status = "okay";
-
-	eeprom@54 {
-		compatible = "atmel,24c128";
-		reg = <0x54>;
-	};
-
-	power-supply@68 {
-		compatible = "ibm,cffps";
-		reg = <0x68>;
-	};
-
-	power-supply@69 {
-		compatible = "ibm,cffps";
-		reg = <0x69>;
-	};
-
-	power-supply@6a {
-		compatible = "ibm,cffps";
-		reg = <0x6a>;
-	};
-
-	power-supply@6b {
-		compatible = "ibm,cffps";
-		reg = <0x6b>;
-	};
-};
-
-&i2c4 {
-	status = "okay";
-
-	i2c-switch@70 {
-		compatible = "nxp,pca9546";
-		reg = <0x70>;
-		#address-cells = <1>;
-		#size-cells = <0>;
-		status = "okay";
-		i2c-mux-idle-disconnect;
-
-		i2c4mux0chn0: i2c@0 {
-			#address-cells = <1>;
-			#size-cells = <0>;
-			reg = <0>;
-			eeprom@52 {
-				compatible = "atmel,24c64";
-				reg = <0x52>;
-			};
-		};
-
-		i2c4mux0chn1: i2c@1 {
-			#address-cells = <1>;
-			#size-cells = <0>;
-			reg = <1>;
-			eeprom@50 {
-				compatible = "atmel,24c64";
-				reg = <0x50>;
-			};
-		};
-
-		i2c4mux0chn2: i2c@2 {
-			#address-cells = <1>;
-			#size-cells = <0>;
-			reg = <2>;
-			eeprom@51 {
-				compatible = "atmel,24c64";
-				reg = <0x51>;
-			};
-		};
-	};
-};
-
-&i2c5 {
-	status = "okay";
-
 	i2c-switch@70 {
 		compatible = "nxp,pca9546";
 		reg = <0x70>;
-- 
2.30.2



