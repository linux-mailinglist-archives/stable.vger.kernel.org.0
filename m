Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A1A86905F4
	for <lists+stable@lfdr.de>; Thu,  9 Feb 2023 11:59:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230116AbjBIK7k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Feb 2023 05:59:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229941AbjBIK7c (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Feb 2023 05:59:32 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D986C12F07
        for <stable@vger.kernel.org>; Thu,  9 Feb 2023 02:58:59 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id ba1so1350860wrb.5
        for <stable@vger.kernel.org>; Thu, 09 Feb 2023 02:58:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MNu/Kq5YO5u+A14KW4yemS89GxvSBvk/6+CEjY6IekA=;
        b=iz/gWjsHgtekoOHBySRM8twbFpzAeFgs07tGqu+gRe3S5q5NcYzl3nBt9K8Ox2uiFN
         KRihdcm5pXZo2x0M2M+ZXgpaZksnyf7PvtGY+JPJgwlgmv6QJRU+6POgc+XpgKzEM89e
         gqlE0xoL1HzWhxK0I075RQpbBpPojxIPKSeViZ0GsuC+MpZmKfF9QzK9MDWLj9rx/CTK
         yYRdXB4BB82wSrPno91cC3MkYQTBHAaudoRypXJ9xe0d0soKKbSj7rWyOEcXRFMFp/oW
         vWFxV28qcUou0C/kcQ6CBdQJHr8eArOiHnBVK/fsXEZNe813sYkdxP9PUUS/nkfo+x+1
         E03Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MNu/Kq5YO5u+A14KW4yemS89GxvSBvk/6+CEjY6IekA=;
        b=HVKXqyPQEfKb3plDhqM1RG5KcDQQ10TlR2Xn2YbAuT/pmbIxLYGVJxr0yDkN6WTB6p
         wdOe0TUMJauexqvXDxvCpOxMNNYC+P/rubF4oPtiwesJhWHWJ6PI08/pNNT34q1QXDD7
         dCVLSuNppXd9etOAWZ5zHpdEnkWNE2pCD/MYDX6hdjUyqsE9f+7sKvwzyFqsUfd4M/73
         KDyXeEvWV6TNcc5mfW5b+L9/ERX/Hc+DIBepIpfBvTfdvIJO8emnX2Mc/o4X0fsuyP7u
         4EUHnhwPWGgpl14syc6efA0zKV20E6rG15CrKokGm4oURVXfW1ZCnvJZBWfTK2miF7tr
         76Lg==
X-Gm-Message-State: AO0yUKWGIjOEyyc6dyAU88gDeisJ/mrFMNaC5uWZsMmaX2zf9+ySp1cq
        1dmhTkQKf5YPKICYp6foAyjb4w==
X-Google-Smtp-Source: AK7set87pvI0dw38uqL6CIrDJGb0xhuuFb/5Ocw4iZx+rV/bw4EmO3TXPdXGt5x+oxS/X5mc+112yw==
X-Received: by 2002:adf:da42:0:b0:2c3:dbaf:dcdc with SMTP id r2-20020adfda42000000b002c3dbafdcdcmr9394736wrl.18.1675940333391;
        Thu, 09 Feb 2023 02:58:53 -0800 (PST)
Received: from krzk-bin.. ([178.197.216.144])
        by smtp.gmail.com with ESMTPSA id g7-20020a5d6987000000b002be063f6820sm927987wru.81.2023.02.09.02.58.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 02:58:53 -0800 (PST)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To:     Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Eduardo Valentin <edubezval@gmail.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Kukjin Kim <kgene@kernel.org>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Anand Moon <linux.amoon@gmail.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        stable@vger.kernel.org
Subject: [PATCH 5/6] ARM: dts: exynos: correct TMU phandle in Odroid HC1
Date:   Thu,  9 Feb 2023 11:58:40 +0100
Message-Id: <20230209105841.779596-5-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230209105841.779596-1-krzysztof.kozlowski@linaro.org>
References: <20230209105841.779596-1-krzysztof.kozlowski@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 arch/arm/boot/dts/exynos5422-odroidhc1.dts | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm/boot/dts/exynos5422-odroidhc1.dts b/arch/arm/boot/dts/exynos5422-odroidhc1.dts
index 3de7019572a2..5e4280393706 100644
--- a/arch/arm/boot/dts/exynos5422-odroidhc1.dts
+++ b/arch/arm/boot/dts/exynos5422-odroidhc1.dts
@@ -31,7 +31,7 @@ led-1 {
 
 	thermal-zones {
 		cpu0_thermal: cpu0-thermal {
-			thermal-sensors = <&tmu_cpu0 0>;
+			thermal-sensors = <&tmu_cpu0>;
 			trips {
 				cpu0_alert0: cpu-alert-0 {
 					temperature = <70000>; /* millicelsius */
@@ -86,7 +86,7 @@ map1 {
 			};
 		};
 		cpu1_thermal: cpu1-thermal {
-			thermal-sensors = <&tmu_cpu1 0>;
+			thermal-sensors = <&tmu_cpu1>;
 			trips {
 				cpu1_alert0: cpu-alert-0 {
 					temperature = <70000>;
@@ -130,7 +130,7 @@ map1 {
 			};
 		};
 		cpu2_thermal: cpu2-thermal {
-			thermal-sensors = <&tmu_cpu2 0>;
+			thermal-sensors = <&tmu_cpu2>;
 			trips {
 				cpu2_alert0: cpu-alert-0 {
 					temperature = <70000>;
@@ -174,7 +174,7 @@ map1 {
 			};
 		};
 		cpu3_thermal: cpu3-thermal {
-			thermal-sensors = <&tmu_cpu3 0>;
+			thermal-sensors = <&tmu_cpu3>;
 			trips {
 				cpu3_alert0: cpu-alert-0 {
 					temperature = <70000>;
@@ -218,7 +218,7 @@ map1 {
 			};
 		};
 		gpu_thermal: gpu-thermal {
-			thermal-sensors = <&tmu_gpu 0>;
+			thermal-sensors = <&tmu_gpu>;
 			trips {
 				gpu_alert0: gpu-alert-0 {
 					temperature = <70000>;
-- 
2.34.1

