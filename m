Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16AE32ABB61
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:28:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733215AbgKINOu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:14:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:41266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731892AbgKINOt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:14:49 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E66BC20867;
        Mon,  9 Nov 2020 13:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927688;
        bh=TCj67ClWiMRJkTMqqqomrJynDRG5J06ZNnfcLOzKfA0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qq1gf3T7kE595nEOvWjcJLAXY6ZLFbCHRo8vnNzjEp4M+FUG0xgH5CPxfLKltw/+O
         LJaGxi5Ege+yqyioyJvY85FixvBVucCtKWZA9tUluCU7reeNh73jJT5ZiLzihVXCQM
         CPZekf3u4pUkg01MAiEjF0UIAnvRSZLv1BoR/oCU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Walle <michael@walle.cc>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH 5.4 74/85] tty: serial: fsl_lpuart: LS1021A has a FIFO size of 16 words, like LS1028A
Date:   Mon,  9 Nov 2020 13:56:11 +0100
Message-Id: <20201109125026.130739118@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125022.614792961@linuxfoundation.org>
References: <20201109125022.614792961@linuxfoundation.org>
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
@@ -318,9 +318,10 @@ MODULE_DEVICE_TABLE(of, lpuart_dt_ids);
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
@@ -1566,11 +1567,11 @@ static int lpuart32_startup(struct uart_
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


