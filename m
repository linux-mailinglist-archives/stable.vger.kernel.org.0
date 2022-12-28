Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 215D165823D
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:34:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234674AbiL1QeT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:34:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234432AbiL1Qdd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:33:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A7211C13E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:31:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 36580B81886
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:31:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89C77C433D2;
        Wed, 28 Dec 2022 16:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672245066;
        bh=OqckLj6cr4f4AlTMwTZqLGiqijkEPZ5XPG07gCG6aLk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w03zZwFEcYLz6WK30KovH3FCB1YTypIQ8MmfkFYO7DoQYJU0GrMzPUMu6j5WXclKH
         RVOp8qgHyKZe0diaE00rEzlEQIBNpJep3OF6V0WE1aGoROfqFe0hMEzvOWMLfQgjQv
         JunXi6GoaM495P30TTEK70HiSVigXLsKirqcFAvw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Bryan ODonoghue <bryan.odonoghue@linaro.org>,
        Lee Jones <lee@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0827/1073] dt-bindings: mfd: qcom,spmi-pmic: Drop PWM reg dependency
Date:   Wed, 28 Dec 2022 15:40:15 +0100
Message-Id: <20221228144350.477582853@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

From: Bryan O'Donoghue <bryan.odonoghue@linaro.org>

[ Upstream commit 763ab98687404d924b6612f7c9c8430333d31229 ]

The PWM node is not a separate device and is expected to be part of parent
SPMI PMIC node, thus it obtains the address space from the parent. One IO
address in "reg" is also not correct description because LPG block maps to
several regions.

Fixes: 3f5117be9584 ("dt-bindings: mfd: convert to yaml Qualcomm SPMI PMIC")
Suggested-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Lee Jones <lee@kernel.org>
Link: https://lore.kernel.org/r/20220928000517.228382-2-bryan.odonoghue@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/mfd/qcom,spmi-pmic.yaml | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/mfd/qcom,spmi-pmic.yaml b/Documentation/devicetree/bindings/mfd/qcom,spmi-pmic.yaml
index 65cbc6dee545..2a5bafe0660a 100644
--- a/Documentation/devicetree/bindings/mfd/qcom,spmi-pmic.yaml
+++ b/Documentation/devicetree/bindings/mfd/qcom,spmi-pmic.yaml
@@ -92,6 +92,10 @@ properties:
     type: object
     $ref: /schemas/regulator/regulator.yaml#
 
+  pwm:
+    type: object
+    $ref: /schemas/leds/leds-qcom-lpg.yaml#
+
 patternProperties:
   "^adc@[0-9a-f]+$":
     type: object
@@ -117,10 +121,6 @@ patternProperties:
     type: object
     $ref: /schemas/power/reset/qcom,pon.yaml#
 
-  "pwm@[0-9a-f]+$":
-    type: object
-    $ref: /schemas/leds/leds-qcom-lpg.yaml#
-
   "^rtc@[0-9a-f]+$":
     type: object
     $ref: /schemas/rtc/qcom-pm8xxx-rtc.yaml#
-- 
2.35.1



