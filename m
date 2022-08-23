Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B759759D464
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 10:24:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242920AbiHWIW3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:22:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242910AbiHWITi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:19:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCDE069F66;
        Tue, 23 Aug 2022 01:11:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B29BAB81C21;
        Tue, 23 Aug 2022 08:11:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DC84C433C1;
        Tue, 23 Aug 2022 08:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242312;
        bh=TaQ55Cpe6WmiczsBCjgMoH8Z7IIbshHed9o2mIVH6mE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XHmQgMOXVfbKdy75gSvvoJLMbYZL1o+T92+fjEYDdN1W+CRE2DTgsgJPOjU22GOxZ
         cv39uhkA1G4BrNqTen1Ik/ePtQ9gg7dkbgMun+ELJcGG24PGaKYuowRkqx8Gp905XS
         6s5jzmX99myJ8HCZPUmGDdoS0+67jR4t0F9WeD04=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" 
        <nfraprado@collabora.com>,
        AngeloGioacchino Del Regno 
        <angelogiocchino.delregno@collabora.com>,
        Rob Herring <robh@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.19 092/365] dt-bindings: pinctrl: mt8192: Use generic bias instead of pull-*-adv
Date:   Tue, 23 Aug 2022 09:59:53 +0200
Message-Id: <20220823080122.037550047@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAD_ENC_HEADER,BAYES_00,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nícolas F. R. A. Prado <nfraprado@collabora.com>

commit 353d2ef77f2be4c1b9b3c70f1637a9986f07b997 upstream.

Commit cafe19db7751 ("pinctrl: mediatek: Backward compatible to previous
Mediatek's bias-pull usage") allowed the bias-pull-up and bias-pull-down
properties to be used for setting PUPD/R1/R0 type bias on mtk-paris
based SoC's, which was previously only supported by the custom
mediatek,pull-up-adv and mediatek,pull-down-adv properties.

Since the bias-pull-{up,down} properties already have defines associated
thus being more descriptive and is more universal on MediaTek platforms,
and given that there are no mediatek,pull-{up,down}-adv users on mt8192
yet, remove the custom adv properties in favor of the generic ones.

Note that only mediatek,pull-up-adv was merged in the binding, but not
its down counterpart.

Fixes: edbacb36ea50 ("dt-bindings: pinctrl: mt8192: Add mediatek,pull-up-adv property")
Signed-off-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogiocchino.delregno@collabora.com>
Reviewed-by: Rob Herring <robh@kernel.org>
Link: https://lore.kernel.org/r/20220525155714.1837360-3-nfraprado@collabora.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 .../bindings/pinctrl/pinctrl-mt8192.yaml      | 29 ++++++++++---------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff --git a/Documentation/devicetree/bindings/pinctrl/pinctrl-mt8192.yaml b/Documentation/devicetree/bindings/pinctrl/pinctrl-mt8192.yaml
index 8ede8b750237..e39f5893bf16 100644
--- a/Documentation/devicetree/bindings/pinctrl/pinctrl-mt8192.yaml
+++ b/Documentation/devicetree/bindings/pinctrl/pinctrl-mt8192.yaml
@@ -83,20 +83,21 @@ patternProperties:
           drive-strength-microamp:
             enum: [125, 250, 500, 1000]
 
-          mediatek,pull-up-adv:
-            description: |
-              Pull up settings for 2 pull resistors, R0 and R1. User can
-              configure those special pins. Valid arguments are described as below:
-              0: (R1, R0) = (0, 0) which means R1 disabled and R0 disabled.
-              1: (R1, R0) = (0, 1) which means R1 disabled and R0 enabled.
-              2: (R1, R0) = (1, 0) which means R1 enabled and R0 disabled.
-              3: (R1, R0) = (1, 1) which means R1 enabled and R0 enabled.
-            $ref: /schemas/types.yaml#/definitions/uint32
-            enum: [0, 1, 2, 3]
-
-          bias-pull-down: true
-
-          bias-pull-up: true
+          bias-pull-down:
+            oneOf:
+              - type: boolean
+                description: normal pull down.
+              - enum: [100, 101, 102, 103]
+                description: PUPD/R1/R0 pull down type. See MTK_PUPD_SET_R1R0_
+                  defines in dt-bindings/pinctrl/mt65xx.h.
+
+          bias-pull-up:
+            oneOf:
+              - type: boolean
+                description: normal pull up.
+              - enum: [100, 101, 102, 103]
+                description: PUPD/R1/R0 pull up type. See MTK_PUPD_SET_R1R0_
+                  defines in dt-bindings/pinctrl/mt65xx.h.
 
           bias-disable: true
 
-- 
2.37.2



