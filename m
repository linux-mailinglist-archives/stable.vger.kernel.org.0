Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A2EA3C6D76
	for <lists+stable@lfdr.de>; Tue, 13 Jul 2021 11:30:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235263AbhGMJcx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Jul 2021 05:32:53 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:10477 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235256AbhGMJcv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Jul 2021 05:32:51 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GPFdH2w8Fzccyw;
        Tue, 13 Jul 2021 17:26:43 +0800 (CST)
Received: from dggpemm500002.china.huawei.com (7.185.36.229) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 13 Jul 2021 17:29:52 +0800
Received: from linux-ibm.site (10.175.102.37) by
 dggpemm500002.china.huawei.com (7.185.36.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 13 Jul 2021 17:29:52 +0800
From:   Hanjun Guo <guohanjun@huawei.com>
To:     <stable@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Gulam Mohamed <gulam.mohamed@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hanjun Guo <guohanjun@huawei.com>
Subject: [Backport for 5.10.y PATCH 6/7] scsi: iscsi: Fix race condition between login and sync thread
Date:   Tue, 13 Jul 2021 17:18:36 +0800
Message-ID: <1626167917-11972-7-git-send-email-guohanjun@huawei.com>
X-Mailer: git-send-email 1.7.12.4
In-Reply-To: <1626167917-11972-1-git-send-email-guohanjun@huawei.com>
References: <1626167917-11972-1-git-send-email-guohanjun@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.102.37]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500002.china.huawei.com (7.185.36.229)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gulam Mohamed <gulam.mohamed@oracle.com>

commit 9e67600ed6b8565da4b85698ec659b5879a6c1c6 upstream.

A kernel panic was observed due to a timing issue between the sync thread
and the initiator processing a login response from the target. The session
reopen can be invoked both from the session sync thread when iscsid
restarts and from iscsid through the error handler. Before the initiator
receives the response to a login, another reopen request can be sent from
the error handler/sync session. When the initial login response is
subsequently processed, the connection has been closed and the socket has
been released.

To fix this a new connection state, ISCSI_CONN_BOUND, is added:

 - Set the connection state value to ISCSI_CONN_DOWN upon
   iscsi_if_ep_disconnect() and iscsi_if_stop_conn()

 - Set the connection state to the newly created value ISCSI_CONN_BOUND
   after bind connection (transport->bind_conn())

 - In iscsi_set_param(), return -ENOTCONN if the connection state is not
   either ISCSI_CONN_BOUND or ISCSI_CONN_UP

Link: https://lore.kernel.org/r/20210325093248.284678-1-gulam.mohamed@oracle.com
Reviewed-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Gulam Mohamed <gulam.mohamed@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Hanjun Guo <guohanjun@huawei.com>
---
 drivers/scsi/scsi_transport_iscsi.c | 14 +++++++++++++-
 include/scsi/scsi_transport_iscsi.h |  1 +
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index c520239..cb7b74a0 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -2480,6 +2480,7 @@ static void iscsi_if_stop_conn(struct iscsi_cls_conn *conn, int flag)
 	 */
 	mutex_lock(&conn_mutex);
 	conn->transport->stop_conn(conn, flag);
+	conn->state = ISCSI_CONN_DOWN;
 	mutex_unlock(&conn_mutex);
 
 }
@@ -2906,6 +2907,13 @@ int iscsi_session_event(struct iscsi_cls_session *session,
 	default:
 		err = transport->set_param(conn, ev->u.set_param.param,
 					   data, ev->u.set_param.len);
+		if ((conn->state == ISCSI_CONN_BOUND) ||
+			(conn->state == ISCSI_CONN_UP)) {
+			err = transport->set_param(conn, ev->u.set_param.param,
+					data, ev->u.set_param.len);
+		} else {
+			return -ENOTCONN;
+		}
 	}
 
 	return err;
@@ -2965,6 +2973,7 @@ static int iscsi_if_ep_disconnect(struct iscsi_transport *transport,
 		mutex_lock(&conn->ep_mutex);
 		conn->ep = NULL;
 		mutex_unlock(&conn->ep_mutex);
+		conn->state = ISCSI_CONN_DOWN;
 	}
 
 	transport->ep_disconnect(ep);
@@ -3732,6 +3741,8 @@ static int iscsi_logout_flashnode_sid(struct iscsi_transport *transport,
 		ev->r.retcode =	transport->bind_conn(session, conn,
 						ev->u.b_conn.transport_eph,
 						ev->u.b_conn.is_leading);
+		if (!ev->r.retcode)
+			conn->state = ISCSI_CONN_BOUND;
 		mutex_unlock(&conn_mutex);
 
 		if (ev->r.retcode || !transport->ep_connect)
@@ -3971,7 +3982,8 @@ static ISCSI_CLASS_ATTR(conn, field, S_IRUGO, show_conn_param_##param,	\
 static const char *const connection_state_names[] = {
 	[ISCSI_CONN_UP] = "up",
 	[ISCSI_CONN_DOWN] = "down",
-	[ISCSI_CONN_FAILED] = "failed"
+	[ISCSI_CONN_FAILED] = "failed",
+	[ISCSI_CONN_BOUND] = "bound"
 };
 
 static ssize_t show_conn_state(struct device *dev,
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index 8a26a2f..fc5a398 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -193,6 +193,7 @@ enum iscsi_connection_state {
 	ISCSI_CONN_UP = 0,
 	ISCSI_CONN_DOWN,
 	ISCSI_CONN_FAILED,
+	ISCSI_CONN_BOUND,
 };
 
 struct iscsi_cls_conn {
-- 
1.7.12.4

