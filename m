Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 108785FFF85
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 15:21:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbiJPNVT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 09:21:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbiJPNVS (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 09:21:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C916532DA1
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 06:21:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6651160B76
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 13:21:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76B0AC433C1;
        Sun, 16 Oct 2022 13:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665926476;
        bh=vzWIQjTACHs+g0jsDChxFj6hgtBpMtIaMFSj9tvShgM=;
        h=Subject:To:Cc:From:Date:From;
        b=0ZLYIHp5QN7cyXizba/8hvx8fmjs6F+mitDDn25c8iCjsiB57LrTChD04q8+PvrfH
         5QM35t3bfOuV9ZCGk1lr/66NZE4rbM6Wlv4HyIcTxtrlsdigSMV/vOO3qqCD7XpBF/
         D5DuUajhaSwuKb7fQOJ/zignJFvzZl3JMbWn7now=
Subject: FAILED: patch "[PATCH] ext4: fix dir corruption when ext4_dx_add_entry() fails" failed to apply to 5.10-stable tree
To:     chengzhihao1@huawei.com, jack@suse.cz, tytso@mit.edu
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 16 Oct 2022 15:21:59 +0200
Message-ID: <1665926519239243@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

7177dd009c7c ("ext4: fix dir corruption when ext4_dx_add_entry() fails")
188c299e2a26 ("ext4: Support for checksumming from journal triggers")
c915fb80eaa6 ("ext4: fix bh ref count on error paths")
a3f5cf14ff91 ("ext4: drop ext4_handle_dirty_super()")
05c2c00f3769 ("ext4: protect superblock modifications with a buffer lock")
4392fbc4bab5 ("ext4: drop sync argument of ext4_commit_super()")
c92dc856848f ("ext4: defer saving error info from atomic context")
02a7780e4d2f ("ext4: simplify ext4 error translation")
4067662388f9 ("ext4: move functions in super.c")
014c9caa29d3 ("ext4: make ext4_abort() use __ext4_error()")
b08070eca9e2 ("ext4: don't remount read-only with errors=continue on reboot")
ca9b404ff137 ("ext4: print quota journalling mode on (re-)mount")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 7177dd009c7c04290891e9a534cd47d1b620bd04 Mon Sep 17 00:00:00 2001
From: Zhihao Cheng <chengzhihao1@huawei.com>
Date: Sun, 11 Sep 2022 12:52:04 +0800
Subject: [PATCH] ext4: fix dir corruption when ext4_dx_add_entry() fails

Following process may lead to fs corruption:
1. ext4_create(dir/foo)
 ext4_add_nondir
  ext4_add_entry
   ext4_dx_add_entry
     a. add_dirent_to_buf
      ext4_mark_inode_dirty
      ext4_handle_dirty_metadata   // dir inode bh is recorded into journal
     b. ext4_append    // dx_get_count(entries) == dx_get_limit(entries)
       ext4_bread(EXT4_GET_BLOCKS_CREATE)
        ext4_getblk
         ext4_map_blocks
          ext4_ext_map_blocks
            ext4_mb_new_blocks
             dquot_alloc_block
              dquot_alloc_space_nodirty
               inode_add_bytes    // update dir's i_blocks
            ext4_ext_insert_extent
	     ext4_ext_dirty  // record extent bh into journal
              ext4_handle_dirty_metadata(bh)
	      // record new block into journal
       inode->i_size += inode->i_sb->s_blocksize   // new size(in mem)
     c. ext4_handle_dirty_dx_node(bh2)
	// record dir's new block(dx_node) into journal
     d. ext4_handle_dirty_dx_node((frame - 1)->bh)
     e. ext4_handle_dirty_dx_node(frame->bh)
     f. do_split    // ret err!
     g. add_dirent_to_buf
	 ext4_mark_inode_dirty(dir)  // update raw_inode on disk(skipped)
2. fsck -a /dev/sdb
 drop last block(dx_node) which beyonds dir's i_size.
  /dev/sdb: recovering journal
  /dev/sdb contains a file system with errors, check forced.
  /dev/sdb: Inode 12, end of extent exceeds allowed value
	(logical block 128, physical block 3938, len 1)
3. fsck -fn /dev/sdb
 dx_node->entry[i].blk > dir->i_size
  Pass 2: Checking directory structure
  Problem in HTREE directory inode 12 (/dir): bad block number 128.
  Clear HTree index? no
  Problem in HTREE directory inode 12: block #3 has invalid depth (2)
  Problem in HTREE directory inode 12: block #3 has bad max hash
  Problem in HTREE directory inode 12: block #3 not referenced

Fix it by marking inode dirty directly inside ext4_append().
Fetch a reproducer in [Link].

Link: https://bugzilla.kernel.org/show_bug.cgi?id=216466
Cc: stable@vger.kernel.org
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20220911045204.516460-1-chengzhihao1@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index bc2e0612ec32..4183a4cb4a21 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -85,15 +85,20 @@ static struct buffer_head *ext4_append(handle_t *handle,
 		return bh;
 	inode->i_size += inode->i_sb->s_blocksize;
 	EXT4_I(inode)->i_disksize = inode->i_size;
+	err = ext4_mark_inode_dirty(handle, inode);
+	if (err)
+		goto out;
 	BUFFER_TRACE(bh, "get_write_access");
 	err = ext4_journal_get_write_access(handle, inode->i_sb, bh,
 					    EXT4_JTR_NONE);
-	if (err) {
-		brelse(bh);
-		ext4_std_error(inode->i_sb, err);
-		return ERR_PTR(err);
-	}
+	if (err)
+		goto out;
 	return bh;
+
+out:
+	brelse(bh);
+	ext4_std_error(inode->i_sb, err);
+	return ERR_PTR(err);
 }
 
 static int ext4_dx_csum_verify(struct inode *inode,

