Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48FB73D2839
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 18:37:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231970AbhGVPz5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 11:55:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:59736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229591AbhGVPzi (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 11:55:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 472046135C;
        Thu, 22 Jul 2021 16:36:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626971772;
        bh=z0w3uzXgPEVK0Ue07y87+yuMeQHmxBHxT5W9POJemyY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=akJ1vynM39OHOSgdd6w9l11hJHh4Vcu9EhAQ7QK0vf1t9b+Unh1OQIRAMAmbbNybz
         hTgUDlwUqW6Jk6R2ul9QLFsKuIDtUFd97dmNZkjK8Z4o7QpVCNVd3KZ+oFNfQFVMIa
         /DtQP8pnbdPZ9pntByo/aDh0KqnAsJX9zhvUKCZY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Primoz Fiser <primoz.fiser@norik.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 020/125] ARM: dts: imx6: phyFLEX: Fix UART hardware flow control
Date:   Thu, 22 Jul 2021 18:30:11 +0200
Message-Id: <20210722155625.362641175@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155624.672583740@linuxfoundation.org>
References: <20210722155624.672583740@linuxfoundation.org>
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
index 5f84e9f2b576..33a70f436aa3 100644
--- a/arch/arm/boot/dts/imx6qdl-phytec-pfla02.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-phytec-pfla02.dtsi
@@ -315,8 +315,8 @@
 			fsl,pins = <
 				MX6QDL_PAD_EIM_D24__UART3_TX_DATA	0x1b0b1
 				MX6QDL_PAD_EIM_D25__UART3_RX_DATA	0x1b0b1
-				MX6QDL_PAD_EIM_D30__UART3_RTS_B		0x1b0b1
-				MX6QDL_PAD_EIM_D31__UART3_CTS_B		0x1b0b1
+				MX6QDL_PAD_EIM_D31__UART3_RTS_B		0x1b0b1
+				MX6QDL_PAD_EIM_D30__UART3_CTS_B		0x1b0b1
 			>;
 		};
 
@@ -403,6 +403,7 @@
 &uart3 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_uart3>;
+	uart-has-rtscts;
 	status = "disabled";
 };
 
-- 
2.30.2



