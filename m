Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C91E43ED6A7
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:23:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239751AbhHPNWr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:22:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:44618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239097AbhHPNUi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:20:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA90C632BE;
        Mon, 16 Aug 2021 13:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119765;
        bh=Db5bJ88XKCt3Vl0kYy7zWPPbF0tbBPULQy1BHkHTAgA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RCGY/UOzlDh8YiCeFRbQiKa3BRih0RNgl1IJehVk37pyZ8I4Vm1FNi1Yl92xkTJ9Y
         GdewNdDnuB1lWVbZkGIIH5VAVCjV8TvR50U3dsf9RemsobV9zMlOtuyCNHpPDSZDZZ
         OOWrdclIqb9tB5wRKMV+UpsUc38FiJox/EWMiX6I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>
Subject: [PATCH 5.13 132/151] PCI/MSI: Do not set invalid bits in MSI mask
Date:   Mon, 16 Aug 2021 15:02:42 +0200
Message-Id: <20210816125448.403081564@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125444.082226187@linuxfoundation.org>
References: <20210816125444.082226187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit 361fd37397f77578735907341579397d5bed0a2d upstream.

msi_mask_irq() takes a mask and a flags argument. The mask argument is used
to mask out bits from the cached mask and the flags argument to set bits.

Some places invoke it with a flags argument which sets bits which are not
used by the device, i.e. when the device supports up to 8 vectors a full
unmask in some places sets the mask to 0xFFFFFF00. While devices probably
do not care, it's still bad practice.

Fixes: 7ba1930db02f ("PCI MSI: Unmask MSI if setup failed")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210729222542.568173099@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/msi.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -656,21 +656,21 @@ static int msi_capability_init(struct pc
 	/* Configure MSI capability structure */
 	ret = pci_msi_setup_msi_irqs(dev, nvec, PCI_CAP_ID_MSI);
 	if (ret) {
-		msi_mask_irq(entry, mask, ~mask);
+		msi_mask_irq(entry, mask, 0);
 		free_msi_irqs(dev);
 		return ret;
 	}
 
 	ret = msi_verify_entries(dev);
 	if (ret) {
-		msi_mask_irq(entry, mask, ~mask);
+		msi_mask_irq(entry, mask, 0);
 		free_msi_irqs(dev);
 		return ret;
 	}
 
 	ret = populate_msi_sysfs(dev);
 	if (ret) {
-		msi_mask_irq(entry, mask, ~mask);
+		msi_mask_irq(entry, mask, 0);
 		free_msi_irqs(dev);
 		return ret;
 	}
@@ -962,7 +962,7 @@ static void pci_msi_shutdown(struct pci_
 	/* Return the device with MSI unmasked as initial states */
 	mask = msi_mask(desc->msi_attrib.multi_cap);
 	/* Keep cached state to be restored */
-	__pci_msi_desc_mask_irq(desc, mask, ~mask);
+	__pci_msi_desc_mask_irq(desc, mask, 0);
 
 	/* Restore dev->irq to its default pin-assertion IRQ */
 	dev->irq = desc->msi_attrib.default_irq;


