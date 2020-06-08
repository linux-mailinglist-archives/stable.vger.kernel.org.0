Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCACB1F2E5E
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:42:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728050AbgFIAlB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 20:41:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:60504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728336AbgFHXMt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:12:49 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 67AAA212CC;
        Mon,  8 Jun 2020 23:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657969;
        bh=48qnSUMvAgXFcboFXXCk/yFfLm1NqUTMU6M6I9i+qZo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cbS24Kgd+8thAY+pjsjvUWqBShwCbZjDYTmI3d+YRwpUIYp+zQ94rqdi+0f91oGYo
         5x4lQcvdtLRHaLV5xZ3T663b3ZbfhJgsYPx4KpnLj3uY5cpLvPiJDrcprmXfX4Gao+
         bM3t879eFRR2zsKStDIxytTc8peZgw0AaombTM20=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kishon Vijay Abraham I <kishon@ti.com>, stable@kernel.org,
        Tony Lindgren <tony@atomide.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-omap@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 032/606] ARM: dts: dra7: Fix bus_dma_limit for PCIe
Date:   Mon,  8 Jun 2020 19:02:37 -0400
Message-Id: <20200608231211.3363633-32-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kishon Vijay Abraham I <kishon@ti.com>

commit 90d4d3f4ea45370d482fa609dbae4d2281b4074f upstream.

Even though commit cfb5d65f2595 ("ARM: dts: dra7: Add bus_dma_limit
for L3 bus") added bus_dma_limit for L3 bus, the PCIe controller
gets incorrect value of bus_dma_limit.

Fix it by adding empty dma-ranges property to axi@0 and axi@1
(parent device tree node of PCIe controller).

Cc: stable@kernel.org
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/dra7.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/dra7.dtsi b/arch/arm/boot/dts/dra7.dtsi
index 5f5ee16f07a3..a341511f014c 100644
--- a/arch/arm/boot/dts/dra7.dtsi
+++ b/arch/arm/boot/dts/dra7.dtsi
@@ -172,6 +172,7 @@ axi@0 {
 			#address-cells = <1>;
 			ranges = <0x51000000 0x51000000 0x3000
 				  0x0	     0x20000000 0x10000000>;
+			dma-ranges;
 			/**
 			 * To enable PCI endpoint mode, disable the pcie1_rc
 			 * node and enable pcie1_ep mode.
@@ -185,7 +186,6 @@ pcie1_rc: pcie@51000000 {
 				device_type = "pci";
 				ranges = <0x81000000 0 0          0x03000 0 0x00010000
 					  0x82000000 0 0x20013000 0x13000 0 0xffed000>;
-				dma-ranges = <0x02000000 0x0 0x00000000 0x00000000 0x1 0x00000000>;
 				bus-range = <0x00 0xff>;
 				#interrupt-cells = <1>;
 				num-lanes = <1>;
@@ -230,6 +230,7 @@ axi@1 {
 			#address-cells = <1>;
 			ranges = <0x51800000 0x51800000 0x3000
 				  0x0	     0x30000000 0x10000000>;
+			dma-ranges;
 			status = "disabled";
 			pcie2_rc: pcie@51800000 {
 				reg = <0x51800000 0x2000>, <0x51802000 0x14c>, <0x1000 0x2000>;
@@ -240,7 +241,6 @@ pcie2_rc: pcie@51800000 {
 				device_type = "pci";
 				ranges = <0x81000000 0 0          0x03000 0 0x00010000
 					  0x82000000 0 0x30013000 0x13000 0 0xffed000>;
-				dma-ranges = <0x02000000 0x0 0x00000000 0x00000000 0x1 0x00000000>;
 				bus-range = <0x00 0xff>;
 				#interrupt-cells = <1>;
 				num-lanes = <1>;
-- 
2.25.1

