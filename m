Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B9124F2CBB
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:32:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245461AbiDEIz4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:55:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241199AbiDEIcy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:32:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62E1D17A80;
        Tue,  5 Apr 2022 01:29:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1CD8AB81BC6;
        Tue,  5 Apr 2022 08:29:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AE0FC385A5;
        Tue,  5 Apr 2022 08:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147359;
        bh=8+nV5sr301wpqPmNJWY4ATfsU6LcUhtfMy/YT4leBTQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J/1s9kGHs8wyeEgbMZ9yyDWWsyjeXY+nKqshJmiAVGVHTVrsFUPr1U5vHjAS5DfT8
         tGx+C5uOyCLvZT58rJlrvi1+C/VLj2h/lZeJFHNuN7mVcMS7u88RIi4JcgRcOitz7R
         7gEgqyNhlVWzLAw9Y/1ADt/mZRxE0psb8wzdGcyI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen-Yu Tsai <wenst@chromium.org>,
        Rob Herring <robh@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.17 1097/1126] dt-bindings: pinctrl: mt8195: fix bias-pull-{up,down} checks
Date:   Tue,  5 Apr 2022 09:30:44 +0200
Message-Id: <20220405070439.641720186@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen-Yu Tsai <wenst@chromium.org>

commit c76eeb14ec4e645a23ed8d627c7e38eca048c527 upstream.

When the constraints and description for bias-pull-{up,down} were added,
the constraints were not indented correctly, resulting in them being
parsed as part of the description. This effectively nullified their
purpose.

Move the constraints out of the description block, make each description
part of the same associative array as the enum its describing, and
reindent them correctly so they take effect.

Also add "type: boolean" to the list of valid values. This corresponds
to having bias-pull-{up,down} without any arguments.

Fixes: 91e7edceda96 ("dt-bindings: pinctrl: mt8195: change pull up/down description")
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Reviewed-by: Rob Herring <robh@kernel.org>
Link: https://lore.kernel.org/r/20220202153528.707185-1-wenst@chromium.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/pinctrl/pinctrl-mt8195.yaml |   30 +++++-----
 1 file changed, 16 insertions(+), 14 deletions(-)

--- a/Documentation/devicetree/bindings/pinctrl/pinctrl-mt8195.yaml
+++ b/Documentation/devicetree/bindings/pinctrl/pinctrl-mt8195.yaml
@@ -99,6 +99,14 @@ patternProperties:
             enum: [2, 4, 6, 8, 10, 12, 14, 16]
 
           bias-pull-down:
+            oneOf:
+              - type: boolean
+              - enum: [100, 101, 102, 103]
+                description: mt8195 pull down PUPD/R0/R1 type define value.
+              - enum: [200, 201, 202, 203, 204, 205, 206, 207]
+                description: mt8195 pull down RSEL type define value.
+              - enum: [75000, 5000]
+                description: mt8195 pull down RSEL type si unit value(ohm).
             description: |
               For pull down type is normal, it don't need add RSEL & R1R0 define
               and resistance value.
@@ -115,13 +123,6 @@ patternProperties:
               & "MTK_PULL_SET_RSEL_110" & "MTK_PULL_SET_RSEL_111"
               define in mt8195. It can also support resistance value(ohm)
               "75000" & "5000" in mt8195.
-              oneOf:
-                - enum: [100, 101, 102, 103]
-                - description: mt8195 pull down PUPD/R0/R1 type define value.
-                - enum: [200, 201, 202, 203, 204, 205, 206, 207]
-                - description: mt8195 pull down RSEL type define value.
-                - enum: [75000, 5000]
-                - description: mt8195 pull down RSEL type si unit value(ohm).
 
               An example of using RSEL define:
               pincontroller {
@@ -146,6 +147,14 @@ patternProperties:
               };
 
           bias-pull-up:
+            oneOf:
+              - type: boolean
+              - enum: [100, 101, 102, 103]
+                description: mt8195 pull up PUPD/R0/R1 type define value.
+              - enum: [200, 201, 202, 203, 204, 205, 206, 207]
+                description: mt8195 pull up RSEL type define value.
+              - enum: [1000, 1500, 2000, 3000, 4000, 5000, 10000, 75000]
+                description: mt8195 pull up RSEL type si unit value(ohm).
             description: |
               For pull up type is normal, it don't need add RSEL & R1R0 define
               and resistance value.
@@ -163,13 +172,6 @@ patternProperties:
               define in mt8195. It can also support resistance value(ohm)
               "1000" & "1500" & "2000" & "3000" & "4000" & "5000" & "10000" &
               "75000" in mt8195.
-              oneOf:
-                - enum: [100, 101, 102, 103]
-                - description: mt8195 pull up PUPD/R0/R1 type define value.
-                - enum: [200, 201, 202, 203, 204, 205, 206, 207]
-                - description: mt8195 pull up RSEL type define value.
-                - enum: [1000, 1500, 2000, 3000, 4000, 5000, 10000, 75000]
-                - description: mt8195 pull up RSEL type si unit value(ohm).
               An example of using RSEL define:
               pincontroller {
                 i2c0-pins {


