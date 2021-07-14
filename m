Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB6B93C8E8E
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:45:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237629AbhGNTsV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:48:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:45124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238260AbhGNTrR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:47:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E7784613FA;
        Wed, 14 Jul 2021 19:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291794;
        bh=2uLP6Ymh1+jBNRVHyGPLVQ5zH4+WJDs6Kl7CNJqhE2I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lIOxcBLlaVdlw1rxJvPGjzhCS0h8XuedJp1CzK2TAR4cBw5bldbk6R0kIvXsdjBYY
         5tXZw3vaC5wHNGKizS/QSbedvv3ZEwWWa+f4Ob1ey0Lu2JzKMuMwNR3YAGr5aEeQNs
         k7AFgFHFNqXmVk+KWQ4Fc+0Syr2XSNPGGaNDGWxTyZe5GFyVtnhk/z3Ai93PZ+6Qmc
         P7QkZPjoVe+nJRHb173oukqQPZASLLyxmovfOAp3+5oJu5uqdj5E6dr6HI3jIXkoyS
         56fp/ZTNnjSitF4mjjPw+lMwv1aX/UA29aEfQPVxliT5xawlcpRiNlBXbElp1OBniB
         OpUhC7L6+RUTQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ezequiel Garcia <ezequiel@collabora.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 06/88] ARM: dts: rockchip: Fix the timer clocks order
Date:   Wed, 14 Jul 2021 15:41:41 -0400
Message-Id: <20210714194303.54028-6-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194303.54028-1-sashal@kernel.org>
References: <20210714194303.54028-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ezequiel Garcia <ezequiel@collabora.com>

[ Upstream commit 7b46d674ac000b101fdad92cf16cc11d90b72f86 ]

Fixed order is the device-tree convention.
The timer driver currently gets clocks by name,
so no changes are needed there.

Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
Link: https://lore.kernel.org/r/20210506111136.3941-3-ezequiel@collabora.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/rk3188.dtsi | 8 ++++----
 arch/arm/boot/dts/rk3288.dtsi | 4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm/boot/dts/rk3188.dtsi b/arch/arm/boot/dts/rk3188.dtsi
index 2298a8d840ba..2c08ae60e4a1 100644
--- a/arch/arm/boot/dts/rk3188.dtsi
+++ b/arch/arm/boot/dts/rk3188.dtsi
@@ -150,16 +150,16 @@ timer3: timer@2000e000 {
 		compatible = "rockchip,rk3188-timer", "rockchip,rk3288-timer";
 		reg = <0x2000e000 0x20>;
 		interrupts = <GIC_SPI 46 IRQ_TYPE_LEVEL_HIGH>;
-		clocks = <&cru SCLK_TIMER3>, <&cru PCLK_TIMER3>;
-		clock-names = "timer", "pclk";
+		clocks = <&cru PCLK_TIMER3>, <&cru SCLK_TIMER3>;
+		clock-names = "pclk", "timer";
 	};
 
 	timer6: timer@200380a0 {
 		compatible = "rockchip,rk3188-timer", "rockchip,rk3288-timer";
 		reg = <0x200380a0 0x20>;
 		interrupts = <GIC_SPI 64 IRQ_TYPE_LEVEL_HIGH>;
-		clocks = <&cru SCLK_TIMER6>, <&cru PCLK_TIMER0>;
-		clock-names = "timer", "pclk";
+		clocks = <&cru PCLK_TIMER0>, <&cru SCLK_TIMER6>;
+		clock-names = "pclk", "timer";
 	};
 
 	i2s0: i2s@1011a000 {
diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
index fb2e89aa71c9..49b196546cdf 100644
--- a/arch/arm/boot/dts/rk3288.dtsi
+++ b/arch/arm/boot/dts/rk3288.dtsi
@@ -240,8 +240,8 @@ timer: timer@ff810000 {
 		compatible = "rockchip,rk3288-timer";
 		reg = <0x0 0xff810000 0x0 0x20>;
 		interrupts = <GIC_SPI 72 IRQ_TYPE_LEVEL_HIGH>;
-		clocks = <&xin24m>, <&cru PCLK_TIMER>;
-		clock-names = "timer", "pclk";
+		clocks = <&cru PCLK_TIMER>, <&xin24m>;
+		clock-names = "pclk", "timer";
 	};
 
 	display-subsystem {
-- 
2.30.2

