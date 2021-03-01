Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1E3C328CFA
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:05:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240935AbhCATCz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:02:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:58438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240700AbhCAS4i (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:56:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F30C65274;
        Mon,  1 Mar 2021 17:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620150;
        bh=mzElu2yX3Zz5De6sGX9jDUe83trjj5Fja2wB19IZbbI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=np2NRhQuZ+pFFWgbpLzP5rLdT5YOE5diAjU20NlyrHMip6ALzkqzJApnmKoJOZiYe
         8ktUGL8lej8SudCuw2eN9ardupDt0Qc/YYSwSCLBwMzZlfvNkySQEGk5hfViNV/ObR
         CJj/ZIdjAAbe2RZKBabDMcXJWVZx4cEzAhfnytbY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 049/775] arm64: dts: allwinner: H6: Allow up to 150 MHz MMC bus frequency
Date:   Mon,  1 Mar 2021 17:03:37 +0100
Message-Id: <20210301161204.144467340@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
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
index f593cfeaecc9f..77765d4a05ec9 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi
+++ b/arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi
@@ -436,6 +436,7 @@
 			interrupts = <GIC_SPI 35 IRQ_TYPE_LEVEL_HIGH>;
 			pinctrl-names = "default";
 			pinctrl-0 = <&mmc0_pins>;
+			max-frequency = <150000000>;
 			status = "disabled";
 			#address-cells = <1>;
 			#size-cells = <0>;
@@ -452,6 +453,7 @@
 			interrupts = <GIC_SPI 36 IRQ_TYPE_LEVEL_HIGH>;
 			pinctrl-names = "default";
 			pinctrl-0 = <&mmc1_pins>;
+			max-frequency = <150000000>;
 			status = "disabled";
 			#address-cells = <1>;
 			#size-cells = <0>;
@@ -468,6 +470,7 @@
 			interrupts = <GIC_SPI 37 IRQ_TYPE_LEVEL_HIGH>;
 			pinctrl-names = "default";
 			pinctrl-0 = <&mmc2_pins>;
+			max-frequency = <150000000>;
 			status = "disabled";
 			#address-cells = <1>;
 			#size-cells = <0>;
-- 
2.27.0



