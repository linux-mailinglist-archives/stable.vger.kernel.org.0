Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1055E6C1003
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 11:59:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230495AbjCTK7d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 06:59:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230002AbjCTK6i (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 06:58:38 -0400
Received: from relmlie5.idc.renesas.com (relmlor1.renesas.com [210.160.252.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AD4B22916A;
        Mon, 20 Mar 2023 03:55:07 -0700 (PDT)
X-IronPort-AV: E=Sophos;i="5.98,274,1673881200"; 
   d="scan'208";a="153188045"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie5.idc.renesas.com with ESMTP; 20 Mar 2023 19:53:55 +0900
Received: from localhost.localdomain (unknown [10.226.92.205])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id CE9474004BCF;
        Mon, 20 Mar 2023 19:53:52 +0900 (JST)
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Biju Das <biju.das.jz@bp.renesas.com>,
        Jiri Slaby <jirislaby@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        linux-serial@vger.kernel.org,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        linux-renesas-soc@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH v3 3/5] tty: serial: sh-sci: Fix Tx on SCI IP
Date:   Mon, 20 Mar 2023 10:53:37 +0000
Message-Id: <20230320105339.236279-4-biju.das.jz@bp.renesas.com>
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

For SCI, the TE (transmit enable) must be set after setting TIE (transmit
interrupt enable) or in the same instruction to start the transmission.
Set TE bit in sci_start_tx() instead of set_termios() for SCI and clear
TE bit, if circular buffer is empty in sci_transmit_chars().

Fixes: f9a2adcc9e90 ("arm64: dts: renesas: r9a07g044: Add SCI[0-1] nodes")
Cc: stable@vger.kernel.org
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
---
v3:
 * New patch
---
 drivers/tty/serial/sh-sci.c | 25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/sh-sci.c b/drivers/tty/serial/sh-sci.c
index b9cd27451f90..9079a8ea9132 100644
--- a/drivers/tty/serial/sh-sci.c
+++ b/drivers/tty/serial/sh-sci.c
@@ -597,6 +597,15 @@ static void sci_start_tx(struct uart_port *port)
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
@@ -835,6 +844,12 @@ static void sci_transmit_chars(struct uart_port *port)
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
 
@@ -2581,8 +2596,14 @@ static void sci_set_termios(struct uart_port *port, struct ktermios *termios,
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

