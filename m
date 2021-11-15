Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02C72452389
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:24:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356467AbhKPB1G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:27:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:34524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243838AbhKOTEM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:04:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C04EE63278;
        Mon, 15 Nov 2021 18:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000136;
        bh=XseYjj8GcNq3FnFCW9RZegwjKiWMEAE/U6zAPsKNHPs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ju7uo7dX2ynCSO/Fg+MX+IC6Tw6RqcsnqvoOdqFCfbuU7GpyCiNRMrR/o1/0GMvRT
         VvUz8TSg1A+kkYkBWCV/mBXkfzFbd8Ej1SIWr6rSoJu0nhSEDUrHCn8bW+DilTrlC1
         K2HXtVbyQmNgM+pb0XYYAklCB9HddWi4FaqrAq8k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dongjin Kim <tobetter@gmail.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 550/849] arm64: dts: meson: sm1: add Ethernet PHY reset line for ODROID-C4/HC4
Date:   Mon, 15 Nov 2021 18:00:33 +0100
Message-Id: <20211115165438.866846025@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dongjin Kim <tobetter@gmail.com>

[ Upstream commit 9d02214f8332d5dbbcce3d6c5c915e54d43a0c46 ]

This patch is to fix an issue that the ethernet link doesn't come up
when using ip link set down/up:
   [   11.428114] meson8b-dwmac ff3f0000.ethernet eth0: Link is Down
   [   14.428595] meson8b-dwmac ff3f0000.ethernet eth0: PHY [0.0:00] driver [RTL8211F Gigabit Ethernet] (irq=31)
   [   14.428610] meson8b-dwmac ff3f0000.ethernet: Failed to reset the dma
   [   14.428974] meson8b-dwmac ff3f0000.ethernet eth0: stmmac_hw_setup: DMA engine initialization failed
   [   14.711185] meson8b-dwmac ff3f0000.ethernet eth0: stmmac_open: Hw setup failed

This fix refers to two commits applied for ODROID-N2 (G12B).
    commit 658e4129bb81 ("arm64: dts: meson: g12b: odroid-n2: add the Ethernet PHY reset line")
    commit 1c7412530d5d0 ("arm64: dts: meson: g12b: odroid-n2: fix PHY deassert timing requirements")

Fixes: 88d537bc92ca ("arm64: dts: meson: convert meson-sm1-odroid-c4 to dtsi")
Signed-off-by: Dongjin Kim <tobetter@gmail.com>
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
[narmstrong: added fixes tag and typo in commit log]
Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Link: https://lore.kernel.org/r/YScKYFWlYymgGw3l@anyang-linuxfactory-or-kr
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-sm1-odroid.dtsi | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/boot/dts/amlogic/meson-sm1-odroid.dtsi b/arch/arm64/boot/dts/amlogic/meson-sm1-odroid.dtsi
index fd0ad85c165ba..45e7fcb062f96 100644
--- a/arch/arm64/boot/dts/amlogic/meson-sm1-odroid.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-sm1-odroid.dtsi
@@ -263,6 +263,10 @@
 		reg = <0>;
 		max-speed = <1000>;
 
+		reset-assert-us = <10000>;
+		reset-deassert-us = <80000>;
+		reset-gpios = <&gpio GPIOZ_15 (GPIO_ACTIVE_LOW | GPIO_OPEN_DRAIN)>;
+
 		interrupt-parent = <&gpio_intc>;
 		/* MAC_INTR on GPIOZ_14 */
 		interrupts = <26 IRQ_TYPE_LEVEL_LOW>;
-- 
2.33.0



