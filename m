Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8718312BAF
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 09:29:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbhBHI3i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 03:29:38 -0500
Received: from mx2.suse.de ([195.135.220.15]:46946 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229711AbhBHI3h (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 03:29:37 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1612772929; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=ylYhbZ1LA4zUBDU4j1QBfyIVz9wIKU6NOfim2CguKC4=;
        b=d5Jgsb0BJWnXlIG5UOYdE4NDHTgUsEfaqea84/89ZdRwhx70CKURKpdmmsCRqoTgwmmt2a
        VKi+tiRoVv0OSpRLbYqLsZ/nU1bJAOlmL4iOxdj8uwu3Q1+zxTV4NoFAmoFJqa90TqXzKj
        v000oGUIkZhZLtMO6XWiJYc5dkG9OlQ=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id A29C6AC43;
        Mon,  8 Feb 2021 08:28:49 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>, stable@vger.kernel.org
Subject: [PATCH] btrfs: Fix race between extent freeing/allocation when using bitmaps
Date:   Mon,  8 Feb 2021 10:26:54 +0200
Message-Id: <20210208082652.2654024-1-nborisov@suse.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

During allocation the allocator will try to allocate an extent using
cluster policy. Once the current cluster is exhausted it will remove the
its entry under btrfs_free_cluster::lock and subsequently acquire
btrfs_free_space_ctl::tree_lock to dispose of the already-deleted
entry and adjust btrfs_free_space_ctl::total_bitmap. This poses a
problem because there exists a race condition between removing the
entry under one lock and doing the necessary accounting holding a
different lock since extent freeing only uses the 2nd lock. This can
result in the following situation:

T1:                                    T2:
btrfs_alloc_from_cluster               insert_into_bitmap <holds tree_lock>
 if (entry->bytes == 0)                   if (block_group && !list_empty(&block_group->cluster_list)) {
    rb_erase(entry)

 spin_unlock(&cluster->lock);
   (total_bitmaps is still 4)           spin_lock(&cluster->lock);
                                         <doesn't find entry in cluster->root>
 spin_lock(&ctl->tree_lock);             <goes to new_bitmap label, adds
<blocked since T2 holds tree_lock>       <a new entry and calls add_new_bitmap>
					    recalculate_thresholds  <crashes,
                                              due to total_bitmaps
					      becoming 5 and triggering
					      an ASSERT>

To fix this ensure that once depleted, the cluster entry is deleted when
both cluster lock and tree locks are held in the allocator (T1), this
ensures that even if there is a race with a concurrent
insert_into_bitmap call it will correctly find the entry in the cluster
and add the new space to it.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
Cc: <stable@vger.kernel.org>
---
 fs/btrfs/free-space-cache.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 0d6dcb5ff963..e386c468feaf 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -3031,8 +3031,6 @@ u64 btrfs_alloc_from_cluster(struct btrfs_block_group *block_group,
 			entry->bytes -= bytes;
 		}

-		if (entry->bytes == 0)
-			rb_erase(&entry->offset_index, &cluster->root);
 		break;
 	}
 out:
@@ -3049,7 +3047,9 @@ u64 btrfs_alloc_from_cluster(struct btrfs_block_group *block_group,
 	ctl->free_space -= bytes;
 	if (!entry->bitmap && !btrfs_free_space_trimmed(entry))
 		ctl->discardable_bytes[BTRFS_STAT_CURR] -= bytes;
+	spin_lock(&cluster->lock);
 	if (entry->bytes == 0) {
+		rb_erase(&entry->offset_index, &cluster->root);
 		ctl->free_extents--;
 		if (entry->bitmap) {
 			kmem_cache_free(btrfs_free_space_bitmap_cachep,
@@ -3062,6 +3062,7 @@ u64 btrfs_alloc_from_cluster(struct btrfs_block_group *block_group,
 		kmem_cache_free(btrfs_free_space_cachep, entry);
 	}

+	spin_unlock(&cluster->lock);
 	spin_unlock(&ctl->tree_lock);

 	return ret;
--
2.25.1

