Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D548343F1E1
	for <lists+stable@lfdr.de>; Thu, 28 Oct 2021 23:36:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231418AbhJ1Viu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Oct 2021 17:38:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:55862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231382AbhJ1Viq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 28 Oct 2021 17:38:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6137360FF2;
        Thu, 28 Oct 2021 21:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1635456978;
        bh=OjR2vCQN6oERDvMoeORfA7FJfBGqjKGPXWFtPG6j5xM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=nZB/XIgZuttk3TUtLZnvTRnvujYr1DYoUWxpd+g6SOs74eoTdXtZ9ui8ecIBzLU2m
         7iaK/bDygOplYdYIeOgJJEydBl5HimMe7R25D7pmBguCiuZFqBJohzdIhA4iQQ+KAl
         yXgmGTwPtSU87AGoeE2khgOuW9PwOeDlWCX+LGQ0=
Date:   Thu, 28 Oct 2021 14:36:17 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, gautham.ananthakrishna@oracle.com,
        gechangwei@live.cn, ghe@suse.com, jlbec@evilplan.org,
        joseph.qi@linux.alibaba.com, junxiao.bi@oracle.com,
        linux-mm@kvack.org, mark@fasheh.com, mm-commits@vger.kernel.org,
        piaojun@huawei.com, rajesh.sivaramasubramaniom@oracle.com,
        stable@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 05/11] ocfs2: fix race between searching chunks
 and release journal_head from buffer_head
Message-ID: <20211028213617.Qwy6hYti3%akpm@linux-foundation.org>
In-Reply-To: <20211028143506.5f5d5e2cd1f768a1da864844@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gautham Ananthakrishna <gautham.ananthakrishna@oracle.com>
Subject: ocfs2: fix race between searching chunks and release journal_head from buffer_head

Encountered a race between ocfs2_test_bg_bit_allocatable() and
jbd2_journal_put_journal_head() resulting in the below vmcore.

PID: 106879  TASK: ffff880244ba9c00  CPU: 2   COMMAND: "loop3"
 0 [ffff8802435ff1c0] panic at ffffffff816ed175
 1 [ffff8802435ff240] oops_end at ffffffff8101a7c9
 2 [ffff8802435ff270] no_context at ffffffff8106eccf
 3 [ffff8802435ff2e0] __bad_area_nosemaphore at ffffffff8106ef9d
 4 [ffff8802435ff330] bad_area_nosemaphore at ffffffff8106f143
 5 [ffff8802435ff340] __do_page_fault at ffffffff8106f80b
 6 [ffff8802435ff3a0] do_page_fault at ffffffff8106fc2f
 7 [ffff8802435ff3e0] page_fault at ffffffff816fd667
    [exception RIP: ocfs2_block_group_find_clear_bits+316]
    RIP: ffffffffc11ef6fc  RSP: ffff8802435ff498  RFLAGS: 00010206
    RAX: 0000000000003918  RBX: 0000000000000001  RCX: 0000000000000018
    RDX: 0000000000003918  RSI: 0000000000000000  RDI: ffff880060194040
    RBP: ffff8802435ff4f8   R8: ffffffffff000000   R9: ffffffffffffffff
    R10: ffff8802435ff730  R11: ffff8802a94e5800  R12: 0000000000000007
    R13: 0000000000007e00  R14: 0000000000003918  R15: ffff88017c973a28
    ORIG_RAX: ffffffffffffffff  CS: e030  SS: e02b
 8 [ffff8802435ff490] ocfs2_block_group_find_clear_bits at ffffffffc11ef680 [ocfs2]
 9 [ffff8802435ff500] ocfs2_cluster_group_search at ffffffffc11ef916 [ocfs2]
10 [ffff8802435ff580] ocfs2_search_chain at ffffffffc11f0fb6 [ocfs2]
11 [ffff8802435ff660] ocfs2_claim_suballoc_bits at ffffffffc11f1b1b [ocfs2]
12 [ffff8802435ff6f0] __ocfs2_claim_clusters at ffffffffc11f32cb [ocfs2]
13 [ffff8802435ff770] ocfs2_claim_clusters at ffffffffc11f5caf [ocfs2]
14 [ffff8802435ff780] ocfs2_local_alloc_slide_window at ffffffffc11cc0db [ocfs2]
15 [ffff8802435ff820] ocfs2_reserve_local_alloc_bits at ffffffffc11ce53f [ocfs2]
16 [ffff8802435ff890] ocfs2_reserve_clusters_with_limit at ffffffffc11f59b5 [ocfs2]
17 [ffff8802435ff8e0] ocfs2_reserve_clusters at ffffffffc11f5c88 [ocfs2]
18 [ffff8802435ff8f0] ocfs2_lock_refcount_allocators at ffffffffc11dc169 [ocfs2]
19 [ffff8802435ff960] ocfs2_make_clusters_writable at ffffffffc11e4274 [ocfs2]
20 [ffff8802435ffa50] ocfs2_replace_cow at ffffffffc11e4df1 [ocfs2]
21 [ffff8802435ffac0] ocfs2_refcount_cow at ffffffffc11e54b1 [ocfs2]
22 [ffff8802435ffb80] ocfs2_file_write_iter at ffffffffc11bf8f4 [ocfs2]
23 [ffff8802435ffcd0] lo_rw_aio at ffffffff814a1b5d
24 [ffff8802435ffd80] loop_queue_work at ffffffff814a2802
25 [ffff8802435ffe60] kthread_worker_fn at ffffffff810a80d2
26 [ffff8802435ffec0] kthread at ffffffff810a7afb
27 [ffff8802435fff50] ret_from_fork at ffffffff816f7da1

When ocfs2_test_bg_bit_allocatable() called bh2jh(bg_bh), the
bg_bh->b_private NULL as jbd2_journal_put_journal_head() raced and
released the jounal head from the buffer head.  Needed to take bit lock
for the bit 'BH_JournalHead' to fix this race.

Link: https://lkml.kernel.org/r/1634820718-6043-1-git-send-email-gautham.ananthakrishna@oracle.com
Signed-off-by: Gautham Ananthakrishna <gautham.ananthakrishna@oracle.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: <rajesh.sivaramasubramaniom@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/suballoc.c |   22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

--- a/fs/ocfs2/suballoc.c~ocfs2-race-between-searching-chunks-and-release-journal_head-from-buffer_head
+++ a/fs/ocfs2/suballoc.c
@@ -1251,7 +1251,7 @@ static int ocfs2_test_bg_bit_allocatable
 {
 	struct ocfs2_group_desc *bg = (struct ocfs2_group_desc *) bg_bh->b_data;
 	struct journal_head *jh;
-	int ret;
+	int ret = 1;
 
 	if (ocfs2_test_bit(nr, (unsigned long *)bg->bg_bitmap))
 		return 0;
@@ -1259,14 +1259,18 @@ static int ocfs2_test_bg_bit_allocatable
 	if (!buffer_jbd(bg_bh))
 		return 1;
 
-	jh = bh2jh(bg_bh);
-	spin_lock(&jh->b_state_lock);
-	bg = (struct ocfs2_group_desc *) jh->b_committed_data;
-	if (bg)
-		ret = !ocfs2_test_bit(nr, (unsigned long *)bg->bg_bitmap);
-	else
-		ret = 1;
-	spin_unlock(&jh->b_state_lock);
+	jbd_lock_bh_journal_head(bg_bh);
+	if (buffer_jbd(bg_bh)) {
+		jh = bh2jh(bg_bh);
+		spin_lock(&jh->b_state_lock);
+		bg = (struct ocfs2_group_desc *) jh->b_committed_data;
+		if (bg)
+			ret = !ocfs2_test_bit(nr, (unsigned long *)bg->bg_bitmap);
+		else
+			ret = 1;
+		spin_unlock(&jh->b_state_lock);
+	}
+	jbd_unlock_bh_journal_head(bg_bh);
 
 	return ret;
 }
_
