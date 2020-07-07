Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54589217262
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:44:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728110AbgGGPc1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:32:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:34536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728575AbgGGPWI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:22:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A16BA20663;
        Tue,  7 Jul 2020 15:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594135327;
        bh=SlcQ3CLVq0OHfMVLc4x9rNOY2A1HJDTfvari2YNnBvw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cyKIJ82pA2pHdXwLkI0fA8hmRd/Kba9CZMMcc5LZxipBow2Ubt4pVMH8qHZtLZ64S
         rPTdTtsNnV91Z3rhev0w6DYwSuDUnwf5feY8tmgvyN54rw80SZMRKBfOuCfnxBuGHR
         Dzu/QDdvaDwr6+r/I7RS7aIeOQKsk4B4FesXp4C0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "J. Bruce Fields" <bfields@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 35/65] nfsd: clients dont need to break their own delegations
Date:   Tue,  7 Jul 2020 17:17:14 +0200
Message-Id: <20200707145754.171869800@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707145752.417212219@linuxfoundation.org>
References: <20200707145752.417212219@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: J. Bruce Fields <bfields@redhat.com>

[ Upstream commit 28df3d1539de5090f7916f6fff03891b67f366f4 ]

We currently revoke read delegations on any write open or any operation
that modifies file data or metadata (including rename, link, and
unlink).  But if the delegation in question is the only read delegation
and is held by the client performing the operation, that's not really
necessary.

It's not always possible to prevent this in the NFSv4.0 case, because
there's not always a way to determine which client an NFSv4.0 delegation
came from.  (In theory we could try to guess this from the transport
layer, e.g., by assuming all traffic on a given TCP connection comes
from the same client.  But that's not really correct.)

In the NFSv4.1 case the session layer always tells us the client.

This patch should remove such self-conflicts in all cases where we can
reliably determine the client from the compound.

To do that we need to track "who" is performing a given (possibly
lease-breaking) file operation.  We're doing that by storing the
information in the svc_rqst and using kthread_data() to map the current
task back to a svc_rqst.

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/filesystems/locking.rst |  2 ++
 fs/locks.c                            |  3 +++
 fs/nfsd/nfs4proc.c                    |  2 ++
 fs/nfsd/nfs4state.c                   | 14 ++++++++++++++
 fs/nfsd/nfsd.h                        |  2 ++
 fs/nfsd/nfssvc.c                      |  6 ++++++
 include/linux/fs.h                    |  1 +
 include/linux/sunrpc/svc.h            |  1 +
 8 files changed, 31 insertions(+)

diff --git a/Documentation/filesystems/locking.rst b/Documentation/filesystems/locking.rst
index fc3a0704553cf..b5f8d15a30fb7 100644
--- a/Documentation/filesystems/locking.rst
+++ b/Documentation/filesystems/locking.rst
@@ -425,6 +425,7 @@ prototypes::
 	int (*lm_grant)(struct file_lock *, struct file_lock *, int);
 	void (*lm_break)(struct file_lock *); /* break_lease callback */
 	int (*lm_change)(struct file_lock **, int);
+	bool (*lm_breaker_owns_lease)(struct file_lock *);
 
 locking rules:
 
@@ -435,6 +436,7 @@ lm_notify:		yes		yes			no
 lm_grant:		no		no			no
 lm_break:		yes		no			no
 lm_change		yes		no			no
+lm_breaker_owns_lease:	no		no			no
 ==========		=============	=================	=========
 
 buffer_head
diff --git a/fs/locks.c b/fs/locks.c
index b8a31c1c4fff3..a3f186846e93e 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -1557,6 +1557,9 @@ static bool leases_conflict(struct file_lock *lease, struct file_lock *breaker)
 {
 	bool rc;
 
+	if (lease->fl_lmops->lm_breaker_owns_lease
+			&& lease->fl_lmops->lm_breaker_owns_lease(lease))
+		return false;
 	if ((breaker->fl_flags & FL_LAYOUT) != (lease->fl_flags & FL_LAYOUT)) {
 		rc = false;
 		goto trace;
diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 4798667af647c..96fa2837d3cfb 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1961,6 +1961,8 @@ nfsd4_proc_compound(struct svc_rqst *rqstp)
 		goto encode_op;
 	}
 
+	rqstp->rq_lease_breaker = (void **)&cstate->clp;
+
 	trace_nfsd_compound(rqstp, args->opcnt);
 	while (!status && resp->opcnt < args->opcnt) {
 		op = &args->ops[resp->opcnt++];
diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 8650a97e2ba96..1e8f5e281bb53 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -4464,6 +4464,19 @@ nfsd_break_deleg_cb(struct file_lock *fl)
 	return ret;
 }
 
+static bool nfsd_breaker_owns_lease(struct file_lock *fl)
+{
+	struct nfs4_delegation *dl = fl->fl_owner;
+	struct svc_rqst *rqst;
+	struct nfs4_client *clp;
+
+	if (!i_am_nfsd())
+		return NULL;
+	rqst = kthread_data(current);
+	clp = *(rqst->rq_lease_breaker);
+	return dl->dl_stid.sc_client == clp;
+}
+
 static int
 nfsd_change_deleg_cb(struct file_lock *onlist, int arg,
 		     struct list_head *dispose)
@@ -4475,6 +4488,7 @@ nfsd_change_deleg_cb(struct file_lock *onlist, int arg,
 }
 
 static const struct lock_manager_operations nfsd_lease_mng_ops = {
+	.lm_breaker_owns_lease = nfsd_breaker_owns_lease,
 	.lm_break = nfsd_break_deleg_cb,
 	.lm_change = nfsd_change_deleg_cb,
 };
diff --git a/fs/nfsd/nfsd.h b/fs/nfsd/nfsd.h
index af2947551e9ce..7a835fb7d79f7 100644
--- a/fs/nfsd/nfsd.h
+++ b/fs/nfsd/nfsd.h
@@ -87,6 +87,8 @@ int		nfsd_pool_stats_release(struct inode *, struct file *);
 
 void		nfsd_destroy(struct net *net);
 
+bool		i_am_nfsd(void);
+
 struct nfsdfs_client {
 	struct kref cl_ref;
 	void (*cl_release)(struct kref *kref);
diff --git a/fs/nfsd/nfssvc.c b/fs/nfsd/nfssvc.c
index e8bee8ff30c59..cb7f0aa9a3b05 100644
--- a/fs/nfsd/nfssvc.c
+++ b/fs/nfsd/nfssvc.c
@@ -590,6 +590,11 @@ static const struct svc_serv_ops nfsd_thread_sv_ops = {
 	.svo_module		= THIS_MODULE,
 };
 
+bool i_am_nfsd()
+{
+	return kthread_func(current) == nfsd;
+}
+
 int nfsd_create_serv(struct net *net)
 {
 	int error;
@@ -997,6 +1002,7 @@ nfsd_dispatch(struct svc_rqst *rqstp, __be32 *statp)
 		*statp = rpc_garbage_args;
 		return 1;
 	}
+	rqstp->rq_lease_breaker = NULL;
 	/*
 	 * Give the xdr decoder a chance to change this if it wants
 	 * (necessary in the NFSv4.0 compound case)
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 5bd384dbdca58..4b5b7667405d8 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1040,6 +1040,7 @@ struct lock_manager_operations {
 	bool (*lm_break)(struct file_lock *);
 	int (*lm_change)(struct file_lock *, int, struct list_head *);
 	void (*lm_setup)(struct file_lock *, void **);
+	bool (*lm_breaker_owns_lease)(struct file_lock *);
 };
 
 struct lock_manager {
diff --git a/include/linux/sunrpc/svc.h b/include/linux/sunrpc/svc.h
index 1afe38eb33f7e..ab6e12d9fcf61 100644
--- a/include/linux/sunrpc/svc.h
+++ b/include/linux/sunrpc/svc.h
@@ -299,6 +299,7 @@ struct svc_rqst {
 	struct net		*rq_bc_net;	/* pointer to backchannel's
 						 * net namespace
 						 */
+	void **			rq_lease_breaker; /* The v4 client breaking a lease */
 };
 
 #define SVC_NET(rqst) (rqst->rq_xprt ? rqst->rq_xprt->xpt_net : rqst->rq_bc_net)
-- 
2.25.1



