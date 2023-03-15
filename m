Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21D6F6BB077
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:18:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232071AbjCOMS1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:18:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231855AbjCOMSQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:18:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BE9C943A0
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:18:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5CE9561ABD
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:18:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72B27C433EF;
        Wed, 15 Mar 2023 12:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678882685;
        bh=cjiVV0CeSCdzuMs3QQvEn+Umv04zh6+0Oa+TvXDe0lY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XYxlYEjFYC26nfFdGUhIltqkMuFW0qXG3eE3N+kpxzQo0SAPs81kbzUAu8JSkXzQH
         dZDVgcFhte5y75rNPGlninoEtM5FlzyACt/sR2P22uUbm0n9joi/KnYPziykha7W57
         x9nHhPVoQGn/t3QRnMZ15cinLN/Q/WM89QPXWc/Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 31/68] ARM: dts: exynos: correct TMU phandle in Odroid XU3 family
Date:   Wed, 15 Mar 2023 13:12:25 +0100
Message-Id: <20230315115727.303285338@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115726.103942885@linuxfoundation.org>
References: <20230315115726.103942885@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit a3583e92d188ec6c58c7f603ac5e72dd8a11c21a ]

TMU node uses 0 as thermal-sensor-cells, thus thermal zone referencing
it must not have an argument to phandle.  This was not critical before,
but since rework of thermal Devicetree initialization in the
commit 3fd6d6e2b4e8 ("thermal/of: Rework the thermal device tree
initialization"), this leads to errors registering thermal zones other
than first one:

  thermal_sys: cpu0-thermal: Failed to read thermal-sensors cells: -2
  thermal_sys: Failed to find thermal zone for tmu id=0
  exynos-tmu 10064000.tmu: Failed to register sensor: -2
  exynos-tmu: probe of 10064000.tmu failed with error -2

Fixes: f1722d7dd8b8 ("ARM: dts: Define default thermal-zones for exynos5422")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20230209105841.779596-6-krzysztof.kozlowski@linaro.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/exynos5422-odroidxu3-common.dtsi | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm/boot/dts/exynos5422-odroidxu3-common.dtsi b/arch/arm/boot/dts/exynos5422-odroidxu3-common.dtsi
index 5cf48af9884c9..56a0e1eba36fc 100644
--- a/arch/arm/boot/dts/exynos5422-odroidxu3-common.dtsi
+++ b/arch/arm/boot/dts/exynos5422-odroidxu3-common.dtsi
@@ -50,7 +50,7 @@
 
 	thermal-zones {
 		cpu0_thermal: cpu0-thermal {
-			thermal-sensors = <&tmu_cpu0 0>;
+			thermal-sensors = <&tmu_cpu0>;
 			polling-delay-passive = <250>;
 			polling-delay = <0>;
 			trips {
@@ -139,7 +139,7 @@
 			};
 		};
 		cpu1_thermal: cpu1-thermal {
-			thermal-sensors = <&tmu_cpu1 0>;
+			thermal-sensors = <&tmu_cpu1>;
 			polling-delay-passive = <250>;
 			polling-delay = <0>;
 			trips {
@@ -212,7 +212,7 @@
 			};
 		};
 		cpu2_thermal: cpu2-thermal {
-			thermal-sensors = <&tmu_cpu2 0>;
+			thermal-sensors = <&tmu_cpu2>;
 			polling-delay-passive = <250>;
 			polling-delay = <0>;
 			trips {
@@ -285,7 +285,7 @@
 			};
 		};
 		cpu3_thermal: cpu3-thermal {
-			thermal-sensors = <&tmu_cpu3 0>;
+			thermal-sensors = <&tmu_cpu3>;
 			polling-delay-passive = <250>;
 			polling-delay = <0>;
 			trips {
@@ -358,7 +358,7 @@
 			};
 		};
 		gpu_thermal: gpu-thermal {
-			thermal-sensors = <&tmu_gpu 0>;
+			thermal-sensors = <&tmu_gpu>;
 			polling-delay-passive = <250>;
 			polling-delay = <0>;
 			trips {
-- 
2.39.2



