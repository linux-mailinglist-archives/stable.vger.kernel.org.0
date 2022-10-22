Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D8D3608A66
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:53:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234894AbiJVIxE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:53:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234998AbiJVIwa (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:52:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAF542F1429;
        Sat, 22 Oct 2022 01:12:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4F7EFB82E1C;
        Sat, 22 Oct 2022 07:56:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F207C433D6;
        Sat, 22 Oct 2022 07:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666425402;
        bh=FimAQjt8rxHycJrSJpJ2hpiNp5LRScxtbelMosB/6Po=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UsPkMC/gd2gH2lyUHrTE3EFF++mLGl0rIes3mPqkPEwCtp277QO63javXiSJgFZtB
         04Pqu8CMt7uMP0yLt1yAae4giHJBTbq64+PxKCU9YvNUtnBQnjOfeU9IlEb9y1Gx1D
         gXRvYRCuXc0Qwsfa0tiXd4DHwZhPm8K28GbD2yVc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lee Duncan <lduncan@suse.com>,
        Mike Christie <michael.christie@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 459/717] scsi: iscsi: Add recv workqueue helpers
Date:   Sat, 22 Oct 2022 09:25:38 +0200
Message-Id: <20221022072518.601109896@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Christie <michael.christie@oracle.com>

[ Upstream commit 8af809966c0b34cfacd8da9a412689b8e9910354 ]

Add helpers to allow the drivers to run their recv paths from libiscsi's
workqueue.

Link: https://lore.kernel.org/r/20220616224557.115234-3-michael.christie@oracle.com
Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: 57569c37f0ad ("scsi: iscsi: iscsi_tcp: Fix null-ptr-deref while calling getpeername()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/libiscsi.c | 29 +++++++++++++++++++++++++++--
 include/scsi/libiscsi.h |  4 ++++
 2 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 1bd772d9b804..8f73c8d6ef22 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -93,6 +93,16 @@ inline void iscsi_conn_queue_xmit(struct iscsi_conn *conn)
 }
 EXPORT_SYMBOL_GPL(iscsi_conn_queue_xmit);
 
+inline void iscsi_conn_queue_recv(struct iscsi_conn *conn)
+{
+	struct Scsi_Host *shost = conn->session->host;
+	struct iscsi_host *ihost = shost_priv(shost);
+
+	if (ihost->workq && !test_bit(ISCSI_CONN_FLAG_SUSPEND_RX, &conn->flags))
+		queue_work(ihost->workq, &conn->recvwork);
+}
+EXPORT_SYMBOL_GPL(iscsi_conn_queue_recv);
+
 static void __iscsi_update_cmdsn(struct iscsi_session *session,
 				 uint32_t exp_cmdsn, uint32_t max_cmdsn)
 {
@@ -1943,7 +1953,7 @@ EXPORT_SYMBOL_GPL(iscsi_suspend_queue);
 
 /**
  * iscsi_suspend_tx - suspend iscsi_data_xmit
- * @conn: iscsi conn tp stop processing IO on.
+ * @conn: iscsi conn to stop processing IO on.
  *
  * This function sets the suspend bit to prevent iscsi_data_xmit
  * from sending new IO, and if work is queued on the xmit thread
@@ -1956,7 +1966,7 @@ void iscsi_suspend_tx(struct iscsi_conn *conn)
 
 	set_bit(ISCSI_CONN_FLAG_SUSPEND_TX, &conn->flags);
 	if (ihost->workq)
-		flush_workqueue(ihost->workq);
+		flush_work(&conn->xmitwork);
 }
 EXPORT_SYMBOL_GPL(iscsi_suspend_tx);
 
@@ -1966,6 +1976,21 @@ static void iscsi_start_tx(struct iscsi_conn *conn)
 	iscsi_conn_queue_xmit(conn);
 }
 
+/**
+ * iscsi_suspend_rx - Prevent recvwork from running again.
+ * @conn: iscsi conn to stop.
+ */
+void iscsi_suspend_rx(struct iscsi_conn *conn)
+{
+	struct Scsi_Host *shost = conn->session->host;
+	struct iscsi_host *ihost = shost_priv(shost);
+
+	set_bit(ISCSI_CONN_FLAG_SUSPEND_RX, &conn->flags);
+	if (ihost->workq)
+		flush_work(&conn->recvwork);
+}
+EXPORT_SYMBOL_GPL(iscsi_suspend_rx);
+
 /*
  * We want to make sure a ping is in flight. It has timed out.
  * And we are not busy processing a pdu that is making
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 51fb0c17815e..5a10e5acfad2 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -213,6 +213,8 @@ struct iscsi_conn {
 	struct list_head	cmdqueue;	/* data-path cmd queue */
 	struct list_head	requeue;	/* tasks needing another run */
 	struct work_struct	xmitwork;	/* per-conn. xmit workqueue */
+	/* recv */
+	struct work_struct	recvwork;
 	unsigned long		flags;		/* ISCSI_CONN_FLAGs */
 
 	/* negotiated params */
@@ -452,8 +454,10 @@ extern int iscsi_conn_get_param(struct iscsi_cls_conn *cls_conn,
 extern int iscsi_conn_get_addr_param(struct sockaddr_storage *addr,
 				     enum iscsi_param param, char *buf);
 extern void iscsi_suspend_tx(struct iscsi_conn *conn);
+extern void iscsi_suspend_rx(struct iscsi_conn *conn);
 extern void iscsi_suspend_queue(struct iscsi_conn *conn);
 extern void iscsi_conn_queue_xmit(struct iscsi_conn *conn);
+extern void iscsi_conn_queue_recv(struct iscsi_conn *conn);
 
 #define iscsi_conn_printk(prefix, _c, fmt, a...) \
 	iscsi_cls_conn_printk(prefix, ((struct iscsi_conn *)_c)->cls_conn, \
-- 
2.35.1



