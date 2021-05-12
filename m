Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CB0637C143
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 16:57:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232148AbhELO6T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 10:58:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:46196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232160AbhELO4s (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 10:56:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A91BB61418;
        Wed, 12 May 2021 14:55:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620831312;
        bh=NqQ3C/5w2D5sCsF76gawlCZVEDjgEQZ7PNxkhEKu3Mk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dFhqDnYGJRXkQF3fib51hT/M0wgssLvTiw+tNRFE+5cfSrCKSH+k7yukiN18L0Eto
         e0L3TCgerBc20JiuC1IrBpU3GO/+CzVEsugjJEV7tXJl7S9wlfv11wHVUhK0EhF82o
         fjs0bozmO+wOUpWjISLNo2IIt7y2qGvfHbo20OmQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 069/244] ARM: dts: exynos: correct PMIC interrupt trigger level on Odroid X/U3 family
Date:   Wed, 12 May 2021 16:47:20 +0200
Message-Id: <20210512144745.244224047@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144743.039977287@linuxfoundation.org>
References: <20210512144743.039977287@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzk@kernel.org>

[ Upstream commit 6503c568e97a52f8b7a3109718db438e52e59485 ]

The Maxim PMIC datasheets describe the interrupt line as active low
with a requirement of acknowledge from the CPU.  Without specifying the
interrupt type in Devicetree, kernel might apply some fixed
configuration, not necessarily working for this hardware.

Additionally, the interrupt line is shared so using level sensitive
interrupt is here especially important to avoid races.

Fixes: eea6653aae7b ("ARM: dts: Enable PMIC interrupts for exynos4412-odroid-common")
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Link: https://lore.kernel.org/r/20201210212534.216197-6-krzk@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/exynos4412-odroid-common.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/exynos4412-odroid-common.dtsi b/arch/arm/boot/dts/exynos4412-odroid-common.dtsi
index ea55f377d17c..424d12ecc901 100644
--- a/arch/arm/boot/dts/exynos4412-odroid-common.dtsi
+++ b/arch/arm/boot/dts/exynos4412-odroid-common.dtsi
@@ -274,7 +274,7 @@
 	max77686: pmic@9 {
 		compatible = "maxim,max77686";
 		interrupt-parent = <&gpx3>;
-		interrupts = <2 IRQ_TYPE_NONE>;
+		interrupts = <2 IRQ_TYPE_LEVEL_LOW>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&max77686_irq>;
 		reg = <0x09>;
-- 
2.30.2



