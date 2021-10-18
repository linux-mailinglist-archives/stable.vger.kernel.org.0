Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B947B431E2F
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:57:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232303AbhJRN65 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:58:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:57384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232993AbhJRN5A (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:57:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD9D86140B;
        Mon, 18 Oct 2021 13:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564441;
        bh=ApDastnvPLq2YFZ2J2d8fh7UgJoGtFenx9l778amDpI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hx94ZoikoQYgNi63TY9il4CRE7vHGuNuiI9BBtqdITemj6ZFGGfxBIKENRzhsXWDT
         yzMMgKNG9w+36lTuGpHRQpko0gT/kKCTcOoqB40UiQIGT+p5ni4W/8w94BplQF7eti
         asloglDWnw7EMPvmGTJ5WcPR96BZ5QrO3N1b5t2Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mateusz Kwiatkowski <kfyatek+publicgit@gmail.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Nicolas Saenz Julienne <nsaenz@kernel.org>
Subject: [PATCH 5.14 090/151] ARM: dts: bcm283x: Fix VEC address for BCM2711
Date:   Mon, 18 Oct 2021 15:24:29 +0200
Message-Id: <20211018132343.607079864@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132340.682786018@linuxfoundation.org>
References: <20211018132340.682786018@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mateusz Kwiatkowski <kfyatek+publicgit@gmail.com>

commit 9287e91e9019d4bc1018adb55ab791ae672e0b14 upstream.

The VEC has a different address (0x7ec13000) on the BCM2711 (used in
e.g. Raspberry Pi 4) compared to BCM283x (e.g. Pi 3 and earlier). This
was erroneously not taken account for.

Definition of the VEC in the devicetrees had to be moved from
bcm283x.dtsi to bcm2711.dtsi and bcm2835-common.dtsi to allow for this
differentiation.

Fixes: 7894bdc6228f ("ARM: boot: dts: bcm2711: Add BCM2711 VEC compatible")
Signed-off-by: Mateusz Kwiatkowski <kfyatek+publicgit@gmail.com>
Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
Link: https://lore.kernel.org/r/1626980528-3835-1-git-send-email-stefan.wahren@i2se.com
Signed-off-by: Nicolas Saenz Julienne <nsaenz@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/bcm2711.dtsi        |    8 ++++++++
 arch/arm/boot/dts/bcm2835-common.dtsi |    8 ++++++++
 arch/arm/boot/dts/bcm283x.dtsi        |    8 --------
 3 files changed, 16 insertions(+), 8 deletions(-)

--- a/arch/arm/boot/dts/bcm2711.dtsi
+++ b/arch/arm/boot/dts/bcm2711.dtsi
@@ -300,6 +300,14 @@
 			status = "disabled";
 		};
 
+		vec: vec@7ec13000 {
+			compatible = "brcm,bcm2711-vec";
+			reg = <0x7ec13000 0x1000>;
+			clocks = <&clocks BCM2835_CLOCK_VEC>;
+			interrupts = <GIC_SPI 123 IRQ_TYPE_LEVEL_HIGH>;
+			status = "disabled";
+		};
+
 		dvp: clock@7ef00000 {
 			compatible = "brcm,brcm2711-dvp";
 			reg = <0x7ef00000 0x10>;
--- a/arch/arm/boot/dts/bcm2835-common.dtsi
+++ b/arch/arm/boot/dts/bcm2835-common.dtsi
@@ -106,6 +106,14 @@
 			status = "okay";
 		};
 
+		vec: vec@7e806000 {
+			compatible = "brcm,bcm2835-vec";
+			reg = <0x7e806000 0x1000>;
+			clocks = <&clocks BCM2835_CLOCK_VEC>;
+			interrupts = <2 27>;
+			status = "disabled";
+		};
+
 		pixelvalve@7e807000 {
 			compatible = "brcm,bcm2835-pixelvalve2";
 			reg = <0x7e807000 0x100>;
--- a/arch/arm/boot/dts/bcm283x.dtsi
+++ b/arch/arm/boot/dts/bcm283x.dtsi
@@ -464,14 +464,6 @@
 			status = "disabled";
 		};
 
-		vec: vec@7e806000 {
-			compatible = "brcm,bcm2835-vec";
-			reg = <0x7e806000 0x1000>;
-			clocks = <&clocks BCM2835_CLOCK_VEC>;
-			interrupts = <2 27>;
-			status = "disabled";
-		};
-
 		usb: usb@7e980000 {
 			compatible = "brcm,bcm2835-usb";
 			reg = <0x7e980000 0x10000>;


