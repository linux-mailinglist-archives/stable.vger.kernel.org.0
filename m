Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10C1E38A361
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:50:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234256AbhETJv4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:51:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:53312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234563AbhETJuD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:50:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 25BCF613AC;
        Thu, 20 May 2021 09:35:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503316;
        bh=LiOXWf0ziXj577Byr/VIDpEFL59xJQe2uwisDAMsKpE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ISfyuNcx3uOOj7h6OSBBDmtmJbLmH2gg7hKxNtjmSLjViu3MX4dBRb9TlJAIkj+CX
         YV7PWuiH+4q7zYfeHBRfXvkZ3HaeNlRDO5KMOEhWAtcMcsAdaEIzqDUnxrBMQm3tlo
         85WqQnrLSo3BkkfIuBFnmyIvaeXweBGBurkpVjC0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 166/425] ARM: dts: exynos: correct PMIC interrupt trigger level on Odroid X/U3 family
Date:   Thu, 20 May 2021 11:18:55 +0200
Message-Id: <20210520092136.904743457@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
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
index 00820d239753..dbca8eeefae1 100644
--- a/arch/arm/boot/dts/exynos4412-odroid-common.dtsi
+++ b/arch/arm/boot/dts/exynos4412-odroid-common.dtsi
@@ -265,7 +265,7 @@
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



