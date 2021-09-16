Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C3B640E8BC
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 20:00:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356137AbhIPRpM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:45:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:57148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355706AbhIPRmB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:42:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD8A063270;
        Thu, 16 Sep 2021 16:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631811247;
        bh=HVB9kR55wmasf7kodz7LehfsL3we6+HIetYGCH/BOG8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uqK0zuv2d0VMxqHpo3IuRuFJB/myGlM/eAZKxwuM+OmBWbQ3c9yHD5q5ZfBwD2q3w
         e3ebh+wOutG51CsXitsKQ5GMvLlALP7EhZqY6ou/5hXqIW0OHYThjNHwfrmwx3W71o
         Dtyl3meHBH+smn5eetmgc3zCcbWLUgeJLLWs1pNI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, sumiyawang <sumiyawang@tencent.com>,
        yongduan <yongduan@tencent.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 5.14 411/432] libnvdimm/pmem: Fix crash triggered when I/O in-flight during unbind
Date:   Thu, 16 Sep 2021 18:02:40 +0200
Message-Id: <20210916155824.774465126@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvdimm/pmem.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -450,11 +450,11 @@ static int pmem_attach_disk(struct devic
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


