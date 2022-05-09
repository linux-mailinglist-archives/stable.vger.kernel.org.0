Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAA3051F7EF
	for <lists+stable@lfdr.de>; Mon,  9 May 2022 11:26:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233112AbiEIJV5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 May 2022 05:21:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235974AbiEIIum (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 May 2022 04:50:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EFB254BCD
        for <stable@vger.kernel.org>; Mon,  9 May 2022 01:46:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3AAE1B8103C
        for <stable@vger.kernel.org>; Mon,  9 May 2022 08:46:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70CB1C385A8;
        Mon,  9 May 2022 08:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652086005;
        bh=6Ce7av6vSHEahIyYXblvl/3T4aYyHyGVuR96eCt5MDk=;
        h=Subject:To:Cc:From:Date:From;
        b=WpKjBXduHF5f4H1gT265oJFv3NE6fdYqmAWOIs0YDcMZnBVcCARwOM231NZJ713PY
         Af2jKNuaX6aaHHIwaumnm2vF9gv0GvM5Pv0yFhp8xmDd9bLjlppe2JR+gClSfC07BF
         oa7Gtmh+l3Me5Gjo898ofDwoLU8i4yQXFlaudlNA=
Subject: FAILED: patch "[PATCH] btrfs: export a helper for compression hard check" failed to apply to 5.15-stable tree
To:     cccheng@synology.com, dsterba@suse.com, nborisov@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 09 May 2022 10:46:43 +0200
Message-ID: <1652086003202248@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From e6f9d69648029e48b8f97db09368d419b5e2614a Mon Sep 17 00:00:00 2001
From: Chung-Chiang Cheng <cccheng@synology.com>
Date: Fri, 15 Apr 2022 16:04:05 +0800
Subject: [PATCH] btrfs: export a helper for compression hard check

inode_can_compress will be used outside of inode.c to check the
availability of setting compression flag by xattr. This patch moves
this function as an internal helper and renames it to
btrfs_inode_can_compress.

Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Chung-Chiang Cheng <cccheng@synology.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 47e72d72f7d0..32131a5d321b 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -384,6 +384,17 @@ static inline bool btrfs_inode_in_log(struct btrfs_inode *inode, u64 generation)
 	return ret;
 }
 
+/*
+ * Check if the inode has flags compatible with compression
+ */
+static inline bool btrfs_inode_can_compress(const struct btrfs_inode *inode)
+{
+	if (inode->flags & BTRFS_INODE_NODATACOW ||
+	    inode->flags & BTRFS_INODE_NODATASUM)
+		return false;
+	return true;
+}
+
 struct btrfs_dio_private {
 	struct inode *inode;
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 8bac68d8e96f..673b9259f6c0 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -480,17 +480,6 @@ static noinline int add_async_extent(struct async_chunk *cow,
 	return 0;
 }
 
-/*
- * Check if the inode has flags compatible with compression
- */
-static inline bool inode_can_compress(struct btrfs_inode *inode)
-{
-	if (inode->flags & BTRFS_INODE_NODATACOW ||
-	    inode->flags & BTRFS_INODE_NODATASUM)
-		return false;
-	return true;
-}
-
 /*
  * Check if the inode needs to be submitted to compression, based on mount
  * options, defragmentation, properties or heuristics.
@@ -500,7 +489,7 @@ static inline int inode_need_compress(struct btrfs_inode *inode, u64 start,
 {
 	struct btrfs_fs_info *fs_info = inode->root->fs_info;
 
-	if (!inode_can_compress(inode)) {
+	if (!btrfs_inode_can_compress(inode)) {
 		WARN(IS_ENABLED(CONFIG_BTRFS_DEBUG),
 			KERN_ERR "BTRFS: unexpected compression for ino %llu\n",
 			btrfs_ino(inode));
@@ -2019,7 +2008,7 @@ int btrfs_run_delalloc_range(struct btrfs_inode *inode, struct page *locked_page
 		ASSERT(!zoned || btrfs_is_data_reloc_root(inode->root));
 		ret = run_delalloc_nocow(inode, locked_page, start, end,
 					 page_started, nr_written);
-	} else if (!inode_can_compress(inode) ||
+	} else if (!btrfs_inode_can_compress(inode) ||
 		   !inode_need_compress(inode, start, end)) {
 		if (zoned)
 			ret = run_delalloc_zoned(inode, locked_page, start, end,

