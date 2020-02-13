Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A994C15C435
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:53:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729414AbgBMP13 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:27:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:50802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729410AbgBMP13 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:27:29 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A926F20661;
        Thu, 13 Feb 2020 15:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607648;
        bh=oZBAetFEYbzhQ5qSX3ax2gWXTVqhU/D25NWfZlIdAV0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iWPnvsCHeH6ND5+Kk/N4OjloC9UQiginX78NtdWCVqSTTPe9Ilj00NUc3/qWrx8Lp
         NFuKiT8JCxgkX2pdlGEBT9lKmCY1iXehE3ncVRs5QwXmvgpx6P73P5hpOUKJIZmBTw
         IfiuWxr7n7EEKuQu/dZo+Xbjc3oX8cI/l7c6UIoU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        Gregory CLEMENT <gregory.clement@bootlin.com>
Subject: [PATCH 5.4 42/96] arm64: dts: uDPU: fix broken ethernet
Date:   Thu, 13 Feb 2020 07:20:49 -0800
Message-Id: <20200213151855.464959648@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151839.156309910@linuxfoundation.org>
References: <20200213151839.156309910@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>

commit 1eebac0240580b531954b02c05068051df41142a upstream.

The uDPU uses both ethernet controllers, which ties up COMPHY 0 for
eth1 and COMPHY 1 for eth0, with no USB3 comphy.  The addition of
COMPHY support made the kernel override the setup by the boot loader
breaking this platform by assuming that COMPHY 0 was always used for
USB3.  Delete the USB3 COMPHY definition at platform level, and add
phy specifications for the ethernet channels.

Fixes: bd3d25b07342 ("arm64: dts: marvell: armada-37xx: link USB hosts with their PHYs")
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/boot/dts/marvell/armada-3720-uDPU.dts |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/arm64/boot/dts/marvell/armada-3720-uDPU.dts
+++ b/arch/arm64/boot/dts/marvell/armada-3720-uDPU.dts
@@ -143,6 +143,7 @@
 	phy-mode = "sgmii";
 	status = "okay";
 	managed = "in-band-status";
+	phys = <&comphy1 0>;
 	sfp = <&sfp_eth0>;
 };
 
@@ -150,11 +151,14 @@
 	phy-mode = "sgmii";
 	status = "okay";
 	managed = "in-band-status";
+	phys = <&comphy0 1>;
 	sfp = <&sfp_eth1>;
 };
 
 &usb3 {
 	status = "okay";
+	phys = <&usb2_utmi_otg_phy>;
+	phy-names = "usb2-utmi-otg-phy";
 };
 
 &uart0 {


