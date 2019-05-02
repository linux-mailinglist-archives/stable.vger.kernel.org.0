Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC3B111F80
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 17:52:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726755AbfEBPsx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 11:48:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:38504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726809AbfEBPW6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 May 2019 11:22:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9FAF220C01;
        Thu,  2 May 2019 15:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556810577;
        bh=xEwRVn6vW+YzMDRZ0xmL2n1BTiwlSjzDzU4hfBMfsfY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dL3eAgAwngHPuZY+5oEZ8RhCFph5V69Oy926PDModq7Z2NGhV3FV8kWFcbpK0cP/r
         7wzZaj3IeRfbQ9Hn6H/1+lUQVxDGHI33RBtEKSaa6ebxfV+GrGxL85ro7SRpme/ZwH
         /NY4Eo0dTk9OgjUlaRDV+eEJmkZgO0UDAgfIshTk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Auger <eric.auger@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4.9 32/32] vfio/type1: Limit DMA mappings per container
Date:   Thu,  2 May 2019 17:21:18 +0200
Message-Id: <20190502143323.641847384@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190502143314.649935114@linuxfoundation.org>
References: <20190502143314.649935114@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Williamson <alex.williamson@redhat.com>

commit 492855939bdb59c6f947b0b5b44af9ad82b7e38c upstream.

Memory backed DMA mappings are accounted against a user's locked
memory limit, including multiple mappings of the same memory.  This
accounting bounds the number of such mappings that a user can create.
However, DMA mappings that are not backed by memory, such as DMA
mappings of device MMIO via mmaps, do not make use of page pinning
and therefore do not count against the user's locked memory limit.
These mappings still consume memory, but the memory is not well
associated to the process for the purpose of oom killing a task.

To add bounding on this use case, we introduce a limit to the total
number of concurrent DMA mappings that a user is allowed to create.
This limit is exposed as a tunable module option where the default
value of 64K is expected to be well in excess of any reasonable use
case (a large virtual machine configuration would typically only make
use of tens of concurrent mappings).

This fixes CVE-2019-3882.

Reviewed-by: Eric Auger <eric.auger@redhat.com>
Tested-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
[groeck: Adjust for missing upstream commit]
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vfio/vfio_iommu_type1.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -53,10 +53,16 @@ module_param_named(disable_hugepages,
 MODULE_PARM_DESC(disable_hugepages,
 		 "Disable VFIO IOMMU support for IOMMU hugepages.");
 
+static unsigned int dma_entry_limit __read_mostly = U16_MAX;
+module_param_named(dma_entry_limit, dma_entry_limit, uint, 0644);
+MODULE_PARM_DESC(dma_entry_limit,
+		 "Maximum number of user DMA mappings per container (65535).");
+
 struct vfio_iommu {
 	struct list_head	domain_list;
 	struct mutex		lock;
 	struct rb_root		dma_list;
+	unsigned int		dma_avail;
 	bool			v2;
 	bool			nesting;
 };
@@ -384,6 +390,7 @@ static void vfio_remove_dma(struct vfio_
 	vfio_unmap_unpin(iommu, dma);
 	vfio_unlink_dma(iommu, dma);
 	kfree(dma);
+	iommu->dma_avail++;
 }
 
 static unsigned long vfio_pgsize_bitmap(struct vfio_iommu *iommu)
@@ -584,12 +591,18 @@ static int vfio_dma_do_map(struct vfio_i
 		return -EEXIST;
 	}
 
+	if (!iommu->dma_avail) {
+		mutex_unlock(&iommu->lock);
+		return -ENOSPC;
+	}
+
 	dma = kzalloc(sizeof(*dma), GFP_KERNEL);
 	if (!dma) {
 		mutex_unlock(&iommu->lock);
 		return -ENOMEM;
 	}
 
+	iommu->dma_avail--;
 	dma->iova = iova;
 	dma->vaddr = vaddr;
 	dma->prot = prot;
@@ -905,6 +918,7 @@ static void *vfio_iommu_type1_open(unsig
 
 	INIT_LIST_HEAD(&iommu->domain_list);
 	iommu->dma_list = RB_ROOT;
+	iommu->dma_avail = dma_entry_limit;
 	mutex_init(&iommu->lock);
 
 	return iommu;


