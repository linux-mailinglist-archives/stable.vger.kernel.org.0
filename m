Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B0C649AA07
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:31:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1323979AbiAYDaF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:30:05 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58486 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S3415675AbiAYBvC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 20:51:02 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BCB19B81620;
        Tue, 25 Jan 2022 01:51:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18A9AC340E5;
        Tue, 25 Jan 2022 01:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643075459;
        bh=2LoAhyTMCBfipDDQQxKRvq0ZjwMsW4r6jCIjKtYduL0=;
        h=Date:From:To:Subject:From;
        b=LGildrqD8lUENW013MNPDfuumhhQkUA2Sc9DN9pRWYPz06U/LqZ5KJJZA3gbfeCj5
         /Q5wY30HcqIQZnQHUtXpnyqZGekb24PkVdnHXYnwncn6V4iNvzcG2QJg+Kk8bK2RE1
         fwwSBjW39Vo57dfzHzrYNxOPNrLBak6PmBEoMAzA=
Date:   Mon, 24 Jan 2022 17:50:58 -0800
From:   akpm@linux-foundation.org
To:     adilger.kernel@dilger.ca, gautham.ananthakrishna@oracle.com,
        gechangwei@live.cn, ghe@suse.com, jlbec@evilplan.org,
        joseph.qi@linux.alibaba.com, junxiao.bi@oracle.com,
        mark@fasheh.com, mm-commits@vger.kernel.org, piaojun@huawei.com,
        saeed.mirzamohammadi@oracle.com, stable@vger.kernel.org,
        tytso@mit.edu
Subject:  + ocfs2-fix-a-deadlock-when-commit-trans.patch added to
 -mm tree
Message-ID: <20220125015058.l3F3fvaVQ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: ocfs2: fix a deadlock when commit trans
has been added to the -mm tree.  Its filename is
     ocfs2-fix-a-deadlock-when-commit-trans.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ocfs2-fix-a-deadlock-when-commit-trans.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-fix-a-deadlock-when-commit-trans.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: ocfs2: fix a deadlock when commit trans

commit 6f1b228529ae introduces a regression which can deadlock as follows:

Task1:                              Task2:
jbd2_journal_commit_transaction     ocfs2_test_bg_bit_allocatable
spin_lock(&jh->b_state_lock)        jbd_lock_bh_journal_head
__jbd2_journal_remove_checkpoint    spin_lock(&jh->b_state_lock)
jbd2_journal_put_journal_head
jbd_lock_bh_journal_head

Task1 and Task2 lock bh->b_state and jh->b_state_lock in different
order, which finally result in a deadlock.

So use jbd2_journal_[grab|put]_journal_head instead in
ocfs2_test_bg_bit_allocatable() to fix it.

Link: https://lkml.kernel.org/r/20220121071205.100648-3-joseph.qi@linux.alibaba.com
Fixes: 6f1b228529ae ("ocfs2: fix race between searching chunks and release journal_head from buffer_head")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reported-by: Gautham Ananthakrishna <gautham.ananthakrishna@oracle.com>
Reported-by: Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: <stable@vger.kernel.org>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/suballoc.c |   25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

--- a/fs/ocfs2/suballoc.c~ocfs2-fix-a-deadlock-when-commit-trans
+++ a/fs/ocfs2/suballoc.c
@@ -1251,26 +1251,23 @@ static int ocfs2_test_bg_bit_allocatable
 {
 	struct ocfs2_group_desc *bg = (struct ocfs2_group_desc *) bg_bh->b_data;
 	struct journal_head *jh;
-	int ret = 1;
+	int ret;
 
 	if (ocfs2_test_bit(nr, (unsigned long *)bg->bg_bitmap))
 		return 0;
 
-	if (!buffer_jbd(bg_bh))
+	jh = jbd2_journal_grab_journal_head(bg_bh);
+	if (!jh)
 		return 1;
 
-	jbd_lock_bh_journal_head(bg_bh);
-	if (buffer_jbd(bg_bh)) {
-		jh = bh2jh(bg_bh);
-		spin_lock(&jh->b_state_lock);
-		bg = (struct ocfs2_group_desc *) jh->b_committed_data;
-		if (bg)
-			ret = !ocfs2_test_bit(nr, (unsigned long *)bg->bg_bitmap);
-		else
-			ret = 1;
-		spin_unlock(&jh->b_state_lock);
-	}
-	jbd_unlock_bh_journal_head(bg_bh);
+	spin_lock(&jh->b_state_lock);
+	bg = (struct ocfs2_group_desc *) jh->b_committed_data;
+	if (bg)
+		ret = !ocfs2_test_bit(nr, (unsigned long *)bg->bg_bitmap);
+	else
+		ret = 1;
+	spin_unlock(&jh->b_state_lock);
+	jbd2_journal_put_journal_head(jh);
 
 	return ret;
 }
_

Patches currently in -mm which might be from joseph.qi@linux.alibaba.com are

jbd2-export-jbd2_journal__journal_head.patch
ocfs2-fix-a-deadlock-when-commit-trans.patch

