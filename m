Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C3102011C6
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404423AbgFSPov (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:44:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:59568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404292AbgFSP1q (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:27:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A861218AC;
        Fri, 19 Jun 2020 15:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580465;
        bh=irzTMsY+KqXnyontaU8CT4smXOnZ+Pu+cz+OaDBR/XQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V5SeeummqLVirDHak4oqQSRaKF8O5zdasA/aSgZ5ZFa393DO+oh1a6z42M5lF/cUH
         5VNNezS5Ikfcbf7L6EJfo5AbGUWzyg5t3xd1l7tFqFYJ9PXmO0IVOr7pX5AYwGN6cI
         nFeeJTHglUcbZFlGh83CSUCDbaeYrO6H/FBHzOfo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.7 260/376] btrfs: force chunk allocation if our global rsv is larger than metadata
Date:   Fri, 19 Jun 2020 16:32:58 +0200
Message-Id: <20200619141722.634574244@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

commit 9c343784c4328781129bcf9e671645f69fe4b38a upstream.

Nikolay noticed a bunch of test failures with my global rsv steal
patches.  At first he thought they were introduced by them, but they've
been failing for a while with 64k nodes.

The problem is with 64k nodes we have a global reserve that calculates
out to 13MiB on a freshly made file system, which only has 8MiB of
metadata space.  Because of changes I previously made we no longer
account for the global reserve in the overcommit logic, which means we
correctly allow overcommit to happen even though we are already
overcommitted.

However in some corner cases, for example btrfs/170, we will allocate
the entire file system up with data chunks before we have enough space
pressure to allocate a metadata chunk.  Then once the fs is full we
ENOSPC out because we cannot overcommit and the global reserve is taking
up all of the available space.

The most ideal way to deal with this is to change our space reservation
stuff to take into account the height of the tree's that we're
modifying, so that our global reserve calculation does not end up so
obscenely large.

However that is a huge undertaking.  Instead fix this by forcing a chunk
allocation if the global reserve is larger than the total metadata
space.  This gives us essentially the same behavior that happened
before, we get a chunk allocated and these tests can pass.

This is meant to be a stop-gap measure until we can tackle the "tree
height only" project.

Fixes: 0096420adb03 ("btrfs: do not account global reserve in can_overcommit")
CC: stable@vger.kernel.org # 5.4+
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Tested-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/block-rsv.c   |    3 +++
 fs/btrfs/transaction.c |   18 ++++++++++++++++++
 2 files changed, 21 insertions(+)

--- a/fs/btrfs/block-rsv.c
+++ b/fs/btrfs/block-rsv.c
@@ -5,6 +5,7 @@
 #include "block-rsv.h"
 #include "space-info.h"
 #include "transaction.h"
+#include "block-group.h"
 
 /*
  * HOW DO BLOCK RESERVES WORK
@@ -405,6 +406,8 @@ void btrfs_update_global_block_rsv(struc
 	else
 		block_rsv->full = 0;
 
+	if (block_rsv->size >= sinfo->total_bytes)
+		sinfo->force_alloc = CHUNK_ALLOC_FORCE;
 	spin_unlock(&block_rsv->lock);
 	spin_unlock(&sinfo->lock);
 }
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -21,6 +21,7 @@
 #include "dev-replace.h"
 #include "qgroup.h"
 #include "block-group.h"
+#include "space-info.h"
 
 #define BTRFS_ROOT_TRANS_TAG 0
 
@@ -523,6 +524,7 @@ start_transaction(struct btrfs_root *roo
 	u64 num_bytes = 0;
 	u64 qgroup_reserved = 0;
 	bool reloc_reserved = false;
+	bool do_chunk_alloc = false;
 	int ret;
 
 	/* Send isn't supposed to start transactions. */
@@ -585,6 +587,9 @@ start_transaction(struct btrfs_root *roo
 							  delayed_refs_bytes);
 			num_bytes -= delayed_refs_bytes;
 		}
+
+		if (rsv->space_info->force_alloc)
+			do_chunk_alloc = true;
 	} else if (num_items == 0 && flush == BTRFS_RESERVE_FLUSH_ALL &&
 		   !delayed_refs_rsv->full) {
 		/*
@@ -667,6 +672,19 @@ got_it:
 		current->journal_info = h;
 
 	/*
+	 * If the space_info is marked ALLOC_FORCE then we'll get upgraded to
+	 * ALLOC_FORCE the first run through, and then we won't allocate for
+	 * anybody else who races in later.  We don't care about the return
+	 * value here.
+	 */
+	if (do_chunk_alloc && num_bytes) {
+		u64 flags = h->block_rsv->space_info->flags;
+
+		btrfs_chunk_alloc(h, btrfs_get_alloc_profile(fs_info, flags),
+				  CHUNK_ALLOC_NO_FORCE);
+	}
+
+	/*
 	 * btrfs_record_root_in_trans() needs to alloc new extents, and may
 	 * call btrfs_join_transaction() while we're also starting a
 	 * transaction.


