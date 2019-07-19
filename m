Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36DD36DFBE
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:38:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728918AbfGSD7x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jul 2019 23:59:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:59628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727739AbfGSD7w (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Jul 2019 23:59:52 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9FB2821873;
        Fri, 19 Jul 2019 03:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563508791;
        bh=QvlXDSoxkqqz4+28wmL0GcIAtj5yQiD+NHM8MahlxRw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CCZs4gazG2xpUNZXFdBEnZ5NQqzsQujhxKlDFnYJqkQ6tf77soCEFL6glgN0ioP/y
         aCVRLjfrMMvEmwsfeggVlhBiWJxHyfIpMy/fjZP5LsXI7leCLAb6K+Gvvisqy8vi+l
         VOigOYrapNJdjpHGEcUs1gduX4QghWKWWWZy99Dc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Brian Masney <masneyb@onstation.org>,
        Rob Herring <robh+dt@kernel.org>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Dan Murphy <dmurphy@ti.com>, Rob Herring <robh@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 091/171] dt-bindings: backlight: lm3630a: correct schema validation
Date:   Thu, 18 Jul 2019 23:55:22 -0400
Message-Id: <20190719035643.14300-91-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719035643.14300-1-sashal@kernel.org>
References: <20190719035643.14300-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brian Masney <masneyb@onstation.org>

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

