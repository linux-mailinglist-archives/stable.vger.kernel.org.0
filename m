Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E38DA37C13F
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 16:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231826AbhELO6K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 10:58:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:46142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232155AbhELO4q (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 10:56:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 44A506143A;
        Wed, 12 May 2021 14:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620831309;
        bh=3EmDXmefUGtBF0IclACxjfClWfCEyFcxPGCGUslaJ+A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VZ0USv/ju5rCYmcgSs2n4VzEIaih91micEuZypFZHECYVXW/NG2vcgCupEwsmDGb8
         Ngrc/pGN8pkhH7G0qeljVBhHh13dwdm0CAphLduB9AhqHN6TKQE9B4oLwAzL+dPxIg
         YlAPOO5wGncTL46yMcUmbMX8XTdx6dQzgGAAc75w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 068/244] ARM: dts: exynos: correct PMIC interrupt trigger level on Midas family
Date:   Wed, 12 May 2021 16:47:19 +0200
Message-Id: <20210512144745.208757131@linuxfoundation.org>
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

[ Upstream commit e52dcd6e70fab51f53292e53336ecb007bb60889 ]

The Maxim PMIC datasheets describe the interrupt line as active low
with a requirement of acknowledge from the CPU.  Without specifying the
interrupt type in Devicetree, kernel might apply some fixed
configuration, not necessarily working for this hardware.

Additionally, the interrupt line is shared so using level sensitive
interrupt is here especially important to avoid races.

Fixes: 15dfdfad2d4a ("ARM: dts: Add basic dts for Exynos4412-based Trats 2 board")
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Link: https://lore.kernel.org/r/20201210212534.216197-5-krzk@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/exynos4412-midas.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/exynos4412-midas.dtsi b/arch/arm/boot/dts/exynos4412-midas.dtsi
index 79e6bd56f9ad..fedb21377c66 100644
--- a/arch/arm/boot/dts/exynos4412-midas.dtsi
+++ b/arch/arm/boot/dts/exynos4412-midas.dtsi
@@ -588,7 +588,7 @@
 	max77686: max77686_pmic@9 {
 		compatible = "maxim,max77686";
 		interrupt-parent = <&gpx0>;
-		interrupts = <7 IRQ_TYPE_NONE>;
+		interrupts = <7 IRQ_TYPE_LEVEL_LOW>;
 		pinctrl-0 = <&max77686_irq>;
 		pinctrl-names = "default";
 		reg = <0x09>;
-- 
2.30.2



