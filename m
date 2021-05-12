Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81AEE37C7B4
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236626AbhELQCK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:02:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:33436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238082AbhELP5S (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:57:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 93696613EB;
        Wed, 12 May 2021 15:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833402;
        bh=Y32D3heCOslglfr3Z8ODH36RjL8NAcx601FGPCo4YLY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0z6a6nrk6zY/Q98lFDzSq7bzhts/ftKhrq23p8FFyj5Tph2/prK6N2SQfW2DvbWTK
         8mLBa9UVsMeLTFzMXeUQszs9AuLz/nb9938XVMf2b11SFmlkE4bCVmVZSfmQo4emKx
         f07csglYV/cv7bcDsLvHJvaJ6kAbo/8bStecIkVY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 134/601] ARM: dts: exynos: correct PMIC interrupt trigger level on Odroid X/U3 family
Date:   Wed, 12 May 2021 16:43:31 +0200
Message-Id: <20210512144832.243406992@linuxfoundation.org>
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
index 2b20d9095d9f..eebe6a3952ce 100644
--- a/arch/arm/boot/dts/exynos4412-odroid-common.dtsi
+++ b/arch/arm/boot/dts/exynos4412-odroid-common.dtsi
@@ -278,7 +278,7 @@
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



