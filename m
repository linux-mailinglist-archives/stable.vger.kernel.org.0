Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D96F507859
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 20:26:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356820AbiDSSUf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Apr 2022 14:20:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356621AbiDSSTm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Apr 2022 14:19:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1827B3FBD4;
        Tue, 19 Apr 2022 11:13:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B59C6B81982;
        Tue, 19 Apr 2022 18:13:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28534C385AD;
        Tue, 19 Apr 2022 18:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650392022;
        bh=CbTfT1XzeXL3nlleuSn+43H8lHVRa+ZsvFPNosQYhUA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PV8SJYrp3DVpFSL4oK9Y+6N+GWEKmPqXo4c70/SHJLK+qZRnKtawKDdC7yEa0h3FM
         NEt+aKnUx67xM8XoMu3VwAW50AKAqtlSb5vnQJYP5dKnhst3YsKy2Q6tbYIiK/iXuX
         CSzplmvotMx1/WAHT3+vakCPCCmSoWpr3a7x0echMg7OmKgjZ9Lodkv5s1LwnYt+qz
         o6G9b3Cots5VKKEeiyxIh44vYQCGWIr8+EZrDFqp8PC9b4A+jqKRI02aQ8rxtvJ8Qn
         KijWD8YbVEbxm8AFblY/rDgup9CpyuRXfTYWPSpPCvGrtJauBFyrJDCdspLqEpK8Pt
         5hVlqUZ8p3OUA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, njavali@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 22/27] scsi: qedi: Fix failed disconnect handling
Date:   Tue, 19 Apr 2022 14:12:37 -0400
Message-Id: <20220419181242.485308-22-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220419181242.485308-1-sashal@kernel.org>
References: <20220419181242.485308-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Christie <michael.christie@oracle.com>

[ Upstream commit 857b06527f707f5df634b854898a191b5c1d0272 ]

We set the qedi_ep state to EP_STATE_OFLDCONN_START when the ep is
created. Then in qedi_set_path we kick off the offload work. If userspace
times out the connection and calls ep_disconnect, qedi will only flush the
offload work if the qedi_ep state has transitioned away from
EP_STATE_OFLDCONN_START. If we can't connect we will not have transitioned
state and will leave the offload work running, and we will free the qedi_ep
from under it.

This patch just has us init the work when we create the ep, then always
flush it.

Link: https://lore.kernel.org/r/20220408001314.5014-10-michael.christie@oracle.com
Tested-by: Manish Rangankar <mrangankar@marvell.com>
Reviewed-by: Lee Duncan <lduncan@suse.com>
Reviewed-by: Chris Leech <cleech@redhat.com>
Acked-by: Manish Rangankar <mrangankar@marvell.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qedi/qedi_iscsi.c | 69 +++++++++++++++++-----------------
 1 file changed, 34 insertions(+), 35 deletions(-)

diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscsi.c
index c5260429c637..04b40a6c1aff 100644
--- a/drivers/scsi/qedi/qedi_iscsi.c
+++ b/drivers/scsi/qedi/qedi_iscsi.c
@@ -859,6 +859,37 @@ static int qedi_task_xmit(struct iscsi_task *task)
 	return qedi_iscsi_send_ioreq(task);
 }
 
+static void qedi_offload_work(struct work_struct *work)
+{
+	struct qedi_endpoint *qedi_ep =
+		container_of(work, struct qedi_endpoint, offload_work);
+	struct qedi_ctx *qedi;
+	int wait_delay = 5 * HZ;
+	int ret;
+
+	qedi = qedi_ep->qedi;
+
+	ret = qedi_iscsi_offload_conn(qedi_ep);
+	if (ret) {
+		QEDI_ERR(&qedi->dbg_ctx,
+			 "offload error: iscsi_cid=%u, qedi_ep=%p, ret=%d\n",
+			 qedi_ep->iscsi_cid, qedi_ep, ret);
+		qedi_ep->state = EP_STATE_OFLDCONN_FAILED;
+		return;
+	}
+
+	ret = wait_event_interruptible_timeout(qedi_ep->tcp_ofld_wait,
+					       (qedi_ep->state ==
+					       EP_STATE_OFLDCONN_COMPL),
+					       wait_delay);
+	if (ret <= 0 || qedi_ep->state != EP_STATE_OFLDCONN_COMPL) {
+		qedi_ep->state = EP_STATE_OFLDCONN_FAILED;
+		QEDI_ERR(&qedi->dbg_ctx,
+			 "Offload conn TIMEOUT iscsi_cid=%u, qedi_ep=%p\n",
+			 qedi_ep->iscsi_cid, qedi_ep);
+	}
+}
+
 static struct iscsi_endpoint *
 qedi_ep_connect(struct Scsi_Host *shost, struct sockaddr *dst_addr,
 		int non_blocking)
@@ -907,6 +938,7 @@ qedi_ep_connect(struct Scsi_Host *shost, struct sockaddr *dst_addr,
 	}
 	qedi_ep = ep->dd_data;
 	memset(qedi_ep, 0, sizeof(struct qedi_endpoint));
+	INIT_WORK(&qedi_ep->offload_work, qedi_offload_work);
 	qedi_ep->state = EP_STATE_IDLE;
 	qedi_ep->iscsi_cid = (u32)-1;
 	qedi_ep->qedi = qedi;
@@ -1055,12 +1087,11 @@ static void qedi_ep_disconnect(struct iscsi_endpoint *ep)
 	qedi_ep = ep->dd_data;
 	qedi = qedi_ep->qedi;
 
+	flush_work(&qedi_ep->offload_work);
+
 	if (qedi_ep->state == EP_STATE_OFLDCONN_START)
 		goto ep_exit_recover;
 
-	if (qedi_ep->state != EP_STATE_OFLDCONN_NONE)
-		flush_work(&qedi_ep->offload_work);
-
 	if (qedi_ep->conn) {
 		qedi_conn = qedi_ep->conn;
 		abrt_conn = qedi_conn->abrt_conn;
@@ -1234,37 +1265,6 @@ static int qedi_data_avail(struct qedi_ctx *qedi, u16 vlanid)
 	return rc;
 }
 
-static void qedi_offload_work(struct work_struct *work)
-{
-	struct qedi_endpoint *qedi_ep =
-		container_of(work, struct qedi_endpoint, offload_work);
-	struct qedi_ctx *qedi;
-	int wait_delay = 5 * HZ;
-	int ret;
-
-	qedi = qedi_ep->qedi;
-
-	ret = qedi_iscsi_offload_conn(qedi_ep);
-	if (ret) {
-		QEDI_ERR(&qedi->dbg_ctx,
-			 "offload error: iscsi_cid=%u, qedi_ep=%p, ret=%d\n",
-			 qedi_ep->iscsi_cid, qedi_ep, ret);
-		qedi_ep->state = EP_STATE_OFLDCONN_FAILED;
-		return;
-	}
-
-	ret = wait_event_interruptible_timeout(qedi_ep->tcp_ofld_wait,
-					       (qedi_ep->state ==
-					       EP_STATE_OFLDCONN_COMPL),
-					       wait_delay);
-	if ((ret <= 0) || (qedi_ep->state != EP_STATE_OFLDCONN_COMPL)) {
-		qedi_ep->state = EP_STATE_OFLDCONN_FAILED;
-		QEDI_ERR(&qedi->dbg_ctx,
-			 "Offload conn TIMEOUT iscsi_cid=%u, qedi_ep=%p\n",
-			 qedi_ep->iscsi_cid, qedi_ep);
-	}
-}
-
 static int qedi_set_path(struct Scsi_Host *shost, struct iscsi_path *path_data)
 {
 	struct qedi_ctx *qedi;
@@ -1380,7 +1380,6 @@ static int qedi_set_path(struct Scsi_Host *shost, struct iscsi_path *path_data)
 			  qedi_ep->dst_addr, qedi_ep->dst_port);
 	}
 
-	INIT_WORK(&qedi_ep->offload_work, qedi_offload_work);
 	queue_work(qedi->offload_thread, &qedi_ep->offload_work);
 
 	ret = 0;
-- 
2.35.1

