Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A79961EFA8B
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 16:19:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728666AbgFEOSg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 10:18:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:49074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728683AbgFEOSe (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Jun 2020 10:18:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1401E2086A;
        Fri,  5 Jun 2020 14:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591366712;
        bh=fY6oFOzSvFPseYsbfMLfeDUn+jVaEvrxH5t+3dkJnN8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p4lWT3TWOQeV0SkAV3m5Rl27iDdXnNjkOWv7jPkIW9mPW8CNGmD7khFCgfbwNyfFg
         A74roKeqz2keT8U9+j/wBuP9YZ9S5Q0PB7RgUamG+vVSFEIetI3aqzwb0ZpZit7WXk
         PZ5NcO3tOPth93sJYJM3pyNhH5fQHJAyWC1fIhWk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Ariel Elior <ariel.elior@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 23/38] RDMA/qedr: Fix synchronization methods and memory leaks in qedr
Date:   Fri,  5 Jun 2020 16:15:06 +0200
Message-Id: <20200605140253.951283829@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200605140252.542768750@linuxfoundation.org>
References: <20200605140252.542768750@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michal Kalderon <michal.kalderon@marvell.com>

[ Upstream commit 82af6d19d8d9227c22a53ff00b40fb2a4f9fce69 ]

Re-design of the iWARP CM related objects reference counting and
synchronization methods, to ensure operations are synchronized correctly
and that memory allocated for "ep" is properly released. Also makes sure
QP memory is not released before ep is finished accessing it.

Where as the QP object is created/destroyed by external operations, the ep
is created/destroyed by internal operations and represents the tcp
connection associated with the QP.

QP destruction flow:
- needs to wait for ep establishment to complete (either successfully or
  with error)
- needs to wait for ep disconnect to be fully posted to avoid a race
  condition of disconnect being called after reset.
- both the operations above don't always happen, so we use atomic flags to
  indicate whether the qp destruction flow needs to wait for these
  completions or not, if the destroy is called before these operations
  began, the flows will check the flags and not execute them ( connect /
  disconnect).

We use completion structure for waiting for the completions mentioned
above.

The QP refcnt was modified to kref object.  The EP has a kref added to it
to handle additional worker thread accessing it.

Memory Leaks - https://www.spinics.net/lists/linux-rdma/msg83762.html

Concurrency not managed correctly -
https://www.spinics.net/lists/linux-rdma/msg67949.html

Fixes: de0089e692a9 ("RDMA/qedr: Add iWARP connection management qp related callbacks")
Link: https://lore.kernel.org/r/20191027200451.28187-4-michal.kalderon@marvell.com
Reported-by: Chuck Lever <chuck.lever@oracle.com>
Reported-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Ariel Elior <ariel.elior@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/qedr/qedr.h       |  23 +++-
 drivers/infiniband/hw/qedr/qedr_iw_cm.c | 148 ++++++++++++++++--------
 drivers/infiniband/hw/qedr/verbs.c      |  62 ++++++----
 3 files changed, 158 insertions(+), 75 deletions(-)

diff --git a/drivers/infiniband/hw/qedr/qedr.h b/drivers/infiniband/hw/qedr/qedr.h
index 0cfd849b13d6..8e927f6c1520 100644
--- a/drivers/infiniband/hw/qedr/qedr.h
+++ b/drivers/infiniband/hw/qedr/qedr.h
@@ -40,6 +40,7 @@
 #include <linux/qed/qed_rdma_if.h>
 #include <linux/qed/qede_rdma.h>
 #include <linux/qed/roce_common.h>
+#include <linux/completion.h>
 #include "qedr_hsi_rdma.h"
 
 #define QEDR_NODE_DESC "QLogic 579xx RoCE HCA"
@@ -377,10 +378,20 @@ enum qedr_qp_err_bitmap {
 	QEDR_QP_ERR_RQ_PBL_FULL = 32,
 };
 
+enum qedr_qp_create_type {
+	QEDR_QP_CREATE_NONE,
+	QEDR_QP_CREATE_USER,
+	QEDR_QP_CREATE_KERNEL,
+};
+
+enum qedr_iwarp_cm_flags {
+	QEDR_IWARP_CM_WAIT_FOR_CONNECT    = BIT(0),
+	QEDR_IWARP_CM_WAIT_FOR_DISCONNECT = BIT(1),
+};
+
 struct qedr_qp {
 	struct ib_qp ibqp;	/* must be first */
 	struct qedr_dev *dev;
-	struct qedr_iw_ep *ep;
 	struct qedr_qp_hwq_info sq;
 	struct qedr_qp_hwq_info rq;
 
@@ -395,6 +406,7 @@ struct qedr_qp {
 	u32 id;
 	struct qedr_pd *pd;
 	enum ib_qp_type qp_type;
+	enum qedr_qp_create_type create_type;
 	struct qed_rdma_qp *qed_qp;
 	u32 qp_id;
 	u16 icid;
@@ -437,8 +449,11 @@ struct qedr_qp {
 	/* Relevant to qps created from user space only (applications) */
 	struct qedr_userq usq;
 	struct qedr_userq urq;
-	atomic_t refcnt;
-	bool destroyed;
+
+	/* synchronization objects used with iwarp ep */
+	struct kref refcnt;
+	struct completion iwarp_cm_comp;
+	unsigned long iwarp_cm_flags; /* enum iwarp_cm_flags */
 };
 
 struct qedr_ah {
@@ -531,7 +546,7 @@ struct qedr_iw_ep {
 	struct iw_cm_id	*cm_id;
 	struct qedr_qp	*qp;
 	void		*qed_context;
-	u8		during_connect;
+	struct kref	refcnt;
 };
 
 static inline
diff --git a/drivers/infiniband/hw/qedr/qedr_iw_cm.c b/drivers/infiniband/hw/qedr/qedr_iw_cm.c
index 7fea74739c1f..5e9732990be5 100644
--- a/drivers/infiniband/hw/qedr/qedr_iw_cm.c
+++ b/drivers/infiniband/hw/qedr/qedr_iw_cm.c
@@ -79,6 +79,27 @@ qedr_fill_sockaddr6(const struct qed_iwarp_cm_info *cm_info,
 	}
 }
 
+static void qedr_iw_free_qp(struct kref *ref)
+{
+	struct qedr_qp *qp = container_of(ref, struct qedr_qp, refcnt);
+
+	kfree(qp);
+}
+
+static void
+qedr_iw_free_ep(struct kref *ref)
+{
+	struct qedr_iw_ep *ep = container_of(ref, struct qedr_iw_ep, refcnt);
+
+	if (ep->qp)
+		kref_put(&ep->qp->refcnt, qedr_iw_free_qp);
+
+	if (ep->cm_id)
+		ep->cm_id->rem_ref(ep->cm_id);
+
+	kfree(ep);
+}
+
 static void
 qedr_iw_mpa_request(void *context, struct qed_iwarp_cm_event_params *params)
 {
@@ -93,6 +114,7 @@ qedr_iw_mpa_request(void *context, struct qed_iwarp_cm_event_params *params)
 
 	ep->dev = dev;
 	ep->qed_context = params->ep_context;
+	kref_init(&ep->refcnt);
 
 	memset(&event, 0, sizeof(event));
 	event.event = IW_CM_EVENT_CONNECT_REQUEST;
@@ -141,12 +163,10 @@ qedr_iw_close_event(void *context, struct qed_iwarp_cm_event_params *params)
 {
 	struct qedr_iw_ep *ep = (struct qedr_iw_ep *)context;
 
-	if (ep->cm_id) {
+	if (ep->cm_id)
 		qedr_iw_issue_event(context, params, IW_CM_EVENT_CLOSE);
 
-		ep->cm_id->rem_ref(ep->cm_id);
-		ep->cm_id = NULL;
-	}
+	kref_put(&ep->refcnt, qedr_iw_free_ep);
 }
 
 static void
@@ -186,11 +206,13 @@ static void qedr_iw_disconnect_worker(struct work_struct *work)
 	struct qedr_qp *qp = ep->qp;
 	struct iw_cm_event event;
 
-	if (qp->destroyed) {
-		kfree(dwork);
-		qedr_iw_qp_rem_ref(&qp->ibqp);
-		return;
-	}
+	/* The qp won't be released until we release the ep.
+	 * the ep's refcnt was increased before calling this
+	 * function, therefore it is safe to access qp
+	 */
+	if (test_and_set_bit(QEDR_IWARP_CM_WAIT_FOR_DISCONNECT,
+			     &qp->iwarp_cm_flags))
+		goto out;
 
 	memset(&event, 0, sizeof(event));
 	event.status = dwork->status;
@@ -204,7 +226,6 @@ static void qedr_iw_disconnect_worker(struct work_struct *work)
 	else
 		qp_params.new_state = QED_ROCE_QP_STATE_SQD;
 
-	kfree(dwork);
 
 	if (ep->cm_id)
 		ep->cm_id->event_handler(ep->cm_id, &event);
@@ -214,7 +235,10 @@ static void qedr_iw_disconnect_worker(struct work_struct *work)
 
 	dev->ops->rdma_modify_qp(dev->rdma_ctx, qp->qed_qp, &qp_params);
 
-	qedr_iw_qp_rem_ref(&qp->ibqp);
+	complete(&ep->qp->iwarp_cm_comp);
+out:
+	kfree(dwork);
+	kref_put(&ep->refcnt, qedr_iw_free_ep);
 }
 
 static void
@@ -224,13 +248,17 @@ qedr_iw_disconnect_event(void *context,
 	struct qedr_discon_work *work;
 	struct qedr_iw_ep *ep = (struct qedr_iw_ep *)context;
 	struct qedr_dev *dev = ep->dev;
-	struct qedr_qp *qp = ep->qp;
 
 	work = kzalloc(sizeof(*work), GFP_ATOMIC);
 	if (!work)
 		return;
 
-	qedr_iw_qp_add_ref(&qp->ibqp);
+	/* We can't get a close event before disconnect, but since
+	 * we're scheduling a work queue we need to make sure close
+	 * won't delete the ep, so we increase the refcnt
+	 */
+	kref_get(&ep->refcnt);
+
 	work->ep = ep;
 	work->event = params->event;
 	work->status = params->status;
@@ -252,16 +280,30 @@ qedr_iw_passive_complete(void *context,
 	if ((params->status == -ECONNREFUSED) && (!ep->qp)) {
 		DP_DEBUG(dev, QEDR_MSG_IWARP,
 			 "PASSIVE connection refused releasing ep...\n");
-		kfree(ep);
+		kref_put(&ep->refcnt, qedr_iw_free_ep);
 		return;
 	}
 
+	complete(&ep->qp->iwarp_cm_comp);
 	qedr_iw_issue_event(context, params, IW_CM_EVENT_ESTABLISHED);
 
 	if (params->status < 0)
 		qedr_iw_close_event(context, params);
 }
 
+static void
+qedr_iw_active_complete(void *context,
+			struct qed_iwarp_cm_event_params *params)
+{
+	struct qedr_iw_ep *ep = (struct qedr_iw_ep *)context;
+
+	complete(&ep->qp->iwarp_cm_comp);
+	qedr_iw_issue_event(context, params, IW_CM_EVENT_CONNECT_REPLY);
+
+	if (params->status < 0)
+		kref_put(&ep->refcnt, qedr_iw_free_ep);
+}
+
 static int
 qedr_iw_mpa_reply(void *context, struct qed_iwarp_cm_event_params *params)
 {
@@ -288,27 +330,15 @@ qedr_iw_event_handler(void *context, struct qed_iwarp_cm_event_params *params)
 		qedr_iw_mpa_reply(context, params);
 		break;
 	case QED_IWARP_EVENT_PASSIVE_COMPLETE:
-		ep->during_connect = 0;
 		qedr_iw_passive_complete(context, params);
 		break;
-
 	case QED_IWARP_EVENT_ACTIVE_COMPLETE:
-		ep->during_connect = 0;
-		qedr_iw_issue_event(context,
-				    params,
-				    IW_CM_EVENT_CONNECT_REPLY);
-		if (params->status < 0) {
-			struct qedr_iw_ep *ep = (struct qedr_iw_ep *)context;
-
-			ep->cm_id->rem_ref(ep->cm_id);
-			ep->cm_id = NULL;
-		}
+		qedr_iw_active_complete(context, params);
 		break;
 	case QED_IWARP_EVENT_DISCONNECT:
 		qedr_iw_disconnect_event(context, params);
 		break;
 	case QED_IWARP_EVENT_CLOSE:
-		ep->during_connect = 0;
 		qedr_iw_close_event(context, params);
 		break;
 	case QED_IWARP_EVENT_RQ_EMPTY:
@@ -476,6 +506,19 @@ qedr_addr6_resolve(struct qedr_dev *dev,
 	return rc;
 }
 
+struct qedr_qp *qedr_iw_load_qp(struct qedr_dev *dev, u32 qpn)
+{
+	struct qedr_qp *qp;
+
+	xa_lock(&dev->qps);
+	qp = xa_load(&dev->qps, qpn);
+	if (qp)
+		kref_get(&qp->refcnt);
+	xa_unlock(&dev->qps);
+
+	return qp;
+}
+
 int qedr_iw_connect(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 {
 	struct qedr_dev *dev = get_qedr_dev(cm_id->device);
@@ -491,10 +534,6 @@ int qedr_iw_connect(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 	int rc = 0;
 	int i;
 
-	qp = xa_load(&dev->qps, conn_param->qpn);
-	if (unlikely(!qp))
-		return -EINVAL;
-
 	laddr = (struct sockaddr_in *)&cm_id->m_local_addr;
 	raddr = (struct sockaddr_in *)&cm_id->m_remote_addr;
 	laddr6 = (struct sockaddr_in6 *)&cm_id->m_local_addr;
@@ -516,8 +555,15 @@ int qedr_iw_connect(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 		return -ENOMEM;
 
 	ep->dev = dev;
+	kref_init(&ep->refcnt);
+
+	qp = qedr_iw_load_qp(dev, conn_param->qpn);
+	if (!qp) {
+		rc = -EINVAL;
+		goto err;
+	}
+
 	ep->qp = qp;
-	qp->ep = ep;
 	cm_id->add_ref(cm_id);
 	ep->cm_id = cm_id;
 
@@ -580,16 +626,20 @@ int qedr_iw_connect(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 	in_params.qp = qp->qed_qp;
 	memcpy(in_params.local_mac_addr, dev->ndev->dev_addr, ETH_ALEN);
 
-	ep->during_connect = 1;
+	if (test_and_set_bit(QEDR_IWARP_CM_WAIT_FOR_CONNECT,
+			     &qp->iwarp_cm_flags))
+		goto err; /* QP already being destroyed */
+
 	rc = dev->ops->iwarp_connect(dev->rdma_ctx, &in_params, &out_params);
-	if (rc)
+	if (rc) {
+		complete(&qp->iwarp_cm_comp);
 		goto err;
+	}
 
 	return rc;
 
 err:
-	cm_id->rem_ref(cm_id);
-	kfree(ep);
+	kref_put(&ep->refcnt, qedr_iw_free_ep);
 	return rc;
 }
 
@@ -677,18 +727,17 @@ int qedr_iw_accept(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 	struct qedr_dev *dev = ep->dev;
 	struct qedr_qp *qp;
 	struct qed_iwarp_accept_in params;
-	int rc;
+	int rc = 0;
 
 	DP_DEBUG(dev, QEDR_MSG_IWARP, "Accept on qpid=%d\n", conn_param->qpn);
 
-	qp = xa_load(&dev->qps, conn_param->qpn);
+	qp = qedr_iw_load_qp(dev, conn_param->qpn);
 	if (!qp) {
 		DP_ERR(dev, "Invalid QP number %d\n", conn_param->qpn);
 		return -EINVAL;
 	}
 
 	ep->qp = qp;
-	qp->ep = ep;
 	cm_id->add_ref(cm_id);
 	ep->cm_id = cm_id;
 
@@ -700,15 +749,21 @@ int qedr_iw_accept(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 	params.ird = conn_param->ird;
 	params.ord = conn_param->ord;
 
-	ep->during_connect = 1;
+	if (test_and_set_bit(QEDR_IWARP_CM_WAIT_FOR_CONNECT,
+			     &qp->iwarp_cm_flags))
+		goto err; /* QP already destroyed */
+
 	rc = dev->ops->iwarp_accept(dev->rdma_ctx, &params);
-	if (rc)
+	if (rc) {
+		complete(&qp->iwarp_cm_comp);
 		goto err;
+	}
 
 	return rc;
+
 err:
-	ep->during_connect = 0;
-	cm_id->rem_ref(cm_id);
+	kref_put(&ep->refcnt, qedr_iw_free_ep);
+
 	return rc;
 }
 
@@ -731,17 +786,14 @@ void qedr_iw_qp_add_ref(struct ib_qp *ibqp)
 {
 	struct qedr_qp *qp = get_qedr_qp(ibqp);
 
-	atomic_inc(&qp->refcnt);
+	kref_get(&qp->refcnt);
 }
 
 void qedr_iw_qp_rem_ref(struct ib_qp *ibqp)
 {
 	struct qedr_qp *qp = get_qedr_qp(ibqp);
 
-	if (atomic_dec_and_test(&qp->refcnt)) {
-		xa_erase(&qp->dev->qps, qp->qp_id);
-		kfree(qp);
-	}
+	kref_put(&qp->refcnt, qedr_iw_free_qp);
 }
 
 struct ib_qp *qedr_iw_get_qp(struct ib_device *ibdev, int qpn)
diff --git a/drivers/infiniband/hw/qedr/verbs.c b/drivers/infiniband/hw/qedr/verbs.c
index 062165935441..8b4240c1cc76 100644
--- a/drivers/infiniband/hw/qedr/verbs.c
+++ b/drivers/infiniband/hw/qedr/verbs.c
@@ -51,6 +51,7 @@
 #include "verbs.h"
 #include <rdma/qedr-abi.h>
 #include "qedr_roce_cm.h"
+#include "qedr_iw_cm.h"
 
 #define QEDR_SRQ_WQE_ELEM_SIZE	sizeof(union rdma_srq_elm)
 #define	RDMA_MAX_SGE_PER_SRQ	(4)
@@ -1193,7 +1194,10 @@ static void qedr_set_common_qp_params(struct qedr_dev *dev,
 				      struct ib_qp_init_attr *attrs)
 {
 	spin_lock_init(&qp->q_lock);
-	atomic_set(&qp->refcnt, 1);
+	if (rdma_protocol_iwarp(&dev->ibdev, 1)) {
+		kref_init(&qp->refcnt);
+		init_completion(&qp->iwarp_cm_comp);
+	}
 	qp->pd = pd;
 	qp->qp_type = attrs->qp_type;
 	qp->max_inline_data = attrs->cap.max_inline_data;
@@ -1600,6 +1604,7 @@ static int qedr_create_user_qp(struct qedr_dev *dev,
 	int alloc_and_init = rdma_protocol_roce(&dev->ibdev, 1);
 	int rc = -EINVAL;
 
+	qp->create_type = QEDR_QP_CREATE_USER;
 	memset(&ureq, 0, sizeof(ureq));
 	rc = ib_copy_from_udata(&ureq, udata, sizeof(ureq));
 	if (rc) {
@@ -1813,6 +1818,7 @@ static int qedr_create_kernel_qp(struct qedr_dev *dev,
 	u32 n_sq_entries;
 
 	memset(&in_params, 0, sizeof(in_params));
+	qp->create_type = QEDR_QP_CREATE_KERNEL;
 
 	/* A single work request may take up to QEDR_MAX_SQ_WQE_SIZE elements in
 	 * the ring. The ring should allow at least a single WR, even if the
@@ -2445,7 +2451,7 @@ static int qedr_free_qp_resources(struct qedr_dev *dev, struct qedr_qp *qp,
 			return rc;
 	}
 
-	if (udata)
+	if (qp->create_type == QEDR_QP_CREATE_USER)
 		qedr_cleanup_user(dev, qp);
 	else
 		qedr_cleanup_kernel(dev, qp);
@@ -2475,34 +2481,44 @@ int qedr_destroy_qp(struct ib_qp *ibqp, struct ib_udata *udata)
 			qedr_modify_qp(ibqp, &attr, attr_mask, NULL);
 		}
 	} else {
-		/* Wait for the connect/accept to complete */
-		if (qp->ep) {
-			int wait_count = 1;
-
-			while (qp->ep->during_connect) {
-				DP_DEBUG(dev, QEDR_MSG_QP,
-					 "Still in during connect/accept\n");
-
-				msleep(100);
-				if (wait_count++ > 200) {
-					DP_NOTICE(dev,
-						  "during connect timeout\n");
-					break;
-				}
-			}
-		}
+		/* If connection establishment started the WAIT_FOR_CONNECT
+		 * bit will be on and we need to Wait for the establishment
+		 * to complete before destroying the qp.
+		 */
+		if (test_and_set_bit(QEDR_IWARP_CM_WAIT_FOR_CONNECT,
+				     &qp->iwarp_cm_flags))
+			wait_for_completion(&qp->iwarp_cm_comp);
+
+		/* If graceful disconnect started, the WAIT_FOR_DISCONNECT
+		 * bit will be on, and we need to wait for the disconnect to
+		 * complete before continuing. We can use the same completion,
+		 * iwarp_cm_comp, since this is the only place that waits for
+		 * this completion and it is sequential. In addition,
+		 * disconnect can't occur before the connection is fully
+		 * established, therefore if WAIT_FOR_DISCONNECT is on it
+		 * means WAIT_FOR_CONNECT is also on and the completion for
+		 * CONNECT already occurred.
+		 */
+		if (test_and_set_bit(QEDR_IWARP_CM_WAIT_FOR_DISCONNECT,
+				     &qp->iwarp_cm_flags))
+			wait_for_completion(&qp->iwarp_cm_comp);
 	}
 
 	if (qp->qp_type == IB_QPT_GSI)
 		qedr_destroy_gsi_qp(dev);
 
+	/* We need to remove the entry from the xarray before we release the
+	 * qp_id to avoid a race of the qp_id being reallocated and failing
+	 * on xa_insert
+	 */
+	if (rdma_protocol_iwarp(&dev->ibdev, 1))
+		xa_erase(&dev->qps, qp->qp_id);
+
 	qedr_free_qp_resources(dev, qp, udata);
 
-	if (atomic_dec_and_test(&qp->refcnt) &&
-	    rdma_protocol_iwarp(&dev->ibdev, 1)) {
-		xa_erase(&dev->qps, qp->qp_id);
-		kfree(qp);
-	}
+	if (rdma_protocol_iwarp(&dev->ibdev, 1))
+		qedr_iw_qp_rem_ref(&qp->ibqp);
+
 	return 0;
 }
 
-- 
2.25.1



