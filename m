Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63A86171A30
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 14:51:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731162AbgB0Nvg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 08:51:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:50768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731409AbgB0Nvf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 08:51:35 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A16A24656;
        Thu, 27 Feb 2020 13:51:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582811494;
        bh=6M4aIEWU6U6B/YmKFklZqlHWhah71sTfS9qFha5y9HY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U/+79RZQVOeqV4xWh9Ap5qF+dTRmW0jJ2v4/B5VTY+pyhu9qPLa3IV07/kLVp7pCl
         lKtCeMLRHd5sgNU+h2EA5BjLIpSOp0c3L2niAngJRO8y+Pknb1QAaGh6TiTVasnD7N
         lQNyvqN9CveyM8YocaQBQjlu08yb0JfvqRIjP2QM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rahul Kundu <rahul.kundu@chelsio.com>,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Dakshaja Uppalapati <dakshaja@chelsio.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4.9 154/165] scsi: Revert "RDMA/isert: Fix a recently introduced regression related to logout"
Date:   Thu, 27 Feb 2020 14:37:08 +0100
Message-Id: <20200227132253.184446972@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132230.840899170@linuxfoundation.org>
References: <20200227132230.840899170@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

commit 76261ada16dcc3be610396a46d35acc3efbda682 upstream.

Since commit 04060db41178 introduces soft lockups when toggling network
interfaces, revert it.

Link: https://marc.info/?l=target-devel&m=158157054906196
Cc: Rahul Kundu <rahul.kundu@chelsio.com>
Cc: Mike Marciniszyn <mike.marciniszyn@intel.com>
Cc: Sagi Grimberg <sagi@grimberg.me>
Reported-by: Dakshaja Uppalapati <dakshaja@chelsio.com>
Fixes: 04060db41178 ("scsi: RDMA/isert: Fix a recently introduced regression related to logout")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/ulp/isert/ib_isert.c |   12 ++++++++++++
 drivers/target/iscsi/iscsi_target.c     |    6 +++---
 2 files changed, 15 insertions(+), 3 deletions(-)

--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -2555,6 +2555,17 @@ isert_wait4logout(struct isert_conn *ise
 	}
 }
 
+static void
+isert_wait4cmds(struct iscsi_conn *conn)
+{
+	isert_info("iscsi_conn %p\n", conn);
+
+	if (conn->sess) {
+		target_sess_cmd_list_set_waiting(conn->sess->se_sess);
+		target_wait_for_sess_cmds(conn->sess->se_sess);
+	}
+}
+
 /**
  * isert_put_unsol_pending_cmds() - Drop commands waiting for
  *     unsolicitate dataout
@@ -2602,6 +2613,7 @@ static void isert_wait_conn(struct iscsi
 
 	ib_drain_qp(isert_conn->qp);
 	isert_put_unsol_pending_cmds(conn);
+	isert_wait4cmds(conn);
 	isert_wait4logout(isert_conn);
 
 	queue_work(isert_release_wq, &isert_conn->release_work);
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -4162,6 +4162,9 @@ int iscsit_close_connection(
 	iscsit_stop_nopin_response_timer(conn);
 	iscsit_stop_nopin_timer(conn);
 
+	if (conn->conn_transport->iscsit_wait_conn)
+		conn->conn_transport->iscsit_wait_conn(conn);
+
 	/*
 	 * During Connection recovery drop unacknowledged out of order
 	 * commands for this connection, and prepare the other commands
@@ -4247,9 +4250,6 @@ int iscsit_close_connection(
 	target_sess_cmd_list_set_waiting(sess->se_sess);
 	target_wait_for_sess_cmds(sess->se_sess);
 
-	if (conn->conn_transport->iscsit_wait_conn)
-		conn->conn_transport->iscsit_wait_conn(conn);
-
 	ahash_request_free(conn->conn_tx_hash);
 	if (conn->conn_rx_hash) {
 		struct crypto_ahash *tfm;


