Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53265171F1D
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:32:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732975AbgB0OBt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:01:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:36056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732994AbgB0OBt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:01:49 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C8D6F20801;
        Thu, 27 Feb 2020 14:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582812108;
        bh=0C0pTTKbZx4Ck1f1jcDyhaaeDVBADdCEi8tIy34GJh4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D0T+iTL1Bi4FqQr4O5icytLsweFq6GfOd4p1YpFDjsCC3hTsMJNGwLa+4reYp/x7E
         ocNpYOk6rf8vANnXlsIGYLQWAjp0mj4g41KQF9qe7cgqfCsKXoS/mRAVvlQywp5V4x
         d+MFklPLMSFWI8XRUOMjiNu4nR4dzB50AmrmLFm4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rahul Kundu <rahul.kundu@chelsio.com>,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Dakshaja Uppalapati <dakshaja@chelsio.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4.14 224/237] scsi: Revert "target: iscsi: Wait for all commands to finish before freeing a session"
Date:   Thu, 27 Feb 2020 14:37:18 +0100
Message-Id: <20200227132312.620607932@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132255.285644406@linuxfoundation.org>
References: <20200227132255.285644406@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

commit 807b9515b7d044cf77df31f1af9d842a76ecd5cb upstream.

Since commit e9d3009cb936 introduced a regression and since the fix for
that regression was not perfect, revert this commit.

Link: https://marc.info/?l=target-devel&m=158157054906195
Cc: Rahul Kundu <rahul.kundu@chelsio.com>
Cc: Mike Marciniszyn <mike.marciniszyn@intel.com>
Cc: Sagi Grimberg <sagi@grimberg.me>
Reported-by: Dakshaja Uppalapati <dakshaja@chelsio.com>
Fixes: e9d3009cb936 ("scsi: target: iscsi: Wait for all commands to finish before freeing a session")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/iscsi/iscsi_target.c |   10 ++--------
 include/scsi/iscsi_proto.h          |    1 -
 2 files changed, 2 insertions(+), 9 deletions(-)

--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -1158,9 +1158,7 @@ int iscsit_setup_scsi_cmd(struct iscsi_c
 		hdr->cmdsn, be32_to_cpu(hdr->data_length), payload_length,
 		conn->cid);
 
-	if (target_get_sess_cmd(&cmd->se_cmd, true) < 0)
-		return iscsit_add_reject_cmd(cmd,
-				ISCSI_REASON_WAITING_FOR_LOGOUT, buf);
+	target_get_sess_cmd(&cmd->se_cmd, true);
 
 	cmd->sense_reason = transport_lookup_cmd_lun(&cmd->se_cmd,
 						     scsilun_to_int(&hdr->lun));
@@ -2006,9 +2004,7 @@ iscsit_handle_task_mgt_cmd(struct iscsi_
 			      conn->sess->se_sess, 0, DMA_NONE,
 			      TCM_SIMPLE_TAG, cmd->sense_buffer + 2);
 
-	if (target_get_sess_cmd(&cmd->se_cmd, true) < 0)
-		return iscsit_add_reject_cmd(cmd,
-				ISCSI_REASON_WAITING_FOR_LOGOUT, buf);
+	target_get_sess_cmd(&cmd->se_cmd, true);
 
 	/*
 	 * TASK_REASSIGN for ERL=2 / connection stays inside of
@@ -4240,8 +4236,6 @@ int iscsit_close_connection(
 	 * must wait until they have completed.
 	 */
 	iscsit_check_conn_usage_count(conn);
-	target_sess_cmd_list_set_waiting(sess->se_sess);
-	target_wait_for_sess_cmds(sess->se_sess);
 
 	ahash_request_free(conn->conn_tx_hash);
 	if (conn->conn_rx_hash) {
--- a/include/scsi/iscsi_proto.h
+++ b/include/scsi/iscsi_proto.h
@@ -638,7 +638,6 @@ struct iscsi_reject {
 #define ISCSI_REASON_BOOKMARK_INVALID	9
 #define ISCSI_REASON_BOOKMARK_NO_RESOURCES	10
 #define ISCSI_REASON_NEGOTIATION_RESET	11
-#define ISCSI_REASON_WAITING_FOR_LOGOUT	12
 
 /* Max. number of Key=Value pairs in a text message */
 #define MAX_KEY_VALUE_PAIRS	8192


