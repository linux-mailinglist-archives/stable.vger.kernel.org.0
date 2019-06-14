Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BA0B45438
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 07:46:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726082AbfFNFqJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jun 2019 01:46:09 -0400
Received: from mx2.suse.de ([195.135.220.15]:44212 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725907AbfFNFqJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Jun 2019 01:46:09 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 05224AF0B;
        Fri, 14 Jun 2019 05:46:07 +0000 (UTC)
From:   Juergen Gross <jgross@suse.com>
To:     xen-devel@lists.xenproject.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Cc:     Juergen Gross <jgross@suse.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH v3 1/3] xen/swiotlb: fix condition for calling xen_destroy_contiguous_region()
Date:   Fri, 14 Jun 2019 07:46:02 +0200
Message-Id: <20190614054604.30101-2-jgross@suse.com>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190614054604.30101-1-jgross@suse.com>
References: <20190614054604.30101-1-jgross@suse.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The condition in xen_swiotlb_free_coherent() for deciding whether to
call xen_destroy_contiguous_region() is wrong: in case the region to
be freed is not contiguous calling xen_destroy_contiguous_region() is
the wrong thing to do: it would result in inconsistent mappings of
multiple PFNs to the same MFN. This will lead to various strange
crashes or data corruption.

Instead of calling xen_destroy_contiguous_region() in that case a
warning should be issued as that situation should never occur.

Cc: stable@vger.kernel.org
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Reviewed-by: Jan Beulich <jbeulich@suse.com>
---
V2: always issue a warning in case xen_destroy_contiguous_region()
    isn't called (Jan Beulich)
---
 drivers/xen/swiotlb-xen.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
index d53f3493a6b9..50fd7de54969 100644
--- a/drivers/xen/swiotlb-xen.c
+++ b/drivers/xen/swiotlb-xen.c
@@ -361,8 +361,8 @@ xen_swiotlb_free_coherent(struct device *hwdev, size_t size, void *vaddr,
 	/* Convert the size to actually allocated. */
 	size = 1UL << (order + XEN_PAGE_SHIFT);
 
-	if (((dev_addr + size - 1 <= dma_mask)) ||
-	    range_straddles_page_boundary(phys, size))
+	if (!WARN_ON((dev_addr + size - 1 > dma_mask) ||
+		     range_straddles_page_boundary(phys, size)))
 		xen_destroy_contiguous_region(phys, order);
 
 	xen_free_coherent_pages(hwdev, size, vaddr, (dma_addr_t)phys, attrs);
-- 
2.16.4

