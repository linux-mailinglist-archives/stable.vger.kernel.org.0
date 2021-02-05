Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44912310EFC
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 18:44:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233495AbhBEQBW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 11:01:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:53906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233364AbhBEP7J (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 10:59:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3AD4C65061;
        Fri,  5 Feb 2021 14:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612534357;
        bh=7Whvksf2CWksxPNtmZQr4TIH59nH+paPjkwL+Dox+B8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H4WewWy22HSUsv1hDy9IcjeMUUll7xiVj+XzWSeVDMw9SvJeFgj0TLFlWzc7kFutE
         bD3tE0u3uVscCn39rFEQIxXKcNz4QrbsC06+mNWQig/4ISydWuQ72GuAga1tfMsRRo
         BmdYxkjCIbj3UQtbMe2BWIt4SIlTtb6eZJlLGU+0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        ethanwu <ethanwu@synology.com>, David Sterba <dsterba@suse.com>
Subject: [PATCH 5.4 09/32] btrfs: backref, only collect file extent items matching backref offset
Date:   Fri,  5 Feb 2021 15:07:24 +0100
Message-Id: <20210205140652.734340643@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210205140652.348864025@linuxfoundation.org>
References: <20210205140652.348864025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: ethanwu <ethanwu@synology.com>

commit 7ac8b88ee668a5b4743ebf3e9888fabac85c334a upstream.

When resolving one backref of type EXTENT_DATA_REF, we collect all
references that simply reference the EXTENT_ITEM even though their
(file_pos - file_extent_item::offset) are not the same as the
btrfs_extent_data_ref::offset we are searching for.

This patch adds additional check so that we only collect references whose
(file_pos - file_extent_item::offset) == btrfs_extent_data_ref::offset.

Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: ethanwu <ethanwu@synology.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/backref.c |   63 +++++++++++++++++++++++++++--------------------------
 1 file changed, 33 insertions(+), 30 deletions(-)

--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -347,33 +347,10 @@ static int add_prelim_ref(const struct b
 		return -ENOMEM;
 
 	ref->root_id = root_id;
-	if (key) {
+	if (key)
 		ref->key_for_search = *key;
-		/*
-		 * We can often find data backrefs with an offset that is too
-		 * large (>= LLONG_MAX, maximum allowed file offset) due to
-		 * underflows when subtracting a file's offset with the data
-		 * offset of its corresponding extent data item. This can
-		 * happen for example in the clone ioctl.
-		 * So if we detect such case we set the search key's offset to
-		 * zero to make sure we will find the matching file extent item
-		 * at add_all_parents(), otherwise we will miss it because the
-		 * offset taken form the backref is much larger then the offset
-		 * of the file extent item. This can make us scan a very large
-		 * number of file extent items, but at least it will not make
-		 * us miss any.
-		 * This is an ugly workaround for a behaviour that should have
-		 * never existed, but it does and a fix for the clone ioctl
-		 * would touch a lot of places, cause backwards incompatibility
-		 * and would not fix the problem for extents cloned with older
-		 * kernels.
-		 */
-		if (ref->key_for_search.type == BTRFS_EXTENT_DATA_KEY &&
-		    ref->key_for_search.offset >= LLONG_MAX)
-			ref->key_for_search.offset = 0;
-	} else {
+	else
 		memset(&ref->key_for_search, 0, sizeof(ref->key_for_search));
-	}
 
 	ref->inode_list = NULL;
 	ref->level = level;
@@ -424,6 +401,7 @@ static int add_all_parents(struct btrfs_
 	u64 disk_byte;
 	u64 wanted_disk_byte = ref->wanted_disk_byte;
 	u64 count = 0;
+	u64 data_offset;
 
 	if (level != 0) {
 		eb = path->nodes[level];
@@ -457,11 +435,15 @@ static int add_all_parents(struct btrfs_
 
 		fi = btrfs_item_ptr(eb, slot, struct btrfs_file_extent_item);
 		disk_byte = btrfs_file_extent_disk_bytenr(eb, fi);
+		data_offset = btrfs_file_extent_offset(eb, fi);
 
 		if (disk_byte == wanted_disk_byte) {
 			eie = NULL;
 			old = NULL;
-			count++;
+			if (ref->key_for_search.offset == key.offset - data_offset)
+				count++;
+			else
+				goto next;
 			if (extent_item_pos) {
 				ret = check_extent_in_eb(&key, eb, fi,
 						*extent_item_pos,
@@ -513,6 +495,7 @@ static int resolve_indirect_ref(struct b
 	int root_level;
 	int level = ref->level;
 	int index;
+	struct btrfs_key search_key = ref->key_for_search;
 
 	root_key.objectid = ref->root_id;
 	root_key.type = BTRFS_ROOT_ITEM_KEY;
@@ -545,13 +528,33 @@ static int resolve_indirect_ref(struct b
 		goto out;
 	}
 
+	/*
+	 * We can often find data backrefs with an offset that is too large
+	 * (>= LLONG_MAX, maximum allowed file offset) due to underflows when
+	 * subtracting a file's offset with the data offset of its
+	 * corresponding extent data item. This can happen for example in the
+	 * clone ioctl.
+	 *
+	 * So if we detect such case we set the search key's offset to zero to
+	 * make sure we will find the matching file extent item at
+	 * add_all_parents(), otherwise we will miss it because the offset
+	 * taken form the backref is much larger then the offset of the file
+	 * extent item. This can make us scan a very large number of file
+	 * extent items, but at least it will not make us miss any.
+	 *
+	 * This is an ugly workaround for a behaviour that should have never
+	 * existed, but it does and a fix for the clone ioctl would touch a lot
+	 * of places, cause backwards incompatibility and would not fix the
+	 * problem for extents cloned with older kernels.
+	 */
+	if (search_key.type == BTRFS_EXTENT_DATA_KEY &&
+	    search_key.offset >= LLONG_MAX)
+		search_key.offset = 0;
 	path->lowest_level = level;
 	if (time_seq == SEQ_LAST)
-		ret = btrfs_search_slot(NULL, root, &ref->key_for_search, path,
-					0, 0);
+		ret = btrfs_search_slot(NULL, root, &search_key, path, 0, 0);
 	else
-		ret = btrfs_search_old_slot(root, &ref->key_for_search, path,
-					    time_seq);
+		ret = btrfs_search_old_slot(root, &search_key, path, time_seq);
 
 	/* root node has been locked, we can release @subvol_srcu safely here */
 	srcu_read_unlock(&fs_info->subvol_srcu, index);


