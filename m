Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A90131D37
	for <lists+stable@lfdr.de>; Sat,  1 Jun 2019 15:27:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730001AbfFAN1j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Jun 2019 09:27:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:60364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729986AbfFAN1g (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 1 Jun 2019 09:27:36 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB35B272B3;
        Sat,  1 Jun 2019 13:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559395655;
        bh=xOvQbVHOT4atXGn1OEzGHIkApfrJXcXFOS/FWUZCrlc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sCaMQh2BST05L7wdVGTro2uDPbLHLPfI/ZSg5Ymd9ULxsiWdaafJc2Y8RPOWMvrqx
         xHtdxaHXJG0eRwAIKX4PBN55Ic/3CEcXSSBzb5kawJJfHO62zBk+iG0ogl9WpZpUoF
         kXUG/1OIQ+/ytTOFUKz/C287pCSM83YPPZeY7ZEw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzk@kernel.org>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 54/56] ARM: dts: exynos: Always enable necessary APIO_1V8 and ABB_1V8 regulators on Arndale Octa
Date:   Sat,  1 Jun 2019 09:25:58 -0400
Message-Id: <20190601132600.27427-54-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190601132600.27427-1-sashal@kernel.org>
References: <20190601132600.27427-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzk@kernel.org>

[ Upstream commit 5ab99cf7d5e96e3b727c30e7a8524c976bd3723d ]

The PVDD_APIO_1V8 (LDO2) and PVDD_ABB_1V8 (LDO8) regulators were turned
off by Linux kernel as unused.  However they supply critical parts of
SoC so they should be always on:

1. PVDD_APIO_1V8 supplies SYS pins (gpx[0-3], PSHOLD), HDMI level shift,
   RTC, VDD1_12 (DRAM internal 1.8 V logic), pull-up for PMIC interrupt
   lines, TTL/UARTR level shift, reset pins and SW-TACT1 button.
   It also supplies unused blocks like VDDQ_SRAM (for SROM controller) and
   VDDQ_GPIO (gpm7, gpy7).
   The LDO2 cannot be turned off (S2MPS11 keeps it on anyway) so
   marking it "always-on" only reflects its real status.

2. PVDD_ABB_1V8 supplies Adaptive Body Bias Generator for ARM cores,
   memory and Mali (G3D).

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/exynos5420-arndale-octa.dts | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/boot/dts/exynos5420-arndale-octa.dts b/arch/arm/boot/dts/exynos5420-arndale-octa.dts
index 4ecef6981d5c4..b54c0b8a5b346 100644
--- a/arch/arm/boot/dts/exynos5420-arndale-octa.dts
+++ b/arch/arm/boot/dts/exynos5420-arndale-octa.dts
@@ -97,6 +97,7 @@
 				regulator-name = "PVDD_APIO_1V8";
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <1800000>;
+				regulator-always-on;
 			};
 
 			ldo3_reg: LDO3 {
@@ -135,6 +136,7 @@
 				regulator-name = "PVDD_ABB_1V8";
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <1800000>;
+				regulator-always-on;
 			};
 
 			ldo9_reg: LDO9 {
-- 
2.20.1

