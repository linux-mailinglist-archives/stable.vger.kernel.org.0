Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2D40171D7D
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:21:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389426AbgB0ORd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:17:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:57938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389705AbgB0ORd (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:17:33 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF1432468F;
        Thu, 27 Feb 2020 14:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582813052;
        bh=A443DwTZMDXtOZiw5vuBoAGw7sigyCpjJWp2qxO9wvk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tSSDJgqtK4t7AG/oA+qIxh5SV97yjqZfLD5UXmLXNwB/yB0WuDBWdDpRya+FYpzPI
         E9SpV8l4/amNTC2LbvVSmlKHHTPV3uUDcJsDwEkCakKqAT1GGfgxXg1Bli5lomJ7fD
         b1++OIgWB/aU6ZOrVhaywqd8dv6l8f+HB7I5e8HU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rahul Kundu <rahul.kundu@chelsio.com>,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Dakshaja Uppalapati <dakshaja@chelsio.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.5 119/150] scsi: Revert "RDMA/isert: Fix a recently introduced regression related to logout"
Date:   Thu, 27 Feb 2020 14:37:36 +0100
Message-Id: <20200227132250.230001659@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132232.815448360@linuxfoundation.org>
References: <20200227132232.815448360@linuxfoundation.org>
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
@@ -2575,6 +2575,17 @@ isert_wait4logout(struct isert_conn *ise
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
@@ -2622,6 +2633,7 @@ static void isert_wait_conn(struct iscsi
 
 	ib_drain_qp(isert_conn->qp);
 	isert_put_unsol_pending_cmds(conn);
+	isert_wait4cmds(conn);
 	isert_wait4logout(isert_conn);
 
 	queue_work(isert_release_wq, &isert_conn->release_work);
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -4149,6 +4149,9 @@ int iscsit_close_connection(
 	iscsit_stop_nopin_response_timer(conn);
 	iscsit_stop_nopin_timer(conn);
 
+	if (conn->conn_transport->iscsit_wait_conn)
+		conn->conn_transport->iscsit_wait_conn(conn);
+
 	/*
 	 * During Connection recovery drop unacknowledged out of order
 	 * commands for this connection, and prepare the other commands
@@ -4234,9 +4237,6 @@ int iscsit_close_connection(
 	target_sess_cmd_list_set_waiting(sess->se_sess);
 	target_wait_for_sess_cmds(sess->se_sess);
 
-	if (conn->conn_transport->iscsit_wait_conn)
-		conn->conn_transport->iscsit_wait_conn(conn);
-
 	ahash_request_free(conn->conn_tx_hash);
 	if (conn->conn_rx_hash) {
 		struct crypto_ahash *tfm;


