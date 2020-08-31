Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF7D22577A8
	for <lists+stable@lfdr.de>; Mon, 31 Aug 2020 12:49:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726489AbgHaKtW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Aug 2020 06:49:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726121AbgHaKtW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Aug 2020 06:49:22 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37814C061573
        for <stable@vger.kernel.org>; Mon, 31 Aug 2020 03:49:22 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <str@pengutronix.de>)
        id 1kChNG-0004g5-CN; Mon, 31 Aug 2020 12:49:18 +0200
Received: from str by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <str@pengutronix.de>)
        id 1kChNF-0007YK-Vw; Mon, 31 Aug 2020 12:49:17 +0200
From:   Steffen Trumtrar <s.trumtrar@pengutronix.de>
To:     Dinh Nguyen <dinguyen@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Cc:     stable@vger.kernel.org
Subject: [PATCH] ARM: socfpga: arria10: fix timer3 address
Date:   Mon, 31 Aug 2020 12:49:12 +0200
Message-Id: <20200831104912.28974-1-s.trumtrar@pengutronix.de>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: str@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Since commit 6d2e16a3181b ("clocksource: dw_apb_timer_of: Fix missing
clockevent timers") the dw_apb_timer_of code tries to add a clockevent
for timer3. This reveals the wrong register offset that is provided in
the timer3-node in the socfpga_arria10 devicetree which in turn results
in

  Unhandled fault: imprecise external abort (0x406) at 0xbea9fe20

and therefore in a kernel panic.

Set the offset to the correct value.

Cc: stable@vger.kernel.org
Signed-off-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>
---
 arch/arm/boot/dts/socfpga_arria10.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/socfpga_arria10.dtsi b/arch/arm/boot/dts/socfpga_arria10.dtsi
index 7b8961794a82..a5bd4537766d 100644
--- a/arch/arm/boot/dts/socfpga_arria10.dtsi
+++ b/arch/arm/boot/dts/socfpga_arria10.dtsi
@@ -852,7 +852,7 @@
 		timer3: timer3@ffd00100 {
 			compatible = "snps,dw-apb-timer";
 			interrupts = <0 118 IRQ_TYPE_LEVEL_HIGH>;
-			reg = <0xffd01000 0x100>;
+			reg = <0xffd00100 0x100>;
 			clocks = <&l4_sys_free_clk>;
 			clock-names = "timer";
 			resets = <&rst L4SYSTIMER1_RESET>;
-- 
2.28.0

