Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0248A129928
	for <lists+stable@lfdr.de>; Mon, 23 Dec 2019 18:13:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726832AbfLWRNt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Dec 2019 12:13:49 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:55129 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726718AbfLWRNt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Dec 2019 12:13:49 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 0387621F2E;
        Mon, 23 Dec 2019 12:13:47 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 23 Dec 2019 12:13:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=L48eg2
        kkjn2xiDRLEqiqTC65WdHvv0zOyujSMH1mqcg=; b=s531Zj65wijyhhd50Bfjzb
        aItudmVILNSh84zf+516U+7wpuxBgtQdNk1S15LuBOaW8bD9nrIwuKD3lCSMMlqB
        BWI84JLaFAIUF7tyXrFTQ7CnHjD5gsc4JRSuQNc02KeXBOGbYjet7AwXv8gXgF5H
        n3gLN2lHJuVvvk0PxkqRBu4CotbsJkWkAoTrr2oScSruUn6DFWjuHWrvI+ri4NmQ
        6JHbym2la3qB7X7UJjAjmXwUA+iW2Dx7kEjJhMPAm4iH8E/0gYcflQd+u3o0LvqM
        fZAF1Bqv4DgUVosVjBujfCM+EbRlvL1kDhkv/97VmZOZzlrYdYvoiZz+Zp8HmVAw
        ==
X-ME-Sender: <xms:yvUAXi_RrLEGtXwucHBE4_IZWuQGTNLeNtRb_q6-M60-QI9agV6CtA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddvtddgleejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeduleekrdekledrieegrddvgeelnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpeeg
X-ME-Proxy: <xmx:yvUAXrpWXzAAu_pgxr7ImGvYmQowHS8HYokMq7OPeToIUso8bBwt4g>
    <xmx:yvUAXsbYAjDJ2aCE-nH1sR5GGuXrak1M27rwgRYJM5eJ4_rBVyqoxQ>
    <xmx:yvUAXvuJUV0xuFW27xK6DtMrFBlfAJVcaLdkyAiL-elzKOuOk2njNg>
    <xmx:yvUAXqg_rxf-G0fne2kTlTL2n2BRmH3eqZY7ZR2jYg96oioOpV2dSg>
Received: from localhost (unknown [198.89.64.249])
        by mail.messagingengine.com (Postfix) with ESMTPA id 68286306098F;
        Mon, 23 Dec 2019 12:13:46 -0500 (EST)
Subject: FAILED: patch "[PATCH] Btrfs: fix missing data checksums after replaying a log tree" failed to apply to 4.14-stable tree
To:     fdmanana@suse.com, dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 23 Dec 2019 12:13:41 -0500
Message-ID: <1577121221132140@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 40e046acbd2f369cfbf93c3413639c66514cec2d Mon Sep 17 00:00:00 2001
From: Filipe Manana <fdmanana@suse.com>
Date: Thu, 5 Dec 2019 16:58:30 +0000
Subject: [PATCH] Btrfs: fix missing data checksums after replaying a log tree

When logging a file that has shared extents (reflinked with other files or
with itself), we can end up logging multiple checksum items that cover
overlapping ranges. This confuses the search for checksums at log replay
time causing some checksums to never be added to the fs/subvolume tree.

Consider the following example of a file that shares the same extent at
offsets 0 and 256Kb:

   [ bytenr 13893632, offset 64Kb, len 64Kb  ]
   0                                         64Kb

   [ bytenr 13631488, offset 64Kb, len 192Kb ]
   64Kb                                      256Kb

   [ bytenr 13893632, offset 0, len 256Kb    ]
   256Kb                                     512Kb

When logging the inode, at tree-log.c:copy_items(), when processing the
file extent item at offset 0, we log a checksum item covering the range
13959168 to 14024704, which corresponds to 13893632 + 64Kb and 13893632 +
64Kb + 64Kb, respectively.

Later when processing the extent item at offset 256K, we log the checksums
for the range from 13893632 to 14155776 (which corresponds to 13893632 +
256Kb). These checksums get merged with the checksum item for the range
from 13631488 to 13893632 (13631488 + 256Kb), logged by a previous fsync.
So after this we get the two following checksum items in the log tree:

   (...)
   item 6 key (EXTENT_CSUM EXTENT_CSUM 13631488) itemoff 3095 itemsize 512
           range start 13631488 end 14155776 length 524288
   item 7 key (EXTENT_CSUM EXTENT_CSUM 13959168) itemoff 3031 itemsize 64
           range start 13959168 end 14024704 length 65536

The first one covers the range from the second one, they overlap.

So far this does not cause a problem after replaying the log, because
when replaying the file extent item for offset 256K, we copy all the
checksums for the extent 13893632 from the log tree to the fs/subvolume
tree, since searching for an checksum item for bytenr 13893632 leaves us
at the first checksum item, which covers the whole range of the extent.

However if we write 64Kb to file offset 256Kb for example, we will
not be able to find and copy the checksums for the last 128Kb of the
extent at bytenr 13893632, referenced by the file range 384Kb to 512Kb.

After writing 64Kb into file offset 256Kb we get the following extent
layout for our file:

   [ bytenr 13893632, offset 64K, len 64Kb   ]
   0                                         64Kb

   [ bytenr 13631488, offset 64Kb, len 192Kb ]
   64Kb                                      256Kb

   [ bytenr 14155776, offset 0, len 64Kb     ]
   256Kb                                     320Kb

   [ bytenr 13893632, offset 64Kb, len 192Kb ]
   320Kb                                     512Kb

After fsync'ing the file, if we have a power failure and then mount
the filesystem to replay the log, the following happens:

1) When replaying the file extent item for file offset 320Kb, we
   lookup for the checksums for the extent range from 13959168
   (13893632 + 64Kb) to 14155776 (13893632 + 256Kb), through a call
   to btrfs_lookup_csums_range();

2) btrfs_lookup_csums_range() finds the checksum item that starts
   precisely at offset 13959168 (item 7 in the log tree, shown before);

3) However that checksum item only covers 64Kb of data, and not 192Kb
   of data;

4) As a result only the checksums for the first 64Kb of data referenced
   by the file extent item are found and copied to the fs/subvolume tree.
   The remaining 128Kb of data, file range 384Kb to 512Kb, doesn't get
   the corresponding data checksums found and copied to the fs/subvolume
   tree.

5) After replaying the log userspace will not be able to read the file
   range from 384Kb to 512Kb, because the checksums are missing and
   resulting in an -EIO error.

The following steps reproduce this scenario:

  $ mkfs.btrfs -f /dev/sdc
  $ mount /dev/sdc /mnt/sdc

  $ xfs_io -f -c "pwrite -S 0xa3 0 256K" /mnt/sdc/foobar
  $ xfs_io -c "fsync" /mnt/sdc/foobar
  $ xfs_io -c "pwrite -S 0xc7 256K 256K" /mnt/sdc/foobar

  $ xfs_io -c "reflink /mnt/sdc/foobar 320K 0 64K" /mnt/sdc/foobar
  $ xfs_io -c "fsync" /mnt/sdc/foobar

  $ xfs_io -c "pwrite -S 0xe5 256K 64K" /mnt/sdc/foobar
  $ xfs_io -c "fsync" /mnt/sdc/foobar

  <power failure>

  $ mount /dev/sdc /mnt/sdc
  $ md5sum /mnt/sdc/foobar
  md5sum: /mnt/sdc/foobar: Input/output error

  $ dmesg | tail
  [165305.003464] BTRFS info (device sdc): no csum found for inode 257 start 401408
  [165305.004014] BTRFS info (device sdc): no csum found for inode 257 start 405504
  [165305.004559] BTRFS info (device sdc): no csum found for inode 257 start 409600
  [165305.005101] BTRFS info (device sdc): no csum found for inode 257 start 413696
  [165305.005627] BTRFS info (device sdc): no csum found for inode 257 start 417792
  [165305.006134] BTRFS info (device sdc): no csum found for inode 257 start 421888
  [165305.006625] BTRFS info (device sdc): no csum found for inode 257 start 425984
  [165305.007278] BTRFS info (device sdc): no csum found for inode 257 start 430080
  [165305.008248] BTRFS warning (device sdc): csum failed root 5 ino 257 off 393216 csum 0x1337385e expected csum 0x00000000 mirror 1
  [165305.009550] BTRFS warning (device sdc): csum failed root 5 ino 257 off 393216 csum 0x1337385e expected csum 0x00000000 mirror 1

Fix this simply by deleting first any checksums, from the log tree, for the
range of the extent we are logging at copy_items(). This ensures we do not
get checksum items in the log tree that have overlapping ranges.

This is a long time issue that has been present since we have the clone
(and deduplication) ioctl, and can happen both when an extent is shared
between different files and within the same file.

A test case for fstests follows soon.

CC: stable@vger.kernel.org # 4.4+
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index b2e8fd8a8e59..54efb21c2727 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2787,7 +2787,7 @@ struct btrfs_inode_extref *btrfs_find_name_in_ext_backref(
 /* file-item.c */
 struct btrfs_dio_private;
 int btrfs_del_csums(struct btrfs_trans_handle *trans,
-		    struct btrfs_fs_info *fs_info, u64 bytenr, u64 len);
+		    struct btrfs_root *root, u64 bytenr, u64 len);
 blk_status_t btrfs_lookup_bio_sums(struct inode *inode, struct bio *bio,
 				   u8 *dst);
 blk_status_t btrfs_lookup_bio_sums_dio(struct inode *inode, struct bio *bio,
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 18df434bfe52..274318e9114e 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1869,8 +1869,8 @@ static int cleanup_ref_head(struct btrfs_trans_handle *trans,
 		btrfs_pin_extent(fs_info, head->bytenr,
 				 head->num_bytes, 1);
 		if (head->is_data) {
-			ret = btrfs_del_csums(trans, fs_info, head->bytenr,
-					      head->num_bytes);
+			ret = btrfs_del_csums(trans, fs_info->csum_root,
+					      head->bytenr, head->num_bytes);
 		}
 	}
 
@@ -3175,7 +3175,8 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 		btrfs_release_path(path);
 
 		if (is_data) {
-			ret = btrfs_del_csums(trans, info, bytenr, num_bytes);
+			ret = btrfs_del_csums(trans, info->csum_root, bytenr,
+					      num_bytes);
 			if (ret) {
 				btrfs_abort_transaction(trans, ret);
 				goto out;
diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index 3270a40b0777..b1bfdc5c1387 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -590,9 +590,9 @@ static noinline void truncate_one_csum(struct btrfs_fs_info *fs_info,
  * range of bytes.
  */
 int btrfs_del_csums(struct btrfs_trans_handle *trans,
-		    struct btrfs_fs_info *fs_info, u64 bytenr, u64 len)
+		    struct btrfs_root *root, u64 bytenr, u64 len)
 {
-	struct btrfs_root *root = fs_info->csum_root;
+	struct btrfs_fs_info *fs_info = trans->fs_info;
 	struct btrfs_path *path;
 	struct btrfs_key key;
 	u64 end_byte = bytenr + len;
@@ -602,6 +602,9 @@ int btrfs_del_csums(struct btrfs_trans_handle *trans,
 	u16 csum_size = btrfs_super_csum_size(fs_info->super_copy);
 	int blocksize_bits = fs_info->sb->s_blocksize_bits;
 
+	ASSERT(root == fs_info->csum_root ||
+	       root->root_key.objectid == BTRFS_TREE_LOG_OBJECTID);
+
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 6f757361db53..79866f1b33d6 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -808,7 +808,8 @@ static noinline int replay_one_extent(struct btrfs_trans_handle *trans,
 						struct btrfs_ordered_sum,
 						list);
 				if (!ret)
-					ret = btrfs_del_csums(trans, fs_info,
+					ret = btrfs_del_csums(trans,
+							      fs_info->csum_root,
 							      sums->bytenr,
 							      sums->len);
 				if (!ret)
@@ -3909,6 +3910,28 @@ static int log_inode_item(struct btrfs_trans_handle *trans,
 	return 0;
 }
 
+static int log_csums(struct btrfs_trans_handle *trans,
+		     struct btrfs_root *log_root,
+		     struct btrfs_ordered_sum *sums)
+{
+	int ret;
+
+	/*
+	 * Due to extent cloning, we might have logged a csum item that covers a
+	 * subrange of a cloned extent, and later we can end up logging a csum
+	 * item for a larger subrange of the same extent or the entire range.
+	 * This would leave csum items in the log tree that cover the same range
+	 * and break the searches for checksums in the log tree, resulting in
+	 * some checksums missing in the fs/subvolume tree. So just delete (or
+	 * trim and adjust) any existing csum items in the log for this range.
+	 */
+	ret = btrfs_del_csums(trans, log_root, sums->bytenr, sums->len);
+	if (ret)
+		return ret;
+
+	return btrfs_csum_file_blocks(trans, log_root, sums);
+}
+
 static noinline int copy_items(struct btrfs_trans_handle *trans,
 			       struct btrfs_inode *inode,
 			       struct btrfs_path *dst_path,
@@ -4054,7 +4077,7 @@ static noinline int copy_items(struct btrfs_trans_handle *trans,
 						   struct btrfs_ordered_sum,
 						   list);
 		if (!ret)
-			ret = btrfs_csum_file_blocks(trans, log, sums);
+			ret = log_csums(trans, log, sums);
 		list_del(&sums->list);
 		kfree(sums);
 	}
@@ -4274,7 +4297,7 @@ static int log_extent_csums(struct btrfs_trans_handle *trans,
 						   struct btrfs_ordered_sum,
 						   list);
 		if (!ret)
-			ret = btrfs_csum_file_blocks(trans, log_root, sums);
+			ret = log_csums(trans, log_root, sums);
 		list_del(&sums->list);
 		kfree(sums);
 	}

