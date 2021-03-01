Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08325328A78
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:20:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239607AbhCASRy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:17:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:60792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239324AbhCASLg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:11:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C2EA064F75;
        Mon,  1 Mar 2021 17:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618373;
        bh=8HJYzbhOhnJ4NwxNFsqk8vfoZ/rwwx6FCa0gY9oZzNw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B99YxxMXlzH5K/M2I8YPsC84xeOuxhST8GVnpOI7Jp1+t8A4o8P6ARU/tqkk8+dO+
         iPYuXpiX4GleX+ixx2+WJZulEcUuYB+aEVThwViFdwiKIPWwvFAUwdWIgtz8t37I1h
         btQ6Mq8vLdRatoeoFWSUz/Cc52klRmO5000YV3Zg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 034/663] arm64: dts: exynos: correct PMIC interrupt trigger level on Espresso
Date:   Mon,  1 Mar 2021 17:04:42 +0100
Message-Id: <20210301161143.483486211@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
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
index 92fecc539c6c7..358b7b6ea84f1 100644
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



