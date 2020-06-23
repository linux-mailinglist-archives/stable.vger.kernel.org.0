Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00CF920632B
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:28:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389664AbgFWUSY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:18:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:35246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389660AbgFWUSX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:18:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 039CB21473;
        Tue, 23 Jun 2020 20:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943503;
        bh=PoNil7jr+30iVCj+zJ8Urou9pPiuYD7sNpCe1oXReJU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dMR+Cfqk4albqgFmcuo9+Fpbkg6y5RO8VPq+lWHnirkSWMYfHL4ldKsxTcj95GZP/
         EuVD7qOf7K8u34v4a60aaDGjVRrZ6pLHyPveMD6bRfMJOKaldwBw2hHnT4EVqzYvfE
         SqGEkQTzkm+dpvA1frAEDP/Nt342ngGiPkzDrEVM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>
Subject: [PATCH 5.7 418/477] arm64: dts: realtek: rtd129x: Use reserved-memory for RPC regions
Date:   Tue, 23 Jun 2020 21:56:55 +0200
Message-Id: <20200623195427.287074940@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Färber <afaerber@suse.de>

commit 690677c22d5fa5dfdaa609a1739b75fdfb1c4a24 upstream.

Move /reserved-memory node from RTD1295 to RTD129x DT.
Convert RPC /memreserve/s into /reserved-memory nodes.

Fixes: 72a7786c0a0d ("ARM64: dts: Add Realtek RTD1295 and Zidoo X9S")
Fixes: f8b3436dad5c ("arm64: dts: realtek: Factor out common RTD129x parts")
Signed-off-by: Andreas Färber <afaerber@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/boot/dts/realtek/rtd1295.dtsi |   13 +------------
 arch/arm64/boot/dts/realtek/rtd129x.dtsi |   23 ++++++++++++++++++++---
 2 files changed, 21 insertions(+), 15 deletions(-)

--- a/arch/arm64/boot/dts/realtek/rtd1295.dtsi
+++ b/arch/arm64/boot/dts/realtek/rtd1295.dtsi
@@ -2,7 +2,7 @@
 /*
  * Realtek RTD1295 SoC
  *
- * Copyright (c) 2016-2017 Andreas Färber
+ * Copyright (c) 2016-2019 Andreas Färber
  */
 
 #include "rtd129x.dtsi"
@@ -47,17 +47,6 @@
 		};
 	};
 
-	reserved-memory {
-		#address-cells = <1>;
-		#size-cells = <1>;
-		ranges;
-
-		tee@10100000 {
-			reg = <0x10100000 0xf00000>;
-			no-map;
-		};
-	};
-
 	timer {
 		compatible = "arm,armv8-timer";
 		interrupts = <GIC_PPI 13
--- a/arch/arm64/boot/dts/realtek/rtd129x.dtsi
+++ b/arch/arm64/boot/dts/realtek/rtd129x.dtsi
@@ -2,14 +2,12 @@
 /*
  * Realtek RTD1293/RTD1295/RTD1296 SoC
  *
- * Copyright (c) 2016-2017 Andreas Färber
+ * Copyright (c) 2016-2019 Andreas Färber
  */
 
 /memreserve/	0x0000000000000000 0x0000000000030000;
-/memreserve/	0x000000000001f000 0x0000000000001000;
 /memreserve/	0x0000000000030000 0x00000000000d0000;
 /memreserve/	0x0000000001b00000 0x00000000004be000;
-/memreserve/	0x0000000001ffe000 0x0000000000004000;
 
 #include <dt-bindings/interrupt-controller/arm-gic.h>
 #include <dt-bindings/reset/realtek,rtd1295.h>
@@ -19,6 +17,25 @@
 	#address-cells = <1>;
 	#size-cells = <1>;
 
+	reserved-memory {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+
+		rpc_comm: rpc@1f000 {
+			reg = <0x1f000 0x1000>;
+		};
+
+		rpc_ringbuf: rpc@1ffe000 {
+			reg = <0x1ffe000 0x4000>;
+		};
+
+		tee: tee@10100000 {
+			reg = <0x10100000 0xf00000>;
+			no-map;
+		};
+	};
+
 	arm_pmu: arm-pmu {
 		compatible = "arm,cortex-a53-pmu";
 		interrupts = <GIC_SPI 48 IRQ_TYPE_LEVEL_HIGH>;


