Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44BE3FEDB1
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 16:46:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729312AbfKPPqL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 10:46:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:52360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728592AbfKPPqK (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:46:10 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5A4112083B;
        Sat, 16 Nov 2019 15:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919169;
        bh=9LCI/pUJ619qOl/wn7bYyo2lDa06P71DoVqYJwBe8X0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zTZr9xYNGgbNWFsO3FrBIWd8hxitd0JTSxp2ZvBhBl4EU4u7bz9mTLE1YES3Wwgqa
         xK2rnfaKsj5CrGE5R+m1ZsmS/OhYsLuCoqD12JCUOJ0r2uYGFJp8Di9huLIYe2Zjp6
         Xr+StaHp+hfS3r5P+jYOSE0EJ7vU5fsz3ixjZcA0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Guozhonghua <guozhonghua@h3c.com>, Jan Kara <jack@suse.cz>,
        Mark Fasheh <mark@fasheh.com>,
        Joel Becker <jlbec@evilplan.org>,
        Junxiao Bi <junxiao.bi@oracle.com>,
        Joseph Qi <jiangqi903@gmail.com>,
        Changwei Ge <ge.changwei@h3c.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 179/237] ocfs2: without quota support, avoid calling quota recovery
Date:   Sat, 16 Nov 2019 10:40:14 -0500
Message-Id: <20191116154113.7417-179-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guozhonghua <guozhonghua@h3c.com>

[ Upstream commit 21158ca85b73ddd0088076a5209cfd040513a8b5 ]

During one dead node's recovery by other node, quota recovery work will
be queued.  We should avoid calling quota when it is not supported, so
check the quota flags.

Link: http://lkml.kernel.org/r/71604351584F6A4EBAE558C676F37CA401071AC9FB@H3CMLB12-EX.srv.huawei-3com.com
Signed-off-by: guozhonghua <guozhonghua@h3c.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Changwei Ge <ge.changwei@h3c.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/journal.c | 51 ++++++++++++++++++++++++++++++----------------
 1 file changed, 34 insertions(+), 17 deletions(-)

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index c492cbb2410f6..babb0ec76d676 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -1379,15 +1379,23 @@ static int __ocfs2_recovery_thread(void *arg)
 	int rm_quota_used = 0, i;
 	struct ocfs2_quota_recovery *qrec;
 
+	/* Whether the quota supported. */
+	int quota_enabled = OCFS2_HAS_RO_COMPAT_FEATURE(osb->sb,
+			OCFS2_FEATURE_RO_COMPAT_USRQUOTA)
+		|| OCFS2_HAS_RO_COMPAT_FEATURE(osb->sb,
+			OCFS2_FEATURE_RO_COMPAT_GRPQUOTA);
+
 	status = ocfs2_wait_on_mount(osb);
 	if (status < 0) {
 		goto bail;
 	}
 
-	rm_quota = kcalloc(osb->max_slots, sizeof(int), GFP_NOFS);
-	if (!rm_quota) {
-		status = -ENOMEM;
-		goto bail;
+	if (quota_enabled) {
+		rm_quota = kcalloc(osb->max_slots, sizeof(int), GFP_NOFS);
+		if (!rm_quota) {
+			status = -ENOMEM;
+			goto bail;
+		}
 	}
 restart:
 	status = ocfs2_super_lock(osb, 1);
@@ -1423,9 +1431,14 @@ static int __ocfs2_recovery_thread(void *arg)
 		 * then quota usage would be out of sync until some node takes
 		 * the slot. So we remember which nodes need quota recovery
 		 * and when everything else is done, we recover quotas. */
-		for (i = 0; i < rm_quota_used && rm_quota[i] != slot_num; i++);
-		if (i == rm_quota_used)
-			rm_quota[rm_quota_used++] = slot_num;
+		if (quota_enabled) {
+			for (i = 0; i < rm_quota_used
+					&& rm_quota[i] != slot_num; i++)
+				;
+
+			if (i == rm_quota_used)
+				rm_quota[rm_quota_used++] = slot_num;
+		}
 
 		status = ocfs2_recover_node(osb, node_num, slot_num);
 skip_recovery:
@@ -1453,16 +1466,19 @@ static int __ocfs2_recovery_thread(void *arg)
 	/* Now it is right time to recover quotas... We have to do this under
 	 * superblock lock so that no one can start using the slot (and crash)
 	 * before we recover it */
-	for (i = 0; i < rm_quota_used; i++) {
-		qrec = ocfs2_begin_quota_recovery(osb, rm_quota[i]);
-		if (IS_ERR(qrec)) {
-			status = PTR_ERR(qrec);
-			mlog_errno(status);
-			continue;
+	if (quota_enabled) {
+		for (i = 0; i < rm_quota_used; i++) {
+			qrec = ocfs2_begin_quota_recovery(osb, rm_quota[i]);
+			if (IS_ERR(qrec)) {
+				status = PTR_ERR(qrec);
+				mlog_errno(status);
+				continue;
+			}
+			ocfs2_queue_recovery_completion(osb->journal,
+					rm_quota[i],
+					NULL, NULL, qrec,
+					ORPHAN_NEED_TRUNCATE);
 		}
-		ocfs2_queue_recovery_completion(osb->journal, rm_quota[i],
-						NULL, NULL, qrec,
-						ORPHAN_NEED_TRUNCATE);
 	}
 
 	ocfs2_super_unlock(osb, 1);
@@ -1484,7 +1500,8 @@ static int __ocfs2_recovery_thread(void *arg)
 
 	mutex_unlock(&osb->recovery_lock);
 
-	kfree(rm_quota);
+	if (quota_enabled)
+		kfree(rm_quota);
 
 	/* no one is callint kthread_stop() for us so the kthread() api
 	 * requires that we call do_exit().  And it isn't exported, but
-- 
2.20.1

