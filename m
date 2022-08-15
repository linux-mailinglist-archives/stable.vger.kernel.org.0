Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2371593DF0
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:44:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345395AbiHOUd3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:33:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348271AbiHOUcZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:32:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1E5D3C177;
        Mon, 15 Aug 2022 12:05:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BC98E612A0;
        Mon, 15 Aug 2022 19:05:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD08DC433D6;
        Mon, 15 Aug 2022 19:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590332;
        bh=8vSjHVpVmaE8n11iZ1ypcPCHI5yaSqylemBc/YbUFbU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gsB5Ok1o9mAPDRy+ovbLb0S4NgCM21trbBgwieVkOXkNqogn2TJJNFp8qK9jwEQso
         xejfHRN8sDsNHY37M6LSQCiognftN8Qj3y0N09H4d79GDzPj6wXx8Wfep3DF0J+t50
         aeoQiVxDSG43lV1sr3EhIJlqk/dJgx4jKvIWerSM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0225/1095] ARM: dts: qcom: msm8974-samsung-klte: move gpio-keys out of soc
Date:   Mon, 15 Aug 2022 19:53:44 +0200
Message-Id: <20220815180439.011443504@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit c19865df6b142276ec4371ad534a1eb6fef5782d ]

The GPIO keys are not part of SoC and they should be defined inside of
the root node.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220401201035.189106-6-krzysztof.kozlowski@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/qcom-msm8974-samsung-klte.dts    | 64 +++++++++----------
 1 file changed, 32 insertions(+), 32 deletions(-)

diff --git a/arch/arm/boot/dts/qcom-msm8974-samsung-klte.dts b/arch/arm/boot/dts/qcom-msm8974-samsung-klte.dts
index 96e1c978b878..6e036a440532 100644
--- a/arch/arm/boot/dts/qcom-msm8974-samsung-klte.dts
+++ b/arch/arm/boot/dts/qcom-msm8974-samsung-klte.dts
@@ -20,6 +20,38 @@ chosen {
 		stdout-path = "serial0:115200n8";
 	};
 
+	gpio-keys {
+		compatible = "gpio-keys";
+
+		pinctrl-names = "default";
+		pinctrl-0 = <&gpio_keys_pin_a>;
+
+		volume-down {
+			label = "volume_down";
+			gpios = <&pma8084_gpios 2 GPIO_ACTIVE_LOW>;
+			linux,input-type = <1>;
+			linux,code = <KEY_VOLUMEDOWN>;
+			debounce-interval = <15>;
+		};
+
+		home-key {
+			label = "home_key";
+			gpios = <&pma8084_gpios 3 GPIO_ACTIVE_LOW>;
+			linux,input-type = <1>;
+			linux,code = <KEY_HOMEPAGE>;
+			wakeup-source;
+			debounce-interval = <15>;
+		};
+
+		volume-up {
+			label = "volume_up";
+			gpios = <&pma8084_gpios 5 GPIO_ACTIVE_LOW>;
+			linux,input-type = <1>;
+			linux,code = <KEY_VOLUMEUP>;
+			debounce-interval = <15>;
+		};
+	};
+
 	smd {
 		rpm {
 			rpm_requests {
@@ -347,38 +379,6 @@ bluetooth {
 		};
 	};
 
-	gpio-keys {
-		compatible = "gpio-keys";
-
-		pinctrl-names = "default";
-		pinctrl-0 = <&gpio_keys_pin_a>;
-
-		volume-down {
-			label = "volume_down";
-			gpios = <&pma8084_gpios 2 GPIO_ACTIVE_LOW>;
-			linux,input-type = <1>;
-			linux,code = <KEY_VOLUMEDOWN>;
-			debounce-interval = <15>;
-		};
-
-		home-key {
-			label = "home_key";
-			gpios = <&pma8084_gpios 3 GPIO_ACTIVE_LOW>;
-			linux,input-type = <1>;
-			linux,code = <KEY_HOMEPAGE>;
-			wakeup-source;
-			debounce-interval = <15>;
-		};
-
-		volume-up {
-			label = "volume_up";
-			gpios = <&pma8084_gpios 5 GPIO_ACTIVE_LOW>;
-			linux,input-type = <1>;
-			linux,code = <KEY_VOLUMEUP>;
-			debounce-interval = <15>;
-		};
-	};
-
 	pinctrl@fd510000 {
 		blsp2_uart8_pins_active: blsp2-uart8-pins-active {
 			pins = "gpio45", "gpio46", "gpio47", "gpio48";
-- 
2.35.1



