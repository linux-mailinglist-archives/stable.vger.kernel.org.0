Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 829613837C7
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:46:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244681AbhEQPrF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:47:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:51344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344234AbhEQPni (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:43:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A30BB61D1D;
        Mon, 17 May 2021 14:42:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262569;
        bh=JwzO9mCEstcAbAC60jAhHeYtSsfctwpzPlwyw+po5SU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nCP+LQUas8Ru6YrDPw68h5pWLBd8VazXc0qORCATx4SbZzLObTwdcc0H1802AGXeF
         yOzr4hx5PllEEcs02mzP/KuljNoOlm7T9alReJVz0X1M+f/Rj97lK+nIsNDHzVIc4n
         BFrG4hsQl+dfsrPfIUVMzCI9owqsOwxhUB7NMUYE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH 5.11 322/329] dt-bindings: media: renesas,vin: Make resets optional on R-Car Gen1
Date:   Mon, 17 May 2021 16:03:53 +0200
Message-Id: <20210517140312.977703007@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.043055203@linuxfoundation.org>
References: <20210517140302.043055203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

commit 7935bb56e21b2add81149f4def8e59b4133fe57c upstream.

The "resets" property is not present on R-Car Gen1 SoCs.
Supporting it would require migrating from renesas,cpg-clocks to
renesas,cpg-mssr.

Fixes: 905fc6b1bfb4a631 ("dt-bindings: rcar-vin: Convert bindings to json-schema")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Link: https://lore.kernel.org/r/217c8197efaee7d803b22d433abb0ea8e33b84c6.1619700314.git.geert+renesas@glider.be
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/media/renesas,vin.yaml |   44 +++++++++------
 1 file changed, 28 insertions(+), 16 deletions(-)

--- a/Documentation/devicetree/bindings/media/renesas,vin.yaml
+++ b/Documentation/devicetree/bindings/media/renesas,vin.yaml
@@ -278,23 +278,35 @@ required:
   - interrupts
   - clocks
   - power-domains
-  - resets
 
-if:
-  properties:
-    compatible:
-      contains:
-        enum:
-          - renesas,vin-r8a7778
-          - renesas,vin-r8a7779
-          - renesas,rcar-gen2-vin
-then:
-  required:
-    - port
-else:
-  required:
-    - renesas,id
-    - ports
+allOf:
+  - if:
+      not:
+        properties:
+          compatible:
+            contains:
+              enum:
+                - renesas,vin-r8a7778
+                - renesas,vin-r8a7779
+    then:
+      required:
+        - resets
+
+  - if:
+      properties:
+        compatible:
+          contains:
+            enum:
+              - renesas,vin-r8a7778
+              - renesas,vin-r8a7779
+              - renesas,rcar-gen2-vin
+    then:
+      required:
+        - port
+    else:
+      required:
+        - renesas,id
+        - ports
 
 additionalProperties: false
 


