Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7361B48E5B8
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 09:21:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239740AbiANIUb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 03:20:31 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:60420 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239757AbiANIUE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 03:20:04 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 83D31B823E6;
        Fri, 14 Jan 2022 08:20:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADBA3C36AE9;
        Fri, 14 Jan 2022 08:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642148402;
        bh=RGSj+h2zb+URl3d/ZUP9kNXSzmJDXd7Pww6bPZbOtd0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zUfAHNOLLUMNU8KXfTacDZOgLsJsspXqVNZ11ZBVKXy2zZ8sUjIIxx4BpdNP0RsMY
         ZYu0wTqNX1FhRwDq/x4TLb3paHgjGf7JzO4pD5zr9Zw+C1SaVqIx5DELAm/IzjErCD
         QCOfvlVpV40KtLd0HRkAgyKRhm2nWiUoNxxyThRE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Cercueil <paul@crapouillou.net>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Subject: [PATCH 5.15 20/41] ARM: dts: exynos: Fix BCM4330 Bluetooth reset polarity in I9100
Date:   Fri, 14 Jan 2022 09:16:20 +0100
Message-Id: <20220114081545.832107395@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220114081545.158363487@linuxfoundation.org>
References: <20220114081545.158363487@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Cercueil <paul@crapouillou.net>

commit 9cb6de45a006a9799ec399bce60d64b6d4fcc4af upstream.

The reset GPIO was marked active-high, which is against what's specified
in the documentation. Mark the reset GPIO as active-low. With this
change, Bluetooth can now be used on the i9100.

Fixes: 8620cc2f99b7 ("ARM: dts: exynos: Add devicetree file for the Galaxy S2")
Cc: stable@vger.kernel.org
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Link: https://lore.kernel.org/r/20211031234137.87070-1-paul@crapouillou.net
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/exynos4210-i9100.dts |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/boot/dts/exynos4210-i9100.dts
+++ b/arch/arm/boot/dts/exynos4210-i9100.dts
@@ -827,7 +827,7 @@
 		compatible = "brcm,bcm4330-bt";
 
 		shutdown-gpios = <&gpl0 4 GPIO_ACTIVE_HIGH>;
-		reset-gpios = <&gpl1 0 GPIO_ACTIVE_HIGH>;
+		reset-gpios = <&gpl1 0 GPIO_ACTIVE_LOW>;
 		device-wakeup-gpios = <&gpx3 1 GPIO_ACTIVE_HIGH>;
 		host-wakeup-gpios = <&gpx2 6 GPIO_ACTIVE_HIGH>;
 	};


