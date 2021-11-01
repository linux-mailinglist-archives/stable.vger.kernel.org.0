Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22B9544175A
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:33:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233217AbhKAJfs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:35:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:43580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233609AbhKAJdp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:33:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F75B61261;
        Mon,  1 Nov 2021 09:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758712;
        bh=qIO+wzM2ikq4QhmwVnx2EeEFOgDRNG0y7NYoeUpHMjA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R6wbvfsX+G40rvTJEEkN9pl7X7B55QrzXPVIB5FJqmPLWUX6ZTuF8ACTel3WdACU1
         db4GFP3xmlQo9nmciJkJe4tHmu80Ij/uHs3rW31zf6hHw9mlWin1fHFMmetqrlptPq
         oVhE/KRRO25VEs3AFFwOm+GCzv8oAeNg2tpdraQE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Gautham Ananthakrishna <gautham.ananthakrishna@oracle.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        rajesh.sivaramasubramaniom@oracle.com,
        Mark Fasheh <mark@fasheh.com>,
        Joel Becker <jlbec@evilplan.org>,
        Junxiao Bi <junxiao.bi@oracle.com>,
        Changwei Ge <gechangwei@live.cn>, Gang He <ghe@suse.com>,
        Jun Piao <piaojun@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 26/77] ocfs2: fix race between searching chunks and release journal_head from buffer_head
Date:   Mon,  1 Nov 2021 10:17:14 +0100
Message-Id: <20211101082517.417685036@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082511.254155853@linuxfoundation.org>
References: <20211101082511.254155853@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gautham Ananthakrishna <gautham.ananthakrishna@oracle.com>

commit 6f1b228529ae49b0f85ab89bcdb6c365df401558 upstream.

Encountered a race between ocfs2_test_bg_bit_allocatable() and
jbd2_journal_put_journal_head() resulting in the below vmcore.

  PID: 106879  TASK: ffff880244ba9c00  CPU: 2   COMMAND: "loop3"
  Call trace:
    panic
    oops_end
    no_context
    __bad_area_nosemaphore
    bad_area_nosemaphore
    __do_page_fault
    do_page_fault
    page_fault
      [exception RIP: ocfs2_block_group_find_clear_bits+316]
    ocfs2_block_group_find_clear_bits [ocfs2]
    ocfs2_cluster_group_search [ocfs2]
    ocfs2_search_chain [ocfs2]
    ocfs2_claim_suballoc_bits [ocfs2]
    __ocfs2_claim_clusters [ocfs2]
    ocfs2_claim_clusters [ocfs2]
    ocfs2_local_alloc_slide_window [ocfs2]
    ocfs2_reserve_local_alloc_bits [ocfs2]
    ocfs2_reserve_clusters_with_limit [ocfs2]
    ocfs2_reserve_clusters [ocfs2]
    ocfs2_lock_refcount_allocators [ocfs2]
    ocfs2_make_clusters_writable [ocfs2]
    ocfs2_replace_cow [ocfs2]
    ocfs2_refcount_cow [ocfs2]
    ocfs2_file_write_iter [ocfs2]
    lo_rw_aio
    loop_queue_work
    kthread_worker_fn
    kthread
    ret_from_fork

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ocfs2/suballoc.c |   22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -1253,7 +1253,7 @@ static int ocfs2_test_bg_bit_allocatable
 {
 	struct ocfs2_group_desc *bg = (struct ocfs2_group_desc *) bg_bh->b_data;
 	struct journal_head *jh;
-	int ret;
+	int ret = 1;
 
 	if (ocfs2_test_bit(nr, (unsigned long *)bg->bg_bitmap))
 		return 0;
@@ -1261,14 +1261,18 @@ static int ocfs2_test_bg_bit_allocatable
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


