Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86FC923FB9B
	for <lists+stable@lfdr.de>; Sun,  9 Aug 2020 01:50:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728052AbgHHXuS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Aug 2020 19:50:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:49428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726984AbgHHXgn (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 8 Aug 2020 19:36:43 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8445F2075D;
        Sat,  8 Aug 2020 23:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596929802;
        bh=r9cARwlmRmQB2cn/JMr7t+CaD0wcuI04mAkfiugb6E4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hFmRidix3ACMxyfkatuZ0PmPk3686DLPF5ZAlG29l0CDyoBwwEEhbswsiqIDmyqH5
         UrIMZ+iug/vLwWYEyEBEEshu5lDMSqhJ0TpvM8oqdVnfd7F34EEfAroXUjxkBqfUkW
         IypmmWtGFgu7nJXh3ExVCkM2nzWNdFiTqLxEJR1o=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chen-Yu Tsai <wens@csie.org>, Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.8 40/72] ARM: dts: sunxi: bananapi-m2-plus-v1.2: Fix CPU supply voltages
Date:   Sat,  8 Aug 2020 19:35:09 -0400
Message-Id: <20200808233542.3617339-40-sashal@kernel.org>
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

From: Chen-Yu Tsai <wens@csie.org>

[ Upstream commit e4dae01bf08b754de79072441c357737220b873f ]

The Bananapi M2+ uses a GPIO line to change the effective resistance of
the CPU supply regulator's feedback resistor network. The voltages
described in the device tree were given directly by the vendor. This
turns out to be slightly off compared to the real values.

The updated voltages are based on calculations of the feedback resistor
network, and verified down to three decimal places with a multi-meter.

Fixes: 6eeb4180d4b9 ("ARM: dts: sunxi: h3-h5: Add Bananapi M2+ v1.2 device trees")
Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://lore.kernel.org/r/20200717160053.31191-4-wens@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/sunxi-bananapi-m2-plus-v1.2.dtsi | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/sunxi-bananapi-m2-plus-v1.2.dtsi b/arch/arm/boot/dts/sunxi-bananapi-m2-plus-v1.2.dtsi
index a628b5ee72b65..235994a4a2ebb 100644
--- a/arch/arm/boot/dts/sunxi-bananapi-m2-plus-v1.2.dtsi
+++ b/arch/arm/boot/dts/sunxi-bananapi-m2-plus-v1.2.dtsi
@@ -16,12 +16,12 @@ reg_vdd_cpux: vdd-cpux {
 		regulator-type = "voltage";
 		regulator-boot-on;
 		regulator-always-on;
-		regulator-min-microvolt = <1100000>;
-		regulator-max-microvolt = <1300000>;
+		regulator-min-microvolt = <1108475>;
+		regulator-max-microvolt = <1308475>;
 		regulator-ramp-delay = <50>; /* 4ms */
 		gpios = <&r_pio 0 1 GPIO_ACTIVE_HIGH>; /* PL1 */
 		gpios-states = <0x1>;
-		states = <1100000 0>, <1300000 1>;
+		states = <1108475 0>, <1308475 1>;
 	};
 };
 
-- 
2.25.1

