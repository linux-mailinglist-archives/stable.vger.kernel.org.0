Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 135B9328D66
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:12:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240406AbhCATKR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:10:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:37322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238149AbhCATGc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:06:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB65265155;
        Mon,  1 Mar 2021 17:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618329;
        bh=DqM2pH+pp3EYn0WykQzwg4VeMSVqXuG96ODKO2Rk+xs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J5lYnnU+JggnZtgGa2yE398SWyOhhG2kERXTn5vZ1qY3tXVMgFbRgvd6wc3R7c0ug
         BYubUlxj+yWRDASGbCczoHW0p0nVRvWSemAuKq118o3fr9C3QPA0fStgeZbsru4jLw
         46unJmpY0icOPX75TacI2xEg5HQCzqdqrCuVw4lw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 048/663] arm64: dts: allwinner: A64: Limit MMC2 bus frequency to 150 MHz
Date:   Mon,  1 Mar 2021 17:04:56 +0100
Message-Id: <20210301161144.149842583@linuxfoundation.org>
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

From: Andre Przywara <andre.przywara@arm.com>

[ Upstream commit 948c657cc45e8ce48cb533d4e2106145fa765759 ]

In contrast to the H6 (and later) manuals, the A64 datasheet does not
specify any limitations in the maximum possible frequency for eMMC
controllers.
However experimentation has found that a 150 MHz limit similar to other
SoCs and also the MMC0 and MMC1 controllers on the A64 seems to exist
for the MMC2 controller.

Limit the frequency for the MMC2 controller to 150 MHz in the SoC .dtsi.
The Pinebook seems to be the an odd exception, since it apparently seems
to work with 200 MHz as well, so overwrite this in its board .dts file.

Tested on a Pine64-LTS: 200 MHz HS-200 fails, 150 MHz HS-200 works.

Fixes: 22be992faea7 ("arm64: allwinner: a64: Increase the MMC max frequency")
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Acked-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://lore.kernel.org/r/20210113152630.28810-7-andre.przywara@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/allwinner/sun50i-a64-pinebook.dts | 1 +
 arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi         | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/allwinner/sun50i-a64-pinebook.dts b/arch/arm64/boot/dts/allwinner/sun50i-a64-pinebook.dts
index d07cf05549c32..7ae16541d14f5 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-a64-pinebook.dts
+++ b/arch/arm64/boot/dts/allwinner/sun50i-a64-pinebook.dts
@@ -167,6 +167,7 @@
 	pinctrl-0 = <&mmc2_pins>, <&mmc2_ds_pin>;
 	vmmc-supply = <&reg_dcdc1>;
 	vqmmc-supply = <&reg_eldo1>;
+	max-frequency = <200000000>;
 	bus-width = <8>;
 	non-removable;
 	cap-mmc-hw-reset;
diff --git a/arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi b/arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi
index 15f6408e73a27..7a41015a9ce59 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi
+++ b/arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi
@@ -514,7 +514,7 @@
 			resets = <&ccu RST_BUS_MMC2>;
 			reset-names = "ahb";
 			interrupts = <GIC_SPI 62 IRQ_TYPE_LEVEL_HIGH>;
-			max-frequency = <200000000>;
+			max-frequency = <150000000>;
 			status = "disabled";
 			#address-cells = <1>;
 			#size-cells = <0>;
-- 
2.27.0



