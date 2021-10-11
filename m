Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FEEF429011
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:04:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237574AbhJKOEx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:04:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:50652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238303AbhJKOCa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 10:02:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 148206120A;
        Mon, 11 Oct 2021 13:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960682;
        bh=J0NnODKIYOf7Q1n/OoexbppyKqrNGzyHfFkDeVFdFok=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IytoJklfWx0owbxTdD3kHZOu8IJHeSjgCael+A67VsEvnAacuB9WRY5t1zNatKruX
         f1tA6WvUiOqmLU7BjuO1x2RLanyHhaEkqg2d+04nD+PAB8EnAsWoHJhieSClLNAnrn
         H8OA5CXE+rdmqaiY21D6aysQ0YcdIoypWLNSnOHg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabio Estevam <festevam@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 045/151] ARM: dts: imx6qdl-pico: Fix Ethernet support
Date:   Mon, 11 Oct 2021 15:45:17 +0200
Message-Id: <20211011134519.303271243@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134517.833565002@linuxfoundation.org>
References: <20211011134517.833565002@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabio Estevam <festevam@gmail.com>

[ Upstream commit 450e7fe9b1b3c90eeed74a2fe0eeb13a7b57f3da ]

Currently, it is no longer possible to retrieve a DHCP address
on the imx6qdl-pico board.

This issue has been exposed by commit f5d9aa79dfdf ("ARM: imx6q:
remove clk-out fixup for the Atheros AR8031 and AR8035 PHYs").

Fix it by describing the qca,clk-out-frequency property as suggested
by the commit above.

Fixes: 98670a0bb0ef14bbb3 ("ARM: dts: imx6qdl: Add imx6qdl-pico support")
Signed-off-by: Fabio Estevam <festevam@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6qdl-pico.dtsi | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm/boot/dts/imx6qdl-pico.dtsi b/arch/arm/boot/dts/imx6qdl-pico.dtsi
index 5de4ccb97916..f7a56d6b160c 100644
--- a/arch/arm/boot/dts/imx6qdl-pico.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-pico.dtsi
@@ -176,7 +176,18 @@
 	pinctrl-0 = <&pinctrl_enet>;
 	phy-mode = "rgmii-id";
 	phy-reset-gpios = <&gpio1 26 GPIO_ACTIVE_LOW>;
+	phy-handle = <&phy>;
 	status = "okay";
+
+	mdio {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		phy: ethernet-phy@1 {
+			reg = <1>;
+			qca,clk-out-frequency = <125000000>;
+		};
+	};
 };
 
 &hdmi {
-- 
2.33.0



