Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67B45469E2B
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:36:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379033AbhLFPgt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:36:49 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:48928 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359564AbhLFPdW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:33:22 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C204D6132B;
        Mon,  6 Dec 2021 15:29:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4425C34900;
        Mon,  6 Dec 2021 15:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804593;
        bh=ryO4KQcH3V+2CFuKqNkoDVZf3cSuqiuLTTarPtnaKq0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vCDHhhPNB1FD9jp3qvrCn/T+ZgnkkBLKG0RCbL1f5hoXI0QAS5qyR2JPX85YN1y5L
         NBLnJ36JmAhq/Tm4skKmrbi0lcY8LDZr4f0nOGvZ2IQ9skSZRs3jluHvlGPAHzyYSr
         5QDRrTBQqUiIIeEs9sfLVCuI7KjJgnFK2rNWIYTo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jay Dolan <jay.dolan@accesio.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 5.15 201/207] serial: 8250_pci: Fix ACCES entries in pci_serial_quirks array
Date:   Mon,  6 Dec 2021 15:57:35 +0100
Message-Id: <20211206145617.243733796@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
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
@@ -2317,11 +2317,18 @@ static struct pci_serial_quirk pci_seria
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


