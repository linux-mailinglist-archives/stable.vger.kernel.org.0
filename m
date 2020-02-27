Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F40201713DC
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 10:16:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728629AbgB0JQl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 04:16:41 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:55313 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728555AbgB0JQl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Feb 2020 04:16:41 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 23D8B610;
        Thu, 27 Feb 2020 04:16:40 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Thu, 27 Feb 2020 04:16:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=OzavhL
        dM55rXCchUS/YJmqd1bhsLM6OnaVgFxJ5pN88=; b=AMFt2WHdZCvF4pLITmqL2j
        3nRiMVxb9brGHgLBZp2TPHKXG2Uho9ms7R+utD/W8nvelNGSAA3mUyioSZAuz/kA
        lxl414lOJ0rBRtyPHgBYeu6IQHGR4L1RZdeY1tl0rZss+GmgBPeEcF+qbwobhQ3r
        PzTWHzdpV1RwQOXODEJyx/2vRHiGjJYGj0vQWYf6b2ecnp3YB6s+NSgvWo5h0OnZ
        o7r/1Bj1W9GaxRJ8UClbyKQyrYAdbP425ZarUNKLRcPNhSgW04Ixt1V1xSBQ++ET
        Oetl3nRGGO1wb92Qf+XGf7YGH09gkQE2aLiI6JH8nzE/D76kKxEkPnH52Q2JdN2w
        ==
X-ME-Sender: <xms:94hXXrrBiYWtCcVddun3f3MThCwffzjrr5fGCBLu9FOnDtq0mWiuRA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrleeigddtvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepfeenuc
    frrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:94hXXgVx0qW_VT82Jy5a0YXNlVwXi_yGVdF7cTfgLbvjcAUA0VyI6g>
    <xmx:94hXXu1PgD9wgS5Cp4PlypalI51lUZ5bXfNSFYwqjx_m0R2nG8bYuw>
    <xmx:94hXXp2RFSNiYON9CYoYQAgam6fMpnDAdfW3uEox8hWDxf4bB5lpqw>
    <xmx:94hXXhDQISvPhbTjLlgTl35u_4pQv5vEmM1_T-f-kN8K3xMoi2XivA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 48DB43060BD1;
        Thu, 27 Feb 2020 04:16:39 -0500 (EST)
Subject: FAILED: patch "[PATCH] btrfs: destroy qgroup extent records on transaction abort" failed to apply to 4.4-stable tree
To:     jeffm@suse.com, dsterba@suse.com, josef@toxicpanda.com,
        wqu@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 27 Feb 2020 10:16:29 +0100
Message-ID: <158279498914394@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 81f7eb00ff5bb8326e82503a32809421d14abb8a Mon Sep 17 00:00:00 2001
From: Jeff Mahoney <jeffm@suse.com>
Date: Tue, 11 Feb 2020 15:25:37 +0800
Subject: [PATCH] btrfs: destroy qgroup extent records on transaction abort

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

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 89422aa8e9d1..d7fec89974cb 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4276,6 +4276,7 @@ static int btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
 		cond_resched();
 		spin_lock(&delayed_refs->lock);
 	}
+	btrfs_qgroup_destroy_extent_records(trans);
 
 	spin_unlock(&delayed_refs->lock);
 
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 98d9a50352d6..ff1870ff3474 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -4002,3 +4002,16 @@ int btrfs_qgroup_trace_subtree_after_cow(struct btrfs_trans_handle *trans,
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
diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
index 236f12224d52..1bc654459469 100644
--- a/fs/btrfs/qgroup.h
+++ b/fs/btrfs/qgroup.h
@@ -414,5 +414,6 @@ int btrfs_qgroup_add_swapped_blocks(struct btrfs_trans_handle *trans,
 		u64 last_snapshot);
 int btrfs_qgroup_trace_subtree_after_cow(struct btrfs_trans_handle *trans,
 		struct btrfs_root *root, struct extent_buffer *eb);
+void btrfs_qgroup_destroy_extent_records(struct btrfs_transaction *trans);
 
 #endif
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 33dcc88b428a..beb6c69cd1e5 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -121,6 +121,8 @@ void btrfs_put_transaction(struct btrfs_transaction *transaction)
 		BUG_ON(!list_empty(&transaction->list));
 		WARN_ON(!RB_EMPTY_ROOT(
 				&transaction->delayed_refs.href_root.rb_root));
+		WARN_ON(!RB_EMPTY_ROOT(
+				&transaction->delayed_refs.dirty_extent_root));
 		if (transaction->delayed_refs.pending_csums)
 			btrfs_err(transaction->fs_info,
 				  "pending csums is %llu",

