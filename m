Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D2A629BCBD
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:41:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1811050AbgJ0Qgz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 12:36:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:48682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750974AbgJ0Pse (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:48:34 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1469A2225E;
        Tue, 27 Oct 2020 15:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813711;
        bh=Quqap/NLxG1ycI7mWO2Pbfxn/SR0a66h6M1r3frzxbw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nVt/LndvAHvIF9iiZARiAoL0xEsYpft4oIH2DZ0C7x3vHbiiyoDeIJjcZvyRk4y+1
         ZPps4zv94/ncQmeKERZxg17s8x/iwBFOkVYRrWG946b+07rQ11lZBXJmrn/UNnRoOD
         A0z0B0n/4N6Y7/yQX9yqRmV4jT3MrYVt/b7YI/fk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Rosin <peda@axentia.se>,
        Roger Quadros <rogerq@ti.com>, Nishanth Menon <nm@ti.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 613/757] arm64: dts: ti: k3-j721e: Rename mux header and update macro names
Date:   Tue, 27 Oct 2020 14:54:23 +0100
Message-Id: <20201027135519.304396441@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roger Quadros <rogerq@ti.com>

[ Upstream commit c65176fd49f45bd5a5ffaa1790109745d1fa462c ]

We intend to use one header file for SERDES MUX for all
TI SoCs so rename the header file.

The exsting macros are too generic. Prefix them with SoC name.

While at that, add the missing configurations for completeness.

Fixes: b766e3b0d5f6 ("arm64: dts: ti: k3-j721e-main: Add system controller node and SERDES lane mux")
Reported-by: Peter Rosin <peda@axentia.se>
Signed-off-by: Roger Quadros <rogerq@ti.com>
Signed-off-by: Nishanth Menon <nm@ti.com>
Acked-by: Peter Rosin <peda@axentia.se>
Link: https://lore.kernel.org/r/20200918165930.2031-1-rogerq@ti.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../dts/ti/k3-j721e-common-proc-board.dts     | 11 +--
 arch/arm64/boot/dts/ti/k3-j721e-main.dtsi     | 13 ++--
 include/dt-bindings/mux/mux-j721e-wiz.h       | 53 --------------
 include/dt-bindings/mux/ti-serdes.h           | 71 +++++++++++++++++++
 4 files changed, 84 insertions(+), 64 deletions(-)
 delete mode 100644 include/dt-bindings/mux/mux-j721e-wiz.h
 create mode 100644 include/dt-bindings/mux/ti-serdes.h

diff --git a/arch/arm64/boot/dts/ti/k3-j721e-common-proc-board.dts b/arch/arm64/boot/dts/ti/k3-j721e-common-proc-board.dts
index e8fc01d97adad..6f7490efc438b 100644
--- a/arch/arm64/boot/dts/ti/k3-j721e-common-proc-board.dts
+++ b/arch/arm64/boot/dts/ti/k3-j721e-common-proc-board.dts
@@ -404,11 +404,12 @@ &usb_serdes_mux {
 };
 
 &serdes_ln_ctrl {
-	idle-states = <SERDES0_LANE0_PCIE0_LANE0>, <SERDES0_LANE1_PCIE0_LANE1>,
-		      <SERDES1_LANE0_PCIE1_LANE0>, <SERDES1_LANE1_PCIE1_LANE1>,
-		      <SERDES2_LANE0_PCIE2_LANE0>, <SERDES2_LANE1_PCIE2_LANE1>,
-		      <SERDES3_LANE0_USB3_0_SWAP>, <SERDES3_LANE1_USB3_0>,
-		      <SERDES4_LANE0_EDP_LANE0>, <SERDES4_LANE1_EDP_LANE1>, <SERDES4_LANE2_EDP_LANE2>, <SERDES4_LANE3_EDP_LANE3>;
+	idle-states = <J721E_SERDES0_LANE0_PCIE0_LANE0>, <J721E_SERDES0_LANE1_PCIE0_LANE1>,
+		      <J721E_SERDES1_LANE0_PCIE1_LANE0>, <J721E_SERDES1_LANE1_PCIE1_LANE1>,
+		      <J721E_SERDES2_LANE0_PCIE2_LANE0>, <J721E_SERDES2_LANE1_PCIE2_LANE1>,
+		      <J721E_SERDES3_LANE0_USB3_0_SWAP>, <J721E_SERDES3_LANE1_USB3_0>,
+		      <J721E_SERDES4_LANE0_EDP_LANE0>, <J721E_SERDES4_LANE1_EDP_LANE1>,
+		      <J721E_SERDES4_LANE2_EDP_LANE2>, <J721E_SERDES4_LANE3_EDP_LANE3>;
 };
 
 &serdes_wiz3 {
diff --git a/arch/arm64/boot/dts/ti/k3-j721e-main.dtsi b/arch/arm64/boot/dts/ti/k3-j721e-main.dtsi
index 12ceea9b3c9ae..63d221aee9bc0 100644
--- a/arch/arm64/boot/dts/ti/k3-j721e-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-j721e-main.dtsi
@@ -6,7 +6,7 @@
  */
 #include <dt-bindings/phy/phy.h>
 #include <dt-bindings/mux/mux.h>
-#include <dt-bindings/mux/mux-j721e-wiz.h>
+#include <dt-bindings/mux/ti-serdes.h>
 
 &cbass_main {
 	msmc_ram: sram@70000000 {
@@ -38,11 +38,12 @@ serdes_ln_ctrl: serdes-ln-ctrl@4080 {
 					<0x40b0 0x3>, <0x40b4 0x3>, /* SERDES3 lane0/1 select */
 					<0x40c0 0x3>, <0x40c4 0x3>, <0x40c8 0x3>, <0x40cc 0x3>;
 					/* SERDES4 lane0/1/2/3 select */
-			idle-states = <SERDES0_LANE0_PCIE0_LANE0>, <SERDES0_LANE1_PCIE0_LANE1>,
-				      <SERDES1_LANE0_PCIE1_LANE0>, <SERDES1_LANE1_PCIE1_LANE1>,
-				      <SERDES2_LANE0_PCIE2_LANE0>, <SERDES2_LANE1_PCIE2_LANE1>,
-				      <MUX_IDLE_AS_IS>, <SERDES3_LANE1_USB3_0>,
-				      <SERDES4_LANE0_EDP_LANE0>, <SERDES4_LANE1_EDP_LANE1>, <SERDES4_LANE2_EDP_LANE2>, <SERDES4_LANE3_EDP_LANE3>;
+			idle-states = <J721E_SERDES0_LANE0_PCIE0_LANE0>, <J721E_SERDES0_LANE1_PCIE0_LANE1>,
+				      <J721E_SERDES1_LANE0_PCIE1_LANE0>, <J721E_SERDES1_LANE1_PCIE1_LANE1>,
+				      <J721E_SERDES2_LANE0_PCIE2_LANE0>, <J721E_SERDES2_LANE1_PCIE2_LANE1>,
+				      <MUX_IDLE_AS_IS>, <J721E_SERDES3_LANE1_USB3_0>,
+				      <J721E_SERDES4_LANE0_EDP_LANE0>, <J721E_SERDES4_LANE1_EDP_LANE1>,
+				      <J721E_SERDES4_LANE2_EDP_LANE2>, <J721E_SERDES4_LANE3_EDP_LANE3>;
 		};
 
 		usb_serdes_mux: mux-controller@4000 {
diff --git a/include/dt-bindings/mux/mux-j721e-wiz.h b/include/dt-bindings/mux/mux-j721e-wiz.h
deleted file mode 100644
index fd1c4ea9fc7f0..0000000000000
--- a/include/dt-bindings/mux/mux-j721e-wiz.h
+++ /dev/null
@@ -1,53 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-/*
- * This header provides constants for J721E WIZ.
- */
-
-#ifndef _DT_BINDINGS_J721E_WIZ
-#define _DT_BINDINGS_J721E_WIZ
-
-#define SERDES0_LANE0_QSGMII_LANE1	0x0
-#define SERDES0_LANE0_PCIE0_LANE0	0x1
-#define SERDES0_LANE0_USB3_0_SWAP	0x2
-
-#define SERDES0_LANE1_QSGMII_LANE2	0x0
-#define SERDES0_LANE1_PCIE0_LANE1	0x1
-#define SERDES0_LANE1_USB3_0		0x2
-
-#define SERDES1_LANE0_QSGMII_LANE3	0x0
-#define SERDES1_LANE0_PCIE1_LANE0	0x1
-#define SERDES1_LANE0_USB3_1_SWAP	0x2
-#define SERDES1_LANE0_SGMII_LANE0	0x3
-
-#define SERDES1_LANE1_QSGMII_LANE4	0x0
-#define SERDES1_LANE1_PCIE1_LANE1	0x1
-#define SERDES1_LANE1_USB3_1		0x2
-#define SERDES1_LANE1_SGMII_LANE1	0x3
-
-#define SERDES2_LANE0_PCIE2_LANE0	0x1
-#define SERDES2_LANE0_SGMII_LANE0	0x3
-#define SERDES2_LANE0_USB3_1_SWAP	0x2
-
-#define SERDES2_LANE1_PCIE2_LANE1	0x1
-#define SERDES2_LANE1_USB3_1		0x2
-#define SERDES2_LANE1_SGMII_LANE1	0x3
-
-#define SERDES3_LANE0_PCIE3_LANE0	0x1
-#define SERDES3_LANE0_USB3_0_SWAP	0x2
-
-#define SERDES3_LANE1_PCIE3_LANE1	0x1
-#define SERDES3_LANE1_USB3_0		0x2
-
-#define SERDES4_LANE0_EDP_LANE0		0x0
-#define SERDES4_LANE0_QSGMII_LANE5	0x2
-
-#define SERDES4_LANE1_EDP_LANE1		0x0
-#define SERDES4_LANE1_QSGMII_LANE6	0x2
-
-#define SERDES4_LANE2_EDP_LANE2		0x0
-#define SERDES4_LANE2_QSGMII_LANE7	0x2
-
-#define SERDES4_LANE3_EDP_LANE3		0x0
-#define SERDES4_LANE3_QSGMII_LANE8	0x2
-
-#endif /* _DT_BINDINGS_J721E_WIZ */
diff --git a/include/dt-bindings/mux/ti-serdes.h b/include/dt-bindings/mux/ti-serdes.h
new file mode 100644
index 0000000000000..146d0685a9251
--- /dev/null
+++ b/include/dt-bindings/mux/ti-serdes.h
@@ -0,0 +1,71 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * This header provides constants for SERDES MUX for TI SoCs
+ */
+
+#ifndef _DT_BINDINGS_MUX_TI_SERDES
+#define _DT_BINDINGS_MUX_TI_SERDES
+
+/* J721E */
+
+#define J721E_SERDES0_LANE0_QSGMII_LANE1	0x0
+#define J721E_SERDES0_LANE0_PCIE0_LANE0		0x1
+#define J721E_SERDES0_LANE0_USB3_0_SWAP		0x2
+#define J721E_SERDES0_LANE0_IP4_UNUSED		0x3
+
+#define J721E_SERDES0_LANE1_QSGMII_LANE2	0x0
+#define J721E_SERDES0_LANE1_PCIE0_LANE1		0x1
+#define J721E_SERDES0_LANE1_USB3_0		0x2
+#define J721E_SERDES0_LANE1_IP4_UNUSED		0x3
+
+#define J721E_SERDES1_LANE0_QSGMII_LANE3	0x0
+#define J721E_SERDES1_LANE0_PCIE1_LANE0		0x1
+#define J721E_SERDES1_LANE0_USB3_1_SWAP		0x2
+#define J721E_SERDES1_LANE0_SGMII_LANE0		0x3
+
+#define J721E_SERDES1_LANE1_QSGMII_LANE4	0x0
+#define J721E_SERDES1_LANE1_PCIE1_LANE1		0x1
+#define J721E_SERDES1_LANE1_USB3_1		0x2
+#define J721E_SERDES1_LANE1_SGMII_LANE1		0x3
+
+#define J721E_SERDES2_LANE0_IP1_UNUSED		0x0
+#define J721E_SERDES2_LANE0_PCIE2_LANE0		0x1
+#define J721E_SERDES2_LANE0_USB3_1_SWAP		0x2
+#define J721E_SERDES2_LANE0_SGMII_LANE0		0x3
+
+#define J721E_SERDES2_LANE1_IP1_UNUSED		0x0
+#define J721E_SERDES2_LANE1_PCIE2_LANE1		0x1
+#define J721E_SERDES2_LANE1_USB3_1		0x2
+#define J721E_SERDES2_LANE1_SGMII_LANE1		0x3
+
+#define J721E_SERDES3_LANE0_IP1_UNUSED		0x0
+#define J721E_SERDES3_LANE0_PCIE3_LANE0		0x1
+#define J721E_SERDES3_LANE0_USB3_0_SWAP		0x2
+#define J721E_SERDES3_LANE0_IP4_UNUSED		0x3
+
+#define J721E_SERDES3_LANE1_IP1_UNUSED		0x0
+#define J721E_SERDES3_LANE1_PCIE3_LANE1		0x1
+#define J721E_SERDES3_LANE1_USB3_0		0x2
+#define J721E_SERDES3_LANE1_IP4_UNUSED		0x3
+
+#define J721E_SERDES4_LANE0_EDP_LANE0		0x0
+#define J721E_SERDES4_LANE0_IP2_UNUSED		0x1
+#define J721E_SERDES4_LANE0_QSGMII_LANE5	0x2
+#define J721E_SERDES4_LANE0_IP4_UNUSED		0x3
+
+#define J721E_SERDES4_LANE1_EDP_LANE1		0x0
+#define J721E_SERDES4_LANE1_IP2_UNUSED		0x1
+#define J721E_SERDES4_LANE1_QSGMII_LANE6	0x2
+#define J721E_SERDES4_LANE1_IP4_UNUSED		0x3
+
+#define J721E_SERDES4_LANE2_EDP_LANE2		0x0
+#define J721E_SERDES4_LANE2_IP2_UNUSED		0x1
+#define J721E_SERDES4_LANE2_QSGMII_LANE7	0x2
+#define J721E_SERDES4_LANE2_IP4_UNUSED		0x3
+
+#define J721E_SERDES4_LANE3_EDP_LANE3		0x0
+#define J721E_SERDES4_LANE3_IP2_UNUSED		0x1
+#define J721E_SERDES4_LANE3_QSGMII_LANE8	0x2
+#define J721E_SERDES4_LANE3_IP4_UNUSED		0x3
+
+#endif /* _DT_BINDINGS_MUX_TI_SERDES */
-- 
2.25.1



