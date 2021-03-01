Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73262328615
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:03:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235436AbhCARDj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:03:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:55582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236100AbhCAQ6K (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:58:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 022EA64FDE;
        Mon,  1 Mar 2021 16:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616620;
        bh=edSMVsVNqcX9qi0orxX9ZJX6EJzJS7kRr7S3XS22IS4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M+WSBD1jfqnIMEtd33YATZ8KJhpxQazdxQpVgumfASa4rqi38mVL/cPhVn06oSokm
         alvM6otE/0OEI25W8rwXhQIuZLNMck5BgPBCEkD0d0WRoW/MHky9SXlLkvmucbcXf6
         aAj2FfLOJ2/KsqTX2J7K06NiMQAIdUVik/YTO+Xg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 038/247] arm64: dts: allwinner: A64: Limit MMC2 bus frequency to 150 MHz
Date:   Mon,  1 Mar 2021 17:10:58 +0100
Message-Id: <20210301161033.546404418@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161031.684018251@linuxfoundation.org>
References: <20210301161031.684018251@linuxfoundation.org>
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
index b2f0729d92d2c..ecb3e10c85e07 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-a64-pinebook.dts
+++ b/arch/arm64/boot/dts/allwinner/sun50i-a64-pinebook.dts
@@ -105,6 +105,7 @@
 	pinctrl-0 = <&mmc2_pins>;
 	vmmc-supply = <&reg_dcdc1>;
 	vqmmc-supply = <&reg_eldo1>;
+	max-frequency = <200000000>;
 	bus-width = <8>;
 	non-removable;
 	cap-mmc-hw-reset;
diff --git a/arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi b/arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi
index 47949f14c49f4..30cc2e83a288e 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi
+++ b/arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi
@@ -264,7 +264,7 @@
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



