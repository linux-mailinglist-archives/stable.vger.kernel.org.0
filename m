Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AC641017D1
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:04:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727301AbfKSFjH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:39:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:33106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729113AbfKSFjF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:39:05 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7ED90206EC;
        Tue, 19 Nov 2019 05:39:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141945;
        bh=NMPNEBM0ZqzblQuub571ZXHEph2ZQyjpjHS66QSs94U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GYFKn/5YlOFXEcvTY8xIB0WDy9n8fon/VAyazlZFtj0v+WaJheplbYni4blrkbQIU
         uNeTeOeK79PHhLb7BWHGcDcHiTG7U/WQYhDlQ38cqY3WNhzFiG72guNe27ydpv1SvS
         RStg8p+QZDvV/wVzaOaXFpaLef4zENJhSlr741vs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 334/422] ARM: dts: exynos: Correct audio subsystem parent clock on Peach Chromebooks
Date:   Tue, 19 Nov 2019 06:18:51 +0100
Message-Id: <20191119051420.660741996@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 769d60d6c9006..9eb48cabcca45 100644
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
index 492e2cd2e559e..4398f2d1fe881 100644
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



