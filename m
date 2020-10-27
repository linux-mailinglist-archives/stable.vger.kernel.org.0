Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 232EE29BD71
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:49:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1810978AbgJ0Qgf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 12:36:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:40472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1801839AbgJ0Pob (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:44:31 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2ED312245D;
        Tue, 27 Oct 2020 15:43:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813434;
        bh=vzAInNGIvcVAoYf6SO9RuuGhQ0XIGZPey4gJ2+u3GV8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UmgXhGyRJJKv034CUl40NGgGmQCHAhTceoaMQGZ1ymzIUiAcdPHy8yMDm0leKques
         lbndPqzzKYpW2UBuFy5+KbHeObcUcoTtgzkj13FAXYk3ysHX4lHFFqk5Om9/5ygjYy
         EunmGv8FYSHR/AmYC8m/jLH3PSSjoUlP3onkEOZE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Theodore Tso <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 551/757] ext4: discard preallocations before releasing group lock
Date:   Tue, 27 Oct 2020 14:53:21 +0100
Message-Id: <20201027135516.336527751@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

[ Upstream commit 5b3dc19dda6691e8ab574e8eede1aef6f02a4f1c ]

ext4_mb_discard_group_preallocations() can be releasing group lock with
preallocations accumulated on its local list. Thus although
discard_pa_seq was incremented and concurrent allocating processes will
be retrying allocations, it can happen that premature ENOSPC error is
returned because blocks used for preallocations are not available for
reuse yet. Make sure we always free locally accumulated preallocations
before releasing group lock.

Fixes: 07b5b8e1ac40 ("ext4: mballoc: introduce pcpu seqcnt for freeing PA to improve ENOSPC handling")
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20200924150959.4335-1-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/mballoc.c | 33 +++++++++++++--------------------
 1 file changed, 13 insertions(+), 20 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index ff47347012f4b..a8d99f676fb1f 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4160,7 +4160,7 @@ ext4_mb_discard_group_preallocations(struct super_block *sb,
 	struct ext4_buddy e4b;
 	int err;
 	int busy = 0;
-	int free = 0;
+	int free, free_total = 0;
 
 	mb_debug(sb, "discard preallocation for group %u\n", group);
 	if (list_empty(&grp->bb_prealloc_list))
@@ -4188,6 +4188,7 @@ ext4_mb_discard_group_preallocations(struct super_block *sb,
 
 	INIT_LIST_HEAD(&list);
 repeat:
+	free = 0;
 	ext4_lock_group(sb, group);
 	list_for_each_entry_safe(pa, tmp,
 				&grp->bb_prealloc_list, pa_group_list) {
@@ -4217,22 +4218,6 @@ ext4_mb_discard_group_preallocations(struct super_block *sb,
 		list_add(&pa->u.pa_tmp_list, &list);
 	}
 
-	/* if we still need more blocks and some PAs were used, try again */
-	if (free < needed && busy) {
-		busy = 0;
-		ext4_unlock_group(sb, group);
-		cond_resched();
-		goto repeat;
-	}
-
-	/* found anything to free? */
-	if (list_empty(&list)) {
-		BUG_ON(free != 0);
-		mb_debug(sb, "Someone else may have freed PA for this group %u\n",
-			 group);
-		goto out;
-	}
-
 	/* now free all selected PAs */
 	list_for_each_entry_safe(pa, tmp, &list, u.pa_tmp_list) {
 
@@ -4250,14 +4235,22 @@ ext4_mb_discard_group_preallocations(struct super_block *sb,
 		call_rcu(&(pa)->u.pa_rcu, ext4_mb_pa_callback);
 	}
 
-out:
+	free_total += free;
+
+	/* if we still need more blocks and some PAs were used, try again */
+	if (free_total < needed && busy) {
+		ext4_unlock_group(sb, group);
+		cond_resched();
+		busy = 0;
+		goto repeat;
+	}
 	ext4_unlock_group(sb, group);
 	ext4_mb_unload_buddy(&e4b);
 	put_bh(bitmap_bh);
 out_dbg:
 	mb_debug(sb, "discarded (%d) blocks preallocated for group %u bb_free (%d)\n",
-		 free, group, grp->bb_free);
-	return free;
+		 free_total, group, grp->bb_free);
+	return free_total;
 }
 
 /*
-- 
2.25.1



