Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DC5340E807
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 20:00:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349935AbhIPRno (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:43:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:53752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354344AbhIPRjo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:39:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4694661555;
        Thu, 16 Sep 2021 16:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631811048;
        bh=PuNTO+x0a9Nn/8c1KsgJyL2LRCnix/RK6ANSFoz61Gg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WImTbrb9ncAJLgoHjQE2wl6LBPtIA60wGPIGa8CQdZQj5AZ4kHOLGvS7gcHtTgW6P
         s5OEtEaDiL68uT2ExYR81T7QSS7XCOM4a5xYTLIshgRxwBcZJKPda1PnByMMlZ5fdn
         iQHr1APf2CHmv3I/vi8pfnE1VE8sAvEFzY7cEYvk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "J. Bruce Fields" <bfields@redhat.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 364/432] nfs: dont atempt blocking locks on nfs reexports
Date:   Thu, 16 Sep 2021 18:01:53 +0200
Message-Id: <20210916155823.143794307@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: J. Bruce Fields <bfields@redhat.com>

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
index 2bedc7839ec5..d0b2041c4d75 100644
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



