Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FA8DF71D
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 13:56:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730508AbfD3LtT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 07:49:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:35764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730278AbfD3LtS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:49:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1ED422054F;
        Tue, 30 Apr 2019 11:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556624957;
        bh=65QYBn1E8A27I3Z0rF4vIT4t9x+i+K9NqwwrzcVi2HI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2i6KBEitIGlR/ZHMnuVE5hMsF16LwTwNzw99Kc0YwlNWShhKTsYUOpwmq0xUvwB3R
         7WdH8Nfv8/ynOJD2DdVOcZwUBp4bAQtTgb/RKGR+3zQv2oOeWzjeNa2kbcQOi5JecB
         1qhDWBQ31xy1TzcoLnN0mo/bPK7yy/o28G2q94zY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Auger <eric.auger@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 5.0 36/89] vfio/type1: Limit DMA mappings per container
Date:   Tue, 30 Apr 2019 13:38:27 +0200
Message-Id: <20190430113611.547423041@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430113609.741196396@linuxfoundation.org>
References: <20190430113609.741196396@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/vfio/vfio_iommu_type1.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -58,12 +58,18 @@ module_param_named(disable_hugepages,
 MODULE_PARM_DESC(disable_hugepages,
 		 "Disable VFIO IOMMU support for IOMMU hugepages.");
 
+static unsigned int dma_entry_limit __read_mostly = U16_MAX;
+module_param_named(dma_entry_limit, dma_entry_limit, uint, 0644);
+MODULE_PARM_DESC(dma_entry_limit,
+		 "Maximum number of user DMA mappings per container (65535).");
+
 struct vfio_iommu {
 	struct list_head	domain_list;
 	struct vfio_domain	*external_domain; /* domain for external user */
 	struct mutex		lock;
 	struct rb_root		dma_list;
 	struct blocking_notifier_head notifier;
+	unsigned int		dma_avail;
 	bool			v2;
 	bool			nesting;
 };
@@ -836,6 +842,7 @@ static void vfio_remove_dma(struct vfio_
 	vfio_unlink_dma(iommu, dma);
 	put_task_struct(dma->task);
 	kfree(dma);
+	iommu->dma_avail++;
 }
 
 static unsigned long vfio_pgsize_bitmap(struct vfio_iommu *iommu)
@@ -1081,12 +1088,18 @@ static int vfio_dma_do_map(struct vfio_i
 		goto out_unlock;
 	}
 
+	if (!iommu->dma_avail) {
+		ret = -ENOSPC;
+		goto out_unlock;
+	}
+
 	dma = kzalloc(sizeof(*dma), GFP_KERNEL);
 	if (!dma) {
 		ret = -ENOMEM;
 		goto out_unlock;
 	}
 
+	iommu->dma_avail--;
 	dma->iova = iova;
 	dma->vaddr = vaddr;
 	dma->prot = prot;
@@ -1583,6 +1596,7 @@ static void *vfio_iommu_type1_open(unsig
 
 	INIT_LIST_HEAD(&iommu->domain_list);
 	iommu->dma_list = RB_ROOT;
+	iommu->dma_avail = dma_entry_limit;
 	mutex_init(&iommu->lock);
 	BLOCKING_INIT_NOTIFIER_HEAD(&iommu->notifier);
 


