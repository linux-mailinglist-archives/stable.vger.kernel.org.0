Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDBDE6BB052
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:17:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231864AbjCOMRP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:17:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231779AbjCOMRJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:17:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 948B59384E
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:16:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3A2C3B81DF8
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:16:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90CC1C433D2;
        Wed, 15 Mar 2023 12:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678882614;
        bh=M1wl3aRnFRk/EPNbsHRZB3+pVkTDAL+RDXaxki4wQts=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vSeJ2SzIp9Rqzsk/qTF69FkWg/cKarij/jMS7m8EF7dSFpdzK9O63Is2BbulqoMId
         f95aNch+fsIOqCwhWYq2BAnc3SmhoFolqAC9s9zEwzb0kj70FGyCHL8tYmHUInGK99
         U40pkZqLkQ+FH53+uDEarzdWKkME+LDHZ5BpPnTM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 23/39] ARM: dts: exynos: Add GPU thermal zone cooling maps for Odroid XU3/XU4/HC1
Date:   Wed, 15 Mar 2023 13:12:37 +0100
Message-Id: <20230315115722.088138374@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115721.234756306@linuxfoundation.org>
References: <20230315115721.234756306@linuxfoundation.org>
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
index 264651141d688..402d69877fd97 100644
--- a/arch/arm/boot/dts/exynos5422-odroidxu3-common.dtsi
+++ b/arch/arm/boot/dts/exynos5422-odroidxu3-common.dtsi
@@ -359,6 +359,65 @@
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



