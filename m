Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28564206367
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:29:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389827AbgFWUXv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:23:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:42118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390348AbgFWUXu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:23:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 53CAB20723;
        Tue, 23 Jun 2020 20:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943829;
        bh=9ZBvvwumbqVmD4E7N8e1DZ4AV4BqvVsv4cpUi2t8YHU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZacpgP15JFA/lBNWfIqBmP9NsL/U5xvV/fKKdOH6KxpdGPnMmpyR/ObiEZn1QD8yU
         FyqhZb6OO7A1J/XUcsYXOxQOWEhg5ug6nsG3cko+zrvaAd0hheY1k2spntOdZFaqyx
         mCXHkN0ucYXqPN+KD3ASHfA+7dTAhLpaVzmwhcW0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 037/314] arm64: dts: juno: Fix GIC child nodes
Date:   Tue, 23 Jun 2020 21:53:52 +0200
Message-Id: <20200623195340.576949501@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195338.770401005@linuxfoundation.org>
References: <20200623195338.770401005@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andre Przywara <andre.przywara@arm.com>

[ Upstream commit a78aee9e434932a500db36cc6d88daeff3745e9f ]

The GIC DT nodes for the Juno boards were not fully compliant with
the DT binding, which has certain expectations about child nodes and
their size and address cells values.

Use smaller #address-cells and #size-cells values, as the binding
requests, and adjust the reg properties accordingly.
This requires adjusting the interrupt nexus nodes as well, as one
field of the interrupt-map property depends on the GIC's address-size.

Link: https://lore.kernel.org/r/20200513103016.130417-10-andre.przywara@arm.com
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/arm/juno-base.dtsi | 50 +++++++++++++-------------
 1 file changed, 25 insertions(+), 25 deletions(-)

diff --git a/arch/arm64/boot/dts/arm/juno-base.dtsi b/arch/arm64/boot/dts/arm/juno-base.dtsi
index 8c11660bbe40c..c47f76b01c4b5 100644
--- a/arch/arm64/boot/dts/arm/juno-base.dtsi
+++ b/arch/arm64/boot/dts/arm/juno-base.dtsi
@@ -62,35 +62,35 @@
 		      <0x0 0x2c02f000 0 0x2000>,
 		      <0x0 0x2c04f000 0 0x2000>,
 		      <0x0 0x2c06f000 0 0x2000>;
-		#address-cells = <2>;
+		#address-cells = <1>;
 		#interrupt-cells = <3>;
-		#size-cells = <2>;
+		#size-cells = <1>;
 		interrupt-controller;
 		interrupts = <GIC_PPI 9 (GIC_CPU_MASK_SIMPLE(6) | IRQ_TYPE_LEVEL_HIGH)>;
-		ranges = <0 0 0 0x2c1c0000 0 0x40000>;
+		ranges = <0 0 0x2c1c0000 0x40000>;
 
 		v2m_0: v2m@0 {
 			compatible = "arm,gic-v2m-frame";
 			msi-controller;
-			reg = <0 0 0 0x10000>;
+			reg = <0 0x10000>;
 		};
 
 		v2m@10000 {
 			compatible = "arm,gic-v2m-frame";
 			msi-controller;
-			reg = <0 0x10000 0 0x10000>;
+			reg = <0x10000 0x10000>;
 		};
 
 		v2m@20000 {
 			compatible = "arm,gic-v2m-frame";
 			msi-controller;
-			reg = <0 0x20000 0 0x10000>;
+			reg = <0x20000 0x10000>;
 		};
 
 		v2m@30000 {
 			compatible = "arm,gic-v2m-frame";
 			msi-controller;
-			reg = <0 0x30000 0 0x10000>;
+			reg = <0x30000 0x10000>;
 		};
 	};
 
@@ -519,10 +519,10 @@
 			 <0x42000000 0x40 0x00000000 0x40 0x00000000 0x1 0x00000000>;
 		#interrupt-cells = <1>;
 		interrupt-map-mask = <0 0 0 7>;
-		interrupt-map = <0 0 0 1 &gic 0 0 GIC_SPI 136 IRQ_TYPE_LEVEL_HIGH>,
-				<0 0 0 2 &gic 0 0 GIC_SPI 137 IRQ_TYPE_LEVEL_HIGH>,
-				<0 0 0 3 &gic 0 0 GIC_SPI 138 IRQ_TYPE_LEVEL_HIGH>,
-				<0 0 0 4 &gic 0 0 GIC_SPI 139 IRQ_TYPE_LEVEL_HIGH>;
+		interrupt-map = <0 0 0 1 &gic 0 GIC_SPI 136 IRQ_TYPE_LEVEL_HIGH>,
+				<0 0 0 2 &gic 0 GIC_SPI 137 IRQ_TYPE_LEVEL_HIGH>,
+				<0 0 0 3 &gic 0 GIC_SPI 138 IRQ_TYPE_LEVEL_HIGH>,
+				<0 0 0 4 &gic 0 GIC_SPI 139 IRQ_TYPE_LEVEL_HIGH>;
 		msi-parent = <&v2m_0>;
 		status = "disabled";
 		iommu-map-mask = <0x0>;	/* RC has no means to output PCI RID */
@@ -786,19 +786,19 @@
 
 		#interrupt-cells = <1>;
 		interrupt-map-mask = <0 0 15>;
-		interrupt-map = <0 0  0 &gic 0 0 GIC_SPI  68 IRQ_TYPE_LEVEL_HIGH>,
-				<0 0  1 &gic 0 0 GIC_SPI  69 IRQ_TYPE_LEVEL_HIGH>,
-				<0 0  2 &gic 0 0 GIC_SPI  70 IRQ_TYPE_LEVEL_HIGH>,
-				<0 0  3 &gic 0 0 GIC_SPI 160 IRQ_TYPE_LEVEL_HIGH>,
-				<0 0  4 &gic 0 0 GIC_SPI 161 IRQ_TYPE_LEVEL_HIGH>,
-				<0 0  5 &gic 0 0 GIC_SPI 162 IRQ_TYPE_LEVEL_HIGH>,
-				<0 0  6 &gic 0 0 GIC_SPI 163 IRQ_TYPE_LEVEL_HIGH>,
-				<0 0  7 &gic 0 0 GIC_SPI 164 IRQ_TYPE_LEVEL_HIGH>,
-				<0 0  8 &gic 0 0 GIC_SPI 165 IRQ_TYPE_LEVEL_HIGH>,
-				<0 0  9 &gic 0 0 GIC_SPI 166 IRQ_TYPE_LEVEL_HIGH>,
-				<0 0 10 &gic 0 0 GIC_SPI 167 IRQ_TYPE_LEVEL_HIGH>,
-				<0 0 11 &gic 0 0 GIC_SPI 168 IRQ_TYPE_LEVEL_HIGH>,
-				<0 0 12 &gic 0 0 GIC_SPI 169 IRQ_TYPE_LEVEL_HIGH>;
+		interrupt-map = <0 0  0 &gic 0 GIC_SPI  68 IRQ_TYPE_LEVEL_HIGH>,
+				<0 0  1 &gic 0 GIC_SPI  69 IRQ_TYPE_LEVEL_HIGH>,
+				<0 0  2 &gic 0 GIC_SPI  70 IRQ_TYPE_LEVEL_HIGH>,
+				<0 0  3 &gic 0 GIC_SPI 160 IRQ_TYPE_LEVEL_HIGH>,
+				<0 0  4 &gic 0 GIC_SPI 161 IRQ_TYPE_LEVEL_HIGH>,
+				<0 0  5 &gic 0 GIC_SPI 162 IRQ_TYPE_LEVEL_HIGH>,
+				<0 0  6 &gic 0 GIC_SPI 163 IRQ_TYPE_LEVEL_HIGH>,
+				<0 0  7 &gic 0 GIC_SPI 164 IRQ_TYPE_LEVEL_HIGH>,
+				<0 0  8 &gic 0 GIC_SPI 165 IRQ_TYPE_LEVEL_HIGH>,
+				<0 0  9 &gic 0 GIC_SPI 166 IRQ_TYPE_LEVEL_HIGH>,
+				<0 0 10 &gic 0 GIC_SPI 167 IRQ_TYPE_LEVEL_HIGH>,
+				<0 0 11 &gic 0 GIC_SPI 168 IRQ_TYPE_LEVEL_HIGH>,
+				<0 0 12 &gic 0 GIC_SPI 169 IRQ_TYPE_LEVEL_HIGH>;
 	};
 
 	site2: tlx@60000000 {
@@ -808,6 +808,6 @@
 		ranges = <0 0 0x60000000 0x10000000>;
 		#interrupt-cells = <1>;
 		interrupt-map-mask = <0 0>;
-		interrupt-map = <0 0 &gic 0 0 GIC_SPI 168 IRQ_TYPE_LEVEL_HIGH>;
+		interrupt-map = <0 0 &gic 0 GIC_SPI 168 IRQ_TYPE_LEVEL_HIGH>;
 	};
 };
-- 
2.25.1



