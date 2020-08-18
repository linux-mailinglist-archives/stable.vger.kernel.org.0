Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3F722483C6
	for <lists+stable@lfdr.de>; Tue, 18 Aug 2020 13:28:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbgHRL2D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Aug 2020 07:28:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:42690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726599AbgHRL1c (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Aug 2020 07:27:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A85D7207D3;
        Tue, 18 Aug 2020 11:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597750038;
        bh=M/pZuJ6qNcafAtYGGevYuspGD7ps4zPgqxO6a1dpw+w=;
        h=Subject:To:From:Date:From;
        b=OuwGtui7LMo3Ud2aAt0OvuZYQbHXEH/0yTxPqbL9kEfT4GXBXjdd1HbZOg7HeyFQj
         Y7y5dOFxYTPYfAt91pGbbn9w4OR9gQBOYUoH3D4HRonP7pRKn46l7HBff8EUfhdgOt
         NeB6lqXayZIUJcz/v6RzAsEKwFxhpFJlOOgcJ3VQ=
Subject: patch "serial: 8250_exar: Fix number of ports for Commtech PCIe cards" added to tty-linus
To:     valmer.huhn@concurrent-rt.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 18 Aug 2020 13:27:42 +0200
Message-ID: <1597750062247186@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    serial: 8250_exar: Fix number of ports for Commtech PCIe cards

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From c6b9e95dde7b54e6a53c47241201ab5a4035c320 Mon Sep 17 00:00:00 2001
From: Valmer Huhn <valmer.huhn@concurrent-rt.com>
Date: Thu, 13 Aug 2020 12:52:55 -0400
Subject: serial: 8250_exar: Fix number of ports for Commtech PCIe cards

The following in 8250_exar.c line 589 is used to determine the number
of ports for each Exar board:

nr_ports = board->num_ports ? board->num_ports : pcidev->device & 0x0f;

If the number of ports a card has is not explicitly specified, it defaults
to the rightmost 4 bits of the PCI device ID. This is prone to error since
not all PCI device IDs contain a number which corresponds to the number of
ports that card provides.

This particular case involves COMMTECH_4222PCIE, COMMTECH_4224PCIE and
COMMTECH_4228PCIE cards with device IDs 0x0022, 0x0020 and 0x0021.
Currently the multiport cards receive 2, 0 and 1 port instead of 2, 4 and
8 ports respectively.

To fix this, each Commtech Fastcom PCIe card is given a struct where the
number of ports is explicitly specified. This ensures 'board->num_ports'
is used instead of the default 'pcidev->device & 0x0f'.

Fixes: d0aeaa83f0b0 ("serial: exar: split out the exar code from 8250_pci")
Signed-off-by: Valmer Huhn <valmer.huhn@concurrent-rt.com>
Tested-by: Valmer Huhn <valmer.huhn@concurrent-rt.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200813165255.GC345440@icarus.concurrent-rt.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_exar.c | 24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_exar.c b/drivers/tty/serial/8250/8250_exar.c
index 04b9af7ed941..2d0e7c7e408d 100644
--- a/drivers/tty/serial/8250/8250_exar.c
+++ b/drivers/tty/serial/8250/8250_exar.c
@@ -744,6 +744,24 @@ static const struct exar8250_board pbn_exar_XR17V35x = {
 	.exit		= pci_xr17v35x_exit,
 };
 
+static const struct exar8250_board pbn_fastcom35x_2 = {
+	.num_ports	= 2,
+	.setup		= pci_xr17v35x_setup,
+	.exit		= pci_xr17v35x_exit,
+};
+
+static const struct exar8250_board pbn_fastcom35x_4 = {
+	.num_ports	= 4,
+	.setup		= pci_xr17v35x_setup,
+	.exit		= pci_xr17v35x_exit,
+};
+
+static const struct exar8250_board pbn_fastcom35x_8 = {
+	.num_ports	= 8,
+	.setup		= pci_xr17v35x_setup,
+	.exit		= pci_xr17v35x_exit,
+};
+
 static const struct exar8250_board pbn_exar_XR17V4358 = {
 	.num_ports	= 12,
 	.setup		= pci_xr17v35x_setup,
@@ -811,9 +829,9 @@ static const struct pci_device_id exar_pci_tbl[] = {
 	EXAR_DEVICE(EXAR, XR17V358, pbn_exar_XR17V35x),
 	EXAR_DEVICE(EXAR, XR17V4358, pbn_exar_XR17V4358),
 	EXAR_DEVICE(EXAR, XR17V8358, pbn_exar_XR17V8358),
-	EXAR_DEVICE(COMMTECH, 4222PCIE, pbn_exar_XR17V35x),
-	EXAR_DEVICE(COMMTECH, 4224PCIE, pbn_exar_XR17V35x),
-	EXAR_DEVICE(COMMTECH, 4228PCIE, pbn_exar_XR17V35x),
+	EXAR_DEVICE(COMMTECH, 4222PCIE, pbn_fastcom35x_2),
+	EXAR_DEVICE(COMMTECH, 4224PCIE, pbn_fastcom35x_4),
+	EXAR_DEVICE(COMMTECH, 4228PCIE, pbn_fastcom35x_8),
 
 	EXAR_DEVICE(COMMTECH, 4222PCI335, pbn_fastcom335_2),
 	EXAR_DEVICE(COMMTECH, 4224PCI335, pbn_fastcom335_4),
-- 
2.28.0


