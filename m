Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6246440DA91
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 15:02:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239777AbhIPNDY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 09:03:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:56436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239574AbhIPNDW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 09:03:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E0BD60ED7;
        Thu, 16 Sep 2021 13:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631797322;
        bh=oADMNIyNnMD121e55Qb26wP/rO9jI/qqW+xcgookqCc=;
        h=Subject:To:Cc:From:Date:From;
        b=AhsgYvloFtU2z+WfVlYZ9imOqSZelI0zrmk2khsKW2IiEFjfITiejEo3FccxV698W
         Hx0WOSyU4clSoa4DN6rV3TxX1lkpWYawG8Y3M2Ty6nOqAiz2DbbS1aEQMS4Jl9CreM
         HN3mODSByRm0NUOQAO8N3pxL7hW4CrLrJ+BNF2C4=
Subject: FAILED: patch "[PATCH] libnvdimm/pmem: Fix crash triggered when I/O in-flight during" failed to apply to 5.4-stable tree
To:     sumiyawang@tencent.com, dan.j.williams@intel.com,
        stable@vger.kernel.org, yongduan@tencent.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 16 Sep 2021 15:01:59 +0200
Message-ID: <1631797319109199@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 32b2397c1e56f33b0b1881def965bb89bd12f448 Mon Sep 17 00:00:00 2001
From: sumiyawang <sumiyawang@tencent.com>
Date: Sun, 22 Aug 2021 19:49:09 +0800
Subject: [PATCH] libnvdimm/pmem: Fix crash triggered when I/O in-flight during
 unbind

There is a use after free crash when the pmem driver tears down its
mapping while I/O is still inbound.

This is triggered by driver unbind, "ndctl destroy-namespace", while I/O
is in flight.

Fix the sequence of blk_cleanup_queue() vs memunmap().

The crash signature is of the form:

 BUG: unable to handle page fault for address: ffffc90080200000
 CPU: 36 PID: 9606 Comm: systemd-udevd
 Call Trace:
  ? pmem_do_bvec+0xf9/0x3a0
  ? xas_alloc+0x55/0xd0
  pmem_rw_page+0x4b/0x80
  bdev_read_page+0x86/0xb0
  do_mpage_readpage+0x5d4/0x7a0
  ? lru_cache_add+0xe/0x10
  mpage_readpages+0xf9/0x1c0
  ? bd_link_disk_holder+0x1a0/0x1a0
  blkdev_readpages+0x1d/0x20
  read_pages+0x67/0x1a0

  ndctl Call Trace in vmcore:
  PID: 23473  TASK: ffff88c4fbbe8000  CPU: 1   COMMAND: "ndctl"
  __schedule
  schedule
  blk_mq_freeze_queue_wait
  blk_freeze_queue
  blk_cleanup_queue
  pmem_release_queue
  devm_action_release
  release_nodes
  devres_release_all
  device_release_driver_internal
  device_driver_detach
  unbind_store

Cc: <stable@vger.kernel.org>
Signed-off-by: sumiyawang <sumiyawang@tencent.com>
Reviewed-by: yongduan <yongduan@tencent.com>
Link: https://lore.kernel.org/r/1629632949-14749-1-git-send-email-sumiyawang@tencent.com
Fixes: 50f44ee7248a ("mm/devm_memremap_pages: fix final page put race")
Signed-off-by: Dan Williams <dan.j.williams@intel.com>

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 1e0615b8565e..72de88ff0d30 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -450,11 +450,11 @@ static int pmem_attach_disk(struct device *dev,
 		pmem->pfn_flags |= PFN_MAP;
 		bb_range = pmem->pgmap.range;
 	} else {
+		addr = devm_memremap(dev, pmem->phys_addr,
+				pmem->size, ARCH_MEMREMAP_PMEM);
 		if (devm_add_action_or_reset(dev, pmem_release_queue,
 					&pmem->pgmap))
 			return -ENOMEM;
-		addr = devm_memremap(dev, pmem->phys_addr,
-				pmem->size, ARCH_MEMREMAP_PMEM);
 		bb_range.start =  res->start;
 		bb_range.end = res->end;
 	}

