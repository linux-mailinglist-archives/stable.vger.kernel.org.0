Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C45D3287D7
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:30:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238548AbhCAR24 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:28:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:48854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238244AbhCARYB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:24:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9A94764F53;
        Mon,  1 Mar 2021 16:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617338;
        bh=AWt1nMTxOx+4J3liZC7t8iaLxUEzbdH6OaB1/nwRs2g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vytyEtFZhhdmNIN9gPZVsQeE3r7K6tGAEopsztoFGerT7AjG01V6a6a6OAEwmHEEV
         gjfbZNVnl8iNEfcnR1HhuuTL00OF5dLi849VYhFQPtqI9GKVY+PdJRsJWT01ocSG4e
         Ye0uNd7e4pFvyxudVfA1GDTLsddDXg92FLSbNRB4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 031/340] arm64: dts: allwinner: H6: Allow up to 150 MHz MMC bus frequency
Date:   Mon,  1 Mar 2021 17:09:35 +0100
Message-Id: <20210301161049.842195616@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andre Przywara <andre.przywara@arm.com>

[ Upstream commit cfe6c487b9a1abc6197714ec5605716a5428cf03 ]

The H6 manual explicitly lists a frequency limit of 150 MHz for the bus
frequency of the MMC controllers. So far we had no explicit limits in the
DT, which limited eMMC to the spec defined frequencies, or whatever the
driver defines (both Linux and FreeBSD use 52 MHz here).

Put those maximum frequencies in the SoC .dtsi, to allow higher speed
modes (which still would need to be explicitly enabled, per board).

Tested with an eMMC using HS-200 on a Pine H64. Running at the spec'ed
200 MHz indeed fails with I/O errors, but 150 MHz seems to work stably.

Fixes: 8f54bd1595b3 ("arm64: allwinner: h6: add device tree nodes for MMC controllers")
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Acked-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://lore.kernel.org/r/20210113152630.28810-6-andre.przywara@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi b/arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi
index 8b77bd5a3c017..1583cd5915214 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi
+++ b/arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi
@@ -332,6 +332,7 @@
 			interrupts = <GIC_SPI 35 IRQ_TYPE_LEVEL_HIGH>;
 			pinctrl-names = "default";
 			pinctrl-0 = <&mmc0_pins>;
+			max-frequency = <150000000>;
 			status = "disabled";
 			#address-cells = <1>;
 			#size-cells = <0>;
@@ -348,6 +349,7 @@
 			interrupts = <GIC_SPI 36 IRQ_TYPE_LEVEL_HIGH>;
 			pinctrl-names = "default";
 			pinctrl-0 = <&mmc1_pins>;
+			max-frequency = <150000000>;
 			status = "disabled";
 			#address-cells = <1>;
 			#size-cells = <0>;
@@ -364,6 +366,7 @@
 			interrupts = <GIC_SPI 37 IRQ_TYPE_LEVEL_HIGH>;
 			pinctrl-names = "default";
 			pinctrl-0 = <&mmc2_pins>;
+			max-frequency = <150000000>;
 			status = "disabled";
 			#address-cells = <1>;
 			#size-cells = <0>;
-- 
2.27.0



