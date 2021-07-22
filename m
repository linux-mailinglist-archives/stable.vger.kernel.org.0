Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F9B33D2969
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:06:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233977AbhGVQD6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 12:03:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:40494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233867AbhGVQDF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 12:03:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A05C561AC0;
        Thu, 22 Jul 2021 16:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626972206;
        bh=DgSsGs98K04WovgFBHCS85LkSAQALYO/sYdvlm0Tcw8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SVx3gFDuVV2SDDlrN/9dMjQtwe8uDajzZ2OI1qmWYRVa0EfIDo4pMcw7a43KFvWqI
         w2e5908D17uVjJTLC6N5rOlIFfgcK4yJW8BuVa9JQyHm1nGti63qwPydGFP6GA/Bkg
         crKquCqlIrXB3/AcqyuOHaZYII4DlEC2wqBJLSCU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Primoz Fiser <primoz.fiser@norik.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 025/156] ARM: dts: imx6: phyFLEX: Fix UART hardware flow control
Date:   Thu, 22 Jul 2021 18:30:00 +0200
Message-Id: <20210722155629.224857956@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155628.371356843@linuxfoundation.org>
References: <20210722155628.371356843@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
@@ -322,8 +322,8 @@
 			fsl,pins = <
 				MX6QDL_PAD_EIM_D24__UART3_TX_DATA	0x1b0b1
 				MX6QDL_PAD_EIM_D25__UART3_RX_DATA	0x1b0b1
-				MX6QDL_PAD_EIM_D30__UART3_RTS_B		0x1b0b1
-				MX6QDL_PAD_EIM_D31__UART3_CTS_B		0x1b0b1
+				MX6QDL_PAD_EIM_D31__UART3_RTS_B		0x1b0b1
+				MX6QDL_PAD_EIM_D30__UART3_CTS_B		0x1b0b1
 			>;
 		};
 
@@ -410,6 +410,7 @@
 &uart3 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_uart3>;
+	uart-has-rtscts;
 	status = "disabled";
 };
 
-- 
2.30.2



