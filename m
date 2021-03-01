Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C6813284EC
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:49:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233282AbhCAQpY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:45:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:41580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234861AbhCAQih (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:38:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3B3D464F7B;
        Mon,  1 Mar 2021 16:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616054;
        bh=0O2i0iS5MXZeNwF+C9VmrK5U3MbLikGOgeAx/O1O7e8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VFkgW9uAe4rY30gW6MkkOAeokdsXl+oUq5BTTY0Efm73qdtdSxc3otpvay9DLMaDR
         8RnK3DDoPf4LNWf2mqicoLd8rJyqnDgu440bxB8FMiBYOr209nwrQT+bt56W0otb5m
         lF8/Oh07mw11pTWQc2Sidzn8dutAGXWwWoGAKHv4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 019/176] arm64: dts: exynos: correct PMIC interrupt trigger level on Espresso
Date:   Mon,  1 Mar 2021 17:11:32 +0100
Message-Id: <20210301161021.931031111@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161020.931630716@linuxfoundation.org>
References: <20210301161020.931630716@linuxfoundation.org>
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
index c8824b918693d..a85ad9f55cda0 100644
--- a/arch/arm64/boot/dts/exynos/exynos7-espresso.dts
+++ b/arch/arm64/boot/dts/exynos/exynos7-espresso.dts
@@ -88,7 +88,7 @@
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



