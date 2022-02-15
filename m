Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 643AD4B7DC5
	for <lists+stable@lfdr.de>; Wed, 16 Feb 2022 03:51:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239689AbiBPClV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 21:41:21 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241668AbiBPClU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 21:41:20 -0500
X-Greylist: delayed 23446 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 15 Feb 2022 18:41:08 PST
Received: from fllv0015.ext.ti.com (fllv0015.ext.ti.com [198.47.19.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2042FBA73
        for <stable@vger.kernel.org>; Tue, 15 Feb 2022 18:41:08 -0800 (PST)
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 21FKA9AG018344;
        Tue, 15 Feb 2022 14:10:09 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1644955809;
        bh=BR4D+hjUIskCY8Md9XUYPrMPYdemIRpfn7ViphRKqsQ=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=bHdohnU4bVQqWcJcQbHxYqn6gTb0L6uBCQVqKYTtZRZngUHbcvv2PrHySopV1WYOx
         iZ/0zBCcWoUiTIiLUpmuhuFe9kLWCleMpe14KrtcheA4r22GXZtGRpWYt4Rev7VANR
         j6vqjvjjMuzUxlo6Z8vcj5EAuof1VHuDUPVOHEqU=
Received: from DFLE115.ent.ti.com (dfle115.ent.ti.com [10.64.6.36])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 21FKA9tb042430
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 15 Feb 2022 14:10:09 -0600
Received: from DFLE111.ent.ti.com (10.64.6.32) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Tue, 15
 Feb 2022 14:10:09 -0600
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE111.ent.ti.com
 (10.64.6.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14 via
 Frontend Transport; Tue, 15 Feb 2022 14:10:09 -0600
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 21FKA9Sg114680;
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
Subject: [PATCH 4/5] arm64: dts: ti: k3-am64: Fix gic-v3 compatible regs
Date:   Tue, 15 Feb 2022 14:10:07 -0600
Message-ID: <20220215201008.15235-5-nm@ti.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220215201008.15235-1-nm@ti.com>
References: <20220215201008.15235-1-nm@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Though GIC ARE option is disabled for no GIC-v2 compatibility,
Cortex-A53 is free to implement the CPU interface as long as it
communicates with the GIC using the stream protocol. This requires
that the SoC integration mark out the PERIPHBASE[1] as reserved area
within the SoC. See longer discussion in [2] for further information.

Update the GIC register map to indicate offsets from PERIPHBASE based
on [3]. Without doing this, systems like kvm will not function with
gic-v2 emulation.

[1] https://developer.arm.com/documentation/ddi0500/e/system-control/aarch64-register-descriptions/configuration-base-address-register--el1
[2] https://lore.kernel.org/all/87k0e0tirw.wl-maz@kernel.org/
[3] https://developer.arm.com/documentation/ddi0500/e/generic-interrupt-controller-cpu-interface/gic-programmers-model/memory-map

Fixes: 8abae9389bdb ("arm64: dts: ti: Add support for AM642 SoC")
Cc: stable@vger.kernel.org
Reported-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Nishanth Menon <nm@ti.com>
---
Testing: based on next-20220215

AM64xx-sk: https://gist.github.com/nmenon/75d413e53005fabc4bde8a4efe227594

 arch/arm64/boot/dts/ti/k3-am64-main.dtsi | 5 ++++-
 arch/arm64/boot/dts/ti/k3-am64.dtsi      | 1 +
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am64-main.dtsi b/arch/arm64/boot/dts/ti/k3-am64-main.dtsi
index 0c9f3bce8418..f64b368c6c37 100644
--- a/arch/arm64/boot/dts/ti/k3-am64-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am64-main.dtsi
@@ -59,7 +59,10 @@ gic500: interrupt-controller@1800000 {
 		#interrupt-cells = <3>;
 		interrupt-controller;
 		reg = <0x00 0x01800000 0x00 0x10000>,	/* GICD */
-		      <0x00 0x01840000 0x00 0xC0000>;	/* GICR */
+		      <0x00 0x01840000 0x00 0xC0000>,	/* GICR */
+		      <0x01 0x00000000 0x00 0x2000>,	/* GICC */
+		      <0x01 0x00010000 0x00 0x1000>,	/* GICH */
+		      <0x01 0x00020000 0x00 0x2000>;	/* GICV */
 		/*
 		 * vcpumntirq:
 		 * virtual CPU interface maintenance interrupt
diff --git a/arch/arm64/boot/dts/ti/k3-am64.dtsi b/arch/arm64/boot/dts/ti/k3-am64.dtsi
index 84bd07cd1824..e88349846871 100644
--- a/arch/arm64/boot/dts/ti/k3-am64.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am64.dtsi
@@ -89,6 +89,7 @@ cbass_main: bus@f4000 {
 			 <0x00 0x68000000 0x00 0x68000000 0x00 0x08000000>, /* PCIe DAT0 */
 			 <0x00 0x70000000 0x00 0x70000000 0x00 0x00200000>, /* OC SRAM */
 			 <0x00 0x78000000 0x00 0x78000000 0x00 0x00800000>, /* Main R5FSS */
+			 <0x01 0x00000000 0x01 0x00000000 0x00 0x00310000>, /* A53 PERIPHBASE */
 			 <0x06 0x00000000 0x06 0x00000000 0x01 0x00000000>, /* PCIe DAT1 */
 			 <0x05 0x00000000 0x05 0x00000000 0x01 0x00000000>, /* FSS0 DAT3 */
 
-- 
2.31.1

