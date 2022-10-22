Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E60C7608858
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:16:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233279AbiJVIQh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:16:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233237AbiJVIML (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:12:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B4322C10A;
        Sat, 22 Oct 2022 00:54:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6D8E4B82E10;
        Sat, 22 Oct 2022 07:54:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAD68C433C1;
        Sat, 22 Oct 2022 07:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666425277;
        bh=JriGQH2ZerNgXXSQ2NT+nwSDaZwwrAgrAf1yrFYB7KA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hbZ9AgHf8h7gJGcMssOvw+UU+kjNN9WMNuav20md8I92oGQ3WmBZ2mF1dVf/P06Zh
         5PYFTBM7l6toYD3Ud1Daihu5irqZQp1PBdusAn+Pi3yhMxmJg6TXdNzSPlKUtuw1Xe
         WU2Z6Ar6bLSNhTtlxgQ3ispRNt3gmGT5gje+RR/c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lennert Buytenhek <buytenh@arista.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 448/717] serial: 8250: Toggle IER bits on only after irq has been set up
Date:   Sat, 22 Oct 2022 09:25:27 +0200
Message-Id: <20221022072518.088368896@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 82726cda6066..f05544e93eae 100644
--- a/drivers/tty/serial/8250/8250_core.c
+++ b/drivers/tty/serial/8250/8250_core.c
@@ -298,10 +298,9 @@ static void serial8250_backup_timeout(struct timer_list *t)
 		jiffies + uart_poll_timeout(&up->port) + HZ / 5);
 }
 
-static int univ8250_setup_irq(struct uart_8250_port *up)
+static void univ8250_setup_timer(struct uart_8250_port *up)
 {
 	struct uart_port *port = &up->port;
-	int retval = 0;
 
 	/*
 	 * The above check will only give an accurate result the first time
@@ -322,10 +321,16 @@ static int univ8250_setup_irq(struct uart_8250_port *up)
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
@@ -381,6 +386,7 @@ static struct uart_ops univ8250_port_ops;
 static const struct uart_8250_ops univ8250_driver_ops = {
 	.setup_irq	= univ8250_setup_irq,
 	.release_irq	= univ8250_release_irq,
+	.setup_timer	= univ8250_setup_timer,
 };
 
 static struct uart_8250_port serial8250_ports[UART_NR];
diff --git a/drivers/tty/serial/8250/8250_port.c b/drivers/tty/serial/8250/8250_port.c
index 5db53941d881..d5f9b56fdbab 100644
--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -2303,6 +2303,10 @@ int serial8250_do_startup(struct uart_port *port)
 	if (port->irq && (up->port.flags & UPF_SHARE_IRQ))
 		up->port.irqflags |= IRQF_SHARED;
 
+	retval = up->ops->setup_irq(up);
+	if (retval)
+		goto out;
+
 	if (port->irq && !(up->port.flags & UPF_NO_THRE_TEST)) {
 		unsigned char iir1;
 
@@ -2345,9 +2349,7 @@ int serial8250_do_startup(struct uart_port *port)
 		}
 	}
 
-	retval = up->ops->setup_irq(up);
-	if (retval)
-		goto out;
+	up->ops->setup_timer(up);
 
 	/*
 	 * Now, initialize the UART
diff --git a/include/linux/serial_8250.h b/include/linux/serial_8250.h
index ff84a3ed10ea..b0183e90fe90 100644
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



