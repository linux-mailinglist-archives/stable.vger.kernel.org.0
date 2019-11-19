Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C882E1018D6
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:11:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727908AbfKSGJb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 01:09:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:47120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727658AbfKSF2k (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:28:40 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 79D6821783;
        Tue, 19 Nov 2019 05:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141319;
        bh=vhKnsVvdS3bhGTQPSXRiTcKVgFkmQF7EkajVkSUKU9w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IcvpejCQg29VVM2us7k+jAp77gzZJJemmLqdhesil2FCNj6nkDfwlLuzJeFxsYpnJ
         lecBqgsKsoUWqqqPRDQgTVvDTtqWLxj/3pcVq/dBKlhfiO+gCDgCIx82kYR3WODzA1
         Osg9mV3guprtbPrltJwf78lIRQWMAJh8xOSRM864=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <yuchao0@huawei.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 120/422] f2fs: avoid wrong decrypted data from disk
Date:   Tue, 19 Nov 2019 06:15:17 +0100
Message-Id: <20191119051406.817606287@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaegeuk Kim <jaegeuk@kernel.org>

[ Upstream commit 0ded69f632bb717be9aeea3ae74e29050fcb060c ]

1. Create a file in an encrypted directory
2. Do GC & drop caches
3. Read stale data before its bio for metapage was not issued yet

Reviewed-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/data.c    | 18 ++++++++++--------
 fs/f2fs/f2fs.h    |  2 +-
 fs/f2fs/file.c    |  3 +--
 fs/f2fs/segment.c |  6 +++++-
 4 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 9511466bc7857..c61beaedf0789 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -575,9 +575,6 @@ static struct bio *f2fs_grab_read_bio(struct inode *inode, block_t blkaddr,
 		ctx->bio = bio;
 		ctx->enabled_steps = post_read_steps;
 		bio->bi_private = ctx;
-
-		/* wait the page to be moved by cleaning */
-		f2fs_wait_on_block_writeback(sbi, blkaddr);
 	}
 
 	return bio;
@@ -592,6 +589,9 @@ static int f2fs_submit_page_read(struct inode *inode, struct page *page,
 	if (IS_ERR(bio))
 		return PTR_ERR(bio);
 
+	/* wait for GCed page writeback via META_MAPPING */
+	f2fs_wait_on_block_writeback(inode, blkaddr);
+
 	if (bio_add_page(bio, page, PAGE_SIZE, 0) < PAGE_SIZE) {
 		bio_put(bio);
 		return -EFAULT;
@@ -1569,6 +1569,12 @@ submit_and_realloc:
 			}
 		}
 
+		/*
+		 * If the page is under writeback, we need to wait for
+		 * its completion to see the correct decrypted data.
+		 */
+		f2fs_wait_on_block_writeback(inode, block_nr);
+
 		if (bio_add_page(bio, page, blocksize, 0) < blocksize)
 			goto submit_and_realloc;
 
@@ -1637,7 +1643,7 @@ static int encrypt_one_page(struct f2fs_io_info *fio)
 		return 0;
 
 	/* wait for GCed page writeback via META_MAPPING */
-	f2fs_wait_on_block_writeback(fio->sbi, fio->old_blkaddr);
+	f2fs_wait_on_block_writeback(inode, fio->old_blkaddr);
 
 retry_encrypt:
 	fio->encrypted_page = fscrypt_encrypt_page(inode, fio->page,
@@ -2402,10 +2408,6 @@ repeat:
 
 	f2fs_wait_on_page_writeback(page, DATA, false);
 
-	/* wait for GCed page writeback via META_MAPPING */
-	if (f2fs_post_read_required(inode))
-		f2fs_wait_on_block_writeback(sbi, blkaddr);
-
 	if (len == PAGE_SIZE || PageUptodate(page))
 		return 0;
 
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index fb216488d67a9..6d361c8c61306 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -2973,7 +2973,7 @@ void f2fs_allocate_data_block(struct f2fs_sb_info *sbi, struct page *page,
 			struct f2fs_io_info *fio, bool add_list);
 void f2fs_wait_on_page_writeback(struct page *page,
 			enum page_type type, bool ordered);
-void f2fs_wait_on_block_writeback(struct f2fs_sb_info *sbi, block_t blkaddr);
+void f2fs_wait_on_block_writeback(struct inode *inode, block_t blkaddr);
 void f2fs_write_data_summaries(struct f2fs_sb_info *sbi, block_t start_blk);
 void f2fs_write_node_summaries(struct f2fs_sb_info *sbi, block_t start_blk);
 int f2fs_lookup_journal_in_cursum(struct f2fs_journal *journal, int type,
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 8d1eb8dec6058..6972c6d7c3893 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -112,8 +112,7 @@ mapped:
 	f2fs_wait_on_page_writeback(page, DATA, false);
 
 	/* wait for GCed page writeback via META_MAPPING */
-	if (f2fs_post_read_required(inode))
-		f2fs_wait_on_block_writeback(sbi, dn.data_blkaddr);
+	f2fs_wait_on_block_writeback(inode, dn.data_blkaddr);
 
 out_sem:
 	up_read(&F2FS_I(inode)->i_mmap_sem);
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 10d5dcdb34be6..d78009694f3fd 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -3214,10 +3214,14 @@ void f2fs_wait_on_page_writeback(struct page *page,
 	}
 }
 
-void f2fs_wait_on_block_writeback(struct f2fs_sb_info *sbi, block_t blkaddr)
+void f2fs_wait_on_block_writeback(struct inode *inode, block_t blkaddr)
 {
+	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
 	struct page *cpage;
 
+	if (!f2fs_post_read_required(inode))
+		return;
+
 	if (!is_valid_data_blkaddr(sbi, blkaddr))
 		return;
 
-- 
2.20.1



