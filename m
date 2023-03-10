Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9EC76B4981
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:13:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233781AbjCJPNY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:13:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234070AbjCJPMz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:12:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9F5E12EE79
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 07:04:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D40BF6187C
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 15:03:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBDDDC433EF;
        Fri, 10 Mar 2023 15:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678460617;
        bh=NaX7V+gohbtE2nO5s3MCd4BEQz1hWz649rSjz779D2Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qLkwUTE80iGpElktnKyjNlR56GFfvtvzhvW2gXHD/Ksn0EjFJR8Oo4dawHD/aSqTp
         ZRZLV6KjbtBIuOE3bm9uZ37B8RTPq3J7D6YbmayYRU3l9oXU6IWkny18OMv/BqNnl0
         oXZoay9HacdaH9gK9ZiB4JsYeotPQdyOrt+fbh9c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 5.10 395/529] ARM: dts: exynos: correct TMU phandle in Odroid XU
Date:   Fri, 10 Mar 2023 14:38:58 +0100
Message-Id: <20230310133823.295367736@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit 9372eca505e7a19934d750b4b4c89a3652738e66 upstream.

TMU node uses 0 as thermal-sensor-cells, thus thermal zone referencing
it must not have an argument to phandle.  Since thermal-sensors property
is already defined in included exynosi5410.dtsi, drop it from
exynos5410-odroidxu.dts to fix the error and remoev redundancy.

Fixes: 88644b4c750b ("ARM: dts: exynos: Configure PWM, usb3503, PMIC and thermal on Odroid XU board")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20230209105841.779596-4-krzysztof.kozlowski@linaro.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/exynos5410-odroidxu.dts |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/arm/boot/dts/exynos5410-odroidxu.dts
+++ b/arch/arm/boot/dts/exynos5410-odroidxu.dts
@@ -116,7 +116,6 @@
 };
 
 &cpu0_thermal {
-	thermal-sensors = <&tmu_cpu0 0>;
 	polling-delay-passive = <0>;
 	polling-delay = <0>;
 


