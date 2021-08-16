Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C3B43ED56F
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:12:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239510AbhHPNLZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:11:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:58330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239176AbhHPNJi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:09:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C7C3C61181;
        Mon, 16 Aug 2021 13:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119336;
        bh=oZL/OB8o8ThoISHrg94bl0H5lOke1fPd/b2loZdPR30=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gfhy4ACtDDlsIW3iSHoDkXTD7fqfDcHFkIy+TrmvzVXvpPjInSQrr3baR+qMUN2SP
         ztR8ONP9hmH2IKdRrxoDNG0cWGpC9q0DJ9HzrJXTrsbZo3f+/YB40nmNT69ilUeb9s
         R5k0nlDxe2P5+YGsT8e2qp+UBcPr8gxhmdCf7LXc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>
Subject: [PATCH 5.10 84/96] PCI/MSI: Correct misleading comments
Date:   Mon, 16 Aug 2021 15:02:34 +0200
Message-Id: <20210816125437.787569264@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125434.948010115@linuxfoundation.org>
References: <20210816125434.948010115@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit 689e6b5351573c38ccf92a0dd8b3e2c2241e4aff upstream.

The comments about preserving the cached state in pci_msi[x]_shutdown() are
misleading as the MSI descriptors are freed right after those functions
return. So there is nothing to restore. Preparatory change.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210729222542.621609423@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/msi.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -961,7 +961,6 @@ static void pci_msi_shutdown(struct pci_
 
 	/* Return the device with MSI unmasked as initial states */
 	mask = msi_mask(desc->msi_attrib.multi_cap);
-	/* Keep cached state to be restored */
 	__pci_msi_desc_mask_irq(desc, mask, 0);
 
 	/* Restore dev->irq to its default pin-assertion IRQ */
@@ -1047,10 +1046,8 @@ static void pci_msix_shutdown(struct pci
 	}
 
 	/* Return the device with MSI-X masked as initial states */
-	for_each_pci_msi_entry(entry, dev) {
-		/* Keep cached states to be restored */
+	for_each_pci_msi_entry(entry, dev)
 		__pci_msix_desc_mask_irq(entry, 1);
-	}
 
 	pci_msix_clear_and_set_ctrl(dev, PCI_MSIX_FLAGS_ENABLE, 0);
 	pci_intx_for_msi(dev, 1);


