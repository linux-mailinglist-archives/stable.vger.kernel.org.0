Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13137470001
	for <lists+stable@lfdr.de>; Fri, 10 Dec 2021 12:34:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240538AbhLJLiB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Dec 2021 06:38:01 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:53576 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240521AbhLJLiA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Dec 2021 06:38:00 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B4F44CE24EF
        for <stable@vger.kernel.org>; Fri, 10 Dec 2021 11:34:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62207C00446;
        Fri, 10 Dec 2021 11:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639136061;
        bh=EJI7sTqlnAzcucsiIkIPBkvIBjeZ1z7dXDfr3h9OWQY=;
        h=Subject:To:Cc:From:Date:From;
        b=vJP08n247DEwR9sfdPMgzz3GF28FHiF+o5TYZuaXD/nGJjRf2gKB1EANWe88Zcwih
         JALVMQB/W1+PCaYsqQmSD0mJGVwfHAj3VOQevMPFfY8QIDKEI0dDwCxTCOFreyMw55
         ReR2/LRizKbzaLZ7LTGjyU69eYCtRKtmvEi4WcW4=
Subject: FAILED: patch "[PATCH] can: m_can: Disable and ignore ELO interrupt" failed to apply to 4.9-stable tree
To:     brian.silverman@bluerivertech.com, mkl@pengutronix.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 10 Dec 2021 12:34:00 +0100
Message-ID: <1639136040202245@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f58ac1adc76b5beda43c64ef359056077df4d93a Mon Sep 17 00:00:00 2001
From: Brian Silverman <brian.silverman@bluerivertech.com>
Date: Mon, 29 Nov 2021 14:26:28 -0800
Subject: [PATCH] can: m_can: Disable and ignore ELO interrupt

With the design of this driver, this condition is often triggered.
However, the counter that this interrupt indicates an overflow is never
read either, so overflowing is harmless.

On my system, when a CAN bus starts flapping up and down, this locks up
the whole system with lots of interrupts and printks.

Specifically, this interrupt indicates the CEL field of ECR has
overflowed. All reads of ECR mask out CEL.

Fixes: e0d1f4816f2a ("can: m_can: add Bosch M_CAN controller support")
Link: https://lore.kernel.org/all/20211129222628.7490-1-brian.silverman@bluerivertech.com
Cc: stable@vger.kernel.org
Signed-off-by: Brian Silverman <brian.silverman@bluerivertech.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 2470c47b2e31..91be87c4f4d3 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -204,16 +204,16 @@ enum m_can_reg {
 
 /* Interrupts for version 3.0.x */
 #define IR_ERR_LEC_30X	(IR_STE	| IR_FOE | IR_ACKE | IR_BE | IR_CRCE)
-#define IR_ERR_BUS_30X	(IR_ERR_LEC_30X | IR_WDI | IR_ELO | IR_BEU | \
-			 IR_BEC | IR_TOO | IR_MRAF | IR_TSW | IR_TEFL | \
-			 IR_RF1L | IR_RF0L)
+#define IR_ERR_BUS_30X	(IR_ERR_LEC_30X | IR_WDI | IR_BEU | IR_BEC | \
+			 IR_TOO | IR_MRAF | IR_TSW | IR_TEFL | IR_RF1L | \
+			 IR_RF0L)
 #define IR_ERR_ALL_30X	(IR_ERR_STATE | IR_ERR_BUS_30X)
 
 /* Interrupts for version >= 3.1.x */
 #define IR_ERR_LEC_31X	(IR_PED | IR_PEA)
-#define IR_ERR_BUS_31X      (IR_ERR_LEC_31X | IR_WDI | IR_ELO | IR_BEU | \
-			 IR_BEC | IR_TOO | IR_MRAF | IR_TSW | IR_TEFL | \
-			 IR_RF1L | IR_RF0L)
+#define IR_ERR_BUS_31X      (IR_ERR_LEC_31X | IR_WDI | IR_BEU | IR_BEC | \
+			 IR_TOO | IR_MRAF | IR_TSW | IR_TEFL | IR_RF1L | \
+			 IR_RF0L)
 #define IR_ERR_ALL_31X	(IR_ERR_STATE | IR_ERR_BUS_31X)
 
 /* Interrupt Line Select (ILS) */
@@ -810,8 +810,6 @@ static void m_can_handle_other_err(struct net_device *dev, u32 irqstatus)
 {
 	if (irqstatus & IR_WDI)
 		netdev_err(dev, "Message RAM Watchdog event due to missing READY\n");
-	if (irqstatus & IR_ELO)
-		netdev_err(dev, "Error Logging Overflow\n");
 	if (irqstatus & IR_BEU)
 		netdev_err(dev, "Bit Error Uncorrected\n");
 	if (irqstatus & IR_BEC)

