Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE8663C2E16
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:25:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233146AbhGJC0K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:26:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:42072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233252AbhGJCZf (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:25:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 141B3613E6;
        Sat, 10 Jul 2021 02:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625883770;
        bh=wpp4vLQ3qXev80xheMBMzW7O59SxQ6+/J2jOMA/mPY8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W6IUgVRRVv+/Oo6MSb1LBmw3gZsIgz7ubgT911tRI36aV4+32g7HoPRPoeCa4KkNe
         3xeNponRenhlXer5TIwWmZgFqHiW42RqBgVJMrYL/LK8o8vzX1ZE9jM1aIYwq7KNXs
         GARAKUiOf7c4iNNVp8WSniowLxu4j2ZZ5rArtVcO8U0KGMMX0M0CiKx2V2DnB/5yy9
         3+8P7A+RjXY3+gVX1R/n+MVF25Ebqazf2Bw+iqrr53AKQP+XDJGfp60wRB2OSbATh2
         4W/5CLq+QyUyS8nWaoP27jrHd1t0HjzZodG8t1K+I9EpRLo7X1vaWtnSbqQZqk9y6+
         jDQNLhl9EGfzQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>,
        Lee Duncan <lduncan@suse.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, open-iscsi@googlegroups.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 041/104] scsi: iscsi: Fix conn use after free during resets
Date:   Fri,  9 Jul 2021 22:20:53 -0400
Message-Id: <20210710022156.3168825-41-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710022156.3168825-1-sashal@kernel.org>
References: <20210710022156.3168825-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Christie <michael.christie@oracle.com>

[ Upstream commit ec29d0ac29be366450a7faffbcf8cba3a6a3b506 ]

If we haven't done a unbind target call we can race where
iscsi_conn_teardown wakes up the EH thread and then frees the conn while
those threads are still accessing the conn ehwait.

We can only do one TMF per session so this just moves the TMF fields from
the conn to the session. We can then rely on the
iscsi_session_teardown->iscsi_remove_session->__iscsi_unbind_session call
to remove the target and it's devices, and know after that point there is
no device or scsi-ml callout trying to access the session.

Link: https://lore.kernel.org/r/20210525181821.7617-14-michael.christie@oracle.com
Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/libiscsi.c | 115 +++++++++++++++++++---------------------
 include/scsi/libiscsi.h |  11 ++--
 2 files changed, 60 insertions(+), 66 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index ab39d7f65bbb..dfe906307e55 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -230,11 +230,11 @@ static int iscsi_prep_ecdb_ahs(struct iscsi_task *task)
  */
 static int iscsi_check_tmf_restrictions(struct iscsi_task *task, int opcode)
 {
-	struct iscsi_conn *conn = task->conn;
-	struct iscsi_tm *tmf = &conn->tmhdr;
+	struct iscsi_session *session = task->conn->session;
+	struct iscsi_tm *tmf = &session->tmhdr;
 	u64 hdr_lun;
 
-	if (conn->tmf_state == TMF_INITIAL)
+	if (session->tmf_state == TMF_INITIAL)
 		return 0;
 
 	if ((tmf->opcode & ISCSI_OPCODE_MASK) != ISCSI_OP_SCSI_TMFUNC)
@@ -254,24 +254,19 @@ static int iscsi_check_tmf_restrictions(struct iscsi_task *task, int opcode)
 		 * Fail all SCSI cmd PDUs
 		 */
 		if (opcode != ISCSI_OP_SCSI_DATA_OUT) {
-			iscsi_conn_printk(KERN_INFO, conn,
-					  "task [op %x itt "
-					  "0x%x/0x%x] "
-					  "rejected.\n",
-					  opcode, task->itt,
-					  task->hdr_itt);
+			iscsi_session_printk(KERN_INFO, session,
+					     "task [op %x itt 0x%x/0x%x] rejected.\n",
+					     opcode, task->itt, task->hdr_itt);
 			return -EACCES;
 		}
 		/*
 		 * And also all data-out PDUs in response to R2T
 		 * if fast_abort is set.
 		 */
-		if (conn->session->fast_abort) {
-			iscsi_conn_printk(KERN_INFO, conn,
-					  "task [op %x itt "
-					  "0x%x/0x%x] fast abort.\n",
-					  opcode, task->itt,
-					  task->hdr_itt);
+		if (session->fast_abort) {
+			iscsi_session_printk(KERN_INFO, session,
+					     "task [op %x itt 0x%x/0x%x] fast abort.\n",
+					     opcode, task->itt, task->hdr_itt);
 			return -EACCES;
 		}
 		break;
@@ -284,7 +279,7 @@ static int iscsi_check_tmf_restrictions(struct iscsi_task *task, int opcode)
 		 */
 		if (opcode == ISCSI_OP_SCSI_DATA_OUT &&
 		    task->hdr_itt == tmf->rtt) {
-			ISCSI_DBG_SESSION(conn->session,
+			ISCSI_DBG_SESSION(session,
 					  "Preventing task %x/%x from sending "
 					  "data-out due to abort task in "
 					  "progress\n", task->itt,
@@ -936,20 +931,21 @@ iscsi_data_in_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 static void iscsi_tmf_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
 {
 	struct iscsi_tm_rsp *tmf = (struct iscsi_tm_rsp *)hdr;
+	struct iscsi_session *session = conn->session;
 
 	conn->exp_statsn = be32_to_cpu(hdr->statsn) + 1;
 	conn->tmfrsp_pdus_cnt++;
 
-	if (conn->tmf_state != TMF_QUEUED)
+	if (session->tmf_state != TMF_QUEUED)
 		return;
 
 	if (tmf->response == ISCSI_TMF_RSP_COMPLETE)
-		conn->tmf_state = TMF_SUCCESS;
+		session->tmf_state = TMF_SUCCESS;
 	else if (tmf->response == ISCSI_TMF_RSP_NO_TASK)
-		conn->tmf_state = TMF_NOT_FOUND;
+		session->tmf_state = TMF_NOT_FOUND;
 	else
-		conn->tmf_state = TMF_FAILED;
-	wake_up(&conn->ehwait);
+		session->tmf_state = TMF_FAILED;
+	wake_up(&session->ehwait);
 }
 
 static int iscsi_send_nopout(struct iscsi_conn *conn, struct iscsi_nopin *rhdr)
@@ -1826,15 +1822,14 @@ EXPORT_SYMBOL_GPL(iscsi_target_alloc);
 
 static void iscsi_tmf_timedout(struct timer_list *t)
 {
-	struct iscsi_conn *conn = from_timer(conn, t, tmf_timer);
-	struct iscsi_session *session = conn->session;
+	struct iscsi_session *session = from_timer(session, t, tmf_timer);
 
 	spin_lock(&session->frwd_lock);
-	if (conn->tmf_state == TMF_QUEUED) {
-		conn->tmf_state = TMF_TIMEDOUT;
+	if (session->tmf_state == TMF_QUEUED) {
+		session->tmf_state = TMF_TIMEDOUT;
 		ISCSI_DBG_EH(session, "tmf timedout\n");
 		/* unblock eh_abort() */
-		wake_up(&conn->ehwait);
+		wake_up(&session->ehwait);
 	}
 	spin_unlock(&session->frwd_lock);
 }
@@ -1857,8 +1852,8 @@ static int iscsi_exec_task_mgmt_fn(struct iscsi_conn *conn,
 		return -EPERM;
 	}
 	conn->tmfcmd_pdus_cnt++;
-	conn->tmf_timer.expires = timeout * HZ + jiffies;
-	add_timer(&conn->tmf_timer);
+	session->tmf_timer.expires = timeout * HZ + jiffies;
+	add_timer(&session->tmf_timer);
 	ISCSI_DBG_EH(session, "tmf set timeout\n");
 
 	spin_unlock_bh(&session->frwd_lock);
@@ -1872,12 +1867,12 @@ static int iscsi_exec_task_mgmt_fn(struct iscsi_conn *conn,
 	 * 3) session is terminated or restarted or userspace has
 	 * given up on recovery
 	 */
-	wait_event_interruptible(conn->ehwait, age != session->age ||
+	wait_event_interruptible(session->ehwait, age != session->age ||
 				 session->state != ISCSI_STATE_LOGGED_IN ||
-				 conn->tmf_state != TMF_QUEUED);
+				 session->tmf_state != TMF_QUEUED);
 	if (signal_pending(current))
 		flush_signals(current);
-	del_timer_sync(&conn->tmf_timer);
+	del_timer_sync(&session->tmf_timer);
 
 	mutex_lock(&session->eh_mutex);
 	spin_lock_bh(&session->frwd_lock);
@@ -2309,17 +2304,17 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 	}
 
 	/* only have one tmf outstanding at a time */
-	if (conn->tmf_state != TMF_INITIAL)
+	if (session->tmf_state != TMF_INITIAL)
 		goto failed;
-	conn->tmf_state = TMF_QUEUED;
+	session->tmf_state = TMF_QUEUED;
 
-	hdr = &conn->tmhdr;
+	hdr = &session->tmhdr;
 	iscsi_prep_abort_task_pdu(task, hdr);
 
 	if (iscsi_exec_task_mgmt_fn(conn, hdr, age, session->abort_timeout))
 		goto failed;
 
-	switch (conn->tmf_state) {
+	switch (session->tmf_state) {
 	case TMF_SUCCESS:
 		spin_unlock_bh(&session->frwd_lock);
 		/*
@@ -2334,7 +2329,7 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 		 */
 		spin_lock_bh(&session->frwd_lock);
 		fail_scsi_task(task, DID_ABORT);
-		conn->tmf_state = TMF_INITIAL;
+		session->tmf_state = TMF_INITIAL;
 		memset(hdr, 0, sizeof(*hdr));
 		spin_unlock_bh(&session->frwd_lock);
 		iscsi_start_tx(conn);
@@ -2345,7 +2340,7 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 		goto failed_unlocked;
 	case TMF_NOT_FOUND:
 		if (!sc->SCp.ptr) {
-			conn->tmf_state = TMF_INITIAL;
+			session->tmf_state = TMF_INITIAL;
 			memset(hdr, 0, sizeof(*hdr));
 			/* task completed before tmf abort response */
 			ISCSI_DBG_EH(session, "sc completed while abort	in "
@@ -2354,7 +2349,7 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 		}
 		fallthrough;
 	default:
-		conn->tmf_state = TMF_INITIAL;
+		session->tmf_state = TMF_INITIAL;
 		goto failed;
 	}
 
@@ -2413,11 +2408,11 @@ int iscsi_eh_device_reset(struct scsi_cmnd *sc)
 	conn = session->leadconn;
 
 	/* only have one tmf outstanding at a time */
-	if (conn->tmf_state != TMF_INITIAL)
+	if (session->tmf_state != TMF_INITIAL)
 		goto unlock;
-	conn->tmf_state = TMF_QUEUED;
+	session->tmf_state = TMF_QUEUED;
 
-	hdr = &conn->tmhdr;
+	hdr = &session->tmhdr;
 	iscsi_prep_lun_reset_pdu(sc, hdr);
 
 	if (iscsi_exec_task_mgmt_fn(conn, hdr, session->age,
@@ -2426,7 +2421,7 @@ int iscsi_eh_device_reset(struct scsi_cmnd *sc)
 		goto unlock;
 	}
 
-	switch (conn->tmf_state) {
+	switch (session->tmf_state) {
 	case TMF_SUCCESS:
 		break;
 	case TMF_TIMEDOUT:
@@ -2434,7 +2429,7 @@ int iscsi_eh_device_reset(struct scsi_cmnd *sc)
 		iscsi_conn_failure(conn, ISCSI_ERR_SCSI_EH_SESSION_RST);
 		goto done;
 	default:
-		conn->tmf_state = TMF_INITIAL;
+		session->tmf_state = TMF_INITIAL;
 		goto unlock;
 	}
 
@@ -2446,7 +2441,7 @@ int iscsi_eh_device_reset(struct scsi_cmnd *sc)
 	spin_lock_bh(&session->frwd_lock);
 	memset(hdr, 0, sizeof(*hdr));
 	fail_scsi_tasks(conn, sc->device->lun, DID_ERROR);
-	conn->tmf_state = TMF_INITIAL;
+	session->tmf_state = TMF_INITIAL;
 	spin_unlock_bh(&session->frwd_lock);
 
 	iscsi_start_tx(conn);
@@ -2469,8 +2464,7 @@ void iscsi_session_recovery_timedout(struct iscsi_cls_session *cls_session)
 	spin_lock_bh(&session->frwd_lock);
 	if (session->state != ISCSI_STATE_LOGGED_IN) {
 		session->state = ISCSI_STATE_RECOVERY_FAILED;
-		if (session->leadconn)
-			wake_up(&session->leadconn->ehwait);
+		wake_up(&session->ehwait);
 	}
 	spin_unlock_bh(&session->frwd_lock);
 }
@@ -2515,7 +2509,7 @@ int iscsi_eh_session_reset(struct scsi_cmnd *sc)
 	iscsi_conn_failure(conn, ISCSI_ERR_SCSI_EH_SESSION_RST);
 
 	ISCSI_DBG_EH(session, "wait for relogin\n");
-	wait_event_interruptible(conn->ehwait,
+	wait_event_interruptible(session->ehwait,
 				 session->state == ISCSI_STATE_TERMINATE ||
 				 session->state == ISCSI_STATE_LOGGED_IN ||
 				 session->state == ISCSI_STATE_RECOVERY_FAILED);
@@ -2576,11 +2570,11 @@ static int iscsi_eh_target_reset(struct scsi_cmnd *sc)
 	conn = session->leadconn;
 
 	/* only have one tmf outstanding at a time */
-	if (conn->tmf_state != TMF_INITIAL)
+	if (session->tmf_state != TMF_INITIAL)
 		goto unlock;
-	conn->tmf_state = TMF_QUEUED;
+	session->tmf_state = TMF_QUEUED;
 
-	hdr = &conn->tmhdr;
+	hdr = &session->tmhdr;
 	iscsi_prep_tgt_reset_pdu(sc, hdr);
 
 	if (iscsi_exec_task_mgmt_fn(conn, hdr, session->age,
@@ -2589,7 +2583,7 @@ static int iscsi_eh_target_reset(struct scsi_cmnd *sc)
 		goto unlock;
 	}
 
-	switch (conn->tmf_state) {
+	switch (session->tmf_state) {
 	case TMF_SUCCESS:
 		break;
 	case TMF_TIMEDOUT:
@@ -2597,7 +2591,7 @@ static int iscsi_eh_target_reset(struct scsi_cmnd *sc)
 		iscsi_conn_failure(conn, ISCSI_ERR_SCSI_EH_SESSION_RST);
 		goto done;
 	default:
-		conn->tmf_state = TMF_INITIAL;
+		session->tmf_state = TMF_INITIAL;
 		goto unlock;
 	}
 
@@ -2609,7 +2603,7 @@ static int iscsi_eh_target_reset(struct scsi_cmnd *sc)
 	spin_lock_bh(&session->frwd_lock);
 	memset(hdr, 0, sizeof(*hdr));
 	fail_scsi_tasks(conn, -1, DID_ERROR);
-	conn->tmf_state = TMF_INITIAL;
+	session->tmf_state = TMF_INITIAL;
 	spin_unlock_bh(&session->frwd_lock);
 
 	iscsi_start_tx(conn);
@@ -2939,7 +2933,10 @@ iscsi_session_setup(struct iscsi_transport *iscsit, struct Scsi_Host *shost,
 	session->tt = iscsit;
 	session->dd_data = cls_session->dd_data + sizeof(*session);
 
+	session->tmf_state = TMF_INITIAL;
+	timer_setup(&session->tmf_timer, iscsi_tmf_timedout, 0);
 	mutex_init(&session->eh_mutex);
+
 	spin_lock_init(&session->frwd_lock);
 	spin_lock_init(&session->back_lock);
 
@@ -3043,7 +3040,6 @@ iscsi_conn_setup(struct iscsi_cls_session *cls_session, int dd_size,
 	conn->c_stage = ISCSI_CONN_INITIAL_STAGE;
 	conn->id = conn_idx;
 	conn->exp_statsn = 0;
-	conn->tmf_state = TMF_INITIAL;
 
 	timer_setup(&conn->transport_timer, iscsi_check_transport_timeouts, 0);
 
@@ -3068,8 +3064,7 @@ iscsi_conn_setup(struct iscsi_cls_session *cls_session, int dd_size,
 		goto login_task_data_alloc_fail;
 	conn->login_task->data = conn->data = data;
 
-	timer_setup(&conn->tmf_timer, iscsi_tmf_timedout, 0);
-	init_waitqueue_head(&conn->ehwait);
+	init_waitqueue_head(&session->ehwait);
 
 	return cls_conn;
 
@@ -3104,7 +3099,7 @@ void iscsi_conn_teardown(struct iscsi_cls_conn *cls_conn)
 		 * leading connection? then give up on recovery.
 		 */
 		session->state = ISCSI_STATE_TERMINATE;
-		wake_up(&conn->ehwait);
+		wake_up(&session->ehwait);
 	}
 	spin_unlock_bh(&session->frwd_lock);
 
@@ -3179,7 +3174,7 @@ int iscsi_conn_start(struct iscsi_cls_conn *cls_conn)
 		 * commands after successful recovery
 		 */
 		conn->stop_stage = 0;
-		conn->tmf_state = TMF_INITIAL;
+		session->tmf_state = TMF_INITIAL;
 		session->age++;
 		if (session->age == 16)
 			session->age = 0;
@@ -3193,7 +3188,7 @@ int iscsi_conn_start(struct iscsi_cls_conn *cls_conn)
 	spin_unlock_bh(&session->frwd_lock);
 
 	iscsi_unblock_session(session->cls_session);
-	wake_up(&conn->ehwait);
+	wake_up(&session->ehwait);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(iscsi_conn_start);
@@ -3287,7 +3282,7 @@ void iscsi_conn_stop(struct iscsi_cls_conn *cls_conn, int flag)
 	spin_lock_bh(&session->frwd_lock);
 	fail_scsi_tasks(conn, -1, DID_TRANSPORT_DISRUPTED);
 	fail_mgmt_tasks(session, conn);
-	memset(&conn->tmhdr, 0, sizeof(conn->tmhdr));
+	memset(&session->tmhdr, 0, sizeof(session->tmhdr));
 	spin_unlock_bh(&session->frwd_lock);
 	mutex_unlock(&session->eh_mutex);
 }
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 091f284bd6e9..2bb452a8f134 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -195,12 +195,6 @@ struct iscsi_conn {
 	unsigned long		suspend_tx;	/* suspend Tx */
 	unsigned long		suspend_rx;	/* suspend Rx */
 
-	/* abort */
-	wait_queue_head_t	ehwait;		/* used in eh_abort() */
-	struct iscsi_tm		tmhdr;
-	struct timer_list	tmf_timer;
-	int			tmf_state;	/* see TMF_INITIAL, etc.*/
-
 	/* negotiated params */
 	unsigned		max_recv_dlength; /* initiator_max_recv_dsl*/
 	unsigned		max_xmit_dlength; /* target_max_recv_dsl */
@@ -270,6 +264,11 @@ struct iscsi_session {
 	 * and recv lock.
 	 */
 	struct mutex		eh_mutex;
+	/* abort */
+	wait_queue_head_t	ehwait;		/* used in eh_abort() */
+	struct iscsi_tm		tmhdr;
+	struct timer_list	tmf_timer;
+	int			tmf_state;	/* see TMF_INITIAL, etc.*/
 
 	/* iSCSI session-wide sequencing */
 	uint32_t		cmdsn;
-- 
2.30.2

