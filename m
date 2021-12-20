Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3217347A701
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 10:29:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229827AbhLTJ3M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 04:29:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbhLTJ3L (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 04:29:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58234C061574
        for <stable@vger.kernel.org>; Mon, 20 Dec 2021 01:29:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2266CB80E28
        for <stable@vger.kernel.org>; Mon, 20 Dec 2021 09:29:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 606CCC36AE5;
        Mon, 20 Dec 2021 09:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639992548;
        bh=guCCY20XrLUNMU0XkTUJ5mVR4QySKFkmOh4mALUiJT0=;
        h=Subject:To:Cc:From:Date:From;
        b=d91X4EI2Fy7iVpw3KzJtfP2BsNLE5HGdPNw7vHb2xawLKowuU3gCRoVxvH0FZjOld
         oVMewEQPZT7c6Q01dDuHqr67VMhwGe48wnSz91bzgCRr0lmR/GHrFKfFbDlL6LQuJa
         aoFBz6O7abxqHBcf1UPS0i+9sTZDqwlgzhGFzw1g=
Subject: FAILED: patch "[PATCH] PCI/MSI: Mask MSI-X vectors only on success" failed to apply to 4.4-stable tree
To:     sr@denx.de, bhelgaas@google.com, marex@denx.de,
        michal.simek@xilinx.com, tglx@linutronix.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 Dec 2021 10:29:06 +0100
Message-ID: <16399925462169@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 83dbf898a2d45289be875deb580e93050ba67529 Mon Sep 17 00:00:00 2001
From: Stefan Roese <sr@denx.de>
Date: Tue, 14 Dec 2021 12:49:32 +0100
Subject: [PATCH] PCI/MSI: Mask MSI-X vectors only on success
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 48e3f4e47b29..6748cf9d7d90 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -722,9 +722,6 @@ static int msix_capability_init(struct pci_dev *dev, struct msix_entry *entries,
 		goto out_disable;
 	}
 
-	/* Ensure that all table entries are masked. */
-	msix_mask_all(base, tsize);
-
 	ret = msix_setup_entries(dev, base, entries, nvec, affd);
 	if (ret)
 		goto out_disable;
@@ -751,6 +748,16 @@ static int msix_capability_init(struct pci_dev *dev, struct msix_entry *entries,
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

