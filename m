Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AEC66C30BF
	for <lists+stable@lfdr.de>; Tue, 21 Mar 2023 12:48:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230337AbjCULsX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Mar 2023 07:48:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230368AbjCULsO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Mar 2023 07:48:14 -0400
Received: from relmlie5.idc.renesas.com (relmlor1.renesas.com [210.160.252.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 829C71E1D2;
        Tue, 21 Mar 2023 04:48:10 -0700 (PDT)
X-IronPort-AV: E=Sophos;i="5.98,278,1673881200"; 
   d="scan'208";a="153277031"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie5.idc.renesas.com with ESMTP; 21 Mar 2023 20:48:10 +0900
Received: from localhost.localdomain (unknown [10.226.93.140])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id 4302C41E388B;
        Tue, 21 Mar 2023 20:48:06 +0900 (JST)
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Biju Das <biju.das.jz@bp.renesas.com>,
        Jiri Slaby <jirislaby@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        linux-serial@vger.kernel.org,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        linux-renesas-soc@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH v4 3/5] tty: serial: sh-sci: Fix Tx on SCI IP
Date:   Tue, 21 Mar 2023 11:47:51 +0000
Message-Id: <20230321114753.75038-4-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230321114753.75038-1-biju.das.jz@bp.renesas.com>
References: <20230321114753.75038-1-biju.das.jz@bp.renesas.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

For SCI, the TE (transmit enable) must be set after setting TIE (transmit
interrupt enable) or in the same instruction to start the transmission.
Set TE bit in sci_start_tx() instead of set_termios() for SCI and clear
TE bit, if circular buffer is empty in sci_transmit_chars().

Fixes: 93bcefd4c6ba ("serial: sh-sci: Fix setting SCSCR_TIE while transferring data")
Cc: stable@vger.kernel.org
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
---
v3->v4:
 * Updated fixes tag.
v3:
 * New patch
---
 drivers/tty/serial/sh-sci.c | 25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/sh-sci.c b/drivers/tty/serial/sh-sci.c
index 15954ca3e9dc..bcc4152ce043 100644
--- a/drivers/tty/serial/sh-sci.c
+++ b/drivers/tty/serial/sh-sci.c
@@ -596,6 +596,15 @@ static void sci_start_tx(struct uart_port *port)
 	if (!s->chan_tx || port->type == PORT_SCIFA || port->type == PORT_SCIFB) {
 		/* Set TIE (Transmit Interrupt Enable) bit in SCSCR */
 		ctrl = serial_port_in(port, SCSCR);
+
+		/*
+		 * For SCI, TE (transmit enable) must be set after setting TIE
+		 * (transmit interrupt enable) or in the same instruction to start
+		 * the transmit process.
+		 */
+		if (port->type == PORT_SCI)
+			ctrl |= SCSCR_TE;
+
 		serial_port_out(port, SCSCR, ctrl | SCSCR_TIE);
 	}
 }
@@ -834,6 +843,12 @@ static void sci_transmit_chars(struct uart_port *port)
 			c = xmit->buf[xmit->tail];
 			xmit->tail = (xmit->tail + 1) & (UART_XMIT_SIZE - 1);
 		} else {
+			if (port->type == PORT_SCI) {
+				ctrl = serial_port_in(port, SCSCR);
+				ctrl &= ~SCSCR_TE;
+				serial_port_out(port, SCSCR, ctrl);
+				return;
+			}
 			break;
 		}
 
@@ -2580,8 +2595,14 @@ static void sci_set_termios(struct uart_port *port, struct ktermios *termios,
 		sci_set_mctrl(port, port->mctrl);
 	}
 
-	scr_val |= SCSCR_RE | SCSCR_TE |
-		   (s->cfg->scscr & ~(SCSCR_CKE1 | SCSCR_CKE0));
+	/*
+	 * For SCI, TE (transmit enable) must be set after setting TIE
+	 * (transmit interrupt enable) or in the same instruction to
+	 * start the transmitting process. So skip setting TE here for SCI.
+	 */
+	if (port->type != PORT_SCI)
+		scr_val |= SCSCR_TE;
+	scr_val |= SCSCR_RE | (s->cfg->scscr & ~(SCSCR_CKE1 | SCSCR_CKE0));
 	serial_port_out(port, SCSCR, scr_val | s->hscif_tot);
 	if ((srr + 1 == 5) &&
 	    (port->type == PORT_SCIFA || port->type == PORT_SCIFB)) {
-- 
2.25.1

