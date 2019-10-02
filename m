Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D60C0C91E2
	for <lists+stable@lfdr.de>; Wed,  2 Oct 2019 21:15:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729301AbfJBTMT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Oct 2019 15:12:19 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35478 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729155AbfJBTIK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Oct 2019 15:08:10 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iFjyn-00035Q-LB; Wed, 02 Oct 2019 20:08:05 +0100
Received: from ben by deadeye with local (Exim 4.92.1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iFjyn-0003ak-5j; Wed, 02 Oct 2019 20:08:05 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Michael Rodin" <mrodin@de.adit-jv.com>,
        "Wolfram Sang" <wsa+renesas@sang-engineering.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "George G. Davis" <george_davis@mentor.com>,
        "Geert Uytterhoeven" <geert+renesas@glider.be>,
        "Simon Horman" <horms+renesas@verge.net.au>,
        "Eugeniu Rosca" <erosca@de.adit-jv.com>
Date:   Wed, 02 Oct 2019 20:06:51 +0100
Message-ID: <lsq.1570043211.904590300@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 12/87] serial: sh-sci: disable DMA for uart_console
In-Reply-To: <lsq.1570043210.379046399@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.75-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: "George G. Davis" <george_davis@mentor.com>

commit 099506cbbc79c0bd52b19cb6b930f256dabc3950 upstream.

As noted in commit 84b40e3b57ee ("serial: 8250: omap: Disable DMA for
console UART"), UART console lines use low-level PIO only access functions
which will conflict with use of the line when DMA is enabled, e.g. when
the console line is also used for systemd messages. So disable DMA
support for UART console lines.

Reported-by: Michael Rodin <mrodin@de.adit-jv.com>
Link: https://patchwork.kernel.org/patch/10929511/
Tested-by: Eugeniu Rosca <erosca@de.adit-jv.com>
Reviewed-by: Simon Horman <horms+renesas@verge.net.au>
Reviewed-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: George G. Davis <george_davis@mentor.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/tty/serial/sh-sci.c | 7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/tty/serial/sh-sci.c
+++ b/drivers/tty/serial/sh-sci.c
@@ -1600,6 +1600,13 @@ static void sci_request_dma(struct uart_
 
 	dev_dbg(port->dev, "%s: port %d\n", __func__, port->line);
 
+	/*
+	 * DMA on console may interfere with Kernel log messages which use
+	 * plain putchar(). So, simply don't use it with a console.
+	 */
+	if (uart_console(port))
+		return;
+
 	if (s->cfg->dma_slave_tx <= 0 || s->cfg->dma_slave_rx <= 0)
 		return;
 

