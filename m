Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BF493D2C1E
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 20:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229556AbhGVSHl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 14:07:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:47512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229545AbhGVSHk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 14:07:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4830460EB5;
        Thu, 22 Jul 2021 18:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626979693;
        bh=bzymmLY4DIM5c7FSzYpK0JjD2Q1uGTXAkJkjcHLt3/o=;
        h=Subject:To:Cc:From:Date:From;
        b=RVpD3Q+E5Yi/LnzsN0E+CwJjEfjQb8G1J4VWdu+PjqEAo/Im1O9kWs0HmV0TcIP88
         2TkmJjiGFX85kIALEDNm6yUQZI37UvPNYzF266ytJn5rFQ4C22XB0mcPO6QbO8RYFh
         SUsz+XD1lhBDc5RlvOpPz9yAMJZfbkGNPHSVUaMI=
Subject: FAILED: patch "[PATCH] arm64: dts: renesas: beacon: Fix USB extal reference" failed to apply to 5.10-stable tree
To:     aford173@gmail.com, geert+renesas@glider.be
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 22 Jul 2021 20:48:09 +0200
Message-ID: <1626979689226214@kroah.com>
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

From 56bc54496f5d6bc638127bfc9df3742cbf0039e7 Mon Sep 17 00:00:00 2001
From: Adam Ford <aford173@gmail.com>
Date: Thu, 13 May 2021 06:46:15 -0500
Subject: [PATCH] arm64: dts: renesas: beacon: Fix USB extal reference

The USB extal clock reference isn't associated to a crystal, it's
associated to a programmable clock, so remove the extal reference,
add the usb2_clksel.  Since usb_extal is referenced by the versaclock,
reference it here so the usb2_clksel can get the proper clock speed
of 50MHz.

Signed-off-by: Adam Ford <aford173@gmail.com>
Link: https://lore.kernel.org/r/20210513114617.30191-1-aford173@gmail.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

diff --git a/arch/arm64/boot/dts/renesas/beacon-renesom-som.dtsi b/arch/arm64/boot/dts/renesas/beacon-renesom-som.dtsi
index 75355c354c38..090dc9c4f57b 100644
--- a/arch/arm64/boot/dts/renesas/beacon-renesom-som.dtsi
+++ b/arch/arm64/boot/dts/renesas/beacon-renesom-som.dtsi
@@ -321,8 +321,10 @@ &sdhi3 {
 	status = "okay";
 };
 
-&usb_extal_clk {
-	clock-frequency = <50000000>;
+&usb2_clksel {
+	clocks = <&cpg CPG_MOD 703>, <&cpg CPG_MOD 704>,
+		  <&versaclock5 3>, <&usb3s0_clk>;
+	status = "okay";
 };
 
 &usb3s0_clk {

