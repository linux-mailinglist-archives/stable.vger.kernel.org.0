Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E9E95BF15C
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 01:41:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231584AbiITXlW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Sep 2022 19:41:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231578AbiITXlF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Sep 2022 19:41:05 -0400
Received: from angie.orcam.me.uk (angie.orcam.me.uk [78.133.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C20007C76D;
        Tue, 20 Sep 2022 16:38:19 -0700 (PDT)
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id BBF0292009E; Wed, 21 Sep 2022 01:35:37 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id B644892009B;
        Wed, 21 Sep 2022 00:35:37 +0100 (BST)
Date:   Wed, 21 Sep 2022 00:35:37 +0100 (BST)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>
cc:     Josh Triplett <josh@joshtriplett.org>,
        Anders Blomdell <anders.blomdell@control.lth.se>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH v2 2/3] serial: 8250: Request full 16550A feature probing
 for OxSemi PCIe devices
In-Reply-To: <alpine.DEB.2.21.2209201659350.41633@angie.orcam.me.uk>
Message-ID: <alpine.DEB.2.21.2209210005040.41633@angie.orcam.me.uk>
References: <alpine.DEB.2.21.2209201659350.41633@angie.orcam.me.uk>
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

Oxford Semiconductor PCIe (Tornado) 950 serial port devices need to 
operate in the enhanced mode via the EFR register for the Divide-by-M 
N/8 baud rate generator prescaler to be used in their native UART mode.  
Otherwise the prescaler is fixed at 1 causing grossly incorrect baud 
rates to be programmed.

Accessing the EFR register requires 16550A features to have been probed 
for, so request this to happen regardless of SERIAL_8250_16550A_VARIANTS 
by setting UPF_FULL_PROBE in port flags.

Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
Reported-by: Anders Blomdell <anders.blomdell@control.lth.se>
Fixes: 366f6c955d4d ("serial: 8250: Add proper clock handling for OxSemi PCIe devices")
Cc: stable@vger.kernel.org # v5.19+
---
No change from v1.
---
 drivers/tty/serial/8250/8250_pci.c |    5 +++++
 1 file changed, 5 insertions(+)

linux-serial-8250-oxsemi-efr.diff
Index: linux-macro/drivers/tty/serial/8250/8250_pci.c
===================================================================
--- linux-macro.orig/drivers/tty/serial/8250/8250_pci.c
+++ linux-macro/drivers/tty/serial/8250/8250_pci.c
@@ -1232,6 +1232,10 @@ static void pci_oxsemi_tornado_set_mctrl
 	serial8250_do_set_mctrl(port, mctrl);
 }
 
+/*
+ * We require EFR features for clock programming, so set UPF_FULL_PROBE
+ * for full probing regardless of CONFIG_SERIAL_8250_16550A_VARIANTS setting.
+ */
 static int pci_oxsemi_tornado_setup(struct serial_private *priv,
 				    const struct pciserial_board *board,
 				    struct uart_8250_port *up, int idx)
@@ -1239,6 +1243,7 @@ static int pci_oxsemi_tornado_setup(stru
 	struct pci_dev *dev = priv->dev;
 
 	if (pci_oxsemi_tornado_p(dev)) {
+		up->port.flags |= UPF_FULL_PROBE;
 		up->port.get_divisor = pci_oxsemi_tornado_get_divisor;
 		up->port.set_divisor = pci_oxsemi_tornado_set_divisor;
 		up->port.set_mctrl = pci_oxsemi_tornado_set_mctrl;
