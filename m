Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8188595076
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 06:42:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231626AbiHPEmS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 00:42:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232259AbiHPEk7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 00:40:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC217CC337;
        Mon, 15 Aug 2022 13:33:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AAB9C61072;
        Mon, 15 Aug 2022 20:33:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99A8EC433C1;
        Mon, 15 Aug 2022 20:33:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595584;
        bh=O1pFYaTsAQWDajFRfQ6pbZr1nVyv40meCohgbHKs3lw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m4rsiZh+XM+tCSAme+nS8iQgwyg969xo0Bunhu0/3KWqjPr7+Mm9EcF7ue0YoTGPi
         Fme+CAjFEGM8kK8Jb0e5ZKZj3d3zIYtbFhAotnIy1O0d6LEipU3hQ6b0ovoDrbW0Kk
         pfK72ThkRp0DlO5fxV9YMfAzcmXnb90aVVYQab2Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Rob Herring <robh@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Bhupesh Sharma <bhupesh.sharma@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0793/1157] dt-bindings: mmc: sdhci-msm: Fix issues in yaml bindings
Date:   Mon, 15 Aug 2022 20:02:29 +0200
Message-Id: <20220815180511.201457858@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bhupesh Sharma <bhupesh.sharma@linaro.org>

[ Upstream commit 8574adf5222d786b747022c6edcbcdddf409a139 ]

Rob pointed some remaining issues in the sdhci-msm yaml
bindings (via [1]).

Fix the same by first using the 'mmc-controller.yaml' as
'ref' and thereafter also fix the issues reported by
'make dtbs_check' check.

[1]. https://lore.kernel.org/linux-arm-msm/YnLmNCwNfoqZln12@robh.at.kernel.org/

Fixes: a45537723f4b ("dt-bindings: mmc: sdhci-msm: Convert bindings to yaml")
Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Rob Herring <robh@kernel.org>
Cc: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
Link: https://lore.kernel.org/r/20220514220116.1008254-1-bhupesh.sharma@linaro.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../devicetree/bindings/mmc/sdhci-msm.yaml    | 52 ++++++++++++++++---
 1 file changed, 44 insertions(+), 8 deletions(-)

diff --git a/Documentation/devicetree/bindings/mmc/sdhci-msm.yaml b/Documentation/devicetree/bindings/mmc/sdhci-msm.yaml
index e4236334e748..31a3ce208e1a 100644
--- a/Documentation/devicetree/bindings/mmc/sdhci-msm.yaml
+++ b/Documentation/devicetree/bindings/mmc/sdhci-msm.yaml
@@ -17,6 +17,9 @@ description:
 properties:
   compatible:
     oneOf:
+      - enum:
+          - qcom,sdhci-msm-v4
+        deprecated: true
       - items:
           - enum:
               - qcom,apq8084-sdhci
@@ -27,6 +30,9 @@ properties:
               - qcom,msm8992-sdhci
               - qcom,msm8994-sdhci
               - qcom,msm8996-sdhci
+          - const: qcom,sdhci-msm-v4 # for sdcc versions less than 5.0
+      - items:
+          - enum:
               - qcom,qcs404-sdhci
               - qcom,sc7180-sdhci
               - qcom,sc7280-sdhci
@@ -38,12 +44,7 @@ properties:
               - qcom,sm6350-sdhci
               - qcom,sm8150-sdhci
               - qcom,sm8250-sdhci
-          - enum:
-              - qcom,sdhci-msm-v4 # for sdcc versions less than 5.0
-              - qcom,sdhci-msm-v5 # for sdcc version 5.0
-      - items:
-          - const: qcom,sdhci-msm-v4 # Deprecated (only for backward compatibility)
-                                     # for sdcc versions less than 5.0
+          - const: qcom,sdhci-msm-v5 # for sdcc version 5.0
 
   reg:
     minItems: 1
@@ -53,6 +54,28 @@ properties:
       - description: CQE register map
       - description: Inline Crypto Engine register map
 
+  reg-names:
+    minItems: 1
+    maxItems: 4
+    oneOf:
+      - items:
+          - const: hc_mem
+      - items:
+          - const: hc_mem
+          - const: core_mem
+      - items:
+          - const: hc_mem
+          - const: cqe_mem
+      - items:
+          - const: hc_mem
+          - const: cqe_mem
+          - const: ice_mem
+      - items:
+          - const: hc_mem
+          - const: core_mem
+          - const: cqe_mem
+          - const: ice_mem
+
   clocks:
     minItems: 3
     items:
@@ -121,6 +144,16 @@ properties:
     description: A phandle to sdhci power domain node
     maxItems: 1
 
+  mmc-ddr-1_8v: true
+
+  mmc-hs200-1_8v: true
+
+  mmc-hs400-1_8v: true
+
+  bus-width: true
+
+  max-frequency: true
+
 patternProperties:
   '^opp-table(-[a-z0-9]+)?$':
     if:
@@ -140,7 +173,10 @@ required:
   - clock-names
   - interrupts
 
-additionalProperties: true
+allOf:
+  - $ref: mmc-controller.yaml#
+
+unevaluatedProperties: false
 
 examples:
   - |
@@ -149,7 +185,7 @@ examples:
     #include <dt-bindings/clock/qcom,rpmh.h>
     #include <dt-bindings/power/qcom-rpmpd.h>
 
-    sdhc_2: sdhci@8804000 {
+    sdhc_2: mmc@8804000 {
       compatible = "qcom,sm8250-sdhci", "qcom,sdhci-msm-v5";
       reg = <0 0x08804000 0 0x1000>;
 
-- 
2.35.1



