Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E33031B41D1
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:57:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728333AbgDVKGT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:06:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:58136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726995AbgDVKGS (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:06:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 54F2C20575;
        Wed, 22 Apr 2020 10:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587549976;
        bh=O8PFb9+YEDcA9NDzZqEKCt+2+vy6aURxzDeWzHgZniA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hfvUCtWhyOwl5sEjZDbPZ3D+axdEp86zlYBuqEBx4J+YLBdyVWDhwwbxj0G61biEC
         drz0/RVbO1XFfM3P0cQMy6TQrqBrNTuJbd2526iopgBDT5l6oF8qQyovFUr8oODCnM
         puE4/R0JRWYVeyc9sfUCW4MDwI4pGWPTm4VuzAwA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matt Coleman <mcoleman@datto.com>,
        Rahul Kundu <rahul.kundu@chelsio.com>,
        Maurizio Lombardi <mlombard@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 083/125] scsi: target: fix hang when multiple threads try to destroy the same iscsi session
Date:   Wed, 22 Apr 2020 11:56:40 +0200
Message-Id: <20200422095046.483650649@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095032.909124119@linuxfoundation.org>
References: <20200422095032.909124119@linuxfoundation.org>
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
 drivers/target/iscsi/iscsi_target.c          |   35 ++++++++++++++++-----------
 drivers/target/iscsi/iscsi_target_configfs.c |    5 +++
 drivers/target/iscsi/iscsi_target_login.c    |    5 ++-
 include/target/iscsi/iscsi_target_core.h     |    2 -
 4 files changed, 30 insertions(+), 17 deletions(-)

--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -4321,30 +4321,37 @@ int iscsit_close_connection(
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
@@ -4453,9 +4460,9 @@ static void iscsit_logout_post_handler_c
 	complete(&conn->conn_logout_comp);
 
 	iscsit_dec_conn_usage_count(conn);
+	atomic_set(&sess->session_close, 1);
 	iscsit_stop_session(sess, sleep, sleep);
 	iscsit_dec_session_usage_count(sess);
-	iscsit_close_session(sess);
 }
 
 static void iscsit_logout_post_handler_samecid(
@@ -4600,8 +4607,6 @@ void iscsit_stop_session(
 	int is_last;
 
 	spin_lock_bh(&sess->conn_lock);
-	if (session_sleep)
-		atomic_set(&sess->sleep_on_sess_wait_comp, 1);
 
 	if (connection_sleep) {
 		list_for_each_entry_safe(conn, conn_tmp, &sess->sess_conn_list,
@@ -4659,12 +4664,15 @@ int iscsit_release_sessions_for_tpg(stru
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
@@ -4674,8 +4682,9 @@ int iscsit_release_sessions_for_tpg(stru
 	list_for_each_entry_safe(se_sess, se_sess_tmp, &free_list, sess_list) {
 		sess = (struct iscsi_session *)se_sess->fabric_sess_ptr;
 
+		list_del_init(&se_sess->sess_list);
 		iscsit_stop_session(sess, 1, 1);
-		iscsit_close_session(sess);
+		iscsit_dec_session_usage_count(sess);
 		session_count++;
 	}
 
--- a/drivers/target/iscsi/iscsi_target_configfs.c
+++ b/drivers/target/iscsi/iscsi_target_configfs.c
@@ -1527,20 +1527,23 @@ static void lio_tpg_close_session(struct
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
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -195,6 +195,7 @@ int iscsi_check_for_session_reinstatemen
 		spin_lock(&sess_p->conn_lock);
 		if (atomic_read(&sess_p->session_fall_back_to_erl0) ||
 		    atomic_read(&sess_p->session_logout) ||
+		    atomic_read(&sess_p->session_close) ||
 		    (sess_p->time2retain_timer_flags & ISCSI_TF_EXPIRED)) {
 			spin_unlock(&sess_p->conn_lock);
 			continue;
@@ -205,6 +206,7 @@ int iscsi_check_for_session_reinstatemen
 		   (sess_p->sess_ops->SessionType == sessiontype))) {
 			atomic_set(&sess_p->session_reinstatement, 1);
 			atomic_set(&sess_p->session_fall_back_to_erl0, 1);
+			atomic_set(&sess_p->session_close, 1);
 			spin_unlock(&sess_p->conn_lock);
 			iscsit_inc_session_usage_count(sess_p);
 			iscsit_stop_time2retain_timer(sess_p);
@@ -229,7 +231,6 @@ int iscsi_check_for_session_reinstatemen
 	if (sess->session_state == TARG_SESS_STATE_FAILED) {
 		spin_unlock_bh(&sess->conn_lock);
 		iscsit_dec_session_usage_count(sess);
-		iscsit_close_session(sess);
 		return 0;
 	}
 	spin_unlock_bh(&sess->conn_lock);
@@ -237,7 +238,6 @@ int iscsi_check_for_session_reinstatemen
 	iscsit_stop_session(sess, 1, 1);
 	iscsit_dec_session_usage_count(sess);
 
-	iscsit_close_session(sess);
 	return 0;
 }
 
@@ -525,6 +525,7 @@ static int iscsi_login_non_zero_tsih_s2(
 		sess_p = (struct iscsi_session *)se_sess->fabric_sess_ptr;
 		if (atomic_read(&sess_p->session_fall_back_to_erl0) ||
 		    atomic_read(&sess_p->session_logout) ||
+		    atomic_read(&sess_p->session_close) ||
 		   (sess_p->time2retain_timer_flags & ISCSI_TF_EXPIRED))
 			continue;
 		if (!memcmp(sess_p->isid, pdu->isid, 6) &&
--- a/include/target/iscsi/iscsi_target_core.h
+++ b/include/target/iscsi/iscsi_target_core.h
@@ -671,7 +671,7 @@ struct iscsi_session {
 	atomic_t		session_logout;
 	atomic_t		session_reinstatement;
 	atomic_t		session_stop_active;
-	atomic_t		sleep_on_sess_wait_comp;
+	atomic_t		session_close;
 	/* connection list */
 	struct list_head	sess_conn_list;
 	struct list_head	cr_active_list;


