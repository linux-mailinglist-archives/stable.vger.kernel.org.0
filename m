Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63C821B3D3A
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:13:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728925AbgDVKNM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:13:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:46846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729437AbgDVKNL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:13:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A29D120775;
        Wed, 22 Apr 2020 10:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550391;
        bh=n29kx90A4hA+tHkl8HeAC3woTJ6vGmPTmAgitgOvX3E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WdUBdf4ITrxd/yscT9skUFMYWx5Eev3CfMtuPeSEPYuWrrwDIm0yXQp6fPSezsY21
         oLWUUp0YQC9yyrsmmCMfnowShFgLkDFSOIRlFNmfyCovcDEmoYfXHNIkhm9Uk99XJk
         4SpZUIwcZJTcXPLF4Fme35tLdtAV2DDNhj7rigd8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rahul Kundu <rahul.kundu@chelsio.com>,
        Maurizio Lombardi <mlombard@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 127/199] scsi: target: remove boilerplate code
Date:   Wed, 22 Apr 2020 11:57:33 +0200
Message-Id: <20200422095110.254553200@linuxfoundation.org>
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
index fb7bd422e2e1f..40993c575017f 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -4583,49 +4583,6 @@ void iscsit_fail_session(struct iscsi_session *sess)
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
@@ -4710,7 +4667,8 @@ int iscsit_release_sessions_for_tpg(struct iscsi_portal_group *tpg, int force)
 	list_for_each_entry_safe(se_sess, se_sess_tmp, &free_list, sess_list) {
 		sess = (struct iscsi_session *)se_sess->fabric_sess_ptr;
 
-		iscsit_free_session(sess);
+		iscsit_stop_session(sess, 1, 1);
+		iscsit_close_session(sess);
 		session_count++;
 	}
 
diff --git a/drivers/target/iscsi/iscsi_target.h b/drivers/target/iscsi/iscsi_target.h
index 42de1843aa40d..f0d2cbf594c92 100644
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



