Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 930DD37CBE9
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:02:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238700AbhELQiy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:38:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:50046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240094AbhELQa3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:30:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D50561C1F;
        Wed, 12 May 2021 15:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835048;
        bh=qtEb2y9YlX0nBzC9odvWW+tYSXTCKZYaqVT6uyM8Zmk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QxpV131U/3qhHlXwSiJ1wzCgEgs/Rp2VN1TzAMc74RBRg63/1LeFv75zHQwnxfxXK
         tRUAi3sbHuCz1SE6qYBxz2pH/ySm/9tPNlyogiMDeJaeOhCCPf1pcDFW2MVBHj3oDW
         8PaeY9pB0gI1T1mo3R4ZQACGqldPKgAs6BMZOtxA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 152/677] ARM: dts: exynos: correct PMIC interrupt trigger level on SMDK5250
Date:   Wed, 12 May 2021 16:43:18 +0200
Message-Id: <20210512144842.293181153@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
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



