Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71764658097
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:18:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234576AbiL1QS2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:18:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234561AbiL1QR5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:17:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37B34140A7
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:16:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C86566156B
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:16:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE07FC433EF;
        Wed, 28 Dec 2022 16:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244200;
        bh=D2nGL7fs+XPP1YjAsf8TRYWowaxa1PIxTxY2oyNpFV0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KybA8c2wO8WRtpS/VW7ch5eHcUBbcXsXkVf2q3NvueHKwjYCl2hxSDyfYdiqcrg6h
         MbORm+Au4vEuSaW0A6vbnD4mlTIZVkXmCSllJP0dCEG3ivYNOxIejCLUV6I2iCvo+q
         iDzZ7u1YbZk/OlTIeghNHsQ4UEBxeBsa85GaIx/s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Lorenzo Pieralisi <lpieralisi@kernel.org>,
        Rob Herring <robh@kernel.org>,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0628/1146] dt-bindings: imx6q-pcie: Fix clock names for imx6sx and imx8mq
Date:   Wed, 28 Dec 2022 15:36:07 +0100
Message-Id: <20221228144347.226913791@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Serge Semin <Sergey.Semin@baikalelectronics.ru>

[ Upstream commit b8a83e600bdde93e7da41ea3204b2b3832a3c99b ]

Originally as it was defined the legacy bindings the pcie_inbound_axi and
pcie_aux clock names were supposed to be used in the fsl,imx6sx-pcie and
fsl,imx8mq-pcie devices respectively. But the bindings conversion has been
incorrectly so now the fourth clock name is defined as "pcie_inbound_axi
for imx6sx-pcie, pcie_aux for imx8mq-pcie", which is completely wrong.
Let's fix that by conditionally apply the clock-names constraints based on
the compatible string content.

Link: https://lore.kernel.org/r/20221113191301.5526-2-Sergey.Semin@baikalelectronics.ru
Fixes: 751ca492f131 ("dt-bindings: PCI: imx6: convert the imx pcie controller to dtschema")
Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
Signed-off-by: Lorenzo Pieralisi <lpieralisi@kernel.org>
Reviewed-by: Rob Herring <robh@kernel.org>
Acked-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../bindings/pci/fsl,imx6q-pcie.yaml          | 46 +++++++++++++++++--
 1 file changed, 42 insertions(+), 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/pci/fsl,imx6q-pcie.yaml b/Documentation/devicetree/bindings/pci/fsl,imx6q-pcie.yaml
index 376e739bcad4..49b4f7a32e71 100644
--- a/Documentation/devicetree/bindings/pci/fsl,imx6q-pcie.yaml
+++ b/Documentation/devicetree/bindings/pci/fsl,imx6q-pcie.yaml
@@ -14,9 +14,6 @@ description: |+
   This PCIe host controller is based on the Synopsys DesignWare PCIe IP
   and thus inherits all the common properties defined in snps,dw-pcie.yaml.
 
-allOf:
-  - $ref: /schemas/pci/snps,dw-pcie.yaml#
-
 properties:
   compatible:
     enum:
@@ -61,7 +58,7 @@ properties:
       - const: pcie
       - const: pcie_bus
       - const: pcie_phy
-      - const: pcie_inbound_axi for imx6sx-pcie, pcie_aux for imx8mq-pcie
+      - enum: [ pcie_inbound_axi, pcie_aux ]
 
   num-lanes:
     const: 1
@@ -175,6 +172,47 @@ required:
   - clocks
   - clock-names
 
+allOf:
+  - $ref: /schemas/pci/snps,dw-pcie.yaml#
+  - if:
+      properties:
+        compatible:
+          contains:
+            const: fsl,imx6sx-pcie
+    then:
+      properties:
+        clock-names:
+          items:
+            - {}
+            - {}
+            - {}
+            - const: pcie_inbound_axi
+  - if:
+      properties:
+        compatible:
+          contains:
+            const: fsl,imx8mq-pcie
+    then:
+      properties:
+        clock-names:
+          items:
+            - {}
+            - {}
+            - {}
+            - const: pcie_aux
+  - if:
+      properties:
+        compatible:
+          not:
+            contains:
+              enum:
+                - fsl,imx6sx-pcie
+                - fsl,imx8mq-pcie
+    then:
+      properties:
+        clock-names:
+          maxItems: 3
+
 unevaluatedProperties: false
 
 examples:
-- 
2.35.1



