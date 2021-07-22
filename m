Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BFF53D2C1F
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 20:48:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbhGVSHy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 14:07:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:47564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229545AbhGVSHy (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 14:07:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5ED1C60EB6;
        Thu, 22 Jul 2021 18:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626979707;
        bh=0v/OHfCt6EhRpxblHKl8J7VV+RuXo5xKG1VOlDZz8hE=;
        h=Subject:To:Cc:From:Date:From;
        b=thbtnTejgqUqulT+q2OpnqBYhnA6axQ9SSmYtinx7JAhemKMvm5tijBV7s+Uf9prA
         rQqdKTCcTy2Ba+MmOVCq59CxwSyg/2Ws7xi3zvaJTs1UU8j7YJqKu51wVihPCoRKu7
         hcLtWtaKwcCI8kOHNxRd59Sifp7b4uR9ktvzwIFE=
Subject: FAILED: patch "[PATCH] arm64: dts: renesas: beacon: Fix USB ref clock references" failed to apply to 5.10-stable tree
To:     aford173@gmail.com, geert+renesas@glider.be
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 22 Jul 2021 20:48:25 +0200
Message-ID: <1626979705124214@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ebc666f39ff67a01e748c34d670ddf05a9e45220 Mon Sep 17 00:00:00 2001
From: Adam Ford <aford173@gmail.com>
Date: Thu, 13 May 2021 06:46:16 -0500
Subject: [PATCH] arm64: dts: renesas: beacon: Fix USB ref clock references

The RZ/G2 boards expect there to be an external clock reference for
USB2 EHCI controllers.  For the Beacon boards, this reference clock
is controlled by a programmable versaclock.  Because the RZ/G2
family has a special clock driver when using an external clock,
the third clock reference in the EHCI node needs to point to this
special clock, called usb2_clksel.

Since the usb2_clksel does not keep the usb_extal clock enabled,
the 4th clock entry for the EHCI nodes needs to reference it to
keep the clock running and make USB functional.

Signed-off-by: Adam Ford <aford173@gmail.com>
Link: https://lore.kernel.org/r/20210513114617.30191-2-aford173@gmail.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

diff --git a/arch/arm64/boot/dts/renesas/beacon-renesom-baseboard.dtsi b/arch/arm64/boot/dts/renesas/beacon-renesom-baseboard.dtsi
index d8046fedf9c1..e3c8b2fe143e 100644
--- a/arch/arm64/boot/dts/renesas/beacon-renesom-baseboard.dtsi
+++ b/arch/arm64/boot/dts/renesas/beacon-renesom-baseboard.dtsi
@@ -271,12 +271,12 @@ &du_out_rgb {
 &ehci0 {
 	dr_mode = "otg";
 	status = "okay";
-	clocks = <&cpg CPG_MOD 703>, <&cpg CPG_MOD 704>;
+	clocks = <&cpg CPG_MOD 703>, <&cpg CPG_MOD 704>, <&usb2_clksel>, <&versaclock5 3>;
 };
 
 &ehci1 {
 	status = "okay";
-	clocks = <&cpg CPG_MOD 703>, <&cpg CPG_MOD 704>;
+	clocks = <&cpg CPG_MOD 703>, <&cpg CPG_MOD 704>, <&usb2_clksel>, <&versaclock5 3>;
 };
 
 &hdmi0 {

