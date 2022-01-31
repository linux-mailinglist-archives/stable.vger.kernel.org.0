Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A5324A44B8
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:33:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350683AbiAaLcO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:32:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379129AbiAaL3u (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:29:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82C93C0617A8;
        Mon, 31 Jan 2022 03:19:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2271261207;
        Mon, 31 Jan 2022 11:19:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA7AAC340E8;
        Mon, 31 Jan 2022 11:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627989;
        bh=X0VcEdGakIz6rEue8sRTEPf3AQkU+2J1McCJq0WJgpk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xjv4vIrzCU0ZX8wstx9FltdSXovwz0bPI+M5GBaE/pZ2aR53QAXUSScs0zwWvRPjc
         2ScmFMpN495KNU+hxk2/kuHGs4GKh6QYyZpfmPpVnsP0AOEq1Pq/7NCqEaje4L3cnj
         CSQc0okCDL4Pvl9qvRPsReg5IkQlPUR1iXjBmVis=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>,
        Gautham Ananthakrishna <gautham.ananthakrishna@oracle.com>,
        Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>,
        "Theodore Tso" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Changwei Ge <gechangwei@live.cn>, Gang He <ghe@suse.com>,
        Joel Becker <jlbec@evilplan.org>,
        Jun Piao <piaojun@huawei.com>,
        Junxiao Bi <junxiao.bi@oracle.com>,
        Mark Fasheh <mark@fasheh.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.16 088/200] ocfs2: fix a deadlock when commit trans
Date:   Mon, 31 Jan 2022 11:55:51 +0100
Message-Id: <20220131105236.572204917@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
References: <20220131105233.561926043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joseph Qi <joseph.qi@linux.alibaba.com>

commit ddf4b773aa40790dfa936bd845c18e735a49c61c upstream.

commit 6f1b228529ae introduces a regression which can deadlock as
follows:

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
Tested-by: Gautham Ananthakrishna <gautham.ananthakrishna@oracle.com>
Reported-by: Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ocfs2/suballoc.c |   25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
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


