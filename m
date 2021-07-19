Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCECD3CDA6D
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:17:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244464AbhGSOfy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:35:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:47358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244676AbhGSOeR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:34:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C6D8D61285;
        Mon, 19 Jul 2021 15:13:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626707613;
        bh=9ToCizXFsijnGuvutrVvkbzrt0UaohYIt/PO8Y92xL0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m+1Q9p1jxcEjQ0SYJV5fhNtY7o33FXBAqiKh18ZieEkK4StKuV/NXZ3vct+B44i+c
         82tLPm7qFOxF4KE/ngHRWUXe5xc1W4Y/gP+zldqYFr1gfYscQVBrWzZqJKZ5O4H4Cy
         OIQ8Y/e5PueonYuMEq06I8cv6oNJiXx7Xu/9PM8k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 234/245] ARM: dts: exynos: fix PWM LED max brightness on Odroid XU/XU3
Date:   Mon, 19 Jul 2021 16:52:56 +0200
Message-Id: <20210719144947.946263998@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.288257948@linuxfoundation.org>
References: <20210719144940.288257948@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>

[ Upstream commit 75121e1dc9fe4def41e63d57f6a53749b88006ed ]

There is no "max_brightness" property.  This brings the intentional
brightness reduce of green LED and dtschema checks as well:

  arch/arm/boot/dts/exynos5410-odroidxu.dt.yaml: led-controller-1: led-1: 'max-brightness' is a required property

Fixes: 719f39fec586 ("ARM: dts: exynos5422-odroidxu3: Hook up PWM and use it for LEDs")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Link: https://lore.kernel.org/r/20210505135941.59898-3-krzysztof.kozlowski@canonical.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/exynos54xx-odroidxu-leds.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/exynos54xx-odroidxu-leds.dtsi b/arch/arm/boot/dts/exynos54xx-odroidxu-leds.dtsi
index 0ed30206625c..f547f67f2783 100644
--- a/arch/arm/boot/dts/exynos54xx-odroidxu-leds.dtsi
+++ b/arch/arm/boot/dts/exynos54xx-odroidxu-leds.dtsi
@@ -25,7 +25,7 @@
 			 * Green LED is much brighter than the others
 			 * so limit its max brightness
 			 */
-			max_brightness = <127>;
+			max-brightness = <127>;
 			linux,default-trigger = "mmc0";
 		};
 
@@ -33,7 +33,7 @@
 			label = "blue:heartbeat";
 			pwms = <&pwm 2 2000000 0>;
 			pwm-names = "pwm2";
-			max_brightness = <255>;
+			max-brightness = <255>;
 			linux,default-trigger = "heartbeat";
 		};
 	};
-- 
2.30.2



