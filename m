Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 544CE1598F
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 07:37:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727948AbfEGFhx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 01:37:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:57652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726492AbfEGFhv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 01:37:51 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 170BE20675;
        Tue,  7 May 2019 05:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207470;
        bh=Oud8qUkPlLbB9a6qg14+M/3sEvYqAYptLUqBaWDOX60=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=15huqM1HMuEYyBXxLMYJx4OwaYGmGEaHo52KgweRUzU+3xT/JMYe4ybUKiAAFL+db
         AS/gu4pltX0QIX/n4rwkQsTXpwnWrdF6QBaE1D5vIqlOc7pS6W/tqZa1R/kKEiq1W2
         /VVGBfkk65RDrk9mfsl6Qhmv9rh9u6FEoQ2JcDxk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 61/81] btrfs: Switch memory allocations in async csum calculation path to kvmalloc
Date:   Tue,  7 May 2019 01:35:32 -0400
Message-Id: <20190507053554.30848-61-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053554.30848-1-sashal@kernel.org>
References: <20190507053554.30848-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikolay Borisov <nborisov@suse.com>

[ Upstream commit a3d46aea46f99d134b4e0726e4826b824c3e5980 ]

Recent multi-page biovec rework allowed creation of bios that can span
large regions - up to 128 megabytes in the case of btrfs. OTOH btrfs'
submission path currently allocates a contiguous array to store the
checksums for every bio submitted. This means we can request up to
(128mb / BTRFS_SECTOR_SIZE) * 4 bytes + 32bytes of memory from kmalloc.
On busy systems with possibly fragmented memory said kmalloc can fail
which will trigger BUG_ON due to improper error handling IO submission
context in btrfs.

Until error handling is improved or bios in btrfs limited to a more
manageable size (e.g. 1m) let's use kvmalloc to fallback to vmalloc for
such large allocations. There is no hard requirement that the memory
allocated for checksums during IO submission has to be contiguous, but
this is a simple fix that does not require several non-contiguous
allocations.

For small writes this is unlikely to have any visible effect since
kmalloc will still satisfy allocation requests as usual. For larger
requests the code will just fallback to vmalloc.

We've performed evaluation on several workload types and there was no
significant difference kmalloc vs kvmalloc.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/file-item.c    | 15 +++++++++++----
 fs/btrfs/ordered-data.c |  3 ++-
 2 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index ba74827beb32..2ba8de8c0d17 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -7,6 +7,7 @@
 #include <linux/slab.h>
 #include <linux/pagemap.h>
 #include <linux/highmem.h>
+#include <linux/sched/mm.h>
 #include "ctree.h"
 #include "disk-io.h"
 #include "transaction.h"
@@ -434,9 +435,13 @@ blk_status_t btrfs_csum_one_bio(struct inode *inode, struct bio *bio,
 	unsigned long this_sum_bytes = 0;
 	int i;
 	u64 offset;
+	unsigned nofs_flag;
+
+	nofs_flag = memalloc_nofs_save();
+	sums = kvzalloc(btrfs_ordered_sum_size(fs_info, bio->bi_iter.bi_size),
+		       GFP_KERNEL);
+	memalloc_nofs_restore(nofs_flag);
 
-	sums = kzalloc(btrfs_ordered_sum_size(fs_info, bio->bi_iter.bi_size),
-		       GFP_NOFS);
 	if (!sums)
 		return BLK_STS_RESOURCE;
 
@@ -479,8 +484,10 @@ blk_status_t btrfs_csum_one_bio(struct inode *inode, struct bio *bio,
 
 				bytes_left = bio->bi_iter.bi_size - total_bytes;
 
-				sums = kzalloc(btrfs_ordered_sum_size(fs_info, bytes_left),
-					       GFP_NOFS);
+				nofs_flag = memalloc_nofs_save();
+				sums = kvzalloc(btrfs_ordered_sum_size(fs_info,
+						      bytes_left), GFP_KERNEL);
+				memalloc_nofs_restore(nofs_flag);
 				BUG_ON(!sums); /* -ENOMEM */
 				sums->len = bytes_left;
 				ordered = btrfs_lookup_ordered_extent(inode,
diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index 0c4ef208b8b9..b92edf0600e3 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -6,6 +6,7 @@
 #include <linux/slab.h>
 #include <linux/blkdev.h>
 #include <linux/writeback.h>
+#include <linux/sched/mm.h>
 #include "ctree.h"
 #include "transaction.h"
 #include "btrfs_inode.h"
@@ -442,7 +443,7 @@ void btrfs_put_ordered_extent(struct btrfs_ordered_extent *entry)
 			cur = entry->list.next;
 			sum = list_entry(cur, struct btrfs_ordered_sum, list);
 			list_del(&sum->list);
-			kfree(sum);
+			kvfree(sum);
 		}
 		kmem_cache_free(btrfs_ordered_extent_cache, entry);
 	}
-- 
2.20.1

