Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97FBF20BDED
	for <lists+stable@lfdr.de>; Sat, 27 Jun 2020 05:33:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725904AbgF0DdK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jun 2020 23:33:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:44828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725828AbgF0DdK (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jun 2020 23:33:10 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 617312080C;
        Sat, 27 Jun 2020 03:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593228789;
        bh=ZJVvWU1usunFGonTSWVSmc8G/T60rnT3jp6pMw1tUJI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=TMB8Z2CBq31/9+NIbrL98Z/quaoAD9FqhUUTjj8mFQUOyQV96eCWXUS/8zFVkU6o2
         I9QdsQUC2RrB1rWCKv5iOCXsWJ17BZFqTTlEdfnTKTyCYpGfnMaqYCz8EL2S9rfpFs
         cK0V3WGn5jvQ4xCdiRl4x68Y6G2dEKDZeNRNsj1I=
Date:   Fri, 26 Jun 2020 20:33:09 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     gechangwei@live.cn, ghe@suse.com, jlbec@evilplan.org,
        joseph.qi@linux.alibaba.com, junxiao.bi@oracle.com,
        mark@fasheh.com, mm-commits@vger.kernel.org, piaojun@huawei.com,
        stable@vger.kernel.org
Subject:  [merged]
 ocfs2-avoid-inode-removed-while-nfsd-access-it.patch removed from -mm tree
Message-ID: <20200627033309.T7sJLexSY%akpm@linux-foundation.org>
In-Reply-To: <20200625202807.b630829d6fa55388148bee7d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: ocfs2: avoid inode removal while nfsd is accessing it
has been removed from the -mm tree.  Its filename was
     ocfs2-avoid-inode-removed-while-nfsd-access-it.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Junxiao Bi <junxiao.bi@oracle.com>
Subject: ocfs2: avoid inode removal while nfsd is accessing it

Patch series "ocfs2: fix nfsd over ocfs2 issues", v2.

This is a series of patches to fix issues on nfsd over ocfs2.  patch 1 is
to avoid inode removed while nfsd access it patch 2 & 3 is to fix a panic
issue.


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
---

 fs/ocfs2/dlmglue.c |   17 ++++++++++++++++-
 fs/ocfs2/ocfs2.h   |    1 +
 2 files changed, 17 insertions(+), 1 deletion(-)

--- a/fs/ocfs2/dlmglue.c~ocfs2-avoid-inode-removed-while-nfsd-access-it
+++ a/fs/ocfs2/dlmglue.c
@@ -689,6 +689,12 @@ static void ocfs2_nfs_sync_lock_res_init
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
@@ -2855,6 +2861,11 @@ int ocfs2_nfs_sync_lock(struct ocfs2_sup
 	if (ocfs2_is_hard_readonly(osb))
 		return -EROFS;
 
+	if (ex)
+		down_write(&osb->nfs_sync_rwlock);
+	else
+		down_read(&osb->nfs_sync_rwlock);
+
 	if (ocfs2_mount_local(osb))
 		return 0;
 
@@ -2873,6 +2884,10 @@ void ocfs2_nfs_sync_unlock(struct ocfs2_
 	if (!ocfs2_mount_local(osb))
 		ocfs2_cluster_unlock(osb, lockres,
 				     ex ? LKM_EXMODE : LKM_PRMODE);
+	if (ex)
+		up_write(&osb->nfs_sync_rwlock);
+	else
+		up_read(&osb->nfs_sync_rwlock);
 }
 
 int ocfs2_trim_fs_lock(struct ocfs2_super *osb,
@@ -3340,7 +3355,7 @@ int ocfs2_dlm_init(struct ocfs2_super *o
 local:
 	ocfs2_super_lock_res_init(&osb->osb_super_lockres, osb);
 	ocfs2_rename_lock_res_init(&osb->osb_rename_lockres, osb);
-	ocfs2_nfs_sync_lock_res_init(&osb->osb_nfs_sync_lockres, osb);
+	ocfs2_nfs_sync_lock_init(osb);
 	ocfs2_orphan_scan_lock_res_init(&osb->osb_orphan_scan.os_lockres, osb);
 
 	osb->cconn = conn;
--- a/fs/ocfs2/ocfs2.h~ocfs2-avoid-inode-removed-while-nfsd-access-it
+++ a/fs/ocfs2/ocfs2.h
@@ -395,6 +395,7 @@ struct ocfs2_super
 	struct ocfs2_lock_res osb_super_lockres;
 	struct ocfs2_lock_res osb_rename_lockres;
 	struct ocfs2_lock_res osb_nfs_sync_lockres;
+	struct rw_semaphore nfs_sync_rwlock;
 	struct ocfs2_lock_res osb_trim_fs_lockres;
 	struct mutex obs_trim_fs_mutex;
 	struct ocfs2_dlm_debug *osb_dlm_debug;
_

Patches currently in -mm which might be from junxiao.bi@oracle.com are


