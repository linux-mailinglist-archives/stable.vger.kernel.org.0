Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A774015C463
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:53:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387843AbgBMPqp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:46:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:49346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729012AbgBMP1N (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:27:13 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2BC592168B;
        Thu, 13 Feb 2020 15:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607632;
        bh=wze1R9Sx/IvZWY6+hkwJtRPbxSyVkd0ruGj6bpG/WWw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QZfZmFy4judiOplb0/YoeF7isSQoaVx4z38/s66HI8U1IUp4W2bieHhiDIik7A4j5
         k/Lc2dCuIZmVTBUuSzdSu4rRnJxa/NlFSIyCiWhvxqsIFewRKuvEkz4+CbYzR41qBZ
         PcFWdGhOS/CLL7FEVe2rrMZSmxnzsvBDluZPvtH4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Milkowski <rmilkowski@gmail.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>
Subject: [PATCH 5.4 33/96] NFSv4.0: nfs4_do_fsinfo() should not do implicit lease renewals
Date:   Thu, 13 Feb 2020 07:20:40 -0800
Message-Id: <20200213151851.829774508@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151839.156309910@linuxfoundation.org>
References: <20200213151839.156309910@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robert Milkowski <rmilkowski@gmail.com>

commit 7dc2993a9e51dd2eee955944efec65bef90265b7 upstream.

Currently, each time nfs4_do_fsinfo() is called it will do an implicit
NFS4 lease renewal, which is not compliant with the NFS4 specification.
This can result in a lease being expired by an NFS server.

Commit 83ca7f5ab31f ("NFS: Avoid PUTROOTFH when managing leases")
introduced implicit client lease renewal in nfs4_do_fsinfo(),
which can result in the NFSv4.0 lease to expire on a server side,
and servers returning NFS4ERR_EXPIRED or NFS4ERR_STALE_CLIENTID.

This can easily be reproduced by frequently unmounting a sub-mount,
then stat'ing it to get it mounted again, which will delay or even
completely prevent client from sending RENEW operations if no other
NFS operations are issued. Eventually nfs server will expire client's
lease and return an error on file access or next RENEW.

This can also happen when a sub-mount is automatically unmounted
due to inactivity (after nfs_mountpoint_expiry_timeout), then it is
mounted again via stat(). This can result in a short window during
which client's lease will expire on a server but not on a client.
This specific case was observed on production systems.

This patch removes the implicit lease renewal from nfs4_do_fsinfo().

Fixes: 83ca7f5ab31f ("NFS: Avoid PUTROOTFH when managing leases")
Signed-off-by: Robert Milkowski <rmilkowski@gmail.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/nfs4_fs.h    |    4 +---
 fs/nfs/nfs4proc.c   |   12 ++++++++----
 fs/nfs/nfs4renewd.c |    5 +----
 fs/nfs/nfs4state.c  |    4 +---
 4 files changed, 11 insertions(+), 14 deletions(-)

--- a/fs/nfs/nfs4_fs.h
+++ b/fs/nfs/nfs4_fs.h
@@ -439,9 +439,7 @@ extern void nfs4_schedule_state_renewal(
 extern void nfs4_renewd_prepare_shutdown(struct nfs_server *);
 extern void nfs4_kill_renewd(struct nfs_client *);
 extern void nfs4_renew_state(struct work_struct *);
-extern void nfs4_set_lease_period(struct nfs_client *clp,
-		unsigned long lease,
-		unsigned long lastrenewed);
+extern void nfs4_set_lease_period(struct nfs_client *clp, unsigned long lease);
 
 
 /* nfs4state.c */
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -5024,16 +5024,13 @@ static int nfs4_do_fsinfo(struct nfs_ser
 	struct nfs4_exception exception = {
 		.interruptible = true,
 	};
-	unsigned long now = jiffies;
 	int err;
 
 	do {
 		err = _nfs4_do_fsinfo(server, fhandle, fsinfo);
 		trace_nfs4_fsinfo(server, fhandle, fsinfo->fattr, err);
 		if (err == 0) {
-			nfs4_set_lease_period(server->nfs_client,
-					fsinfo->lease_time * HZ,
-					now);
+			nfs4_set_lease_period(server->nfs_client, fsinfo->lease_time * HZ);
 			break;
 		}
 		err = nfs4_handle_exception(server, err, &exception);
@@ -6089,6 +6086,7 @@ int nfs4_proc_setclientid(struct nfs_cli
 		.callback_data = &setclientid,
 		.flags = RPC_TASK_TIMEOUT | RPC_TASK_NO_ROUND_ROBIN,
 	};
+	unsigned long now = jiffies;
 	int status;
 
 	/* nfs_client_id4 */
@@ -6121,6 +6119,9 @@ int nfs4_proc_setclientid(struct nfs_cli
 		clp->cl_acceptor = rpcauth_stringify_acceptor(setclientid.sc_cred);
 		put_rpccred(setclientid.sc_cred);
 	}
+
+	if (status == 0)
+		do_renew_lease(clp, now);
 out:
 	trace_nfs4_setclientid(clp, status);
 	dprintk("NFS reply setclientid: %d\n", status);
@@ -8204,6 +8205,7 @@ static int _nfs4_proc_exchange_id(struct
 	struct rpc_task *task;
 	struct nfs41_exchange_id_args *argp;
 	struct nfs41_exchange_id_res *resp;
+	unsigned long now = jiffies;
 	int status;
 
 	task = nfs4_run_exchange_id(clp, cred, sp4_how, NULL);
@@ -8224,6 +8226,8 @@ static int _nfs4_proc_exchange_id(struct
 	if (status != 0)
 		goto out;
 
+	do_renew_lease(clp, now);
+
 	clp->cl_clientid = resp->clientid;
 	clp->cl_exchange_flags = resp->flags;
 	clp->cl_seqid = resp->seqid;
--- a/fs/nfs/nfs4renewd.c
+++ b/fs/nfs/nfs4renewd.c
@@ -138,15 +138,12 @@ nfs4_kill_renewd(struct nfs_client *clp)
  *
  * @clp: pointer to nfs_client
  * @lease: new value for lease period
- * @lastrenewed: time at which lease was last renewed
  */
 void nfs4_set_lease_period(struct nfs_client *clp,
-		unsigned long lease,
-		unsigned long lastrenewed)
+		unsigned long lease)
 {
 	spin_lock(&clp->cl_lock);
 	clp->cl_lease_time = lease;
-	clp->cl_last_renewal = lastrenewed;
 	spin_unlock(&clp->cl_lock);
 
 	/* Cap maximum reconnect timeout at 1/2 lease period */
--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -91,17 +91,15 @@ static int nfs4_setup_state_renewal(stru
 {
 	int status;
 	struct nfs_fsinfo fsinfo;
-	unsigned long now;
 
 	if (!test_bit(NFS_CS_CHECK_LEASE_TIME, &clp->cl_res_state)) {
 		nfs4_schedule_state_renewal(clp);
 		return 0;
 	}
 
-	now = jiffies;
 	status = nfs4_proc_get_lease_time(clp, &fsinfo);
 	if (status == 0) {
-		nfs4_set_lease_period(clp, fsinfo.lease_time * HZ, now);
+		nfs4_set_lease_period(clp, fsinfo.lease_time * HZ);
 		nfs4_schedule_state_renewal(clp);
 	}
 


