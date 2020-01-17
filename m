Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F6F013FFB8
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:45:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731940AbgAPXog (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:44:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:52796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730969AbgAPXYB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:24:01 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B42E7206D9;
        Thu, 16 Jan 2020 23:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217040;
        bh=ldsUpBwdcBBX6zPRy6kx1Lh2h6EqBnpsrUOw2AZ4JBU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=goYJoRB5SfYMdhUvoULFovOoYG3nhFiiJuecuDhskSZeAdkj1bH0QoIL55hQs6IEK
         54KUyeRIjnPcViMiDz5vNeRjH9w1wvpFuxCutIulKp5nL8YtU1GTTwj0LJu/6d783l
         os0BBLpUCWH8pm3GQl+kKSE8291G+9vqBYj9zpuo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 5.4 107/203] NFSv4.x: Handle bad/dead sessions correctly in nfs41_sequence_process()
Date:   Fri, 17 Jan 2020 00:17:04 +0100
Message-Id: <20200116231754.887877704@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231745.218684830@linuxfoundation.org>
References: <20200116231745.218684830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

commit 5c441544f045e679afd6c3c6d9f7aaf5fa5f37b0 upstream.

If the server returns a bad or dead session error, the we don't want
to update the session slot number, but just immediately schedule
recovery and allow it to proceed.

We can/should then remove handling in other places

Fixes: 3453d5708b33 ("NFSv4.1: Avoid false retries when RPC calls are interrupted")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/nfs4proc.c |   34 +++++++++++++++++++++++++---------
 1 file changed, 25 insertions(+), 9 deletions(-)

--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -521,9 +521,7 @@ static int nfs4_do_handle_exception(stru
 		case -NFS4ERR_DEADSESSION:
 		case -NFS4ERR_SEQ_FALSE_RETRY:
 		case -NFS4ERR_SEQ_MISORDERED:
-			dprintk("%s ERROR: %d Reset session\n", __func__,
-				errorcode);
-			nfs4_schedule_session_recovery(clp->cl_session, errorcode);
+			/* Handled in nfs41_sequence_process() */
 			goto wait_on_recovery;
 #endif /* defined(CONFIG_NFS_V4_1) */
 		case -NFS4ERR_FILE_OPEN:
@@ -782,6 +780,7 @@ static int nfs41_sequence_process(struct
 	struct nfs4_session *session;
 	struct nfs4_slot *slot = res->sr_slot;
 	struct nfs_client *clp;
+	int status;
 	int ret = 1;
 
 	if (slot == NULL)
@@ -793,8 +792,13 @@ static int nfs41_sequence_process(struct
 	session = slot->table->session;
 
 	trace_nfs4_sequence_done(session, res);
+
+	status = res->sr_status;
+	if (task->tk_status == -NFS4ERR_DEADSESSION)
+		status = -NFS4ERR_DEADSESSION;
+
 	/* Check the SEQUENCE operation status */
-	switch (res->sr_status) {
+	switch (status) {
 	case 0:
 		/* Mark this sequence number as having been acked */
 		nfs4_slot_sequence_acked(slot, slot->seq_nr);
@@ -866,6 +870,10 @@ static int nfs41_sequence_process(struct
 		 */
 		slot->seq_nr = slot->seq_nr_highest_sent;
 		goto out_retry;
+	case -NFS4ERR_BADSESSION:
+	case -NFS4ERR_DEADSESSION:
+	case -NFS4ERR_CONN_NOT_BOUND_TO_SESSION:
+		goto session_recover;
 	default:
 		/* Just update the slot sequence no. */
 		slot->seq_done = 1;
@@ -876,8 +884,10 @@ out:
 out_noaction:
 	return ret;
 session_recover:
-	nfs4_schedule_session_recovery(session, res->sr_status);
-	goto retry_nowait;
+	nfs4_schedule_session_recovery(session, status);
+	dprintk("%s ERROR: %d Reset session\n", __func__, status);
+	nfs41_sequence_free_slot(res);
+	goto out;
 retry_new_seq:
 	++slot->seq_nr;
 retry_nowait:
@@ -2188,7 +2198,6 @@ static int nfs4_handle_delegation_recall
 		case -NFS4ERR_BAD_HIGH_SLOT:
 		case -NFS4ERR_CONN_NOT_BOUND_TO_SESSION:
 		case -NFS4ERR_DEADSESSION:
-			nfs4_schedule_session_recovery(server->nfs_client->cl_session, err);
 			return -EAGAIN;
 		case -NFS4ERR_STALE_CLIENTID:
 		case -NFS4ERR_STALE_STATEID:
@@ -7820,6 +7829,15 @@ nfs41_same_server_scope(struct nfs41_ser
 static void
 nfs4_bind_one_conn_to_session_done(struct rpc_task *task, void *calldata)
 {
+	struct nfs41_bind_conn_to_session_args *args = task->tk_msg.rpc_argp;
+	struct nfs_client *clp = args->client;
+
+	switch (task->tk_status) {
+	case -NFS4ERR_BADSESSION:
+	case -NFS4ERR_DEADSESSION:
+		nfs4_schedule_session_recovery(clp->cl_session,
+				task->tk_status);
+	}
 }
 
 static const struct rpc_call_ops nfs4_bind_one_conn_to_session_ops = {
@@ -8867,8 +8885,6 @@ static int nfs41_reclaim_complete_handle
 	case -NFS4ERR_BADSESSION:
 	case -NFS4ERR_DEADSESSION:
 	case -NFS4ERR_CONN_NOT_BOUND_TO_SESSION:
-		nfs4_schedule_session_recovery(clp->cl_session,
-				task->tk_status);
 		break;
 	default:
 		nfs4_schedule_lease_recovery(clp);


