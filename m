Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A0AC1ACBFC
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 17:56:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2896336AbgDPPxX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 11:53:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:43732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2896541AbgDPNct (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:32:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 71D792220A;
        Thu, 16 Apr 2020 13:31:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587043890;
        bh=hutXKienBjwJBpgB0pkLoS31sOWq76NOiXeYV+JgnKk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QiZb4MOEEdou80OF9j6GDrEhkcZuBDhAwSVeOQ7M9e52cjjOP3Ajr0GalEsr7YAO7
         Wo6XPgMOwx8zdsGb8s11LigvQbBM3m0YefaZb2C0FAutYD24qayygcw5QkEX+Y1t6P
         g/6YkLBjlbVzmN6fBX0aj9+QCf6O7vcr4KozlGgY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 142/146] drm: Remove PageReserved manipulation from drm_pci_alloc
Date:   Thu, 16 Apr 2020 15:24:43 +0200
Message-Id: <20200416131301.796387164@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131242.353444678@linuxfoundation.org>
References: <20200416131242.353444678@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

[ Upstream commit ea36ec8623f56791c6ff6738d0509b7920f85220 ]

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
Bug: https://gitlab.freedesktop.org/drm/intel/issues/1027
Fixes: de09d31dd38a ("page-flags: define PG_reserved behavior on compound pages")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: <stable@vger.kernel.org> # v4.5+
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200202171635.4039044-1-chris@chris-wilson.co.uk
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_pci.c | 25 ++-----------------------
 1 file changed, 2 insertions(+), 23 deletions(-)

diff --git a/drivers/gpu/drm/drm_pci.c b/drivers/gpu/drm/drm_pci.c
index 896e42a34895d..d89a992829beb 100644
--- a/drivers/gpu/drm/drm_pci.c
+++ b/drivers/gpu/drm/drm_pci.c
@@ -46,8 +46,6 @@
 drm_dma_handle_t *drm_pci_alloc(struct drm_device * dev, size_t size, size_t align)
 {
 	drm_dma_handle_t *dmah;
-	unsigned long addr;
-	size_t sz;
 
 	/* pci_alloc_consistent only guarantees alignment to the smallest
 	 * PAGE_SIZE order which is greater than or equal to the requested size.
@@ -61,22 +59,13 @@ drm_dma_handle_t *drm_pci_alloc(struct drm_device * dev, size_t size, size_t ali
 		return NULL;
 
 	dmah->size = size;
-	dmah->vaddr = dma_alloc_coherent(&dev->pdev->dev, size, &dmah->busaddr, GFP_KERNEL | __GFP_COMP);
+	dmah->vaddr = dma_alloc_coherent(&dev->pdev->dev, size, &dmah->busaddr, GFP_KERNEL);
 
 	if (dmah->vaddr == NULL) {
 		kfree(dmah);
 		return NULL;
 	}
 
-	memset(dmah->vaddr, 0, size);
-
-	/* XXX - Is virt_to_page() legal for consistent mem? */
-	/* Reserve */
-	for (addr = (unsigned long)dmah->vaddr, sz = size;
-	     sz > 0; addr += PAGE_SIZE, sz -= PAGE_SIZE) {
-		SetPageReserved(virt_to_page((void *)addr));
-	}
-
 	return dmah;
 }
 
@@ -89,19 +78,9 @@ EXPORT_SYMBOL(drm_pci_alloc);
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
2.20.1



