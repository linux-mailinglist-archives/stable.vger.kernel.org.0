Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A8A117F952
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 13:55:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729061AbgCJMzm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:55:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:34510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729552AbgCJMzi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:55:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB16820674;
        Tue, 10 Mar 2020 12:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583844938;
        bh=ag3c6GVTu3Y1a+XFsrgA2806COetS2Xnz2jc0AH61aw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ytDr+7GQqjJF7FWGjLDZ7kIbNdsqcdmB+yeEOp6dpBckzRGuhKexRHcNHzppbs5W8
         NxGOPGSUsqgfD3r+3Or5HpjlbhYXxTtB/+GNC4emZlzr51xBGjLmz3LVE40NgfNpNq
         WRleMCV1XaFJgZ060jg9GzGr+FpUR1Xlm5xcNxQQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Suman Anna <s-anna@ti.com>,
        Tony Lindgren <tony@atomide.com>
Subject: [PATCH 5.4 156/168] ARM: dts: dra7xx-clocks: Fixup IPU1 mux clock parent source
Date:   Tue, 10 Mar 2020 13:40:02 +0100
Message-Id: <20200310123651.318646878@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123635.322799692@linuxfoundation.org>
References: <20200310123635.322799692@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suman Anna <s-anna@ti.com>

commit 78722d37b2b4cf9178295e2aa5510880e6135fd7 upstream.

The IPU1 functional clock is the output of a mux clock (represented
by ipu1_gfclk_mux previously) and the clock source for this has been
updated to be sourced from dpll_core_h22x2_ck in commit 39879c7d963e
("ARM: dts: dra7xx-clocks: Source IPU1 functional clock from CORE DPLL").
ipu1_gfclk_mux is an obsolete clock now with the clkctrl conversion,
and this clock source parenting is lost during the new clkctrl layout
conversion.

Remove this stale clock and fix up the clock source for this mux
clock using the latest equivalent clkctrl clock. This restores the
previous logic and ensures that the IPU1 continues to run at the
same frequency of IPU2 and independent of the ABE DPLL.

Fixes: b5f8ffbb6fad ("ARM: dts: dra7: convert to use new clkctrl layout")
Signed-off-by: Suman Anna <s-anna@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/dra7xx-clocks.dtsi |   12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

--- a/arch/arm/boot/dts/dra7xx-clocks.dtsi
+++ b/arch/arm/boot/dts/dra7xx-clocks.dtsi
@@ -796,16 +796,6 @@
 		clock-div = <1>;
 	};
 
-	ipu1_gfclk_mux: ipu1_gfclk_mux@520 {
-		#clock-cells = <0>;
-		compatible = "ti,mux-clock";
-		clocks = <&dpll_abe_m2x2_ck>, <&dpll_core_h22x2_ck>;
-		ti,bit-shift = <24>;
-		reg = <0x0520>;
-		assigned-clocks = <&ipu1_gfclk_mux>;
-		assigned-clock-parents = <&dpll_core_h22x2_ck>;
-	};
-
 	dummy_ck: dummy_ck {
 		#clock-cells = <0>;
 		compatible = "fixed-clock";
@@ -1564,6 +1554,8 @@
 			compatible = "ti,clkctrl";
 			reg = <0x20 0x4>;
 			#clock-cells = <2>;
+			assigned-clocks = <&ipu1_clkctrl DRA7_IPU1_MMU_IPU1_CLKCTRL 24>;
+			assigned-clock-parents = <&dpll_core_h22x2_ck>;
 		};
 
 		ipu_clkctrl: ipu-clkctrl@50 {


