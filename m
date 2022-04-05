Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95E5D4F2FAF
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:17:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237460AbiDEJEO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:04:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242667AbiDEItX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:49:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4F7C6A419;
        Tue,  5 Apr 2022 01:37:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B00A661539;
        Tue,  5 Apr 2022 08:37:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD332C385B4;
        Tue,  5 Apr 2022 08:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147839;
        bh=zptyK2nimVICzBITahKX+tewufXiE/uNtdoF6Ehqy8I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ueVFNt/90SVNgDY02efQxBEkPn2xrLC35KHXw9OTmoHNqnkm3GkFQhRQlBHrsCf/k
         oCn4d1aED7IzPIS0DE7nyri4FEkd9dmXldR6kv1KSnU8RqKHirlMkpRsbeRrxesrFc
         kyBeMw+xc/lDSxrmEmL7z2EvHekMCpyyGrvTuMEY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ye Bin <yebin10@huawei.com>,
        stable@kernel.org, Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.16 0140/1017] ext4: fix fs corruption when tring to remove a non-empty directory with IO error
Date:   Tue,  5 Apr 2022 09:17:33 +0200
Message-Id: <20220405070358.359271000@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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
@@ -1788,19 +1788,20 @@ bool empty_inline_dir(struct inode *dir,
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
 
@@ -1809,7 +1810,6 @@ bool empty_inline_dir(struct inode *dir,
 		ext4_warning(dir->i_sb,
 			     "bad inline directory (dir #%lu) - no `..'",
 			     dir->i_ino);
-		ret = true;
 		goto out;
 	}
 
@@ -1828,16 +1828,15 @@ bool empty_inline_dir(struct inode *dir,
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
@@ -2997,14 +2997,14 @@ bool ext4_empty_dir(struct inode *inode)
 	if (inode->i_size < ext4_dir_rec_len(1, NULL) +
 					ext4_dir_rec_len(2, NULL)) {
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
@@ -3012,7 +3012,7 @@ bool ext4_empty_dir(struct inode *inode)
 	    le32_to_cpu(de->inode) != inode->i_ino || strcmp(".", de->name)) {
 		ext4_warning_inode(inode, "directory missing '.'");
 		brelse(bh);
-		return true;
+		return false;
 	}
 	offset = ext4_rec_len_from_disk(de->rec_len, sb->s_blocksize);
 	de = ext4_next_entry(de, sb->s_blocksize);
@@ -3021,7 +3021,7 @@ bool ext4_empty_dir(struct inode *inode)
 	    le32_to_cpu(de->inode) == 0 || strcmp("..", de->name)) {
 		ext4_warning_inode(inode, "directory missing '..'");
 		brelse(bh);
-		return true;
+		return false;
 	}
 	offset += ext4_rec_len_from_disk(de->rec_len, sb->s_blocksize);
 	while (offset < inode->i_size) {
@@ -3035,7 +3035,7 @@ bool ext4_empty_dir(struct inode *inode)
 				continue;
 			}
 			if (IS_ERR(bh))
-				return true;
+				return false;
 		}
 		de = (struct ext4_dir_entry_2 *) (bh->b_data +
 					(offset & (sb->s_blocksize - 1)));


