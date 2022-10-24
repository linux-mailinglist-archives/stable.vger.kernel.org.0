Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A01660A9A5
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 15:23:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234729AbiJXNXh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 09:23:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233006AbiJXNWx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 09:22:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E5D53B460;
        Mon, 24 Oct 2022 05:30:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1F392612CF;
        Mon, 24 Oct 2022 12:26:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 320F2C433D6;
        Mon, 24 Oct 2022 12:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666614376;
        bh=9SE63E0V05/nB5l+e4Iv+eiMc19/AbJJynH7bXQ/Obs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TDvvODlYgMjwrhgl9Gk9YNDnpCsHEH63DfuG9VcuSvqbKgbvSVZa5WNQ0AL/wM+77
         Alp9Wz42BtTIDUd7VSODh9BmaxBEs8ard/meXglY6Rk5BDX8nH3B2+HTKO+v3vzPwU
         5fi5pTZAkv3AsxNIQ/xv2xUsE8J0myLOzxqSkhp8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lennert Buytenhek <buytenh@arista.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 237/390] serial: 8250: Toggle IER bits on only after irq has been set up
Date:   Mon, 24 Oct 2022 13:30:34 +0200
Message-Id: <20221024113032.886503141@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113022.510008560@linuxfoundation.org>
References: <20221024113022.510008560@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

[ Upstream commit 039d4926379b1d1c17b51cf21c500a5eed86899e ]

Invoking TIOCVHANGUP on 8250_mid port on Ice Lake-D and then reopening
the port triggers these faults during serial8250_do_startup():

  DMAR: DRHD: handling fault status reg 3
  DMAR: [DMA Write NO_PASID] Request device [00:1a.0] fault addr 0x0 [fault reason 0x05] PTE Write access is not set

If the IRQ hasn't been set up yet, the UART will have zeroes in its MSI
address/data registers. Disabling the IRQ at the interrupt controller
won't stop the UART from performing a DMA write to the address programmed
in its MSI address register (zero) when it wants to signal an interrupt.

The UARTs (in Ice Lake-D) implement PCI 2.1 style MSI without masking
capability, so there is no way to mask the interrupt at the source PCI
function level, except disabling the MSI capability entirely, but that
would cause it to fall back to INTx# assertion, and the PCI specification
prohibits disabling the MSI capability as a way to mask a function's
interrupt service request.

The MSI address register is zeroed by the hangup as the irq is freed.
The interrupt is signalled during serial8250_do_startup() performing a
THRE test that temporarily toggles THRI in IER. The THRE test currently
occurs before UART's irq (and MSI address) is properly set up.

Refactor serial8250_do_startup() such that irq is set up before the
THRE test. The current irq setup code is intermixed with the timer
setup code. As THRE test must be performed prior to the timer setup,
extract it into own function and call it only after the THRE test.

The ->setup_timer() needs to be part of the struct uart_8250_ops in
order to not create circular dependency between 8250 and 8250_base
modules.

Fixes: 40b36daad0ac ("[PATCH] 8250 UART backup timer")
Reported-by: Lennert Buytenhek <buytenh@arista.com>
Tested-by: Lennert Buytenhek <buytenh@arista.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://lore.kernel.org/r/20220922070005.2965-1-ilpo.jarvinen@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_core.c | 16 +++++++++++-----
 drivers/tty/serial/8250/8250_port.c |  8 +++++---
 include/linux/serial_8250.h         |  1 +
 3 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/8250_core.c
index aae9d26ce4f4..0a7e9491b4d1 100644
--- a/drivers/tty/serial/8250/8250_core.c
+++ b/drivers/tty/serial/8250/8250_core.c
@@ -310,10 +310,9 @@ static void serial8250_backup_timeout(struct timer_list *t)
 		jiffies + uart_poll_timeout(&up->port) + HZ / 5);
 }
 
-static int univ8250_setup_irq(struct uart_8250_port *up)
+static void univ8250_setup_timer(struct uart_8250_port *up)
 {
 	struct uart_port *port = &up->port;
-	int retval = 0;
 
 	/*
 	 * The above check will only give an accurate result the first time
@@ -334,10 +333,16 @@ static int univ8250_setup_irq(struct uart_8250_port *up)
 	 */
 	if (!port->irq)
 		mod_timer(&up->timer, jiffies + uart_poll_timeout(port));
-	else
-		retval = serial_link_irq_chain(up);
+}
 
-	return retval;
+static int univ8250_setup_irq(struct uart_8250_port *up)
+{
+	struct uart_port *port = &up->port;
+
+	if (port->irq)
+		return serial_link_irq_chain(up);
+
+	return 0;
 }
 
 static void univ8250_release_irq(struct uart_8250_port *up)
@@ -393,6 +398,7 @@ static struct uart_ops univ8250_port_ops;
 static const struct uart_8250_ops univ8250_driver_ops = {
 	.setup_irq	= univ8250_setup_irq,
 	.release_irq	= univ8250_release_irq,
+	.setup_timer	= univ8250_setup_timer,
 };
 
 static struct uart_8250_port serial8250_ports[UART_NR];
diff --git a/drivers/tty/serial/8250/8250_port.c b/drivers/tty/serial/8250/8250_port.c
index 6de188b121d7..4a0793e1ba61 100644
--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -2277,6 +2277,10 @@ int serial8250_do_startup(struct uart_port *port)
 	if (port->irq && (up->port.flags & UPF_SHARE_IRQ))
 		up->port.irqflags |= IRQF_SHARED;
 
+	retval = up->ops->setup_irq(up);
+	if (retval)
+		goto out;
+
 	if (port->irq && !(up->port.flags & UPF_NO_THRE_TEST)) {
 		unsigned char iir1;
 
@@ -2319,9 +2323,7 @@ int serial8250_do_startup(struct uart_port *port)
 		}
 	}
 
-	retval = up->ops->setup_irq(up);
-	if (retval)
-		goto out;
+	up->ops->setup_timer(up);
 
 	/*
 	 * Now, initialize the UART
diff --git a/include/linux/serial_8250.h b/include/linux/serial_8250.h
index 2b70f736b091..92f3b778d8c2 100644
--- a/include/linux/serial_8250.h
+++ b/include/linux/serial_8250.h
@@ -74,6 +74,7 @@ struct uart_8250_port;
 struct uart_8250_ops {
 	int		(*setup_irq)(struct uart_8250_port *);
 	void		(*release_irq)(struct uart_8250_port *);
+	void		(*setup_timer)(struct uart_8250_port *);
 };
 
 struct uart_8250_em485 {
-- 
2.35.1



