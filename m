Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DB0820DB52
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:15:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387505AbgF2UFi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 16:05:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:40568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732975AbgF2Ta2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:30:28 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B4AC7252A6;
        Mon, 29 Jun 2020 15:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593445015;
        bh=ynMIqF5vEp8/euxzrnMtKLqP5VfXQbGHU3Ru9xX2DgA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bhHH2C43Uvl3w7eWFwTy8/XxRjrATuMKwJjPW2TOpgwigLARcefZNwfc1UJWx4qA3
         2XVAZLJ/xjeD1XCHOUJiENcqwt/W/f/RsmyY8kq5KXb8BSsqprizSGQ6PV4Z3DAjCW
         IO5+CKNVdvIqsVRAD5wAaegO47mxJt7OhlxgCIqw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Junxiao Bi <junxiao.bi@oracle.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        Changwei Ge <gechangwei@live.cn>, Gang He <ghe@suse.com>,
        Joel Becker <jlbec@evilplan.org>,
        Jun Piao <piaojun@huawei.com>, Mark Fasheh <mark@fasheh.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.19 114/131] ocfs2: avoid inode removal while nfsd is accessing it
Date:   Mon, 29 Jun 2020 11:34:45 -0400
Message-Id: <20200629153502.2494656-115-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629153502.2494656-1-sashal@kernel.org>
References: <20200629153502.2494656-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.131-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.131-rc1
X-KernelTest-Deadline: 2020-07-01T15:34+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Junxiao Bi <junxiao.bi@oracle.com>

commit 4cd9973f9ff69e37dd0ba2bd6e6423f8179c329a upstream.

Patch series "ocfs2: fix nfsd over ocfs2 issues", v2.

This is a series of patches to fix issues on nfsd over ocfs2.  patch 1
is to avoid inode removed while nfsd access it patch 2 & 3 is to fix a
panic issue.

This patch (of 4):

When nfsd is getting file dentry using handle or parent dentry of some
dentry, one cluster lock is used to avoid inode removed from other node,
but it still could be removed from local node, so use a rw lock to avoid
this.

Link: http://lkml.kernel.org/r/20200616183829.87211-1-junxiao.bi@oracle.com
Link: http://lkml.kernel.org/r/20200616183829.87211-2-junxiao.bi@oracle.com
Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ocfs2/dlmglue.c | 17 ++++++++++++++++-
 fs/ocfs2/ocfs2.h   |  1 +
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 178cb9e6772ac..c141b06811a6c 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -682,6 +682,12 @@ static void ocfs2_nfs_sync_lock_res_init(struct ocfs2_lock_res *res,
 				   &ocfs2_nfs_sync_lops, osb);
 }
 
+static void ocfs2_nfs_sync_lock_init(struct ocfs2_super *osb)
+{
+	ocfs2_nfs_sync_lock_res_init(&osb->osb_nfs_sync_lockres, osb);
+	init_rwsem(&osb->nfs_sync_rwlock);
+}
+
 void ocfs2_trim_fs_lock_res_init(struct ocfs2_super *osb)
 {
 	struct ocfs2_lock_res *lockres = &osb->osb_trim_fs_lockres;
@@ -2851,6 +2857,11 @@ int ocfs2_nfs_sync_lock(struct ocfs2_super *osb, int ex)
 	if (ocfs2_is_hard_readonly(osb))
 		return -EROFS;
 
+	if (ex)
+		down_write(&osb->nfs_sync_rwlock);
+	else
+		down_read(&osb->nfs_sync_rwlock);
+
 	if (ocfs2_mount_local(osb))
 		return 0;
 
@@ -2869,6 +2880,10 @@ void ocfs2_nfs_sync_unlock(struct ocfs2_super *osb, int ex)
 	if (!ocfs2_mount_local(osb))
 		ocfs2_cluster_unlock(osb, lockres,
 				     ex ? LKM_EXMODE : LKM_PRMODE);
+	if (ex)
+		up_write(&osb->nfs_sync_rwlock);
+	else
+		up_read(&osb->nfs_sync_rwlock);
 }
 
 int ocfs2_trim_fs_lock(struct ocfs2_super *osb,
@@ -3314,7 +3329,7 @@ int ocfs2_dlm_init(struct ocfs2_super *osb)
 local:
 	ocfs2_super_lock_res_init(&osb->osb_super_lockres, osb);
 	ocfs2_rename_lock_res_init(&osb->osb_rename_lockres, osb);
-	ocfs2_nfs_sync_lock_res_init(&osb->osb_nfs_sync_lockres, osb);
+	ocfs2_nfs_sync_lock_init(osb);
 	ocfs2_orphan_scan_lock_res_init(&osb->osb_orphan_scan.os_lockres, osb);
 
 	osb->cconn = conn;
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 4f86ac0027b5b..2319336183005 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -406,6 +406,7 @@ struct ocfs2_super
 	struct ocfs2_lock_res osb_super_lockres;
 	struct ocfs2_lock_res osb_rename_lockres;
 	struct ocfs2_lock_res osb_nfs_sync_lockres;
+	struct rw_semaphore nfs_sync_rwlock;
 	struct ocfs2_lock_res osb_trim_fs_lockres;
 	struct ocfs2_dlm_debug *osb_dlm_debug;
 
-- 
2.25.1

