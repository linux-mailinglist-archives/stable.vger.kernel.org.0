Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3CBC3E804E
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:47:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232604AbhHJRr7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:47:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:50910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235730AbhHJRqD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:46:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6D27561251;
        Tue, 10 Aug 2021 17:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617222;
        bh=s0g1xmmZwpz0X/vZ9KJFPr4XM+vbvQa7yuAIxalVp1c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jo+Hz9igLqy9jYSDQUhHcIPPZMaai2VHVHQCRUYwTfFWxbtMH1h1pstrHT6xtJBzx
         4AVGWLpecIZehYqgkGaJjp8IOSKdRSE7b2j47vJLQ1KifEbc+hlJkGN7spfWq3wTTP
         mctD5Y1lP3WSdaOmK8Eeyz+V/LcZmZy5I2LYyt/k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ralf Ramsauer <ralf.ramsauer@oth-regensburg.de>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Mario Kleiner <mario.kleiner.de@gmail.com>
Subject: [PATCH 5.10 099/135] serial: 8250_pci: Avoid irq sharing for MSI(-X) interrupts.
Date:   Tue, 10 Aug 2021 19:30:33 +0200
Message-Id: <20210810172959.123092016@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172955.660225700@linuxfoundation.org>
References: <20210810172955.660225700@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mario Kleiner <mario.kleiner.de@gmail.com>

commit 341abd693d10e5f337a51f140ae3e7a1ae0febf6 upstream.

This attempts to fix a bug found with a serial port card which uses
an MCS9922 chip, one of the 4 models for which MSI-X interrupts are
currently supported. I don't possess such a card, and i'm not
experienced with the serial subsystem, so this patch is based on what
i think i found as a likely reason for failure, based on walking the
user who actually owns the card through some diagnostic.

The user who reported the problem finds the following in his dmesg
output for the relevant ttyS4 and ttyS5:

[    0.580425] serial 0000:02:00.0: enabling device (0000 -> 0003)
[    0.601448] 0000:02:00.0: ttyS4 at I/O 0x3010 (irq = 125, base_baud = 115200) is a ST16650V2
[    0.603089] serial 0000:02:00.1: enabling device (0000 -> 0003)
[    0.624119] 0000:02:00.1: ttyS5 at I/O 0x3000 (irq = 126, base_baud = 115200) is a ST16650V2
...
[    6.323784] genirq: Flags mismatch irq 128. 00000080 (ttyS5) vs. 00000000 (xhci_hcd)
[    6.324128] genirq: Flags mismatch irq 128. 00000080 (ttyS5) vs. 00000000 (xhci_hcd)
...

Output of setserial -a:

/dev/ttyS4, Line 4, UART: 16650V2, Port: 0x3010, IRQ: 127
	Baud_base: 115200, close_delay: 50, divisor: 0
	closing_wait: 3000
	Flags: spd_normal skip_test

This suggests to me that the serial driver wants to register and share a
MSI/MSI-X irq 128 with the xhci_hcd driver, whereas the xhci driver does
not want to share the irq, as flags 0x00000080 (== IRQF_SHARED) from the
serial port driver means to share the irq, and this mismatch ends in some
failed irq init?

With this setup, data reception works very unreliable, with dropped data,
already at a transmission rate of only a 16 Bytes chunk every 1/120th of
a second, ie. 1920 Bytes/sec, presumably due to rx fifo overflow due to
mishandled or not used at all rx irq's?

See full discussion thread with attempted diagnosis at:

https://psychtoolbox.discourse.group/t/issues-with-iscan-serial-port-recording/3886

Disabling the use of MSI interrupts for the serial port pci card did
fix the reliability problems. The user executed the following sequence
of commands to achieve this:

echo 0000:02:00.0 | sudo tee /sys/bus/pci/drivers/serial/unbind
echo 0000:02:00.1 | sudo tee /sys/bus/pci/drivers/serial/unbind

echo 0 | sudo tee /sys/bus/pci/devices/0000:02:00.0/msi_bus
echo 0 | sudo tee /sys/bus/pci/devices/0000:02:00.1/msi_bus

echo 0000:02:00.0 | sudo tee /sys/bus/pci/drivers/serial/bind
echo 0000:02:00.1 | sudo tee /sys/bus/pci/drivers/serial/bind

This resulted in the following log output:

[   82.179021] pci 0000:02:00.0: MSI/MSI-X disallowed for future drivers
[   87.003031] pci 0000:02:00.1: MSI/MSI-X disallowed for future drivers
[   98.537010] 0000:02:00.0: ttyS4 at I/O 0x3010 (irq = 17, base_baud = 115200) is a ST16650V2
[  103.648124] 0000:02:00.1: ttyS5 at I/O 0x3000 (irq = 18, base_baud = 115200) is a ST16650V2

This patch attempts to fix the problem by disabling irq sharing when
using MSI irq's. Note that all i know for sure is that disabling MSI
irq's fixed the problem for the user, so this patch could be wrong and
is untested. Please review with caution, keeping this in mind.

Fixes: 8428413b1d14 ("serial: 8250_pci: Implement MSI(-X) support")
Cc: Ralf Ramsauer <ralf.ramsauer@oth-regensburg.de>
Cc: stable <stable@vger.kernel.org>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Mario Kleiner <mario.kleiner.de@gmail.com>
Link: https://lore.kernel.org/r/20210729043306.18528-1-mario.kleiner.de@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_pci.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/tty/serial/8250/8250_pci.c
+++ b/drivers/tty/serial/8250/8250_pci.c
@@ -3970,6 +3970,7 @@ pciserial_init_ports(struct pci_dev *dev
 		if (pci_match_id(pci_use_msi, dev)) {
 			dev_dbg(&dev->dev, "Using MSI(-X) interrupts\n");
 			pci_set_master(dev);
+			uart.port.flags &= ~UPF_SHARE_IRQ;
 			rc = pci_alloc_irq_vectors(dev, 1, 1, PCI_IRQ_ALL_TYPES);
 		} else {
 			dev_dbg(&dev->dev, "Using legacy interrupts\n");


