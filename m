Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EF6F113232
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 19:08:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728703AbfLDSGT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 13:06:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:54320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730520AbfLDSGT (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 13:06:19 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 38E50206DF;
        Wed,  4 Dec 2019 18:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575482777;
        bh=zBPDCyY6Vpcz+D96PO12iW3TKeVfwHVznMWy6CktHIo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nvQ3H8KagXEwBNHywbIuDe5/0JqizKid+3R6Xobui36dgQMhyGTjMhPXnpyNPYozt
         E/N8YP4guq3eZ3KCXuvl0dI4Zw5PhrMg6ykA09k5kGoRFmiYX6O5s1TAkTDeZIygCO
         kKG35cHJSWhZz8p4SQLU7zrSQLXzivXokdZGLDZc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Jens Axboe <axboe@fb.com>,
        Keith Busch <keith.busch@intel.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 129/209] PCI/MSI: Return -ENOSPC from pci_alloc_irq_vectors_affinity()
Date:   Wed,  4 Dec 2019 18:55:41 +0100
Message-Id: <20191204175331.999463947@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191204175321.609072813@linuxfoundation.org>
References: <20191204175321.609072813@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit 77f88abd4a6f73a1a68dbdc0e3f21575fd508fc3 ]

The API of pci_alloc_irq_vectors_affinity() says it returns -ENOSPC if
fewer than @min_vecs interrupt vectors are available for @dev.

However, if a device supports MSI-X but not MSI and a caller requests
@min_vecs that can't be satisfied by MSI-X, we previously returned -EINVAL
(from the failed attempt to enable MSI), not -ENOSPC.

When -ENOSPC is returned, callers may reduce the number IRQs they request
and try again.  Most callers can use the @min_vecs and @max_vecs
parameters to avoid this retry loop, but that doesn't work when using IRQ
affinity "nr_sets" because rebalancing the sets is driver-specific.

This return value bug has been present since pci_alloc_irq_vectors() was
added in v4.10 by aff171641d18 ("PCI: Provide sensible IRQ vector
alloc/free routines"), but it wasn't an issue because @min_vecs/@max_vecs
removed the need for callers to iteratively reduce the number of IRQs
requested and retry the allocation, so they didn't need to distinguish
-ENOSPC from -EINVAL.

In v5.0, 6da4b3ab9a6e ("genirq/affinity: Add support for allocating
interrupt sets") added IRQ sets to the interface, which reintroduced the
need to check for -ENOSPC and possibly reduce the number of IRQs requested
and retry the allocation.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
[bhelgaas: changelog]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jens Axboe <axboe@fb.com>
Cc: Keith Busch <keith.busch@intel.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/msi.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 536e9a5cd2b14..d66ef88e13cf1 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -1156,7 +1156,8 @@ int pci_alloc_irq_vectors_affinity(struct pci_dev *dev, unsigned int min_vecs,
 				   const struct irq_affinity *affd)
 {
 	static const struct irq_affinity msi_default_affd;
-	int vecs = -ENOSPC;
+	int msix_vecs = -ENOSPC;
+	int msi_vecs = -ENOSPC;
 
 	if (flags & PCI_IRQ_AFFINITY) {
 		if (!affd)
@@ -1167,16 +1168,17 @@ int pci_alloc_irq_vectors_affinity(struct pci_dev *dev, unsigned int min_vecs,
 	}
 
 	if (flags & PCI_IRQ_MSIX) {
-		vecs = __pci_enable_msix_range(dev, NULL, min_vecs, max_vecs,
-				affd);
-		if (vecs > 0)
-			return vecs;
+		msix_vecs = __pci_enable_msix_range(dev, NULL, min_vecs,
+						    max_vecs, affd);
+		if (msix_vecs > 0)
+			return msix_vecs;
 	}
 
 	if (flags & PCI_IRQ_MSI) {
-		vecs = __pci_enable_msi_range(dev, min_vecs, max_vecs, affd);
-		if (vecs > 0)
-			return vecs;
+		msi_vecs = __pci_enable_msi_range(dev, min_vecs, max_vecs,
+						  affd);
+		if (msi_vecs > 0)
+			return msi_vecs;
 	}
 
 	/* use legacy irq if allowed */
@@ -1187,7 +1189,9 @@ int pci_alloc_irq_vectors_affinity(struct pci_dev *dev, unsigned int min_vecs,
 		}
 	}
 
-	return vecs;
+	if (msix_vecs == -ENOSPC)
+		return -ENOSPC;
+	return msi_vecs;
 }
 EXPORT_SYMBOL(pci_alloc_irq_vectors_affinity);
 
-- 
2.20.1



