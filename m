Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8294319B0B2
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 18:29:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732430AbgDAQ2q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:28:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:54166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387659AbgDAQ2p (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:28:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B9D782137B;
        Wed,  1 Apr 2020 16:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585758524;
        bh=5JqrpdjqLIuWIOjEGpjTuL1YlPVL+BNI/ZpNl79kbkE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aHw8idb90JtFRWkRqfXHRgw4qMN/WLsBpTHflHW3W/IZ0aIUMS90MU6lTTOGihHT+
         8HsULRNnauHk9esA31Jr9VWY/Hl0PgmNTLU/x5ULYvetR0xLaiV0Zt1Wl+653o0DIS
         2hJs//cyVSrXbQJkhiUDsjkAfJ6rnpAp7BzQh74w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arthur Demchenkov <spinal.by@gmail.com>,
        Merlijn Wajer <merlijn@wizzup.org>,
        Roger Quadros <rogerq@ti.com>, Tony Lindgren <tony@atomide.com>
Subject: [PATCH 4.19 114/116] ARM: dts: N900: fix onenand timings
Date:   Wed,  1 Apr 2020 18:18:10 +0200
Message-Id: <20200401161556.667067117@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200401161542.669484650@linuxfoundation.org>
References: <20200401161542.669484650@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arthur Demchenkov <spinal.by@gmail.com>

commit 0c5220a3c1242c7a2451570ed5f5af69620aac75 upstream.

Commit a758f50f10cf ("mtd: onenand: omap2: Configure driver from DT")
started using DT specified timings for GPMC, and as a result the
OneNAND stopped working on N900 as we had wrong values in the DT.
Fix by updating the values to bootloader timings that have been tested
to be working on Nokia N900 with OneNAND manufacturers: Samsung,
Numonyx.

Fixes: a758f50f10cf ("mtd: onenand: omap2: Configure driver from DT")
Signed-off-by: Arthur Demchenkov <spinal.by@gmail.com>
Tested-by: Merlijn Wajer <merlijn@wizzup.org>
Reviewed-by: Roger Quadros <rogerq@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/omap3-n900.dts |   44 ++++++++++++++++++++++++---------------
 1 file changed, 28 insertions(+), 16 deletions(-)

--- a/arch/arm/boot/dts/omap3-n900.dts
+++ b/arch/arm/boot/dts/omap3-n900.dts
@@ -852,34 +852,46 @@
 		compatible = "ti,omap2-onenand";
 		reg = <0 0 0x20000>;	/* CS0, offset 0, IO size 128K */
 
+		/*
+		 * These timings are based on CONFIG_OMAP_GPMC_DEBUG=y reported
+		 * bootloader set values when booted with v5.1
+		 * (OneNAND Manufacturer: Samsung):
+		 *
+		 *   cs0 GPMC_CS_CONFIG1: 0xfb001202
+		 *   cs0 GPMC_CS_CONFIG2: 0x00111100
+		 *   cs0 GPMC_CS_CONFIG3: 0x00020200
+		 *   cs0 GPMC_CS_CONFIG4: 0x11001102
+		 *   cs0 GPMC_CS_CONFIG5: 0x03101616
+		 *   cs0 GPMC_CS_CONFIG6: 0x90060000
+		 */
 		gpmc,sync-read;
 		gpmc,sync-write;
 		gpmc,burst-length = <16>;
 		gpmc,burst-read;
 		gpmc,burst-wrap;
 		gpmc,burst-write;
-		gpmc,device-width = <2>; /* GPMC_DEVWIDTH_16BIT */
-		gpmc,mux-add-data = <2>; /* GPMC_MUX_AD */
+		gpmc,device-width = <2>;
+		gpmc,mux-add-data = <2>;
 		gpmc,cs-on-ns = <0>;
-		gpmc,cs-rd-off-ns = <87>;
-		gpmc,cs-wr-off-ns = <87>;
+		gpmc,cs-rd-off-ns = <102>;
+		gpmc,cs-wr-off-ns = <102>;
 		gpmc,adv-on-ns = <0>;
-		gpmc,adv-rd-off-ns = <10>;
-		gpmc,adv-wr-off-ns = <10>;
-		gpmc,oe-on-ns = <15>;
-		gpmc,oe-off-ns = <87>;
+		gpmc,adv-rd-off-ns = <12>;
+		gpmc,adv-wr-off-ns = <12>;
+		gpmc,oe-on-ns = <12>;
+		gpmc,oe-off-ns = <102>;
 		gpmc,we-on-ns = <0>;
-		gpmc,we-off-ns = <87>;
-		gpmc,rd-cycle-ns = <112>;
-		gpmc,wr-cycle-ns = <112>;
-		gpmc,access-ns = <81>;
-		gpmc,page-burst-access-ns = <15>;
+		gpmc,we-off-ns = <102>;
+		gpmc,rd-cycle-ns = <132>;
+		gpmc,wr-cycle-ns = <132>;
+		gpmc,access-ns = <96>;
+		gpmc,page-burst-access-ns = <18>;
 		gpmc,bus-turnaround-ns = <0>;
 		gpmc,cycle2cycle-delay-ns = <0>;
 		gpmc,wait-monitoring-ns = <0>;
-		gpmc,clk-activation-ns = <5>;
-		gpmc,wr-data-mux-bus-ns = <30>;
-		gpmc,wr-access-ns = <81>;
+		gpmc,clk-activation-ns = <6>;
+		gpmc,wr-data-mux-bus-ns = <36>;
+		gpmc,wr-access-ns = <96>;
 		gpmc,sync-clk-ps = <15000>;
 
 		/*


