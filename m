Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84A54CA2A4
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:09:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732100AbfJCQHh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:07:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:55456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732972AbfJCQHg (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:07:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA4FA2245C;
        Thu,  3 Oct 2019 16:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570118855;
        bh=hamLF/be2yWDbkm1xolk1kZ1ArBeiYf1ziKgbV1oYKQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sn4x17g3smBNQsSwgFLT+CyhzucDlxEVB5KxVjCuGseHTqBCPxzx14VNJ04WksPR7
         sSET9q3KnXvBrGkQjZr86JsVkx/7EOZdBWAbS9Vksu2kH3r9Rpj6PqF7nT3aZ/6yp4
         18xt9WusifnAjd4aCP34j5OvRF/l/WDVnpCNSH/k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
        Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 033/185] f2fs: use generic EFSBADCRC/EFSCORRUPTED
Date:   Thu,  3 Oct 2019 17:51:51 +0200
Message-Id: <20191003154445.140135573@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154437.541662648@linuxfoundation.org>
References: <20191003154437.541662648@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <yuchao0@huawei.com>

[ Upstream commit 10f966bbf521bb9b2e497bbca496a5141f4071d0 ]

f2fs uses EFAULT as error number to indicate filesystem is corrupted
all the time, but generic filesystems use EUCLEAN for such condition,
we need to change to follow others.

This patch adds two new macros as below to wrap more generic error
code macros, and spread them in code.

EFSBADCRC	EBADMSG		/* Bad CRC detected */
EFSCORRUPTED	EUCLEAN		/* Filesystem is corrupted */

Reported-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Chao Yu <yuchao0@huawei.com>
Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/checkpoint.c | 8 ++++++--
 fs/f2fs/data.c       | 8 ++++----
 fs/f2fs/f2fs.h       | 4 ++++
 fs/f2fs/inline.c     | 4 ++--
 fs/f2fs/inode.c      | 4 ++--
 fs/f2fs/node.c       | 4 ++--
 fs/f2fs/recovery.c   | 2 +-
 fs/f2fs/segment.c    | 7 ++++---
 fs/f2fs/segment.h    | 4 ++--
 fs/f2fs/super.c      | 2 +-
 10 files changed, 28 insertions(+), 19 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index 624817eeb25e3..170423ff27210 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -793,6 +793,7 @@ int get_valid_checkpoint(struct f2fs_sb_info *sbi)
 	unsigned int cp_blks = 1 + __cp_payload(sbi);
 	block_t cp_blk_no;
 	int i;
+	int err;
 
 	sbi->ckpt = kzalloc(cp_blks * blk_size, GFP_KERNEL);
 	if (!sbi->ckpt)
@@ -819,6 +820,7 @@ int get_valid_checkpoint(struct f2fs_sb_info *sbi)
 	} else if (cp2) {
 		cur_page = cp2;
 	} else {
+		err = -EFSCORRUPTED;
 		goto fail_no_cp;
 	}
 
@@ -831,8 +833,10 @@ int get_valid_checkpoint(struct f2fs_sb_info *sbi)
 		sbi->cur_cp_pack = 2;
 
 	/* Sanity checking of checkpoint */
-	if (sanity_check_ckpt(sbi))
+	if (sanity_check_ckpt(sbi)) {
+		err = -EFSCORRUPTED;
 		goto free_fail_no_cp;
+	}
 
 	if (cp_blks <= 1)
 		goto done;
@@ -860,7 +864,7 @@ int get_valid_checkpoint(struct f2fs_sb_info *sbi)
 	f2fs_put_page(cp2, 1);
 fail_no_cp:
 	kfree(sbi->ckpt);
-	return -EINVAL;
+	return err;
 }
 
 static void __add_dirty_inode(struct inode *inode, enum inode_type type)
diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 113d1cd551192..cc57294451940 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -376,7 +376,7 @@ int f2fs_submit_page_bio(struct f2fs_io_info *fio)
 
 	if (!f2fs_is_valid_blkaddr(fio->sbi, fio->new_blkaddr,
 			__is_meta_io(fio) ? META_GENERIC : DATA_GENERIC))
-		return -EFAULT;
+		return -EFSCORRUPTED;
 
 	trace_f2fs_submit_page_bio(page, fio);
 	f2fs_trace_ios(fio, 0);
@@ -959,7 +959,7 @@ int f2fs_map_blocks(struct inode *inode, struct f2fs_map_blocks *map,
 
 	if (__is_valid_data_blkaddr(blkaddr) &&
 		!f2fs_is_valid_blkaddr(sbi, blkaddr, DATA_GENERIC)) {
-		err = -EFAULT;
+		err = -EFSCORRUPTED;
 		goto sync_out;
 	}
 
@@ -1425,7 +1425,7 @@ int do_write_data_page(struct f2fs_io_info *fio)
 
 		if (!f2fs_is_valid_blkaddr(fio->sbi, fio->old_blkaddr,
 							DATA_GENERIC))
-			return -EFAULT;
+			return -EFSCORRUPTED;
 
 		ipu_force = true;
 		fio->need_lock = LOCK_DONE;
@@ -1451,7 +1451,7 @@ int do_write_data_page(struct f2fs_io_info *fio)
 	if (__is_valid_data_blkaddr(fio->old_blkaddr) &&
 		!f2fs_is_valid_blkaddr(fio->sbi, fio->old_blkaddr,
 							DATA_GENERIC)) {
-		err = -EFAULT;
+		err = -EFSCORRUPTED;
 		goto out_writepage;
 	}
 	/*
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 6caae471c1a45..268409cee1c34 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -3089,3 +3089,7 @@ static inline bool f2fs_may_encrypt(struct inode *inode)
 }
 
 #endif
+
+#define EFSBADCRC	EBADMSG		/* Bad CRC detected */
+#define EFSCORRUPTED	EUCLEAN		/* Filesystem is corrupted */
+
diff --git a/fs/f2fs/inline.c b/fs/f2fs/inline.c
index 506e365cf903e..8906f6381b1a4 100644
--- a/fs/f2fs/inline.c
+++ b/fs/f2fs/inline.c
@@ -135,7 +135,7 @@ int f2fs_convert_inline_page(struct dnode_of_data *dn, struct page *page)
 			"%s: corrupted inline inode ino=%lx, i_addr[0]:0x%x, "
 			"run fsck to fix.",
 			__func__, dn->inode->i_ino, dn->data_blkaddr);
-		return -EINVAL;
+		return -EFSCORRUPTED;
 	}
 
 	f2fs_bug_on(F2FS_P_SB(page), PageWriteback(page));
@@ -382,7 +382,7 @@ static int f2fs_move_inline_dirents(struct inode *dir, struct page *ipage,
 			"%s: corrupted inline inode ino=%lx, i_addr[0]:0x%x, "
 			"run fsck to fix.",
 			__func__, dir->i_ino, dn.data_blkaddr);
-		err = -EINVAL;
+		err = -EFSCORRUPTED;
 		goto out;
 	}
 
diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
index e02ed16bc35cd..c6d0687f00fee 100644
--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -70,7 +70,7 @@ static int __written_first_block(struct f2fs_sb_info *sbi,
 	if (!__is_valid_data_blkaddr(addr))
 		return 1;
 	if (!f2fs_is_valid_blkaddr(sbi, addr, DATA_GENERIC))
-		return -EFAULT;
+		return -EFSCORRUPTED;
 	return 0;
 }
 
@@ -300,7 +300,7 @@ static int do_read_inode(struct inode *inode)
 
 	if (!sanity_check_inode(inode, node_page)) {
 		f2fs_put_page(node_page, 1);
-		return -EINVAL;
+		return -EFSCORRUPTED;
 	}
 
 	/* check data exist */
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 12060fbfbb05e..e7b8e2b35e226 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -39,7 +39,7 @@ int check_nid_range(struct f2fs_sb_info *sbi, nid_t nid)
 		f2fs_msg(sbi->sb, KERN_WARNING,
 				"%s: out-of-range nid=%x, run fsck to fix.",
 				__func__, nid);
-		return -EINVAL;
+		return -EFSCORRUPTED;
 	}
 	return 0;
 }
@@ -1195,7 +1195,7 @@ static struct page *__get_node_page(struct f2fs_sb_info *sbi, pgoff_t nid,
 	}
 
 	if (!f2fs_inode_chksum_verify(sbi, page)) {
-		err = -EBADMSG;
+		err = -EFSBADCRC;
 		goto out_err;
 	}
 page_hit:
diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
index 65a82c5bafcbe..db357e9ad5990 100644
--- a/fs/f2fs/recovery.c
+++ b/fs/f2fs/recovery.c
@@ -451,7 +451,7 @@ static int do_recover_data(struct f2fs_sb_info *sbi, struct inode *inode,
 			"Inconsistent ofs_of_node, ino:%lu, ofs:%u, %u",
 			inode->i_ino, ofs_of_node(dn.node_page),
 			ofs_of_node(page));
-		err = -EFAULT;
+		err = -EFSCORRUPTED;
 		goto err;
 	}
 
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 294fdb1b22137..9e5fca35e47d0 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -2216,6 +2216,7 @@ int f2fs_trim_fs(struct f2fs_sb_info *sbi, struct fstrim_range *range)
 	if (is_sbi_flag_set(sbi, SBI_NEED_FSCK)) {
 		f2fs_msg(sbi->sb, KERN_WARNING,
 			"Found FS corruption, run fsck to fix.");
+		err = -EFSCORRUPTED;
 		goto out;
 	}
 
@@ -3309,7 +3310,7 @@ static int build_sit_entries(struct f2fs_sb_info *sbi)
 					"Wrong journal entry on segno %u",
 					start);
 			set_sbi_flag(sbi, SBI_NEED_FSCK);
-			err = -EINVAL;
+			err = -EFSCORRUPTED;
 			break;
 		}
 
@@ -3350,7 +3351,7 @@ static int build_sit_entries(struct f2fs_sb_info *sbi)
 			"SIT is corrupted node# %u vs %u",
 			total_node_blocks, valid_node_count(sbi));
 		set_sbi_flag(sbi, SBI_NEED_FSCK);
-		err = -EINVAL;
+		err = -EFSCORRUPTED;
 	}
 
 	return err;
@@ -3468,7 +3469,7 @@ static int sanity_check_curseg(struct f2fs_sb_info *sbi)
 				"segno:%u, type:%u, next_blkoff:%u, blkofs:%u",
 				i, curseg->segno, curseg->alloc_type,
 				curseg->next_blkoff, blkofs);
-			return -EINVAL;
+			return -EFSCORRUPTED;
 		}
 	}
 	return 0;
diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h
index e3d8826c5113d..0d46e936d54ed 100644
--- a/fs/f2fs/segment.h
+++ b/fs/f2fs/segment.h
@@ -665,7 +665,7 @@ static inline int check_block_count(struct f2fs_sb_info *sbi,
 				"Mismatch valid blocks %d vs. %d",
 					GET_SIT_VBLOCKS(raw_sit), valid_blocks);
 		set_sbi_flag(sbi, SBI_NEED_FSCK);
-		return -EINVAL;
+		return -EFSCORRUPTED;
 	}
 
 	/* check segment usage, and check boundary of a given segment number */
@@ -675,7 +675,7 @@ static inline int check_block_count(struct f2fs_sb_info *sbi,
 				"Wrong valid blocks %d or segno %u",
 					GET_SIT_VBLOCKS(raw_sit), segno);
 		set_sbi_flag(sbi, SBI_NEED_FSCK);
-		return -EINVAL;
+		return -EFSCORRUPTED;
 	}
 	return 0;
 }
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index ad839a7996e9b..344aa861774bd 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -2220,7 +2220,7 @@ static int read_raw_super_block(struct f2fs_sb_info *sbi,
 			f2fs_msg(sb, KERN_ERR,
 				"Can't find valid F2FS filesystem in %dth superblock",
 				block + 1);
-			err = -EINVAL;
+			err = -EFSCORRUPTED;
 			brelse(bh);
 			continue;
 		}
-- 
2.20.1



