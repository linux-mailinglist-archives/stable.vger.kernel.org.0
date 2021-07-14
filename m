Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 079143C8FE1
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:59:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240514AbhGNTxb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:53:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:46536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240585AbhGNTty (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:49:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8FE3D61434;
        Wed, 14 Jul 2021 19:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291941;
        bh=rv1Jq7gSeH/D7qK7OR/7LIsNvqRJl3kZI8/nznX9llE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mIsMq6suz05OpPTEC/bY8vXLSLgdQFKh1m8tNeAYtmBnrs9iKqHgjCIwn64QMvXiS
         irqXuEtc0l/WweA/8RfNZtUSmkMQfUzsFAT0nd4QtlqIbyYWW6ZyqoBHNcGvBY3YyM
         AcKvsPmyxbycdJ11E1uIScV4SdgXnddB3HO/zwrVBGLZEEmWjCtWuSan/kychfTddK
         oWZjK1eh81AvzNaH63zgUJeKKfmbirQNQWoGHPsdFoWgerrSJARQgf/qinLO6vHoCK
         wcrH7gUIL794BIELGnzDhueXXTt05RiN1jtS67yFjtgiKK/q6CgCB9exjREl+AZMsb
         oeeFM26Owx9qg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Primoz Fiser <primoz.fiser@norik.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 19/51] ARM: dts: imx6: phyFLEX: Fix UART hardware flow control
Date:   Wed, 14 Jul 2021 15:44:41 -0400
Message-Id: <20210714194513.54827-19-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194513.54827-1-sashal@kernel.org>
References: <20210714194513.54827-1-sashal@kernel.org>
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
index 6678b97b1007..3617089dbe36 100644
--- a/arch/arm/boot/dts/imx6qdl-phytec-pfla02.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-phytec-pfla02.dtsi
@@ -315,8 +315,8 @@ pinctrl_uart3: uart3grp {
 			fsl,pins = <
 				MX6QDL_PAD_EIM_D24__UART3_TX_DATA	0x1b0b1
 				MX6QDL_PAD_EIM_D25__UART3_RX_DATA	0x1b0b1
-				MX6QDL_PAD_EIM_D30__UART3_RTS_B		0x1b0b1
-				MX6QDL_PAD_EIM_D31__UART3_CTS_B		0x1b0b1
+				MX6QDL_PAD_EIM_D31__UART3_RTS_B		0x1b0b1
+				MX6QDL_PAD_EIM_D30__UART3_CTS_B		0x1b0b1
 			>;
 		};
 
@@ -403,6 +403,7 @@ &reg_soc {
 &uart3 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_uart3>;
+	uart-has-rtscts;
 	status = "disabled";
 };
 
-- 
2.30.2

