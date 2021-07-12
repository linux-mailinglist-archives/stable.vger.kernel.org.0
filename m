Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B57DE3C4FB6
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:44:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245553AbhGLH1P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:27:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:33304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345372AbhGLHZW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:25:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 869B8610D1;
        Mon, 12 Jul 2021 07:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074553;
        bh=S4+NEffNIZ0yY5n+MH2nvPRNu2DMHbtXypFSGKvvpPk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D4KAH8/PnCe98DQyJhDnzTQZ1mOxgf0EHnXConlYXUBx3j4c1HkVK3m6cKb0uFwfo
         fuGYl7HDL5OONmTb1fjBUhD67FL1rX8bFuaBZRAtIbxjaEaD+DE3E9qvlc6bk227l2
         hRjdwlUPT2pe2ZyeQ2ri+plDZvTt07VH3zY3gpPs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lee Duncan <lduncan@suse.com>,
        Mike Christie <michael.christie@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 581/700] scsi: iscsi: Fix in-kernel conn failure handling
Date:   Mon, 12 Jul 2021 08:11:04 +0200
Message-Id: <20210712061037.858495222@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Christie <michael.christie@oracle.com>

[ Upstream commit 23d6fefbb3f6b1cc29794427588b470ed06ff64e ]

Commit 0ab710458da1 ("scsi: iscsi: Perform connection failure entirely in
kernel space") has the following regressions/bugs that this patch fixes:

1. It can return cmds to upper layers like dm-multipath where that can
retry them. After they are successful the fs/app can send new I/O to the
same sectors, but we've left the cmds running in FW or in the net layer.
We need to be calling ep_disconnect if userspace is not up.

This patch only fixes the issue for offload drivers. iscsi_tcp will be
fixed in separate commit because it doesn't have a ep_disconnect call.

2. The drivers that implement ep_disconnect expect that it's called before
conn_stop. Besides crashes, if the cleanup_task callout is called before
ep_disconnect it might free up driver/card resources for session1 then they
could be allocated for session2. But because the driver's ep_disconnect is
not called it has not cleaned up the firmware so the card is still using
the resources for the original cmd.

3. The stop_conn_work_fn can run after userspace has done its recovery and
we are happily using the session. We will then end up with various bugs
depending on what is going on at the time.

We may also run stop_conn_work_fn late after userspace has called stop_conn
and ep_disconnect and is now going to call start/bind conn. If
stop_conn_work_fn runs after bind but before start, we would leave the conn
in a unbound but sort of started state where IO might be allowed even
though the drivers have been set in a state where they no longer expect
I/O.

4. Returning -EAGAIN in iscsi_if_destroy_conn if we haven't yet run the in
kernel stop_conn function is breaking userspace. We should have been doing
this for the caller.

Link: https://lore.kernel.org/r/20210525181821.7617-8-michael.christie@oracle.com
Fixes: 0ab710458da1 ("scsi: iscsi: Perform connection failure entirely in kernel space")
Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_transport_iscsi.c | 471 ++++++++++++++++------------
 include/scsi/scsi_transport_iscsi.h |  10 +-
 2 files changed, 283 insertions(+), 198 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index bab6654d8ee9..b8a93e607891 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -86,15 +86,11 @@ struct iscsi_internal {
 	struct transport_container session_cont;
 };
 
-/* Worker to perform connection failure on unresponsive connections
- * completely in kernel space.
- */
-static void stop_conn_work_fn(struct work_struct *work);
-static DECLARE_WORK(stop_conn_work, stop_conn_work_fn);
-
 static atomic_t iscsi_session_nr; /* sysfs session id for next new session */
 static struct workqueue_struct *iscsi_eh_timer_workq;
 
+static struct workqueue_struct *iscsi_conn_cleanup_workq;
+
 static DEFINE_IDA(iscsi_sess_ida);
 /*
  * list of registered transports and lock that must
@@ -1623,12 +1619,6 @@ static DECLARE_TRANSPORT_CLASS(iscsi_connection_class,
 static struct sock *nls;
 static DEFINE_MUTEX(rx_queue_mutex);
 
-/*
- * conn_mutex protects the {start,bind,stop,destroy}_conn from racing
- * against the kernel stop_connection recovery mechanism
- */
-static DEFINE_MUTEX(conn_mutex);
-
 static LIST_HEAD(sesslist);
 static DEFINE_SPINLOCK(sesslock);
 static LIST_HEAD(connlist);
@@ -2245,6 +2235,123 @@ void iscsi_remove_session(struct iscsi_cls_session *session)
 }
 EXPORT_SYMBOL_GPL(iscsi_remove_session);
 
+static void iscsi_stop_conn(struct iscsi_cls_conn *conn, int flag)
+{
+	ISCSI_DBG_TRANS_CONN(conn, "Stopping conn.\n");
+
+	switch (flag) {
+	case STOP_CONN_RECOVER:
+		conn->state = ISCSI_CONN_FAILED;
+		break;
+	case STOP_CONN_TERM:
+		conn->state = ISCSI_CONN_DOWN;
+		break;
+	default:
+		iscsi_cls_conn_printk(KERN_ERR, conn, "invalid stop flag %d\n",
+				      flag);
+		return;
+	}
+
+	conn->transport->stop_conn(conn, flag);
+	ISCSI_DBG_TRANS_CONN(conn, "Stopping conn done.\n");
+}
+
+static int iscsi_if_stop_conn(struct iscsi_transport *transport,
+			      struct iscsi_uevent *ev)
+{
+	int flag = ev->u.stop_conn.flag;
+	struct iscsi_cls_conn *conn;
+
+	conn = iscsi_conn_lookup(ev->u.stop_conn.sid, ev->u.stop_conn.cid);
+	if (!conn)
+		return -EINVAL;
+
+	ISCSI_DBG_TRANS_CONN(conn, "iscsi if conn stop.\n");
+	/*
+	 * If this is a termination we have to call stop_conn with that flag
+	 * so the correct states get set. If we haven't run the work yet try to
+	 * avoid the extra run.
+	 */
+	if (flag == STOP_CONN_TERM) {
+		cancel_work_sync(&conn->cleanup_work);
+		iscsi_stop_conn(conn, flag);
+	} else {
+		/*
+		 * Figure out if it was the kernel or userspace initiating this.
+		 */
+		if (!test_and_set_bit(ISCSI_CLS_CONN_BIT_CLEANUP, &conn->flags)) {
+			iscsi_stop_conn(conn, flag);
+		} else {
+			ISCSI_DBG_TRANS_CONN(conn,
+					     "flush kernel conn cleanup.\n");
+			flush_work(&conn->cleanup_work);
+		}
+		/*
+		 * Only clear for recovery to avoid extra cleanup runs during
+		 * termination.
+		 */
+		clear_bit(ISCSI_CLS_CONN_BIT_CLEANUP, &conn->flags);
+	}
+	ISCSI_DBG_TRANS_CONN(conn, "iscsi if conn stop done.\n");
+	return 0;
+}
+
+static void iscsi_ep_disconnect(struct iscsi_cls_conn *conn, bool is_active)
+{
+	struct iscsi_cls_session *session = iscsi_conn_to_session(conn);
+	struct iscsi_endpoint *ep;
+
+	ISCSI_DBG_TRANS_CONN(conn, "disconnect ep.\n");
+	conn->state = ISCSI_CONN_FAILED;
+
+	if (!conn->ep || !session->transport->ep_disconnect)
+		return;
+
+	ep = conn->ep;
+	conn->ep = NULL;
+
+	session->transport->unbind_conn(conn, is_active);
+	session->transport->ep_disconnect(ep);
+	ISCSI_DBG_TRANS_CONN(conn, "disconnect ep done.\n");
+}
+
+static void iscsi_cleanup_conn_work_fn(struct work_struct *work)
+{
+	struct iscsi_cls_conn *conn = container_of(work, struct iscsi_cls_conn,
+						   cleanup_work);
+	struct iscsi_cls_session *session = iscsi_conn_to_session(conn);
+
+	mutex_lock(&conn->ep_mutex);
+	/*
+	 * If we are not at least bound there is nothing for us to do. Userspace
+	 * will do a ep_disconnect call if offload is used, but will not be
+	 * doing a stop since there is nothing to clean up, so we have to clear
+	 * the cleanup bit here.
+	 */
+	if (conn->state != ISCSI_CONN_BOUND && conn->state != ISCSI_CONN_UP) {
+		ISCSI_DBG_TRANS_CONN(conn, "Got error while conn is already failed. Ignoring.\n");
+		clear_bit(ISCSI_CLS_CONN_BIT_CLEANUP, &conn->flags);
+		mutex_unlock(&conn->ep_mutex);
+		return;
+	}
+
+	iscsi_ep_disconnect(conn, false);
+
+	if (system_state != SYSTEM_RUNNING) {
+		/*
+		 * If the user has set up for the session to never timeout
+		 * then hang like they wanted. For all other cases fail right
+		 * away since userspace is not going to relogin.
+		 */
+		if (session->recovery_tmo > 0)
+			session->recovery_tmo = 0;
+	}
+
+	iscsi_stop_conn(conn, STOP_CONN_RECOVER);
+	mutex_unlock(&conn->ep_mutex);
+	ISCSI_DBG_TRANS_CONN(conn, "cleanup done.\n");
+}
+
 void iscsi_free_session(struct iscsi_cls_session *session)
 {
 	ISCSI_DBG_TRANS_SESSION(session, "Freeing session\n");
@@ -2284,7 +2391,7 @@ iscsi_create_conn(struct iscsi_cls_session *session, int dd_size, uint32_t cid)
 
 	mutex_init(&conn->ep_mutex);
 	INIT_LIST_HEAD(&conn->conn_list);
-	INIT_LIST_HEAD(&conn->conn_list_err);
+	INIT_WORK(&conn->cleanup_work, iscsi_cleanup_conn_work_fn);
 	conn->transport = transport;
 	conn->cid = cid;
 	conn->state = ISCSI_CONN_DOWN;
@@ -2341,7 +2448,6 @@ int iscsi_destroy_conn(struct iscsi_cls_conn *conn)
 
 	spin_lock_irqsave(&connlock, flags);
 	list_del(&conn->conn_list);
-	list_del(&conn->conn_list_err);
 	spin_unlock_irqrestore(&connlock, flags);
 
 	transport_unregister_device(&conn->dev);
@@ -2456,83 +2562,6 @@ int iscsi_offload_mesg(struct Scsi_Host *shost,
 }
 EXPORT_SYMBOL_GPL(iscsi_offload_mesg);
 
-/*
- * This can be called without the rx_queue_mutex, if invoked by the kernel
- * stop work. But, in that case, it is guaranteed not to race with
- * iscsi_destroy by conn_mutex.
- */
-static void iscsi_if_stop_conn(struct iscsi_cls_conn *conn, int flag)
-{
-	/*
-	 * It is important that this path doesn't rely on
-	 * rx_queue_mutex, otherwise, a thread doing allocation on a
-	 * start_session/start_connection could sleep waiting on a
-	 * writeback to a failed iscsi device, that cannot be recovered
-	 * because the lock is held.  If we don't hold it here, the
-	 * kernel stop_conn_work_fn has a chance to stop the broken
-	 * session and resolve the allocation.
-	 *
-	 * Still, the user invoked .stop_conn() needs to be serialized
-	 * with stop_conn_work_fn by a private mutex.  Not pretty, but
-	 * it works.
-	 */
-	mutex_lock(&conn_mutex);
-	switch (flag) {
-	case STOP_CONN_RECOVER:
-		conn->state = ISCSI_CONN_FAILED;
-		break;
-	case STOP_CONN_TERM:
-		conn->state = ISCSI_CONN_DOWN;
-		break;
-	default:
-		iscsi_cls_conn_printk(KERN_ERR, conn,
-				      "invalid stop flag %d\n", flag);
-		goto unlock;
-	}
-
-	conn->transport->stop_conn(conn, flag);
-unlock:
-	mutex_unlock(&conn_mutex);
-}
-
-static void stop_conn_work_fn(struct work_struct *work)
-{
-	struct iscsi_cls_conn *conn, *tmp;
-	unsigned long flags;
-	LIST_HEAD(recovery_list);
-
-	spin_lock_irqsave(&connlock, flags);
-	if (list_empty(&connlist_err)) {
-		spin_unlock_irqrestore(&connlock, flags);
-		return;
-	}
-	list_splice_init(&connlist_err, &recovery_list);
-	spin_unlock_irqrestore(&connlock, flags);
-
-	list_for_each_entry_safe(conn, tmp, &recovery_list, conn_list_err) {
-		uint32_t sid = iscsi_conn_get_sid(conn);
-		struct iscsi_cls_session *session;
-
-		session = iscsi_session_lookup(sid);
-		if (session) {
-			if (system_state != SYSTEM_RUNNING) {
-				/*
-				 * If the user has set up for the session to
-				 * never timeout then hang like they wanted.
-				 * For all other cases fail right away since
-				 * userspace is not going to relogin.
-				 */
-				if (session->recovery_tmo > 0)
-					session->recovery_tmo = 0;
-			}
-
-			iscsi_if_stop_conn(conn, STOP_CONN_RECOVER);
-		}
-
-		list_del_init(&conn->conn_list_err);
-	}
-}
-
 void iscsi_conn_error_event(struct iscsi_cls_conn *conn, enum iscsi_err error)
 {
 	struct nlmsghdr	*nlh;
@@ -2540,12 +2569,9 @@ void iscsi_conn_error_event(struct iscsi_cls_conn *conn, enum iscsi_err error)
 	struct iscsi_uevent *ev;
 	struct iscsi_internal *priv;
 	int len = nlmsg_total_size(sizeof(*ev));
-	unsigned long flags;
 
-	spin_lock_irqsave(&connlock, flags);
-	list_add(&conn->conn_list_err, &connlist_err);
-	spin_unlock_irqrestore(&connlock, flags);
-	queue_work(system_unbound_wq, &stop_conn_work);
+	if (!test_and_set_bit(ISCSI_CLS_CONN_BIT_CLEANUP, &conn->flags))
+		queue_work(iscsi_conn_cleanup_workq, &conn->cleanup_work);
 
 	priv = iscsi_if_transport_lookup(conn->transport);
 	if (!priv)
@@ -2875,26 +2901,17 @@ static int
 iscsi_if_destroy_conn(struct iscsi_transport *transport, struct iscsi_uevent *ev)
 {
 	struct iscsi_cls_conn *conn;
-	unsigned long flags;
 
 	conn = iscsi_conn_lookup(ev->u.d_conn.sid, ev->u.d_conn.cid);
 	if (!conn)
 		return -EINVAL;
 
-	spin_lock_irqsave(&connlock, flags);
-	if (!list_empty(&conn->conn_list_err)) {
-		spin_unlock_irqrestore(&connlock, flags);
-		return -EAGAIN;
-	}
-	spin_unlock_irqrestore(&connlock, flags);
-
+	ISCSI_DBG_TRANS_CONN(conn, "Flushing cleanup during destruction\n");
+	flush_work(&conn->cleanup_work);
 	ISCSI_DBG_TRANS_CONN(conn, "Destroying transport conn\n");
 
-	mutex_lock(&conn_mutex);
 	if (transport->destroy_conn)
 		transport->destroy_conn(conn);
-	mutex_unlock(&conn_mutex);
-
 	return 0;
 }
 
@@ -2973,7 +2990,7 @@ release_host:
 }
 
 static int iscsi_if_ep_disconnect(struct iscsi_transport *transport,
-				  u64 ep_handle, bool is_active)
+				  u64 ep_handle)
 {
 	struct iscsi_cls_conn *conn;
 	struct iscsi_endpoint *ep;
@@ -2984,17 +3001,30 @@ static int iscsi_if_ep_disconnect(struct iscsi_transport *transport,
 	ep = iscsi_lookup_endpoint(ep_handle);
 	if (!ep)
 		return -EINVAL;
+
 	conn = ep->conn;
-	if (conn) {
-		mutex_lock(&conn->ep_mutex);
-		conn->ep = NULL;
+	if (!conn) {
+		/*
+		 * conn was not even bound yet, so we can't get iscsi conn
+		 * failures yet.
+		 */
+		transport->ep_disconnect(ep);
+		goto put_ep;
+	}
+
+	mutex_lock(&conn->ep_mutex);
+	/* Check if this was a conn error and the kernel took ownership */
+	if (test_bit(ISCSI_CLS_CONN_BIT_CLEANUP, &conn->flags)) {
+		ISCSI_DBG_TRANS_CONN(conn, "flush kernel conn cleanup.\n");
 		mutex_unlock(&conn->ep_mutex);
-		conn->state = ISCSI_CONN_FAILED;
 
-		transport->unbind_conn(conn, is_active);
+		flush_work(&conn->cleanup_work);
+		goto put_ep;
 	}
 
-	transport->ep_disconnect(ep);
+	iscsi_ep_disconnect(conn, false);
+	mutex_unlock(&conn->ep_mutex);
+put_ep:
 	iscsi_put_endpoint(ep);
 	return 0;
 }
@@ -3025,8 +3055,7 @@ iscsi_if_transport_ep(struct iscsi_transport *transport,
 		break;
 	case ISCSI_UEVENT_TRANSPORT_EP_DISCONNECT:
 		rc = iscsi_if_ep_disconnect(transport,
-					    ev->u.ep_disconnect.ep_handle,
-					    false);
+					    ev->u.ep_disconnect.ep_handle);
 		break;
 	}
 	return rc;
@@ -3653,18 +3682,129 @@ exit_host_stats:
 	return err;
 }
 
+static int iscsi_if_transport_conn(struct iscsi_transport *transport,
+				   struct nlmsghdr *nlh)
+{
+	struct iscsi_uevent *ev = nlmsg_data(nlh);
+	struct iscsi_cls_session *session;
+	struct iscsi_cls_conn *conn = NULL;
+	struct iscsi_endpoint *ep;
+	uint32_t pdu_len;
+	int err = 0;
+
+	switch (nlh->nlmsg_type) {
+	case ISCSI_UEVENT_CREATE_CONN:
+		return iscsi_if_create_conn(transport, ev);
+	case ISCSI_UEVENT_DESTROY_CONN:
+		return iscsi_if_destroy_conn(transport, ev);
+	case ISCSI_UEVENT_STOP_CONN:
+		return iscsi_if_stop_conn(transport, ev);
+	}
+
+	/*
+	 * The following cmds need to be run under the ep_mutex so in kernel
+	 * conn cleanup (ep_disconnect + unbind and conn) is not done while
+	 * these are running. They also must not run if we have just run a conn
+	 * cleanup because they would set the state in a way that might allow
+	 * IO or send IO themselves.
+	 */
+	switch (nlh->nlmsg_type) {
+	case ISCSI_UEVENT_START_CONN:
+		conn = iscsi_conn_lookup(ev->u.start_conn.sid,
+					 ev->u.start_conn.cid);
+		break;
+	case ISCSI_UEVENT_BIND_CONN:
+		conn = iscsi_conn_lookup(ev->u.b_conn.sid, ev->u.b_conn.cid);
+		break;
+	case ISCSI_UEVENT_SEND_PDU:
+		conn = iscsi_conn_lookup(ev->u.send_pdu.sid, ev->u.send_pdu.cid);
+		break;
+	}
+
+	if (!conn)
+		return -EINVAL;
+
+	mutex_lock(&conn->ep_mutex);
+	if (test_bit(ISCSI_CLS_CONN_BIT_CLEANUP, &conn->flags)) {
+		mutex_unlock(&conn->ep_mutex);
+		ev->r.retcode = -ENOTCONN;
+		return 0;
+	}
+
+	switch (nlh->nlmsg_type) {
+	case ISCSI_UEVENT_BIND_CONN:
+		if (conn->ep) {
+			/*
+			 * For offload boot support where iscsid is restarted
+			 * during the pivot root stage, the ep will be intact
+			 * here when the new iscsid instance starts up and
+			 * reconnects.
+			 */
+			iscsi_ep_disconnect(conn, true);
+		}
+
+		session = iscsi_session_lookup(ev->u.b_conn.sid);
+		if (!session) {
+			err = -EINVAL;
+			break;
+		}
+
+		ev->r.retcode =	transport->bind_conn(session, conn,
+						ev->u.b_conn.transport_eph,
+						ev->u.b_conn.is_leading);
+		if (!ev->r.retcode)
+			conn->state = ISCSI_CONN_BOUND;
+
+		if (ev->r.retcode || !transport->ep_connect)
+			break;
+
+		ep = iscsi_lookup_endpoint(ev->u.b_conn.transport_eph);
+		if (ep) {
+			ep->conn = conn;
+			conn->ep = ep;
+			iscsi_put_endpoint(ep);
+		} else {
+			err = -ENOTCONN;
+			iscsi_cls_conn_printk(KERN_ERR, conn,
+					      "Could not set ep conn binding\n");
+		}
+		break;
+	case ISCSI_UEVENT_START_CONN:
+		ev->r.retcode = transport->start_conn(conn);
+		if (!ev->r.retcode)
+			conn->state = ISCSI_CONN_UP;
+		break;
+	case ISCSI_UEVENT_SEND_PDU:
+		pdu_len = nlh->nlmsg_len - sizeof(*nlh) - sizeof(*ev);
+
+		if ((ev->u.send_pdu.hdr_size > pdu_len) ||
+		    (ev->u.send_pdu.data_size > (pdu_len - ev->u.send_pdu.hdr_size))) {
+			err = -EINVAL;
+			break;
+		}
+
+		ev->r.retcode =	transport->send_pdu(conn,
+				(struct iscsi_hdr *)((char *)ev + sizeof(*ev)),
+				(char *)ev + sizeof(*ev) + ev->u.send_pdu.hdr_size,
+				ev->u.send_pdu.data_size);
+		break;
+	default:
+		err = -ENOSYS;
+	}
+
+	mutex_unlock(&conn->ep_mutex);
+	return err;
+}
 
 static int
 iscsi_if_recv_msg(struct sk_buff *skb, struct nlmsghdr *nlh, uint32_t *group)
 {
 	int err = 0;
 	u32 portid;
-	u32 pdu_len;
 	struct iscsi_uevent *ev = nlmsg_data(nlh);
 	struct iscsi_transport *transport = NULL;
 	struct iscsi_internal *priv;
 	struct iscsi_cls_session *session;
-	struct iscsi_cls_conn *conn;
 	struct iscsi_endpoint *ep = NULL;
 
 	if (!netlink_capable(skb, CAP_SYS_ADMIN))
@@ -3741,90 +3881,16 @@ iscsi_if_recv_msg(struct sk_buff *skb, struct nlmsghdr *nlh, uint32_t *group)
 		else
 			err = -EINVAL;
 		break;
-	case ISCSI_UEVENT_CREATE_CONN:
-		err = iscsi_if_create_conn(transport, ev);
-		break;
-	case ISCSI_UEVENT_DESTROY_CONN:
-		err = iscsi_if_destroy_conn(transport, ev);
-		break;
-	case ISCSI_UEVENT_BIND_CONN:
-		session = iscsi_session_lookup(ev->u.b_conn.sid);
-		conn = iscsi_conn_lookup(ev->u.b_conn.sid, ev->u.b_conn.cid);
-
-		if (conn && conn->ep)
-			iscsi_if_ep_disconnect(transport, conn->ep->id, true);
-
-		if (!session || !conn) {
-			err = -EINVAL;
-			break;
-		}
-
-		mutex_lock(&conn_mutex);
-		ev->r.retcode =	transport->bind_conn(session, conn,
-						ev->u.b_conn.transport_eph,
-						ev->u.b_conn.is_leading);
-		if (!ev->r.retcode)
-			conn->state = ISCSI_CONN_BOUND;
-		mutex_unlock(&conn_mutex);
-
-		if (ev->r.retcode || !transport->ep_connect)
-			break;
-
-		ep = iscsi_lookup_endpoint(ev->u.b_conn.transport_eph);
-		if (ep) {
-			ep->conn = conn;
-
-			mutex_lock(&conn->ep_mutex);
-			conn->ep = ep;
-			mutex_unlock(&conn->ep_mutex);
-			iscsi_put_endpoint(ep);
-		} else
-			iscsi_cls_conn_printk(KERN_ERR, conn,
-					      "Could not set ep conn "
-					      "binding\n");
-		break;
 	case ISCSI_UEVENT_SET_PARAM:
 		err = iscsi_set_param(transport, ev);
 		break;
-	case ISCSI_UEVENT_START_CONN:
-		conn = iscsi_conn_lookup(ev->u.start_conn.sid, ev->u.start_conn.cid);
-		if (conn) {
-			mutex_lock(&conn_mutex);
-			ev->r.retcode = transport->start_conn(conn);
-			if (!ev->r.retcode)
-				conn->state = ISCSI_CONN_UP;
-			mutex_unlock(&conn_mutex);
-		}
-		else
-			err = -EINVAL;
-		break;
+	case ISCSI_UEVENT_CREATE_CONN:
+	case ISCSI_UEVENT_DESTROY_CONN:
 	case ISCSI_UEVENT_STOP_CONN:
-		conn = iscsi_conn_lookup(ev->u.stop_conn.sid, ev->u.stop_conn.cid);
-		if (conn)
-			iscsi_if_stop_conn(conn, ev->u.stop_conn.flag);
-		else
-			err = -EINVAL;
-		break;
+	case ISCSI_UEVENT_START_CONN:
+	case ISCSI_UEVENT_BIND_CONN:
 	case ISCSI_UEVENT_SEND_PDU:
-		pdu_len = nlh->nlmsg_len - sizeof(*nlh) - sizeof(*ev);
-
-		if ((ev->u.send_pdu.hdr_size > pdu_len) ||
-		    (ev->u.send_pdu.data_size > (pdu_len - ev->u.send_pdu.hdr_size))) {
-			err = -EINVAL;
-			break;
-		}
-
-		conn = iscsi_conn_lookup(ev->u.send_pdu.sid, ev->u.send_pdu.cid);
-		if (conn) {
-			mutex_lock(&conn_mutex);
-			ev->r.retcode =	transport->send_pdu(conn,
-				(struct iscsi_hdr*)((char*)ev + sizeof(*ev)),
-				(char*)ev + sizeof(*ev) + ev->u.send_pdu.hdr_size,
-				ev->u.send_pdu.data_size);
-			mutex_unlock(&conn_mutex);
-		}
-		else
-			err = -EINVAL;
+		err = iscsi_if_transport_conn(transport, nlh);
 		break;
 	case ISCSI_UEVENT_GET_STATS:
 		err = iscsi_if_get_stats(transport, nlh);
@@ -4827,8 +4893,18 @@ static __init int iscsi_transport_init(void)
 		goto release_nls;
 	}
 
+	iscsi_conn_cleanup_workq = alloc_workqueue("%s",
+			WQ_SYSFS | WQ_MEM_RECLAIM | WQ_UNBOUND, 0,
+			"iscsi_conn_cleanup");
+	if (!iscsi_conn_cleanup_workq) {
+		err = -ENOMEM;
+		goto destroy_wq;
+	}
+
 	return 0;
 
+destroy_wq:
+	destroy_workqueue(iscsi_eh_timer_workq);
 release_nls:
 	netlink_kernel_release(nls);
 unregister_flashnode_bus:
@@ -4850,6 +4926,7 @@ unregister_transport_class:
 
 static void __exit iscsi_transport_exit(void)
 {
+	destroy_workqueue(iscsi_conn_cleanup_workq);
 	destroy_workqueue(iscsi_eh_timer_workq);
 	netlink_kernel_release(nls);
 	bus_unregister(&iscsi_flashnode_bus);
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index d36a72cf049f..3974329d4d02 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -197,15 +197,23 @@ enum iscsi_connection_state {
 	ISCSI_CONN_BOUND,
 };
 
+#define ISCSI_CLS_CONN_BIT_CLEANUP	1
+
 struct iscsi_cls_conn {
 	struct list_head conn_list;	/* item in connlist */
-	struct list_head conn_list_err;	/* item in connlist_err */
 	void *dd_data;			/* LLD private data */
 	struct iscsi_transport *transport;
 	uint32_t cid;			/* connection id */
+	/*
+	 * This protects the conn startup and binding/unbinding of the ep to
+	 * the conn. Unbinding includes ep_disconnect and stop_conn.
+	 */
 	struct mutex ep_mutex;
 	struct iscsi_endpoint *ep;
 
+	unsigned long flags;
+	struct work_struct cleanup_work;
+
 	struct device dev;		/* sysfs transport/container device */
 	enum iscsi_connection_state state;
 };
-- 
2.30.2



