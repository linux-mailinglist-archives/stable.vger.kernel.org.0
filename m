Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 922103C2D3E
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:20:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232515AbhGJCWQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:22:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:38416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232493AbhGJCVc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:21:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 57137613BE;
        Sat, 10 Jul 2021 02:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625883528;
        bh=7U4vZqBaD7Fctf/2ZRSIKOEiDNzE4mJm9yBDA0b3hT8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cAxKGVNs1/E6GLzfpXXxG9/IWgh1YSC1uG05Q0ox07SGei3jvNW9m/BNGjShtBXx6
         suhS2/4AbygIsAVTAZHXQI9lDpvBtemNR567MrsKfPl0saOLw1noGT4PlIbYkt7HEO
         RsfL2hsb8mfFOo1XzqosBPjA9pYUiNjIAN0GVxIiGH/pgrF/LqOKrKzz5yrJkyCWKX
         WInY87b5HbrlfthNaW6RvFbVJj9pUAH98P47DV8QmEWixIl/k7lP086ui0nMqb28RS
         MQ2SVwS9MI2VyAr3MV4ZCOj+OM0+gSPo8wwIbxwXi7n979jxzP+rRBoMc4L8cxOSXe
         tjpMit960eRIg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>,
        Lee Duncan <lduncan@suse.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org,
        linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com
Subject: [PATCH AUTOSEL 5.13 043/114] scsi: iscsi: Stop queueing during ep_disconnect
Date:   Fri,  9 Jul 2021 22:16:37 -0400
Message-Id: <20210710021748.3167666-43-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710021748.3167666-1-sashal@kernel.org>
References: <20210710021748.3167666-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Christie <michael.christie@oracle.com>

[ Upstream commit 891e2639deae721dc43764a44fa255890dc34313 ]

During ep_disconnect we have been doing iscsi_suspend_tx/queue to block new
I/O but every driver except cxgbi and iscsi_tcp can still get I/O from
__iscsi_conn_send_pdu() if we haven't called iscsi_conn_failure() before
ep_disconnect. This could happen if we were terminating the session, and
the logout timed out before it was even sent to libiscsi.

Fix the issue by adding a helper which reverses the bind_conn call that
allows new I/O to be queued. Drivers implementing ep_disconnect can use this
to make sure new I/O is not queued to them when handling the disconnect.

Link: https://lore.kernel.org/r/20210525181821.7617-3-michael.christie@oracle.com
Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c |  1 +
 drivers/scsi/be2iscsi/be_main.c          |  1 +
 drivers/scsi/bnx2i/bnx2i_iscsi.c         |  1 +
 drivers/scsi/cxgbi/cxgb3i/cxgb3i.c       |  1 +
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c       |  1 +
 drivers/scsi/libiscsi.c                  | 70 +++++++++++++++++++++---
 drivers/scsi/qedi/qedi_iscsi.c           |  1 +
 drivers/scsi/qla4xxx/ql4_os.c            |  1 +
 drivers/scsi/scsi_transport_iscsi.c      | 10 +++-
 include/scsi/libiscsi.h                  |  1 +
 include/scsi/scsi_transport_iscsi.h      |  1 +
 11 files changed, 78 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 8fcaa1136f2c..6baebcb6d14d 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -1002,6 +1002,7 @@ static struct iscsi_transport iscsi_iser_transport = {
 	/* connection management */
 	.create_conn            = iscsi_iser_conn_create,
 	.bind_conn              = iscsi_iser_conn_bind,
+	.unbind_conn		= iscsi_conn_unbind,
 	.destroy_conn           = iscsi_conn_teardown,
 	.attr_is_visible	= iser_attr_is_visible,
 	.set_param              = iscsi_iser_set_param,
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 22cf7f4b8d8c..27c4f1598f76 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -5809,6 +5809,7 @@ struct iscsi_transport beiscsi_iscsi_transport = {
 	.destroy_session = beiscsi_session_destroy,
 	.create_conn = beiscsi_conn_create,
 	.bind_conn = beiscsi_conn_bind,
+	.unbind_conn = iscsi_conn_unbind,
 	.destroy_conn = iscsi_conn_teardown,
 	.attr_is_visible = beiscsi_attr_is_visible,
 	.set_iface_param = beiscsi_iface_set_param,
diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index 1e6d8f62ea3c..b6c1da46d582 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -2276,6 +2276,7 @@ struct iscsi_transport bnx2i_iscsi_transport = {
 	.destroy_session	= bnx2i_session_destroy,
 	.create_conn		= bnx2i_conn_create,
 	.bind_conn		= bnx2i_conn_bind,
+	.unbind_conn		= iscsi_conn_unbind,
 	.destroy_conn		= bnx2i_conn_destroy,
 	.attr_is_visible	= bnx2i_attr_is_visible,
 	.set_param		= iscsi_set_param,
diff --git a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
index 203f938fca7e..f949a4e00783 100644
--- a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
+++ b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
@@ -117,6 +117,7 @@ static struct iscsi_transport cxgb3i_iscsi_transport = {
 	/* connection management */
 	.create_conn	= cxgbi_create_conn,
 	.bind_conn	= cxgbi_bind_conn,
+	.unbind_conn	= iscsi_conn_unbind,
 	.destroy_conn	= iscsi_tcp_conn_teardown,
 	.start_conn	= iscsi_conn_start,
 	.stop_conn	= iscsi_conn_stop,
diff --git a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
index 2c3491528d42..efb3e2b3398e 100644
--- a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
+++ b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
@@ -134,6 +134,7 @@ static struct iscsi_transport cxgb4i_iscsi_transport = {
 	/* connection management */
 	.create_conn	= cxgbi_create_conn,
 	.bind_conn		= cxgbi_bind_conn,
+	.unbind_conn	= iscsi_conn_unbind,
 	.destroy_conn	= iscsi_tcp_conn_teardown,
 	.start_conn		= iscsi_conn_start,
 	.stop_conn		= iscsi_conn_stop,
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 4834219497ee..2aaf83678654 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1387,23 +1387,32 @@ void iscsi_session_failure(struct iscsi_session *session,
 }
 EXPORT_SYMBOL_GPL(iscsi_session_failure);
 
-void iscsi_conn_failure(struct iscsi_conn *conn, enum iscsi_err err)
+static bool iscsi_set_conn_failed(struct iscsi_conn *conn)
 {
 	struct iscsi_session *session = conn->session;
 
-	spin_lock_bh(&session->frwd_lock);
-	if (session->state == ISCSI_STATE_FAILED) {
-		spin_unlock_bh(&session->frwd_lock);
-		return;
-	}
+	if (session->state == ISCSI_STATE_FAILED)
+		return false;
 
 	if (conn->stop_stage == 0)
 		session->state = ISCSI_STATE_FAILED;
-	spin_unlock_bh(&session->frwd_lock);
 
 	set_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx);
 	set_bit(ISCSI_SUSPEND_BIT, &conn->suspend_rx);
-	iscsi_conn_error_event(conn->cls_conn, err);
+	return true;
+}
+
+void iscsi_conn_failure(struct iscsi_conn *conn, enum iscsi_err err)
+{
+	struct iscsi_session *session = conn->session;
+	bool needs_evt;
+
+	spin_lock_bh(&session->frwd_lock);
+	needs_evt = iscsi_set_conn_failed(conn);
+	spin_unlock_bh(&session->frwd_lock);
+
+	if (needs_evt)
+		iscsi_conn_error_event(conn->cls_conn, err);
 }
 EXPORT_SYMBOL_GPL(iscsi_conn_failure);
 
@@ -2180,6 +2189,51 @@ static void iscsi_check_transport_timeouts(struct timer_list *t)
 	spin_unlock(&session->frwd_lock);
 }
 
+/**
+ * iscsi_conn_unbind - prevent queueing to conn.
+ * @cls_conn: iscsi conn ep is bound to.
+ * @is_active: is the conn in use for boot or is this for EH/termination
+ *
+ * This must be called by drivers implementing the ep_disconnect callout.
+ * It disables queueing to the connection from libiscsi in preparation for
+ * an ep_disconnect call.
+ */
+void iscsi_conn_unbind(struct iscsi_cls_conn *cls_conn, bool is_active)
+{
+	struct iscsi_session *session;
+	struct iscsi_conn *conn;
+
+	if (!cls_conn)
+		return;
+
+	conn = cls_conn->dd_data;
+	session = conn->session;
+	/*
+	 * Wait for iscsi_eh calls to exit. We don't wait for the tmf to
+	 * complete or timeout. The caller just wants to know what's running
+	 * is everything that needs to be cleaned up, and no cmds will be
+	 * queued.
+	 */
+	mutex_lock(&session->eh_mutex);
+
+	iscsi_suspend_queue(conn);
+	iscsi_suspend_tx(conn);
+
+	spin_lock_bh(&session->frwd_lock);
+	if (!is_active) {
+		/*
+		 * if logout timed out before userspace could even send a PDU
+		 * the state might still be in ISCSI_STATE_LOGGED_IN and
+		 * allowing new cmds and TMFs.
+		 */
+		if (session->state == ISCSI_STATE_LOGGED_IN)
+			iscsi_set_conn_failed(conn);
+	}
+	spin_unlock_bh(&session->frwd_lock);
+	mutex_unlock(&session->eh_mutex);
+}
+EXPORT_SYMBOL_GPL(iscsi_conn_unbind);
+
 static void iscsi_prep_abort_task_pdu(struct iscsi_task *task,
 				      struct iscsi_tm *hdr)
 {
diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscsi.c
index 08c05403cd72..ef16537c523c 100644
--- a/drivers/scsi/qedi/qedi_iscsi.c
+++ b/drivers/scsi/qedi/qedi_iscsi.c
@@ -1401,6 +1401,7 @@ struct iscsi_transport qedi_iscsi_transport = {
 	.destroy_session = qedi_session_destroy,
 	.create_conn = qedi_conn_create,
 	.bind_conn = qedi_conn_bind,
+	.unbind_conn = iscsi_conn_unbind,
 	.start_conn = qedi_conn_start,
 	.stop_conn = iscsi_conn_stop,
 	.destroy_conn = qedi_conn_destroy,
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index ad3afe30f617..74d0d1bc208d 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -259,6 +259,7 @@ static struct iscsi_transport qla4xxx_iscsi_transport = {
 	.start_conn             = qla4xxx_conn_start,
 	.create_conn            = qla4xxx_conn_create,
 	.bind_conn              = qla4xxx_conn_bind,
+	.unbind_conn		= iscsi_conn_unbind,
 	.stop_conn              = iscsi_conn_stop,
 	.destroy_conn           = qla4xxx_conn_destroy,
 	.set_param              = iscsi_set_param,
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 441f0152193f..82491343e94a 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -2964,7 +2964,7 @@ static int iscsi_if_ep_connect(struct iscsi_transport *transport,
 }
 
 static int iscsi_if_ep_disconnect(struct iscsi_transport *transport,
-				  u64 ep_handle)
+				  u64 ep_handle, bool is_active)
 {
 	struct iscsi_cls_conn *conn;
 	struct iscsi_endpoint *ep;
@@ -2981,6 +2981,8 @@ static int iscsi_if_ep_disconnect(struct iscsi_transport *transport,
 		conn->ep = NULL;
 		mutex_unlock(&conn->ep_mutex);
 		conn->state = ISCSI_CONN_FAILED;
+
+		transport->unbind_conn(conn, is_active);
 	}
 
 	transport->ep_disconnect(ep);
@@ -3012,7 +3014,8 @@ iscsi_if_transport_ep(struct iscsi_transport *transport,
 		break;
 	case ISCSI_UEVENT_TRANSPORT_EP_DISCONNECT:
 		rc = iscsi_if_ep_disconnect(transport,
-					    ev->u.ep_disconnect.ep_handle);
+					    ev->u.ep_disconnect.ep_handle,
+					    false);
 		break;
 	}
 	return rc;
@@ -3737,7 +3740,7 @@ iscsi_if_recv_msg(struct sk_buff *skb, struct nlmsghdr *nlh, uint32_t *group)
 		conn = iscsi_conn_lookup(ev->u.b_conn.sid, ev->u.b_conn.cid);
 
 		if (conn && conn->ep)
-			iscsi_if_ep_disconnect(transport, conn->ep->id);
+			iscsi_if_ep_disconnect(transport, conn->ep->id, true);
 
 		if (!session || !conn) {
 			err = -EINVAL;
@@ -4656,6 +4659,7 @@ iscsi_register_transport(struct iscsi_transport *tt)
 	int err;
 
 	BUG_ON(!tt);
+	WARN_ON(tt->ep_disconnect && !tt->unbind_conn);
 
 	priv = iscsi_if_transport_lookup(tt);
 	if (priv)
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 02f966e9358f..091f284bd6e9 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -424,6 +424,7 @@ extern int iscsi_conn_start(struct iscsi_cls_conn *);
 extern void iscsi_conn_stop(struct iscsi_cls_conn *, int);
 extern int iscsi_conn_bind(struct iscsi_cls_session *, struct iscsi_cls_conn *,
 			   int);
+extern void iscsi_conn_unbind(struct iscsi_cls_conn *cls_conn, bool is_active);
 extern void iscsi_conn_failure(struct iscsi_conn *conn, enum iscsi_err err);
 extern void iscsi_session_failure(struct iscsi_session *session,
 				  enum iscsi_err err);
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index fc5a39839b4b..8874016b3c9a 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -82,6 +82,7 @@ struct iscsi_transport {
 	void (*destroy_session) (struct iscsi_cls_session *session);
 	struct iscsi_cls_conn *(*create_conn) (struct iscsi_cls_session *sess,
 				uint32_t cid);
+	void (*unbind_conn) (struct iscsi_cls_conn *conn, bool is_active);
 	int (*bind_conn) (struct iscsi_cls_session *session,
 			  struct iscsi_cls_conn *cls_conn,
 			  uint64_t transport_eph, int is_leading);
-- 
2.30.2

