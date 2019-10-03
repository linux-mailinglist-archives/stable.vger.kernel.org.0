Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B7F7CA304
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:14:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732949AbfJCQLX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:11:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:33100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732680AbfJCQLX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:11:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C03620865;
        Thu,  3 Oct 2019 16:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570119082;
        bh=O45hS1XFtek78qi/yy2DUdGSAsD3n7PiKl6lfkTw7f8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=urZ2X1xzq0suIy7+WiADftNJbpyqXBACpev52zTrUuq3j+Hh9mkftkqZTdQkFaSsF
         kShEegMqQG83mVWsv8iTiWjAOAc69KCtulSBGMpb7uGaY3Z7DoGMEOnJzwVBgV2+Pv
         quTWNZcr5PYAz9qKPgCL80gG30MV0g4VJk1lxnfQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 118/185] ARM: dts: exynos: Mark LDO10 as always-on on Peach Pit/Pi Chromebooks
Date:   Thu,  3 Oct 2019 17:53:16 +0200
Message-Id: <20191003154504.880906309@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154437.541662648@linuxfoundation.org>
References: <20191003154437.541662648@linuxfoundation.org>
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
index c91eff8475a87..7ccee2cfe4812 100644
--- a/arch/arm/boot/dts/exynos5420-peach-pit.dts
+++ b/arch/arm/boot/dts/exynos5420-peach-pit.dts
@@ -426,6 +426,7 @@
 				regulator-name = "vdd_ldo10";
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <1800000>;
+				regulator-always-on;
 				regulator-state-mem {
 					regulator-off-in-suspend;
 				};
diff --git a/arch/arm/boot/dts/exynos5800-peach-pi.dts b/arch/arm/boot/dts/exynos5800-peach-pi.dts
index daad5d425cf5c..0900b38f60b4f 100644
--- a/arch/arm/boot/dts/exynos5800-peach-pi.dts
+++ b/arch/arm/boot/dts/exynos5800-peach-pi.dts
@@ -426,6 +426,7 @@
 				regulator-name = "vdd_ldo10";
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <1800000>;
+				regulator-always-on;
 				regulator-state-mem {
 					regulator-off-in-suspend;
 				};
-- 
2.20.1



