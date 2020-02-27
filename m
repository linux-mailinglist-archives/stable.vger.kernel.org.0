Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4110B171D7E
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:21:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389739AbgB0ORl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:17:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:58130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389748AbgB0ORl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:17:41 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 28C2A2468F;
        Thu, 27 Feb 2020 14:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582813059;
        bh=NpPQdfyc5L+GRHg5wPDXDM8+oXQBfP++pwzaH75mJkA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J1/H601MRsHDvf+1PFMd6ojsqcwD1vLYqwC8gxYHcMxX3V+BWtrK6wqygtulsYIRm
         MbAHmf6rgJE/TFOJa4kIyaV5Tl3qknsAnEO5cDeuphCZX424m40V3934K0VD/q3DsL
         tQzyQKBmGTfENT1H4lV4hRryWfC8BvKOe9zd2Z88=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        Jeff Mahoney <jeffm@suse.com>, Qu Wenruo <wqu@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.5 104/150] btrfs: destroy qgroup extent records on transaction abort
Date:   Thu, 27 Feb 2020 14:37:21 +0100
Message-Id: <20200227132248.117693088@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132232.815448360@linuxfoundation.org>
References: <20200227132232.815448360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeff Mahoney <jeffm@suse.com>

commit 81f7eb00ff5bb8326e82503a32809421d14abb8a upstream.

We clean up the delayed references when we abort a transaction but we
leave the pending qgroup extent records behind, leaking memory.

This patch destroys the extent records when we destroy the delayed refs
and makes sure ensure they're gone before releasing the transaction.

Fixes: 3368d001ba5d ("btrfs: qgroup: Record possible quota-related extent for qgroup.")
CC: stable@vger.kernel.org # 4.4+
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Jeff Mahoney <jeffm@suse.com>
[ Rebased to latest upstream, remove to_qgroup() helper, use
  rbtree_postorder_for_each_entry_safe() wrapper ]
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/disk-io.c     |    1 +
 fs/btrfs/qgroup.c      |   13 +++++++++++++
 fs/btrfs/qgroup.h      |    1 +
 fs/btrfs/transaction.c |    2 ++
 4 files changed, 17 insertions(+)

--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4272,6 +4272,7 @@ static int btrfs_destroy_delayed_refs(st
 		cond_resched();
 		spin_lock(&delayed_refs->lock);
 	}
+	btrfs_qgroup_destroy_extent_records(trans);
 
 	spin_unlock(&delayed_refs->lock);
 
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -4016,3 +4016,16 @@ out:
 	}
 	return ret;
 }
+
+void btrfs_qgroup_destroy_extent_records(struct btrfs_transaction *trans)
+{
+	struct btrfs_qgroup_extent_record *entry;
+	struct btrfs_qgroup_extent_record *next;
+	struct rb_root *root;
+
+	root = &trans->delayed_refs.dirty_extent_root;
+	rbtree_postorder_for_each_entry_safe(entry, next, root, node) {
+		ulist_free(entry->old_roots);
+		kfree(entry);
+	}
+}
--- a/fs/btrfs/qgroup.h
+++ b/fs/btrfs/qgroup.h
@@ -414,5 +414,6 @@ int btrfs_qgroup_add_swapped_blocks(stru
 		u64 last_snapshot);
 int btrfs_qgroup_trace_subtree_after_cow(struct btrfs_trans_handle *trans,
 		struct btrfs_root *root, struct extent_buffer *eb);
+void btrfs_qgroup_destroy_extent_records(struct btrfs_transaction *trans);
 
 #endif
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -121,6 +121,8 @@ void btrfs_put_transaction(struct btrfs_
 		BUG_ON(!list_empty(&transaction->list));
 		WARN_ON(!RB_EMPTY_ROOT(
 				&transaction->delayed_refs.href_root.rb_root));
+		WARN_ON(!RB_EMPTY_ROOT(
+				&transaction->delayed_refs.dirty_extent_root));
 		if (transaction->delayed_refs.pending_csums)
 			btrfs_err(transaction->fs_info,
 				  "pending csums is %llu",


