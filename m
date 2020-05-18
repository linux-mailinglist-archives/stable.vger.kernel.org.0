Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47F951D851B
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:17:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728495AbgERSQ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:16:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:37652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731888AbgERR6U (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:58:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6125A207C4;
        Mon, 18 May 2020 17:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824699;
        bh=z2CwPlf7bz18Akb6Y2vLQl3VvY12zCFv4kN7QHx18fs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eWauLexNjhIjluFPNjp6o3FsuRfb94sLap8u9TJatbmK3BtegNMh3Mdf0YBevwVCd
         LOzBtSyhhOf1myHMIAM2CsuVj6Ns4azomeh8YNpEAouC356DIpXB2UZGkg1ZJyE//1
         xJjkMOkqLavJf20zRZ0Djp3wfL1hjEkMggbTj0ac=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Tony Lindgren <tony@atomide.com>
Subject: [PATCH 5.4 115/147] ARM: dts: dra7: Fix bus_dma_limit for PCIe
Date:   Mon, 18 May 2020 19:37:18 +0200
Message-Id: <20200518173527.379496085@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173513.009514388@linuxfoundation.org>
References: <20200518173513.009514388@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
 arch/arm/boot/dts/dra7.dtsi |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm/boot/dts/dra7.dtsi
+++ b/arch/arm/boot/dts/dra7.dtsi
@@ -172,6 +172,7 @@
 			#address-cells = <1>;
 			ranges = <0x51000000 0x51000000 0x3000
 				  0x0	     0x20000000 0x10000000>;
+			dma-ranges;
 			/**
 			 * To enable PCI endpoint mode, disable the pcie1_rc
 			 * node and enable pcie1_ep mode.
@@ -185,7 +186,6 @@
 				device_type = "pci";
 				ranges = <0x81000000 0 0          0x03000 0 0x00010000
 					  0x82000000 0 0x20013000 0x13000 0 0xffed000>;
-				dma-ranges = <0x02000000 0x0 0x00000000 0x00000000 0x1 0x00000000>;
 				bus-range = <0x00 0xff>;
 				#interrupt-cells = <1>;
 				num-lanes = <1>;
@@ -230,6 +230,7 @@
 			#address-cells = <1>;
 			ranges = <0x51800000 0x51800000 0x3000
 				  0x0	     0x30000000 0x10000000>;
+			dma-ranges;
 			status = "disabled";
 			pcie2_rc: pcie@51800000 {
 				reg = <0x51800000 0x2000>, <0x51802000 0x14c>, <0x1000 0x2000>;
@@ -240,7 +241,6 @@
 				device_type = "pci";
 				ranges = <0x81000000 0 0          0x03000 0 0x00010000
 					  0x82000000 0 0x30013000 0x13000 0 0xffed000>;
-				dma-ranges = <0x02000000 0x0 0x00000000 0x00000000 0x1 0x00000000>;
 				bus-range = <0x00 0xff>;
 				#interrupt-cells = <1>;
 				num-lanes = <1>;


