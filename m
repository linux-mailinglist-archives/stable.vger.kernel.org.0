Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2703D14FE84
	for <lists+stable@lfdr.de>; Sun,  2 Feb 2020 18:16:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726992AbgBBRQj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 Feb 2020 12:16:39 -0500
Received: from mail.fireflyinternet.com ([77.68.26.236]:62571 "EHLO
        fireflyinternet.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726885AbgBBRQj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 2 Feb 2020 12:16:39 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from haswell.alporthouse.com (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP id 20091962-1500050 
        for multiple; Sun, 02 Feb 2020 17:16:35 +0000
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     dri-devel@lists.freedesktop.org
Cc:     intel-gfx@lists.freedesktop.org,
        Chris Wilson <chris@chris-wilson.co.uk>, stable@vger.kernel.org
Subject: [PATCH 1/5] drm: Remove PageReserved manipulation from drm_pci_alloc
Date:   Sun,  2 Feb 2020 17:16:31 +0000
Message-Id: <20200202171635.4039044-1-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

drm_pci_alloc/drm_pci_free are very thin wrappers around the core dma
facilities, and we have no special reason within the drm layer to behave
differently. In particular, since

commit de09d31dd38a50fdce106c15abd68432eebbd014
Author: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Date:   Fri Jan 15 16:51:42 2016 -0800

    page-flags: define PG_reserved behavior on compound pages

    As far as I can see there's no users of PG_reserved on compound pages.
    Let's use PF_NO_COMPOUND here.

it has been illegal to combine GFP_COMP with SetPageReserved, so lets
stop doing both and leave the dma layer to its own devices.

Reported-by: Taketo Kabe
Closes: https://gitlab.freedesktop.org/drm/intel/issues/1027
Fixes: de09d31dd38a ("page-flags: define PG_reserved behavior on compound pages")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: <stable@vger.kernel.org> # v4.5+
---
 drivers/gpu/drm/drm_pci.c | 23 ++---------------------
 1 file changed, 2 insertions(+), 21 deletions(-)

diff --git a/drivers/gpu/drm/drm_pci.c b/drivers/gpu/drm/drm_pci.c
index f2e43d341980..d16dac4325f9 100644
--- a/drivers/gpu/drm/drm_pci.c
+++ b/drivers/gpu/drm/drm_pci.c
@@ -51,8 +51,6 @@
 drm_dma_handle_t *drm_pci_alloc(struct drm_device * dev, size_t size, size_t align)
 {
 	drm_dma_handle_t *dmah;
-	unsigned long addr;
-	size_t sz;
 
 	/* pci_alloc_consistent only guarantees alignment to the smallest
 	 * PAGE_SIZE order which is greater than or equal to the requested size.
@@ -68,20 +66,13 @@ drm_dma_handle_t *drm_pci_alloc(struct drm_device * dev, size_t size, size_t ali
 	dmah->size = size;
 	dmah->vaddr = dma_alloc_coherent(&dev->pdev->dev, size,
 					 &dmah->busaddr,
-					 GFP_KERNEL | __GFP_COMP);
+					 GFP_KERNEL);
 
 	if (dmah->vaddr == NULL) {
 		kfree(dmah);
 		return NULL;
 	}
 
-	/* XXX - Is virt_to_page() legal for consistent mem? */
-	/* Reserve */
-	for (addr = (unsigned long)dmah->vaddr, sz = size;
-	     sz > 0; addr += PAGE_SIZE, sz -= PAGE_SIZE) {
-		SetPageReserved(virt_to_page((void *)addr));
-	}
-
 	return dmah;
 }
 
@@ -94,19 +85,9 @@ EXPORT_SYMBOL(drm_pci_alloc);
  */
 void __drm_legacy_pci_free(struct drm_device * dev, drm_dma_handle_t * dmah)
 {
-	unsigned long addr;
-	size_t sz;
-
-	if (dmah->vaddr) {
-		/* XXX - Is virt_to_page() legal for consistent mem? */
-		/* Unreserve */
-		for (addr = (unsigned long)dmah->vaddr, sz = dmah->size;
-		     sz > 0; addr += PAGE_SIZE, sz -= PAGE_SIZE) {
-			ClearPageReserved(virt_to_page((void *)addr));
-		}
+	if (dmah->vaddr)
 		dma_free_coherent(&dev->pdev->dev, dmah->size, dmah->vaddr,
 				  dmah->busaddr);
-	}
 }
 
 /**
-- 
2.25.0

