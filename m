Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3650B22F07B
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:25:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732345AbgG0OY7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:24:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:54642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732337AbgG0OYz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:24:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6936F208E4;
        Mon, 27 Jul 2020 14:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859894;
        bh=9IPoUjIl9rYUQoHwrqTKJT7UCqyqqU4r75Elw+Qpxr8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=veIWri0MyObFTt9IfVdo6PFq2pwYN89p2y4plQ2RMTI9d7MDdwBNvAuMkTeLY5IwS
         6lFzvt2xLMbHodjU5PQhZwvONa2HyWRWk7PdH7ws1ltYHXoOJkz2csnKmqetx44TR8
         hjmfE4QoJOfUWIbJmmHupo2bVn5xwza2nxVOVdug=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>,
        Jan Kiszka <jan.kiszka@web.de>,
        Helmut Grohne <helmut.grohne@intenta.de>
Subject: [PATCH 5.7 145/179] tty: xilinx_uartps: Really fix id assignment
Date:   Mon, 27 Jul 2020 16:05:20 +0200
Message-Id: <20200727134939.735741726@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134932.659499757@linuxfoundation.org>
References: <20200727134932.659499757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Helmut Grohne <helmut.grohne@intenta.de>

commit 22a82fa7d6c3e16d56a036b1fa697a39b954adf0 upstream.

The problems started with the revert (18cc7ac8a28e28). The
cdns_uart_console.index is statically assigned -1. When the port is
registered, Linux assigns consecutive numbers to it. It turned out that
when using ttyPS1 as console, the index is not updated as we are reusing
the same cdns_uart_console instance for multiple ports. When registering
ttyPS0, it gets updated from -1 to 0, but when registering ttyPS1, it
already is 0 and not updated.

That led to 2ae11c46d5fdc4. It assigns the index prior to registering
the uart_driver once. Unfortunately, that ended up breaking the
situation where the probe order does not match the id order. When using
the same device tree for both uboot and linux, it is important that the
serial0 alias points to the console. So some boards reverse those
aliases. This was reported by Jan Kiszka. The proposed fix was reverting
the index assignment and going back to the previous iteration.

However such a reversed assignement (serial0 -> uart1, serial1 -> uart0)
was already partially broken by the revert (18cc7ac8a28e28). While the
ttyPS device works, the kmsg connection is already broken and kernel
messages go missing. Reverting the id assignment does not fix this.

>From the xilinx_uartps driver pov (after reverting the refactoring
commits), there can be only one console. This manifests in static
variables console_pprt and cdns_uart_console. These variables are not
properly linked and can go out of sync. The cdns_uart_console.index is
important for uart_add_one_port. We call that function for each port -
one of which hopefully is the console. If it isn't, the CON_ENABLED flag
is not set and console_port is cleared. The next cdns_uart_probe call
then tries to register the next port using that same cdns_uart_console.

It is important that console_port and cdns_uart_console (and its index
in particular) stay in sync. The index assignment implemented by
Shubhrajyoti Datta is correct in principle. It just may have to happen a
second time if the first cdns_uart_probe call didn't encounter the
console device. And we shouldn't change the index once the console uart
is registered.

Reported-by: Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>
Reported-by: Jan Kiszka <jan.kiszka@web.de>
Link: https://lore.kernel.org/linux-serial/f4092727-d8f5-5f91-2c9f-76643aace993@siemens.com/
Fixes: 18cc7ac8a28e28 ("Revert "serial: uartps: Register own uart console and driver structures"")
Fixes: 2ae11c46d5fdc4 ("tty: xilinx_uartps: Fix missing id assignment to the console")
Fixes: 76ed2e10579671 ("Revert "tty: xilinx_uartps: Fix missing id assignment to the console"")
Signed-off-by: Helmut Grohne <helmut.grohne@intenta.de>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200713073227.GA3805@laureti-dev
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/xilinx_uartps.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/tty/serial/xilinx_uartps.c
+++ b/drivers/tty/serial/xilinx_uartps.c
@@ -1574,8 +1574,10 @@ static int cdns_uart_probe(struct platfo
 	 * If register_console() don't assign value, then console_port pointer
 	 * is cleanup.
 	 */
-	if (!console_port)
+	if (!console_port) {
+		cdns_uart_console.index = id;
 		console_port = port;
+	}
 #endif
 
 	rc = uart_add_one_port(&cdns_uart_uart_driver, port);
@@ -1588,8 +1590,10 @@ static int cdns_uart_probe(struct platfo
 #ifdef CONFIG_SERIAL_XILINX_PS_UART_CONSOLE
 	/* This is not port which is used for console that's why clean it up */
 	if (console_port == port &&
-	    !(cdns_uart_uart_driver.cons->flags & CON_ENABLED))
+	    !(cdns_uart_uart_driver.cons->flags & CON_ENABLED)) {
 		console_port = NULL;
+		cdns_uart_console.index = -1;
+	}
 #endif
 
 	cdns_uart_data->cts_override = of_property_read_bool(pdev->dev.of_node,


