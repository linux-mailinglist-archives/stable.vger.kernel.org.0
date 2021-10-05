Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE11442286F
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 15:50:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235378AbhJENwb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 09:52:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:58930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235289AbhJENwX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Oct 2021 09:52:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D830361506;
        Tue,  5 Oct 2021 13:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633441833;
        bh=by9GtSUX11HWhHVBkgN2q4BLfuacQPdQ+x5SSxgs4Kw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GAcG/n8fKBrrYTAeJnp790E2kaGkW0m4fP8bgu9aklUdM0LhRbLOXGmWlRjSozytS
         ZC46Z5TqRvx15p3imPunoA1MDJ88wjWWGKxPCJ/rZ/KhpyBahUXt12f1GHGGBLeBmm
         QgnpT8CM9YGl2z9zQrxz9sdnBuPux/wAoqQ8spTy/yH42AxaSK97pCOErjNBMgBQhr
         7tvxyjYCsZgSbdEAy+nAASNqD6RgotqZjAZhvk+seEUSRePVsP7QX0K2bRpFD176Ak
         zIlM5IacQYwquMrNB0sVypiD5xlmKzHgkSJ7ZGVR2M2xEI9kPtSW/3QeaFo6dpPI1Y
         pXrx/0Cz7L0+A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shawn Guo <shawn.guo@linaro.org>, Rob Herring <robh@kernel.org>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@somainline.org>,
        Georgi Djakov <djakov@kernel.org>,
        Sasha Levin <sashal@kernel.org>, agross@kernel.org,
        bjorn.andersson@linaro.org, robh+dt@kernel.org, kholk11@gmail.com,
        linux-arm-msm@vger.kernel.org, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 06/40] dt-bindings: interconnect: sdm660: Add missing a2noc qos clocks
Date:   Tue,  5 Oct 2021 09:49:45 -0400
Message-Id: <20211005135020.214291-6-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211005135020.214291-1-sashal@kernel.org>
References: <20211005135020.214291-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shawn Guo <shawn.guo@linaro.org>

[ Upstream commit cf49e366020396ad83845c1c3bdbaa3c1406f5ce ]

It adds the missing a2noc clocks required for QoS registers programming
per downstream kernel[1].

[1] https://source.codeaurora.org/quic/la/kernel/msm-4.4/tree/arch/arm/boot/dts/qcom/sdm660-bus.dtsi?h=LA.UM.8.2.r1-04800-sdm660.0#n43

Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
Reviewed-by: Rob Herring <robh@kernel.org>
Acked-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@somainline.org>
Link: https://lore.kernel.org/r/20210824043435.23190-2-shawn.guo@linaro.org
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../bindings/interconnect/qcom,sdm660.yaml    | 46 +++++++++++++++++--
 1 file changed, 42 insertions(+), 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/interconnect/qcom,sdm660.yaml b/Documentation/devicetree/bindings/interconnect/qcom,sdm660.yaml
index 29de7807df54..bcd41e491f1d 100644
--- a/Documentation/devicetree/bindings/interconnect/qcom,sdm660.yaml
+++ b/Documentation/devicetree/bindings/interconnect/qcom,sdm660.yaml
@@ -31,11 +31,11 @@ properties:
 
   clocks:
     minItems: 1
-    maxItems: 3
+    maxItems: 7
 
   clock-names:
     minItems: 1
-    maxItems: 3
+    maxItems: 7
 
 required:
   - compatible
@@ -72,6 +72,32 @@ allOf:
           contains:
             enum:
               - qcom,sdm660-a2noc
+    then:
+      properties:
+        clocks:
+          items:
+            - description: Bus Clock.
+            - description: Bus A Clock.
+            - description: IPA Clock.
+            - description: UFS AXI Clock.
+            - description: Aggregate2 UFS AXI Clock.
+            - description: Aggregate2 USB3 AXI Clock.
+            - description: Config NoC USB2 AXI Clock.
+        clock-names:
+          items:
+            - const: bus
+            - const: bus_a
+            - const: ipa
+            - const: ufs_axi
+            - const: aggre2_ufs_axi
+            - const: aggre2_usb3_axi
+            - const: cfg_noc_usb2_axi
+
+  - if:
+      properties:
+        compatible:
+          contains:
+            enum:
               - qcom,sdm660-bimc
               - qcom,sdm660-cnoc
               - qcom,sdm660-gnoc
@@ -91,6 +117,7 @@ examples:
   - |
       #include <dt-bindings/clock/qcom,rpmcc.h>
       #include <dt-bindings/clock/qcom,mmcc-sdm660.h>
+      #include <dt-bindings/clock/qcom,gcc-sdm660.h>
 
       bimc: interconnect@1008000 {
               compatible = "qcom,sdm660-bimc";
@@ -123,9 +150,20 @@ examples:
               compatible = "qcom,sdm660-a2noc";
               reg = <0x01704000 0xc100>;
               #interconnect-cells = <1>;
-              clock-names = "bus", "bus_a";
+              clock-names = "bus",
+                            "bus_a",
+                            "ipa",
+                            "ufs_axi",
+                            "aggre2_ufs_axi",
+                            "aggre2_usb3_axi",
+                            "cfg_noc_usb2_axi";
               clocks = <&rpmcc RPM_SMD_AGGR2_NOC_CLK>,
-                       <&rpmcc RPM_SMD_AGGR2_NOC_A_CLK>;
+                       <&rpmcc RPM_SMD_AGGR2_NOC_A_CLK>,
+                       <&rpmcc RPM_SMD_IPA_CLK>,
+                       <&gcc GCC_UFS_AXI_CLK>,
+                       <&gcc GCC_AGGRE2_UFS_AXI_CLK>,
+                       <&gcc GCC_AGGRE2_USB3_AXI_CLK>,
+                       <&gcc GCC_CFG_NOC_USB2_AXI_CLK>;
       };
 
       mnoc: interconnect@1745000 {
-- 
2.33.0

