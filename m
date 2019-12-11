Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FC5F11B06E
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:22:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730932AbfLKPWn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:22:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:53496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732630AbfLKPWl (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:22:41 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 82D2C2073D;
        Wed, 11 Dec 2019 15:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077760;
        bh=zFJXkK5NTDEYDICxlCGpP4NSUh2oXKu5G1zQkxmwtj4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mPZhVY6rBV8aFAryEGLEpMCL+d+r0j9PKAswwfMSmKXRqnS4EMjR8b2pKz2U9PkwP
         Xik2ST5VYkKHB48i9p/FQBSWvoDzvnPPW8CIdzok5mK4FibEX9YyEiZNBwGooxp6HP
         KdyiRJVMQm7jeFsh3sp/FKcCVLbkf2KPehhYA2kY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Mack <daniel@zonque.org>,
        Sergey Yanovich <ynvich@gmail.com>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 161/243] ARM: dts: pxa: clean up USB controller nodes
Date:   Wed, 11 Dec 2019 16:05:23 +0100
Message-Id: <20191211150350.032424282@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
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
index 3228ad5fb725f..ccbecad9c5c7c 100644
--- a/arch/arm/boot/dts/pxa27x.dtsi
+++ b/arch/arm/boot/dts/pxa27x.dtsi
@@ -35,7 +35,7 @@
 			clocks = <&clks CLK_NONE>;
 		};
 
-		pxa27x_ohci: usb@4c000000 {
+		usb0: usb@4c000000 {
 			compatible = "marvell,pxa-ohci";
 			reg = <0x4c000000 0x10000>;
 			interrupts = <3>;
diff --git a/arch/arm/boot/dts/pxa2xx.dtsi b/arch/arm/boot/dts/pxa2xx.dtsi
index a520b4c14ea9f..0a0e837dc79cb 100644
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
index 3a8f0edc3af99..53009dbd36158 100644
--- a/arch/arm/boot/dts/pxa3xx.dtsi
+++ b/arch/arm/boot/dts/pxa3xx.dtsi
@@ -204,7 +204,7 @@
 			status = "disabled";
 		};
 
-		pxa3xx_ohci: usb@4c000000 {
+		usb0: usb@4c000000 {
 			compatible = "marvell,pxa-ohci";
 			reg = <0x4c000000 0x10000>;
 			interrupts = <3>;
-- 
2.20.1



