Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D155B469C8E
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:20:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358768AbhLFPXb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:23:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350095AbhLFPVa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:21:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFEF3C08E883;
        Mon,  6 Dec 2021 07:14:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6DBEC61320;
        Mon,  6 Dec 2021 15:14:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EDC9C341C1;
        Mon,  6 Dec 2021 15:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803663;
        bh=dtLroQ0gdgq8IK1tSicOJbJRtKJzEjhs2p4tRU0/WDM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f+ozduXBDsdy3E5rZlazejY6x0jWzxjOsJiS66MG6V59p/JFmtM6T5vM8paQD61ca
         ObHsWcL6SV68mX99DeqTeXzQAmqd4laTFnn9apCFadEttY0si8JI9Qj0NDr4rq5y+U
         Gtqkc3/nN0HUeg3rK63wNGyIOVS9MOcR4jRIBZGc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jay Dolan <jay.dolan@accesio.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 5.4 65/70] serial: 8250_pci: Fix ACCES entries in pci_serial_quirks array
Date:   Mon,  6 Dec 2021 15:57:09 +0100
Message-Id: <20211206145554.179151530@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145551.909846023@linuxfoundation.org>
References: <20211206145551.909846023@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jay Dolan <jay.dolan@accesio.com>

commit c525c5d2437f93520388920baac6d9340c65d239 upstream.

Fix error in table for PCI_DEVICE_ID_ACCESIO_PCIE_ICM_4S that caused it
and PCI_DEVICE_ID_ACCESIO_PCIE_ICM232_4 to be missing their fourth port.

Fixes: 78d3820b9bd3 ("serial: 8250_pci: Have ACCES cards that use the four port Pericom PI7C9X7954 chip use the pci_pericom_setup()")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Jay Dolan <jay.dolan@accesio.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20211122120604.3909-2-andriy.shevchenko@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_pci.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/tty/serial/8250/8250_pci.c
+++ b/drivers/tty/serial/8250/8250_pci.c
@@ -2285,11 +2285,18 @@ static struct pci_serial_quirk pci_seria
 		.setup      = pci_pericom_setup_four_at_eight,
 	},
 	{
-		.vendor     = PCI_DEVICE_ID_ACCESIO_PCIE_ICM_4S,
+		.vendor     = PCI_VENDOR_ID_ACCESIO,
 		.device     = PCI_DEVICE_ID_ACCESIO_PCIE_ICM232_4,
 		.subvendor  = PCI_ANY_ID,
 		.subdevice  = PCI_ANY_ID,
 		.setup      = pci_pericom_setup_four_at_eight,
+	},
+	{
+		.vendor     = PCI_VENDOR_ID_ACCESIO,
+		.device     = PCI_DEVICE_ID_ACCESIO_PCIE_ICM_4S,
+		.subvendor  = PCI_ANY_ID,
+		.subdevice  = PCI_ANY_ID,
+		.setup      = pci_pericom_setup_four_at_eight,
 	},
 	{
 		.vendor     = PCI_VENDOR_ID_ACCESIO,


