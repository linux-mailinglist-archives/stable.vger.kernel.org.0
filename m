Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15B443E804B
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:47:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235452AbhHJRr5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:47:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:56820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235704AbhHJRqD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:46:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3610161247;
        Tue, 10 Aug 2021 17:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617220;
        bh=ckeo+XSfRypBSHdnCzFP2tkKjgTwwxNzrwrjQIeZC8w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T2IE8j7hrGoRKGRKvBo/la2K22FmFNKUckStrGhpOmvsQtYm8e4u6rIFBxdQBvMtc
         k0VaiwzSByfdGpwQAIq6gex8nBkCURDhyhR1+v4qQIdqJng8ppsISrzpSKOfazg/Ix
         9e3gpvyxfZM101emkGOL4HkGbdSfPEnBtQFTWQ7o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 5.10 098/135] serial: 8250_pci: Enumerate Elkhart Lake UARTs via dedicated driver
Date:   Tue, 10 Aug 2021 19:30:32 +0200
Message-Id: <20210810172959.093363149@linuxfoundation.org>
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
 


