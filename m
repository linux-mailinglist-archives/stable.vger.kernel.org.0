Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EB6E3837C8
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:46:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244476AbhEQPrG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:47:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:51388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344237AbhEQPnm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:43:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 033F361D1A;
        Mon, 17 May 2021 14:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262573;
        bh=yjeCTpBFeVmsrA3/JrZH+qARtm43WoxbaZoQG1cOiCM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TkDUyqwyib7VEHc5j8lZIpRi8S4HaBPLDgItI5gyYaC9gWAOTll5uj8j+AV1b0djj
         pwhMRqexuiw2GNtmSmBUcxXmY+pAB1p95njSy7rYtLorfbvT6LnvAhzZEyFDi4TCzD
         O4j+LTUL7MB4frJXTu5FuMAVASeLTQEhJvhriJmI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: [PATCH 5.11 323/329] dt-bindings: thermal: rcar-gen3-thermal: Support five TSC nodes on r8a779a0
Date:   Mon, 17 May 2021 16:03:54 +0200
Message-Id: <20210517140313.008767427@linuxfoundation.org>
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

From: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

commit 9468e7b031876935230182628f8d5f216c071784 upstream.

When adding support for V3U (r8a779a0) it was incorrectly recorded it
supports four nodes, while in fact it supports five. The fifth node is
named TSC0 and breaks the existing naming schema starting at 1. Work
around this by separately defining the reg property for V3U and others.

Restore the maximum number of nodes to three for other compatibles as
it was before erroneously increasing it for V3U.

Fixes: d7fdfb6541f3be88 ("dt-bindings: thermal: rcar-gen3-thermal: Add r8a779a0 support")
Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20210310110716.3297544-1-niklas.soderlund+renesas@ragnatech.se
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/thermal/rcar-gen3-thermal.yaml |   43 ++++++++--
 1 file changed, 35 insertions(+), 8 deletions(-)

--- a/Documentation/devicetree/bindings/thermal/rcar-gen3-thermal.yaml
+++ b/Documentation/devicetree/bindings/thermal/rcar-gen3-thermal.yaml
@@ -28,14 +28,7 @@ properties:
       - renesas,r8a77980-thermal # R-Car V3H
       - renesas,r8a779a0-thermal # R-Car V3U
 
-  reg:
-    minItems: 2
-    maxItems: 4
-    items:
-      - description: TSC1 registers
-      - description: TSC2 registers
-      - description: TSC3 registers
-      - description: TSC4 registers
+  reg: true
 
   interrupts:
     items:
@@ -71,8 +64,25 @@ if:
           enum:
             - renesas,r8a779a0-thermal
 then:
+  properties:
+    reg:
+      minItems: 2
+      maxItems: 3
+      items:
+        - description: TSC1 registers
+        - description: TSC2 registers
+        - description: TSC3 registers
   required:
     - interrupts
+else:
+  properties:
+    reg:
+      items:
+        - description: TSC0 registers
+        - description: TSC1 registers
+        - description: TSC2 registers
+        - description: TSC3 registers
+        - description: TSC4 registers
 
 additionalProperties: false
 
@@ -111,3 +121,20 @@ examples:
                     };
             };
     };
+  - |
+    #include <dt-bindings/clock/r8a779a0-cpg-mssr.h>
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+    #include <dt-bindings/power/r8a779a0-sysc.h>
+
+    tsc_r8a779a0: thermal@e6190000 {
+            compatible = "renesas,r8a779a0-thermal";
+            reg = <0xe6190000 0x200>,
+                  <0xe6198000 0x200>,
+                  <0xe61a0000 0x200>,
+                  <0xe61a8000 0x200>,
+                  <0xe61b0000 0x200>;
+            clocks = <&cpg CPG_MOD 919>;
+            power-domains = <&sysc R8A779A0_PD_ALWAYS_ON>;
+            resets = <&cpg 919>;
+            #thermal-sensor-cells = <1>;
+    };


