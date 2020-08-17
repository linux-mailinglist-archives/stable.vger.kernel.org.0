Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 407CD246949
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 17:19:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729201AbgHQPSz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:18:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:40334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729191AbgHQPSt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:18:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 10AC8205CB;
        Mon, 17 Aug 2020 15:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597677528;
        bh=+mpINWnZ77fQrIFcKNZzBdvpHqJ/JoGT+r1RxI/vdvU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JJJhq7A2bABxD7mE2WdajAb+zn7F+kWQvLCY7wNB883tAZQE05TiDJiX7ZqTEYpXp
         6v2RZQByR6p0cbnMJlZREJkJBZSYqNdDG/6o3VSVhXNzEzhN8avRvXsQVOgKZA8CFP
         dNGryMfpzoQ1rUShkADM4wd56WP7hJrLlYLOEm80=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Heiko Stuebner <heiko.stuebner@theobroma-systems.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 016/464] arm64: dts: rockchip: fix rk3399-puma gmac reset gpio
Date:   Mon, 17 Aug 2020 17:09:29 +0200
Message-Id: <20200817143834.534889384@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiko Stuebner <heiko.stuebner@theobroma-systems.com>

[ Upstream commit 8a445086f8af0b7b9bd8d1901d6f306bb154f70d ]

The puma gmac node currently uses opposite active-values for the
gmac phy reset pin. The gpio-declaration uses active-high while the
separate snps,reset-active-low property marks the pin as active low.

While on the kernel side this works ok, other DT users may get
confused - as seen with uboot right now.

So bring this in line and make both properties match, similar to the
other Rockchip board.

Fixes: 2c66fc34e945 ("arm64: dts: rockchip: add RK3399-Q7 (Puma) SoM")
Signed-off-by: Heiko Stuebner <heiko.stuebner@theobroma-systems.com>
Link: https://lore.kernel.org/r/20200603132836.362519-1-heiko@sntech.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi b/arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi
index 063f59a420b65..72c06abd27ea7 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi
@@ -157,7 +157,7 @@ &gmac {
 	phy-mode = "rgmii";
 	pinctrl-names = "default";
 	pinctrl-0 = <&rgmii_pins>;
-	snps,reset-gpio = <&gpio3 RK_PC0 GPIO_ACTIVE_HIGH>;
+	snps,reset-gpio = <&gpio3 RK_PC0 GPIO_ACTIVE_LOW>;
 	snps,reset-active-low;
 	snps,reset-delays-us = <0 10000 50000>;
 	tx_delay = <0x10>;
-- 
2.25.1



