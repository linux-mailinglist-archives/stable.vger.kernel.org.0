Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6560E88E3A
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 22:53:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726565AbfHJUwx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Aug 2019 16:52:53 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54016 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726543AbfHJUnu (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Aug 2019 16:43:50 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDJ-00053Y-UY; Sat, 10 Aug 2019 21:43:45 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDJ-0003ZW-6m; Sat, 10 Aug 2019 21:43:45 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Hoan Nguyen An" <na-hoan@jinso.co.jp>
Date:   Sat, 10 Aug 2019 21:40:07 +0100
Message-ID: <lsq.1565469607.565559628@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 026/157] serial: sh-sci: Fix setting SCSCR_TIE while
 transferring data
In-Reply-To: <lsq.1565469607.188083258@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.72-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Hoan Nguyen An <na-hoan@jinso.co.jp>

commit 93bcefd4c6bad4c69dbc4edcd3fbf774b24d930d upstream.

We disable transmission interrupt (clear SCSCR_TIE) after all data has been transmitted
(if uart_circ_empty(xmit)). While transmitting, if the data is still in the tty buffer,
re-enable the SCSCR_TIE bit, which was done at sci_start_tx().
This is unnecessary processing, wasting CPU operation if the data transmission length is large.
And further, transmit end, FIFO empty bits disabling have also been performed in the step above.

Signed-off-by: Hoan Nguyen An <na-hoan@jinso.co.jp>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/tty/serial/sh-sci.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

--- a/drivers/tty/serial/sh-sci.c
+++ b/drivers/tty/serial/sh-sci.c
@@ -633,19 +633,9 @@ static void sci_transmit_chars(struct ua
 
 	if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
 		uart_write_wakeup(port);
-	if (uart_circ_empty(xmit)) {
+	if (uart_circ_empty(xmit))
 		sci_stop_tx(port);
-	} else {
-		ctrl = serial_port_in(port, SCSCR);
 
-		if (port->type != PORT_SCI) {
-			serial_port_in(port, SCxSR); /* Dummy read */
-			serial_port_out(port, SCxSR, SCxSR_TDxE_CLEAR(port));
-		}
-
-		ctrl |= SCSCR_TIE;
-		serial_port_out(port, SCSCR, ctrl);
-	}
 }
 
 /* On SH3, SCIF may read end-of-break as a space->mark char */

