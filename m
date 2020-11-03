Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3EF12A5836
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:50:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730768AbgKCVtn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:49:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:42638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731581AbgKCUtc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:49:32 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C8DD20719;
        Tue,  3 Nov 2020 20:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436571;
        bh=QYyRrFbcyXrX73ICqkPVtJdE0djkzXrE+AgOOO/FjuE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wFWrpcFHu6kJt/EKmgsAAglx+eSiJDyc9iIEzY8yYlxEibIhCgQl73/vXH+l2ZJzb
         PL2LG02PVQgomGf2w3GLf8skW2J3h8mUILq+Cs6+hlY1KBzaIi7QOkQFj5YunjZaKD
         wrf7lsyuja5lY+P4ztx4XskQYcBMf3PMX5rjeBOE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Walle <michael@walle.cc>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH 5.9 260/391] tty: serial: fsl_lpuart: LS1021A has a FIFO size of 16 words, like LS1028A
Date:   Tue,  3 Nov 2020 21:35:11 +0100
Message-Id: <20201103203404.568391592@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

commit c97f2a6fb3dfbfbbc88edc8ea62ef2b944e18849 upstream.

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
 drivers/tty/serial/fsl_lpuart.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

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
@@ -1644,11 +1645,11 @@ static int lpuart32_startup(struct uart_
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


