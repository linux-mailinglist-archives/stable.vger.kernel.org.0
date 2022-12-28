Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94BA9657C8C
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:33:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233475AbiL1Pdm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:33:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233430AbiL1Pdh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:33:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9D9D15FD3
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:33:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7635F61560
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:33:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81EE1C433EF;
        Wed, 28 Dec 2022 15:33:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241615;
        bh=h7Ai2CixuiWV9kMofQNhiA9BdUYGPBYbLSFyd2Ft4uw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ky+4fccSEBKIrcgkoC+0zbD9Z6HM9VMRbikOo64D1xa5CB64v837RHuAECBWKw+zX
         ErXJ/v5IouTZZo4uNxqI9jt1/ghox6itTX92ZKpiFvI3RG1kKYh3E0ZueuDH9EyENv
         gAIzbO2E6FjAe3nt2w1JtoZhkZDeJsagu6Gq8E5A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sam Shih <sam.shih@mediatek.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0308/1073] dt-bindings: pinctrl: update uart/mmc bindings for MT7986 SoC
Date:   Wed, 28 Dec 2022 15:31:36 +0100
Message-Id: <20221228144336.373899592@linuxfoundation.org>
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

From: Frank Wunderlich <frank-w@public-files.de>

[ Upstream commit c115e7f51e685536ecb885854bdd4b3f225ff3e4 ]

Fix mmc and uart pins after uart splitting.

Some pinmux pins of the mt7986 pinctrl driver is composed of multiple
pinctrl groups, the original binding only allows one pinctrl group
per dts node, this patch sets "maxItems" for these groups and add new
examples to the binding documentation.

Fixes: 65916a1ca90a ("dt-bindings: pinctrl: update bindings for MT7986 SoC")
Signed-off-by: Sam Shih <sam.shih@mediatek.com>
Signed-off-by: Frank Wunderlich <frank-w@public-files.de>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20221106080114.7426-3-linux@fw-web.de
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../pinctrl/mediatek,mt7986-pinctrl.yaml      | 46 +++++++++++++++++--
 1 file changed, 41 insertions(+), 5 deletions(-)

diff --git a/Documentation/devicetree/bindings/pinctrl/mediatek,mt7986-pinctrl.yaml b/Documentation/devicetree/bindings/pinctrl/mediatek,mt7986-pinctrl.yaml
index 4eadea55df10..41abfa94877f 100644
--- a/Documentation/devicetree/bindings/pinctrl/mediatek,mt7986-pinctrl.yaml
+++ b/Documentation/devicetree/bindings/pinctrl/mediatek,mt7986-pinctrl.yaml
@@ -87,6 +87,8 @@ patternProperties:
           "wifi_led"        "led"       1, 2
           "i2c"             "i2c"       3, 4
           "uart1_0"         "uart"      7, 8, 9, 10
+          "uart1_rx_tx"     "uart"      42, 43
+          "uart1_cts_rts"   "uart"      44, 45
           "pcie_clk"        "pcie"      9
           "pcie_wake"       "pcie"      10
           "spi1_0"          "spi"       11, 12, 13, 14
@@ -98,9 +100,11 @@ patternProperties:
           "emmc_45"         "emmc"      22, 23, 24, 25, 26, 27, 28, 29, 30,
                                         31, 32
           "spi1_1"          "spi"       23, 24, 25, 26
-          "uart1_2"         "uart"      29, 30, 31, 32
+          "uart1_2_rx_tx"   "uart"      29, 30
+          "uart1_2_cts_rts" "uart"      31, 32
           "uart1_1"         "uart"      23, 24, 25, 26
-          "uart2_0"         "uart"      29, 30, 31, 32
+          "uart2_0_rx_tx"   "uart"      29, 30
+          "uart2_0_cts_rts" "uart"      31, 32
           "spi0"            "spi"       33, 34, 35, 36
           "spi0_wp_hold"    "spi"       37, 38
           "uart1_3_rx_tx"   "uart"      35, 36
@@ -153,7 +157,7 @@ patternProperties:
             then:
               properties:
                 groups:
-                  enum: [emmc, emmc_rst]
+                  enum: [emmc_45, emmc_51]
           - if:
               properties:
                 function:
@@ -217,8 +221,12 @@ patternProperties:
             then:
               properties:
                 groups:
-                  enum: [uart1_0, uart1_1, uart1_2, uart1_3_rx_tx,
-                         uart1_3_cts_rts, uart2_0, uart2_1, uart0, uart1, uart2]
+                  items:
+                    enum: [uart1_0, uart1_rx_tx, uart1_cts_rts, uart1_1,
+                           uart1_2_rx_tx, uart1_2_cts_rts, uart1_3_rx_tx,
+                           uart1_3_cts_rts, uart2_0_rx_tx, uart2_0_cts_rts,
+                           uart2_1, uart0, uart1, uart2]
+                  maxItems: 2
           - if:
               properties:
                 function:
@@ -348,6 +356,27 @@ examples:
         interrupt-parent = <&gic>;
         #interrupt-cells = <2>;
 
+        pcie_pins: pcie-pins {
+          mux {
+            function = "pcie";
+            groups = "pcie_clk", "pcie_wake", "pcie_pereset";
+          };
+        };
+
+        pwm_pins: pwm-pins {
+          mux {
+            function = "pwm";
+            groups = "pwm0", "pwm1_0";
+          };
+        };
+
+        spi0_pins: spi0-pins {
+          mux {
+            function = "spi";
+            groups = "spi0", "spi0_wp_hold";
+          };
+        };
+
         uart1_pins: uart1-pins {
           mux {
             function = "uart";
@@ -355,6 +384,13 @@ examples:
           };
         };
 
+        uart1_3_pins: uart1-3-pins {
+          mux {
+            function = "uart";
+            groups = "uart1_3_rx_tx", "uart1_3_cts_rts";
+          };
+        };
+
         uart2_pins: uart2-pins {
           mux {
             function = "uart";
-- 
2.35.1



