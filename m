Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 660CD11A3C
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 15:33:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726268AbfEBNdd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 09:33:33 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:38630 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726267AbfEBNdd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 May 2019 09:33:33 -0400
Received: by mail-pg1-f193.google.com with SMTP id j26so1074043pgl.5
        for <stable@vger.kernel.org>; Thu, 02 May 2019 06:33:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=SjOzCbd+VkJ3BPjVFCxoRZHljW/fdoULtx2bTSB/08A=;
        b=DC/vKPy7fv4TOyPiTmzLihNIDFsIW0ysvh7f4QZtnlrtr+RiS/NwG0uK+tfRos6oRx
         ro5hOL0WAqHiVRwM952W/uE6uiK1oFSR9ytfxzdlmS5/l771AvBfBy5grwEcVW1pQZnT
         VitfNPXiZGPQtrh1NcDN4f7L+6tHZw24Kp1ZFKC++VrSZuWNG9XroARqcJMmaMwbBQTQ
         MWkQMhVAE193XisU1C1VjEDCrj6FImY4vhxy6+UnETzHE/nmluPHgowOR1hZIDwZBfey
         ecQtUvRlqCu9gmPihbvhjfQtRx1EhHSXWM9nw4BVuS5dg5s6KGjykDnoLADjDBnBS8/P
         xtVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=SjOzCbd+VkJ3BPjVFCxoRZHljW/fdoULtx2bTSB/08A=;
        b=lcMJiHwA8KTP/nh7XEwXVX/eclWurAi7pkeHoqHwHWgLrwtCPx9N8oLW/giKP3ZaoD
         whRKkMVznp4sXroD2TUjmVwVxCNOoVbkjgv0Psp2nA2JfJxH7DSH8e36X+7BBfjMvgnu
         zaH+IZqWcNoXaEiXcR7FA+xNLjAGj8I9SopEAAjqmcnEickQVG7Pb2jDA5H7VrdxY3fc
         o2KKzp8kh+xST2NmTfI1pfr1v9rlr4CbIYhGzJ0UvJmMrz0LGfu6kCvxkHfnhTQtZRG3
         Xpwmskt0x8yyxaey5Y6mxYmIWGs6+RKt6x+5VooanTZDPg8kxkPPqoElGhvXagZGm6ol
         XgeQ==
X-Gm-Message-State: APjAAAUobI4UXYxYXj3J0HKWJ+Yw4zvBiAXk2VMfj0GJNr5hgtKtUyaR
        GwAeelL7QUvDYXKZirEEuiQxyl30
X-Google-Smtp-Source: APXvYqwa8p7+TVgeLXfUN41uPLg9AYar5b8XkrprSE2N24kGB0JWzk4r5SNjfoMI+ZDTJTNrZPWK9g==
X-Received: by 2002:a62:5445:: with SMTP id i66mr4147099pfb.250.1556804012200;
        Thu, 02 May 2019 06:33:32 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id k14sm33200223pfj.171.2019.05.02.06.33.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 May 2019 06:33:30 -0700 (PDT)
From:   Guenter Roeck <linux@roeck-us.net>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH v4.4,v4.9] vfio/type1: Limit DMA mappings per container
Date:   Thu,  2 May 2019 06:33:23 -0700
Message-Id: <1556804003-2561-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 2.7.4
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
---
 drivers/vfio/vfio_iommu_type1.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 2fa280671c1e..875634d0d020 100644
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
@@ -382,6 +388,7 @@ static void vfio_remove_dma(struct vfio_iommu *iommu, struct vfio_dma *dma)
 	vfio_unmap_unpin(iommu, dma);
 	vfio_unlink_dma(iommu, dma);
 	kfree(dma);
+	iommu->dma_avail++;
 }
 
 static unsigned long vfio_pgsize_bitmap(struct vfio_iommu *iommu)
@@ -582,12 +589,18 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
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
@@ -903,6 +916,7 @@ static void *vfio_iommu_type1_open(unsigned long arg)
 
 	INIT_LIST_HEAD(&iommu->domain_list);
 	iommu->dma_list = RB_ROOT;
+	iommu->dma_avail = dma_entry_limit;
 	mutex_init(&iommu->lock);
 
 	return iommu;
-- 
2.7.4

