Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C02A6B4460
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:23:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232318AbjCJOXa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:23:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232221AbjCJOWy (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:22:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D70911ACAB
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:22:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E434F617B4
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:22:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E09B0C433EF;
        Fri, 10 Mar 2023 14:22:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678458144;
        bh=pkPIXgMWwT4wEDy1AJGqcdjHB6ZuViFM3AQXGJoix5k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FoMXC1n2LqQhY6BTltuxSL1eEXQf883HZXiqOKwtvMQ933x5dq3GLfZCKy+cgGC/9
         dSRrlwG5rAeF4BlB4mlSGJQw4ey+PKSG6bgsMGAM4pAo9fTlGnuBiPrNDwJdJi9y0X
         bmWXuu3byY9DVcSP3RXzKCsiWwUYMLQU7vDuA4eY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 4.19 178/252] ARM: dts: exynos: correct TMU phandle in Odroid XU
Date:   Fri, 10 Mar 2023 14:39:08 +0100
Message-Id: <20230310133724.251528194@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.803482157@linuxfoundation.org>
References: <20230310133718.803482157@linuxfoundation.org>
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
@@ -113,7 +113,6 @@
 };
 
 &cpu0_thermal {
-	thermal-sensors = <&tmu_cpu0 0>;
 	polling-delay-passive = <0>;
 	polling-delay = <0>;
 


