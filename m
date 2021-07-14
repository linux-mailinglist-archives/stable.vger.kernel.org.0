Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD67D3C8C46
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:39:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233417AbhGNTle (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:41:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:36120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233020AbhGNTld (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:41:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 531B8613D4;
        Wed, 14 Jul 2021 19:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291521;
        bh=1Ygl143RWXnJvZswsvdQxQjefwP09XEGPUnmffJOIjI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qhf95t4LkG55udOe7U8m1o1tmxwq7jxB3Br83NNVFOGEw9now4U3t5P7Uq3KYq7Hz
         +ZQNpCCGvdOOvT5MlkFSqPLe3cwe4A0oY7a+/A8VBlbVvzdFgKw+w8UEx0ZmWoM4ct
         I0R5mGiLV0UueenM+sahF2JtNmE6q4NElOYm2eo841L4/7RtXONOKzbp2Eglr0Nbd9
         DGDtmVdvkmJwylKvqZVr5Ij5N7TKPD5n59E6qkHQ8YRbmdtnFPjn0G8hoCy3zwJmeY
         UQV+CORohXbXFu5n+wurfW/uMIIYHH/RFKFQpO+/Ah6IB9py2zhu4mhguC9N8OLo6L
         rS9m1dKnpriQg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Primoz Fiser <primoz.fiser@norik.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.13 027/108] ARM: dts: imx6: phyFLEX: Fix UART hardware flow control
Date:   Wed, 14 Jul 2021 15:36:39 -0400
Message-Id: <20210714193800.52097-27-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714193800.52097-1-sashal@kernel.org>
References: <20210714193800.52097-1-sashal@kernel.org>
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
index 7bd658b7bdda..f3236204cb5a 100644
--- a/arch/arm/boot/dts/imx6qdl-phytec-pfla02.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-phytec-pfla02.dtsi
@@ -322,8 +322,8 @@ pinctrl_uart3: uart3grp {
 			fsl,pins = <
 				MX6QDL_PAD_EIM_D24__UART3_TX_DATA	0x1b0b1
 				MX6QDL_PAD_EIM_D25__UART3_RX_DATA	0x1b0b1
-				MX6QDL_PAD_EIM_D30__UART3_RTS_B		0x1b0b1
-				MX6QDL_PAD_EIM_D31__UART3_CTS_B		0x1b0b1
+				MX6QDL_PAD_EIM_D31__UART3_RTS_B		0x1b0b1
+				MX6QDL_PAD_EIM_D30__UART3_CTS_B		0x1b0b1
 			>;
 		};
 
@@ -410,6 +410,7 @@ &reg_soc {
 &uart3 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_uart3>;
+	uart-has-rtscts;
 	status = "disabled";
 };
 
-- 
2.30.2

