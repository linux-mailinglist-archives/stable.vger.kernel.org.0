Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B38873C9039
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 22:00:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241016AbhGNTyI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:54:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:47276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241083AbhGNTuW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:50:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 92AE6613B5;
        Wed, 14 Jul 2021 19:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626292007;
        bh=uWyAnwa3WxnWjfWfs4xD2A6KM49nG54dNobJZvDA8a0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cBQiLaVHO4i24dpL7kB8XwhyKqyFnhaN6Tp3pL4dSW31S+86Cisu56NYOQ0ppUsEx
         h+S9/C7uwly9NgiOUFhrCAOrJt+L5EoIOTp6x9RV927XlsbmE8gqtqP/Ry/6l5MNj/
         NnIfg4mP/wZrVwDBK6JOP0tku4A8D1iBlsNYp4FUVHq1Tp9RxY1xIrzohBnjSN6IbJ
         ZpLczMjG3ebuCgp6a7/wrCfLXJseldlku+rCfuKbjR0EwwcI/aV+dgBjEEg0vpB3dr
         A6DamiDSb7bLDb7JLkS+q6QtPrb0SUy0i3gcOk2xp0FjOnnaxyKayGv9QwlXLrth0Y
         N5nj8QGOhV9cA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Primoz Fiser <primoz.fiser@norik.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 16/39] ARM: dts: imx6: phyFLEX: Fix UART hardware flow control
Date:   Wed, 14 Jul 2021 15:46:01 -0400
Message-Id: <20210714194625.55303-16-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194625.55303-1-sashal@kernel.org>
References: <20210714194625.55303-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Primoz Fiser <primoz.fiser@norik.com>

[ Upstream commit 14cdc1f243d79e0b46be150502b7dba9c5a6bdfd ]

Serial interface uart3 on phyFLEX board is capable of 5-wire connection
including signals RTS and CTS for hardware flow control.

Fix signals UART3_CTS_B and UART3_RTS_B padmux assignments and add
missing property "uart-has-rtscts" to allow serial interface to be
configured and used with the hardware flow control.

Signed-off-by: Primoz Fiser <primoz.fiser@norik.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6qdl-phytec-pfla02.dtsi | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/imx6qdl-phytec-pfla02.dtsi b/arch/arm/boot/dts/imx6qdl-phytec-pfla02.dtsi
index 9499d113b139..25462f778994 100644
--- a/arch/arm/boot/dts/imx6qdl-phytec-pfla02.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-phytec-pfla02.dtsi
@@ -306,8 +306,8 @@ pinctrl_uart3: uart3grp {
 			fsl,pins = <
 				MX6QDL_PAD_EIM_D24__UART3_TX_DATA	0x1b0b1
 				MX6QDL_PAD_EIM_D25__UART3_RX_DATA	0x1b0b1
-				MX6QDL_PAD_EIM_D30__UART3_RTS_B		0x1b0b1
-				MX6QDL_PAD_EIM_D31__UART3_CTS_B		0x1b0b1
+				MX6QDL_PAD_EIM_D31__UART3_RTS_B		0x1b0b1
+				MX6QDL_PAD_EIM_D30__UART3_CTS_B		0x1b0b1
 			>;
 		};
 
@@ -394,6 +394,7 @@ &reg_soc {
 &uart3 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_uart3>;
+	uart-has-rtscts;
 	status = "disabled";
 };
 
-- 
2.30.2

