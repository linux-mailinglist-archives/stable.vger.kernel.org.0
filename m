Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A704C172E
	for <lists+stable@lfdr.de>; Sun, 29 Sep 2019 19:36:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730808AbfI2RgV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 13:36:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:48818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730790AbfI2RgU (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Sep 2019 13:36:20 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 95A9D21A4A;
        Sun, 29 Sep 2019 17:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569778579;
        bh=63/jWXKufjyiFg2ahV8Id1e3jfvZ9rfSOZpiyU+pRdk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N9s1Rd5b48/ocwftnZACHPCqCpN7yv2c0n2mywQE5MQyulwv1EDmsZcQZ44NM9RVv
         dvtCE39ckuxTQvxPBpYi6Fg3bKIyPEWXUpaspRGHoheOryAUkWJNVNh9CD/IbimHdu
         kMk6YjzFpcdCnzqhLFscmUO4KJgV0Dzg8zMshZvk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Changwei Ge <gechangwei@live.cn>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        Mark Fasheh <mark@fasheh.com>,
        Joel Becker <jlbec@evilplan.org>,
        Junxiao Bi <junxiao.bi@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 22/23] ocfs2: wait for recovering done after direct unlock request
Date:   Sun, 29 Sep 2019 13:35:32 -0400
Message-Id: <20190929173535.9744-22-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190929173535.9744-1-sashal@kernel.org>
References: <20190929173535.9744-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 63d701cd1e2e7..c8e9b7031d9ad 100644
--- a/fs/ocfs2/dlm/dlmunlock.c
+++ b/fs/ocfs2/dlm/dlmunlock.c
@@ -105,7 +105,8 @@ static enum dlm_status dlmunlock_common(struct dlm_ctxt *dlm,
 	enum dlm_status status;
 	int actions = 0;
 	int in_use;
-        u8 owner;
+	u8 owner;
+	int recovery_wait = 0;
 
 	mlog(0, "master_node = %d, valblk = %d\n", master_node,
 	     flags & LKM_VALBLK);
@@ -208,9 +209,12 @@ static enum dlm_status dlmunlock_common(struct dlm_ctxt *dlm,
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
@@ -244,6 +248,17 @@ static enum dlm_status dlmunlock_common(struct dlm_ctxt *dlm,
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

