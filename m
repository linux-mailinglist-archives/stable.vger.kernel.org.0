Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA50737C7B5
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236652AbhELQCM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:02:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:37076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238081AbhELP5S (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:57:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6527A61438;
        Wed, 12 May 2021 15:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833404;
        bh=1K6sckRj1Nh0mmfgqx9bldPd4ucfU4Vbj8aVmmDPsO8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iZWBjR9Gww1jFQ+r/V2PcouFFnOXxoLB0+CrtRlutkYA6hjKoJCLBIbTi8Aajt2Am
         M3piKcq4xQfkuCHlbH7BUe/MI39ZGl7i6wjF5gPCUkQ0LNtTfVbQLmBIWUHY8xlJgu
         nPgqvc9ad0AH24aTNzBDB5cweivN48wIkniUrGWE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 135/601] ARM: dts: exynos: correct PMIC interrupt trigger level on P4 Note family
Date:   Wed, 12 May 2021 16:43:32 +0200
Message-Id: <20210512144832.272929980@linuxfoundation.org>
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

[ Upstream commit fbe9c9bb2e929865500a0985735f81c0142accad ]

The Maxim PMIC datasheets describe the interrupt line as active low
with a requirement of acknowledge from the CPU.  Without specifying the
interrupt type in Devicetree, kernel might apply some fixed
configuration, not necessarily working for this hardware.

Additionally, the interrupt line is shared so using level sensitive
interrupt is here especially important to avoid races.

Fixes: f48b5050c301 ("ARM: dts: exynos: add Samsung's Exynos4412-based P4 Note boards")
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Link: https://lore.kernel.org/r/20201210212534.216197-7-krzk@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/exynos4412-p4note.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/exynos4412-p4note.dtsi b/arch/arm/boot/dts/exynos4412-p4note.dtsi
index 5fe371543cbb..9e750890edb8 100644
--- a/arch/arm/boot/dts/exynos4412-p4note.dtsi
+++ b/arch/arm/boot/dts/exynos4412-p4note.dtsi
@@ -322,7 +322,7 @@
 	max77686: pmic@9 {
 		compatible = "maxim,max77686";
 		interrupt-parent = <&gpx0>;
-		interrupts = <7 IRQ_TYPE_NONE>;
+		interrupts = <7 IRQ_TYPE_LEVEL_LOW>;
 		pinctrl-0 = <&max77686_irq>;
 		pinctrl-names = "default";
 		reg = <0x09>;
-- 
2.30.2



