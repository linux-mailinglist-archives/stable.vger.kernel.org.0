Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 616334E978C
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 15:08:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240204AbiC1NJl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 09:09:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243023AbiC1NJX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 09:09:23 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 310F45EBFF;
        Mon, 28 Mar 2022 06:07:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648472853; x=1680008853;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RT1jiMOLDKKzZ3OKW/tweMawbEKnxvuRQOMnp6G+Js4=;
  b=mcElYYDye3sLB+6aw9Dpl+Tz7CLcjomWmVKuIcGM2pQ4NUNmeqbNFjd1
   0nM8+g+NS7T6Tns/G0yPgOtY2UwuRw8fEql6k44pjzr/9ThDNwXKtXG5B
   iMweGp0mLGFUUQbBhqZGpX4rixM7b7wQUvuSY4pSTc7oDhZQa+fU/aJyy
   X9KITYgZS1qYw+gquqOPLzdvWL6a+s0DpTYSx5ueJXwO6i3Rf3uOm7o2H
   kMtdB6yVlEOgATIy9iWUuhpXFMIMhRCfMQzvMj/zRwhpPVU0jkHu6PFsx
   bP23eJclIdJsWmeOd6qn2zoSC2CkGJpV9fEZw94lxZKjUpr28R2m9bMJk
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10299"; a="259179011"
X-IronPort-AV: E=Sophos;i="5.90,217,1643702400"; 
   d="scan'208";a="259179011"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2022 06:07:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,217,1643702400"; 
   d="scan'208";a="563641151"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.76])
  by orsmga008.jf.intel.com with ESMTP; 28 Mar 2022 06:07:28 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        stable@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Kyle Sanderson <kyle.leet@gmail.com>,
        Marco Chiappero <marco.chiappero@intel.com>
Subject: [PATCH 3/4] crypto: qat - add backlog mechanism
Date:   Mon, 28 Mar 2022 14:07:13 +0100
Message-Id: <20220328130714.31606-4-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220328130714.31606-1-giovanni.cabiddu@intel.com>
References: <20220328130714.31606-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The implementations of the crypto algorithms (aead, skcipher, etc) in
the QAT driver are not properly supporting requests with the
CRYPTO_TFM_REQ_MAY_BACKLOG flag set.
If the HW queue is full, the driver returns -EBUSY but does not enqueue
the request.
This can result in applications like dm-crypt waiting indefinitely for a
completion of a request that was never submitted to the hardware.

Fix this by adding a software backlog queue: if the ring buffer is more
than eighty percent full, then the request is enqueued to a backlog
list, a worker thread is scheduled to resubmit it at later time and the
error code -EBUSY is returned up to the caller.
The request for which -EBUSY is returned is then marked as -EINPROGRESS
when is submitted to the HW queues.

The submission loop inside the function qat_alg_send_message() has been
modified to decide which submission policy to use based on the request
flags. If the request does not have the CRYPTO_TFM_REQ_MAY_BACKLOG set,
the previous behaviour has been preserved.

Based on a patch by
Vishnu Das Ramachandran <vishnu.dasx.ramachandran@intel.com>

Cc: stable@vger.kernel.org
Fixes: d370cec32194 ("crypto: qat - Intel(R) QAT crypto interface")
Reported-by: Mikulas Patocka <mpatocka@redhat.com>
Reported-by: Kyle Sanderson <kyle.leet@gmail.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Marco Chiappero <marco.chiappero@intel.com>
---
 drivers/crypto/qat/qat_common/adf_transport.c | 11 +++
 drivers/crypto/qat/qat_common/adf_transport.h |  1 +
 .../qat/qat_common/adf_transport_internal.h   |  1 +
 drivers/crypto/qat/qat_common/qat_algs.c      | 21 +++---
 drivers/crypto/qat/qat_common/qat_algs_send.c | 72 ++++++++++++++++++-
 drivers/crypto/qat/qat_common/qat_algs_send.h |  2 +-
 drivers/crypto/qat/qat_common/qat_asym_algs.c | 20 +++---
 drivers/crypto/qat/qat_common/qat_crypto.c    | 30 ++++++++
 drivers/crypto/qat/qat_common/qat_crypto.h    | 11 +++
 9 files changed, 150 insertions(+), 19 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_transport.c b/drivers/crypto/qat/qat_common/adf_transport.c
index 8ba28409fb74..630d0483c4e0 100644
--- a/drivers/crypto/qat/qat_common/adf_transport.c
+++ b/drivers/crypto/qat/qat_common/adf_transport.c
@@ -8,6 +8,9 @@
 #include "adf_cfg.h"
 #include "adf_common_drv.h"
 
+#define ADF_MAX_RING_THRESHOLD		80
+#define ADF_PERCENT(tot, percent)	(((tot) * (percent)) / 100)
+
 static inline u32 adf_modulo(u32 data, u32 shift)
 {
 	u32 div = data >> shift;
@@ -77,6 +80,11 @@ static void adf_disable_ring_irq(struct adf_etr_bank_data *bank, u32 ring)
 				      bank->irq_mask);
 }
 
+bool adf_ring_nearly_full(struct adf_etr_ring_data *ring)
+{
+	return atomic_read(ring->inflights) > ring->threshold;
+}
+
 int adf_send_message(struct adf_etr_ring_data *ring, u32 *msg)
 {
 	struct adf_hw_csr_ops *csr_ops = GET_CSR_OPS(ring->bank->accel_dev);
@@ -217,6 +225,7 @@ int adf_create_ring(struct adf_accel_dev *accel_dev, const char *section,
 	struct adf_etr_bank_data *bank;
 	struct adf_etr_ring_data *ring;
 	char val[ADF_CFG_MAX_VAL_LEN_IN_BYTES];
+	int max_inflights;
 	u32 ring_num;
 	int ret;
 
@@ -263,6 +272,8 @@ int adf_create_ring(struct adf_accel_dev *accel_dev, const char *section,
 	ring->ring_size = adf_verify_ring_size(msg_size, num_msgs);
 	ring->head = 0;
 	ring->tail = 0;
+	max_inflights = ADF_MAX_INFLIGHTS(ring->ring_size, ring->msg_size);
+	ring->threshold = ADF_PERCENT(max_inflights, ADF_MAX_RING_THRESHOLD);
 	atomic_set(ring->inflights, 0);
 	ret = adf_init_ring(ring);
 	if (ret)
diff --git a/drivers/crypto/qat/qat_common/adf_transport.h b/drivers/crypto/qat/qat_common/adf_transport.h
index 2c95f1697c76..e6ef6f9b7691 100644
--- a/drivers/crypto/qat/qat_common/adf_transport.h
+++ b/drivers/crypto/qat/qat_common/adf_transport.h
@@ -14,6 +14,7 @@ int adf_create_ring(struct adf_accel_dev *accel_dev, const char *section,
 		    const char *ring_name, adf_callback_fn callback,
 		    int poll_mode, struct adf_etr_ring_data **ring_ptr);
 
+bool adf_ring_nearly_full(struct adf_etr_ring_data *ring);
 int adf_send_message(struct adf_etr_ring_data *ring, u32 *msg);
 void adf_remove_ring(struct adf_etr_ring_data *ring);
 #endif
diff --git a/drivers/crypto/qat/qat_common/adf_transport_internal.h b/drivers/crypto/qat/qat_common/adf_transport_internal.h
index 501bcf0f1809..8b2c92ba7ca1 100644
--- a/drivers/crypto/qat/qat_common/adf_transport_internal.h
+++ b/drivers/crypto/qat/qat_common/adf_transport_internal.h
@@ -22,6 +22,7 @@ struct adf_etr_ring_data {
 	spinlock_t lock;	/* protects ring data struct */
 	u16 head;
 	u16 tail;
+	u32 threshold;
 	u8 ring_number;
 	u8 ring_size;
 	u8 msg_size;
diff --git a/drivers/crypto/qat/qat_common/qat_algs.c b/drivers/crypto/qat/qat_common/qat_algs.c
index f93218dd6de3..f1fb3c2c18ed 100644
--- a/drivers/crypto/qat/qat_common/qat_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_algs.c
@@ -940,14 +940,17 @@ void qat_alg_callback(void *resp)
 }
 
 static int qat_alg_send_sym_message(struct qat_crypto_request *qat_req,
-				    struct qat_crypto_instance *inst)
+				    struct qat_crypto_instance *inst,
+				    struct crypto_async_request *base)
 {
-	struct qat_alg_req req;
+	struct qat_alg_req *req = &qat_req->job;
+	struct qat_instance_backlog *bl = &inst->backlog;
 
-	req.fw_req = (u32 *)&qat_req->req;
-	req.tx_ring = inst->sym_tx;
+	req->fw_req = (u32 *)&qat_req->req;
+	req->tx_ring = inst->sym_tx;
+	req->base = base;
 
-	return qat_alg_send_message(&req);
+	return qat_alg_send_message(req, bl);
 }
 
 static int qat_alg_aead_dec(struct aead_request *areq)
@@ -987,7 +990,7 @@ static int qat_alg_aead_dec(struct aead_request *areq)
 	auth_param->auth_off = 0;
 	auth_param->auth_len = areq->assoclen + cipher_param->cipher_length;
 
-	ret = qat_alg_send_sym_message(qat_req, ctx->inst);
+	ret = qat_alg_send_sym_message(qat_req, ctx->inst, &areq->base);
 	if (ret == -ENOSPC)
 		qat_alg_free_bufl(ctx->inst, qat_req);
 
@@ -1031,7 +1034,7 @@ static int qat_alg_aead_enc(struct aead_request *areq)
 	auth_param->auth_off = 0;
 	auth_param->auth_len = areq->assoclen + areq->cryptlen;
 
-	ret = qat_alg_send_sym_message(qat_req, ctx->inst);
+	ret = qat_alg_send_sym_message(qat_req, ctx->inst, &areq->base);
 	if (ret == -ENOSPC)
 		qat_alg_free_bufl(ctx->inst, qat_req);
 
@@ -1212,7 +1215,7 @@ static int qat_alg_skcipher_encrypt(struct skcipher_request *req)
 
 	qat_alg_set_req_iv(qat_req);
 
-	ret = qat_alg_send_sym_message(qat_req, ctx->inst);
+	ret = qat_alg_send_sym_message(qat_req, ctx->inst, &req->base);
 	if (ret == -ENOSPC)
 		qat_alg_free_bufl(ctx->inst, qat_req);
 
@@ -1278,7 +1281,7 @@ static int qat_alg_skcipher_decrypt(struct skcipher_request *req)
 	qat_alg_set_req_iv(qat_req);
 	qat_alg_update_iv(qat_req);
 
-	ret = qat_alg_send_sym_message(qat_req, ctx->inst);
+	ret = qat_alg_send_sym_message(qat_req, ctx->inst, &req->base);
 	if (ret == -ENOSPC)
 		qat_alg_free_bufl(ctx->inst, qat_req);
 
diff --git a/drivers/crypto/qat/qat_common/qat_algs_send.c b/drivers/crypto/qat/qat_common/qat_algs_send.c
index 78f1bb8c26c0..f1109bc0d5c7 100644
--- a/drivers/crypto/qat/qat_common/qat_algs_send.c
+++ b/drivers/crypto/qat/qat_common/qat_algs_send.c
@@ -6,7 +6,7 @@
 
 #define ADF_MAX_RETRIES		20
 
-int qat_alg_send_message(struct qat_alg_req *req)
+static int qat_alg_send_message_retry(struct qat_alg_req *req)
 {
 	int ret = 0, ctr = 0;
 
@@ -19,3 +19,73 @@ int qat_alg_send_message(struct qat_alg_req *req)
 
 	return -EINPROGRESS;
 }
+
+static void qat_alg_send_backlog(struct work_struct *work)
+{
+	struct qat_instance_backlog *backlog;
+	struct qat_alg_req *req, *tmp;
+
+	backlog = container_of(work, struct qat_instance_backlog, work);
+
+	spin_lock_bh(&backlog->lock);
+	list_for_each_entry_safe(req, tmp, &backlog->list, list) {
+		if (adf_send_message(req->tx_ring, req->fw_req)) {
+			/* If adf_send_message() fails, trigger worker */
+			INIT_WORK(&backlog->work, qat_alg_send_backlog);
+			queue_work(backlog->wq, &backlog->work);
+			break;
+		}
+		list_del(&req->list);
+		req->base->complete(req->base, -EINPROGRESS);
+	}
+	spin_unlock_bh(&backlog->lock);
+}
+
+static void qat_alg_backlog_req(struct qat_alg_req *req,
+				struct qat_instance_backlog *backlog)
+{
+	spin_lock_bh(&backlog->lock);
+	if (list_empty(&backlog->list)) {
+		/* Schedule worker only for first element in the list */
+		INIT_WORK(&backlog->work, qat_alg_send_backlog);
+		queue_work(backlog->wq, &backlog->work);
+	}
+	list_add_tail(&req->list, &backlog->list);
+	spin_unlock_bh(&backlog->lock);
+}
+
+static int qat_alg_send_message_maybacklog(struct qat_alg_req *req,
+					   struct qat_instance_backlog *backlog)
+{
+	struct adf_etr_ring_data *tx_ring = req->tx_ring;
+	u32 *fw_req = req->fw_req;
+
+	/* If any request is already backlogged, then add to backlog list */
+	if (!list_empty(&backlog->list))
+		goto enqueue;
+
+	/* If ring is nearly full, then add to backlog list */
+	if (adf_ring_nearly_full(tx_ring))
+		goto enqueue;
+
+	/* If adding request to HW ring fails, then add to backlog list */
+	if (adf_send_message(tx_ring, fw_req))
+		goto enqueue;
+
+	return -EINPROGRESS;
+
+enqueue:
+	qat_alg_backlog_req(req, backlog);
+
+	return -EBUSY;
+}
+
+int qat_alg_send_message(struct qat_alg_req *req, struct qat_instance_backlog *bl)
+{
+	u32 flags = req->base->flags;
+
+	if (flags & CRYPTO_TFM_REQ_MAY_BACKLOG)
+		return qat_alg_send_message_maybacklog(req, bl);
+	else
+		return qat_alg_send_message_retry(req);
+}
diff --git a/drivers/crypto/qat/qat_common/qat_algs_send.h b/drivers/crypto/qat/qat_common/qat_algs_send.h
index 3b5fa0c1c95d..fba275a61a67 100644
--- a/drivers/crypto/qat/qat_common/qat_algs_send.h
+++ b/drivers/crypto/qat/qat_common/qat_algs_send.h
@@ -5,6 +5,6 @@
 
 #include "qat_crypto.h"
 
-int qat_alg_send_message(struct qat_alg_req *req);
+int qat_alg_send_message(struct qat_alg_req *req, struct qat_instance_backlog *bl);
 
 #endif
diff --git a/drivers/crypto/qat/qat_common/qat_asym_algs.c b/drivers/crypto/qat/qat_common/qat_asym_algs.c
index a3fdbcc08772..ad2696a18a34 100644
--- a/drivers/crypto/qat/qat_common/qat_asym_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_asym_algs.c
@@ -136,17 +136,21 @@ struct qat_asym_request {
 	} areq;
 	int err;
 	void (*cb)(struct icp_qat_fw_pke_resp *resp);
+	struct qat_alg_req job;
 } __aligned(64);
 
 static int qat_alg_send_asym_message(struct qat_asym_request *qat_req,
-				     struct qat_crypto_instance *inst)
+				     struct qat_crypto_instance *inst,
+				     struct crypto_async_request *base)
 {
-	struct qat_alg_req req;
+	struct qat_alg_req *req = &qat_req->job;
+	struct qat_instance_backlog *bl = &inst->backlog;
 
-	req.fw_req = (u32 *)&qat_req->req;
-	req.tx_ring = inst->pke_tx;
+	req->fw_req = (u32 *)&qat_req->req;
+	req->tx_ring = inst->pke_tx;
+	req->base = base;
 
-	return qat_alg_send_message(&req);
+	return qat_alg_send_message(req, bl);
 }
 
 static void qat_dh_cb(struct icp_qat_fw_pke_resp *resp)
@@ -350,7 +354,7 @@ static int qat_dh_compute_value(struct kpp_request *req)
 	msg->input_param_count = n_input_params;
 	msg->output_param_count = 1;
 
-	ret = qat_alg_send_asym_message(qat_req, ctx->inst);
+	ret = qat_alg_send_asym_message(qat_req, ctx->inst, &req->base);
 	if (ret == -ENOSPC)
 		goto unmap_all;
 
@@ -745,7 +749,7 @@ static int qat_rsa_enc(struct akcipher_request *req)
 	msg->input_param_count = 3;
 	msg->output_param_count = 1;
 
-	ret = qat_alg_send_asym_message(qat_req, ctx->inst);
+	ret = qat_alg_send_asym_message(qat_req, ctx->inst, &req->base);
 	if (ret == -ENOSPC)
 		goto unmap_all;
 
@@ -898,7 +902,7 @@ static int qat_rsa_dec(struct akcipher_request *req)
 
 	msg->output_param_count = 1;
 
-	ret = qat_alg_send_asym_message(qat_req, ctx->inst);
+	ret = qat_alg_send_asym_message(qat_req, ctx->inst, &req->base);
 	if (ret == -ENOSPC)
 		goto unmap_all;
 
diff --git a/drivers/crypto/qat/qat_common/qat_crypto.c b/drivers/crypto/qat/qat_common/qat_crypto.c
index 67c9588e89df..1558630927c6 100644
--- a/drivers/crypto/qat/qat_common/qat_crypto.c
+++ b/drivers/crypto/qat/qat_common/qat_crypto.c
@@ -16,8 +16,31 @@
 
 static struct service_hndl qat_crypto;
 
+static int qat_instance_backlog_init(struct qat_instance_backlog *bl,
+				     int accel_id, int instance_id)
+{
+	bl->wq = alloc_ordered_workqueue("qat_bl_%d.%d", WQ_MEM_RECLAIM,
+					 accel_id, instance_id);
+	if (!bl->wq)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&bl->list);
+	spin_lock_init(&bl->lock);
+
+	return 0;
+}
+
+static void qat_instance_backlog_free(struct qat_instance_backlog *bl)
+{
+	if (bl->wq) {
+		destroy_workqueue(bl->wq);
+		bl->wq = NULL;
+	}
+}
+
 void qat_crypto_put_instance(struct qat_crypto_instance *inst)
 {
+	qat_instance_backlog_free(&inst->backlog);
 	atomic_dec(&inst->refctr);
 	adf_dev_put(inst->accel_dev);
 }
@@ -54,6 +77,7 @@ struct qat_crypto_instance *qat_crypto_get_instance_node(int node)
 	struct adf_accel_dev *accel_dev = NULL, *tmp_dev;
 	struct qat_crypto_instance *inst = NULL, *tmp_inst;
 	unsigned long best = ~0;
+	int ret;
 
 	list_for_each_entry(tmp_dev, adf_devmgr_get_head(), list) {
 		unsigned long ctr;
@@ -96,8 +120,14 @@ struct qat_crypto_instance *qat_crypto_get_instance_node(int node)
 		}
 	}
 	if (inst) {
+		ret = qat_instance_backlog_init(&inst->backlog,
+						accel_dev->accel_id, inst->id);
+		if (ret)
+			return NULL;
+
 		if (adf_dev_get(accel_dev)) {
 			dev_err(&GET_DEV(accel_dev), "Could not increment dev refctr\n");
+			qat_instance_backlog_free(&inst->backlog);
 			return NULL;
 		}
 		atomic_inc(&inst->refctr);
diff --git a/drivers/crypto/qat/qat_common/qat_crypto.h b/drivers/crypto/qat/qat_common/qat_crypto.h
index 0dcba6fc358c..8aa992c23dec 100644
--- a/drivers/crypto/qat/qat_common/qat_crypto.h
+++ b/drivers/crypto/qat/qat_common/qat_crypto.h
@@ -12,6 +12,15 @@
 struct qat_alg_req {
 	u32 *fw_req;
 	struct adf_etr_ring_data *tx_ring;
+	struct crypto_async_request *base;
+	struct list_head list;
+};
+
+struct qat_instance_backlog {
+	struct workqueue_struct *wq;
+	struct list_head list;
+	spinlock_t lock; /* protects backlog list */
+	struct work_struct work;
 };
 
 struct qat_crypto_instance {
@@ -24,6 +33,7 @@ struct qat_crypto_instance {
 	unsigned long state;
 	int id;
 	atomic_t refctr;
+	struct qat_instance_backlog backlog;
 };
 
 #define QAT_MAX_BUFF_DESC	4
@@ -82,6 +92,7 @@ struct qat_crypto_request {
 		u8 iv[AES_BLOCK_SIZE];
 	};
 	bool encryption;
+	struct qat_alg_req job;
 };
 
 static inline bool adf_hw_dev_has_crypto(struct adf_accel_dev *accel_dev)
-- 
2.35.1

