Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 840F63ED56D
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:12:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236260AbhHPNLW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:11:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:59430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239169AbhHPNJh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:09:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 81B226329F;
        Mon, 16 Aug 2021 13:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119333;
        bh=Ne27BaWQ6LwvxVUHIKwB0TtH0uKXrbSfv4u+ZZ0uwwg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AlvMKrWPk7IWpE5ccERO4+4GiauEAYn0aYKzSgWOgygoMjbEgQGngEXMaa6Q37sfB
         basLlyVI+Yw/eqQrZAXtWBInJ+DWSUkgeSO6h7LwM19nv0/XnrKrcNyyJZ8noZ0MbM
         FRkPeLx+YVKnPZo+1iIYyzmYh9pC0+jt0AHDFBrg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>
Subject: [PATCH 5.10 83/96] PCI/MSI: Do not set invalid bits in MSI mask
Date:   Mon, 16 Aug 2021 15:02:33 +0200
Message-Id: <20210816125437.747838666@linuxfoundation.org>
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
@@ -663,21 +663,21 @@ static int msi_capability_init(struct pc
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


