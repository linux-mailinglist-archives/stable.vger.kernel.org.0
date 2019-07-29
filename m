Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EF107962B
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 21:49:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390534AbfG2Tt0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:49:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:39952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390530AbfG2Tt0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:49:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB4CA21655;
        Mon, 29 Jul 2019 19:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564429765;
        bh=Fp1/PCJzmmL4q7pkcIlbBIawt4Iaunw6ZRL7LHFPzwg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iacrIsBLW+tmPO7DywqNF2DwLyOE5aLDrlaKQYmN0iwXx8r82PLj+udb+HzprTGmY
         sy0y9uCEMoq5YGjgyHXR+zYwbbPukAFZ5TdQ0ON8QtY6HZCSNaa2umgAJCGxb/+dp1
         S2pyDTfPOXWS7h5gjXUMk2zzdNxdwhJsDmXemkOg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brian Masney <masneyb@onstation.org>,
        Rob Herring <robh+dt@kernel.org>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Dan Murphy <dmurphy@ti.com>, Rob Herring <robh@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 089/215] dt-bindings: backlight: lm3630a: correct schema validation
Date:   Mon, 29 Jul 2019 21:21:25 +0200
Message-Id: <20190729190754.820886392@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190739.971253303@linuxfoundation.org>
References: <20190729190739.971253303@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit ef4db28c1f45cda6989bc8a8e45294894786d947 ]

The '#address-cells' and '#size-cells' properties were not defined in
the lm3630a bindings and would cause the following error when
attempting to validate the examples against the schema:

Documentation/devicetree/bindings/leds/backlight/lm3630a-backlight.example.dt.yaml:
'#address-cells', '#size-cells' do not match any of the regexes:
'^led@[01]$', 'pinctrl-[0-9]+'

Correct this by adding those two properties.

While we're here, move the ti,linear-mapping-mode property to the
led@[01] child nodes to correct the following validation error:

Documentation/devicetree/bindings/leds/backlight/lm3630a-backlight.example.dt.yaml:
led@0: 'ti,linear-mapping-mode' does not match any of the regexes:
'pinctrl-[0-9]+'

Fixes: 32fcb75c66a0 ("dt-bindings: backlight: Add lm3630a bindings")
Signed-off-by: Brian Masney <masneyb@onstation.org>
Reported-by: Rob Herring <robh+dt@kernel.org>
Acked-by: Daniel Thompson <daniel.thompson@linaro.org>
Acked-by: Dan Murphy <dmurphy@ti.com>
[robh: also drop maxItems from child reg]
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../leds/backlight/lm3630a-backlight.yaml     | 21 ++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/Documentation/devicetree/bindings/leds/backlight/lm3630a-backlight.yaml b/Documentation/devicetree/bindings/leds/backlight/lm3630a-backlight.yaml
index 4d61fe0a98a4..dc129d9a329e 100644
--- a/Documentation/devicetree/bindings/leds/backlight/lm3630a-backlight.yaml
+++ b/Documentation/devicetree/bindings/leds/backlight/lm3630a-backlight.yaml
@@ -23,16 +23,17 @@ properties:
   reg:
     maxItems: 1
 
-  ti,linear-mapping-mode:
-    description: |
-      Enable linear mapping mode. If disabled, then it will use exponential
-      mapping mode in which the ramp up/down appears to have a more uniform
-      transition to the human eye.
-    type: boolean
+  '#address-cells':
+    const: 1
+
+  '#size-cells':
+    const: 0
 
 required:
   - compatible
   - reg
+  - '#address-cells'
+  - '#size-cells'
 
 patternProperties:
   "^led@[01]$":
@@ -48,7 +49,6 @@ patternProperties:
           in this property. The two current sinks can be controlled
           independently with both banks, or bank A can be configured to control
           both sinks with the led-sources property.
-        maxItems: 1
         minimum: 0
         maximum: 1
 
@@ -73,6 +73,13 @@ patternProperties:
         minimum: 0
         maximum: 255
 
+      ti,linear-mapping-mode:
+        description: |
+          Enable linear mapping mode. If disabled, then it will use exponential
+          mapping mode in which the ramp up/down appears to have a more uniform
+          transition to the human eye.
+        type: boolean
+
     required:
       - reg
 
-- 
2.20.1



