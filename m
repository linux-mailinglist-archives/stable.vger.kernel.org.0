Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D233738A8E1
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:53:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238158AbhETKzK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:55:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:52608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239157AbhETKwW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:52:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 52EC261CCA;
        Thu, 20 May 2021 10:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504815;
        bh=nSyohOdoRifUQBKaJOFU46RL/pOu8xoR+00HB6OHH5w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AXUt2m4+XFg3B8CaZaOc8rNnraQaf+Gcx1YvlsROP5ejPOGOBn2gezKV59I9HSNAb
         Kg/j0AOOhldzlRFN+UA0s2y6IyRauKZWD3lFHdJ4ewko2m+daqh4bwkcS+ayDJpWjW
         65hHH7FJAPBGWl2lPy9YDpjYrcpWTZ8hFsB0SG8o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 093/240] ARM: dts: exynos: correct PMIC interrupt trigger level on SMDK5250
Date:   Thu, 20 May 2021 11:21:25 +0200
Message-Id: <20210520092111.817981988@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092108.587553970@linuxfoundation.org>
References: <20210520092108.587553970@linuxfoundation.org>
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
index a97a785ccc6b..f0906d67a107 100644
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
 		wakeup-source;
-- 
2.30.2



