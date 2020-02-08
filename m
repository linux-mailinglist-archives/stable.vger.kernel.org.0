Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 769DB156626
	for <lists+stable@lfdr.de>; Sat,  8 Feb 2020 19:32:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728457AbgBHScY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Feb 2020 13:32:24 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34582 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727939AbgBHS3s (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Feb 2020 13:29:48 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrO-0003jM-5x; Sat, 08 Feb 2020 18:29:42 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrL-000CVj-HX; Sat, 08 Feb 2020 18:29:39 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Bjorn Helgaas" <bhelgaas@google.com>,
        "Jian-Hong Pan" <jian-hong@endlessm.com>
Date:   Sat, 08 Feb 2020 18:21:03 +0000
Message-ID: <lsq.1581185941.640775918@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 124/148] PCI/MSI: Fix incorrect MSI-X masking on resume
In-Reply-To: <lsq.1581185939.857586636@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.82-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Jian-Hong Pan <jian-hong@endlessm.com>

commit e045fa29e89383c717e308609edd19d2fd29e1be upstream.

When a driver enables MSI-X, msix_program_entries() reads the MSI-X Vector
Control register for each vector and saves it in desc->masked.  Each
register is 32 bits and bit 0 is the actual Mask bit.

When we restored these registers during resume, we previously set the Mask
bit if *any* bit in desc->masked was set instead of when the Mask bit
itself was set:

  pci_restore_state
    pci_restore_msi_state
      __pci_restore_msix_state
        for_each_pci_msi_entry
          msix_mask_irq(entry, entry->masked)   <-- entire u32 word
            __pci_msix_desc_mask_irq(desc, flag)
              mask_bits = desc->masked & ~PCI_MSIX_ENTRY_CTRL_MASKBIT
              if (flag)       <-- testing entire u32, not just bit 0
                mask_bits |= PCI_MSIX_ENTRY_CTRL_MASKBIT
              writel(mask_bits, desc_addr + PCI_MSIX_ENTRY_VECTOR_CTRL)

This means that after resume, MSI-X vectors were masked when they shouldn't
be, which leads to timeouts like this:

  nvme nvme0: I/O 978 QID 3 timeout, completion polled

On resume, set the Mask bit only when the saved Mask bit from suspend was
set.

This should remove the need for 19ea025e1d28 ("nvme: Add quirk for Kingston
NVME SSD running FW E8FK11.T").

[bhelgaas: commit log, move fix to __pci_msix_desc_mask_irq()]
Link: https://bugzilla.kernel.org/show_bug.cgi?id=204887
Link: https://lore.kernel.org/r/20191008034238.2503-1-jian-hong@endlessm.com
Fixes: f2440d9acbe8 ("PCI MSI: Refactor interrupt masking code")
Signed-off-by: Jian-Hong Pan <jian-hong@endlessm.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/pci/msi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -220,8 +220,9 @@ u32 default_msix_mask_irq(struct msi_des
 	u32 mask_bits = desc->masked;
 	unsigned offset = desc->msi_attrib.entry_nr * PCI_MSIX_ENTRY_SIZE +
 						PCI_MSIX_ENTRY_VECTOR_CTRL;
+
 	mask_bits &= ~PCI_MSIX_ENTRY_CTRL_MASKBIT;
-	if (flag)
+	if (flag & PCI_MSIX_ENTRY_CTRL_MASKBIT)
 		mask_bits |= PCI_MSIX_ENTRY_CTRL_MASKBIT;
 	writel(mask_bits, desc->mask_base + offset);
 

