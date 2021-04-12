Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48AE335BC99
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:44:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237562AbhDLIn4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:43:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:35764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237506AbhDLIn4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:43:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1B46961249;
        Mon, 12 Apr 2021 08:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217018;
        bh=/MjeJI148M+BeIPY1ICTVeKw2vzCV9nGhsuTUqlFP9A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iR7PVge++2y9aPZy8PcDzLBCVG3Shh6ZN7Spk4VhZOtSZg7aU2Nw75LWts1rOKuLn
         tv2k0K7MjthTQdbD4egdNq1ukuzk8eTiUYTqdInubn5ceJPXNU1ZagQdWmQlLd67hM
         UpBjEW77i7BxsZ+4+UDtyydyXtf7NDhlGWXLhTgc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Stefan Riedmueller <s.riedmueller@phytec.de>,
        Fabio Estevam <festevam@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 40/66] ARM: dts: imx6: pbab01: Set vmmc supply for both SD interfaces
Date:   Mon, 12 Apr 2021 10:40:46 +0200
Message-Id: <20210412083959.414857062@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412083958.129944265@linuxfoundation.org>
References: <20210412083958.129944265@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Riedmueller <s.riedmueller@phytec.de>

[ Upstream commit f57011e72f5fe0421ec7a812beb1b57bdf4bb47f ]

Setting the vmmc supplies is crucial since otherwise the supplying
regulators get disabled and the SD interfaces are no longer powered
which leads to system failures if the system is booted from that SD
interface.

Fixes: 1e44d3f880d5 ("ARM i.MX6Q: dts: Enable I2C1 with EEPROM and PMIC on Phytec phyFLEX-i.MX6 Ouad module")
Signed-off-by: Stefan Riedmueller <s.riedmueller@phytec.de>
Reviewed-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6qdl-phytec-pfla02.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/boot/dts/imx6qdl-phytec-pfla02.dtsi b/arch/arm/boot/dts/imx6qdl-phytec-pfla02.dtsi
index fe4e89d773f5..9499d113b139 100644
--- a/arch/arm/boot/dts/imx6qdl-phytec-pfla02.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-phytec-pfla02.dtsi
@@ -423,6 +423,7 @@
 	pinctrl-0 = <&pinctrl_usdhc2>;
 	cd-gpios = <&gpio1 4 GPIO_ACTIVE_LOW>;
 	wp-gpios = <&gpio1 2 GPIO_ACTIVE_HIGH>;
+	vmmc-supply = <&vdd_sd1_reg>;
 	status = "disabled";
 };
 
@@ -432,5 +433,6 @@
 		     &pinctrl_usdhc3_cdwp>;
 	cd-gpios = <&gpio1 27 GPIO_ACTIVE_LOW>;
 	wp-gpios = <&gpio1 29 GPIO_ACTIVE_HIGH>;
+	vmmc-supply = <&vdd_sd0_reg>;
 	status = "disabled";
 };
-- 
2.30.2



