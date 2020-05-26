Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49D391B3D3C
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:13:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726445AbgDVKNQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:13:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:46930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729442AbgDVKNP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:13:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 20FC72075A;
        Wed, 22 Apr 2020 10:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550393;
        bh=iyqB6GscLOqd4OvWEsvEydJPHSWu/nSS0xSDV7NvpNk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dfkdpmj9+x+cINDRlLDcXgIhveKxIvvbialOPGdD+UolvlxkgEWVcPF0yb462PhFr
         jDxt8rMf6qpamrp76x8bex+uv6hgAOu1KMh2e+KU/x3eXW+DX8Q3gs2mseJEwiD3e2
         WWUZzSNIeWw/AFzs+sRL/tLT41YH2+XaR5gzzDzw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matt Coleman <mcoleman@datto.com>,
        Rahul Kundu <rahul.kundu@chelsio.com>,
        Maurizio Lombardi <mlombard@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 128/199] scsi: target: fix hang when multiple threads try to destroy the same iscsi session
Date:   Wed, 22 Apr 2020 11:57:34 +0200
Message-Id: <20200422095110.542217619@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095057.806111593@linuxfoundation.org>
References: <20200422095057.806111593@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maurizio Lombardi <mlombard@redhat.com>

[ Upstream commit 57c46e9f33da530a2485fa01aa27b6d18c28c796 ]

A number of hangs have been reported against the target driver; they are
due to the fact that multiple threads may try to destroy the iscsi session
at the same time. This may be reproduced for example when a "targetcli
iscsi/iqn.../tpg1 disable" command is executed while a logout operation is
underway.

When this happens, two or more threads may end up sleeping and waiting for
iscsit_close_connection() to execute "complete(session_wait_comp)".  Only
one of the threads will wake up and proceed to destroy the session
structure, the remaining threads will hang forever.

Note that if the blocked threads are somehow forced to wake up with
complete_all(), they will try to free the same iscsi session structure
destroyed by the first thread, causing double frees, memory corruptions
etc...

With this patch, the threads that want to destroy the iscsi session will
increase the session refcount and will set the "session_close" flag to 1;
then they wait for the driver to close the remaining active connections.
When the last connection is closed, iscsit_close_connection() will wake up
all the threads and will wait for the session's refcount to reach zero;
when this happens, iscsit_close_connection() will destroy the session
structure because no one is referencing it anymore.

 INFO: task targetcli:5971 blocked for more than 120 seconds.
       Tainted: P           OE    4.15.0-72-generic #81~16.04.1
 "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
 targetcli       D    0  5971      1 0x00000080
 Call Trace:
  __schedule+0x3d6/0x8b0
  ? vprintk_func+0x44/0xe0
  schedule+0x36/0x80
  schedule_timeout+0x1db/0x370
  ? __dynamic_pr_debug+0x8a/0xb0
  wait_for_completion+0xb4/0x140
  ? wake_up_q+0x70/0x70
  iscsit_free_session+0x13d/0x1a0 [iscsi_target_mod]
  iscsit_release_sessions_for_tpg+0x16b/0x1e0 [iscsi_target_mod]
  iscsit_tpg_disable_portal_group+0xca/0x1c0 [iscsi_target_mod]
  lio_target_tpg_enable_store+0x66/0xe0 [iscsi_target_mod]
  configfs_write_file+0xb9/0x120
  __vfs_write+0x1b/0x40
  vfs_write+0xb8/0x1b0
  SyS_write+0x5c/0xe0
  do_syscall_64+0x73/0x130
  entry_SYSCALL_64_after_hwframe+0x3d/0xa2

Link: https://lore.kernel.org/r/20200313170656.9716-3-mlombard@redhat.com
Reported-by: Matt Coleman <mcoleman@datto.com>
Tested-by: Matt Coleman <mcoleman@datto.com>
Tested-by: Rahul Kundu <rahul.kundu@chelsio.com>
Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/iscsi/iscsi_target.c          | 35 ++++++++++++--------
 drivers/target/iscsi/iscsi_target_configfs.c |  5 ++-
 drivers/target/iscsi/iscsi_target_login.c    |  5 +--
 include/target/iscsi/iscsi_target_core.h     |  2 +-
 4 files changed, 30 insertions(+), 17 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 40993c575017f..ee49b227dc12b 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -4314,30 +4314,37 @@ int iscsit_close_connection(
 	if (!atomic_read(&sess->session_reinstatement) &&
 	     atomic_read(&sess->session_fall_back_to_erl0)) {
 		spin_unlock_bh(&sess->conn_lock);
+		complete_all(&sess->session_wait_comp);
 		iscsit_close_session(sess);
 
 		return 0;
 	} else if (atomic_read(&sess->session_logout)) {
 		pr_debug("Moving to TARG_SESS_STATE_FREE.\n");
 		sess->session_state = TARG_SESS_STATE_FREE;
-		spin_unlock_bh(&sess->conn_lock);
 
-		if (atomic_read(&sess->sleep_on_sess_wait_comp))
-			complete(&sess->session_wait_comp);
+		if (atomic_read(&sess->session_close)) {
+			spin_unlock_bh(&sess->conn_lock);
+			complete_all(&sess->session_wait_comp);
+			iscsit_close_session(sess);
+		} else {
+			spin_unlock_bh(&sess->conn_lock);
+		}
 
 		return 0;
 	} else {
 		pr_debug("Moving to TARG_SESS_STATE_FAILED.\n");
 		sess->session_state = TARG_SESS_STATE_FAILED;
 
-		if (!atomic_read(&sess->session_continuation)) {
-			spin_unlock_bh(&sess->conn_lock);
+		if (!atomic_read(&sess->session_continuation))
 			iscsit_start_time2retain_handler(sess);
-		} else
-			spin_unlock_bh(&sess->conn_lock);
 
-		if (atomic_read(&sess->sleep_on_sess_wait_comp))
-			complete(&sess->session_wait_comp);
+		if (atomic_read(&sess->session_close)) {
+			spin_unlock_bh(&sess->conn_lock);
+			complete_all(&sess->session_wait_comp);
+			iscsit_close_session(sess);
+		} else {
+			spin_unlock_bh(&sess->conn_lock);
+		}
 
 		return 0;
 	}
@@ -4446,9 +4453,9 @@ static void iscsit_logout_post_handler_closesession(
 	complete(&conn->conn_logout_comp);
 
 	iscsit_dec_conn_usage_count(conn);
+	atomic_set(&sess->session_close, 1);
 	iscsit_stop_session(sess, sleep, sleep);
 	iscsit_dec_session_usage_count(sess);
-	iscsit_close_session(sess);
 }
 
 static void iscsit_logout_post_handler_samecid(
@@ -4593,8 +4600,6 @@ void iscsit_stop_session(
 	int is_last;
 
 	spin_lock_bh(&sess->conn_lock);
-	if (session_sleep)
-		atomic_set(&sess->sleep_on_sess_wait_comp, 1);
 
 	if (connection_sleep) {
 		list_for_each_entry_safe(conn, conn_tmp, &sess->sess_conn_list,
@@ -4652,12 +4657,15 @@ int iscsit_release_sessions_for_tpg(struct iscsi_portal_group *tpg, int force)
 		spin_lock(&sess->conn_lock);
 		if (atomic_read(&sess->session_fall_back_to_erl0) ||
 		    atomic_read(&sess->session_logout) ||
+		    atomic_read(&sess->session_close) ||
 		    (sess->time2retain_timer_flags & ISCSI_TF_EXPIRED)) {
 			spin_unlock(&sess->conn_lock);
 			continue;
 		}
+		iscsit_inc_session_usage_count(sess);
 		atomic_set(&sess->session_reinstatement, 1);
 		atomic_set(&sess->session_fall_back_to_erl0, 1);
+		atomic_set(&sess->session_close, 1);
 		spin_unlock(&sess->conn_lock);
 
 		list_move_tail(&se_sess->sess_list, &free_list);
@@ -4667,8 +4675,9 @@ int iscsit_release_sessions_for_tpg(struct iscsi_portal_group *tpg, int force)
 	list_for_each_entry_safe(se_sess, se_sess_tmp, &free_list, sess_list) {
 		sess = (struct iscsi_session *)se_sess->fabric_sess_ptr;
 
+		list_del_init(&se_sess->sess_list);
 		iscsit_stop_session(sess, 1, 1);
-		iscsit_close_session(sess);
+		iscsit_dec_session_usage_count(sess);
 		session_count++;
 	}
 
diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/target/iscsi/iscsi_target_configfs.c
index 0ebc4818e132a..4191e4a8a9ed6 100644
--- a/drivers/target/iscsi/iscsi_target_configfs.c
+++ b/drivers/target/iscsi/iscsi_target_configfs.c
@@ -1503,20 +1503,23 @@ static void lio_tpg_close_session(struct se_session *se_sess)
 	spin_lock(&sess->conn_lock);
 	if (atomic_read(&sess->session_fall_back_to_erl0) ||
 	    atomic_read(&sess->session_logout) ||
+	    atomic_read(&sess->session_close) ||
 	    (sess->time2retain_timer_flags & ISCSI_TF_EXPIRED)) {
 		spin_unlock(&sess->conn_lock);
 		spin_unlock_bh(&se_tpg->session_lock);
 		return;
 	}
+	iscsit_inc_session_usage_count(sess);
 	atomic_set(&sess->session_reinstatement, 1);
 	atomic_set(&sess->session_fall_back_to_erl0, 1);
+	atomic_set(&sess->session_close, 1);
 	spin_unlock(&sess->conn_lock);
 
 	iscsit_stop_time2retain_timer(sess);
 	spin_unlock_bh(&se_tpg->session_lock);
 
 	iscsit_stop_session(sess, 1, 1);
-	iscsit_close_session(sess);
+	iscsit_dec_session_usage_count(sess);
 }
 
 static u32 lio_tpg_get_inst_index(struct se_portal_group *se_tpg)
diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index 27893d90c4efa..55df6f99e6691 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -199,6 +199,7 @@ int iscsi_check_for_session_reinstatement(struct iscsi_conn *conn)
 		spin_lock(&sess_p->conn_lock);
 		if (atomic_read(&sess_p->session_fall_back_to_erl0) ||
 		    atomic_read(&sess_p->session_logout) ||
+		    atomic_read(&sess_p->session_close) ||
 		    (sess_p->time2retain_timer_flags & ISCSI_TF_EXPIRED)) {
 			spin_unlock(&sess_p->conn_lock);
 			continue;
@@ -209,6 +210,7 @@ int iscsi_check_for_session_reinstatement(struct iscsi_conn *conn)
 		   (sess_p->sess_ops->SessionType == sessiontype))) {
 			atomic_set(&sess_p->session_reinstatement, 1);
 			atomic_set(&sess_p->session_fall_back_to_erl0, 1);
+			atomic_set(&sess_p->session_close, 1);
 			spin_unlock(&sess_p->conn_lock);
 			iscsit_inc_session_usage_count(sess_p);
 			iscsit_stop_time2retain_timer(sess_p);
@@ -233,7 +235,6 @@ int iscsi_check_for_session_reinstatement(struct iscsi_conn *conn)
 	if (sess->session_state == TARG_SESS_STATE_FAILED) {
 		spin_unlock_bh(&sess->conn_lock);
 		iscsit_dec_session_usage_count(sess);
-		iscsit_close_session(sess);
 		return 0;
 	}
 	spin_unlock_bh(&sess->conn_lock);
@@ -241,7 +242,6 @@ int iscsi_check_for_session_reinstatement(struct iscsi_conn *conn)
 	iscsit_stop_session(sess, 1, 1);
 	iscsit_dec_session_usage_count(sess);
 
-	iscsit_close_session(sess);
 	return 0;
 }
 
@@ -534,6 +534,7 @@ static int iscsi_login_non_zero_tsih_s2(
 		sess_p = (struct iscsi_session *)se_sess->fabric_sess_ptr;
 		if (atomic_read(&sess_p->session_fall_back_to_erl0) ||
 		    atomic_read(&sess_p->session_logout) ||
+		    atomic_read(&sess_p->session_close) ||
 		   (sess_p->time2retain_timer_flags & ISCSI_TF_EXPIRED))
 			continue;
 		if (!memcmp(sess_p->isid, pdu->isid, 6) &&
diff --git a/include/target/iscsi/iscsi_target_core.h b/include/target/iscsi/iscsi_target_core.h
index cf5f3fff1f1a7..fd7e4d1df9a15 100644
--- a/include/target/iscsi/iscsi_target_core.h
+++ b/include/target/iscsi/iscsi_target_core.h
@@ -673,7 +673,7 @@ struct iscsi_session {
 	atomic_t		session_logout;
 	atomic_t		session_reinstatement;
 	atomic_t		session_stop_active;
-	atomic_t		sleep_on_sess_wait_comp;
+	atomic_t		session_close;
 	/* connection list */
 	struct list_head	sess_conn_list;
 	struct list_head	cr_active_list;
-- 
2.20.1



