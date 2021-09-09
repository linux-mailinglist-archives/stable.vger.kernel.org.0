Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40A27405060
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:40:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350167AbhIIM1b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:27:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:57708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350422AbhIIMWN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:22:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4556A61ADF;
        Thu,  9 Sep 2021 11:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188252;
        bh=9OYq0SczP0njcv51S+c+cNC6JLDBw4a0XCds4ybT87w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LJ9Tx2EjRWOVcS2+2lWk5n5uJ9PLhWpoftmbd9T7GtE38w2Cnbgn6WbFC+mDhUFKV
         ZFj8A/s9T3cuyn9X/b9EQXWHGE5xDXR+gkOdXqlzxAOldOaKLDyHryPUFFS//kBc4P
         Zbv0zkphNIR5hTzQ+EBOYcX2jB3N+aksKhxar/Oh2pDAZxf/ngVUF239uWhLgf6lAg
         Kwbn8mef5/eUkK3jM32MxjqyJmpzwJ9SReuSEu6h0TumJw0I/9RivnMTKGLGBhAZ4p
         XFIJ6MX7IwKm9kX0vHtnsvMXy0J6kU4Ht0TrQCtfyiaXYhsiYwtjGMOJ1RNtYiqeQn
         bRUQfwMgfoUow==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "J. Bruce Fields" <bfields@redhat.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 199/219] nfs: don't atempt blocking locks on nfs reexports
Date:   Thu,  9 Sep 2021 07:46:15 -0400
Message-Id: <20210909114635.143983-199-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114635.143983-1-sashal@kernel.org>
References: <20210909114635.143983-1-sashal@kernel.org>
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
index 90e81f6491ff..323d57e72d25 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -6727,6 +6727,7 @@ nfsd4_lock(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	struct nfsd4_blocked_lock *nbl = NULL;
 	struct file_lock *file_lock = NULL;
 	struct file_lock *conflock = NULL;
+	struct super_block *sb;
 	__be32 status = 0;
 	int lkflg;
 	int err;
@@ -6748,6 +6749,7 @@ nfsd4_lock(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 		dprintk("NFSD: nfsd4_lock: permission denied!\n");
 		return status;
 	}
+	sb = cstate->current_fh.fh_dentry->d_sb;
 
 	if (lock->lk_is_new) {
 		if (nfsd4_has_session(cstate))
@@ -6796,7 +6798,8 @@ nfsd4_lock(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	fp = lock_stp->st_stid.sc_file;
 	switch (lock->lk_type) {
 		case NFS4_READW_LT:
-			if (nfsd4_has_session(cstate))
+			if (nfsd4_has_session(cstate) &&
+			    !(sb->s_export_op->flags & EXPORT_OP_SYNC_LOCKS))
 				fl_flags |= FL_SLEEP;
 			fallthrough;
 		case NFS4_READ_LT:
@@ -6808,7 +6811,8 @@ nfsd4_lock(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
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

