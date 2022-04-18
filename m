Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32C445053F4
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:02:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238594AbiDRNBg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:01:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240029AbiDRM4a (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:56:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC9F812ABB;
        Mon, 18 Apr 2022 05:37:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 089D2611C9;
        Mon, 18 Apr 2022 12:37:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D774C385A8;
        Mon, 18 Apr 2022 12:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650285468;
        bh=Ks9zCk+VKhE9egTQtJE0fON4oKo7BKhoDemQDJMo/jQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ir2gN0yUTD/c+8vpq6eAEC2ie2RXJwaodp8XK48a2s2mD40q7iEctcFcoQxtzZ5FD
         2qxo2DVTJEbdVT2Z8cTF+2miFYSJy1v2WblErz7bKE9DDsUJu4jyuP7L0UFzMUFdn7
         7HaAaprbqBBg4CL/gmpOT/xMl6f9akn7uKY51tvg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lee Duncan <lduncan@suse.com>,
        Mike Christie <michael.christie@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 027/105] scsi: iscsi: Stop queueing during ep_disconnect
Date:   Mon, 18 Apr 2022 14:12:29 +0200
Message-Id: <20220418121147.070897187@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121145.140991388@linuxfoundation.org>
References: <20220418121145.140991388@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 3690e28cc7ea..8857d8322710 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -988,6 +988,7 @@ static struct iscsi_transport iscsi_iser_transport = {
 	/* connection management */
 	.create_conn            = iscsi_iser_conn_create,
 	.bind_conn              = iscsi_iser_conn_bind,
+	.unbind_conn		= iscsi_conn_unbind,
 	.destroy_conn           = iscsi_conn_teardown,
 	.attr_is_visible	= iser_attr_is_visible,
 	.set_param              = iscsi_iser_set_param,
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 987dc8135a9b..b977e039bb78 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -5810,6 +5810,7 @@ struct iscsi_transport beiscsi_iscsi_transport = {
 	.destroy_session = beiscsi_session_destroy,
 	.create_conn = beiscsi_conn_create,
 	.bind_conn = beiscsi_conn_bind,
+	.unbind_conn = iscsi_conn_unbind,
 	.destroy_conn = iscsi_conn_teardown,
 	.attr_is_visible = beiscsi_attr_is_visible,
 	.set_iface_param = beiscsi_iface_set_param,
diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index 21efc73b87be..173d8c6a8cbf 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -2278,6 +2278,7 @@ struct iscsi_transport bnx2i_iscsi_transport = {
 	.destroy_session	= bnx2i_session_destroy,
 	.create_conn		= bnx2i_conn_create,
 	.bind_conn		= bnx2i_conn_bind,
+	.unbind_conn		= iscsi_conn_unbind,
 	.destroy_conn		= bnx2i_conn_destroy,
 	.attr_is_visible	= bnx2i_attr_is_visible,
 	.set_param		= iscsi_set_param,
diff --git a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
index 37d99357120f..edcd3fab6973 100644
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
index d4e66c595eb8..05799b41974d 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1367,23 +1367,32 @@ void iscsi_session_failure(struct iscsi_session *session,
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
 
@@ -2117,6 +2126,51 @@ static void iscsi_check_transport_timeouts(struct timer_list *t)
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
index f51723e2d522..8f8036ae9a56 100644
--- a/drivers/scsi/qedi/qedi_iscsi.c
+++ b/drivers/scsi/qedi/qedi_iscsi.c
@@ -1428,6 +1428,7 @@ struct iscsi_transport qedi_iscsi_transport = {
 	.destroy_session = qedi_session_destroy,
 	.create_conn = qedi_conn_create,
 	.bind_conn = qedi_conn_bind,
+	.unbind_conn = iscsi_conn_unbind,
 	.start_conn = qedi_conn_start,
 	.stop_conn = iscsi_conn_stop,
 	.destroy_conn = qedi_conn_destroy,
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 2c23b692e318..a8b8bf118c76 100644
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
index a5759d0e388a..6490211b55d2 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -2957,7 +2957,7 @@ static int iscsi_if_ep_connect(struct iscsi_transport *transport,
 }
 
 static int iscsi_if_ep_disconnect(struct iscsi_transport *transport,
-				  u64 ep_handle)
+				  u64 ep_handle, bool is_active)
 {
 	struct iscsi_cls_conn *conn;
 	struct iscsi_endpoint *ep;
@@ -2974,6 +2974,8 @@ static int iscsi_if_ep_disconnect(struct iscsi_transport *transport,
 		conn->ep = NULL;
 		mutex_unlock(&conn->ep_mutex);
 		conn->state = ISCSI_CONN_FAILED;
+
+		transport->unbind_conn(conn, is_active);
 	}
 
 	transport->ep_disconnect(ep);
@@ -3005,7 +3007,8 @@ iscsi_if_transport_ep(struct iscsi_transport *transport,
 		break;
 	case ISCSI_UEVENT_TRANSPORT_EP_DISCONNECT:
 		rc = iscsi_if_ep_disconnect(transport,
-					    ev->u.ep_disconnect.ep_handle);
+					    ev->u.ep_disconnect.ep_handle,
+					    false);
 		break;
 	}
 	return rc;
@@ -3730,7 +3733,7 @@ iscsi_if_recv_msg(struct sk_buff *skb, struct nlmsghdr *nlh, uint32_t *group)
 		conn = iscsi_conn_lookup(ev->u.b_conn.sid, ev->u.b_conn.cid);
 
 		if (conn && conn->ep)
-			iscsi_if_ep_disconnect(transport, conn->ep->id);
+			iscsi_if_ep_disconnect(transport, conn->ep->id, true);
 
 		if (!session || !conn) {
 			err = -EINVAL;
@@ -4649,6 +4652,7 @@ iscsi_register_transport(struct iscsi_transport *tt)
 	int err;
 
 	BUG_ON(!tt);
+	WARN_ON(tt->ep_disconnect && !tt->unbind_conn);
 
 	priv = iscsi_if_transport_lookup(tt);
 	if (priv)
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 2b5f97224f69..fa00e2543ad6 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -421,6 +421,7 @@ extern int iscsi_conn_start(struct iscsi_cls_conn *);
 extern void iscsi_conn_stop(struct iscsi_cls_conn *, int);
 extern int iscsi_conn_bind(struct iscsi_cls_session *, struct iscsi_cls_conn *,
 			   int);
+extern void iscsi_conn_unbind(struct iscsi_cls_conn *cls_conn, bool is_active);
 extern void iscsi_conn_failure(struct iscsi_conn *conn, enum iscsi_err err);
 extern void iscsi_session_failure(struct iscsi_session *session,
 				  enum iscsi_err err);
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index f28bb20d6271..eb6ed499324d 100644
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
2.35.1



