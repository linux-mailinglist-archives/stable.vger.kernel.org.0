Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70EB4F6630
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 04:12:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728289AbfKJCnX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 21:43:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:41272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728278AbfKJCnW (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 21:43:22 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3208E21019;
        Sun, 10 Nov 2019 02:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573353801;
        bh=i1YyJb5sAQ180K+dHjN3dhEjhX9emQ4nwBfvjmRp7l8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qgnHfjum20xX5/TOA3XIqkq0Fa1fKDMndSoRCxdsJx8Nqy8NVT+9DTl+rYXgrLtGc
         kN+7yKo/hBzMSKSyN97hxqkWhB80fw2KIjlxWCTxAYkuv9FDgyZIaICbgQSaZ5esfj
         4lHrBYFJn6G28ydX/TNvcPRXNcyiOtNdpyYToLcY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marek Szyprowski <m.szyprowski@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 100/191] ARM: dts: exynos: Correct audio subsystem parent clock on Peach Chromebooks
Date:   Sat,  9 Nov 2019 21:38:42 -0500
Message-Id: <20191110024013.29782-100-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024013.29782-1-sashal@kernel.org>
References: <20191110024013.29782-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Szyprowski <m.szyprowski@samsung.com>

[ Upstream commit ff1e37c6809daab75f7b2dea1efe69330e8eb65b ]

The proper parent clock for audio subsystem for Exynos5420 and Exynos5800
SoCs is CLK_MAU_EPLL. This fixes following warning:

    clk: failed to reparent mout_audss to fout_epll: -22

Fixes: ed7d1307077e: ARM: dts: exynos: Enable HDMI audio support on Peach Pit
Fixes: bae0f445c1e7: ARM: dts: exynos: Enable HDMI audio support on Peach Pi
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/exynos5420-peach-pit.dts | 2 +-
 arch/arm/boot/dts/exynos5800-peach-pi.dts  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/exynos5420-peach-pit.dts b/arch/arm/boot/dts/exynos5420-peach-pit.dts
index 25bdc9d97a4df..3e666caa86bfe 100644
--- a/arch/arm/boot/dts/exynos5420-peach-pit.dts
+++ b/arch/arm/boot/dts/exynos5420-peach-pit.dts
@@ -153,7 +153,7 @@
 
 &clock_audss {
 	assigned-clocks = <&clock_audss EXYNOS_MOUT_AUDSS>;
-	assigned-clock-parents = <&clock CLK_FOUT_EPLL>;
+	assigned-clock-parents = <&clock CLK_MAU_EPLL>;
 };
 
 &cpu0 {
diff --git a/arch/arm/boot/dts/exynos5800-peach-pi.dts b/arch/arm/boot/dts/exynos5800-peach-pi.dts
index 7989631b39ccf..90222ec19f877 100644
--- a/arch/arm/boot/dts/exynos5800-peach-pi.dts
+++ b/arch/arm/boot/dts/exynos5800-peach-pi.dts
@@ -153,7 +153,7 @@
 
 &clock_audss {
 	assigned-clocks = <&clock_audss EXYNOS_MOUT_AUDSS>;
-	assigned-clock-parents = <&clock CLK_FOUT_EPLL>;
+	assigned-clock-parents = <&clock CLK_MAU_EPLL>;
 };
 
 &cpu0 {
-- 
2.20.1

