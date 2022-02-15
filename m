Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 852494B766E
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 21:49:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244026AbiBOUKi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 15:10:38 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244039AbiBOUKg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 15:10:36 -0500
Received: from fllv0016.ext.ti.com (fllv0016.ext.ti.com [198.47.19.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D35ED9BB94;
        Tue, 15 Feb 2022 12:10:25 -0800 (PST)
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 21FKA9un079920;
        Tue, 15 Feb 2022 14:10:09 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1644955809;
        bh=wDndPo2+ZSyz/0RP+/Q2sN3cxYrxLwrGelAqY+YSfyY=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=MZ2A0TAAprtkoEsU6OgtWS4dKU5Tr0j3bEI/EVt7eJFjLPbkoUZcTgkusghv9n4AP
         0PzpiL+nwRT4nEZyM9CDvXkkTRE8wrOOCOZY9X/ECM356Mf1eg1r4VFSU3NZl7b17d
         N9htT65SK0/XxC4TdzKdJ/QeLjR6i/p2iXp9sK+8=
Received: from DFLE112.ent.ti.com (dfle112.ent.ti.com [10.64.6.33])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 21FKA9JK068711
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 15 Feb 2022 14:10:09 -0600
Received: from DFLE102.ent.ti.com (10.64.6.23) by DFLE112.ent.ti.com
 (10.64.6.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Tue, 15
 Feb 2022 14:10:09 -0600
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE102.ent.ti.com
 (10.64.6.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14 via
 Frontend Transport; Tue, 15 Feb 2022 14:10:09 -0600
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 21FKA9S5057338;
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
Subject: [PATCH 1/5] arm64: dts: ti: k3-am65: Fix gic-v3 compatible regs
Date:   Tue, 15 Feb 2022 14:10:04 -0600
Message-ID: <20220215201008.15235-2-nm@ti.com>
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

Fixes: ea47eed33a3f ("arm64: dts: ti: Add Support for AM654 SoC")
Cc: stable@vger.kernel.org # 5.10+
Reported-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Nishanth Menon <nm@ti.com>
---

Testing: based on next-20220215
am65xx-evm Log: https://gist.github.com/nmenon/7e086c4d96d928429b9cd987a6e16b82

 arch/arm64/boot/dts/ti/k3-am65-main.dtsi | 5 ++++-
 arch/arm64/boot/dts/ti/k3-am65.dtsi      | 1 +
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am65-main.dtsi b/arch/arm64/boot/dts/ti/k3-am65-main.dtsi
index ce8bb4a61011..e749343acced 100644
--- a/arch/arm64/boot/dts/ti/k3-am65-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am65-main.dtsi
@@ -35,7 +35,10 @@ gic500: interrupt-controller@1800000 {
 		#interrupt-cells = <3>;
 		interrupt-controller;
 		reg = <0x00 0x01800000 0x00 0x10000>,	/* GICD */
-		      <0x00 0x01880000 0x00 0x90000>;	/* GICR */
+		      <0x00 0x01880000 0x00 0x90000>,	/* GICR */
+		      <0x00 0x6f000000 0x00 0x2000>,	/* GICC */
+		      <0x00 0x6f010000 0x00 0x1000>,	/* GICH */
+		      <0x00 0x6f020000 0x00 0x2000>;	/* GICV */
 		/*
 		 * vcpumntirq:
 		 * virtual CPU interface maintenance interrupt
diff --git a/arch/arm64/boot/dts/ti/k3-am65.dtsi b/arch/arm64/boot/dts/ti/k3-am65.dtsi
index a58a39fa42db..c538a0bf3cdd 100644
--- a/arch/arm64/boot/dts/ti/k3-am65.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am65.dtsi
@@ -86,6 +86,7 @@ cbass_main: bus@100000 {
 			 <0x00 0x46000000 0x00 0x46000000 0x00 0x00200000>,
 			 <0x00 0x47000000 0x00 0x47000000 0x00 0x00068400>,
 			 <0x00 0x50000000 0x00 0x50000000 0x00 0x8000000>,
+			 <0x00 0x6f000000 0x00 0x6f000000 0x00 0x00310000>, /* A53 PERIPHBASE */
 			 <0x00 0x70000000 0x00 0x70000000 0x00 0x200000>,
 			 <0x05 0x00000000 0x05 0x00000000 0x01 0x0000000>,
 			 <0x07 0x00000000 0x07 0x00000000 0x01 0x0000000>;
-- 
2.31.1

