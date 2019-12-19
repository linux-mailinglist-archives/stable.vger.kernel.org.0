Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0C54126D23
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 20:08:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727870AbfLSSlb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:41:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:60580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727595AbfLSSla (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:41:30 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C51A24680;
        Thu, 19 Dec 2019 18:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576780890;
        bh=AJK70NamlA8q23FxBdWv6jpYVX0+fEyOeEMfVQ3W+N4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cy+mrxiw+R+Yw0MaMw10cE9oof0oTv2BS4T5jsgd/pybD74LjxDwhcgdfDeETYME7
         yAnxH97ZuipvWLatTAQEihni4QLdKsUYjTMz6w70CRN7hByLQJS/ZFFeT/p3GLjpPr
         P3UiJGRy9NwPo7C2L0tmN8e6QUFnAe2HjaK2am5g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jian-Hong Pan <jian-hong@endlessm.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 4.4 152/162] PCI/MSI: Fix incorrect MSI-X masking on resume
Date:   Thu, 19 Dec 2019 19:34:20 +0100
Message-Id: <20191219183217.032889852@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183150.477687052@linuxfoundation.org>
References: <20191219183150.477687052@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/msi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -224,7 +224,7 @@ u32 __pci_msix_desc_mask_irq(struct msi_
 		return 0;
 
 	mask_bits &= ~PCI_MSIX_ENTRY_CTRL_MASKBIT;
-	if (flag)
+	if (flag & PCI_MSIX_ENTRY_CTRL_MASKBIT)
 		mask_bits |= PCI_MSIX_ENTRY_CTRL_MASKBIT;
 	writel(mask_bits, desc->mask_base + offset);
 


