Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDD541E722
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 05:29:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726279AbfEOD3y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 May 2019 23:29:54 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:61222 "EHLO
        relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726201AbfEOD3y (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 May 2019 23:29:54 -0400
Received: from svr-orw-mbx-01.mgc.mentorg.com ([147.34.90.201])
        by relay1.mentorg.com with esmtps (TLSv1.2:ECDHE-RSA-AES256-SHA384:256)
        id 1hQkbw-0006UV-Ol from George_Davis@mentor.com ; Tue, 14 May 2019 20:29:44 -0700
Received: from localhost (147.34.91.1) by svr-orw-mbx-01.mgc.mentorg.com
 (147.34.90.201) with Microsoft SMTP Server (TLS) id 15.0.1320.4; Tue, 14 May
 2019 20:29:42 -0700
From:   "George G. Davis" <george_davis@mentor.com>
To:     Eugeniu Rosca <erosca@de.adit-jv.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Simon Horman <horms+renesas@verge.net.au>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.com>,
        "open list:SERIAL DRIVERS" <linux-serial@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
CC:     Chris Brandt <chris.brandt@renesas.com>,
        Ulrich Hecht <ulrich.hecht+renesas@gmail.com>,
        Andy Lowe <andy_lowe@mentor.com>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS 
        <devicetree@vger.kernel.org>, Magnus Damm <magnus.damm@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "George G. Davis" <george_davis@mentor.com>,
        <stable@vger.kernel.org>
Subject: [PATCH v3] serial: sh-sci: disable DMA for uart_console
Date:   Tue, 14 May 2019 23:29:34 -0400
Message-ID: <1557890974-21179-1-git-send-email-george_davis@mentor.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: SVR-ORW-MBX-09.mgc.mentorg.com (147.34.90.209) To
 svr-orw-mbx-01.mgc.mentorg.com (147.34.90.201)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Cc: stable@vger.kernel.org
Signed-off-by: George G. Davis <george_davis@mentor.com>
---
v2: Clarify comment regarding DMA support on kernel console,
    add {Tested,Reviewed}-by:, and Cc: linux-stable lines.
v3: Change Fixes: reference to Link: reference and add another Reviewed-by.
---
 drivers/tty/serial/sh-sci.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/tty/serial/sh-sci.c b/drivers/tty/serial/sh-sci.c
index 3cd139752d3f..abc705716aa0 100644
--- a/drivers/tty/serial/sh-sci.c
+++ b/drivers/tty/serial/sh-sci.c
@@ -1557,6 +1557,13 @@ static void sci_request_dma(struct uart_port *port)
 
 	dev_dbg(port->dev, "%s: port %d\n", __func__, port->line);
 
+	/*
+	 * DMA on console may interfere with Kernel log messages which use
+	 * plain putchar(). So, simply don't use it with a console.
+	 */
+	if (uart_console(port))
+		return;
+
 	if (!port->dev->of_node)
 		return;
 
-- 
2.7.4

