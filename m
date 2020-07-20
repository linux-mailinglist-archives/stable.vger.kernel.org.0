Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 114132268BB
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:24:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387741AbgGTQLD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:11:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:49848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387736AbgGTQLC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:11:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 69D1D2064B;
        Mon, 20 Jul 2020 16:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261462;
        bh=SBlFkReosziBxuvkdEK8X2H748jr3WdZloS1SoahGPw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A6YWPR7lqBzj9bMej6ruB7eKr+v+PRL6ggNkv+hra8Evq10i2y2YKUwVAxjqomM9r
         BZYLyhInj3gAcXyTmulQj5u8lzs2DqFZLZiZKSDUBzhDGjU4nz1mNzKjI9PvDtgkqJ
         95Uv3Yhgw63QOZ7mFe2LvV1Qv7sQNRR5q8keVd/M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 107/244] NFS: Fix interrupted slots by sending a solo SEQUENCE operation
Date:   Mon, 20 Jul 2020 17:36:18 +0200
Message-Id: <20200720152830.917630970@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152825.863040590@linuxfoundation.org>
References: <20200720152825.863040590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anna Schumaker <Anna.Schumaker@Netapp.com>

[ Upstream commit 913fadc5b105c3619d9e8d0fe8899ff1593cc737 ]

We used to do this before 3453d5708b33, but this was changed to better
handle the NFS4ERR_SEQ_MISORDERED error code. This commit fixed the slot
re-use case when the server doesn't receive the interrupted operation,
but if the server does receive the operation then it could still end up
replying to the client with mis-matched operations from the reply cache.

We can fix this by sending a SEQUENCE to the server while recovering from
a SEQ_MISORDERED error when we detect that we are in an interrupted slot
situation.

Fixes: 3453d5708b33 (NFSv4.1: Avoid false retries when RPC calls are interrupted)
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4proc.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index e32717fd1169a..2e2dac29a9e91 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -774,6 +774,14 @@ static void nfs4_slot_sequence_acked(struct nfs4_slot *slot,
 	slot->seq_nr_last_acked = seqnr;
 }
 
+static void nfs4_probe_sequence(struct nfs_client *client, const struct cred *cred,
+				struct nfs4_slot *slot)
+{
+	struct rpc_task *task = _nfs41_proc_sequence(client, cred, slot, true);
+	if (!IS_ERR(task))
+		rpc_put_task_async(task);
+}
+
 static int nfs41_sequence_process(struct rpc_task *task,
 		struct nfs4_sequence_res *res)
 {
@@ -790,6 +798,7 @@ static int nfs41_sequence_process(struct rpc_task *task,
 		goto out;
 
 	session = slot->table->session;
+	clp = session->clp;
 
 	trace_nfs4_sequence_done(session, res);
 
@@ -804,7 +813,6 @@ static int nfs41_sequence_process(struct rpc_task *task,
 		nfs4_slot_sequence_acked(slot, slot->seq_nr);
 		/* Update the slot's sequence and clientid lease timer */
 		slot->seq_done = 1;
-		clp = session->clp;
 		do_renew_lease(clp, res->sr_timestamp);
 		/* Check sequence flags */
 		nfs41_handle_sequence_flag_errors(clp, res->sr_status_flags,
@@ -852,10 +860,18 @@ static int nfs41_sequence_process(struct rpc_task *task,
 		/*
 		 * Were one or more calls using this slot interrupted?
 		 * If the server never received the request, then our
-		 * transmitted slot sequence number may be too high.
+		 * transmitted slot sequence number may be too high. However,
+		 * if the server did receive the request then it might
+		 * accidentally give us a reply with a mismatched operation.
+		 * We can sort this out by sending a lone sequence operation
+		 * to the server on the same slot.
 		 */
 		if ((s32)(slot->seq_nr - slot->seq_nr_last_acked) > 1) {
 			slot->seq_nr--;
+			if (task->tk_msg.rpc_proc != &nfs4_procedures[NFSPROC4_CLNT_SEQUENCE]) {
+				nfs4_probe_sequence(clp, task->tk_msg.rpc_cred, slot);
+				res->sr_slot = NULL;
+			}
 			goto retry_nowait;
 		}
 		/*
-- 
2.25.1



