Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CA353CA787
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 20:52:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239773AbhGOSzO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 14:55:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:57908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241081AbhGOSyE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:54:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1971B613C4;
        Thu, 15 Jul 2021 18:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375069;
        bh=qNpQeJi/cdK37j7kuc/V8Xneiz4MUr41EdQKULHvwgw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yOTigQjZdHz21AmUMTAY8wrvY/o/Noh+TzpS207b0HB5RzZohRmurRdiaGmV2qfp5
         nhvj0A+g4ZBfjvKU8qji4nf7SBSI4/CNqcKez1rihjNJnv+XSU4ev4GiwJv/pIB+yr
         LkdoRIBrmYSHjntIbYFuExZO79uAhN9UxDPHrK6Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mike Christie <michael.christie@oracle.com>,
        Gulam Mohamed <gulam.mohamed@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hanjun Guo <guohanjun@huawei.com>
Subject: [PATCH 5.10 144/215] scsi: iscsi: Fix race condition between login and sync thread
Date:   Thu, 15 Jul 2021 20:38:36 +0200
Message-Id: <20210715182625.054880259@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/scsi_transport_iscsi.c |   14 +++++++++++++-
 include/scsi/scsi_transport_iscsi.h |    1 +
 2 files changed, 14 insertions(+), 1 deletion(-)

--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -2480,6 +2480,7 @@ static void iscsi_if_stop_conn(struct is
 	 */
 	mutex_lock(&conn_mutex);
 	conn->transport->stop_conn(conn, flag);
+	conn->state = ISCSI_CONN_DOWN;
 	mutex_unlock(&conn_mutex);
 
 }
@@ -2906,6 +2907,13 @@ iscsi_set_param(struct iscsi_transport *
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
@@ -2965,6 +2973,7 @@ static int iscsi_if_ep_disconnect(struct
 		mutex_lock(&conn->ep_mutex);
 		conn->ep = NULL;
 		mutex_unlock(&conn->ep_mutex);
+		conn->state = ISCSI_CONN_DOWN;
 	}
 
 	transport->ep_disconnect(ep);
@@ -3732,6 +3741,8 @@ iscsi_if_recv_msg(struct sk_buff *skb, s
 		ev->r.retcode =	transport->bind_conn(session, conn,
 						ev->u.b_conn.transport_eph,
 						ev->u.b_conn.is_leading);
+		if (!ev->r.retcode)
+			conn->state = ISCSI_CONN_BOUND;
 		mutex_unlock(&conn_mutex);
 
 		if (ev->r.retcode || !transport->ep_connect)
@@ -3971,7 +3982,8 @@ iscsi_conn_attr(local_ipaddr, ISCSI_PARA
 static const char *const connection_state_names[] = {
 	[ISCSI_CONN_UP] = "up",
 	[ISCSI_CONN_DOWN] = "down",
-	[ISCSI_CONN_FAILED] = "failed"
+	[ISCSI_CONN_FAILED] = "failed",
+	[ISCSI_CONN_BOUND] = "bound"
 };
 
 static ssize_t show_conn_state(struct device *dev,
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -193,6 +193,7 @@ enum iscsi_connection_state {
 	ISCSI_CONN_UP = 0,
 	ISCSI_CONN_DOWN,
 	ISCSI_CONN_FAILED,
+	ISCSI_CONN_BOUND,
 };
 
 struct iscsi_cls_conn {


