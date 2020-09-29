Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6C5E27C405
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:11:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729158AbgI2LK3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:10:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:50972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729151AbgI2LKO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:10:14 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3945B21D46;
        Tue, 29 Sep 2020 11:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601377813;
        bh=JhkyNonEfdkzvlR7tiCFHlN7ZQwpU6Pomj+ZQSfG9BQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kRz/gm17bqoY5azrtGeOPMKkFNCh0BMWWUpb2bZJh9Q/1LyHKb15D4e8oiUXjTJ+c
         UmJYacTl8KLFUbUscgEE3sjLVtKbcXHi4FGTHYgesUU4c6JKm1t+tEUx1U2IXYfeTt
         VNqiZmOpUY8V/8SYR/FXAYWUqdmWsJ2FgICOALc0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonathan Bakker <xc-racer2@live.ca>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 080/121] dt-bindings: sound: wm8994: Correct required supplies based on actual implementaion
Date:   Tue, 29 Sep 2020 13:00:24 +0200
Message-Id: <20200929105934.144790464@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105930.172747117@linuxfoundation.org>
References: <20200929105930.172747117@linuxfoundation.org>
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
index 68c4e8d96bed6..b309de00cd836 100644
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
 
@@ -68,11 +74,11 @@ codec: wm8994@1a {
 
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



