Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDA1147AC69
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:43:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235187AbhLTOni (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:43:38 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:50640 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235438AbhLTOmP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:42:15 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 44E6AB80EE3;
        Mon, 20 Dec 2021 14:42:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87487C36AE8;
        Mon, 20 Dec 2021 14:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011333;
        bh=dsyhPV3pGgf/4WJmlaH/zgA+cgIArokgSGhXtKSLHqc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PRlxF98EwLCsPDsKHWSVDCyR5vwCe3ZiGqyO1mP+YdhyKgCtdF4V9hktUVkI0kKW2
         3eb6+HOMOc8CWdKIFGOoFrOZ8X5Olgnnzz8yiKZ0okuBiU6YawLGanTYzp2miiG33M
         2w18zKksvKlNR0RmVqjl/2qtHoykrvmwZv4vQrqg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Roese <sr@denx.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-pci@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Marek Vasut <marex@denx.de>
Subject: [PATCH 4.19 33/56] PCI/MSI: Mask MSI-X vectors only on success
Date:   Mon, 20 Dec 2021 15:34:26 +0100
Message-Id: <20211220143024.526582062@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143023.451982183@linuxfoundation.org>
References: <20211220143023.451982183@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Roese <sr@denx.de>

commit 83dbf898a2d45289be875deb580e93050ba67529 upstream.

Masking all unused MSI-X entries is done to ensure that a crash kernel
starts from a clean slate, which correponds to the reset state of the
device as defined in the PCI-E specificion 3.0 and later:

 Vector Control for MSI-X Table Entries
 --------------------------------------

 "00: Mask bit:  When this bit is set, the function is prohibited from
                 sending a message using this MSI-X Table entry.
                 ...
                 This bit’s state after reset is 1 (entry is masked)."

A Marvell NVME device fails to deliver MSI interrupts after trying to
enable MSI-X interrupts due to that masking. It seems to take the MSI-X
mask bits into account even when MSI-X is disabled.

While not specification compliant, this can be cured by moving the masking
into the success path, so that the MSI-X table entries stay in device reset
state when the MSI-X setup fails.

[ tglx: Move it into the success path, add comment and amend changelog ]

Fixes: aa8092c1d1f1 ("PCI/MSI: Mask all unused MSI-X entries")
Signed-off-by: Stefan Roese <sr@denx.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-pci@vger.kernel.org
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Michal Simek <michal.simek@xilinx.com>
Cc: Marek Vasut <marex@denx.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20211210161025.3287927-1-sr@denx.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/msi.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -799,9 +799,6 @@ static int msix_capability_init(struct p
 		goto out_disable;
 	}
 
-	/* Ensure that all table entries are masked. */
-	msix_mask_all(base, tsize);
-
 	ret = msix_setup_entries(dev, base, entries, nvec, affd);
 	if (ret)
 		goto out_disable;
@@ -824,6 +821,16 @@ static int msix_capability_init(struct p
 	/* Set MSI-X enabled bits and unmask the function */
 	pci_intx_for_msi(dev, 0);
 	dev->msix_enabled = 1;
+
+	/*
+	 * Ensure that all table entries are masked to prevent
+	 * stale entries from firing in a crash kernel.
+	 *
+	 * Done late to deal with a broken Marvell NVME device
+	 * which takes the MSI-X mask bits into account even
+	 * when MSI-X is disabled, which prevents MSI delivery.
+	 */
+	msix_mask_all(base, tsize);
 	pci_msix_clear_and_set_ctrl(dev, PCI_MSIX_FLAGS_MASKALL, 0);
 
 	pcibios_free_irq(dev);


