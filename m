Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3C674B7899
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 21:52:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242700AbiBOUKa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 15:10:30 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241321AbiBOUKa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 15:10:30 -0500
Received: from lelv0143.ext.ti.com (lelv0143.ext.ti.com [198.47.23.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE835DB867;
        Tue, 15 Feb 2022 12:10:18 -0800 (PST)
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 21FKA9IH071778;
        Tue, 15 Feb 2022 14:10:09 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1644955809;
        bh=oRGfgk65UBNyDtOEXhs/elyUR2uWsKKCsKDcR1SgWNc=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=yRuKkDfob0k4EWbdO0JUvwzZPD7fQ0yAHvwGt6yOJOBy/92rFsP+3Brb0WbWAbU9g
         X7t+NUc+L5l2e0KIgIxAOqU9oFlKlU+rDRS4TwjlxY3l4obk2LDs64au4QIpw1FTVV
         P1kFfiTDIWPyKcQZ7TntlnZGTbedEn6IuDAS4u6o=
Received: from DFLE108.ent.ti.com (dfle108.ent.ti.com [10.64.6.29])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 21FKA9PB114900
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 15 Feb 2022 14:10:09 -0600
Received: from DFLE107.ent.ti.com (10.64.6.28) by DFLE108.ent.ti.com
 (10.64.6.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Tue, 15
 Feb 2022 14:10:09 -0600
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE107.ent.ti.com
 (10.64.6.28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14 via
 Frontend Transport; Tue, 15 Feb 2022 14:10:09 -0600
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 21FKA9sU114677;
        Tue, 15 Feb 2022 14:10:09 -0600
From:   Nishanth Menon <nm@ti.com>
To:     Tero Kristo <kristo@kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Marc Zyngier <maz@kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Rob Herring <robh+dt@kernel.org>, Nishanth Menon <nm@ti.com>,
        <stable@vger.kernel.org>
Subject: [PATCH 2/5] arm64: dts: ti: k3-j721e: Fix gic-v3 compatible regs
Date:   Tue, 15 Feb 2022 14:10:05 -0600
Message-ID: <20220215201008.15235-3-nm@ti.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220215201008.15235-1-nm@ti.com>
References: <20220215201008.15235-1-nm@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Though GIC ARE option is disabled for no GIC-v2 compatibility,
Cortex-A72 is free to implement the CPU interface as long as it
communicates with the GIC using the stream protocol. This requires
that the SoC integration mark out the PERIPHBASE[1] as reserved area
within the SoC. See longer discussion in [2] for further information.

Update the GIC register map to indicate offsets from PERIPHBASE based
on [3]. Without doing this, systems like kvm will not function with
gic-v2 emulation.

[1] https://developer.arm.com/documentation/100095/0002/system-control/aarch64-register-descriptions/configuration-base-address-register--el1
[2] https://lore.kernel.org/all/87k0e0tirw.wl-maz@kernel.org/
[3] https://developer.arm.com/documentation/100095/0002/way1382452674438

Fixes: 2d87061e70de ("arm64: dts: ti: Add Support for J721E SoC")
Cc: stable@vger.kernel.org # 5.10+
Reported-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Nishanth Menon <nm@ti.com>
---
Testing: based on next-20220215
j721e-sk: https://gist.github.com/nmenon/db3f29f2f241f1b5294c7e4054c3fbf1

 arch/arm64/boot/dts/ti/k3-j721e-main.dtsi | 5 ++++-
 arch/arm64/boot/dts/ti/k3-j721e.dtsi      | 1 +
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/ti/k3-j721e-main.dtsi b/arch/arm64/boot/dts/ti/k3-j721e-main.dtsi
index 599861259a30..db0669985e42 100644
--- a/arch/arm64/boot/dts/ti/k3-j721e-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-j721e-main.dtsi
@@ -76,7 +76,10 @@ gic500: interrupt-controller@1800000 {
 		#interrupt-cells = <3>;
 		interrupt-controller;
 		reg = <0x00 0x01800000 0x00 0x10000>,	/* GICD */
-		      <0x00 0x01900000 0x00 0x100000>;	/* GICR */
+		      <0x00 0x01900000 0x00 0x100000>,	/* GICR */
+		      <0x00 0x6f000000 0x00 0x2000>,	/* GICC */
+		      <0x00 0x6f010000 0x00 0x1000>,	/* GICH */
+		      <0x00 0x6f020000 0x00 0x2000>;	/* GICV */
 
 		/* vcpumntirq: virtual CPU interface maintenance interrupt */
 		interrupts = <GIC_PPI 9 IRQ_TYPE_LEVEL_HIGH>;
diff --git a/arch/arm64/boot/dts/ti/k3-j721e.dtsi b/arch/arm64/boot/dts/ti/k3-j721e.dtsi
index 4a3872fce533..0e23886c9fd1 100644
--- a/arch/arm64/boot/dts/ti/k3-j721e.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-j721e.dtsi
@@ -139,6 +139,7 @@ cbass_main: bus@100000 {
 			 <0x00 0x0e000000 0x00 0x0e000000 0x00 0x01800000>, /* PCIe Core*/
 			 <0x00 0x10000000 0x00 0x10000000 0x00 0x10000000>, /* PCIe DAT */
 			 <0x00 0x64800000 0x00 0x64800000 0x00 0x00800000>, /* C71 */
+			 <0x00 0x6f000000 0x00 0x6f000000 0x00 0x00310000>, /* A72 PERIPHBASE */
 			 <0x44 0x00000000 0x44 0x00000000 0x00 0x08000000>, /* PCIe2 DAT */
 			 <0x44 0x10000000 0x44 0x10000000 0x00 0x08000000>, /* PCIe3 DAT */
 			 <0x4d 0x80800000 0x4d 0x80800000 0x00 0x00800000>, /* C66_0 */
-- 
2.31.1

