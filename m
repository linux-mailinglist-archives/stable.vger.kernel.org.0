Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED88327CB2F
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:27:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732245AbgI2MZS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:25:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:49220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728745AbgI2Ldd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:33:33 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE55423BC6;
        Tue, 29 Sep 2020 11:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378830;
        bh=lDDGUL4kvJ5mex8eDO//IqOW71j0i6XZXgohdWZWS0A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WUyzJoMAW5Jz+ZshTYVFicA3H70DgYnGGYErEWqBEiFvlptfFZHmSF1x3tgrQYxSV
         V9P54I/iCr/BhG3/UkX0swTRab1aDTlUc8SBaMhRq2CPgSYhFRSkTqLz2m8mb9Yi8A
         Jg1l/WfqWpZmlWScVfK2Zal0ZKGNSKRlw9k9Z+NE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonathan Bakker <xc-racer2@live.ca>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 155/245] dt-bindings: sound: wm8994: Correct required supplies based on actual implementaion
Date:   Tue, 29 Sep 2020 13:00:06 +0200
Message-Id: <20200929105954.528063904@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105946.978650816@linuxfoundation.org>
References: <20200929105946.978650816@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzk@kernel.org>

[ Upstream commit 8c149b7d75e53be47648742f40fc90d9fc6fa63a ]

The required supplies in bindings were actually not matching
implementation making the bindings incorrect and misleading.  The Linux
kernel driver requires all supplies to be present.  Also for wlf,wm8994
uses just DBVDD-supply instead of DBVDDn-supply (n: <1,3>).

Reported-by: Jonathan Bakker <xc-racer2@live.ca>
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Link: https://lore.kernel.org/r/20200501133534.6706-1-krzk@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../devicetree/bindings/sound/wm8994.txt       | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/Documentation/devicetree/bindings/sound/wm8994.txt b/Documentation/devicetree/bindings/sound/wm8994.txt
index 68cccc4653ba3..367b58ce1bb92 100644
--- a/Documentation/devicetree/bindings/sound/wm8994.txt
+++ b/Documentation/devicetree/bindings/sound/wm8994.txt
@@ -14,9 +14,15 @@ Required properties:
   - #gpio-cells : Must be 2. The first cell is the pin number and the
     second cell is used to specify optional parameters (currently unused).
 
-  - AVDD2-supply, DBVDD1-supply, DBVDD2-supply, DBVDD3-supply, CPVDD-supply,
-    SPKVDD1-supply, SPKVDD2-supply : power supplies for the device, as covered
-    in Documentation/devicetree/bindings/regulator/regulator.txt
+  - power supplies for the device, as covered in
+    Documentation/devicetree/bindings/regulator/regulator.txt, depending
+    on compatible:
+    - for wlf,wm1811 and wlf,wm8958:
+      AVDD1-supply, AVDD2-supply, DBVDD1-supply, DBVDD2-supply, DBVDD3-supply,
+      DCVDD-supply, CPVDD-supply, SPKVDD1-supply, SPKVDD2-supply
+    - for wlf,wm8994:
+      AVDD1-supply, AVDD2-supply, DBVDD-supply, DCVDD-supply, CPVDD-supply,
+      SPKVDD1-supply, SPKVDD2-supply
 
 Optional properties:
 
@@ -73,11 +79,11 @@ wm8994: codec@1a {
 
 	lineout1-se;
 
+	AVDD1-supply = <&regulator>;
 	AVDD2-supply = <&regulator>;
 	CPVDD-supply = <&regulator>;
-	DBVDD1-supply = <&regulator>;
-	DBVDD2-supply = <&regulator>;
-	DBVDD3-supply = <&regulator>;
+	DBVDD-supply = <&regulator>;
+	DCVDD-supply = <&regulator>;
 	SPKVDD1-supply = <&regulator>;
 	SPKVDD2-supply = <&regulator>;
 };
-- 
2.25.1



