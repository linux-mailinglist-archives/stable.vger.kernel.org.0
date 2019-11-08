Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DAD0F4A24
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 13:08:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389057AbfKHLkz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 06:40:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:53954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389045AbfKHLky (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 06:40:54 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 55D97222C2;
        Fri,  8 Nov 2019 11:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213254;
        bh=m5SAiEhmgoM419e11DWoaWJ3r5SwTf19vYa1RbB7u0k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hunAVwixqEkhUuRx8cnWEXRtsvvXezyXw8s2tdPwxwk58S6pVouQN3xUijEqbsXzk
         m0J8LbZiQyH9O2RuKaNPbdhbnT1LBVDybj7WLCjYwqWMkmgyS3xUPdn5nzu2F0td0M
         4i2/ZYCshFWsOxsTsMACKf4glRWUjg3DGNkFG4u8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marek Szyprowski <m.szyprowski@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 119/205] ARM: dts: exynos: Disable pull control for PMIC IRQ line on Artik5 board
Date:   Fri,  8 Nov 2019 06:36:26 -0500
Message-Id: <20191108113752.12502-119-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108113752.12502-1-sashal@kernel.org>
References: <20191108113752.12502-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Szyprowski <m.szyprowski@samsung.com>

[ Upstream commit 62623718fd31d08b26ebea6c8b40f24924153ab7 ]

S2MPS14 PMIC interrupt line on Exynos3250-based Artik5 evaluation board
has external pull-up resistors, so disable any pull control for it in
controller node. This fixes support for S2MPS14 PMIC interrupts and
enables operation of wakeup from S2MPS14 RTC alarm.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/exynos3250-artik5.dtsi | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm/boot/dts/exynos3250-artik5.dtsi b/arch/arm/boot/dts/exynos3250-artik5.dtsi
index 620b50c19ead9..7c22cbf6f3d41 100644
--- a/arch/arm/boot/dts/exynos3250-artik5.dtsi
+++ b/arch/arm/boot/dts/exynos3250-artik5.dtsi
@@ -69,6 +69,8 @@
 		compatible = "samsung,s2mps14-pmic";
 		interrupt-parent = <&gpx3>;
 		interrupts = <5 IRQ_TYPE_NONE>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&s2mps14_irq>;
 		reg = <0x66>;
 
 		s2mps14_osc: clocks {
@@ -350,6 +352,11 @@
 		samsung,pin-drv = <EXYNOS4_PIN_DRV_LV3>;
 		samsung,pin-val = <1>;
 	};
+
+	s2mps14_irq: s2mps14-irq {
+		samsung,pins = "gpx3-5";
+		samsung,pin-pud = <EXYNOS_PIN_PULL_NONE>;
+	};
 };
 
 &rtc {
-- 
2.20.1

