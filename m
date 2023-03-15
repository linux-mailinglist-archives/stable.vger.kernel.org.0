Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F5856BB070
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:18:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231934AbjCOMSL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:18:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232005AbjCOMSC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:18:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6F05206B0
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:18:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 371E061D13
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:18:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47986C4339C;
        Wed, 15 Mar 2023 12:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678882680;
        bh=anRi+hGmPUdB0A0oCgq7NMi1UWS6Tval1cwYfxhjaIA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MIhAtrXhMR+SI6RAwcMG7t2uQUi6KXYpREmeWlGdgqhaLh2E5VNSYB47ytceWNKSz
         6DL9p3UoDMl3PQ6FLKWJ6fyVtdqfkARXFIREohufF7jz5JYaaaMrFbJUNaJmoQC9jD
         uzRmXwRpa6EPZ6Gw63K0p3eELXH4p0sJEZMvo7Io=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 29/68] ARM: dts: exynos: Add GPU thermal zone cooling maps for Odroid XU3/XU4/HC1
Date:   Wed, 15 Mar 2023 13:12:23 +0100
Message-Id: <20230315115727.226487057@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115726.103942885@linuxfoundation.org>
References: <20230315115726.103942885@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Szyprowski <m.szyprowski@samsung.com>

[ Upstream commit 1c651356f482ff08f6acef197a362f2e71d55a98 ]

Add trip points and cooling maps for GPU thermal zone for Odroid
XU3/XU4/HC1 boards. Trip points are based on the CPU thermal zone for the
those boards.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Stable-dep-of: 2e3d0e20d845 ("ARM: dts: exynos: correct TMU phandle in Odroid HC1")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/exynos5422-odroidhc1.dts    | 30 ++++++++++
 .../boot/dts/exynos5422-odroidxu3-common.dtsi | 59 +++++++++++++++++++
 2 files changed, 89 insertions(+)

diff --git a/arch/arm/boot/dts/exynos5422-odroidhc1.dts b/arch/arm/boot/dts/exynos5422-odroidhc1.dts
index fce5a4579693e..3235d7a27e042 100644
--- a/arch/arm/boot/dts/exynos5422-odroidhc1.dts
+++ b/arch/arm/boot/dts/exynos5422-odroidhc1.dts
@@ -215,6 +215,36 @@
 				};
 			};
 		};
+		gpu_thermal: gpu-thermal {
+			thermal-sensors = <&tmu_gpu 0>;
+			trips {
+				gpu_alert0: gpu-alert-0 {
+					temperature = <70000>;
+					hysteresis = <10000>;
+					type = "active";
+				};
+				gpu_alert1: gpu-alert-1 {
+					temperature = <85000>;
+					hysteresis = <10000>;
+					type = "active";
+				};
+				gpu_crit0: gpu-crit-0 {
+					temperature = <120000>;
+					hysteresis = <0>;
+					type = "critical";
+				};
+			};
+			cooling-maps {
+				map0 {
+					trip = <&gpu_alert0>;
+					cooling-device = <&gpu 0 2>;
+				};
+				map1 {
+					trip = <&gpu_alert1>;
+					cooling-device = <&gpu 3 6>;
+				};
+			};
+		};
 	};
 
 };
diff --git a/arch/arm/boot/dts/exynos5422-odroidxu3-common.dtsi b/arch/arm/boot/dts/exynos5422-odroidxu3-common.dtsi
index 8388720374932..5cf48af9884c9 100644
--- a/arch/arm/boot/dts/exynos5422-odroidxu3-common.dtsi
+++ b/arch/arm/boot/dts/exynos5422-odroidxu3-common.dtsi
@@ -357,6 +357,65 @@
 				};
 			};
 		};
+		gpu_thermal: gpu-thermal {
+			thermal-sensors = <&tmu_gpu 0>;
+			polling-delay-passive = <250>;
+			polling-delay = <0>;
+			trips {
+				gpu_alert0: gpu-alert-0 {
+					temperature = <50000>;
+					hysteresis = <5000>;
+					type = "active";
+				};
+				gpu_alert1: gpu-alert-1 {
+					temperature = <60000>;
+					hysteresis = <5000>;
+					type = "active";
+				};
+				gpu_alert2: gpu-alert-2 {
+					temperature = <70000>;
+					hysteresis = <5000>;
+					type = "active";
+				};
+				gpu_crit0: gpu-crit-0 {
+					temperature = <120000>;
+					hysteresis = <0>;
+					type = "critical";
+				};
+				gpu_alert3: gpu-alert-3 {
+					temperature = <70000>;
+					hysteresis = <10000>;
+					type = "passive";
+				};
+				gpu_alert4: gpu-alert-4 {
+					temperature = <85000>;
+					hysteresis = <10000>;
+					type = "passive";
+				};
+			};
+			cooling-maps {
+				map0 {
+					trip = <&gpu_alert0>;
+					cooling-device = <&fan0 0 1>;
+				};
+				map1 {
+					trip = <&gpu_alert1>;
+					cooling-device = <&fan0 1 2>;
+				};
+				map2 {
+					trip = <&gpu_alert2>;
+					cooling-device = <&fan0 2 3>;
+				};
+				map3 {
+					trip = <&gpu_alert3>;
+					cooling-device = <&gpu 0 2>;
+				};
+				map4 {
+					trip = <&gpu_alert4>;
+					cooling-device = <&gpu 3 6>;
+				};
+			};
+		};
 	};
 };
 
-- 
2.39.2



