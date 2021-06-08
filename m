Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 838BC3A035D
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:24:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235993AbhFHTQK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:16:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:59066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236555AbhFHTN7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 15:13:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4DD7761958;
        Tue,  8 Jun 2021 18:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623178206;
        bh=v1oMwKHnjxU73MpDkT5DofjoJu3gZY+tqku0jOHo47s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ckiRH/N0xDwWeUxYpE6Fw7heiI9TQxxx6Qs5SVc6YRBmz6I6voidrY/4GZ+72DDBr
         I3sh3/suaUYMcd3mIKkTRD4Be1+qkZuzDUh3g2zIAHTX3f19RsA9fD/R/Fzuc06S0n
         hzujJf5tHF6mFyTryji7cJY9EQbu7tH2+YUZDbw8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabio Estevam <festevam@gmail.com>,
        Marek Vasut <marex@denx.de>,
        Christoph Niedermaier <cniedermaier@dh-electronics.com>,
        Ludwig Zenz <lzenz@dh-electronics.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 5.12 115/161] ARM: dts: imx6q-dhcom: Add PU,VDD1P1,VDD2P5 regulators
Date:   Tue,  8 Jun 2021 20:27:25 +0200
Message-Id: <20210608175949.343341664@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175945.476074951@linuxfoundation.org>
References: <20210608175945.476074951@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Vasut <marex@denx.de>

commit 8967b27a6c1c19251989c7ab33c058d16e4a5f53 upstream.

Per schematic, both PU and SOC regulator are supplied from LTC3676 SW1
via VDDSOC_IN rail, add the PU input. Both VDD1P1, VDD2P5 are supplied
from LTC3676 SW2 via VDDHIGH_IN rail, add both inputs.

While no instability or problems are currently observed, the regulators
should be fully described in DT and that description should fully match
the hardware, else this might lead to unforseen issues later. Fix this.

Fixes: 52c7a088badd ("ARM: dts: imx6q: Add support for the DHCOM iMX6 SoM and PDK2")
Reviewed-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Christoph Niedermaier <cniedermaier@dh-electronics.com>
Cc: Fabio Estevam <festevam@gmail.com>
Cc: Ludwig Zenz <lzenz@dh-electronics.com>
Cc: NXP Linux Team <linux-imx@nxp.com>
Cc: Shawn Guo <shawnguo@kernel.org>
Cc: stable@vger.kernel.org
Reviewed-by: Christoph Niedermaier <cniedermaier@dh-electronics.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/imx6q-dhcom-som.dtsi |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/arch/arm/boot/dts/imx6q-dhcom-som.dtsi
+++ b/arch/arm/boot/dts/imx6q-dhcom-som.dtsi
@@ -406,6 +406,18 @@
 	vin-supply = <&sw1_reg>;
 };
 
+&reg_pu {
+	vin-supply = <&sw1_reg>;
+};
+
+&reg_vdd1p1 {
+	vin-supply = <&sw2_reg>;
+};
+
+&reg_vdd2p5 {
+	vin-supply = <&sw2_reg>;
+};
+
 &uart1 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_uart1>;


