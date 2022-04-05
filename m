Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34B354F3ABF
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 17:04:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240386AbiDELrb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:47:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355228AbiDEKSh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:18:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F9CD38B8;
        Tue,  5 Apr 2022 03:04:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4F9B0B81C8B;
        Tue,  5 Apr 2022 10:04:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2AD3C385B5;
        Tue,  5 Apr 2022 10:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649153068;
        bh=f+uDxiRuFTIs+PAR4oqtQd+ZBsuICTSJlk0ujjCc4CI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YEJpdx0J7DQItPB7Z9D6P7CDHH9E4BnXLbgnh1sCtTh/29FIhMa0La9DwWffEJ6CI
         n1fR57EAMOukvUYuKagZ5SoFgqBv6wM/I2fBz1b9uIvxtwx1YY9L2rIMQMIiCmPDB6
         YIHJRTU0ID3sIeKqs4iMgXct6RTm093SMaT33tcM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ye Bin <yebin10@huawei.com>,
        stable@kernel.org, Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.10 091/599] ext4: fix fs corruption when tring to remove a non-empty directory with IO error
Date:   Tue,  5 Apr 2022 09:26:25 +0200
Message-Id: <20220405070301.537777044@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ye Bin <yebin10@huawei.com>

commit 7aab5c84a0f6ec2290e2ba4a6b245178b1bf949a upstream.

We inject IO error when rmdir non empty direcory, then got issue as follows:
step1: mkfs.ext4 -F /dev/sda
step2: mount /dev/sda  test
step3: cd test
step4: mkdir -p 1/2
step5: rmdir 1
	[  110.920551] ext4_empty_dir: inject fault
	[  110.921926] EXT4-fs warning (device sda): ext4_rmdir:3113: inode #12:
	comm rmdir: empty directory '1' has too many links (3)
step6: cd ..
step7: umount test
step8: fsck.ext4 -f /dev/sda
	e2fsck 1.42.9 (28-Dec-2013)
	Pass 1: Checking inodes, blocks, and sizes
	Pass 2: Checking directory structure
	Entry '..' in .../??? (13) has deleted/unused inode 12.  Clear<y>? yes
	Pass 3: Checking directory connectivity
	Unconnected directory inode 13 (...)
	Connect to /lost+found<y>? yes
	Pass 4: Checking reference counts
	Inode 13 ref count is 3, should be 2.  Fix<y>? yes
	Pass 5: Checking group summary information

	/dev/sda: ***** FILE SYSTEM WAS MODIFIED *****
	/dev/sda: 12/131072 files (0.0% non-contiguous), 26157/524288 blocks

ext4_rmdir
	if (!ext4_empty_dir(inode))
		goto end_rmdir;
ext4_empty_dir
	bh = ext4_read_dirblock(inode, 0, DIRENT_HTREE);
	if (IS_ERR(bh))
		return true;
Now if read directory block failed, 'ext4_empty_dir' will return true, assume
directory is empty. Obviously, it will lead to above issue.
To solve this issue, if read directory block failed 'ext4_empty_dir' just
return false. To avoid making things worse when file system is already
corrupted, 'ext4_empty_dir' also return false.

Signed-off-by: Ye Bin <yebin10@huawei.com>
Cc: stable@kernel.org
Link: https://lore.kernel.org/r/20220228024815.3952506-1-yebin10@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/inline.c |    9 ++++-----
 fs/ext4/namei.c  |   10 +++++-----
 2 files changed, 9 insertions(+), 10 deletions(-)

--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -1768,19 +1768,20 @@ bool empty_inline_dir(struct inode *dir,
 	void *inline_pos;
 	unsigned int offset;
 	struct ext4_dir_entry_2 *de;
-	bool ret = true;
+	bool ret = false;
 
 	err = ext4_get_inode_loc(dir, &iloc);
 	if (err) {
 		EXT4_ERROR_INODE_ERR(dir, -err,
 				     "error %d getting inode %lu block",
 				     err, dir->i_ino);
-		return true;
+		return false;
 	}
 
 	down_read(&EXT4_I(dir)->xattr_sem);
 	if (!ext4_has_inline_data(dir)) {
 		*has_inline_data = 0;
+		ret = true;
 		goto out;
 	}
 
@@ -1789,7 +1790,6 @@ bool empty_inline_dir(struct inode *dir,
 		ext4_warning(dir->i_sb,
 			     "bad inline directory (dir #%lu) - no `..'",
 			     dir->i_ino);
-		ret = true;
 		goto out;
 	}
 
@@ -1808,16 +1808,15 @@ bool empty_inline_dir(struct inode *dir,
 				     dir->i_ino, le32_to_cpu(de->inode),
 				     le16_to_cpu(de->rec_len), de->name_len,
 				     inline_size);
-			ret = true;
 			goto out;
 		}
 		if (le32_to_cpu(de->inode)) {
-			ret = false;
 			goto out;
 		}
 		offset += ext4_rec_len_from_disk(de->rec_len, inline_size);
 	}
 
+	ret = true;
 out:
 	up_read(&EXT4_I(dir)->xattr_sem);
 	brelse(iloc.bh);
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2868,14 +2868,14 @@ bool ext4_empty_dir(struct inode *inode)
 	sb = inode->i_sb;
 	if (inode->i_size < EXT4_DIR_REC_LEN(1) + EXT4_DIR_REC_LEN(2)) {
 		EXT4_ERROR_INODE(inode, "invalid size");
-		return true;
+		return false;
 	}
 	/* The first directory block must not be a hole,
 	 * so treat it as DIRENT_HTREE
 	 */
 	bh = ext4_read_dirblock(inode, 0, DIRENT_HTREE);
 	if (IS_ERR(bh))
-		return true;
+		return false;
 
 	de = (struct ext4_dir_entry_2 *) bh->b_data;
 	if (ext4_check_dir_entry(inode, NULL, de, bh, bh->b_data, bh->b_size,
@@ -2883,7 +2883,7 @@ bool ext4_empty_dir(struct inode *inode)
 	    le32_to_cpu(de->inode) != inode->i_ino || strcmp(".", de->name)) {
 		ext4_warning_inode(inode, "directory missing '.'");
 		brelse(bh);
-		return true;
+		return false;
 	}
 	offset = ext4_rec_len_from_disk(de->rec_len, sb->s_blocksize);
 	de = ext4_next_entry(de, sb->s_blocksize);
@@ -2892,7 +2892,7 @@ bool ext4_empty_dir(struct inode *inode)
 	    le32_to_cpu(de->inode) == 0 || strcmp("..", de->name)) {
 		ext4_warning_inode(inode, "directory missing '..'");
 		brelse(bh);
-		return true;
+		return false;
 	}
 	offset += ext4_rec_len_from_disk(de->rec_len, sb->s_blocksize);
 	while (offset < inode->i_size) {
@@ -2906,7 +2906,7 @@ bool ext4_empty_dir(struct inode *inode)
 				continue;
 			}
 			if (IS_ERR(bh))
-				return true;
+				return false;
 		}
 		de = (struct ext4_dir_entry_2 *) (bh->b_data +
 					(offset & (sb->s_blocksize - 1)));


