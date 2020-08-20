Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EEA024B21D
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 11:24:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726908AbgHTJYN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 05:24:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:60060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726858AbgHTJYG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:24:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 39C4A22CB2;
        Thu, 20 Aug 2020 09:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597915444;
        bh=FsTRNsDIVPigZPg1zRuc7Om65/Nr/bvjY+ArNNN8NS0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zvfLML1uKvdhIdI3x+3b9TSrhOn6E2Gfu7R1jaPMcxqDaS7ttAFumLx6nMDLprihG
         B3U5kWtvqhOjDdrGVA8H2YB1i5U/xCYISHJc28gMjMpH/5MPk1/y59cdIhFjoM1D2/
         X/8H2A22qc0unZwqUvdeOsHBRYCXgZ++XfLp6sXk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Greed Rong <greedrong@gmail.com>,
        Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>
Subject: [PATCH 5.8 016/232] btrfs: preallocate anon block device at first phase of snapshot creation
Date:   Thu, 20 Aug 2020 11:17:47 +0200
Message-Id: <20200820091613.519405888@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091612.692383444@linuxfoundation.org>
References: <20200820091612.692383444@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

commit 2dfb1e43f57dd3aeaa66f7cf05d068db2d4c8788 upstream.

[BUG]
When the anonymous block device pool is exhausted, subvolume/snapshot
creation fails with EMFILE (Too many files open). This has been reported
by a user. The allocation happens in the second phase during transaction
commit where it's only way out is to abort the transaction

  BTRFS: Transaction aborted (error -24)
  WARNING: CPU: 17 PID: 17041 at fs/btrfs/transaction.c:1576 create_pending_snapshot+0xbc4/0xd10 [btrfs]
  RIP: 0010:create_pending_snapshot+0xbc4/0xd10 [btrfs]
  Call Trace:
   create_pending_snapshots+0x82/0xa0 [btrfs]
   btrfs_commit_transaction+0x275/0x8c0 [btrfs]
   btrfs_mksubvol+0x4b9/0x500 [btrfs]
   btrfs_ioctl_snap_create_transid+0x174/0x180 [btrfs]
   btrfs_ioctl_snap_create_v2+0x11c/0x180 [btrfs]
   btrfs_ioctl+0x11a4/0x2da0 [btrfs]
   do_vfs_ioctl+0xa9/0x640
   ksys_ioctl+0x67/0x90
   __x64_sys_ioctl+0x1a/0x20
   do_syscall_64+0x5a/0x110
   entry_SYSCALL_64_after_hwframe+0x44/0xa9
  ---[ end trace 33f2f83f3d5250e9 ]---
  BTRFS: error (device sda1) in create_pending_snapshot:1576: errno=-24 unknown
  BTRFS info (device sda1): forced readonly
  BTRFS warning (device sda1): Skipping commit of aborted transaction.
  BTRFS: error (device sda1) in cleanup_transaction:1831: errno=-24 unknown

[CAUSE]
When the global anonymous block device pool is exhausted, the following
call chain will fail, and lead to transaction abort:

 btrfs_ioctl_snap_create_v2()
 |- btrfs_ioctl_snap_create_transid()
    |- btrfs_mksubvol()
       |- btrfs_commit_transaction()
          |- create_pending_snapshot()
             |- btrfs_get_fs_root()
                |- btrfs_init_fs_root()
                   |- get_anon_bdev()

[FIX]
Although we can't enlarge the anonymous block device pool, at least we
can preallocate anon_dev for subvolume/snapshot in the first phase,
outside of transaction context and exactly at the moment the user calls
the creation ioctl.

Reported-by: Greed Rong <greedrong@gmail.com>
Link: https://lore.kernel.org/linux-btrfs/CA+UqX+NTrZ6boGnWHhSeZmEY5J76CTqmYjO2S+=tHJX7nb9DPw@mail.gmail.com/
CC: stable@vger.kernel.org # 4.4+
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/disk-io.c     |   71 ++++++++++++++++++++++++++++++++++++++++++++-----
 fs/btrfs/disk-io.h     |    2 +
 fs/btrfs/ioctl.c       |   21 +++++++++++++-
 fs/btrfs/transaction.c |    2 -
 fs/btrfs/transaction.h |    2 +
 5 files changed, 89 insertions(+), 9 deletions(-)

--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1395,7 +1395,12 @@ alloc_fail:
 	goto out;
 }
 
-static int btrfs_init_fs_root(struct btrfs_root *root)
+/*
+ * Initialize subvolume root in-memory structure
+ *
+ * @anon_dev:	anonymous device to attach to the root, if zero, allocate new
+ */
+static int btrfs_init_fs_root(struct btrfs_root *root, dev_t anon_dev)
 {
 	int ret;
 	unsigned int nofs_flag;
@@ -1434,9 +1439,13 @@ static int btrfs_init_fs_root(struct btr
 	 */
 	if (is_fstree(root->root_key.objectid) &&
 	    btrfs_root_refs(&root->root_item) > 0) {
-		ret = get_anon_bdev(&root->anon_dev);
-		if (ret)
-			goto fail;
+		if (!anon_dev) {
+			ret = get_anon_bdev(&root->anon_dev);
+			if (ret)
+				goto fail;
+		} else {
+			root->anon_dev = anon_dev;
+		}
 	}
 
 	mutex_lock(&root->objectid_mutex);
@@ -1541,8 +1550,27 @@ void btrfs_free_fs_info(struct btrfs_fs_
 }
 
 
-struct btrfs_root *btrfs_get_fs_root(struct btrfs_fs_info *fs_info,
-				     u64 objectid, bool check_ref)
+/*
+ * Get an in-memory reference of a root structure.
+ *
+ * For essential trees like root/extent tree, we grab it from fs_info directly.
+ * For subvolume trees, we check the cached filesystem roots first. If not
+ * found, then read it from disk and add it to cached fs roots.
+ *
+ * Caller should release the root by calling btrfs_put_root() after the usage.
+ *
+ * NOTE: Reloc and log trees can't be read by this function as they share the
+ *	 same root objectid.
+ *
+ * @objectid:	root id
+ * @anon_dev:	preallocated anonymous block device number for new roots,
+ * 		pass 0 for new allocation.
+ * @check_ref:	whether to check root item references, If true, return -ENOENT
+ *		for orphan roots
+ */
+static struct btrfs_root *btrfs_get_root_ref(struct btrfs_fs_info *fs_info,
+					     u64 objectid, dev_t anon_dev,
+					     bool check_ref)
 {
 	struct btrfs_root *root;
 	struct btrfs_path *path;
@@ -1571,6 +1599,8 @@ struct btrfs_root *btrfs_get_fs_root(str
 again:
 	root = btrfs_lookup_fs_root(fs_info, objectid);
 	if (root) {
+		/* Shouldn't get preallocated anon_dev for cached roots */
+		ASSERT(!anon_dev);
 		if (check_ref && btrfs_root_refs(&root->root_item) == 0) {
 			btrfs_put_root(root);
 			return ERR_PTR(-ENOENT);
@@ -1590,7 +1620,7 @@ again:
 		goto fail;
 	}
 
-	ret = btrfs_init_fs_root(root);
+	ret = btrfs_init_fs_root(root, anon_dev);
 	if (ret)
 		goto fail;
 
@@ -1623,6 +1653,33 @@ fail:
 	return ERR_PTR(ret);
 }
 
+/*
+ * Get in-memory reference of a root structure
+ *
+ * @objectid:	tree objectid
+ * @check_ref:	if set, verify that the tree exists and the item has at least
+ *		one reference
+ */
+struct btrfs_root *btrfs_get_fs_root(struct btrfs_fs_info *fs_info,
+				     u64 objectid, bool check_ref)
+{
+	return btrfs_get_root_ref(fs_info, objectid, 0, check_ref);
+}
+
+/*
+ * Get in-memory reference of a root structure, created as new, optionally pass
+ * the anonymous block device id
+ *
+ * @objectid:	tree objectid
+ * @anon_dev:	if zero, allocate a new anonymous block device or use the
+ *		parameter value
+ */
+struct btrfs_root *btrfs_get_new_fs_root(struct btrfs_fs_info *fs_info,
+					 u64 objectid, dev_t anon_dev)
+{
+	return btrfs_get_root_ref(fs_info, objectid, anon_dev, true);
+}
+
 static int btrfs_congested_fn(void *congested_data, int bdi_bits)
 {
 	struct btrfs_fs_info *info = (struct btrfs_fs_info *)congested_data;
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -67,6 +67,8 @@ void btrfs_free_fs_roots(struct btrfs_fs
 
 struct btrfs_root *btrfs_get_fs_root(struct btrfs_fs_info *fs_info,
 				     u64 objectid, bool check_ref);
+struct btrfs_root *btrfs_get_new_fs_root(struct btrfs_fs_info *fs_info,
+					 u64 objectid, dev_t anon_dev);
 
 void btrfs_free_fs_info(struct btrfs_fs_info *fs_info);
 int btrfs_cleanup_fs_roots(struct btrfs_fs_info *fs_info);
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -566,6 +566,7 @@ static noinline int create_subvol(struct
 	struct inode *inode;
 	int ret;
 	int err;
+	dev_t anon_dev = 0;
 	u64 objectid;
 	u64 new_dirid = BTRFS_FIRST_FREE_OBJECTID;
 	u64 index = 0;
@@ -578,6 +579,10 @@ static noinline int create_subvol(struct
 	if (ret)
 		goto fail_free;
 
+	ret = get_anon_bdev(&anon_dev);
+	if (ret < 0)
+		goto fail_free;
+
 	/*
 	 * Don't create subvolume whose level is not zero. Or qgroup will be
 	 * screwed up since it assumes subvolume qgroup's level to be 0.
@@ -660,12 +665,15 @@ static noinline int create_subvol(struct
 		goto fail;
 
 	key.offset = (u64)-1;
-	new_root = btrfs_get_fs_root(fs_info, objectid, true);
+	new_root = btrfs_get_new_fs_root(fs_info, objectid, anon_dev);
 	if (IS_ERR(new_root)) {
+		free_anon_bdev(anon_dev);
 		ret = PTR_ERR(new_root);
 		btrfs_abort_transaction(trans, ret);
 		goto fail;
 	}
+	/* Freeing will be done in btrfs_put_root() of new_root */
+	anon_dev = 0;
 
 	btrfs_record_root_in_trans(trans, new_root);
 
@@ -735,6 +743,8 @@ fail:
 	return ret;
 
 fail_free:
+	if (anon_dev)
+		free_anon_bdev(anon_dev);
 	kfree(root_item);
 	return ret;
 }
@@ -762,6 +772,9 @@ static int create_snapshot(struct btrfs_
 	if (!pending_snapshot)
 		return -ENOMEM;
 
+	ret = get_anon_bdev(&pending_snapshot->anon_dev);
+	if (ret < 0)
+		goto free_pending;
 	pending_snapshot->root_item = kzalloc(sizeof(struct btrfs_root_item),
 			GFP_KERNEL);
 	pending_snapshot->path = btrfs_alloc_path();
@@ -823,10 +836,16 @@ static int create_snapshot(struct btrfs_
 
 	d_instantiate(dentry, inode);
 	ret = 0;
+	pending_snapshot->anon_dev = 0;
 fail:
+	/* Prevent double freeing of anon_dev */
+	if (ret && pending_snapshot->snap)
+		pending_snapshot->snap->anon_dev = 0;
 	btrfs_put_root(pending_snapshot->snap);
 	btrfs_subvolume_release_metadata(fs_info, &pending_snapshot->block_rsv);
 free_pending:
+	if (pending_snapshot->anon_dev)
+		free_anon_bdev(pending_snapshot->anon_dev);
 	kfree(pending_snapshot->root_item);
 	btrfs_free_path(pending_snapshot->path);
 	kfree(pending_snapshot);
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1630,7 +1630,7 @@ static noinline int create_pending_snaps
 	}
 
 	key.offset = (u64)-1;
-	pending->snap = btrfs_get_fs_root(fs_info, objectid, true);
+	pending->snap = btrfs_get_new_fs_root(fs_info, objectid, pending->anon_dev);
 	if (IS_ERR(pending->snap)) {
 		ret = PTR_ERR(pending->snap);
 		btrfs_abort_transaction(trans, ret);
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -151,6 +151,8 @@ struct btrfs_pending_snapshot {
 	struct btrfs_block_rsv block_rsv;
 	/* extra metadata reservation for relocation */
 	int error;
+	/* Preallocated anonymous block device number */
+	dev_t anon_dev;
 	bool readonly;
 	struct list_head list;
 };


