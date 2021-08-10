Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E81733E81C1
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 20:02:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233977AbhHJSB7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 14:01:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:33268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238717AbhHJR74 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:59:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5B0D761242;
        Tue, 10 Aug 2021 17:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617600;
        bh=ckeo+XSfRypBSHdnCzFP2tkKjgTwwxNzrwrjQIeZC8w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0dL5XkwmYJJjK37y5mx4qi9/0xZii6VDaTQcUXHnAlgsHU5T5gaUygQhCevHWYH+x
         5Kkf/CIzQStlIRaPxQvhKvsEtzgxf/z8WoapbUEjVHDz1XdQ90DYcdmaRdE3cTYToN
         kbyCvR4Js9iY4cMTuSvi5fKhIziFoFaSeAM/WzNg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 5.13 129/175] serial: 8250_pci: Enumerate Elkhart Lake UARTs via dedicated driver
Date:   Tue, 10 Aug 2021 19:30:37 +0200
Message-Id: <20210810173005.200512277@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810173000.928681411@linuxfoundation.org>
References: <20210810173000.928681411@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

commit 7f0909db761535aefafa77031062603a71557267 upstream.

Elkhart Lake UARTs are PCI enumerated Synopsys DesignWare v4.0+ UART
integrated with Intel iDMA 32-bit DMA controller. There is a specific
driver to handle them, i.e. 8250_lpss. Hence, disable 8250_pci
enumeration for these UARTs.

Fixes: 1b91d97c66ef ("serial: 8250_lpss: Add ->setup() for Elkhart Lake ports")
Fixes: 4f912b898dc2 ("serial: 8250_lpss: Enable HS UART on Elkhart Lake")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20210713101739.36962-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_pci.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/tty/serial/8250/8250_pci.c
+++ b/drivers/tty/serial/8250/8250_pci.c
@@ -3804,6 +3804,12 @@ static const struct pci_device_id blackl
 	{ PCI_VDEVICE(INTEL, 0x0f0c), },
 	{ PCI_VDEVICE(INTEL, 0x228a), },
 	{ PCI_VDEVICE(INTEL, 0x228c), },
+	{ PCI_VDEVICE(INTEL, 0x4b96), },
+	{ PCI_VDEVICE(INTEL, 0x4b97), },
+	{ PCI_VDEVICE(INTEL, 0x4b98), },
+	{ PCI_VDEVICE(INTEL, 0x4b99), },
+	{ PCI_VDEVICE(INTEL, 0x4b9a), },
+	{ PCI_VDEVICE(INTEL, 0x4b9b), },
 	{ PCI_VDEVICE(INTEL, 0x9ce3), },
 	{ PCI_VDEVICE(INTEL, 0x9ce4), },
 


