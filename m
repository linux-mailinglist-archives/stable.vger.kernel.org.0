Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 472153C5545
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:55:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355477AbhGLIJr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 04:09:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:54816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353386AbhGLICE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 04:02:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E8CB5611F1;
        Mon, 12 Jul 2021 07:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076487;
        bh=n14p7IUm5Egr2TzVg7yBQaQ13//UEkzLmkVdiE2I9WA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=owXiTnrB82oc/5ZesaNjWYZQDMNGmAY6/h/xC9mfci3Cac7RL4S3cXkm+YcE+vMeD
         9bvFNDURkzW7dAywbxGlABVWXNtJWvJqFzrTeDDuWDbbIp8X5vajgrrOpXb5uoy4NL
         GCxInry+bXK/a32TYExUc//oPORtaVzKRvMhKvTE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lee Duncan <lduncan@suse.com>,
        Mike Christie <michael.christie@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 665/800] scsi: iscsi: Rel ref after iscsi_lookup_endpoint()
Date:   Mon, 12 Jul 2021 08:11:28 +0200
Message-Id: <20210712061037.690326779@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Christie <michael.christie@oracle.com>

[ Upstream commit 9e5fe1700896c85040943fdc0d3fee0dd3e0d36f ]

Subsequent commits allow the kernel to do ep_disconnect. In that case we
will have to get a proper refcount on the ep so one thread does not delete
it from under another.

Link: https://lore.kernel.org/r/20210525181821.7617-7-michael.christie@oracle.com
Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c |  1 +
 drivers/scsi/be2iscsi/be_iscsi.c         | 19 ++++++++++++------
 drivers/scsi/bnx2i/bnx2i_iscsi.c         | 23 +++++++++++++++-------
 drivers/scsi/cxgbi/libcxgbi.c            | 12 ++++++++----
 drivers/scsi/qedi/qedi_iscsi.c           | 25 +++++++++++++++++-------
 drivers/scsi/qla4xxx/ql4_os.c            |  1 +
 drivers/scsi/scsi_transport_iscsi.c      | 25 ++++++++++++++++--------
 include/scsi/scsi_transport_iscsi.h      |  1 +
 8 files changed, 75 insertions(+), 32 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 6baebcb6d14d..776e46ee95da 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -506,6 +506,7 @@ iscsi_iser_conn_bind(struct iscsi_cls_session *cls_session,
 	iser_conn->iscsi_conn = conn;
 
 out:
+	iscsi_put_endpoint(ep);
 	mutex_unlock(&iser_conn->state_mutex);
 	return error;
 }
diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index 0e935c49b57b..dd419e295184 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -182,6 +182,7 @@ int beiscsi_conn_bind(struct iscsi_cls_session *cls_session,
 	struct beiscsi_endpoint *beiscsi_ep;
 	struct iscsi_endpoint *ep;
 	uint16_t cri_index;
+	int rc = 0;
 
 	ep = iscsi_lookup_endpoint(transport_fd);
 	if (!ep)
@@ -189,15 +190,17 @@ int beiscsi_conn_bind(struct iscsi_cls_session *cls_session,
 
 	beiscsi_ep = ep->dd_data;
 
-	if (iscsi_conn_bind(cls_session, cls_conn, is_leading))
-		return -EINVAL;
+	if (iscsi_conn_bind(cls_session, cls_conn, is_leading)) {
+		rc = -EINVAL;
+		goto put_ep;
+	}
 
 	if (beiscsi_ep->phba != phba) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
 			    "BS_%d : beiscsi_ep->hba=%p not equal to phba=%p\n",
 			    beiscsi_ep->phba, phba);
-
-		return -EEXIST;
+		rc = -EEXIST;
+		goto put_ep;
 	}
 	cri_index = BE_GET_CRI_FROM_CID(beiscsi_ep->ep_cid);
 	if (phba->conn_table[cri_index]) {
@@ -209,7 +212,8 @@ int beiscsi_conn_bind(struct iscsi_cls_session *cls_session,
 				      beiscsi_ep->ep_cid,
 				      beiscsi_conn,
 				      phba->conn_table[cri_index]);
-			return -EINVAL;
+			rc = -EINVAL;
+			goto put_ep;
 		}
 	}
 
@@ -226,7 +230,10 @@ int beiscsi_conn_bind(struct iscsi_cls_session *cls_session,
 		    "BS_%d : cid %d phba->conn_table[%u]=%p\n",
 		    beiscsi_ep->ep_cid, cri_index, beiscsi_conn);
 	phba->conn_table[cri_index] = beiscsi_conn;
-	return 0;
+
+put_ep:
+	iscsi_put_endpoint(ep);
+	return rc;
 }
 
 static int beiscsi_iface_create_ipv4(struct beiscsi_hba *phba)
diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index b6c1da46d582..2ad85c6b99fd 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -1420,17 +1420,23 @@ static int bnx2i_conn_bind(struct iscsi_cls_session *cls_session,
 	 * Forcefully terminate all in progress connection recovery at the
 	 * earliest, either in bind(), send_pdu(LOGIN), or conn_start()
 	 */
-	if (bnx2i_adapter_ready(hba))
-		return -EIO;
+	if (bnx2i_adapter_ready(hba)) {
+		ret_code = -EIO;
+		goto put_ep;
+	}
 
 	bnx2i_ep = ep->dd_data;
 	if ((bnx2i_ep->state == EP_STATE_TCP_FIN_RCVD) ||
-	    (bnx2i_ep->state == EP_STATE_TCP_RST_RCVD))
+	    (bnx2i_ep->state == EP_STATE_TCP_RST_RCVD)) {
 		/* Peer disconnect via' FIN or RST */
-		return -EINVAL;
+		ret_code = -EINVAL;
+		goto put_ep;
+	}
 
-	if (iscsi_conn_bind(cls_session, cls_conn, is_leading))
-		return -EINVAL;
+	if (iscsi_conn_bind(cls_session, cls_conn, is_leading)) {
+		ret_code = -EINVAL;
+		goto put_ep;
+	}
 
 	if (bnx2i_ep->hba != hba) {
 		/* Error - TCP connection does not belong to this device
@@ -1441,7 +1447,8 @@ static int bnx2i_conn_bind(struct iscsi_cls_session *cls_session,
 		iscsi_conn_printk(KERN_ALERT, cls_conn->dd_data,
 				  "belong to hba (%s)\n",
 				  hba->netdev->name);
-		return -EEXIST;
+		ret_code = -EEXIST;
+		goto put_ep;
 	}
 	bnx2i_ep->conn = bnx2i_conn;
 	bnx2i_conn->ep = bnx2i_ep;
@@ -1458,6 +1465,8 @@ static int bnx2i_conn_bind(struct iscsi_cls_session *cls_session,
 		bnx2i_put_rq_buf(bnx2i_conn, 0);
 
 	bnx2i_arm_cq_event_coalescing(bnx2i_conn->ep, CNIC_ARM_CQE);
+put_ep:
+	iscsi_put_endpoint(ep);
 	return ret_code;
 }
 
diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index f078b3c4e083..f6bcae829c29 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -2690,11 +2690,13 @@ int cxgbi_bind_conn(struct iscsi_cls_session *cls_session,
 	err = csk->cdev->csk_ddp_setup_pgidx(csk, csk->tid,
 					     ppm->tformat.pgsz_idx_dflt);
 	if (err < 0)
-		return err;
+		goto put_ep;
 
 	err = iscsi_conn_bind(cls_session, cls_conn, is_leading);
-	if (err)
-		return -EINVAL;
+	if (err) {
+		err = -EINVAL;
+		goto put_ep;
+	}
 
 	/*  calculate the tag idx bits needed for this conn based on cmds_max */
 	cconn->task_idx_bits = (__ilog2_u32(conn->session->cmds_max - 1)) + 1;
@@ -2715,7 +2717,9 @@ int cxgbi_bind_conn(struct iscsi_cls_session *cls_session,
 	/*  init recv engine */
 	iscsi_tcp_hdr_recv_prep(tcp_conn);
 
-	return 0;
+put_ep:
+	iscsi_put_endpoint(ep);
+	return err;
 }
 EXPORT_SYMBOL_GPL(cxgbi_bind_conn);
 
diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscsi.c
index ef16537c523c..087c7ff28cd5 100644
--- a/drivers/scsi/qedi/qedi_iscsi.c
+++ b/drivers/scsi/qedi/qedi_iscsi.c
@@ -377,6 +377,7 @@ static int qedi_conn_bind(struct iscsi_cls_session *cls_session,
 	struct qedi_ctx *qedi = iscsi_host_priv(shost);
 	struct qedi_endpoint *qedi_ep;
 	struct iscsi_endpoint *ep;
+	int rc = 0;
 
 	ep = iscsi_lookup_endpoint(transport_fd);
 	if (!ep)
@@ -384,11 +385,16 @@ static int qedi_conn_bind(struct iscsi_cls_session *cls_session,
 
 	qedi_ep = ep->dd_data;
 	if ((qedi_ep->state == EP_STATE_TCP_FIN_RCVD) ||
-	    (qedi_ep->state == EP_STATE_TCP_RST_RCVD))
-		return -EINVAL;
+	    (qedi_ep->state == EP_STATE_TCP_RST_RCVD)) {
+		rc = -EINVAL;
+		goto put_ep;
+	}
+
+	if (iscsi_conn_bind(cls_session, cls_conn, is_leading)) {
+		rc = -EINVAL;
+		goto put_ep;
+	}
 
-	if (iscsi_conn_bind(cls_session, cls_conn, is_leading))
-		return -EINVAL;
 
 	qedi_ep->conn = qedi_conn;
 	qedi_conn->ep = qedi_ep;
@@ -398,13 +404,18 @@ static int qedi_conn_bind(struct iscsi_cls_session *cls_session,
 	qedi_conn->cmd_cleanup_req = 0;
 	qedi_conn->cmd_cleanup_cmpl = 0;
 
-	if (qedi_bind_conn_to_iscsi_cid(qedi, qedi_conn))
-		return -EINVAL;
+	if (qedi_bind_conn_to_iscsi_cid(qedi, qedi_conn)) {
+		rc = -EINVAL;
+		goto put_ep;
+	}
+
 
 	spin_lock_init(&qedi_conn->tmf_work_lock);
 	INIT_LIST_HEAD(&qedi_conn->tmf_work_list);
 	init_waitqueue_head(&qedi_conn->wait_queue);
-	return 0;
+put_ep:
+	iscsi_put_endpoint(ep);
+	return rc;
 }
 
 static int qedi_iscsi_update_conn(struct qedi_ctx *qedi,
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 74d0d1bc208d..0e7a7e82e028 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -3235,6 +3235,7 @@ static int qla4xxx_conn_bind(struct iscsi_cls_session *cls_session,
 	conn = cls_conn->dd_data;
 	qla_conn = conn->dd_data;
 	qla_conn->qla_ep = ep->dd_data;
+	iscsi_put_endpoint(ep);
 	return 0;
 }
 
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 2eb77f69fe0c..bab6654d8ee9 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -266,9 +266,20 @@ void iscsi_destroy_endpoint(struct iscsi_endpoint *ep)
 }
 EXPORT_SYMBOL_GPL(iscsi_destroy_endpoint);
 
+void iscsi_put_endpoint(struct iscsi_endpoint *ep)
+{
+	put_device(&ep->dev);
+}
+EXPORT_SYMBOL_GPL(iscsi_put_endpoint);
+
+/**
+ * iscsi_lookup_endpoint - get ep from handle
+ * @handle: endpoint handle
+ *
+ * Caller must do a iscsi_put_endpoint.
+ */
 struct iscsi_endpoint *iscsi_lookup_endpoint(u64 handle)
 {
-	struct iscsi_endpoint *ep;
 	struct device *dev;
 
 	dev = class_find_device(&iscsi_endpoint_class, NULL, &handle,
@@ -276,13 +287,7 @@ struct iscsi_endpoint *iscsi_lookup_endpoint(u64 handle)
 	if (!dev)
 		return NULL;
 
-	ep = iscsi_dev_to_endpoint(dev);
-	/*
-	 * we can drop this now because the interface will prevent
-	 * removals and lookups from racing.
-	 */
-	put_device(dev);
-	return ep;
+	return iscsi_dev_to_endpoint(dev);
 }
 EXPORT_SYMBOL_GPL(iscsi_lookup_endpoint);
 
@@ -2990,6 +2995,7 @@ static int iscsi_if_ep_disconnect(struct iscsi_transport *transport,
 	}
 
 	transport->ep_disconnect(ep);
+	iscsi_put_endpoint(ep);
 	return 0;
 }
 
@@ -3015,6 +3021,7 @@ iscsi_if_transport_ep(struct iscsi_transport *transport,
 
 		ev->r.retcode = transport->ep_poll(ep,
 						   ev->u.ep_poll.timeout_ms);
+		iscsi_put_endpoint(ep);
 		break;
 	case ISCSI_UEVENT_TRANSPORT_EP_DISCONNECT:
 		rc = iscsi_if_ep_disconnect(transport,
@@ -3698,6 +3705,7 @@ iscsi_if_recv_msg(struct sk_buff *skb, struct nlmsghdr *nlh, uint32_t *group)
 					ev->u.c_bound_session.initial_cmdsn,
 					ev->u.c_bound_session.cmds_max,
 					ev->u.c_bound_session.queue_depth);
+		iscsi_put_endpoint(ep);
 		break;
 	case ISCSI_UEVENT_DESTROY_SESSION:
 		session = iscsi_session_lookup(ev->u.d_session.sid);
@@ -3769,6 +3777,7 @@ iscsi_if_recv_msg(struct sk_buff *skb, struct nlmsghdr *nlh, uint32_t *group)
 			mutex_lock(&conn->ep_mutex);
 			conn->ep = ep;
 			mutex_unlock(&conn->ep_mutex);
+			iscsi_put_endpoint(ep);
 		} else
 			iscsi_cls_conn_printk(KERN_ERR, conn,
 					      "Could not set ep conn "
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index 8874016b3c9a..d36a72cf049f 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -442,6 +442,7 @@ extern int iscsi_scan_finished(struct Scsi_Host *shost, unsigned long time);
 extern struct iscsi_endpoint *iscsi_create_endpoint(int dd_size);
 extern void iscsi_destroy_endpoint(struct iscsi_endpoint *ep);
 extern struct iscsi_endpoint *iscsi_lookup_endpoint(u64 handle);
+extern void iscsi_put_endpoint(struct iscsi_endpoint *ep);
 extern int iscsi_block_scsi_eh(struct scsi_cmnd *cmd);
 extern struct iscsi_iface *iscsi_create_iface(struct Scsi_Host *shost,
 					      struct iscsi_transport *t,
-- 
2.30.2



