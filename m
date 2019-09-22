Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04309BA733
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404759AbfIVS4f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 14:56:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:58734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404473AbfIVS4f (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:56:35 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE48B21A4A;
        Sun, 22 Sep 2019 18:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178594;
        bh=ynYx037q2k8foXoI60jbKLN69/59PWUHOAgkDPUJ1Ok=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IFKgLLA6YnXhNRQf4gsLHg+amuRmDTsmtJssek+kmXYkca2N8tXf9gr7mPVTeKQe5
         e1K01DkUEeLzNT5riHcynKdraRoTQs7KX8raIe4EfE6Za3bUta8CIs/hMwn/Brx8se
         nUeI3sd+dlANZBIXeMOr6O3co3WsL+1Kbme2pEes=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marek Szyprowski <m.szyprowski@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 099/128] ARM: dts: exynos: Mark LDO10 as always-on on Peach Pit/Pi Chromebooks
Date:   Sun, 22 Sep 2019 14:53:49 -0400
Message-Id: <20190922185418.2158-99-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922185418.2158-1-sashal@kernel.org>
References: <20190922185418.2158-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Szyprowski <m.szyprowski@samsung.com>

[ Upstream commit 5b0eeeaa37615df37a9a30929b73e9defe61ca84 ]

Commit aff138bf8e37 ("ARM: dts: exynos: Add TMU nodes regulator supply
for Peach boards") assigned LDO10 to Exynos Thermal Measurement Unit,
but it turned out that it supplies also some other critical parts and
board freezes/crashes when it is turned off.

The mentioned commit made Exynos TMU a consumer of that regulator and in
typical case Exynos TMU driver keeps it enabled from early boot. However
there are such configurations (example is multi_v7_defconfig), in which
some of the regulators are compiled as modules and are not available
from early boot. In such case it may happen that LDO10 is turned off by
regulator core, because it has no consumers yet (in this case consumer
drivers cannot get it, because the supply regulators for it are not yet
available). This in turn causes the board to crash. This patch restores
'always-on' property for the LDO10 regulator.

Fixes: aff138bf8e37 ("ARM: dts: exynos: Add TMU nodes regulator supply for Peach boards")
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/exynos5420-peach-pit.dts | 1 +
 arch/arm/boot/dts/exynos5800-peach-pi.dts  | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/arm/boot/dts/exynos5420-peach-pit.dts b/arch/arm/boot/dts/exynos5420-peach-pit.dts
index 57c2332bf2824..25bdc9d97a4df 100644
--- a/arch/arm/boot/dts/exynos5420-peach-pit.dts
+++ b/arch/arm/boot/dts/exynos5420-peach-pit.dts
@@ -437,6 +437,7 @@
 				regulator-name = "vdd_ldo10";
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <1800000>;
+				regulator-always-on;
 				regulator-state-mem {
 					regulator-off-in-suspend;
 				};
diff --git a/arch/arm/boot/dts/exynos5800-peach-pi.dts b/arch/arm/boot/dts/exynos5800-peach-pi.dts
index d80ab9085da19..7989631b39ccf 100644
--- a/arch/arm/boot/dts/exynos5800-peach-pi.dts
+++ b/arch/arm/boot/dts/exynos5800-peach-pi.dts
@@ -437,6 +437,7 @@
 				regulator-name = "vdd_ldo10";
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <1800000>;
+				regulator-always-on;
 				regulator-state-mem {
 					regulator-off-in-suspend;
 				};
-- 
2.20.1

