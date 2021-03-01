Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40ECC328364
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:19:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237699AbhCAQSV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:18:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:55516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237688AbhCAQRG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:17:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1B59F64DE5;
        Mon,  1 Mar 2021 16:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614615383;
        bh=ADR4RqQ7UnHNWLhicJav5VyFALEwfAJCpTjVjswRJ/o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YxkHPaAtsg3IJcic7YVoMNDqY3GwCh0HPnj09ykyvgY1qZ19BFkHUBTiBlFTzKX5s
         h6OzKjn4KZhsnGFuUBUDehRjXcHRxpfFq6ZyfZpKRxtSpwDjpoGBChEmfNwPqB4q+2
         YJDMsIKI/U2Dx4ah7MyyaYNUPTYEK2tj5IRc4SeA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 10/93] ARM: dts: exynos: correct PMIC interrupt trigger level on Spring
Date:   Mon,  1 Mar 2021 17:12:22 +0100
Message-Id: <20210301161007.407919540@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161006.881950696@linuxfoundation.org>
References: <20210301161006.881950696@linuxfoundation.org>
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
index c1edd6d038a90..4b3bd43f77213 100644
--- a/arch/arm/boot/dts/exynos5250-spring.dts
+++ b/arch/arm/boot/dts/exynos5250-spring.dts
@@ -112,7 +112,7 @@
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



