Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FCBC1B0BC9
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 14:59:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728191AbgDTMmV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 08:42:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:35286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728185AbgDTMmT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Apr 2020 08:42:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 160482070B;
        Mon, 20 Apr 2020 12:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587386538;
        bh=/6Zk/WfSEcta6ObKXtkziK3NKWfi7EYrd+xW2/jWKoM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WEcTFsuwLE0zG4Urnvhp5kHYLHDy3RyZ6s/IjzG+ydgrTRe4B0XE88+lQiqQorgzu
         3fZqikUVf153E1+rtjdvYYdrMmdnu0pY4wZClWx/57BKFD2kHUGrnZFyzQspZ5n+Uz
         A5Y0UyQZCHGKR2G6iun9oL+tXu8e6L7VjMmqLVjA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rahul Kundu <rahul.kundu@chelsio.com>,
        Maurizio Lombardi <mlombard@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 63/65] scsi: target: remove boilerplate code
Date:   Mon, 20 Apr 2020 14:39:07 +0200
Message-Id: <20200420121520.027764023@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200420121505.909671922@linuxfoundation.org>
References: <20200420121505.909671922@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maurizio Lombardi <mlombard@redhat.com>

[ Upstream commit e49a7d994379278d3353d7ffc7994672752fb0ad ]

iscsit_free_session() is equivalent to iscsit_stop_session() followed by a
call to iscsit_close_session().

Link: https://lore.kernel.org/r/20200313170656.9716-2-mlombard@redhat.com
Tested-by: Rahul Kundu <rahul.kundu@chelsio.com>
Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/iscsi/iscsi_target.c | 46 ++---------------------------
 drivers/target/iscsi/iscsi_target.h |  1 -
 2 files changed, 2 insertions(+), 45 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 09e55ea0bf5d5..ff85666d4e029 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -4567,49 +4567,6 @@ void iscsit_fail_session(struct iscsi_session *sess)
 	sess->session_state = TARG_SESS_STATE_FAILED;
 }
 
-int iscsit_free_session(struct iscsi_session *sess)
-{
-	u16 conn_count = atomic_read(&sess->nconn);
-	struct iscsi_conn *conn, *conn_tmp = NULL;
-	int is_last;
-
-	spin_lock_bh(&sess->conn_lock);
-	atomic_set(&sess->sleep_on_sess_wait_comp, 1);
-
-	list_for_each_entry_safe(conn, conn_tmp, &sess->sess_conn_list,
-			conn_list) {
-		if (conn_count == 0)
-			break;
-
-		if (list_is_last(&conn->conn_list, &sess->sess_conn_list)) {
-			is_last = 1;
-		} else {
-			iscsit_inc_conn_usage_count(conn_tmp);
-			is_last = 0;
-		}
-		iscsit_inc_conn_usage_count(conn);
-
-		spin_unlock_bh(&sess->conn_lock);
-		iscsit_cause_connection_reinstatement(conn, 1);
-		spin_lock_bh(&sess->conn_lock);
-
-		iscsit_dec_conn_usage_count(conn);
-		if (is_last == 0)
-			iscsit_dec_conn_usage_count(conn_tmp);
-
-		conn_count--;
-	}
-
-	if (atomic_read(&sess->nconn)) {
-		spin_unlock_bh(&sess->conn_lock);
-		wait_for_completion(&sess->session_wait_comp);
-	} else
-		spin_unlock_bh(&sess->conn_lock);
-
-	iscsit_close_session(sess);
-	return 0;
-}
-
 void iscsit_stop_session(
 	struct iscsi_session *sess,
 	int session_sleep,
@@ -4694,7 +4651,8 @@ int iscsit_release_sessions_for_tpg(struct iscsi_portal_group *tpg, int force)
 	list_for_each_entry_safe(se_sess, se_sess_tmp, &free_list, sess_list) {
 		sess = (struct iscsi_session *)se_sess->fabric_sess_ptr;
 
-		iscsit_free_session(sess);
+		iscsit_stop_session(sess, 1, 1);
+		iscsit_close_session(sess);
 		session_count++;
 	}
 
diff --git a/drivers/target/iscsi/iscsi_target.h b/drivers/target/iscsi/iscsi_target.h
index c95f56a3ce31b..7409ce2a66078 100644
--- a/drivers/target/iscsi/iscsi_target.h
+++ b/drivers/target/iscsi/iscsi_target.h
@@ -43,7 +43,6 @@ extern int iscsi_target_rx_thread(void *);
 extern int iscsit_close_connection(struct iscsi_conn *);
 extern int iscsit_close_session(struct iscsi_session *);
 extern void iscsit_fail_session(struct iscsi_session *);
-extern int iscsit_free_session(struct iscsi_session *);
 extern void iscsit_stop_session(struct iscsi_session *, int, int);
 extern int iscsit_release_sessions_for_tpg(struct iscsi_portal_group *, int);
 
-- 
2.20.1



