Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13BCD2E65FE
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:08:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389000AbgL1QGt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 11:06:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:55106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389524AbgL1N0i (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:26:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 526A522475;
        Mon, 28 Dec 2020 13:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161983;
        bh=3eWDB9OsAbmc9/uqUMhmfDFYxJ0LVDMxRLeyCrIVHV8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bsTuzgBJ2FFmZupB2phb+wNKLt2Buif6ELYF5ol4UtgaKHvMQe2SO16eQoaXMSJf8
         EyObfmLgq0Y/ERiRCGvgLPsMVRQMz9+w4KsUmVv1ecqkAAviGBVtkWl4FbW8A0Ew87
         aWZdS/kpyryPbWtg+xG69sLUAqTClWS4BtMGgiX0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pawe=C5=82=20Chmiel?= <pawel.mikolaj.chmiel@gmail.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 121/346] arm64: dts: exynos: Include common syscon restart/poweroff for Exynos7
Date:   Mon, 28 Dec 2020 13:47:20 +0100
Message-Id: <20201228124925.646591886@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paweł Chmiel <pawel.mikolaj.chmiel@gmail.com>

[ Upstream commit 73bc7510ea0dafb4ff1ae6808759627a8ec51f5a ]

Exynos7 uses the same syscon reboot and poweroff nodes as other Exynos
SoCs, so instead of duplicating code we can just include common dtsi
file, which already contains definitions of them. After this change,
poweroff node will be also available, previously this dts file did
contain only reboot node.

Fixes: fb026cb65247 ("arm64: dts: Add reboot node for exynos7")
Fixes: b9024cbc937d ("arm64: dts: Add initial device tree support for exynos7")
Signed-off-by: Paweł Chmiel <pawel.mikolaj.chmiel@gmail.com>
Link: https://lore.kernel.org/r/20201107133926.37187-1-pawel.mikolaj.chmiel@gmail.com
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/exynos/exynos7.dtsi | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/arch/arm64/boot/dts/exynos/exynos7.dtsi b/arch/arm64/boot/dts/exynos/exynos7.dtsi
index 31b1a606cb664..38a07d9763a3f 100644
--- a/arch/arm64/boot/dts/exynos/exynos7.dtsi
+++ b/arch/arm64/boot/dts/exynos/exynos7.dtsi
@@ -494,13 +494,6 @@
 		pmu_system_controller: system-controller@105c0000 {
 			compatible = "samsung,exynos7-pmu", "syscon";
 			reg = <0x105c0000 0x5000>;
-
-			reboot: syscon-reboot {
-				compatible = "syscon-reboot";
-				regmap = <&pmu_system_controller>;
-				offset = <0x0400>;
-				mask = <0x1>;
-			};
 		};
 
 		rtc: rtc@10590000 {
@@ -638,3 +631,4 @@
 };
 
 #include "exynos7-pinctrl.dtsi"
+#include "arm/exynos-syscon-restart.dtsi"
-- 
2.27.0



