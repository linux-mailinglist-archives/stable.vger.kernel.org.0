Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCDB8259792
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 18:16:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729282AbgIAQPi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 12:15:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:39798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729232AbgIAPel (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:34:41 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1017F205F4;
        Tue,  1 Sep 2020 15:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974480;
        bh=2zFgQ/EK2UjnFNqLNvQO5Li4cdQ+2xUr2yjlL79tAYc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y0jb/4Y/m5Upi3IqoM3dpClmi28Ra6ZuYXBlotuDnjQIIAOjLQopbmMz5/GRTDnkU
         Uj4FIVCOdwGrl4qto0Gvk+tPn69JiuqI/U76rSxKMtNiRIytms8RExGst3Vnjr/zXi
         kUX3+zXL+w4OBflyDa7kgI2scSb11zcjiqN9CDhc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Wunner <lukas@wunner.de>,
        Aleksey Makarov <amakarov@marvell.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Russell King <linux@armlinux.org.uk>,
        Christopher Covington <cov@codeaurora.org>
Subject: [PATCH 5.4 162/214] serial: pl011: Fix oops on -EPROBE_DEFER
Date:   Tue,  1 Sep 2020 17:10:42 +0200
Message-Id: <20200901151000.735976266@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150952.963606936@linuxfoundation.org>
References: <20200901150952.963606936@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Wunner <lukas@wunner.de>

commit 27afac93e3bd7fa89749cf11da5d86ac9cde4dba upstream.

If probing of a pl011 gets deferred until after free_initmem(), an oops
ensues because pl011_console_match() is called which has been freed.

Fix by removing the __init attribute from the function and those it
calls.

Commit 10879ae5f12e ("serial: pl011: add console matching function")
introduced pl011_console_match() not just for early consoles but
regular preferred consoles, such as those added by acpi_parse_spcr().
Regular consoles may be registered after free_initmem() for various
reasons, one being deferred probing, another being dynamic enablement
of serial ports using a DeviceTree overlay.

Thus, pl011_console_match() must not be declared __init and the
functions it calls mustn't either.

Stack trace for posterity:

Unable to handle kernel paging request at virtual address 80c38b58
Internal error: Oops: 8000000d [#1] PREEMPT SMP ARM
PC is at pl011_console_match+0x0/0xfc
LR is at register_console+0x150/0x468
[<80187004>] (register_console)
[<805a8184>] (uart_add_one_port)
[<805b2b68>] (pl011_register_port)
[<805b3ce4>] (pl011_probe)
[<80569214>] (amba_probe)
[<805ca088>] (really_probe)
[<805ca2ec>] (driver_probe_device)
[<805ca5b0>] (__device_attach_driver)
[<805c8060>] (bus_for_each_drv)
[<805c9dfc>] (__device_attach)
[<805ca630>] (device_initial_probe)
[<805c90a8>] (bus_probe_device)
[<805c95a8>] (deferred_probe_work_func)

Fixes: 10879ae5f12e ("serial: pl011: add console matching function")
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: stable@vger.kernel.org # v4.10+
Cc: Aleksey Makarov <amakarov@marvell.com>
Cc: Peter Hurley <peter@hurleysoftware.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Christopher Covington <cov@codeaurora.org>
Link: https://lore.kernel.org/r/f827ff09da55b8c57d316a1b008a137677b58921.1597315557.git.lukas@wunner.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/amba-pl011.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -2252,9 +2252,8 @@ pl011_console_write(struct console *co,
 	clk_disable(uap->clk);
 }
 
-static void __init
-pl011_console_get_options(struct uart_amba_port *uap, int *baud,
-			     int *parity, int *bits)
+static void pl011_console_get_options(struct uart_amba_port *uap, int *baud,
+				      int *parity, int *bits)
 {
 	if (pl011_read(uap, REG_CR) & UART01x_CR_UARTEN) {
 		unsigned int lcr_h, ibrd, fbrd;
@@ -2287,7 +2286,7 @@ pl011_console_get_options(struct uart_am
 	}
 }
 
-static int __init pl011_console_setup(struct console *co, char *options)
+static int pl011_console_setup(struct console *co, char *options)
 {
 	struct uart_amba_port *uap;
 	int baud = 38400;
@@ -2355,8 +2354,8 @@ static int __init pl011_console_setup(st
  *
  *	Returns 0 if console matches; otherwise non-zero to use default matching
  */
-static int __init pl011_console_match(struct console *co, char *name, int idx,
-				      char *options)
+static int pl011_console_match(struct console *co, char *name, int idx,
+			       char *options)
 {
 	unsigned char iotype;
 	resource_size_t addr;


