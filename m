Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20C842E409F
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:55:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392301AbgL1Oyo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:54:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:52078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2441390AbgL1ORM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:17:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2565D206D4;
        Mon, 28 Dec 2020 14:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165016;
        bh=NNZwcEfpwbXIVyZo4YkPxPqtl3xvEcGYnuyijk9fYQs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wqZtNoyunE015zabXtM508cFwsoW2ShxPKJRpyS4OEjViGzHSWbt4L1oofiw/bMkv
         Gug6fqTCHJndq3jrwMeQl0c+ZcbMBGd9xWIXlcfZvAQgX8X5XOpP+rTXSabEwHN+xD
         q2b+Pek0kGWZuErdUzQ9LWsGWbLX2zod985audkQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Stefan Agner <stefan@agner.ch>,
        Kevin Hilman <khilman@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 350/717] arm64: dts: meson: g12b: odroid-n2: fix PHY deassert timing requirements
Date:   Mon, 28 Dec 2020 13:45:48 +0100
Message-Id: <20201228125037.795599848@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Agner <stefan@agner.ch>

[ Upstream commit 1c7412530d5d0e0a0b27f1642f5c13c8b9f36f05 ]

According to the datasheet (Rev. 1.9) the RTL8211F requires at least
72ms "for internal circuits settling time" before accessing the PHY
registers. This fixes an issue where the Ethernet link doesn't come up
when using ip link set down/up:
  [   29.360965] meson8b-dwmac ff3f0000.ethernet eth0: Link is Down
  [   34.569012] meson8b-dwmac ff3f0000.ethernet eth0: PHY [0.0:00] driver [RTL8211F Gigabit Ethernet] (irq=31)
  [   34.676732] meson8b-dwmac ff3f0000.ethernet: Failed to reset the dma
  [   34.678874] meson8b-dwmac ff3f0000.ethernet eth0: stmmac_hw_setup: DMA engine initialization failed
  [   34.687850] meson8b-dwmac ff3f0000.ethernet eth0: stmmac_open: Hw setup failed

Fixes: 658e4129bb81 ("arm64: dts: meson: g12b: odroid-n2: add the Ethernet PHY reset line")
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Signed-off-by: Stefan Agner <stefan@agner.ch>
Signed-off-by: Kevin Hilman <khilman@baylibre.com>
Link: https://lore.kernel.org/r/df3f5c4fc6e43c55429fd3662a636036a21eed49.1607363522.git.stefan@agner.ch
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-g12b-odroid-n2.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/amlogic/meson-g12b-odroid-n2.dtsi b/arch/arm64/boot/dts/amlogic/meson-g12b-odroid-n2.dtsi
index 6982632ae6461..39a09661c5f62 100644
--- a/arch/arm64/boot/dts/amlogic/meson-g12b-odroid-n2.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-g12b-odroid-n2.dtsi
@@ -413,7 +413,7 @@
 		max-speed = <1000>;
 
 		reset-assert-us = <10000>;
-		reset-deassert-us = <30000>;
+		reset-deassert-us = <80000>;
 		reset-gpios = <&gpio GPIOZ_15 (GPIO_ACTIVE_LOW | GPIO_OPEN_DRAIN)>;
 
 		interrupt-parent = <&gpio_intc>;
-- 
2.27.0



