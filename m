Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F95D6AF56B
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:25:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231445AbjCGTZF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:25:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234093AbjCGTYm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:24:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC5E79966C
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 11:10:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7D004B817C2
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 19:10:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC38EC433EF;
        Tue,  7 Mar 2023 19:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678216243;
        bh=IPA9piGXGg/ye2fhV5PzHBZ9hdwsph59OpYy5w1QIio=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jfgUtijgkYHfXQcrYk2gHsIhzCcuv5XGpcjuiYQgZlOjiXpEWEm7824mMDPYTJB1l
         zcH4H2NK8Qg7q+sOzCMfORIxiePbMAaFpHvvseslwiAOsRYDZ+OqXpVF4+Eib7jkg1
         0z2ifz5fOEvcgmy+JYcFfCEq7ow3N+++BY2g86TQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 5.15 521/567] ARM: dts: exynos: correct TMU phandle in Odroid HC1
Date:   Tue,  7 Mar 2023 18:04:17 +0100
Message-Id: <20230307165928.525257979@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
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

commit 2e3d0e20d8456f876607a8af61fdb83dfbf98cb6 upstream.

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

Fixes: 1ac49427b566 ("ARM: dts: exynos: Add support for Hardkernel's Odroid HC1 board")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20230209105841.779596-5-krzysztof.kozlowski@linaro.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/exynos5422-odroidhc1.dts |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/arch/arm/boot/dts/exynos5422-odroidhc1.dts
+++ b/arch/arm/boot/dts/exynos5422-odroidhc1.dts
@@ -29,7 +29,7 @@
 
 	thermal-zones {
 		cpu0_thermal: cpu0-thermal {
-			thermal-sensors = <&tmu_cpu0 0>;
+			thermal-sensors = <&tmu_cpu0>;
 			trips {
 				cpu0_alert0: cpu-alert-0 {
 					temperature = <70000>; /* millicelsius */
@@ -84,7 +84,7 @@
 			};
 		};
 		cpu1_thermal: cpu1-thermal {
-			thermal-sensors = <&tmu_cpu1 0>;
+			thermal-sensors = <&tmu_cpu1>;
 			trips {
 				cpu1_alert0: cpu-alert-0 {
 					temperature = <70000>;
@@ -128,7 +128,7 @@
 			};
 		};
 		cpu2_thermal: cpu2-thermal {
-			thermal-sensors = <&tmu_cpu2 0>;
+			thermal-sensors = <&tmu_cpu2>;
 			trips {
 				cpu2_alert0: cpu-alert-0 {
 					temperature = <70000>;
@@ -172,7 +172,7 @@
 			};
 		};
 		cpu3_thermal: cpu3-thermal {
-			thermal-sensors = <&tmu_cpu3 0>;
+			thermal-sensors = <&tmu_cpu3>;
 			trips {
 				cpu3_alert0: cpu-alert-0 {
 					temperature = <70000>;
@@ -216,7 +216,7 @@
 			};
 		};
 		gpu_thermal: gpu-thermal {
-			thermal-sensors = <&tmu_gpu 0>;
+			thermal-sensors = <&tmu_gpu>;
 			trips {
 				gpu_alert0: gpu-alert-0 {
 					temperature = <70000>;


