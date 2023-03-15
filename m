Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 156DD6BB032
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:16:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231428AbjCOMQH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:16:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231290AbjCOMQF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:16:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB80C7DF9C
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:16:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 34DF661D13
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:16:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A68AC433EF;
        Wed, 15 Mar 2023 12:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678882561;
        bh=7mRHmHpzPHD1OYvkj1rJg+t5RzmzG9DqzHDzBVx4mxg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RcVX+QCWFYYiE17UoTXVcivPmsheId3RiwxmUNcUbsVFvRs/3TTlMJr3HyFeHe5LN
         9k/4s4PaMpIrpjKktfi6HiaZhGtmraknIKuwMfc14RValTKycIsbZCc9sr8OcjxgJq
         LLEoPdqcohi1qrxRln47NbybQ7KYFp7elwrd4xV8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Viresh Kumar <viresh.kumar@linaro.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 17/39] ARM: dts: exynos: Add all CPUs in cooling maps
Date:   Wed, 15 Mar 2023 13:12:31 +0100
Message-Id: <20230315115721.866116592@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115721.234756306@linuxfoundation.org>
References: <20230315115721.234756306@linuxfoundation.org>
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

From: Viresh Kumar <viresh.kumar@linaro.org>

[ Upstream commit 670734f5581023a2e695e82ea662e4d603fd3e8a ]

Each CPU can (and does) participate in cooling down the system but the
DT only captures a handful of them, normally CPU0, in the cooling maps.
Things work by chance currently as under normal circumstances its the
first CPU of each cluster which is used by the operating systems to
probe the cooling devices. But as soon as this CPU ordering changes and
any other CPU is used to bring up the cooling device, we will start
seeing failures.

Also the DT is rather incomplete when we list only one CPU in the
cooling maps, as the hardware doesn't have any such limitations.

Update cooling maps to include all devices affected by individual trip
points.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Stable-dep-of: 33e2c595e2e4 ("ARM: dts: exynos: correct TMU phandle in Exynos5250")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/exynos3250-artik5.dtsi      |   6 +-
 arch/arm/boot/dts/exynos3250-monk.dts         |   6 +-
 arch/arm/boot/dts/exynos3250-rinato.dts       |   6 +-
 arch/arm/boot/dts/exynos4210-trats.dts        |   4 +-
 arch/arm/boot/dts/exynos4210.dtsi             |   2 +-
 .../boot/dts/exynos4412-itop-scp-core.dtsi    |   8 +-
 arch/arm/boot/dts/exynos4412-midas.dtsi       |   8 +-
 .../boot/dts/exynos4412-odroid-common.dtsi    |   8 +-
 arch/arm/boot/dts/exynos4412-odroidu3.dts     |  18 ++-
 arch/arm/boot/dts/exynos4412.dtsi             |   6 +-
 arch/arm/boot/dts/exynos5250.dtsi             |   7 +-
 arch/arm/boot/dts/exynos5422-odroidhc1.dts    | 106 +++++++++++-------
 .../boot/dts/exynos5422-odroidxu3-common.dtsi | 106 +++++++++++-------
 13 files changed, 178 insertions(+), 113 deletions(-)

diff --git a/arch/arm/boot/dts/exynos3250-artik5.dtsi b/arch/arm/boot/dts/exynos3250-artik5.dtsi
index 6e30db644c83a..86aa0956b2d3b 100644
--- a/arch/arm/boot/dts/exynos3250-artik5.dtsi
+++ b/arch/arm/boot/dts/exynos3250-artik5.dtsi
@@ -36,11 +36,13 @@
 			cooling-maps {
 				map0 {
 					/* Corresponds to 500MHz */
-					cooling-device = <&cpu0 5 5>;
+					cooling-device = <&cpu0 5 5>,
+							 <&cpu1 5 5>;
 				};
 				map1 {
 					/* Corresponds to 200MHz */
-					cooling-device = <&cpu0 8 8>;
+					cooling-device = <&cpu0 8 8>,
+							 <&cpu1 8 8>;
 				};
 			};
 		};
diff --git a/arch/arm/boot/dts/exynos3250-monk.dts b/arch/arm/boot/dts/exynos3250-monk.dts
index d343dc13ceecd..c9b6fb65d6861 100644
--- a/arch/arm/boot/dts/exynos3250-monk.dts
+++ b/arch/arm/boot/dts/exynos3250-monk.dts
@@ -121,11 +121,13 @@
 			cooling-maps {
 				map0 {
 					/* Correspond to 500MHz at freq_table */
-					cooling-device = <&cpu0 5 5>;
+					cooling-device = <&cpu0 5 5>,
+							 <&cpu1 5 5>;
 				};
 				map1 {
 					/* Correspond to 200MHz at freq_table */
-					cooling-device = <&cpu0 8 8>;
+					cooling-device = <&cpu0 8 8>,
+							 <&cpu1 8 8>;
 				};
 			};
 		};
diff --git a/arch/arm/boot/dts/exynos3250-rinato.dts b/arch/arm/boot/dts/exynos3250-rinato.dts
index e398604b2ce0f..4eb5f79b1c3b2 100644
--- a/arch/arm/boot/dts/exynos3250-rinato.dts
+++ b/arch/arm/boot/dts/exynos3250-rinato.dts
@@ -116,11 +116,13 @@
 			cooling-maps {
 				map0 {
 					/* Corresponds to 500MHz */
-					cooling-device = <&cpu0 5 5>;
+					cooling-device = <&cpu0 5 5>,
+							 <&cpu1 5 5>;
 				};
 				map1 {
 					/* Corresponds to 200MHz */
-					cooling-device = <&cpu0 8 8>;
+					cooling-device = <&cpu0 8 8>,
+							 <&cpu1 8 8>;
 				};
 			};
 		};
diff --git a/arch/arm/boot/dts/exynos4210-trats.dts b/arch/arm/boot/dts/exynos4210-trats.dts
index 6f1d76cb79515..230969556e1ce 100644
--- a/arch/arm/boot/dts/exynos4210-trats.dts
+++ b/arch/arm/boot/dts/exynos4210-trats.dts
@@ -138,11 +138,11 @@
 			cooling-maps {
 				map0 {
 				     /* Corresponds to 800MHz at freq_table */
-				     cooling-device = <&cpu0 2 2>;
+				     cooling-device = <&cpu0 2 2>, <&cpu1 2 2>;
 				};
 				map1 {
 				     /* Corresponds to 200MHz at freq_table */
-				     cooling-device = <&cpu0 4 4>;
+				     cooling-device = <&cpu0 4 4>, <&cpu1 4 4>;
 			       };
 		       };
 		};
diff --git a/arch/arm/boot/dts/exynos4210.dtsi b/arch/arm/boot/dts/exynos4210.dtsi
index 24bea84034af2..b7b6edbc0499e 100644
--- a/arch/arm/boot/dts/exynos4210.dtsi
+++ b/arch/arm/boot/dts/exynos4210.dtsi
@@ -51,7 +51,7 @@
 			#cooling-cells = <2>; /* min followed by max */
 		};
 
-		cpu@901 {
+		cpu1: cpu@901 {
 			device_type = "cpu";
 			compatible = "arm,cortex-a9";
 			reg = <0x901>;
diff --git a/arch/arm/boot/dts/exynos4412-itop-scp-core.dtsi b/arch/arm/boot/dts/exynos4412-itop-scp-core.dtsi
index ab7affab7f1c0..4ca05599ee2ac 100644
--- a/arch/arm/boot/dts/exynos4412-itop-scp-core.dtsi
+++ b/arch/arm/boot/dts/exynos4412-itop-scp-core.dtsi
@@ -45,11 +45,15 @@
 			cooling-maps {
 				map0 {
 				     /* Corresponds to 800MHz at freq_table */
-				     cooling-device = <&cpu0 7 7>;
+				     cooling-device = <&cpu0 7 7>, <&cpu1 7 7>,
+						      <&cpu2 7 7>, <&cpu3 7 7>;
 				};
 				map1 {
 				     /* Corresponds to 200MHz at freq_table */
-				     cooling-device = <&cpu0 13 13>;
+				     cooling-device = <&cpu0 13 13>,
+						      <&cpu1 13 13>,
+						      <&cpu2 13 13>,
+						      <&cpu3 13 13>;
 			       };
 		       };
 		};
diff --git a/arch/arm/boot/dts/exynos4412-midas.dtsi b/arch/arm/boot/dts/exynos4412-midas.dtsi
index 93c8918e599bd..047240a32097a 100644
--- a/arch/arm/boot/dts/exynos4412-midas.dtsi
+++ b/arch/arm/boot/dts/exynos4412-midas.dtsi
@@ -267,11 +267,15 @@
 			cooling-maps {
 				map0 {
 				     /* Corresponds to 800MHz at freq_table */
-				     cooling-device = <&cpu0 7 7>;
+				     cooling-device = <&cpu0 7 7>, <&cpu1 7 7>,
+						      <&cpu2 7 7>, <&cpu3 7 7>;
 				};
 				map1 {
 				     /* Corresponds to 200MHz at freq_table */
-				     cooling-device = <&cpu0 13 13>;
+				     cooling-device = <&cpu0 13 13>,
+						      <&cpu1 13 13>,
+						      <&cpu2 13 13>,
+						      <&cpu3 13 13>;
 			       };
 		       };
 		};
diff --git a/arch/arm/boot/dts/exynos4412-odroid-common.dtsi b/arch/arm/boot/dts/exynos4412-odroid-common.dtsi
index dbca8eeefae13..e269818668bb1 100644
--- a/arch/arm/boot/dts/exynos4412-odroid-common.dtsi
+++ b/arch/arm/boot/dts/exynos4412-odroid-common.dtsi
@@ -72,11 +72,15 @@
 			cooling-maps {
 				cooling_map0: map0 {
 				     /* Corresponds to 800MHz at freq_table */
-				     cooling-device = <&cpu0 7 7>;
+				     cooling-device = <&cpu0 7 7>, <&cpu1 7 7>,
+						      <&cpu2 7 7>, <&cpu3 7 7>;
 				};
 				cooling_map1: map1 {
 				     /* Corresponds to 200MHz at freq_table */
-				     cooling-device = <&cpu0 13 13>;
+				     cooling-device = <&cpu0 13 13>,
+						      <&cpu1 13 13>,
+						      <&cpu2 13 13>,
+						      <&cpu3 13 13>;
 			       };
 		       };
 		};
diff --git a/arch/arm/boot/dts/exynos4412-odroidu3.dts b/arch/arm/boot/dts/exynos4412-odroidu3.dts
index 459919b65df81..2bdf899df4366 100644
--- a/arch/arm/boot/dts/exynos4412-odroidu3.dts
+++ b/arch/arm/boot/dts/exynos4412-odroidu3.dts
@@ -45,24 +45,22 @@
 			cooling-maps {
 				map0 {
 				     trip = <&cpu_alert1>;
-				     cooling-device = <&cpu0 9 9>;
+				     cooling-device = <&cpu0 9 9>, <&cpu1 9 9>,
+						      <&cpu2 9 9>, <&cpu3 9 9>,
+						      <&fan0 1 2>;
 				};
 				map1 {
 				     trip = <&cpu_alert2>;
-				     cooling-device = <&cpu0 15 15>;
+				     cooling-device = <&cpu0 15 15>,
+						      <&cpu1 15 15>,
+						      <&cpu2 15 15>,
+						      <&cpu3 15 15>,
+						      <&fan0 2 3>;
 				};
 				map2 {
 				     trip = <&cpu_alert0>;
 				     cooling-device = <&fan0 0 1>;
 				};
-				map3 {
-				     trip = <&cpu_alert1>;
-				     cooling-device = <&fan0 1 2>;
-				};
-				map4 {
-				     trip = <&cpu_alert2>;
-				     cooling-device = <&fan0 2 3>;
-				};
 			};
 		};
 	};
diff --git a/arch/arm/boot/dts/exynos4412.dtsi b/arch/arm/boot/dts/exynos4412.dtsi
index 51f72f0327e52..cd04bb4aea5f8 100644
--- a/arch/arm/boot/dts/exynos4412.dtsi
+++ b/arch/arm/boot/dts/exynos4412.dtsi
@@ -45,7 +45,7 @@
 			#cooling-cells = <2>; /* min followed by max */
 		};
 
-		cpu@a01 {
+		cpu1: cpu@a01 {
 			device_type = "cpu";
 			compatible = "arm,cortex-a9";
 			reg = <0xA01>;
@@ -55,7 +55,7 @@
 			#cooling-cells = <2>; /* min followed by max */
 		};
 
-		cpu@a02 {
+		cpu2: cpu@a02 {
 			device_type = "cpu";
 			compatible = "arm,cortex-a9";
 			reg = <0xA02>;
@@ -65,7 +65,7 @@
 			#cooling-cells = <2>; /* min followed by max */
 		};
 
-		cpu@a03 {
+		cpu3: cpu@a03 {
 			device_type = "cpu";
 			compatible = "arm,cortex-a9";
 			reg = <0xA03>;
diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
index b85527faa6ea4..e6b1a8a9b832c 100644
--- a/arch/arm/boot/dts/exynos5250.dtsi
+++ b/arch/arm/boot/dts/exynos5250.dtsi
@@ -59,7 +59,7 @@
 			operating-points-v2 = <&cpu0_opp_table>;
 			#cooling-cells = <2>; /* min followed by max */
 		};
-		cpu@1 {
+		cpu1: cpu@1 {
 			device_type = "cpu";
 			compatible = "arm,cortex-a15";
 			reg = <1>;
@@ -1066,11 +1066,12 @@
 			cooling-maps {
 				map0 {
 				     /* Corresponds to 800MHz at freq_table */
-				     cooling-device = <&cpu0 9 9>;
+				     cooling-device = <&cpu0 9 9>, <&cpu1 9 9>;
 				};
 				map1 {
 				     /* Corresponds to 200MHz at freq_table */
-				     cooling-device = <&cpu0 15 15>;
+				     cooling-device = <&cpu0 15 15>,
+						      <&cpu1 15 15>;
 			       };
 		       };
 		};
diff --git a/arch/arm/boot/dts/exynos5422-odroidhc1.dts b/arch/arm/boot/dts/exynos5422-odroidhc1.dts
index abc6fb7d27259..fce5a4579693e 100644
--- a/arch/arm/boot/dts/exynos5422-odroidhc1.dts
+++ b/arch/arm/boot/dts/exynos5422-odroidhc1.dts
@@ -56,24 +56,30 @@
 				 */
 				map0 {
 					trip = <&cpu0_alert0>;
-					cooling-device = <&cpu0 0 2>;
-				};
-				map1 {
-					trip = <&cpu0_alert0>;
-					cooling-device = <&cpu4 0 2>;
+					cooling-device = <&cpu0 0 2>,
+							 <&cpu1 0 2>,
+							 <&cpu2 0 2>,
+							 <&cpu3 0 2>,
+							 <&cpu4 0 2>,
+							 <&cpu5 0 2>,
+							 <&cpu6 0 2>,
+							 <&cpu7 0 2>;
 				};
 				/*
 				 * When reaching cpu0_alert1, reduce CPU
 				 * further, down to 600 MHz (12 steps for big,
 				 * 7 steps for LITTLE).
 				 */
-				map2 {
-					trip = <&cpu0_alert1>;
-					cooling-device = <&cpu0 3 7>;
-				};
-				map3 {
+				map1 {
 					trip = <&cpu0_alert1>;
-					cooling-device = <&cpu4 3 12>;
+					cooling-device = <&cpu0 3 7>,
+							 <&cpu1 3 7>,
+							 <&cpu2 3 7>,
+							 <&cpu3 3 7>,
+							 <&cpu4 3 12>,
+							 <&cpu5 3 12>,
+							 <&cpu6 3 12>,
+							 <&cpu7 3 12>;
 				};
 			};
 		};
@@ -99,19 +105,25 @@
 			cooling-maps {
 				map0 {
 					trip = <&cpu1_alert0>;
-					cooling-device = <&cpu0 0 2>;
+					cooling-device = <&cpu0 0 2>,
+							 <&cpu1 0 2>,
+							 <&cpu2 0 2>,
+							 <&cpu3 0 2>,
+							 <&cpu4 0 2>,
+							 <&cpu5 0 2>,
+							 <&cpu6 0 2>,
+							 <&cpu7 0 2>;
 				};
 				map1 {
-					trip = <&cpu1_alert0>;
-					cooling-device = <&cpu4 0 2>;
-				};
-				map2 {
-					trip = <&cpu1_alert1>;
-					cooling-device = <&cpu0 3 7>;
-				};
-				map3 {
 					trip = <&cpu1_alert1>;
-					cooling-device = <&cpu4 3 12>;
+					cooling-device = <&cpu0 3 7>,
+							 <&cpu1 3 7>,
+							 <&cpu2 3 7>,
+							 <&cpu3 3 7>,
+							 <&cpu4 3 12>,
+							 <&cpu5 3 12>,
+							 <&cpu6 3 12>,
+							 <&cpu7 3 12>;
 				};
 			};
 		};
@@ -137,19 +149,25 @@
 			cooling-maps {
 				map0 {
 					trip = <&cpu2_alert0>;
-					cooling-device = <&cpu0 0 2>;
+					cooling-device = <&cpu0 0 2>,
+							 <&cpu1 0 2>,
+							 <&cpu2 0 2>,
+							 <&cpu3 0 2>,
+							 <&cpu4 0 2>,
+							 <&cpu5 0 2>,
+							 <&cpu6 0 2>,
+							 <&cpu7 0 2>;
 				};
 				map1 {
-					trip = <&cpu2_alert0>;
-					cooling-device = <&cpu4 0 2>;
-				};
-				map2 {
-					trip = <&cpu2_alert1>;
-					cooling-device = <&cpu0 3 7>;
-				};
-				map3 {
 					trip = <&cpu2_alert1>;
-					cooling-device = <&cpu4 3 12>;
+					cooling-device = <&cpu0 3 7>,
+							 <&cpu1 3 7>,
+							 <&cpu2 3 7>,
+							 <&cpu3 3 7>,
+							 <&cpu4 3 12>,
+							 <&cpu5 3 12>,
+							 <&cpu6 3 12>,
+							 <&cpu7 3 12>;
 				};
 			};
 		};
@@ -175,19 +193,25 @@
 			cooling-maps {
 				map0 {
 					trip = <&cpu3_alert0>;
-					cooling-device = <&cpu0 0 2>;
+					cooling-device = <&cpu0 0 2>,
+							 <&cpu1 0 2>,
+							 <&cpu2 0 2>,
+							 <&cpu3 0 2>,
+							 <&cpu4 0 2>,
+							 <&cpu5 0 2>,
+							 <&cpu6 0 2>,
+							 <&cpu7 0 2>;
 				};
 				map1 {
-					trip = <&cpu3_alert0>;
-					cooling-device = <&cpu4 0 2>;
-				};
-				map2 {
-					trip = <&cpu3_alert1>;
-					cooling-device = <&cpu0 3 7>;
-				};
-				map3 {
 					trip = <&cpu3_alert1>;
-					cooling-device = <&cpu4 3 12>;
+					cooling-device = <&cpu0 3 7>,
+							 <&cpu1 3 7>,
+							 <&cpu2 3 7>,
+							 <&cpu3 3 7>,
+							 <&cpu4 3 12>,
+							 <&cpu5 3 12>,
+							 <&cpu6 3 12>,
+							 <&cpu7 3 12>;
 				};
 			};
 		};
diff --git a/arch/arm/boot/dts/exynos5422-odroidxu3-common.dtsi b/arch/arm/boot/dts/exynos5422-odroidxu3-common.dtsi
index 96e281c0a118a..264651141d688 100644
--- a/arch/arm/boot/dts/exynos5422-odroidxu3-common.dtsi
+++ b/arch/arm/boot/dts/exynos5422-odroidxu3-common.dtsi
@@ -113,24 +113,30 @@
 				 */
 				map3 {
 					trip = <&cpu0_alert3>;
-					cooling-device = <&cpu0 0 2>;
-				};
-				map4 {
-					trip = <&cpu0_alert3>;
-					cooling-device = <&cpu4 0 2>;
+					cooling-device = <&cpu0 0 2>,
+							 <&cpu1 0 2>,
+							 <&cpu2 0 2>,
+							 <&cpu3 0 2>,
+							 <&cpu4 0 2>,
+							 <&cpu5 0 2>,
+							 <&cpu6 0 2>,
+							 <&cpu7 0 2>;
 				};
 				/*
 				 * When reaching cpu0_alert4, reduce CPU
 				 * further, down to 600 MHz (12 steps for big,
 				 * 7 steps for LITTLE).
 				 */
-				map5 {
-					trip = <&cpu0_alert4>;
-					cooling-device = <&cpu0 3 7>;
-				};
-				map6 {
+				map4 {
 					trip = <&cpu0_alert4>;
-					cooling-device = <&cpu4 3 12>;
+					cooling-device = <&cpu0 3 7>,
+							 <&cpu1 3 7>,
+							 <&cpu2 3 7>,
+							 <&cpu3 3 7>,
+							 <&cpu4 3 12>,
+							 <&cpu5 3 12>,
+							 <&cpu6 3 12>,
+							 <&cpu7 3 12>;
 				};
 			};
 		};
@@ -185,19 +191,25 @@
 				};
 				map3 {
 					trip = <&cpu1_alert3>;
-					cooling-device = <&cpu0 0 2>;
+					cooling-device = <&cpu0 0 2>,
+							 <&cpu1 0 2>,
+							 <&cpu2 0 2>,
+							 <&cpu3 0 2>,
+							 <&cpu4 0 2>,
+							 <&cpu5 0 2>,
+							 <&cpu6 0 2>,
+							 <&cpu7 0 2>;
 				};
 				map4 {
-					trip = <&cpu1_alert3>;
-					cooling-device = <&cpu4 0 2>;
-				};
-				map5 {
-					trip = <&cpu1_alert4>;
-					cooling-device = <&cpu0 3 7>;
-				};
-				map6 {
 					trip = <&cpu1_alert4>;
-					cooling-device = <&cpu4 3 12>;
+					cooling-device = <&cpu0 3 7>,
+							 <&cpu1 3 7>,
+							 <&cpu2 3 7>,
+							 <&cpu3 3 7>,
+							 <&cpu4 3 12>,
+							 <&cpu5 3 12>,
+							 <&cpu6 3 12>,
+							 <&cpu7 3 12>;
 				};
 			};
 		};
@@ -252,19 +264,25 @@
 				};
 				map3 {
 					trip = <&cpu2_alert3>;
-					cooling-device = <&cpu0 0 2>;
+					cooling-device = <&cpu0 0 2>,
+							 <&cpu1 0 2>,
+							 <&cpu2 0 2>,
+							 <&cpu3 0 2>,
+							 <&cpu4 0 2>,
+							 <&cpu5 0 2>,
+							 <&cpu6 0 2>,
+							 <&cpu7 0 2>;
 				};
 				map4 {
-					trip = <&cpu2_alert3>;
-					cooling-device = <&cpu4 0 2>;
-				};
-				map5 {
-					trip = <&cpu2_alert4>;
-					cooling-device = <&cpu0 3 7>;
-				};
-				map6 {
 					trip = <&cpu2_alert4>;
-					cooling-device = <&cpu4 3 12>;
+					cooling-device = <&cpu0 3 7>,
+							 <&cpu1 3 7>,
+							 <&cpu2 3 7>,
+							 <&cpu3 3 7>,
+							 <&cpu4 3 12>,
+							 <&cpu5 3 12>,
+							 <&cpu6 3 12>,
+							 <&cpu7 3 12>;
 				};
 			};
 		};
@@ -319,19 +337,25 @@
 				};
 				map3 {
 					trip = <&cpu3_alert3>;
-					cooling-device = <&cpu0 0 2>;
+					cooling-device = <&cpu0 0 2>,
+							 <&cpu1 0 2>,
+							 <&cpu2 0 2>,
+							 <&cpu3 0 2>,
+							 <&cpu4 0 2>,
+							 <&cpu5 0 2>,
+							 <&cpu6 0 2>,
+							 <&cpu7 0 2>;
 				};
 				map4 {
-					trip = <&cpu3_alert3>;
-					cooling-device = <&cpu4 0 2>;
-				};
-				map5 {
-					trip = <&cpu3_alert4>;
-					cooling-device = <&cpu0 3 7>;
-				};
-				map6 {
 					trip = <&cpu3_alert4>;
-					cooling-device = <&cpu4 3 12>;
+					cooling-device = <&cpu0 3 7>,
+							 <&cpu1 3 7>,
+							 <&cpu2 3 7>,
+							 <&cpu3 3 7>,
+							 <&cpu4 3 12>,
+							 <&cpu5 3 12>,
+							 <&cpu6 3 12>,
+							 <&cpu7 3 12>;
 				};
 			};
 		};
-- 
2.39.2



