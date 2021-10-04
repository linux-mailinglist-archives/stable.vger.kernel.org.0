Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8531442059E
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 07:52:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231970AbhJDFxv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 01:53:51 -0400
Received: from linux.microsoft.com ([13.77.154.182]:60670 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231935AbhJDFxv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Oct 2021 01:53:51 -0400
Received: from sequoia.work.tihix.com (162-237-133-238.lightspeed.rcsntx.sbcglobal.net [162.237.133.238])
        by linux.microsoft.com (Postfix) with ESMTPSA id 4C70E20B861E;
        Sun,  3 Oct 2021 22:52:02 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 4C70E20B861E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1633326722;
        bh=YuYuQCLYvGt135JMf9sLNe7YvbMcnd/CI+4BgHuZKCo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kfEsdLzwZug5WYvPIEV/4cLPD2GKKseDHV/tVKEo/0f/42sr8SDSqyNksDaA5FoAq
         0uJhlbdq2FqIB08qd7KO0L9fs7wc6vcSj26XwxAkLfXrBI4XZ0QdHjQK0d2KdmgAQn
         294NlfwVexASusXiyYUQh+1FOFAl6FmJkv+l8DPE=
From:   Tyler Hicks <tyhicks@linux.microsoft.com>
To:     stable@vger.kernel.org, gregkh@linuxfoundation.org
Cc:     dan.j.williams@intel.com, sumiyawang@tencent.com,
        yongduan@tencent.com
Subject: [PATCH 5.4] libnvdimm/pmem: Fix crash triggered when I/O in-flight during unbind
Date:   Mon,  4 Oct 2021 00:51:34 -0500
Message-Id: <20211004055134.677854-1-tyhicks@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <1631797319109199@kroah.com>
References: <1631797319109199@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: sumiyawang <sumiyawang@tencent.com>

commit 32b2397c1e56f33b0b1881def965bb89bd12f448 upstream.

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
[tyhicks: Minor contextual change in pmem_attach_disk() due to the
 transition to 'struct range' not yet taking place. Preserve the
 memcpy() call rather than initializing the range struct. That change
 was introduced in v5.10 with commit a4574f63edc6 ("mm/memremap_pages:
 convert to 'struct range'")]
Signed-off-by: Tyler Hicks <tyhicks@linux.microsoft.com>
---

We're seeing memory corruption issues in production and, AFAICT, we
exercise this bit of code around the time that the corruption takes
place. Therefore, I'm submitting this manually tested backport for
inclusion in linux-5.4.y since it wasn't automatically applied due to
the need for a manual backport.

 drivers/nvdimm/pmem.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index f9f76f6ba07b..7e65306b2bf2 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -423,11 +423,11 @@ static int pmem_attach_disk(struct device *dev,
 		pmem->pfn_flags |= PFN_MAP;
 		memcpy(&bb_res, &pmem->pgmap.res, sizeof(bb_res));
 	} else {
+		addr = devm_memremap(dev, pmem->phys_addr,
+				pmem->size, ARCH_MEMREMAP_PMEM);
 		if (devm_add_action_or_reset(dev, pmem_release_queue,
 					&pmem->pgmap))
 			return -ENOMEM;
-		addr = devm_memremap(dev, pmem->phys_addr,
-				pmem->size, ARCH_MEMREMAP_PMEM);
 		memcpy(&bb_res, &nsio->res, sizeof(bb_res));
 	}
 
-- 
2.25.1

