Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63B52681099
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:05:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237041AbjA3OFE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:05:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236993AbjA3OFD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:05:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DC821040D
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:05:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3F322B80C9B
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:05:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E96FC433EF;
        Mon, 30 Jan 2023 14:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087500;
        bh=Q9nayGaTf5FemrVXaozNIed3CO1q+xQHUtAnEY2vhp0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BGMl9aeT4B1GTnxfQSHsRfOx75vKNztDPHDHh2RFS2ayr8VsPSlVbXO0HQb35rcXI
         yM4kd/9qdmcuoLzGZxFeNPkR0skN++WhnU4pcHKHxDt6z5katXMBmu0vf+IoPEMyN8
         Br7n8BlZYPXqHoMqIPVLSW1JVCixK9rSO82ZlucY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.1 228/313] regulator: dt-bindings: samsung,s2mps14: add lost samsung,ext-control-gpios
Date:   Mon, 30 Jan 2023 14:51:03 +0100
Message-Id: <20230130134347.336607862@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit 4bb3d82a1820c1b609ede8eb2332f3cb038c5840 upstream.

The samsung,ext-control-gpios property was lost during conversion to DT
schema:

  exynos3250-artik5-eval.dtb: pmic@66: regulators:LDO11: Unevaluated properties are not allowed ('samsung,ext-control-gpios' was unexpected)

Fixes: ea98b9eba05c ("regulator: dt-bindings: samsung,s2m: convert to dtschema")
Cc: <stable@vger.kernel.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20230120131447.289702-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/regulator/samsung,s2mps14.yaml |   21 +++++++++-
 1 file changed, 19 insertions(+), 2 deletions(-)

--- a/Documentation/devicetree/bindings/regulator/samsung,s2mps14.yaml
+++ b/Documentation/devicetree/bindings/regulator/samsung,s2mps14.yaml
@@ -19,8 +19,8 @@ description: |
   additional information and example.
 
 patternProperties:
-  # 25 LDOs
-  "^LDO([1-9]|[1][0-9]|2[0-5])$":
+  # 25 LDOs, without LDO10-12
+  "^LDO([1-9]|1[3-9]|2[0-5])$":
     type: object
     $ref: regulator.yaml#
     unevaluatedProperties: false
@@ -29,6 +29,23 @@ patternProperties:
 
     required:
       - regulator-name
+
+  "^LDO(1[0-2])$":
+    type: object
+    $ref: regulator.yaml#
+    unevaluatedProperties: false
+    description:
+      Properties for single LDO regulator.
+
+    properties:
+      samsung,ext-control-gpios:
+        maxItems: 1
+        description:
+          LDO10, LDO11 and LDO12 can be configured to external control over
+          GPIO.
+
+    required:
+      - regulator-name
 
   # 5 bucks
   "^BUCK[1-5]$":


