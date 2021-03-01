Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23BDA328637
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:07:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232419AbhCARGi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:06:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:59160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234807AbhCAQ7T (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:59:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 540FD64FED;
        Mon,  1 Mar 2021 16:37:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616668;
        bh=B7XW7BLs2z4ebKxTAMHvLPksR/2GuNm+Z4BT0ZXd2Uw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eFEEeTWbZJzSttzmloKdYYkiBYCuzHK+Pl4yHU7uzUeupSi4eH0MFIRUQ95+G5Qxe
         02N7QYGOLV0BuXzbkd5Or30+6MNvNFN5DDqRFS1NjAy+FodKP5FS2LciS5JArXcGat
         xfac9KtHyf+hG3+2TpSa2YBLBSPeX7yCG5Zt6GHw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 027/247] ARM: dts: exynos: correct PMIC interrupt trigger level on Artik 5
Date:   Mon,  1 Mar 2021 17:10:47 +0100
Message-Id: <20210301161033.025438796@linuxfoundation.org>
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

[ Upstream commit cb31334687db31c691901269d65074a7ffaecb18 ]

The Samsung PMIC datasheets describe the interrupt line as active low
with a requirement of acknowledge from the CPU.  Without specifying the
interrupt type in Devicetree, kernel might apply some fixed
configuration, not necessarily working for this hardware.

Fixes: b004a34bd0ff ("ARM: dts: exynos: Add exynos3250-artik5 dtsi file for ARTIK5 module")
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Link: https://lore.kernel.org/r/20201210212903.216728-1-krzk@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/exynos3250-artik5.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/exynos3250-artik5.dtsi b/arch/arm/boot/dts/exynos3250-artik5.dtsi
index 7c22cbf6f3d41..6e30db644c83a 100644
--- a/arch/arm/boot/dts/exynos3250-artik5.dtsi
+++ b/arch/arm/boot/dts/exynos3250-artik5.dtsi
@@ -68,7 +68,7 @@
 	s2mps14_pmic@66 {
 		compatible = "samsung,s2mps14-pmic";
 		interrupt-parent = <&gpx3>;
-		interrupts = <5 IRQ_TYPE_NONE>;
+		interrupts = <5 IRQ_TYPE_LEVEL_LOW>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&s2mps14_irq>;
 		reg = <0x66>;
-- 
2.27.0



