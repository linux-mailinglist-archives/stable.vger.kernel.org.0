Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44630CD5A6
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 19:38:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730561AbfJFRiQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:38:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:37430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730575AbfJFRiP (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:38:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 594452080F;
        Sun,  6 Oct 2019 17:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570383494;
        bh=GDnE7TWM084jLv/9o7QScr1HLC3+SE6bcqhm2DZWlOs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QOm4AQpcLxcHBOuAGVk6/JbHi8OikgCsYvdBpmy6KoYQFvIPfupObU1NmXk1Idy2+
         G5u/mfO00buZg1QZCvxfsGAUXCF4cL9kNwL00bBEbhFfchAFC1k2DUwLJzRqaXWRVI
         aPWVu0fAT8Jr/n8E7AXI4A7J6j/izqKHPsAIhFJ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Changwei Ge <gechangwei@live.cn>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        Mark Fasheh <mark@fasheh.com>,
        Joel Becker <jlbec@evilplan.org>,
        Junxiao Bi <junxiao.bi@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 123/137] ocfs2: wait for recovering done after direct unlock request
Date:   Sun,  6 Oct 2019 19:21:47 +0200
Message-Id: <20191006171219.541645995@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171209.403038733@linuxfoundation.org>
References: <20191006171209.403038733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Changwei Ge <gechangwei@live.cn>

[ Upstream commit 0a3775e4f883912944481cf2ef36eb6383a9cc74 ]

There is a scenario causing ocfs2 umount hang when multiple hosts are
rebooting at the same time.

NODE1                           NODE2               NODE3
send unlock requset to NODE2
                                dies
                                                    become recovery master
                                                    recover NODE2
find NODE2 dead
mark resource RECOVERING
directly remove lock from grant list
calculate usage but RECOVERING marked
**miss the window of purging
clear RECOVERING

To reproduce this issue, crash a host and then umount ocfs2
from another node.

To solve this, just let unlock progress wait for recovery done.

Link: http://lkml.kernel.org/r/1550124866-20367-1-git-send-email-gechangwei@live.cn
Signed-off-by: Changwei Ge <gechangwei@live.cn>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/dlm/dlmunlock.c | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmunlock.c b/fs/ocfs2/dlm/dlmunlock.c
index e78657742bd89..3883633e82eb9 100644
--- a/fs/ocfs2/dlm/dlmunlock.c
+++ b/fs/ocfs2/dlm/dlmunlock.c
@@ -90,7 +90,8 @@ static enum dlm_status dlmunlock_common(struct dlm_ctxt *dlm,
 	enum dlm_status status;
 	int actions = 0;
 	int in_use;
-        u8 owner;
+	u8 owner;
+	int recovery_wait = 0;
 
 	mlog(0, "master_node = %d, valblk = %d\n", master_node,
 	     flags & LKM_VALBLK);
@@ -193,9 +194,12 @@ static enum dlm_status dlmunlock_common(struct dlm_ctxt *dlm,
 		}
 		if (flags & LKM_CANCEL)
 			lock->cancel_pending = 0;
-		else
-			lock->unlock_pending = 0;
-
+		else {
+			if (!lock->unlock_pending)
+				recovery_wait = 1;
+			else
+				lock->unlock_pending = 0;
+		}
 	}
 
 	/* get an extra ref on lock.  if we are just switching
@@ -229,6 +233,17 @@ leave:
 	spin_unlock(&res->spinlock);
 	wake_up(&res->wq);
 
+	if (recovery_wait) {
+		spin_lock(&res->spinlock);
+		/* Unlock request will directly succeed after owner dies,
+		 * and the lock is already removed from grant list. We have to
+		 * wait for RECOVERING done or we miss the chance to purge it
+		 * since the removement is much faster than RECOVERING proc.
+		 */
+		__dlm_wait_on_lockres_flags(res, DLM_LOCK_RES_RECOVERING);
+		spin_unlock(&res->spinlock);
+	}
+
 	/* let the caller's final dlm_lock_put handle the actual kfree */
 	if (actions & DLM_UNLOCK_FREE_LOCK) {
 		/* this should always be coupled with list removal */
-- 
2.20.1



