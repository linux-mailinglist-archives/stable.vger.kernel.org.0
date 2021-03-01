Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDDB8328EAF
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:37:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242090AbhCATfK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:35:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:48626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241869AbhCAT3c (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:29:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 232C0650A9;
        Mon,  1 Mar 2021 17:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620109;
        bh=Msc955rlv/3waQ4IClZtSO1AHl4oIE37BJfp+bn1WgI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XgYS2hnXQy9GU4pt5Vgue1t7kfLOzttiKsDY1YPCPRVR0Ju1wwk/z03AbE6pdLcTC
         KB8UvNNBfTcYBmp4F/HlnWDDwl2O13rnraGpZ7Msp7aSugBq/Tnzlf81A7xV1iOlwp
         UwCaQZPsFt1OV6UPC/xBVpzZQ5lIi1YztnHFhq7g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 032/775] ARM: dts: exynos: correct PMIC interrupt trigger level on Spring
Date:   Mon,  1 Mar 2021 17:03:20 +0100
Message-Id: <20210301161203.306546203@linuxfoundation.org>
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

[ Upstream commit 77e6a5467cb8657cf8b5e610a30a4c502085e4f9 ]

The Samsung PMIC datasheets describe the interrupt line as active low
with a requirement of acknowledge from the CPU.  Without specifying the
interrupt type in Devicetree, kernel might apply some fixed
configuration, not necessarily working for this hardware.

Fixes: 53dd4138bb0a ("ARM: dts: Add exynos5250-spring device tree")
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Link: https://lore.kernel.org/r/20201210212903.216728-4-krzk@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/exynos5250-spring.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/exynos5250-spring.dts b/arch/arm/boot/dts/exynos5250-spring.dts
index 9d2baea62d0d7..fba1462b19dfd 100644
--- a/arch/arm/boot/dts/exynos5250-spring.dts
+++ b/arch/arm/boot/dts/exynos5250-spring.dts
@@ -109,7 +109,7 @@
 		compatible = "samsung,s5m8767-pmic";
 		reg = <0x66>;
 		interrupt-parent = <&gpx3>;
-		interrupts = <2 IRQ_TYPE_NONE>;
+		interrupts = <2 IRQ_TYPE_LEVEL_LOW>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&s5m8767_irq &s5m8767_dvs &s5m8767_ds>;
 		wakeup-source;
-- 
2.27.0



