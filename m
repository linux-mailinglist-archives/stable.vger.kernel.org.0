Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEAB5505BC6
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 17:47:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344408AbiDRPts (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 11:49:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345661AbiDRPtk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 11:49:40 -0400
Received: from angie.orcam.me.uk (angie.orcam.me.uk [IPv6:2001:4190:8020::34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 925323DA60;
        Mon, 18 Apr 2022 08:27:11 -0700 (PDT)
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id 10B2E92009E; Mon, 18 Apr 2022 17:27:11 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id 09A8292009C;
        Mon, 18 Apr 2022 16:27:11 +0100 (BST)
Date:   Mon, 18 Apr 2022 16:27:10 +0100 (BST)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>
cc:     Andy Shevchenko <andy.shevchenko@gmail.com>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH v5 1/5] serial: 8250: Also set sticky MCR bits in console
 restoration
In-Reply-To: <alpine.DEB.2.21.2204181506000.9383@angie.orcam.me.uk>
Message-ID: <alpine.DEB.2.21.2204181518490.9383@angie.orcam.me.uk>
References: <alpine.DEB.2.21.2204181506000.9383@angie.orcam.me.uk>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Sticky MCR bits are lost in console restoration if console suspending 
has been disabled.  This currently affects the AFE bit, which works in 
combination with RTS which we set, so we want to make sure the UART 
retains control of its FIFO where previously requested.  Also specific 
drivers may need other bits in the future.

Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
Fixes: 4516d50aabed ("serial: 8250: Use canary to restart console after suspend")
Cc: stable@vger.kernel.org # v4.0+
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
---
Changes from v4:

- Reorder as 1/5 (from 4/5).

New change in v4, factored out from 5/5.
---
 drivers/tty/serial/8250/8250_port.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

linux-serial-8250-mcr-restore.diff
Index: linux-macro/drivers/tty/serial/8250/8250_port.c
===================================================================
--- linux-macro.orig/drivers/tty/serial/8250/8250_port.c
+++ linux-macro/drivers/tty/serial/8250/8250_port.c
@@ -3308,7 +3308,7 @@ static void serial8250_console_restore(s
 
 	serial8250_set_divisor(port, baud, quot, frac);
 	serial_port_out(port, UART_LCR, up->lcr);
-	serial8250_out_MCR(up, UART_MCR_DTR | UART_MCR_RTS);
+	serial8250_out_MCR(up, up->mcr | UART_MCR_DTR | UART_MCR_RTS);
 }
 
 /*
