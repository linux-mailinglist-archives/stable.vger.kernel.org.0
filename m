Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E2F52E3AFD
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:44:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404568AbgL1NoU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:44:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:44964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404463AbgL1NoS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:44:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7AC0A2072C;
        Mon, 28 Dec 2020 13:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163018;
        bh=YMPTSssMi1YmhhP66jNW89dJEyt9dUSiPtp+sq5D8GU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=brsmcsu4QfEvW1V76JnC7havhKRs9lgFkIUHHIKG7jNhGjzCRO0jK+XnLVmNXZXFv
         fZhAMsi6QA4jWGxgiI0Eb9nNi3bN56IO1Ako2Pq4+QxiqR3xzZKDshWTUlkBDalOvt
         aaDqN2TcwKHGXaM2Kd0lp1cORJOakv06zrDFZpYw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pawe=C5=82=20Chmiel?= <pawel.mikolaj.chmiel@gmail.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 110/453] arm64: dts: exynos: Include common syscon restart/poweroff for Exynos7
Date:   Mon, 28 Dec 2020 13:45:46 +0100
Message-Id: <20201228124942.506487667@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
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
index 0821489a874de..c5be82d48c986 100644
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
@@ -650,3 +643,4 @@
 };
 
 #include "exynos7-pinctrl.dtsi"
+#include "arm/exynos-syscon-restart.dtsi"
-- 
2.27.0



