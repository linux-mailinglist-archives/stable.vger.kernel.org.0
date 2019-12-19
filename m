Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31CF9126D85
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 20:14:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727715AbfLSSgy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:36:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:54132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727709AbfLSSgx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:36:53 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B20C424679;
        Thu, 19 Dec 2019 18:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576780613;
        bh=y7PJEwvRvvxykxAcJ3PnpOSmhXF2KCRA4ZmeQkYGcXY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IvvSZ1k52y6qw5RI5oRob67r9cQ4NUi4o26ZbdyxXhvBD7cnKnaphDjXRoWy1vCuf
         2WnzuVDQDtQZE7K2wCaQMNspfeJgrmfzXB4/c5/L9Fra9PH9vntfGzEvWX+9nnL0uv
         U1cNIkM8CHFzzjiJlYHpskj0fW1c5BCXrycREEvs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Mack <daniel@zonque.org>,
        Sergey Yanovich <ynvich@gmail.com>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 046/162] ARM: dts: pxa: clean up USB controller nodes
Date:   Thu, 19 Dec 2019 19:32:34 +0100
Message-Id: <20191219183210.710776991@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183150.477687052@linuxfoundation.org>
References: <20191219183150.477687052@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Mack <daniel@zonque.org>

[ Upstream commit c40ad24254f1dbd54f2df5f5f524130dc1862122 ]

PXA25xx SoCs don't have a USB controller, so drop the node from the
common pxa2xx.dtsi base file. Both pxa27x and pxa3xx have a dedicated
node already anyway.

While at it, unify the names for the nodes across all pxa platforms.

Signed-off-by: Daniel Mack <daniel@zonque.org>
Reported-by: Sergey Yanovich <ynvich@gmail.com>
Link: https://patchwork.kernel.org/patch/8375421/
Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/pxa27x.dtsi | 2 +-
 arch/arm/boot/dts/pxa2xx.dtsi | 7 -------
 arch/arm/boot/dts/pxa3xx.dtsi | 2 +-
 3 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/arch/arm/boot/dts/pxa27x.dtsi b/arch/arm/boot/dts/pxa27x.dtsi
index 4448505e34d3b..e1a8466b77a4c 100644
--- a/arch/arm/boot/dts/pxa27x.dtsi
+++ b/arch/arm/boot/dts/pxa27x.dtsi
@@ -27,7 +27,7 @@
 			clocks = <&clks CLK_NONE>;
 		};
 
-		pxa27x_ohci: usb@4c000000 {
+		usb0: usb@4c000000 {
 			compatible = "marvell,pxa-ohci";
 			reg = <0x4c000000 0x10000>;
 			interrupts = <3>;
diff --git a/arch/arm/boot/dts/pxa2xx.dtsi b/arch/arm/boot/dts/pxa2xx.dtsi
index 5e5af078b9b54..7343115c6d55b 100644
--- a/arch/arm/boot/dts/pxa2xx.dtsi
+++ b/arch/arm/boot/dts/pxa2xx.dtsi
@@ -117,13 +117,6 @@
 			status = "disabled";
 		};
 
-		usb0: ohci@4c000000 {
-			compatible = "marvell,pxa-ohci";
-			reg = <0x4c000000 0x10000>;
-			interrupts = <3>;
-			status = "disabled";
-		};
-
 		mmc0: mmc@41100000 {
 			compatible = "marvell,pxa-mmc";
 			reg = <0x41100000 0x1000>;
diff --git a/arch/arm/boot/dts/pxa3xx.dtsi b/arch/arm/boot/dts/pxa3xx.dtsi
index fec47bcd8292f..c714e583e5c75 100644
--- a/arch/arm/boot/dts/pxa3xx.dtsi
+++ b/arch/arm/boot/dts/pxa3xx.dtsi
@@ -88,7 +88,7 @@
 			status = "disabled";
 		};
 
-		pxa3xx_ohci: usb@4c000000 {
+		usb0: usb@4c000000 {
 			compatible = "marvell,pxa-ohci";
 			reg = <0x4c000000 0x10000>;
 			interrupts = <3>;
-- 
2.20.1



