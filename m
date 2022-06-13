Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB158548B4B
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:09:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377524AbiFMNdK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:33:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378339AbiFMNbW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:31:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 489A170344;
        Mon, 13 Jun 2022 04:25:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 630E361120;
        Mon, 13 Jun 2022 11:25:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73179C3411C;
        Mon, 13 Jun 2022 11:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655119556;
        bh=X7YenglVW5w/0CfOMVL6Ir5FPNow7NRwNMizl+2C09c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VzewI+hD1GnUZ5+c2sH9R1Eakj0OJnfpbqXoFJBtS5v12oy78iAzTlFl7N3uKMoPx
         gsupeErlbPNVyXvLLUrdIShQ8h2wdwJIgxy/ysOHmo+a2MaGJVqiHGGaQ3GnV65lW9
         jAVpfUS8aUrd7WrQsizrMrUPGdD+pekM+mlA70Ps=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" 
        <nfraprado@collabora.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 056/339] dt-bindings: remoteproc: mediatek: Make l1tcm reg exclusive to mt819x
Date:   Mon, 13 Jun 2022 12:08:01 +0200
Message-Id: <20220613094928.221846138@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
References: <20220613094926.497929857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAD_ENC_HEADER,BAYES_00,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nícolas F. R. A. Prado <nfraprado@collabora.com>

[ Upstream commit 6bbe1065121b8cd3b3e734ef8cd99f142bdab241 ]

Commit ca23ecfdbd44 ("remoteproc/mediatek: support L1TCM") added support
for the l1tcm memory region on the MT8192 SCP, adding a new da_to_va
callback that handles l1tcm while keeping the old one for
back-compatibility with MT8183. However, since the mt8192 compatible was
missing from the dt-binding, the accompanying dt-binding commit
503c64cc42f1 ("dt-bindings: remoteproc: mediatek: add L1TCM memory region")
mistakenly added this reg as if it were for mt8183. And later
it became common to all platforms as their compatibles were added.

Fix the dt-binding so that the l1tcm reg can be present only on the
supported platforms: mt8192 and mt8195.

Fixes: 503c64cc42f1 ("dt-bindings: remoteproc: mediatek: add L1TCM memory region")
Signed-off-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20220511195452.871897-2-nfraprado@collabora.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../bindings/remoteproc/mtk,scp.yaml          | 44 +++++++++++++------
 1 file changed, 30 insertions(+), 14 deletions(-)

diff --git a/Documentation/devicetree/bindings/remoteproc/mtk,scp.yaml b/Documentation/devicetree/bindings/remoteproc/mtk,scp.yaml
index 5b693a2d049c..d55b861db605 100644
--- a/Documentation/devicetree/bindings/remoteproc/mtk,scp.yaml
+++ b/Documentation/devicetree/bindings/remoteproc/mtk,scp.yaml
@@ -23,11 +23,13 @@ properties:
 
   reg:
     description:
-      Should contain the address ranges for memory regions SRAM, CFG, and
-      L1TCM.
+      Should contain the address ranges for memory regions SRAM, CFG, and,
+      on some platforms, L1TCM.
+    minItems: 2
     maxItems: 3
 
   reg-names:
+    minItems: 2
     items:
       - const: sram
       - const: cfg
@@ -47,16 +49,30 @@ required:
   - reg
   - reg-names
 
-if:
-  properties:
-    compatible:
-      enum:
-        - mediatek,mt8183-scp
-        - mediatek,mt8192-scp
-then:
-  required:
-    - clocks
-    - clock-names
+allOf:
+  - if:
+      properties:
+        compatible:
+          enum:
+            - mediatek,mt8183-scp
+            - mediatek,mt8192-scp
+    then:
+      required:
+        - clocks
+        - clock-names
+
+  - if:
+      properties:
+        compatible:
+          enum:
+            - mediatek,mt8183-scp
+            - mediatek,mt8186-scp
+    then:
+      properties:
+        reg:
+          maxItems: 2
+        reg-names:
+          maxItems: 2
 
 additionalProperties:
   type: object
@@ -76,10 +92,10 @@ additionalProperties:
 
 examples:
   - |
-    #include <dt-bindings/clock/mt8183-clk.h>
+    #include <dt-bindings/clock/mt8192-clk.h>
 
     scp@10500000 {
-        compatible = "mediatek,mt8183-scp";
+        compatible = "mediatek,mt8192-scp";
         reg = <0x10500000 0x80000>,
               <0x10700000 0x8000>,
               <0x10720000 0xe0000>;
-- 
2.35.1



