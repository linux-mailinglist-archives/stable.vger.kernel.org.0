Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 944AC579CF2
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:46:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241492AbiGSMqD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:46:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241629AbiGSMpb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:45:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB3A58AB04;
        Tue, 19 Jul 2022 05:18:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3984061746;
        Tue, 19 Jul 2022 12:18:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B03FC341CE;
        Tue, 19 Jul 2022 12:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233079;
        bh=EzMbJ/79Gfem+Qi5Q99AdsP/OjJm7cgbuH+Ln4CrI84=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W09wMSeJg9gK2fXsG88iE71N6C2mODGtqOqL7jkLxceD5hbf8l2ZMUp+wEwUqvziD
         Oa+4G3gaMC/y7m1c/Fy4/gR7KrX4giLWM4Dh7QOPN74HOfbDpH6VRAWaemJc3ciQQ2
         H3DARJS1/18WUMd/9NAy0wQ5xg8o4Szul5xHh/bc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable <stable@kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 5.15 166/167] serial: 8250: Fix PM usage_count for console handover
Date:   Tue, 19 Jul 2022 13:54:58 +0200
Message-Id: <20220719114712.518528832@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114656.750574879@linuxfoundation.org>
References: <20220719114656.750574879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

commit f9b11229b79c0fb2100b5bb4628a101b1d37fbf6 upstream.

When console is enabled, univ8250_console_setup() calls
serial8250_console_setup() before .dev is set to uart_port. Therefore,
it will not call pm_runtime_get_sync(). Later, when the actual driver
is going to take over univ8250_console_exit() is called. As .dev is
already set, serial8250_console_exit() makes pm_runtime_put_sync() call
with usage count being zero triggering PM usage count warning
(extra debug for univ8250_console_setup(), univ8250_console_exit(), and
serial8250_register_ports()):

[    0.068987] univ8250_console_setup ttyS0 nodev
[    0.499670] printk: console [ttyS0] enabled
[    0.717955] printk: console [ttyS0] printing thread started
[    1.960163] serial8250_register_ports assigned dev for ttyS0
[    1.976830] printk: console [ttyS0] disabled
[    1.976888] printk: console [ttyS0] printing thread stopped
[    1.977073] univ8250_console_exit ttyS0 usage:0
[    1.977075] serial8250 serial8250: Runtime PM usage count underflow!
[    1.977429] dw-apb-uart.6: ttyS0 at MMIO 0x4010006000 (irq = 33, base_baud = 115200) is a 16550A
[    1.977812] univ8250_console_setup ttyS0 usage:2
[    1.978167] printk: console [ttyS0] printing thread started
[    1.978203] printk: console [ttyS0] enabled

To fix the issue, call pm_runtime_get_sync() in
serial8250_register_ports() as soon as .dev is set for an uart_port
if it has console enabled.

This problem became apparent only recently because 82586a721595 ("PM:
runtime: Avoid device usage count underflows") added the warning
printout. I confirmed this problem also occurs with v5.18 (w/o the
warning printout, obviously).

Fixes: bedb404e91bb ("serial: 8250_port: Don't use power management for kernel console")
Cc: stable <stable@kernel.org>
Tested-by: Tony Lindgren <tony@atomide.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://lore.kernel.org/r/b4f428e9-491f-daf2-2232-819928dc276e@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_core.c |    4 ++++
 drivers/tty/serial/serial_core.c    |    5 -----
 include/linux/serial_core.h         |    5 +++++
 3 files changed, 9 insertions(+), 5 deletions(-)

--- a/drivers/tty/serial/8250/8250_core.c
+++ b/drivers/tty/serial/8250/8250_core.c
@@ -23,6 +23,7 @@
 #include <linux/sysrq.h>
 #include <linux/delay.h>
 #include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
 #include <linux/tty.h>
 #include <linux/ratelimit.h>
 #include <linux/tty_flip.h>
@@ -561,6 +562,9 @@ serial8250_register_ports(struct uart_dr
 
 		up->port.dev = dev;
 
+		if (uart_console_enabled(&up->port))
+			pm_runtime_get_sync(up->port.dev);
+
 		serial8250_apply_quirks(up);
 		uart_add_one_port(drv, &up->port);
 	}
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -1912,11 +1912,6 @@ static int uart_proc_show(struct seq_fil
 }
 #endif
 
-static inline bool uart_console_enabled(struct uart_port *port)
-{
-	return uart_console(port) && (port->cons->flags & CON_ENABLED);
-}
-
 static void uart_port_spin_lock_init(struct uart_port *port)
 {
 	spin_lock_init(&port->lock);
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -388,6 +388,11 @@ static const bool earlycon_acpi_spcr_ena
 static inline int setup_earlycon(char *buf) { return 0; }
 #endif
 
+static inline bool uart_console_enabled(struct uart_port *port)
+{
+	return uart_console(port) && (port->cons->flags & CON_ENABLED);
+}
+
 struct uart_port *uart_get_console(struct uart_port *ports, int nr,
 				   struct console *c);
 int uart_parse_earlycon(char *p, unsigned char *iotype, resource_size_t *addr,


