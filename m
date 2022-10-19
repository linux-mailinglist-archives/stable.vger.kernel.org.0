Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABB20604503
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 14:20:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230331AbiJSMTt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 08:19:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233207AbiJSMTK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 08:19:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E19831004E;
        Wed, 19 Oct 2022 04:54:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3A10CB82256;
        Wed, 19 Oct 2022 08:44:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89A83C433C1;
        Wed, 19 Oct 2022 08:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169061;
        bh=HJEF7endQpM+60VPzFKP7f1JvxvvavZo44m56jkX12A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mnm8IAAlqigkFfsDultPzOp76Z/LIe+sVS0GySWGQMLPBFxss3h6GdDiJCdE/UD7V
         oQcFHxRu9Slnb1vLqa11Zo6cSXGH54K0lty9FzB0tOW0L2aPVa08VSQENiGw8l6eKk
         uxgx3YC4ZBeMmjuoNVsYtVFM1IT+TILUjwsm7SQ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhihao Cheng <chengzhihao1@huawei.com>,
        Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.0 144/862] ext4: fix dir corruption when ext4_dx_add_entry() fails
Date:   Wed, 19 Oct 2022 10:23:51 +0200
Message-Id: <20221019083256.348223732@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhihao Cheng <chengzhihao1@huawei.com>

commit 7177dd009c7c04290891e9a534cd47d1b620bd04 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/namei.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -85,15 +85,20 @@ static struct buffer_head *ext4_append(h
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


