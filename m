Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27F4E23FBCB
	for <lists+stable@lfdr.de>; Sun,  9 Aug 2020 01:51:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726489AbgHHXf5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Aug 2020 19:35:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:48202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726478AbgHHXf4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 8 Aug 2020 19:35:56 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D335206C3;
        Sat,  8 Aug 2020 23:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596929756;
        bh=sB317FLKXl8ZWzvoUjIVlaxiV8Hf9CrJJB1t9Ct1CJM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=saHh26g877MHoXkCvECVmlx4sILZN3wAbfORu8mNjIi/HzSdYddmb8SLRoO5bmIOf
         9oawQfctq7mqE2Elu7Y4r0+QS6A3PlT7lgbhzY51m6b7irCGoVQR65r/MLwSVvrqlu
         YXT9pgGlCSscCDPPRXgh+PhKNjaxCnlenQmGxIho=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Heiko Stuebner <heiko.stuebner@theobroma-systems.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org
Subject: [PATCH AUTOSEL 5.8 10/72] arm64: dts: rockchip: fix rk3368-lion gmac reset gpio
Date:   Sat,  8 Aug 2020 19:34:39 -0400
Message-Id: <20200808233542.3617339-10-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200808233542.3617339-1-sashal@kernel.org>
References: <20200808233542.3617339-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiko Stuebner <heiko.stuebner@theobroma-systems.com>

[ Upstream commit 2300e6dab473e93181cf76e4fe6671aa3d24c57b ]

The lion gmac node currently uses opposite active-values for the
gmac phy reset pin. The gpio-declaration uses active-high while the
separate snps,reset-active-low property marks the pin as active low.

While on the kernel side this works ok, other DT users may get
confused - as seen with uboot right now.

So bring this in line and make both properties match, similar to the
other Rockchip board.

Fixes: d99a02bcfa81 ("arm64: dts: rockchip: add RK3368-uQ7 (Lion) SoM")
Signed-off-by: Heiko Stuebner <heiko.stuebner@theobroma-systems.com>
Link: https://lore.kernel.org/r/20200607212909.920575-1-heiko@sntech.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3368-lion.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3368-lion.dtsi b/arch/arm64/boot/dts/rockchip/rk3368-lion.dtsi
index e17311e090826..216aafd90e7f1 100644
--- a/arch/arm64/boot/dts/rockchip/rk3368-lion.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3368-lion.dtsi
@@ -156,7 +156,7 @@ &gmac {
 	pinctrl-0 = <&rgmii_pins>;
 	snps,reset-active-low;
 	snps,reset-delays-us = <0 10000 50000>;
-	snps,reset-gpio = <&gpio3 RK_PB3 GPIO_ACTIVE_HIGH>;
+	snps,reset-gpio = <&gpio3 RK_PB3 GPIO_ACTIVE_LOW>;
 	tx_delay = <0x10>;
 	rx_delay = <0x10>;
 	status = "okay";
-- 
2.25.1

