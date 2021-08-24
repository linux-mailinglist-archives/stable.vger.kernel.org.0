Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A92193F6718
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241511AbhHXRan (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:30:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:35536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240197AbhHXR2m (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:28:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6863661B68;
        Tue, 24 Aug 2021 17:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824722;
        bh=1mDLm/B2jQap7FqEtkMnp8RQKxaulQQyqv0Yf1e6pdg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LPZEkoRpI94yM9K6x4wuQU0241cf9ANteZv4y5JPU5H0JYsSKLKFcwciX7fzbowI/
         +sIZlJQYHlZGvNsIgQDVzKUziK+rE/BSqhFOS2gaD0MpiAuNIocNdRGAPGVDImqrE3
         OWx3IkaD8aCfXnFwe+KyE5GwmRmM1KmrxFQNe2tG6eITHTYQBgD+aj4cK3m+epQdds
         WL1SMpJpzPZAIt79vVcEhe8YpcOru0Sg8AQtvrLPS7vQyjTcM3/vtZP+gb91o0Cv1H
         o55yxmh/5LAFkdhjJFDE+/c/1A38JmeGcNX4FaFojyuqgIo1vFPy9zbe7fosMpojGk
         g7LqCn/eUBwAQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.14 24/64] PCI/MSI: Use msi_mask_irq() in pci_msi_shutdown()
Date:   Tue, 24 Aug 2021 13:04:17 -0400
Message-Id: <20210824170457.710623-25-sashal@kernel.org>
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

commit d28d4ad2a1aef27458b3383725bb179beb8d015c upstream.

No point in using the raw write function from shutdown. Preparatory change
to introduce proper serialization for the msi_desc::masked cache.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210729222542.674391354@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/msi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 93dd4c69cc46..034f60b75a6e 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -896,7 +896,7 @@ static void pci_msi_shutdown(struct pci_dev *dev)
 
 	/* Return the device with MSI unmasked as initial states */
 	mask = msi_mask(desc->msi_attrib.multi_cap);
-	__pci_msi_desc_mask_irq(desc, mask, 0);
+	msi_mask_irq(desc, mask, 0);
 
 	/* Restore dev->irq to its default pin-assertion irq */
 	dev->irq = desc->msi_attrib.default_irq;
-- 
2.30.2

