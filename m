Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6FD829DE59
	for <lists+stable@lfdr.de>; Thu, 29 Oct 2020 01:54:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731847AbgJ1WTT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Oct 2020 18:19:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:60520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731710AbgJ1WRm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 28 Oct 2020 18:17:42 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 861142472E;
        Wed, 28 Oct 2020 12:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603888784;
        bh=LTeHRK77K3JMi0ZKwDFZ1hVZ5lCtvL2wCJRqxzPSLLE=;
        h=Subject:To:From:Date:From;
        b=WhJA/Ns73aK/F9FL5XUjVfzN2Kvg2yeUnCR7g2sDy/Y1SgSUdivrXEwJY50cuygU4
         uIxBcFx77DwHX3AK0Oeaf7qp/TAYl2522tjDwAPHkQ4JYwfVDdz9nZShF2PrBTyjZA
         1/yVSsfRwOPjTmMFGEGCFeoMCmjYS3Ls1ECAIAoE=
Subject: patch "tty: serial: fsl_lpuart: LS1021A has a FIFO size of 16 words, like" added to tty-linus
To:     vladimir.oltean@nxp.com, fugang.duan@nxp.com,
        gregkh@linuxfoundation.org, michael@walle.cc,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 28 Oct 2020 13:40:35 +0100
Message-ID: <160388883531123@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    tty: serial: fsl_lpuart: LS1021A has a FIFO size of 16 words, like

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From c97f2a6fb3dfbfbbc88edc8ea62ef2b944e18849 Mon Sep 17 00:00:00 2001
From: Vladimir Oltean <vladimir.oltean@nxp.com>
Date: Fri, 23 Oct 2020 04:34:29 +0300
Subject: tty: serial: fsl_lpuart: LS1021A has a FIFO size of 16 words, like
 LS1028A
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Prior to the commit that this one fixes, the FIFO size was derived from
the read-only register LPUARTx_FIFO[TXFIFOSIZE] using the following
formula:

TX FIFO size = 2 ^ (LPUARTx_FIFO[TXFIFOSIZE] - 1)

The documentation for LS1021A is a mess. Under chapter 26.1.3 LS1021A
LPUART module special consideration, it mentions TXFIFO_SZ and RXFIFO_SZ
being equal to 4, and in the register description for LPUARTx_FIFO, it
shows the out-of-reset value of TXFIFOSIZE and RXFIFOSIZE fields as "011",
even though these registers read as "101" in reality.

And when LPUART on LS1021A was working, the "101" value did correspond
to "16 datawords", by applying the formula above, even though the
documentation is wrong again (!!!!) and says that "101" means 64 datawords
(hint: it doesn't).

So the "new" formula created by commit f77ebb241ce0 has all the premises
of being wrong for LS1021A, because it relied only on false data and no
actual experimentation.

Interestingly, in commit c2f448cff22a ("tty: serial: fsl_lpuart: add
LS1028A support"), Michael Walle applied a workaround to this by manually
setting the FIFO widths for LS1028A. It looks like the same values are
used by LS1021A as well, in fact.

When the driver thinks that it has a deeper FIFO than it really has,
getty (user space) output gets truncated.

Many thanks to Michael for pointing out where to look.

Fixes: f77ebb241ce0 ("tty: serial: fsl_lpuart: correct the FIFO depth size")
Suggested-by: Michael Walle <michael@walle.cc>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://lore.kernel.org/r/20201023013429.3551026-1-vladimir.oltean@nxp.com
Reviewed-by：Fugang Duan <fugang.duan@nxp.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/fsl_lpuart.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/tty/serial/fsl_lpuart.c b/drivers/tty/serial/fsl_lpuart.c
index ff4b88c637d0..bd047e1f9bea 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -314,9 +314,10 @@ MODULE_DEVICE_TABLE(of, lpuart_dt_ids);
 /* Forward declare this for the dma callbacks*/
 static void lpuart_dma_tx_complete(void *arg);
 
-static inline bool is_ls1028a_lpuart(struct lpuart_port *sport)
+static inline bool is_layerscape_lpuart(struct lpuart_port *sport)
 {
-	return sport->devtype == LS1028A_LPUART;
+	return (sport->devtype == LS1021A_LPUART ||
+		sport->devtype == LS1028A_LPUART);
 }
 
 static inline bool is_imx8qxp_lpuart(struct lpuart_port *sport)
@@ -1701,11 +1702,11 @@ static int lpuart32_startup(struct uart_port *port)
 					    UARTFIFO_FIFOSIZE_MASK);
 
 	/*
-	 * The LS1028A has a fixed length of 16 words. Although it supports the
-	 * RX/TXSIZE fields their encoding is different. Eg the reference manual
-	 * states 0b101 is 16 words.
+	 * The LS1021A and LS1028A have a fixed FIFO depth of 16 words.
+	 * Although they support the RX/TXSIZE fields, their encoding is
+	 * different. Eg the reference manual states 0b101 is 16 words.
 	 */
-	if (is_ls1028a_lpuart(sport)) {
+	if (is_layerscape_lpuart(sport)) {
 		sport->rxfifo_size = 16;
 		sport->txfifo_size = 16;
 		sport->port.fifosize = sport->txfifo_size;
-- 
2.29.1


