Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 227633EB89C
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 17:26:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241946AbhHMPOv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 11:14:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:54986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241380AbhHMPN6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Aug 2021 11:13:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B9B1461153;
        Fri, 13 Aug 2021 15:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628867602;
        bh=oN4t9KHoIysBwjmc+ZF5f7ORML5e+3rH53RD+H6R2d8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=repzAXxFcFyefbVXCEX8gnYDFJiie2zAfg+8stdiYSDYcX9CkZx5EeVXEF/tPdKQ9
         gVMhk7CY7ry7ZDwBqD0Sn+O9+FSgKDTLw0Srea8dauL64Br16AwuIsQz08WvoVo3b5
         tTQqp3jXnvTKUZwkrDsqS82/7fr/5nPOLwVF3l28=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>,
        Anand Jain <anand.jain@oracle.com>
Subject: [PATCH 5.4 19/27] btrfs: qgroup: allow to unreserve range without releasing other ranges
Date:   Fri, 13 Aug 2021 17:07:17 +0200
Message-Id: <20210813150523.997531716@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210813150523.364549385@linuxfoundation.org>
References: <20210813150523.364549385@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

commit 263da812e87bac4098a4778efaa32c54275641db upstream

[PROBLEM]
Before this patch, when btrfs_qgroup_reserve_data() fails, we free all
reserved space of the changeset.

For example:
	ret = btrfs_qgroup_reserve_data(inode, changeset, 0, SZ_1M);
	ret = btrfs_qgroup_reserve_data(inode, changeset, SZ_1M, SZ_1M);
	ret = btrfs_qgroup_reserve_data(inode, changeset, SZ_2M, SZ_1M);

If the last btrfs_qgroup_reserve_data() failed, it will release the
entire [0, 3M) range.

This behavior is kind of OK for now, as when we hit -EDQUOT, we normally
go error handling and need to release all reserved ranges anyway.

But this also means the following call is not possible:

	ret = btrfs_qgroup_reserve_data();
	if (ret == -EDQUOT) {
		/* Do something to free some qgroup space */
		ret = btrfs_qgroup_reserve_data();
	}

As if the first btrfs_qgroup_reserve_data() fails, it will free all
reserved qgroup space.

[CAUSE]
This is because we release all reserved ranges when
btrfs_qgroup_reserve_data() fails.

[FIX]
This patch will implement a new function, qgroup_unreserve_range(), to
iterate through the ulist nodes, to find any nodes in the failure range,
and remove the EXTENT_QGROUP_RESERVED bits from the io_tree, and
decrease the extent_changeset::bytes_changed, so that we can revert to
previous state.

This allows later patches to retry btrfs_qgroup_reserve_data() if EDQUOT
happens.

Suggested-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/qgroup.c |   92 +++++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 77 insertions(+), 15 deletions(-)

--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -3411,6 +3411,73 @@ btrfs_qgroup_rescan_resume(struct btrfs_
 	}
 }
 
+#define rbtree_iterate_from_safe(node, next, start)				\
+       for (node = start; node && ({ next = rb_next(node); 1;}); node = next)
+
+static int qgroup_unreserve_range(struct btrfs_inode *inode,
+				  struct extent_changeset *reserved, u64 start,
+				  u64 len)
+{
+	struct rb_node *node;
+	struct rb_node *next;
+	struct ulist_node *entry = NULL;
+	int ret = 0;
+
+	node = reserved->range_changed.root.rb_node;
+	while (node) {
+		entry = rb_entry(node, struct ulist_node, rb_node);
+		if (entry->val < start)
+			node = node->rb_right;
+		else if (entry)
+			node = node->rb_left;
+		else
+			break;
+	}
+
+	/* Empty changeset */
+	if (!entry)
+		return 0;
+
+	if (entry->val > start && rb_prev(&entry->rb_node))
+		entry = rb_entry(rb_prev(&entry->rb_node), struct ulist_node,
+				 rb_node);
+
+	rbtree_iterate_from_safe(node, next, &entry->rb_node) {
+		u64 entry_start;
+		u64 entry_end;
+		u64 entry_len;
+		int clear_ret;
+
+		entry = rb_entry(node, struct ulist_node, rb_node);
+		entry_start = entry->val;
+		entry_end = entry->aux;
+		entry_len = entry_end - entry_start + 1;
+
+		if (entry_start >= start + len)
+			break;
+		if (entry_start + entry_len <= start)
+			continue;
+		/*
+		 * Now the entry is in [start, start + len), revert the
+		 * EXTENT_QGROUP_RESERVED bit.
+		 */
+		clear_ret = clear_extent_bits(&inode->io_tree, entry_start,
+					      entry_end, EXTENT_QGROUP_RESERVED);
+		if (!ret && clear_ret < 0)
+			ret = clear_ret;
+
+		ulist_del(&reserved->range_changed, entry->val, entry->aux);
+		if (likely(reserved->bytes_changed >= entry_len)) {
+			reserved->bytes_changed -= entry_len;
+		} else {
+			WARN_ON(1);
+			reserved->bytes_changed = 0;
+		}
+	}
+
+	return ret;
+}
+
 /*
  * Reserve qgroup space for range [start, start + len).
  *
@@ -3421,18 +3488,14 @@ btrfs_qgroup_rescan_resume(struct btrfs_
  * Return <0 for error (including -EQUOT)
  *
  * NOTE: this function may sleep for memory allocation.
- *       if btrfs_qgroup_reserve_data() is called multiple times with
- *       same @reserved, caller must ensure when error happens it's OK
- *       to free *ALL* reserved space.
  */
 int btrfs_qgroup_reserve_data(struct btrfs_inode *inode,
 			struct extent_changeset **reserved_ret, u64 start,
 			u64 len)
 {
 	struct btrfs_root *root = inode->root;
-	struct ulist_node *unode;
-	struct ulist_iterator uiter;
 	struct extent_changeset *reserved;
+	bool new_reserved = false;
 	u64 orig_reserved;
 	u64 to_reserve;
 	int ret;
@@ -3445,6 +3508,7 @@ int btrfs_qgroup_reserve_data(struct btr
 	if (WARN_ON(!reserved_ret))
 		return -EINVAL;
 	if (!*reserved_ret) {
+		new_reserved = true;
 		*reserved_ret = extent_changeset_alloc();
 		if (!*reserved_ret)
 			return -ENOMEM;
@@ -3460,7 +3524,7 @@ int btrfs_qgroup_reserve_data(struct btr
 	trace_btrfs_qgroup_reserve_data(&inode->vfs_inode, start, len,
 					to_reserve, QGROUP_RESERVE);
 	if (ret < 0)
-		goto cleanup;
+		goto out;
 	ret = qgroup_reserve(root, to_reserve, true, BTRFS_QGROUP_RSV_DATA);
 	if (ret < 0)
 		goto cleanup;
@@ -3468,15 +3532,13 @@ int btrfs_qgroup_reserve_data(struct btr
 	return ret;
 
 cleanup:
-	/* cleanup *ALL* already reserved ranges */
-	ULIST_ITER_INIT(&uiter);
-	while ((unode = ulist_next(&reserved->range_changed, &uiter)))
-		clear_extent_bit(&inode->io_tree, unode->val,
-				 unode->aux, EXTENT_QGROUP_RESERVED, 0, 0, NULL);
-	/* Also free data bytes of already reserved one */
-	btrfs_qgroup_free_refroot(root->fs_info, root->root_key.objectid,
-				  orig_reserved, BTRFS_QGROUP_RSV_DATA);
-	extent_changeset_release(reserved);
+	qgroup_unreserve_range(inode, reserved, start, len);
+out:
+	if (new_reserved) {
+		extent_changeset_release(reserved);
+		kfree(reserved);
+		*reserved_ret = NULL;
+	}
 	return ret;
 }
 


