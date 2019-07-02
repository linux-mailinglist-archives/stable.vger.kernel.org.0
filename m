Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A56C15CA5A
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 10:03:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727379AbfGBIDU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 04:03:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:48268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727391AbfGBIDT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 04:03:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E60C21479;
        Tue,  2 Jul 2019 08:03:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562054598;
        bh=DDWDCe5pXoo9Ostrrinsk/Zyhxnf6QK84gQMrSEiTRQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pnIsc+hQS9X+79wJbxGnsscfa2iBTyLDKxTUqUlcSnuioRPLQRlCGkbW2iNE/J+2W
         XfM68VkWBmR9ijAe0n+hQgFrVumTGNViEFXWllrB/PZVaZKeN6HSIEVbJBCsM82rdX
         rzopBPp9JQN4FP9Bj1RyysKGKq9nL9OajEpy9Ng4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
        Shakeel Butt <shakeelb@google.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH 5.1 24/55] mm: fix page cache convergence regression
Date:   Tue,  2 Jul 2019 10:01:32 +0200
Message-Id: <20190702080125.306608913@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190702080124.103022729@linuxfoundation.org>
References: <20190702080124.103022729@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Weiner <hannes@cmpxchg.org>

commit 7b785645e8f13e17cbce492708cf6e7039d32e46 upstream.

Since a28334862993 ("page cache: Finish XArray conversion"), on most
major Linux distributions, the page cache doesn't correctly transition
when the hot data set is changing, and leaves the new pages thrashing
indefinitely instead of kicking out the cold ones.

On a freshly booted, freshly ssh'd into virtual machine with 1G RAM
running stock Arch Linux:

[root@ham ~]# ./reclaimtest.sh
+ dd of=workingset-a bs=1M count=0 seek=600
+ cat workingset-a
+ cat workingset-a
+ cat workingset-a
+ cat workingset-a
+ cat workingset-a
+ cat workingset-a
+ cat workingset-a
+ cat workingset-a
+ ./mincore workingset-a
153600/153600 workingset-a
+ dd of=workingset-b bs=1M count=0 seek=600
+ cat workingset-b
+ cat workingset-b
+ cat workingset-b
+ cat workingset-b
+ ./mincore workingset-a workingset-b
104029/153600 workingset-a
120086/153600 workingset-b
+ cat workingset-b
+ cat workingset-b
+ cat workingset-b
+ cat workingset-b
+ ./mincore workingset-a workingset-b
104029/153600 workingset-a
120268/153600 workingset-b

workingset-b is a 600M file on a 1G host that is otherwise entirely
idle. No matter how often it's being accessed, it won't get cached.

While investigating, I noticed that the non-resident information gets
aggressively reclaimed - /proc/vmstat::workingset_nodereclaim. This is
a problem because a workingset transition like this relies on the
non-resident information tracked in the page cache tree of evicted
file ranges: when the cache faults are refaults of recently evicted
cache, we challenge the existing active set, and that allows a new
workingset to establish itself.

Tracing the shrinker that maintains this memory revealed that all page
cache tree nodes were allocated to the root cgroup. This is a problem,
because 1) the shrinker sizes the amount of non-resident information
it keeps to the size of the cgroup's other memory and 2) on most major
Linux distributions, only kernel threads live in the root cgroup and
everything else gets put into services or session groups:

[root@ham ~]# cat /proc/self/cgroup
0::/user.slice/user-0.slice/session-c1.scope

As a result, we basically maintain no non-resident information for the
workloads running on the system, thus breaking the caching algorithm.

Looking through the code, I found the culprit in the above-mentioned
patch: when switching from the radix tree to xarray, it dropped the
__GFP_ACCOUNT flag from the tree node allocations - the flag that
makes sure the allocated memory gets charged to and tracked by the
cgroup of the calling process - in this case, the one doing the fault.

To fix this, allow xarray users to specify per-tree flag that makes
xarray allocate nodes using __GFP_ACCOUNT. Then restore the page cache
tree annotation to request such cgroup tracking for the cache nodes.

With this patch applied, the page cache correctly converges on new
workingsets again after just a few iterations:

[root@ham ~]# ./reclaimtest.sh
+ dd of=workingset-a bs=1M count=0 seek=600
+ cat workingset-a
+ cat workingset-a
+ cat workingset-a
+ cat workingset-a
+ cat workingset-a
+ cat workingset-a
+ cat workingset-a
+ cat workingset-a
+ ./mincore workingset-a
153600/153600 workingset-a
+ dd of=workingset-b bs=1M count=0 seek=600
+ cat workingset-b
+ ./mincore workingset-a workingset-b
124607/153600 workingset-a
87876/153600 workingset-b
+ cat workingset-b
+ ./mincore workingset-a workingset-b
81313/153600 workingset-a
133321/153600 workingset-b
+ cat workingset-b
+ ./mincore workingset-a workingset-b
63036/153600 workingset-a
153600/153600 workingset-b

Cc: stable@vger.kernel.org # 4.20+
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/inode.c             |    2 +-
 include/linux/xarray.h |    1 +
 lib/xarray.c           |   12 ++++++++++--
 3 files changed, 12 insertions(+), 3 deletions(-)

--- a/fs/inode.c
+++ b/fs/inode.c
@@ -349,7 +349,7 @@ EXPORT_SYMBOL(inc_nlink);
 
 static void __address_space_init_once(struct address_space *mapping)
 {
-	xa_init_flags(&mapping->i_pages, XA_FLAGS_LOCK_IRQ);
+	xa_init_flags(&mapping->i_pages, XA_FLAGS_LOCK_IRQ | XA_FLAGS_ACCOUNT);
 	init_rwsem(&mapping->i_mmap_rwsem);
 	INIT_LIST_HEAD(&mapping->private_list);
 	spin_lock_init(&mapping->private_lock);
--- a/include/linux/xarray.h
+++ b/include/linux/xarray.h
@@ -265,6 +265,7 @@ enum xa_lock_type {
 #define XA_FLAGS_TRACK_FREE	((__force gfp_t)4U)
 #define XA_FLAGS_ZERO_BUSY	((__force gfp_t)8U)
 #define XA_FLAGS_ALLOC_WRAPPED	((__force gfp_t)16U)
+#define XA_FLAGS_ACCOUNT	((__force gfp_t)32U)
 #define XA_FLAGS_MARK(mark)	((__force gfp_t)((1U << __GFP_BITS_SHIFT) << \
 						(__force unsigned)(mark)))
 
--- a/lib/xarray.c
+++ b/lib/xarray.c
@@ -298,6 +298,8 @@ bool xas_nomem(struct xa_state *xas, gfp
 		xas_destroy(xas);
 		return false;
 	}
+	if (xas->xa->xa_flags & XA_FLAGS_ACCOUNT)
+		gfp |= __GFP_ACCOUNT;
 	xas->xa_alloc = kmem_cache_alloc(radix_tree_node_cachep, gfp);
 	if (!xas->xa_alloc)
 		return false;
@@ -325,6 +327,8 @@ static bool __xas_nomem(struct xa_state
 		xas_destroy(xas);
 		return false;
 	}
+	if (xas->xa->xa_flags & XA_FLAGS_ACCOUNT)
+		gfp |= __GFP_ACCOUNT;
 	if (gfpflags_allow_blocking(gfp)) {
 		xas_unlock_type(xas, lock_type);
 		xas->xa_alloc = kmem_cache_alloc(radix_tree_node_cachep, gfp);
@@ -358,8 +362,12 @@ static void *xas_alloc(struct xa_state *
 	if (node) {
 		xas->xa_alloc = NULL;
 	} else {
-		node = kmem_cache_alloc(radix_tree_node_cachep,
-					GFP_NOWAIT | __GFP_NOWARN);
+		gfp_t gfp = GFP_NOWAIT | __GFP_NOWARN;
+
+		if (xas->xa->xa_flags & XA_FLAGS_ACCOUNT)
+			gfp |= __GFP_ACCOUNT;
+
+		node = kmem_cache_alloc(radix_tree_node_cachep, gfp);
 		if (!node) {
 			xas_set_err(xas, -ENOMEM);
 			return NULL;


