Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02948328FC1
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:01:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242395AbhCAT5q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:57:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:55162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235703AbhCATor (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:44:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 51D62650A7;
        Mon,  1 Mar 2021 17:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620106;
        bh=VVXnvKARqbj73+n20UVfpqm9XfExt99n6HGFu8Z9xVA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XkVX4aV+sqUmQroSAiDsmswbP/ABq0RuMarw6CaFPdT2mge3jpuY8UBd4mv0WyDaG
         /XbhDxn60ptSdm6Uy4Zr2dhRhaYvnUtgvTZbxl8tnIpTjbHxuKC+ZEY1Ts/pgegOvq
         s31RbW10Z/mDiCeapNmhjeSvEKtY4cHYHFpjT0as=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 031/775] ARM: dts: exynos: correct PMIC interrupt trigger level on Rinato
Date:   Mon,  1 Mar 2021 17:03:19 +0100
Message-Id: <20210301161203.256841384@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzk@kernel.org>

[ Upstream commit 437ae60947716bb479e2f32466f49445c0509b1e ]

The Samsung PMIC datasheets describe the interrupt line as active low
with a requirement of acknowledge from the CPU.  Without specifying the
interrupt type in Devicetree, kernel might apply some fixed
configuration, not necessarily working for this hardware.

Fixes: faaf348ef468 ("ARM: dts: Add board dts file for exynos3250-rinato")
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Link: https://lore.kernel.org/r/20201210212903.216728-3-krzk@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/exynos3250-rinato.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/exynos3250-rinato.dts b/arch/arm/boot/dts/exynos3250-rinato.dts
index a26e3e582a7e7..d64ccf4b7d324 100644
--- a/arch/arm/boot/dts/exynos3250-rinato.dts
+++ b/arch/arm/boot/dts/exynos3250-rinato.dts
@@ -270,7 +270,7 @@
 	pmic@66 {
 		compatible = "samsung,s2mps14-pmic";
 		interrupt-parent = <&gpx0>;
-		interrupts = <7 IRQ_TYPE_NONE>;
+		interrupts = <7 IRQ_TYPE_LEVEL_LOW>;
 		reg = <0x66>;
 		wakeup-source;
 
-- 
2.27.0



