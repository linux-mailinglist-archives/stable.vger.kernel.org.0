Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93C0F3CE5C6
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:43:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345460AbhGSPxY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:53:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:47916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349764AbhGSPuV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:50:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 662A561924;
        Mon, 19 Jul 2021 16:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626712135;
        bh=sJ/DnlcTQwTw5VbWLwsAvRAJ3/+0OkQQNktX8+J0g20=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qdZYx2S9fbtw1i2kfIRTBb3KeGVq3eKUgNkRQr4SDDOJ2uisPurRPMYxuB5NjQK22
         GtH16q9pGS2EnXkYAY8M2yIj9zIxNwPJI/LfXTcX1X+zwbe3/MWzAHiPEuLXq3sEmT
         vmfEoINI3bg2jPlWCmwY1e61glUz39s83py6q1DE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 230/292] ARM: dts: exynos: fix PWM LED max brightness on Odroid XU/XU3
Date:   Mon, 19 Jul 2021 16:54:52 +0200
Message-Id: <20210719144950.529088756@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.514164272@linuxfoundation.org>
References: <20210719144942.514164272@linuxfoundation.org>
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
index 2fc3e86dc5f7..982752e1df24 100644
--- a/arch/arm/boot/dts/exynos54xx-odroidxu-leds.dtsi
+++ b/arch/arm/boot/dts/exynos54xx-odroidxu-leds.dtsi
@@ -22,7 +22,7 @@
 			 * Green LED is much brighter than the others
 			 * so limit its max brightness
 			 */
-			max_brightness = <127>;
+			max-brightness = <127>;
 			linux,default-trigger = "mmc0";
 		};
 
@@ -30,7 +30,7 @@
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



