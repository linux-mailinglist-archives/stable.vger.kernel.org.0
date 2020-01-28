Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C92D14B5CC
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:01:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbgA1OAQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:00:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:45906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726697AbgA1OAP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:00:15 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 237822468E;
        Tue, 28 Jan 2020 14:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220014;
        bh=NulzUR+Bcv5HjejEXu+sWCrO4q04TYqPilWK904PGjQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gm7IpJgK3dHwaZJAIFbKTZ4jkDmxG71zt89zaN0jXCfQ6XMey9B46io3GYbtfMcS8
         /BM58Lom74Sp2cdWPdzk+txL3aqCpAsbrMtWikjc3LIK6SL6ig3xzkt7KkvSmDOzhE
         tCSrxtun4spnM35Qb/pxCZr8RE7Wj5kWogeedxTA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rahul Kundu <rahul.kundu@chelsio.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4.14 34/46] scsi: RDMA/isert: Fix a recently introduced regression related to logout
Date:   Tue, 28 Jan 2020 14:58:08 +0100
Message-Id: <20200128135754.345841923@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135749.822297911@linuxfoundation.org>
References: <20200128135749.822297911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

commit 04060db41178c7c244f2c7dcd913e7fd331de915 upstream.

iscsit_close_connection() calls isert_wait_conn(). Due to commit
e9d3009cb936 both functions call target_wait_for_sess_cmds() although that
last function should be called only once. Fix this by removing the
target_wait_for_sess_cmds() call from isert_wait_conn() and by only calling
isert_wait_conn() after target_wait_for_sess_cmds().

Fixes: e9d3009cb936 ("scsi: target: iscsi: Wait for all commands to finish before freeing a session").
Link: https://lore.kernel.org/r/20200116044737.19507-1-bvanassche@acm.org
Reported-by: Rahul Kundu <rahul.kundu@chelsio.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Tested-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Acked-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/ulp/isert/ib_isert.c |   12 ------------
 drivers/target/iscsi/iscsi_target.c     |    6 +++---
 2 files changed, 3 insertions(+), 15 deletions(-)

--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -2582,17 +2582,6 @@ isert_wait4logout(struct isert_conn *ise
 	}
 }
 
-static void
-isert_wait4cmds(struct iscsi_conn *conn)
-{
-	isert_info("iscsi_conn %p\n", conn);
-
-	if (conn->sess) {
-		target_sess_cmd_list_set_waiting(conn->sess->se_sess);
-		target_wait_for_sess_cmds(conn->sess->se_sess);
-	}
-}
-
 /**
  * isert_put_unsol_pending_cmds() - Drop commands waiting for
  *     unsolicitate dataout
@@ -2640,7 +2629,6 @@ static void isert_wait_conn(struct iscsi
 
 	ib_drain_qp(isert_conn->qp);
 	isert_put_unsol_pending_cmds(conn);
-	isert_wait4cmds(conn);
 	isert_wait4logout(isert_conn);
 
 	queue_work(isert_release_wq, &isert_conn->release_work);
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -4155,9 +4155,6 @@ int iscsit_close_connection(
 	iscsit_stop_nopin_response_timer(conn);
 	iscsit_stop_nopin_timer(conn);
 
-	if (conn->conn_transport->iscsit_wait_conn)
-		conn->conn_transport->iscsit_wait_conn(conn);
-
 	/*
 	 * During Connection recovery drop unacknowledged out of order
 	 * commands for this connection, and prepare the other commands
@@ -4243,6 +4240,9 @@ int iscsit_close_connection(
 	target_sess_cmd_list_set_waiting(sess->se_sess);
 	target_wait_for_sess_cmds(sess->se_sess);
 
+	if (conn->conn_transport->iscsit_wait_conn)
+		conn->conn_transport->iscsit_wait_conn(conn);
+
 	ahash_request_free(conn->conn_tx_hash);
 	if (conn->conn_rx_hash) {
 		struct crypto_ahash *tfm;


