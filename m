Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 117254061A6
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:42:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240956AbhIJAnW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:43:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:43688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232664AbhIJATD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:19:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 265AD610E9;
        Fri, 10 Sep 2021 00:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233070;
        bh=LUd+G3+gj7ABxoZULKlb7MG8flMMf70NCfz1c3d0LQ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZI8ZlbzxGMSaEtpLoBa+m2moxHIEHI2934mBnb4KaGCeeH3thmGk3kaeMSl/h3yMw
         jAQFc7xuEs3qAPLirKa7cgIKR6xiBvLx2oaXwK2i3/cBX1a5fShxCWmf6Ga+GrMaIv
         V+e3RrOOdjPbOk0w3fEOcn0OwiCk6OisapNBn19iG/CBMD9W/BdpS8486wWuSGJ2w1
         +z6yvHjk7klz8/eXYnUJRtZtoW0m6M5ZEi5PqzWXCZJLHsi3dhP+D9xeZzVzccxvIM
         zK0QBPDjDT8CM5yX3KvezmVMnVj8Rmt+mbG9Paz+N+mVFKTivb1Nz+MQrhnrWqoPzN
         v8xrV/p9kIVew==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Rob Herring <robh@kernel.org>, Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-clk@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.14 80/99] dt-bindings: clock: brcm,iproc-clocks: fix armpll properties
Date:   Thu,  9 Sep 2021 20:15:39 -0400
Message-Id: <20210910001558.173296-80-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910001558.173296-1-sashal@kernel.org>
References: <20210910001558.173296-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

[ Upstream commit 6880d94f84262e721f7da6eaa41cd8fd5d87164c ]

armpll clocks (available on Cygnus and Northstar Plus) are simple clocks
with no cells. Adjust binding props #clock-cells and clock-output-names
to handle them.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Link: https://lore.kernel.org/r/20210819052918.6753-1-zajec5@gmail.com
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Rob Herring <robh@kernel.org>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../bindings/clock/brcm,iproc-clocks.yaml     | 27 +++++++++++++++++--
 1 file changed, 25 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/clock/brcm,iproc-clocks.yaml b/Documentation/devicetree/bindings/clock/brcm,iproc-clocks.yaml
index 1174c9aa9934..5ad147d265e6 100644
--- a/Documentation/devicetree/bindings/clock/brcm,iproc-clocks.yaml
+++ b/Documentation/devicetree/bindings/clock/brcm,iproc-clocks.yaml
@@ -61,13 +61,30 @@ properties:
     maxItems: 1
 
   '#clock-cells':
-    const: 1
+    true
 
   clock-output-names:
     minItems: 1
     maxItems: 45
 
 allOf:
+  - if:
+      properties:
+        compatible:
+          contains:
+            enum:
+              - brcm,cygnus-armpll
+              - brcm,nsp-armpll
+    then:
+      properties:
+        '#clock-cells':
+          const: 0
+    else:
+      properties:
+        '#clock-cells':
+          const: 1
+      required:
+        - clock-output-names
   - if:
       properties:
         compatible:
@@ -358,7 +375,6 @@ required:
   - reg
   - clocks
   - '#clock-cells'
-  - clock-output-names
 
 additionalProperties: false
 
@@ -392,3 +408,10 @@ examples:
         clocks = <&osc2>;
         clock-output-names = "keypad", "adc/touch", "pwm";
     };
+  - |
+    arm_clk@0 {
+        #clock-cells = <0>;
+        compatible = "brcm,nsp-armpll";
+        clocks = <&osc>;
+        reg = <0x0 0x1000>;
+    };
-- 
2.30.2

