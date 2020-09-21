Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38D13272C70
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:32:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728444AbgIUQcV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:32:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:57340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728246AbgIUQcG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:32:06 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C10EA23998;
        Mon, 21 Sep 2020 16:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600705925;
        bh=c5rXe6L+Uv7p3TCLj0B2Tm3NmbfuKM53pvoUknxnlVI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gOzj0+xuTXcwtA4O8cbSogxtfZPfXl6YlbnGG1ayl5pe3OddemNSbcnhkbe178iRc
         ywxj8OFLNZYHAHt0OkwVzeJUbDdU+UJNFkj29xs0pAdK+jMHpN4leEux9yiDMizhV+
         8G42xUbXIhlytObTzVTGDAgTe4kzBWlbwmIPca6M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mike Christie <michael.christie@oracle.com>,
        Hou Pu <houpu@bytedance.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4.4 18/46] scsi: target: iscsi: Fix hang in iscsit_access_np() when getting tpg->np_login_sem
Date:   Mon, 21 Sep 2020 18:27:34 +0200
Message-Id: <20200921162034.165342926@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162033.346434578@linuxfoundation.org>
References: <20200921162033.346434578@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hou Pu <houpu@bytedance.com>

commit ed43ffea78dcc97db3f561da834f1a49c8961e33 upstream.

The iSCSI target login thread might get stuck with the following stack:

cat /proc/`pidof iscsi_np`/stack
[<0>] down_interruptible+0x42/0x50
[<0>] iscsit_access_np+0xe3/0x167
[<0>] iscsi_target_locate_portal+0x695/0x8ac
[<0>] __iscsi_target_login_thread+0x855/0xb82
[<0>] iscsi_target_login_thread+0x2f/0x5a
[<0>] kthread+0xfa/0x130
[<0>] ret_from_fork+0x1f/0x30

This can be reproduced via the following steps:

1. Initiator A tries to log in to iqn1-tpg1 on port 3260. After finishing
   PDU exchange in the login thread and before the negotiation is finished
   the the network link goes down. At this point A has not finished login
   and tpg->np_login_sem is held.

2. Initiator B tries to log in to iqn2-tpg1 on port 3260. After finishing
   PDU exchange in the login thread the target expects to process remaining
   login PDUs in workqueue context.

3. Initiator A' tries to log in to iqn1-tpg1 on port 3260 from a new
   socket. A' will wait for tpg->np_login_sem with np->np_login_timer
   loaded to wait for at most 15 seconds. The lock is held by A so A'
   eventually times out.

4. Before A' got timeout initiator B gets negotiation failed and calls
   iscsi_target_login_drop()->iscsi_target_login_sess_out().  The
   np->np_login_timer is canceled and initiator A' will hang forever.
   Because A' is now in the login thread, no new login requests can be
   serviced.

Fix this by moving iscsi_stop_login_thread_timer() out of
iscsi_target_login_sess_out(). Also remove iscsi_np parameter from
iscsi_target_login_sess_out().

Link: https://lore.kernel.org/r/20200729130343.24976-1-houpu@bytedance.com
Cc: stable@vger.kernel.org
Reviewed-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Hou Pu <houpu@bytedance.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/iscsi/iscsi_target_login.c |    6 +++---
 drivers/target/iscsi/iscsi_target_login.h |    3 +--
 drivers/target/iscsi/iscsi_target_nego.c  |    3 +--
 3 files changed, 5 insertions(+), 7 deletions(-)

--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -1139,7 +1139,7 @@ iscsit_conn_set_transport(struct iscsi_c
 }
 
 void iscsi_target_login_sess_out(struct iscsi_conn *conn,
-		struct iscsi_np *np, bool zero_tsih, bool new_sess)
+				 bool zero_tsih, bool new_sess)
 {
 	if (!new_sess)
 		goto old_sess_out;
@@ -1161,7 +1161,6 @@ void iscsi_target_login_sess_out(struct
 	conn->sess = NULL;
 
 old_sess_out:
-	iscsi_stop_login_thread_timer(np);
 	/*
 	 * If login negotiation fails check if the Time2Retain timer
 	 * needs to be restarted.
@@ -1407,8 +1406,9 @@ static int __iscsi_target_login_thread(s
 new_sess_out:
 	new_sess = true;
 old_sess_out:
+	iscsi_stop_login_thread_timer(np);
 	tpg_np = conn->tpg_np;
-	iscsi_target_login_sess_out(conn, np, zero_tsih, new_sess);
+	iscsi_target_login_sess_out(conn, zero_tsih, new_sess);
 	new_sess = false;
 
 	if (tpg) {
--- a/drivers/target/iscsi/iscsi_target_login.h
+++ b/drivers/target/iscsi/iscsi_target_login.h
@@ -14,8 +14,7 @@ extern int iscsit_put_login_tx(struct is
 extern void iscsit_free_conn(struct iscsi_np *, struct iscsi_conn *);
 extern int iscsit_start_kthreads(struct iscsi_conn *);
 extern void iscsi_post_login_handler(struct iscsi_np *, struct iscsi_conn *, u8);
-extern void iscsi_target_login_sess_out(struct iscsi_conn *, struct iscsi_np *,
-				bool, bool);
+extern void iscsi_target_login_sess_out(struct iscsi_conn *, bool, bool);
 extern int iscsi_target_login_thread(void *);
 
 #endif   /*** ISCSI_TARGET_LOGIN_H ***/
--- a/drivers/target/iscsi/iscsi_target_nego.c
+++ b/drivers/target/iscsi/iscsi_target_nego.c
@@ -547,12 +547,11 @@ static bool iscsi_target_sk_check_and_cl
 
 static void iscsi_target_login_drop(struct iscsi_conn *conn, struct iscsi_login *login)
 {
-	struct iscsi_np *np = login->np;
 	bool zero_tsih = login->zero_tsih;
 
 	iscsi_remove_failed_auth_entry(conn);
 	iscsi_target_nego_release(conn);
-	iscsi_target_login_sess_out(conn, np, zero_tsih, true);
+	iscsi_target_login_sess_out(conn, zero_tsih, true);
 }
 
 static void iscsi_target_login_timeout(unsigned long data)


