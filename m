Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 177653F6663
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:24:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239886AbhHXRXa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:23:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:60108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240161AbhHXRV2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:21:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4008B61B05;
        Tue, 24 Aug 2021 17:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824602;
        bh=hwq8p25wnqwg64+f9CK1rVkM4Pzsn/JuNlex93PA+lQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kxLOP6MrDofK+LADbXX0SrV9JShEX6QfGbFClnnfOIOuBoNxHvQchK2ewjxM5YoQP
         TRYngou1dQJ9VQYCw9Eervu/m07TlKvZB80iB3Iiyumd8yCqXo2UjmRTaVZMESciPx
         RxfxKDsbjLNV0bNVii6/cw8W7KbyeNMeolWhYLJIpkoCMe1P8i6igzsMLvKmxmCTgP
         D1TwattxE/up9KTCH5hQ0kkGXrVQzVA9VPI/WvRNbMC/LDnjyxbyPkcZwH67SRpRs6
         ryI2NbKu+qwQsQuc6rfbzO7I2TLmReABiZrRbVf8DezkOZaBpJ6IMr6PdqJblgheou
         1hQNDMK5EVT5A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.19 32/84] PCI/MSI: Do not set invalid bits in MSI mask
Date:   Tue, 24 Aug 2021 13:01:58 -0400
Message-Id: <20210824170250.710392-33-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170250.710392-1-sashal@kernel.org>
References: <20210824170250.710392-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.205-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.205-rc1
X-KernelTest-Deadline: 2021-08-26T17:02+00:00
X-stable: review
X-Patchwork-Hint: Ignore
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
 drivers/pci/msi.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 949dc342c16a..77e096c942ec 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -619,21 +619,21 @@ static int msi_capability_init(struct pci_dev *dev, int nvec,
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
@@ -897,7 +897,7 @@ static void pci_msi_shutdown(struct pci_dev *dev)
 	/* Return the device with MSI unmasked as initial states */
 	mask = msi_mask(desc->msi_attrib.multi_cap);
 	/* Keep cached state to be restored */
-	__pci_msi_desc_mask_irq(desc, mask, ~mask);
+	__pci_msi_desc_mask_irq(desc, mask, 0);
 
 	/* Restore dev->irq to its default pin-assertion irq */
 	dev->irq = desc->msi_attrib.default_irq;
-- 
2.30.2

