Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 981753287A6
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:29:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235178AbhCAR0x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:26:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:37358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237998AbhCARVT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:21:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB6C165066;
        Mon,  1 Mar 2021 16:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617298;
        bh=Q32zRlozEh5KScQaYc5NYN7IPL/9q2IG7dg7ITIgwPI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qCRSZ9U0+QKaw9xfLq7dInCdrvfR3uMgLUftR+vUHgJVEwOO5/YOd7rmJB1E6fxiA
         2JhFnH3tJKpkRaceZfK9JKgeUmEKGfne+MoOGS4bPgqqz3WKNyN7ckjFrZDzcONgBn
         jJEnXN19g3d/HddVHH213y3vVtN3J2lexfElv/JI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 024/340] arm64: dts: exynos: correct PMIC interrupt trigger level on Espresso
Date:   Mon,  1 Mar 2021 17:09:28 +0100
Message-Id: <20210301161049.508735232@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzk@kernel.org>

[ Upstream commit 1fea2eb2f5bbd3fbbe2513d2386b5f6e6db17fd7 ]

The Samsung PMIC datasheets describe the interrupt line as active low
with a requirement of acknowledge from the CPU.  Without specifying the
interrupt type in Devicetree, kernel might apply some fixed
configuration, not necessarily working for this hardware.

Fixes: 9589f7721e16 ("arm64: dts: Add S2MPS15 PMIC node on exynos7-espresso")
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Link: https://lore.kernel.org/r/20201210212903.216728-8-krzk@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/exynos/exynos7-espresso.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/exynos/exynos7-espresso.dts b/arch/arm64/boot/dts/exynos/exynos7-espresso.dts
index 61ee7b6a31594..09aead2be000c 100644
--- a/arch/arm64/boot/dts/exynos/exynos7-espresso.dts
+++ b/arch/arm64/boot/dts/exynos/exynos7-espresso.dts
@@ -90,7 +90,7 @@
 	s2mps15_pmic@66 {
 		compatible = "samsung,s2mps15-pmic";
 		reg = <0x66>;
-		interrupts = <2 IRQ_TYPE_NONE>;
+		interrupts = <2 IRQ_TYPE_LEVEL_LOW>;
 		interrupt-parent = <&gpa0>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&pmic_irq>;
-- 
2.27.0



