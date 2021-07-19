Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2289C3CE3EA
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:30:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242954AbhGSPlL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:41:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:59810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347925AbhGSPfU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:35:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C6EED614A5;
        Mon, 19 Jul 2021 16:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711196;
        bh=4FcsHxi4CzxlZaRAlc6eWSCvhTpDgoZ9eZ2lh8B2xhw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hBbDxKV4Yp7w3S02LiTcnIGM+cruYUSVZvw2ZpP0YCY06NUv0Hkk9JNDklPh3a/er
         aFFBJiIRY+6d4kR9xj/eMwW2KSoKx+IKzeJYSUehbVFnv8WV/JRG+e7HjnNr13Od6O
         aBsrGOBXF1wfB+FDAQXwY2Imh13rs26gPrcKzrcY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 263/351] virtio-mem: dont read big block size in Sub Block Mode
Date:   Mon, 19 Jul 2021 16:53:29 +0200
Message-Id: <20210719144953.644611723@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
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



