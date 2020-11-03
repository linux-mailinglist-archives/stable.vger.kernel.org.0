Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B5562A5237
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:48:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731392AbgKCUru (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:47:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:38574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729958AbgKCUrt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:47:49 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CECE320719;
        Tue,  3 Nov 2020 20:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436468;
        bh=/oiix+ZHFj9vRtKzvKXRYPkiyeCny7/DNbw6DEOLauM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=efBVfnJ/LUjiGb8sNtwcFWLg0y1z5eP1UmlaF6G/lSpOlwD1qB/L/VZPqZZaVq+bA
         1jyjnuTGEgzgRTwTTy7eJwxUraMAHoWFWOtxfWRPwJt62vRGKzxdmgn2tEtuu52RI5
         oCNe9c8in09T5C/l4XWyLJ39HkpeyEJxFCMNDt6w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans van Kranenburg <hans@knorrie.org>,
        Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>
Subject: [PATCH 5.9 225/391] btrfs: tracepoints: output proper root owner for trace_find_free_extent()
Date:   Tue,  3 Nov 2020 21:34:36 +0100
Message-Id: <20201103203402.136069226@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

commit 437490fed3b0c9ae21af8f70e0f338d34560842b upstream.

The current trace event always output result like this:

 find_free_extent: root=2(EXTENT_TREE) len=16384 empty_size=0 flags=4(METADATA)
 find_free_extent: root=2(EXTENT_TREE) len=16384 empty_size=0 flags=4(METADATA)
 find_free_extent: root=2(EXTENT_TREE) len=8192 empty_size=0 flags=1(DATA)
 find_free_extent: root=2(EXTENT_TREE) len=8192 empty_size=0 flags=1(DATA)
 find_free_extent: root=2(EXTENT_TREE) len=4096 empty_size=0 flags=1(DATA)
 find_free_extent: root=2(EXTENT_TREE) len=4096 empty_size=0 flags=1(DATA)

T's saying we're allocating data extent for EXTENT tree, which is not
even possible.

It's because we always use EXTENT tree as the owner for
trace_find_free_extent() without using the @root from
btrfs_reserve_extent().

This patch will change the parameter to use proper @root for
trace_find_free_extent():

Now it looks much better:

 find_free_extent: root=5(FS_TREE) len=16384 empty_size=0 flags=36(METADATA|DUP)
 find_free_extent: root=5(FS_TREE) len=8192 empty_size=0 flags=1(DATA)
 find_free_extent: root=5(FS_TREE) len=16384 empty_size=0 flags=1(DATA)
 find_free_extent: root=5(FS_TREE) len=4096 empty_size=0 flags=1(DATA)
 find_free_extent: root=5(FS_TREE) len=8192 empty_size=0 flags=1(DATA)
 find_free_extent: root=5(FS_TREE) len=16384 empty_size=0 flags=36(METADATA|DUP)
 find_free_extent: root=7(CSUM_TREE) len=16384 empty_size=0 flags=36(METADATA|DUP)
 find_free_extent: root=2(EXTENT_TREE) len=16384 empty_size=0 flags=36(METADATA|DUP)
 find_free_extent: root=1(ROOT_TREE) len=16384 empty_size=0 flags=36(METADATA|DUP)

Reported-by: Hans van Kranenburg <hans@knorrie.org>
CC: stable@vger.kernel.org # 5.4+
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/extent-tree.c       |    7 ++++---
 include/trace/events/btrfs.h |   10 ++++++----
 2 files changed, 10 insertions(+), 7 deletions(-)

--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3918,11 +3918,12 @@ static int prepare_allocation(struct btr
  * |- Push harder to find free extents
  *    |- If not found, re-iterate all block groups
  */
-static noinline int find_free_extent(struct btrfs_fs_info *fs_info,
+static noinline int find_free_extent(struct btrfs_root *root,
 				u64 ram_bytes, u64 num_bytes, u64 empty_size,
 				u64 hint_byte_orig, struct btrfs_key *ins,
 				u64 flags, int delalloc)
 {
+	struct btrfs_fs_info *fs_info = root->fs_info;
 	int ret = 0;
 	int cache_block_group_error = 0;
 	struct btrfs_block_group *block_group = NULL;
@@ -3954,7 +3955,7 @@ static noinline int find_free_extent(str
 	ins->objectid = 0;
 	ins->offset = 0;
 
-	trace_find_free_extent(fs_info, num_bytes, empty_size, flags);
+	trace_find_free_extent(root, num_bytes, empty_size, flags);
 
 	space_info = btrfs_find_space_info(fs_info, flags);
 	if (!space_info) {
@@ -4203,7 +4204,7 @@ int btrfs_reserve_extent(struct btrfs_ro
 	flags = get_alloc_profile_by_root(root, is_data);
 again:
 	WARN_ON(num_bytes < fs_info->sectorsize);
-	ret = find_free_extent(fs_info, ram_bytes, num_bytes, empty_size,
+	ret = find_free_extent(root, ram_bytes, num_bytes, empty_size,
 			       hint_byte, ins, flags, delalloc);
 	if (!ret && !is_data) {
 		btrfs_dec_block_group_reservations(fs_info, ins->objectid);
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -1176,25 +1176,27 @@ DEFINE_EVENT(btrfs__reserved_extent,  bt
 
 TRACE_EVENT(find_free_extent,
 
-	TP_PROTO(const struct btrfs_fs_info *fs_info, u64 num_bytes,
+	TP_PROTO(const struct btrfs_root *root, u64 num_bytes,
 		 u64 empty_size, u64 data),
 
-	TP_ARGS(fs_info, num_bytes, empty_size, data),
+	TP_ARGS(root, num_bytes, empty_size, data),
 
 	TP_STRUCT__entry_btrfs(
+		__field(	u64,	root_objectid		)
 		__field(	u64,	num_bytes		)
 		__field(	u64,	empty_size		)
 		__field(	u64,	data			)
 	),
 
-	TP_fast_assign_btrfs(fs_info,
+	TP_fast_assign_btrfs(root->fs_info,
+		__entry->root_objectid	= root->root_key.objectid;
 		__entry->num_bytes	= num_bytes;
 		__entry->empty_size	= empty_size;
 		__entry->data		= data;
 	),
 
 	TP_printk_btrfs("root=%llu(%s) len=%llu empty_size=%llu flags=%llu(%s)",
-		  show_root_type(BTRFS_EXTENT_TREE_OBJECTID),
+		  show_root_type(__entry->root_objectid),
 		  __entry->num_bytes, __entry->empty_size, __entry->data,
 		  __print_flags((unsigned long)__entry->data, "|",
 				 BTRFS_GROUP_FLAGS))


