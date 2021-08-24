Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 806D13F6716
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241408AbhHXRam (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:30:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:35500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240580AbhHXR2k (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:28:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B01261B63;
        Tue, 24 Aug 2021 17:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824721;
        bh=xNDjOULY9Sb5CRSKZB3PB64wDwg1EBJ8CHW31JAPtkI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MSJu7iPPfTN3rvPrxFMhSmqsjgwtNqYnhUbGO7jiB1UylpWa1BYhLRRnr3UXjQ+Pa
         e1uA7oU7oRsl8y9KrNy29zVCZs4DsI8cjD9cNZikp/0pmUQP4G1ZMIaxMmMCqpt8zJ
         J+CjZRhvvWpJ5NN4FeaIUeol8FEMbhRWDJ97JQ4k0jvpwyDE1XXUwwIKFg0SdaSSWb
         KxMQYjvb9n6G60jLC5FGbvXkTjqrVWxDQILjlqODdzjSNUbDGgzNMz8GNy/jEKf7Ni
         rM5zPUzxnWz9v3GK54xMwD4D/Ztx6VVAfCdVQxHKMSZxiB9NzuqwjWiAaD5qjik4O2
         H6GlKLfSVBEqQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.14 23/64] PCI/MSI: Correct misleading comments
Date:   Tue, 24 Aug 2021 13:04:16 -0400
Message-Id: <20210824170457.710623-24-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170457.710623-1-sashal@kernel.org>
References: <20210824170457.710623-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.245-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.245-rc1
X-KernelTest-Deadline: 2021-08-26T17:04+00:00
X-stable: review
X-Patchwork-Hint: Ignore
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
 drivers/pci/msi.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index c69cd0dff301..93dd4c69cc46 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -896,7 +896,6 @@ static void pci_msi_shutdown(struct pci_dev *dev)
 
 	/* Return the device with MSI unmasked as initial states */
 	mask = msi_mask(desc->msi_attrib.multi_cap);
-	/* Keep cached state to be restored */
 	__pci_msi_desc_mask_irq(desc, mask, 0);
 
 	/* Restore dev->irq to its default pin-assertion irq */
@@ -982,10 +981,8 @@ static void pci_msix_shutdown(struct pci_dev *dev)
 	}
 
 	/* Return the device with MSI-X masked as initial states */
-	for_each_pci_msi_entry(entry, dev) {
-		/* Keep cached states to be restored */
+	for_each_pci_msi_entry(entry, dev)
 		__pci_msix_desc_mask_irq(entry, 1);
-	}
 
 	pci_msix_clear_and_set_ctrl(dev, PCI_MSIX_FLAGS_ENABLE, 0);
 	pci_intx_for_msi(dev, 1);
-- 
2.30.2

