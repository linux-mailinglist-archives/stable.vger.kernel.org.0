Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69E996ADAB7
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 10:44:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229798AbjCGJoM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 04:44:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229937AbjCGJoH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 04:44:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F1823D08A
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 01:43:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3BCF06126D
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:43:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 464CFC433EF;
        Tue,  7 Mar 2023 09:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678182232;
        bh=3ggxdl8ATuCP3GkUTxL0x5kl2D3bipsozthCis+qyhs=;
        h=Subject:To:Cc:From:Date:From;
        b=xR3fam/xZllsm/ll3YdA+LpiC+fPj+yA6nqWC0opRKXBhuxb0SdWyHk+qZZputSNo
         MJI3EbWupq/zcQAqFKr1uGwO/ztmk6Wo+DZDsKhMYimLEGt/aXuCuTEOY6GgPLm3TE
         Meuoy8wn7hhLSBM6+nTim68+ZykumsgIDBWqpHZg=
Subject: FAILED: patch "[PATCH] ARM: dts: exynos: correct TMU phandle in Odroid HC1" failed to apply to 4.19-stable tree
To:     krzysztof.kozlowski@linaro.org, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 07 Mar 2023 10:43:41 +0100
Message-ID: <16781822212785@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-4.19.y
git checkout FETCH_HEAD
git cherry-pick -x 2e3d0e20d8456f876607a8af61fdb83dfbf98cb6
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '16781822212785@kroah.com' --subject-prefix 'PATCH 4.19.y' HEAD^..

Possible dependencies:

2e3d0e20d845 ("ARM: dts: exynos: correct TMU phandle in Odroid HC1")
1c651356f482 ("ARM: dts: exynos: Add GPU thermal zone cooling maps for Odroid XU3/XU4/HC1")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 2e3d0e20d8456f876607a8af61fdb83dfbf98cb6 Mon Sep 17 00:00:00 2001
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Date: Thu, 9 Feb 2023 11:58:40 +0100
Subject: [PATCH] ARM: dts: exynos: correct TMU phandle in Odroid HC1

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

diff --git a/arch/arm/boot/dts/exynos5422-odroidhc1.dts b/arch/arm/boot/dts/exynos5422-odroidhc1.dts
index 3de7019572a2..5e4280393706 100644
--- a/arch/arm/boot/dts/exynos5422-odroidhc1.dts
+++ b/arch/arm/boot/dts/exynos5422-odroidhc1.dts
@@ -31,7 +31,7 @@
 
 	thermal-zones {
 		cpu0_thermal: cpu0-thermal {
-			thermal-sensors = <&tmu_cpu0 0>;
+			thermal-sensors = <&tmu_cpu0>;
 			trips {
 				cpu0_alert0: cpu-alert-0 {
 					temperature = <70000>; /* millicelsius */
@@ -86,7 +86,7 @@
 			};
 		};
 		cpu1_thermal: cpu1-thermal {
-			thermal-sensors = <&tmu_cpu1 0>;
+			thermal-sensors = <&tmu_cpu1>;
 			trips {
 				cpu1_alert0: cpu-alert-0 {
 					temperature = <70000>;
@@ -130,7 +130,7 @@
 			};
 		};
 		cpu2_thermal: cpu2-thermal {
-			thermal-sensors = <&tmu_cpu2 0>;
+			thermal-sensors = <&tmu_cpu2>;
 			trips {
 				cpu2_alert0: cpu-alert-0 {
 					temperature = <70000>;
@@ -174,7 +174,7 @@
 			};
 		};
 		cpu3_thermal: cpu3-thermal {
-			thermal-sensors = <&tmu_cpu3 0>;
+			thermal-sensors = <&tmu_cpu3>;
 			trips {
 				cpu3_alert0: cpu-alert-0 {
 					temperature = <70000>;
@@ -218,7 +218,7 @@
 			};
 		};
 		gpu_thermal: gpu-thermal {
-			thermal-sensors = <&tmu_gpu 0>;
+			thermal-sensors = <&tmu_gpu>;
 			trips {
 				gpu_alert0: gpu-alert-0 {
 					temperature = <70000>;

