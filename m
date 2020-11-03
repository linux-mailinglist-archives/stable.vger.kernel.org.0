Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 617182A575A
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:42:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730802AbgKCVmI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:42:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:56598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732055AbgKCUzn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:55:43 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5AD0222226;
        Tue,  3 Nov 2020 20:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436942;
        bh=UF9k1jimG33NR+B01t3IBLaw3xUqSgNa+NY9u22Q8qo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IpjZ9meKt5fY4uifM8Qp1//LKWoY3Tx3xoPa5rE+VnfOf2jTkcBhn1TuUYGVgM3W8
         ZcErkDcONviQwqaePwEXQPuDDKTZ+i/2EyEsozIAT/oPAG+h4cIjdmF9cAlqIYP1P8
         kAoPuTIlixJSC/HNGInrRpfLdv2r0g9GizQNKPf8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+ee250ac8137be41d7b13@syzkaller.appspotmail.com,
        Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 030/214] f2fs: handle errors of f2fs_get_meta_page_nofail
Date:   Tue,  3 Nov 2020 21:34:38 +0100
Message-Id: <20201103203252.907563273@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203249.448706377@linuxfoundation.org>
References: <20201103203249.448706377@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaegeuk Kim <jaegeuk@kernel.org>

[ Upstream commit 86f33603f8c51537265ff7ac0320638fd2cbdb1b ]

First problem is we hit BUG_ON() in f2fs_get_sum_page given EIO on
f2fs_get_meta_page_nofail().

Quick fix was not to give any error with infinite loop, but syzbot caught
a case where it goes to that loop from fuzzed image. In turned out we abused
f2fs_get_meta_page_nofail() like in the below call stack.

- f2fs_fill_super
 - f2fs_build_segment_manager
  - build_sit_entries
   - get_current_sit_page

INFO: task syz-executor178:6870 can't die for more than 143 seconds.
task:syz-executor178 state:R
 stack:26960 pid: 6870 ppid:  6869 flags:0x00004006
Call Trace:

Showing all locks held in the system:
1 lock held by khungtaskd/1179:
 #0: ffffffff8a554da0 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x53/0x260 kernel/locking/lockdep.c:6242
1 lock held by systemd-journal/3920:
1 lock held by in:imklog/6769:
 #0: ffff88809eebc130 (&f->f_pos_lock){+.+.}-{3:3}, at: __fdget_pos+0xe9/0x100 fs/file.c:930
1 lock held by syz-executor178/6870:
 #0: ffff8880925120e0 (&type->s_umount_key#47/1){+.+.}-{3:3}, at: alloc_super+0x201/0xaf0 fs/super.c:229

Actually, we didn't have to use _nofail in this case, since we could return
error to mount(2) already with the error handler.

As a result, this patch tries to 1) remove _nofail callers as much as possible,
2) deal with error case in last remaining caller, f2fs_get_sum_page().

Reported-by: syzbot+ee250ac8137be41d7b13@syzkaller.appspotmail.com
Reviewed-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/checkpoint.c |  2 +-
 fs/f2fs/f2fs.h       |  2 +-
 fs/f2fs/node.c       |  2 +-
 fs/f2fs/segment.c    | 12 +++++++++---
 4 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index 6d9be7783d25c..c966ccc44c157 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -108,7 +108,7 @@ struct page *f2fs_get_meta_page(struct f2fs_sb_info *sbi, pgoff_t index)
 	return __get_meta_page(sbi, index, true);
 }
 
-struct page *f2fs_get_meta_page_nofail(struct f2fs_sb_info *sbi, pgoff_t index)
+struct page *f2fs_get_meta_page_retry(struct f2fs_sb_info *sbi, pgoff_t index)
 {
 	struct page *page;
 	int count = 0;
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index b3b7e63394be7..63440abe58c42 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -3149,7 +3149,7 @@ enum rw_hint f2fs_io_type_to_rw_hint(struct f2fs_sb_info *sbi,
 void f2fs_stop_checkpoint(struct f2fs_sb_info *sbi, bool end_io);
 struct page *f2fs_grab_meta_page(struct f2fs_sb_info *sbi, pgoff_t index);
 struct page *f2fs_get_meta_page(struct f2fs_sb_info *sbi, pgoff_t index);
-struct page *f2fs_get_meta_page_nofail(struct f2fs_sb_info *sbi, pgoff_t index);
+struct page *f2fs_get_meta_page_retry(struct f2fs_sb_info *sbi, pgoff_t index);
 struct page *f2fs_get_tmp_page(struct f2fs_sb_info *sbi, pgoff_t index);
 bool f2fs_is_valid_blkaddr(struct f2fs_sb_info *sbi,
 					block_t blkaddr, int type);
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index ed12e96681842..2a4a382f28fed 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -109,7 +109,7 @@ static void clear_node_page_dirty(struct page *page)
 
 static struct page *get_current_nat_page(struct f2fs_sb_info *sbi, nid_t nid)
 {
-	return f2fs_get_meta_page_nofail(sbi, current_nat_addr(sbi, nid));
+	return f2fs_get_meta_page(sbi, current_nat_addr(sbi, nid));
 }
 
 static struct page *get_next_nat_page(struct f2fs_sb_info *sbi, nid_t nid)
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 7d85784012678..5ba677f85533c 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -2310,7 +2310,9 @@ int f2fs_npages_for_summary_flush(struct f2fs_sb_info *sbi, bool for_ra)
  */
 struct page *f2fs_get_sum_page(struct f2fs_sb_info *sbi, unsigned int segno)
 {
-	return f2fs_get_meta_page_nofail(sbi, GET_SUM_BLOCK(sbi, segno));
+	if (unlikely(f2fs_cp_error(sbi)))
+		return ERR_PTR(-EIO);
+	return f2fs_get_meta_page_retry(sbi, GET_SUM_BLOCK(sbi, segno));
 }
 
 void f2fs_update_meta_page(struct f2fs_sb_info *sbi,
@@ -2582,7 +2584,11 @@ static void change_curseg(struct f2fs_sb_info *sbi, int type)
 	__next_free_blkoff(sbi, curseg, 0);
 
 	sum_page = f2fs_get_sum_page(sbi, new_segno);
-	f2fs_bug_on(sbi, IS_ERR(sum_page));
+	if (IS_ERR(sum_page)) {
+		/* GC won't be able to use stale summary pages by cp_error */
+		memset(curseg->sum_blk, 0, SUM_ENTRY_SIZE);
+		return;
+	}
 	sum_node = (struct f2fs_summary_block *)page_address(sum_page);
 	memcpy(curseg->sum_blk, sum_node, SUM_ENTRY_SIZE);
 	f2fs_put_page(sum_page, 1);
@@ -3713,7 +3719,7 @@ int f2fs_lookup_journal_in_cursum(struct f2fs_journal *journal, int type,
 static struct page *get_current_sit_page(struct f2fs_sb_info *sbi,
 					unsigned int segno)
 {
-	return f2fs_get_meta_page_nofail(sbi, current_sit_addr(sbi, segno));
+	return f2fs_get_meta_page(sbi, current_sit_addr(sbi, segno));
 }
 
 static struct page *get_next_sit_page(struct f2fs_sb_info *sbi,
-- 
2.27.0



