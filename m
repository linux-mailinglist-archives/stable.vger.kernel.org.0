Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA7095BB7A6
	for <lists+stable@lfdr.de>; Sat, 17 Sep 2022 12:07:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbiIQKH3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Sep 2022 06:07:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiIQKHY (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Sep 2022 06:07:24 -0400
Received: from angie.orcam.me.uk (angie.orcam.me.uk [IPv6:2001:4190:8020::34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1ED5B357DB;
        Sat, 17 Sep 2022 03:07:24 -0700 (PDT)
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id 5FE7492009D; Sat, 17 Sep 2022 12:07:23 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id 58E8892009B;
        Sat, 17 Sep 2022 11:07:23 +0100 (BST)
Date:   Sat, 17 Sep 2022 11:07:23 +0100 (BST)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>
cc:     Josh Triplett <josh@joshtriplett.org>,
        Anders Blomdell <anders.blomdell@control.lth.se>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH 1/2] serial: 8250: Let drivers request full 16550A feature
 probing
In-Reply-To: <alpine.DEB.2.21.2209162317180.19473@angie.orcam.me.uk>
Message-ID: <alpine.DEB.2.21.2209171043270.31781@angie.orcam.me.uk>
References: <alpine.DEB.2.21.2209162317180.19473@angie.orcam.me.uk>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A SERIAL_8250_16550A_VARIANTS configuration option has been recently 
defined that lets one request the 8250 driver not to probe for 16550A 
device features so as to reduce the driver's device startup time in 
virtual machines.

Some actual hardware devices require these features to have been fully 
determined however for their driver to work correctly, so define a flag 
to let drivers request full 16550A feature probing on a device-by-device 
basis if required regardless of the SERIAL_8250_16550A_VARIANTS option 
setting chosen.

Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
Reported-by: Anders Blomdell <anders.blomdell@control.lth.se>
Fixes: dc56ecb81a0a ("serial: 8250: Support disabling mdelay-filled probes of 16550A variants")
Cc: stable@vger.kernel.org # v5.6+
---
 drivers/tty/serial/8250/8250_port.c |    3 ++-
 include/linux/serial_core.h         |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

linux-serial-8250-full-probe.diff
Index: linux-macro/drivers/tty/serial/8250/8250_port.c
===================================================================
--- linux-macro.orig/drivers/tty/serial/8250/8250_port.c
+++ linux-macro/drivers/tty/serial/8250/8250_port.c
@@ -1021,7 +1021,8 @@ static void autoconfig_16550a(struct uar
 	up->port.type = PORT_16550A;
 	up->capabilities |= UART_CAP_FIFO;
 
-	if (!IS_ENABLED(CONFIG_SERIAL_8250_16550A_VARIANTS))
+	if (!IS_ENABLED(CONFIG_SERIAL_8250_16550A_VARIANTS) &&
+	    !(up->port.flags & UPF_FULL_PROBE))
 		return;
 
 	/*
Index: linux-macro/include/linux/serial_core.h
===================================================================
--- linux-macro.orig/include/linux/serial_core.h
+++ linux-macro/include/linux/serial_core.h
@@ -414,7 +414,7 @@ struct uart_icount {
 	__u32	buf_overrun;
 };
 
-typedef unsigned int __bitwise upf_t;
+typedef __u64 __bitwise upf_t;
 typedef unsigned int __bitwise upstat_t;
 
 struct uart_port {
@@ -522,6 +522,7 @@ struct uart_port {
 #define UPF_FIXED_PORT		((__force upf_t) (1 << 29))
 #define UPF_DEAD		((__force upf_t) (1 << 30))
 #define UPF_IOREMAP		((__force upf_t) (1 << 31))
+#define UPF_FULL_PROBE		((__force upf_t) (1ULL << 32))
 
 #define __UPF_CHANGE_MASK	0x17fff
 #define UPF_CHANGE_MASK		((__force upf_t) __UPF_CHANGE_MASK)
