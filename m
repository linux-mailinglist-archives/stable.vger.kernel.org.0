Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B813426B425
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 01:17:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727401AbgIOXRs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 19:17:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:48808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727241AbgIOOj2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:39:28 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A9BF223D21;
        Tue, 15 Sep 2020 14:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600180185;
        bh=ggdIUu1Skz3CMeK0rk6aLgCtDbP1FVURnXX1XV/ZnAQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TMCa7h+CwJW3GZLOWS8WUwViRjbL0lHIB2rwySiTo7GCtmsUDN8KNuPOMkfwwAYqf
         8JnG/jUQHajCLpT/6PsNt9pDHl4M1uDniKhsQBncW9RrbJJ8Vf4Toplx6p+tcAB8F3
         KiVBHO5Z767gDoGnss68ewpy9X3AFxrIne8npi4E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mike Christie <michael.christie@oracle.com>,
        Hou Pu <houpu@bytedance.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.8 141/177] scsi: target: iscsi: Fix hang in iscsit_access_np() when getting tpg->np_login_sem
Date:   Tue, 15 Sep 2020 16:13:32 +0200
Message-Id: <20200915140700.415531702@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140653.610388773@linuxfoundation.org>
References: <20200915140653.610388773@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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
@@ -1149,7 +1149,7 @@ void iscsit_free_conn(struct iscsi_conn
 }
 
 void iscsi_target_login_sess_out(struct iscsi_conn *conn,
-		struct iscsi_np *np, bool zero_tsih, bool new_sess)
+				 bool zero_tsih, bool new_sess)
 {
 	if (!new_sess)
 		goto old_sess_out;
@@ -1167,7 +1167,6 @@ void iscsi_target_login_sess_out(struct
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
@@ -22,8 +22,7 @@ extern int iscsit_put_login_tx(struct is
 extern void iscsit_free_conn(struct iscsi_conn *);
 extern int iscsit_start_kthreads(struct iscsi_conn *);
 extern void iscsi_post_login_handler(struct iscsi_np *, struct iscsi_conn *, u8);
-extern void iscsi_target_login_sess_out(struct iscsi_conn *, struct iscsi_np *,
-				bool, bool);
+extern void iscsi_target_login_sess_out(struct iscsi_conn *, bool, bool);
 extern int iscsi_target_login_thread(void *);
 extern void iscsi_handle_login_thread_timeout(struct timer_list *t);
 
--- a/drivers/target/iscsi/iscsi_target_nego.c
+++ b/drivers/target/iscsi/iscsi_target_nego.c
@@ -535,12 +535,11 @@ static bool iscsi_target_sk_check_and_cl
 
 static void iscsi_target_login_drop(struct iscsi_conn *conn, struct iscsi_login *login)
 {
-	struct iscsi_np *np = login->np;
 	bool zero_tsih = login->zero_tsih;
 
 	iscsi_remove_failed_auth_entry(conn);
 	iscsi_target_nego_release(conn);
-	iscsi_target_login_sess_out(conn, np, zero_tsih, true);
+	iscsi_target_login_sess_out(conn, zero_tsih, true);
 }
 
 struct conn_timeout {


