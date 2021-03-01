Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89311328646
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:09:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237122AbhCARHm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:07:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:33308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236688AbhCARDR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:03:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 05BEF64FEF;
        Mon,  1 Mar 2021 16:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616689;
        bh=Li96Hy031LmYk0NW//eYTVV5d6JD9FSofoxk6L1/w4Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FLOxHw0S+Rb1Hfk4fyUE3zvuTCF5ol5aIEcIG6tttza3bQCBdIcFnkVmJ+AVr4dRK
         uUFxIOf/bBqt1kPoNCKio7H9AVad6gdoQwT26Refd/GYL2FO4pRGMyshJhmDHorYqv
         YWSOGPbucR3P9+xZn5Gz3HsEFKeQSxiOyBMPHf3E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 031/247] ARM: dts: exynos: correct PMIC interrupt trigger level on Arndale Octa
Date:   Mon,  1 Mar 2021 17:10:51 +0100
Message-Id: <20210301161033.207113299@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161031.684018251@linuxfoundation.org>
References: <20210301161031.684018251@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzk@kernel.org>

[ Upstream commit 1ac8893c4fa3d4a34915dc5cdab568a39db5086c ]

The Samsung PMIC datasheets describe the interrupt line as active low
with a requirement of acknowledge from the CPU.  The falling edge
interrupt will mostly work but it's not correct.

Fixes: 1fed2252713e ("ARM: dts: fix pinctrl for s2mps11-irq on exynos5420-arndale-octa")
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Link: https://lore.kernel.org/r/20201210212903.216728-5-krzk@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/exynos5420-arndale-octa.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/exynos5420-arndale-octa.dts b/arch/arm/boot/dts/exynos5420-arndale-octa.dts
index a370857beac0d..fbaca74cbaea4 100644
--- a/arch/arm/boot/dts/exynos5420-arndale-octa.dts
+++ b/arch/arm/boot/dts/exynos5420-arndale-octa.dts
@@ -84,7 +84,7 @@
 		reg = <0x66>;
 
 		interrupt-parent = <&gpx3>;
-		interrupts = <2 IRQ_TYPE_EDGE_FALLING>;
+		interrupts = <2 IRQ_TYPE_LEVEL_LOW>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&s2mps11_irq>;
 
-- 
2.27.0



