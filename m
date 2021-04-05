Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B910A354416
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 18:04:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242050AbhDEQE1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 12:04:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:55614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241981AbhDEQEV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 12:04:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4ED31613B8;
        Mon,  5 Apr 2021 16:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617638655;
        bh=F71KHINfsuV/NDMgW/augmyJgjANPodoz4nNfQKfovM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J9vqABgQCefqafr9fJsHLPyb6F+Nt1DC4YB598QXHWFlIa0MAOdK/T7Ik4/t+0epI
         E6QbWwzedW64x5rGimxqsO0qBhTlYuKUZ/MXGgElhYCTnx7oFOIz73l4rFQt0B62+G
         jQXvw6tVI82v3Kr60Eah/RHbo/MsBLByNR0fscwiJDP5N7wjr4tfa7SltLPU0i9ZnY
         yD/g83aRE9H81efEt/YJMKZIv37rp7iYJJV8gtp1GSsPedeg8nODHQQAl9miFZ/pEd
         ZqJyroqeO9z+DVs0VK0RwdSrYhDa3Rpp3DPXosK7PbTvRSrg342Avx9u/widKi/rh5
         VSkgHfa6qTEnQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gulam Mohamed <gulam.mohamed@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, open-iscsi@googlegroups.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 07/22] scsi: iscsi: Fix race condition between login and sync thread
Date:   Mon,  5 Apr 2021 12:03:50 -0400
Message-Id: <20210405160406.268132-7-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210405160406.268132-1-sashal@kernel.org>
References: <20210405160406.268132-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gulam Mohamed <gulam.mohamed@oracle.com>

[ Upstream commit 9e67600ed6b8565da4b85698ec659b5879a6c1c6 ]

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

index 91074fd97f64..f4bf62b007a0 100644

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_transport_iscsi.c | 14 +++++++++++++-
 include/scsi/scsi_transport_iscsi.h |  1 +
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index c53c3f9fa526..f648452d8d66 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -2478,6 +2478,7 @@ static void iscsi_if_stop_conn(struct iscsi_cls_conn *conn, int flag)
 	 */
 	mutex_lock(&conn_mutex);
 	conn->transport->stop_conn(conn, flag);
+	conn->state = ISCSI_CONN_DOWN;
 	mutex_unlock(&conn_mutex);
 
 }
@@ -2904,6 +2905,13 @@ iscsi_set_param(struct iscsi_transport *transport, struct iscsi_uevent *ev)
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
@@ -2963,6 +2971,7 @@ static int iscsi_if_ep_disconnect(struct iscsi_transport *transport,
 		mutex_lock(&conn->ep_mutex);
 		conn->ep = NULL;
 		mutex_unlock(&conn->ep_mutex);
+		conn->state = ISCSI_CONN_DOWN;
 	}
 
 	transport->ep_disconnect(ep);
@@ -3730,6 +3739,8 @@ iscsi_if_recv_msg(struct sk_buff *skb, struct nlmsghdr *nlh, uint32_t *group)
 		ev->r.retcode =	transport->bind_conn(session, conn,
 						ev->u.b_conn.transport_eph,
 						ev->u.b_conn.is_leading);
+		if (!ev->r.retcode)
+			conn->state = ISCSI_CONN_BOUND;
 		mutex_unlock(&conn_mutex);
 
 		if (ev->r.retcode || !transport->ep_connect)
@@ -3969,7 +3980,8 @@ iscsi_conn_attr(local_ipaddr, ISCSI_PARAM_LOCAL_IPADDR);
 static const char *const connection_state_names[] = {
 	[ISCSI_CONN_UP] = "up",
 	[ISCSI_CONN_DOWN] = "down",
-	[ISCSI_CONN_FAILED] = "failed"
+	[ISCSI_CONN_FAILED] = "failed",
+	[ISCSI_CONN_BOUND] = "bound"
 };
 
 static ssize_t show_conn_state(struct device *dev,
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index 8a26a2ffa952..fc5a39839b4b 100644
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
2.30.2

