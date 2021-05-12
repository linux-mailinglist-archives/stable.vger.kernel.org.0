Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E6A837C7B6
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:37:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236666AbhELQCN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:02:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:36902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238097AbhELP5U (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:57:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 16E4061C51;
        Wed, 12 May 2021 15:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833407;
        bh=qtEb2y9YlX0nBzC9odvWW+tYSXTCKZYaqVT6uyM8Zmk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I7uE8MMTobuxMm/VlZj1Ob3EaXookKLWJDSNejwADhoUJXlxVIR6JYhHDohk++yBd
         dlvAttySQNPCrQDnfLD6AU0BEhumCReAT4O7Laf5D4L/IOIua4DV45a+GWa/u5mpFH
         XxInkyQ6S7xJ034wZpby7u7FSN+MUDyglkGPlzfM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 136/601] ARM: dts: exynos: correct PMIC interrupt trigger level on SMDK5250
Date:   Wed, 12 May 2021 16:43:33 +0200
Message-Id: <20210512144832.303835577@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzk@kernel.org>

[ Upstream commit f6368c60561370e4a92fac22982a3bd656172170 ]

The Maxim PMIC datasheets describe the interrupt line as active low
with a requirement of acknowledge from the CPU.  Without specifying the
interrupt type in Devicetree, kernel might apply some fixed
configuration, not necessarily working for this hardware.

Additionally, the interrupt line is shared so using level sensitive
interrupt is here especially important to avoid races.

Fixes: 47580e8d94c2 ("ARM: dts: Specify MAX77686 pmic interrupt for exynos5250-smdk5250")
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Link: https://lore.kernel.org/r/20201210212534.216197-8-krzk@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/exynos5250-smdk5250.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/exynos5250-smdk5250.dts b/arch/arm/boot/dts/exynos5250-smdk5250.dts
index 8b5a79a8720c..39bbe18145cf 100644
--- a/arch/arm/boot/dts/exynos5250-smdk5250.dts
+++ b/arch/arm/boot/dts/exynos5250-smdk5250.dts
@@ -134,7 +134,7 @@
 		compatible = "maxim,max77686";
 		reg = <0x09>;
 		interrupt-parent = <&gpx3>;
-		interrupts = <2 IRQ_TYPE_NONE>;
+		interrupts = <2 IRQ_TYPE_LEVEL_LOW>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&max77686_irq>;
 		#clock-cells = <1>;
-- 
2.30.2



