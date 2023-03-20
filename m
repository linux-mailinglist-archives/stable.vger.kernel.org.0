Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8ED5C6C0FFF
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 11:59:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230365AbjCTK7U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 06:59:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbjCTK63 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 06:58:29 -0400
Received: from relmlie6.idc.renesas.com (relmlor2.renesas.com [210.160.252.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 42860274A0;
        Mon, 20 Mar 2023 03:55:02 -0700 (PDT)
X-IronPort-AV: E=Sophos;i="5.98,274,1673881200"; 
   d="scan'208";a="156562987"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie6.idc.renesas.com with ESMTP; 20 Mar 2023 19:53:59 +0900
Received: from localhost.localdomain (unknown [10.226.92.205])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id 24A1E4004BCF;
        Mon, 20 Mar 2023 19:53:55 +0900 (JST)
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Biju Das <biju.das.jz@bp.renesas.com>,
        Jiri Slaby <jirislaby@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        linux-serial@vger.kernel.org,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        linux-renesas-soc@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH v3 4/5] tty: serial: sh-sci: Add support for tx end interrupt handling
Date:   Mon, 20 Mar 2023 10:53:38 +0000
Message-Id: <20230320105339.236279-5-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230320105339.236279-1-biju.das.jz@bp.renesas.com>
References: <20230320105339.236279-1-biju.das.jz@bp.renesas.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

As per the RZ/G2L users hardware manual (Rev.1.20 Sep, 2022), section
23.3.7 Serial Data Transmission (Asynchronous Mode), it is mentioned
that, set the SCR.TIE bit to 0 and SCR.TEIE bit to 1, after the last
data to be transmitted are written to the TDR.

This will generate tx end interrupt and in the handler set SCR.TE and
SCR.TEIE to 0.

Fixes: f9a2adcc9e90 ("arm64: dts: renesas: r9a07g044: Add SCI[0-1] nodes")
Cc: stable@vger.kernel.org
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
---
v3:
 * New patch
---
 drivers/tty/serial/sh-sci.c | 31 ++++++++++++++++++++++++++++---
 drivers/tty/serial/sh-sci.h |  3 +++
 2 files changed, 31 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/serial/sh-sci.c b/drivers/tty/serial/sh-sci.c
index 9079a8ea9132..adc2ac4a3cf6 100644
--- a/drivers/tty/serial/sh-sci.c
+++ b/drivers/tty/serial/sh-sci.c
@@ -862,9 +862,16 @@ static void sci_transmit_chars(struct uart_port *port)
 
 	if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
 		uart_write_wakeup(port);
-	if (uart_circ_empty(xmit))
-		sci_stop_tx(port);
+	if (uart_circ_empty(xmit)) {
+		if (port->type == PORT_SCI) {
+			ctrl = serial_port_in(port, SCSCR);
+			ctrl &= ~SCSCR_TIE;
+			ctrl |= SCSCR_TEIE;
+			serial_port_out(port, SCSCR, ctrl);
+		}
 
+		sci_stop_tx(port);
+	}
 }
 
 static void sci_receive_chars(struct uart_port *port)
@@ -1753,6 +1760,24 @@ static irqreturn_t sci_tx_interrupt(int irq, void *ptr)
 	return IRQ_HANDLED;
 }
 
+static irqreturn_t sci_tx_end_interrupt(int irq, void *ptr)
+{
+	struct uart_port *port = ptr;
+	unsigned long flags;
+	unsigned short ctrl;
+
+	if (port->type != PORT_SCI)
+		return sci_tx_interrupt(irq, ptr);
+
+	spin_lock_irqsave(&port->lock, flags);
+	ctrl = serial_port_in(port, SCSCR);
+	ctrl &= ~(SCSCR_TE | SCSCR_TEIE);
+	serial_port_out(port, SCSCR, ctrl);
+	spin_unlock_irqrestore(&port->lock, flags);
+
+	return IRQ_HANDLED;
+}
+
 static irqreturn_t sci_br_interrupt(int irq, void *ptr)
 {
 	struct uart_port *port = ptr;
@@ -1889,7 +1914,7 @@ static const struct sci_irq_desc {
 
 	[SCIx_TEI_IRQ] = {
 		.desc = "tx end",
-		.handler = sci_tx_interrupt,
+		.handler = sci_tx_end_interrupt,
 	},
 
 	/*
diff --git a/drivers/tty/serial/sh-sci.h b/drivers/tty/serial/sh-sci.h
index c0ae78632dda..7460f6021a92 100644
--- a/drivers/tty/serial/sh-sci.h
+++ b/drivers/tty/serial/sh-sci.h
@@ -59,6 +59,9 @@ enum {
 #define SCSMR_SRC_19	0x0600	/* Sampling rate 1/19 */
 #define SCSMR_SRC_27	0x0700	/* Sampling rate 1/27 */
 
+/* Serial Control Register, RZ SCI only bits */
+#define SCSCR_TEIE	BIT(2)		/* Transmit End Interrupt Enable */
+
 /* Serial Control Register, SCIFA/SCIFB only bits */
 #define SCSCR_TDRQE	BIT(15)	/* Tx Data Transfer Request Enable */
 #define SCSCR_RDRQE	BIT(14)	/* Rx Data Transfer Request Enable */
-- 
2.25.1

