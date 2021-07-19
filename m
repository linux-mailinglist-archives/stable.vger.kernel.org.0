Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA6363CE573
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:41:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349341AbhGSPuN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:50:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:47932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242613AbhGSPqS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:46:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F19E60FE9;
        Mon, 19 Jul 2021 16:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626712016;
        bh=4FcsHxi4CzxlZaRAlc6eWSCvhTpDgoZ9eZ2lh8B2xhw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vs03qZN74HKVAGWpicNdsxOLbSkj+mJ4jtYOLriu8oQvaAXWOE+Jds3WdvCuDsjWW
         iCT5bV5j5pa6d/JTfubFiJ/aQCacGo5D1ea45YQJ60BwYDD4tMd+VARiqUYpiDHkDM
         v71EyJP3Wxu4Esw4EcvsAk+lSCvIqOdybROUmkeA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 217/292] virtio-mem: dont read big block size in Sub Block Mode
Date:   Mon, 19 Jul 2021 16:54:39 +0200
Message-Id: <20210719144950.124458040@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.514164272@linuxfoundation.org>
References: <20210719144942.514164272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Hildenbrand <david@redhat.com>

[ Upstream commit 500817bf5e110ad9b7138bc582971bb7ee77d6f7 ]

We are reading a Big Block Mode value while in Sub Block Mode
when initializing. Fortunately, vm->bbm.bb_size maps to some counter
in the vm->sbm.mb_count array, which is 0 at that point in time.

No harm done; still, this was unintended and is not future-proof.

Fixes: 4ba50cd3355d ("virtio-mem: Big Block Mode (BBM) memory hotplug")
Signed-off-by: David Hildenbrand <david@redhat.com>
Link: https://lore.kernel.org/r/20210602185720.31821-2-david@redhat.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/virtio/virtio_mem.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/virtio/virtio_mem.c b/drivers/virtio/virtio_mem.c
index 10ec60d81e84..3bf08b5bb359 100644
--- a/drivers/virtio/virtio_mem.c
+++ b/drivers/virtio/virtio_mem.c
@@ -2420,6 +2420,10 @@ static int virtio_mem_init(struct virtio_mem *vm)
 		dev_warn(&vm->vdev->dev,
 			 "Some device memory is not addressable/pluggable. This can make some memory unusable.\n");
 
+	/* Prepare the offline threshold - make sure we can add two blocks. */
+	vm->offline_threshold = max_t(uint64_t, 2 * memory_block_size_bytes(),
+				      VIRTIO_MEM_DEFAULT_OFFLINE_THRESHOLD);
+
 	/*
 	 * We want subblocks to span at least MAX_ORDER_NR_PAGES and
 	 * pageblock_nr_pages pages. This:
@@ -2466,14 +2470,11 @@ static int virtio_mem_init(struct virtio_mem *vm)
 		       vm->bbm.bb_size - 1;
 		vm->bbm.first_bb_id = virtio_mem_phys_to_bb_id(vm, addr);
 		vm->bbm.next_bb_id = vm->bbm.first_bb_id;
-	}
 
-	/* Prepare the offline threshold - make sure we can add two blocks. */
-	vm->offline_threshold = max_t(uint64_t, 2 * memory_block_size_bytes(),
-				      VIRTIO_MEM_DEFAULT_OFFLINE_THRESHOLD);
-	/* In BBM, we also want at least two big blocks. */
-	vm->offline_threshold = max_t(uint64_t, 2 * vm->bbm.bb_size,
-				      vm->offline_threshold);
+		/* Make sure we can add two big blocks. */
+		vm->offline_threshold = max_t(uint64_t, 2 * vm->bbm.bb_size,
+					      vm->offline_threshold);
+	}
 
 	dev_info(&vm->vdev->dev, "start address: 0x%llx", vm->addr);
 	dev_info(&vm->vdev->dev, "region size: 0x%llx", vm->region_size);
-- 
2.30.2



