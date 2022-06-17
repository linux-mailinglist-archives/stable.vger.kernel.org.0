Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 998DB54FF66
	for <lists+stable@lfdr.de>; Fri, 17 Jun 2022 23:35:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232790AbiFQVfL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jun 2022 17:35:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231941AbiFQVfK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Jun 2022 17:35:10 -0400
Received: from fllv0016.ext.ti.com (fllv0016.ext.ti.com [198.47.19.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6784942488
        for <stable@vger.kernel.org>; Fri, 17 Jun 2022 14:35:09 -0700 (PDT)
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 25HLZ7j5074867
        for <stable@vger.kernel.org>; Fri, 17 Jun 2022 16:35:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1655501707;
        bh=hgbzgVrSZOFXI6edkMYQtyhHMOrZPrVQzXWEdlwt1Sk=;
        h=From:To:Subject:Date;
        b=QoRJKwVzCfc0QOpNU81VHsbZ/0dQt2XXagx8hXihJrSaiRhAWei/u8SjofxD6wsQ1
         yV3sUf8BJMqdDaLhjQuTmF6xopAckTiMhV/rxdztdrZkpxUDVGZf4+HN5ZGYQtJbpJ
         RfATTjxWsxSDeRzxESlfcJaMuI6q101FXJDceaOw=
Received: from DFLE105.ent.ti.com (dfle105.ent.ti.com [10.64.6.26])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 25HLZ7sI046161
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <stable@vger.kernel.org>; Fri, 17 Jun 2022 16:35:07 -0500
Received: from DFLE102.ent.ti.com (10.64.6.23) by DFLE105.ent.ti.com
 (10.64.6.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Fri, 17
 Jun 2022 16:35:07 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE102.ent.ti.com
 (10.64.6.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14 via
 Frontend Transport; Fri, 17 Jun 2022 16:35:07 -0500
Received: from ubuntu.ent.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 25HLZ3tq124810
        for <stable@vger.kernel.org>; Fri, 17 Jun 2022 16:35:05 -0500
From:   Matt Ranostay <mranostay@ti.com>
To:     <stable@vger.kernel.org>
Subject: [PATCH v3] arm64: dts: ti: k3-j721s2: fix overlapping GICD memory region
Date:   Fri, 17 Jun 2022 14:35:01 -0700
Message-ID: <20220617213501.451061-1-mranostay@ti.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

GICD region was overlapping with GICR causing the latter to not map
successfully, and in turn the gic-v3 driver would fail to initialize.

This issue was hidden till commit 2b2cd74a06c3 ("irqchip/gic-v3: Claim
iomem resources") replaced of_iomap() calls with of_io_request_and_map()
that internally called request_mem_region().

Respective console output before this patchset:

[    0.000000] GICv3: /bus@100000/interrupt-controller@1800000: couldn't map region 0

Fixes: b8545f9d3a54 ("arm64: dts: ti: Add initial support for J721S2 SoC")
Cc: Marc Zyngier <maz@kernel.org>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Nishanth Menon <nm@ti.com>
Acked-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Matt Ranostay <mranostay@ti.com>
---
 arch/arm64/boot/dts/ti/k3-j721s2-main.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Changes from v1:
* Add missing Fixes: in commit messages

Changes from v2:
* Corrected Fixes: tag to actual commit that introduced the issue
* Fixed word wrapping in commit message

NOTE: incorrect linux stable address was used for v3, resubmitted to only
this list with the Marc's Acked-By

diff --git a/arch/arm64/boot/dts/ti/k3-j721s2-main.dtsi b/arch/arm64/boot/dts/ti/k3-j721s2-main.dtsi
index be7f39299894..19966f72c5b3 100644
--- a/arch/arm64/boot/dts/ti/k3-j721s2-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-j721s2-main.dtsi
@@ -33,7 +33,7 @@ gic500: interrupt-controller@1800000 {
 		ranges;
 		#interrupt-cells = <3>;
 		interrupt-controller;
-		reg = <0x00 0x01800000 0x00 0x200000>, /* GICD */
+		reg = <0x00 0x01800000 0x00 0x100000>, /* GICD */
 		      <0x00 0x01900000 0x00 0x100000>, /* GICR */
 		      <0x00 0x6f000000 0x00 0x2000>,   /* GICC */
 		      <0x00 0x6f010000 0x00 0x1000>,   /* GICH */
-- 
2.36.1

