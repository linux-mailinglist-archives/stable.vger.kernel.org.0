Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F27E328416
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:30:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234747AbhCAQ2u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:28:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:59980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237913AbhCAQYV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:24:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 41A8D64EDB;
        Mon,  1 Mar 2021 16:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614615661;
        bh=P+XU5p46Jfmxm0w/YgrOLZVBwVC1OLRjJgkURhC9W5A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uPFLheWIBcgMfoyXH1viCGre3lAhkWsZ74FW/u+v476s0eH0/kqDVLTxZf322Rxvw
         RAVg9BNJOToua2xnPZYYV6dQsqGWwAb3sFzOV1Qf1fAZwK/3cfkg85cdP/i6Q5/kjI
         hrRAwXYDsdS+Oaj4tDfERzMsQnW00qaORB4ZzZLQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 016/134] arm64: dts: exynos: correct PMIC interrupt trigger level on Espresso
Date:   Mon,  1 Mar 2021 17:11:57 +0100
Message-Id: <20210301161014.377600597@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161013.585393984@linuxfoundation.org>
References: <20210301161013.585393984@linuxfoundation.org>
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
index 2f7d144d556da..e43e804c42c3e 100644
--- a/arch/arm64/boot/dts/exynos/exynos7-espresso.dts
+++ b/arch/arm64/boot/dts/exynos/exynos7-espresso.dts
@@ -64,7 +64,7 @@
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



