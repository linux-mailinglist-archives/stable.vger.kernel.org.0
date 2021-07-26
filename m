Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A2413D5E2E
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 17:47:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236172AbhGZPGM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:06:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:46038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236099AbhGZPFj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:05:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0545060F38;
        Mon, 26 Jul 2021 15:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627314367;
        bh=/lGveVitXFJEeMTqG1LajMuRMXQ4MCaJZ/XdiRtfNcg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p0IXhEpYyfGtiY76IiqlVxXMYCC5WBSS7ZSwj8ZGvnbElvIY9kqya3xG0rO71vx4f
         xl2XDi8QeT6sRbDWIPZvYBcgTRX8ziEtHxAnKRz7SjQ/eBdn2DBCghUo7bVzOsUkBr
         vSNBda7eubkRLdXimER3OTqcrlIOO39LQv22F3Gg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ezequiel Garcia <ezequiel@collabora.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 04/82] ARM: dts: rockchip: Fix the timer clocks order
Date:   Mon, 26 Jul 2021 17:38:04 +0200
Message-Id: <20210726153828.292628068@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153828.144714469@linuxfoundation.org>
References: <20210726153828.144714469@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 1399bc04ea77..74eb1dfa2f6c 100644
--- a/arch/arm/boot/dts/rk3188.dtsi
+++ b/arch/arm/boot/dts/rk3188.dtsi
@@ -110,16 +110,16 @@
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
index 5dd37d09c1f1..8abf0990c691 100644
--- a/arch/arm/boot/dts/rk3288.dtsi
+++ b/arch/arm/boot/dts/rk3288.dtsi
@@ -220,8 +220,8 @@
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



