Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C12946FFFF
	for <lists+stable@lfdr.de>; Fri, 10 Dec 2021 12:34:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235390AbhLJLhx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Dec 2021 06:37:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240538AbhLJLhx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Dec 2021 06:37:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 348FDC0617A1
        for <stable@vger.kernel.org>; Fri, 10 Dec 2021 03:34:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F2B97B827E6
        for <stable@vger.kernel.org>; Fri, 10 Dec 2021 11:34:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34002C00446;
        Fri, 10 Dec 2021 11:34:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639136055;
        bh=uXsU7Mbpxy8zdZePgJ0wC5Dj7FCfFwZvRStzCHK24TY=;
        h=Subject:To:Cc:From:Date:From;
        b=XZljajUhMkXivJSAebi69kfOzCsEtnsh7HSiUb8nLbYjhRoLvK3NDi55QVZZAOSOq
         nMCncO8GZAQnKGB3MOj1JtrV2Q0/TskVQATf7gF4QtpflN/rJMcrIYhumjeDHzoCVu
         7mBaYHIp6CS00aDW2zWRFWsjB4XpRXDSn8cJXoYM=
Subject: FAILED: patch "[PATCH] can: m_can: Disable and ignore ELO interrupt" failed to apply to 4.19-stable tree
To:     brian.silverman@bluerivertech.com, mkl@pengutronix.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 10 Dec 2021 12:33:59 +0100
Message-ID: <1639136039110222@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
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

