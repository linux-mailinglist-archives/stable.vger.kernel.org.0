Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE229404D4C
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:02:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245627AbhIIMBd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:01:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:41392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345014AbhIIL7c (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 07:59:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 490C661425;
        Thu,  9 Sep 2021 11:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631187961;
        bh=O4QDUrrhok5Yx1hnbaku5IUMizrFXg2FjhyeUpa7OvE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J+moTNGtF37LH0dSo3DOCwTMc6Br5Vsx51QFb62zc1h7igoxJ1CM4s1CpCi0LNHyB
         hNODAOlkiXXDrO7yiNTt4X3MtRNj5DGxzxp9bel7aZOfwPOEIBRER4Mi2EdZZCLHlY
         2onDpR3L3XqHmz7BXLdsG1DNVu+clPmiPZFgLzdrCWaHOIfPYSTJyRjh6KA2oB2F68
         5KKSqSStzH3AWiFgvnBH7huJ2grrlXc2Nk+LhspiwX0Fku5Ah5emvtiYE5MMMe+F6l
         9vNAdHF+9qrhD5MU4YVmu5G+KzHZ7j7MlJ8EuHeRAA0Eu72jOGQNrz3/FWwF3zbrzo
         Dg2e5EVTG/AOQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "J. Bruce Fields" <bfields@redhat.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 226/252] nfs: don't atempt blocking locks on nfs reexports
Date:   Thu,  9 Sep 2021 07:40:40 -0400
Message-Id: <20210909114106.141462-226-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114106.141462-1-sashal@kernel.org>
References: <20210909114106.141462-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "J. Bruce Fields" <bfields@redhat.com>

[ Upstream commit f657f8eef3ff870552c9fd2839e0061046f44618 ]

NFS implements blocking locks by blocking inside its lock method.  In
the reexport case, this blocks the nfs server thread, which could lead
to deadlocks since an nfs server thread might be required to unlock the
conflicting lock.  It also causes a crash, since the nfs server thread
assumes it can free the lock when its lm_notify lock callback is called.

Ideal would be to make the nfs lock method return without blocking in
this case, but for now it works just not to attempt blocking locks.  The
difference is just that the original client will have to poll (as it
does in the v4.0 case) instead of getting a callback when the lock's
available.

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Acked-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/export.c          | 2 +-
 fs/nfsd/nfs4state.c      | 8 ++++++--
 include/linux/exportfs.h | 2 ++
 3 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/nfs/export.c b/fs/nfs/export.c
index 37a1a88df771..d772c20bbfd1 100644
--- a/fs/nfs/export.c
+++ b/fs/nfs/export.c
@@ -180,5 +180,5 @@ const struct export_operations nfs_export_ops = {
 	.fetch_iversion = nfs_fetch_iversion,
 	.flags = EXPORT_OP_NOWCC|EXPORT_OP_NOSUBTREECHK|
 		EXPORT_OP_CLOSE_BEFORE_UNLINK|EXPORT_OP_REMOTE_FS|
-		EXPORT_OP_NOATOMIC_ATTR,
+		EXPORT_OP_NOATOMIC_ATTR|EXPORT_OP_SYNC_LOCKS,
 };
diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index fa67ecd5fe63..bebe86cce7c7 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -6835,6 +6835,7 @@ nfsd4_lock(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	struct nfsd4_blocked_lock *nbl = NULL;
 	struct file_lock *file_lock = NULL;
 	struct file_lock *conflock = NULL;
+	struct super_block *sb;
 	__be32 status = 0;
 	int lkflg;
 	int err;
@@ -6856,6 +6857,7 @@ nfsd4_lock(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 		dprintk("NFSD: nfsd4_lock: permission denied!\n");
 		return status;
 	}
+	sb = cstate->current_fh.fh_dentry->d_sb;
 
 	if (lock->lk_is_new) {
 		if (nfsd4_has_session(cstate))
@@ -6904,7 +6906,8 @@ nfsd4_lock(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	fp = lock_stp->st_stid.sc_file;
 	switch (lock->lk_type) {
 		case NFS4_READW_LT:
-			if (nfsd4_has_session(cstate))
+			if (nfsd4_has_session(cstate) &&
+			    !(sb->s_export_op->flags & EXPORT_OP_SYNC_LOCKS))
 				fl_flags |= FL_SLEEP;
 			fallthrough;
 		case NFS4_READ_LT:
@@ -6916,7 +6919,8 @@ nfsd4_lock(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 			fl_type = F_RDLCK;
 			break;
 		case NFS4_WRITEW_LT:
-			if (nfsd4_has_session(cstate))
+			if (nfsd4_has_session(cstate) &&
+			    !(sb->s_export_op->flags & EXPORT_OP_SYNC_LOCKS))
 				fl_flags |= FL_SLEEP;
 			fallthrough;
 		case NFS4_WRITE_LT:
diff --git a/include/linux/exportfs.h b/include/linux/exportfs.h
index fe848901fcc3..3260fe714846 100644
--- a/include/linux/exportfs.h
+++ b/include/linux/exportfs.h
@@ -221,6 +221,8 @@ struct export_operations {
 #define EXPORT_OP_NOATOMIC_ATTR		(0x10) /* Filesystem cannot supply
 						  atomic attribute updates
 						*/
+#define EXPORT_OP_SYNC_LOCKS		(0x20) /* Filesystem can't do
+						  asychronous blocking locks */
 	unsigned long	flags;
 };
 
-- 
2.30.2

