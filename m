Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C70562595CD
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 17:56:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728238AbgIAP4E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:56:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:33300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729763AbgIAPpN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:45:13 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 50A6A2064B;
        Tue,  1 Sep 2020 15:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598975112;
        bh=vyBKgTstExfaBCk1Y6nblj5Oorsha5j4zcPMCeia2nI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T8rKVO6cNhE37CoY8YjRqtE8bVETg3ncT4XHew0V2ny4wIBv8cpge1gcwTttc6+VA
         h28BWPtg+4wyTtwVm/S6zkRNJ5dxabq8zs+nL7DHMh1BxIlmPDldHPDvFeq0kYhzYE
         wvnaiAdVYS3ju8nKVFUFxgcZrd9P/59fpzI7w4DY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Valmer Huhn <valmer.huhn@concurrent-rt.com>
Subject: [PATCH 5.8 184/255] serial: 8250_exar: Fix number of ports for Commtech PCIe cards
Date:   Tue,  1 Sep 2020 17:10:40 +0200
Message-Id: <20200901151009.502520930@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901151000.800754757@linuxfoundation.org>
References: <20200901151000.800754757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Valmer Huhn <valmer.huhn@concurrent-rt.com>

commit c6b9e95dde7b54e6a53c47241201ab5a4035c320 upstream.

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
 drivers/tty/serial/8250/8250_exar.c |   24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

--- a/drivers/tty/serial/8250/8250_exar.c
+++ b/drivers/tty/serial/8250/8250_exar.c
@@ -744,6 +744,24 @@ static const struct exar8250_board pbn_e
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
@@ -811,9 +829,9 @@ static const struct pci_device_id exar_p
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


