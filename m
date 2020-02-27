Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4DB31713DA
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 10:16:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728614AbgB0JQc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 04:16:32 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:36447 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728555AbgB0JQc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Feb 2020 04:16:32 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id A111C687;
        Thu, 27 Feb 2020 04:16:30 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Thu, 27 Feb 2020 04:16:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=ZwGrmo
        LEcDnWBCMVhbHqkZ3xSJ9Y7RCefpaQhsS4tEs=; b=uCy/FFtprzY2K5yG5QiMW9
        lCCVkwrkrtkOwyGIYVuwak5zpZpZuXH2r6MAeJ8pNFM3NLuH+2jxK/mfkeS6gRdw
        kTtcNp2kBO1UAkMRt/pdD8wTQYfXtES1Lew6X2DrLxRBMrlodQTYxx0YB4XB0asK
        r3XE5RpEjxHpx8LxoFcnlcNrJdVJ1PBy1TFDMBnHfxc6D/Y2HIoz8YoNB6YgBFDM
        h4Pr+/aFuD0xqDttpaQgBw8qrQyhJko5FqB+388cPjSfpYIOGZTvbgHTgDDfX4Q8
        uFrd4pzZgzbGJX9GhPcP27PF68Swfvg7/a41UnX/AH8lj9p1IuuR4mXZiban9nVA
        ==
X-ME-Sender: <xms:7YhXXkT4Hihogur0rzVd12i2A-DT7sRF9BAo2RmAPp5TqwqYkFWFvQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrleeigddtvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepvdenuc
    frrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:7YhXXqtKs6hccyo8-BOLGryscQdPOEo11dBWahOHuJ0JZbXwiu5GNw>
    <xmx:7YhXXjxYqKbqj-IKKaeu8TTqHMmabfrBQDVLzIkhpEqQIiSZYpreGA>
    <xmx:7YhXXk4s2G_P24E_0H7UZ8QIQRqa0viAPclvnbWWrXB8wj85GYPBGw>
    <xmx:7ohXXrCDuqNbio92UARIlE3xk_WXaj3XfnxqWd4KYoLTp4mq426UHQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 820C23060FE0;
        Thu, 27 Feb 2020 04:16:29 -0500 (EST)
Subject: FAILED: patch "[PATCH] btrfs: destroy qgroup extent records on transaction abort" failed to apply to 4.19-stable tree
To:     jeffm@suse.com, dsterba@suse.com, josef@toxicpanda.com,
        wqu@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 27 Feb 2020 10:16:28 +0100
Message-ID: <1582794988238213@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
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

