Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D767CA552
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:35:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391983AbfJCQdQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:33:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:41178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391274AbfJCQdP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:33:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 68A2A2086A;
        Thu,  3 Oct 2019 16:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570120394;
        bh=3iuTUPH38z8GhXhGf0ZoFLJizgr0/Dx+jX0EiSbp/nM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xj2RCNOx8xUR0JmPnUsIem2LeZ39ftM+2PufEbBvSa2+NepWEWp5no33EPaGdbjSq
         kZmW0vrRlV/bKSXv3uJMJx+2MixOVm1TUtGI9hznE7a1gSkctQfwcxR51gnVhQSTq+
         8ijgMJSuN0ytrNbxhUeQaeu7dq6ey1lbmWbcthds=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 168/313] ARM: dts: exynos: Mark LDO10 as always-on on Peach Pit/Pi Chromebooks
Date:   Thu,  3 Oct 2019 17:52:26 +0200
Message-Id: <20191003154549.512120380@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154533.590915454@linuxfoundation.org>
References: <20191003154533.590915454@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index f78db6809cca4..9eb48cabcca45 100644
--- a/arch/arm/boot/dts/exynos5420-peach-pit.dts
+++ b/arch/arm/boot/dts/exynos5420-peach-pit.dts
@@ -440,6 +440,7 @@
 				regulator-name = "vdd_ldo10";
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <1800000>;
+				regulator-always-on;
 				regulator-state-mem {
 					regulator-off-in-suspend;
 				};
diff --git a/arch/arm/boot/dts/exynos5800-peach-pi.dts b/arch/arm/boot/dts/exynos5800-peach-pi.dts
index e0f470fe54c81..4398f2d1fe881 100644
--- a/arch/arm/boot/dts/exynos5800-peach-pi.dts
+++ b/arch/arm/boot/dts/exynos5800-peach-pi.dts
@@ -440,6 +440,7 @@
 				regulator-name = "vdd_ldo10";
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <1800000>;
+				regulator-always-on;
 				regulator-state-mem {
 					regulator-off-in-suspend;
 				};
-- 
2.20.1



