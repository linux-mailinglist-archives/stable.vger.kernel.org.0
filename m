Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E946A3CA7D6
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 20:54:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241006AbhGOS4m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 14:56:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:59882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240120AbhGOS4F (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:56:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 65032613D1;
        Thu, 15 Jul 2021 18:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375190;
        bh=dyshn5kvxDEI0SM2myXYKNppDxlJZf63QS5mPCGGb8c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GmPfx9DVbmXFryobMV/UeDc8143EwZ+AAeI2vkcr/gHfFK6Pd5wYW3cd4n9cRcdxN
         NJmN/q8dHUprKpLbzEVx6FY9WGF3oFhn2fU8q1OnzQQAkMPScq1JYC95NDhfpeF9DD
         vICvaUss/H7DFCVnp07HNHmuBfLKCOyFIVZ5oV+g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Gulam Mohamed <gulam.mohamed@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hanjun Guo <guohanjun@huawei.com>
Subject: [PATCH 5.10 145/215] scsi: iscsi: Fix iSCSI cls conn state
Date:   Thu, 15 Jul 2021 20:38:37 +0200
Message-Id: <20210715182625.263662643@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182558.381078833@linuxfoundation.org>
References: <20210715182558.381078833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Christie <michael.christie@oracle.com>

commit 0dcf8febcb7b9d42bec98bc068e01d1a6ea578b8 upstream.

In commit 9e67600ed6b8 ("scsi: iscsi: Fix race condition between login and
sync thread") I missed that libiscsi was now setting the iSCSI class state,
and that patch ended up resetting the state during conn stoppage and using
the wrong state value during ep_disconnect. This patch moves the setting of
the class state to the class module and then fixes the two issues above.

Link: https://lore.kernel.org/r/20210406171746.5016-1-michael.christie@oracle.com
Fixes: 9e67600ed6b8 ("scsi: iscsi: Fix race condition between login and sync thread")
Cc: Gulam Mohamed <gulam.mohamed@oracle.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Hanjun Guo <guohanjun@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/libiscsi.c             |   26 +++-----------------------
 drivers/scsi/scsi_transport_iscsi.c |   18 +++++++++++++++---
 2 files changed, 18 insertions(+), 26 deletions(-)

--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -3089,9 +3089,10 @@ fail_mgmt_tasks(struct iscsi_session *se
 	}
 }
 
-static void iscsi_start_session_recovery(struct iscsi_session *session,
-					 struct iscsi_conn *conn, int flag)
+void iscsi_conn_stop(struct iscsi_cls_conn *cls_conn, int flag)
 {
+	struct iscsi_conn *conn = cls_conn->dd_data;
+	struct iscsi_session *session = conn->session;
 	int old_stop_stage;
 
 	mutex_lock(&session->eh_mutex);
@@ -3149,27 +3150,6 @@ static void iscsi_start_session_recovery
 	spin_unlock_bh(&session->frwd_lock);
 	mutex_unlock(&session->eh_mutex);
 }
-
-void iscsi_conn_stop(struct iscsi_cls_conn *cls_conn, int flag)
-{
-	struct iscsi_conn *conn = cls_conn->dd_data;
-	struct iscsi_session *session = conn->session;
-
-	switch (flag) {
-	case STOP_CONN_RECOVER:
-		cls_conn->state = ISCSI_CONN_FAILED;
-		break;
-	case STOP_CONN_TERM:
-		cls_conn->state = ISCSI_CONN_DOWN;
-		break;
-	default:
-		iscsi_conn_printk(KERN_ERR, conn,
-				  "invalid stop flag %d\n", flag);
-		return;
-	}
-
-	iscsi_start_session_recovery(session, conn, flag);
-}
 EXPORT_SYMBOL_GPL(iscsi_conn_stop);
 
 int iscsi_conn_bind(struct iscsi_cls_session *cls_session,
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -2479,10 +2479,22 @@ static void iscsi_if_stop_conn(struct is
 	 * it works.
 	 */
 	mutex_lock(&conn_mutex);
+	switch (flag) {
+	case STOP_CONN_RECOVER:
+		conn->state = ISCSI_CONN_FAILED;
+		break;
+	case STOP_CONN_TERM:
+		conn->state = ISCSI_CONN_DOWN;
+		break;
+	default:
+		iscsi_cls_conn_printk(KERN_ERR, conn,
+				      "invalid stop flag %d\n", flag);
+		goto unlock;
+	}
+
 	conn->transport->stop_conn(conn, flag);
-	conn->state = ISCSI_CONN_DOWN;
+unlock:
 	mutex_unlock(&conn_mutex);
-
 }
 
 static void stop_conn_work_fn(struct work_struct *work)
@@ -2973,7 +2985,7 @@ static int iscsi_if_ep_disconnect(struct
 		mutex_lock(&conn->ep_mutex);
 		conn->ep = NULL;
 		mutex_unlock(&conn->ep_mutex);
-		conn->state = ISCSI_CONN_DOWN;
+		conn->state = ISCSI_CONN_FAILED;
 	}
 
 	transport->ep_disconnect(ep);


