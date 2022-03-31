Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CC684EDD92
	for <lists+stable@lfdr.de>; Thu, 31 Mar 2022 17:42:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238982AbiCaPmr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Mar 2022 11:42:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239052AbiCaPm2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 31 Mar 2022 11:42:28 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCD935A158;
        Thu, 31 Mar 2022 08:37:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648741041; x=1680277041;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wspBC7yhTsGGOGxtG2IhAryn8B6WNOq3vPpJMjpO3Hg=;
  b=coS8dO5RYp1hZLcqFFj7yYbYfq9DDfrQLFyamXtZG3m551iTnNMYAZSI
   suqfRrEnGotTFi8DVYmRFv2iHmataXiZS9VVwZl4GKq5ann7RGHCzR97D
   wdMLAjkCOHsHVDg/ta/YR3s4D2vKsaj5TjBR09bi/I7zP2FacK6SzpH4j
   561H/OGWDzNiDQ4Rkz+hTbPXEcqtEPc7D77nwAQDUJKEnOi7ulZYuuUvc
   Frp+Y3OHxNNw4gAliDR8j6eh46aZC4shvdmptkkazDFjZ3uOpcZlQCK/Q
   2AvfDCUA3s9x4Q11Q6ezSs+kYJwDeAGYLvmMKkKpofIrNB+ShXQM/2Fxy
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10302"; a="242022745"
X-IronPort-AV: E=Sophos;i="5.90,225,1643702400"; 
   d="scan'208";a="242022745"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2022 08:37:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,225,1643702400"; 
   d="scan'208";a="555124800"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.76])
  by fmsmga007.fm.intel.com with ESMTP; 31 Mar 2022 08:36:59 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        marco.chiappero@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        stable@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Kyle Sanderson <kyle.leet@gmail.com>
Subject: [PATCH v2 3/4] crypto: qat - add backlog mechanism
Date:   Thu, 31 Mar 2022 16:36:51 +0100
Message-Id: <20220331153652.37020-4-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220331153652.37020-1-giovanni.cabiddu@intel.com>
References: <20220331153652.37020-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The implementations of the crypto algorithms (aead, skcipher, etc) in
the QAT driver do not properly support requests with the
CRYPTO_TFM_REQ_MAY_BACKLOG flag set. If the HW queue is full, the driver
returns -EBUSY but does not enqueue the request. This can result in
applications like dm-crypt waiting indefinitely for the completion of a
request that was never submitted to the hardware.

Fix this by adding a software backlog queue: if the ring buffer is more
than eighty percent full, then the request is enqueued to a backlog
list and the error code -EBUSY is returned back to the caller.
Requests in the backlog queue are resubmitted at a later time, in the
context of the callback of a previously submitted request.
The request for which -EBUSY is returned is then marked as -EINPROGRESS
once submitted to the HW queues.

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
 drivers/crypto/qat/qat_common/adf_transport.c | 11 ++++
 drivers/crypto/qat/qat_common/adf_transport.h |  1 +
 .../qat/qat_common/adf_transport_internal.h   |  1 +
 drivers/crypto/qat/qat_common/qat_algs.c      | 23 ++++---
 drivers/crypto/qat/qat_common/qat_algs_send.c | 65 ++++++++++++++++++-
 drivers/crypto/qat/qat_common/qat_algs_send.h |  1 +
 drivers/crypto/qat/qat_common/qat_asym_algs.c | 22 ++++---
 drivers/crypto/qat/qat_common/qat_crypto.c    |  3 +
 drivers/crypto/qat/qat_common/qat_crypto.h    | 10 +++
 9 files changed, 119 insertions(+), 18 deletions(-)

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
index f93218dd6de3..7f1bdab9706b 100644
--- a/drivers/crypto/qat/qat_common/qat_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_algs.c
@@ -937,17 +937,22 @@ void qat_alg_callback(void *resp)
 				(void *)(__force long)qat_resp->opaque_data;
 
 	qat_req->cb(qat_resp, qat_req);
+
+	qat_alg_send_backlog(qat_req->alg_req.backlog);
 }
 
 static int qat_alg_send_sym_message(struct qat_crypto_request *qat_req,
-				    struct qat_crypto_instance *inst)
+				    struct qat_crypto_instance *inst,
+				    struct crypto_async_request *base)
 {
-	struct qat_alg_req req;
+	struct qat_alg_req *alg_req = &qat_req->alg_req;
 
-	req.fw_req = (u32 *)&qat_req->req;
-	req.tx_ring = inst->sym_tx;
+	alg_req->fw_req = (u32 *)&qat_req->req;
+	alg_req->tx_ring = inst->sym_tx;
+	alg_req->base = base;
+	alg_req->backlog = &inst->backlog;
 
-	return qat_alg_send_message(&req);
+	return qat_alg_send_message(alg_req);
 }
 
 static int qat_alg_aead_dec(struct aead_request *areq)
@@ -987,7 +992,7 @@ static int qat_alg_aead_dec(struct aead_request *areq)
 	auth_param->auth_off = 0;
 	auth_param->auth_len = areq->assoclen + cipher_param->cipher_length;
 
-	ret = qat_alg_send_sym_message(qat_req, ctx->inst);
+	ret = qat_alg_send_sym_message(qat_req, ctx->inst, &areq->base);
 	if (ret == -ENOSPC)
 		qat_alg_free_bufl(ctx->inst, qat_req);
 
@@ -1031,7 +1036,7 @@ static int qat_alg_aead_enc(struct aead_request *areq)
 	auth_param->auth_off = 0;
 	auth_param->auth_len = areq->assoclen + areq->cryptlen;
 
-	ret = qat_alg_send_sym_message(qat_req, ctx->inst);
+	ret = qat_alg_send_sym_message(qat_req, ctx->inst, &areq->base);
 	if (ret == -ENOSPC)
 		qat_alg_free_bufl(ctx->inst, qat_req);
 
@@ -1212,7 +1217,7 @@ static int qat_alg_skcipher_encrypt(struct skcipher_request *req)
 
 	qat_alg_set_req_iv(qat_req);
 
-	ret = qat_alg_send_sym_message(qat_req, ctx->inst);
+	ret = qat_alg_send_sym_message(qat_req, ctx->inst, &req->base);
 	if (ret == -ENOSPC)
 		qat_alg_free_bufl(ctx->inst, qat_req);
 
@@ -1278,7 +1283,7 @@ static int qat_alg_skcipher_decrypt(struct skcipher_request *req)
 	qat_alg_set_req_iv(qat_req);
 	qat_alg_update_iv(qat_req);
 
-	ret = qat_alg_send_sym_message(qat_req, ctx->inst);
+	ret = qat_alg_send_sym_message(qat_req, ctx->inst, &req->base);
 	if (ret == -ENOSPC)
 		qat_alg_free_bufl(ctx->inst, qat_req);
 
diff --git a/drivers/crypto/qat/qat_common/qat_algs_send.c b/drivers/crypto/qat/qat_common/qat_algs_send.c
index 78f1bb8c26c0..c2f3d920c94d 100644
--- a/drivers/crypto/qat/qat_common/qat_algs_send.c
+++ b/drivers/crypto/qat/qat_common/qat_algs_send.c
@@ -6,7 +6,7 @@
 
 #define ADF_MAX_RETRIES		20
 
-int qat_alg_send_message(struct qat_alg_req *req)
+static int qat_alg_send_message_retry(struct qat_alg_req *req)
 {
 	int ret = 0, ctr = 0;
 
@@ -19,3 +19,66 @@ int qat_alg_send_message(struct qat_alg_req *req)
 
 	return -EINPROGRESS;
 }
+
+void qat_alg_send_backlog(struct qat_instance_backlog *backlog)
+{
+	struct qat_alg_req *req, *tmp;
+
+	spin_lock_bh(&backlog->lock);
+	list_for_each_entry_safe(req, tmp, &backlog->list, list) {
+		if (adf_send_message(req->tx_ring, req->fw_req)) {
+			/* The HW ring is full. Do nothing.
+			 * qat_alg_send_backlog() will be invoked again by
+			 * another callback.
+			 */
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
+	list_add_tail(&req->list, &backlog->list);
+	spin_unlock_bh(&backlog->lock);
+}
+
+static int qat_alg_send_message_maybacklog(struct qat_alg_req *req)
+{
+	struct qat_instance_backlog *backlog = req->backlog;
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
+int qat_alg_send_message(struct qat_alg_req *req)
+{
+	u32 flags = req->base->flags;
+
+	if (flags & CRYPTO_TFM_REQ_MAY_BACKLOG)
+		return qat_alg_send_message_maybacklog(req);
+	else
+		return qat_alg_send_message_retry(req);
+}
diff --git a/drivers/crypto/qat/qat_common/qat_algs_send.h b/drivers/crypto/qat/qat_common/qat_algs_send.h
index 3fa685d0c293..5ce9f4f69d8f 100644
--- a/drivers/crypto/qat/qat_common/qat_algs_send.h
+++ b/drivers/crypto/qat/qat_common/qat_algs_send.h
@@ -6,5 +6,6 @@
 #include "qat_crypto.h"
 
 int qat_alg_send_message(struct qat_alg_req *req);
+void qat_alg_send_backlog(struct qat_instance_backlog *backlog);
 
 #endif
diff --git a/drivers/crypto/qat/qat_common/qat_asym_algs.c b/drivers/crypto/qat/qat_common/qat_asym_algs.c
index a3fdbcc08772..b97a0e189db6 100644
--- a/drivers/crypto/qat/qat_common/qat_asym_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_asym_algs.c
@@ -136,17 +136,21 @@ struct qat_asym_request {
 	} areq;
 	int err;
 	void (*cb)(struct icp_qat_fw_pke_resp *resp);
+	struct qat_alg_req alg_req;
 } __aligned(64);
 
 static int qat_alg_send_asym_message(struct qat_asym_request *qat_req,
-				     struct qat_crypto_instance *inst)
+				     struct qat_crypto_instance *inst,
+				     struct crypto_async_request *base)
 {
-	struct qat_alg_req req;
+	struct qat_alg_req *alg_req = &qat_req->alg_req;
 
-	req.fw_req = (u32 *)&qat_req->req;
-	req.tx_ring = inst->pke_tx;
+	alg_req->fw_req = (u32 *)&qat_req->req;
+	alg_req->tx_ring = inst->pke_tx;
+	alg_req->base = base;
+	alg_req->backlog = &inst->backlog;
 
-	return qat_alg_send_message(&req);
+	return qat_alg_send_message(alg_req);
 }
 
 static void qat_dh_cb(struct icp_qat_fw_pke_resp *resp)
@@ -350,7 +354,7 @@ static int qat_dh_compute_value(struct kpp_request *req)
 	msg->input_param_count = n_input_params;
 	msg->output_param_count = 1;
 
-	ret = qat_alg_send_asym_message(qat_req, ctx->inst);
+	ret = qat_alg_send_asym_message(qat_req, inst, &req->base);
 	if (ret == -ENOSPC)
 		goto unmap_all;
 
@@ -556,6 +560,8 @@ void qat_alg_asym_callback(void *_resp)
 	struct qat_asym_request *areq = (void *)(__force long)resp->opaque;
 
 	areq->cb(resp);
+
+	qat_alg_send_backlog(areq->alg_req.backlog);
 }
 
 #define PKE_RSA_EP_512 0x1c161b21
@@ -745,7 +751,7 @@ static int qat_rsa_enc(struct akcipher_request *req)
 	msg->input_param_count = 3;
 	msg->output_param_count = 1;
 
-	ret = qat_alg_send_asym_message(qat_req, ctx->inst);
+	ret = qat_alg_send_asym_message(qat_req, inst, &req->base);
 	if (ret == -ENOSPC)
 		goto unmap_all;
 
@@ -898,7 +904,7 @@ static int qat_rsa_dec(struct akcipher_request *req)
 
 	msg->output_param_count = 1;
 
-	ret = qat_alg_send_asym_message(qat_req, ctx->inst);
+	ret = qat_alg_send_asym_message(qat_req, inst, &req->base);
 	if (ret == -ENOSPC)
 		goto unmap_all;
 
diff --git a/drivers/crypto/qat/qat_common/qat_crypto.c b/drivers/crypto/qat/qat_common/qat_crypto.c
index 67c9588e89df..80d905ed102e 100644
--- a/drivers/crypto/qat/qat_common/qat_crypto.c
+++ b/drivers/crypto/qat/qat_common/qat_crypto.c
@@ -353,6 +353,9 @@ static int qat_crypto_create_instances(struct adf_accel_dev *accel_dev)
 				      &inst->pke_rx);
 		if (ret)
 			goto err;
+
+		INIT_LIST_HEAD(&inst->backlog.list);
+		spin_lock_init(&inst->backlog.lock);
 	}
 	return 0;
 err:
diff --git a/drivers/crypto/qat/qat_common/qat_crypto.h b/drivers/crypto/qat/qat_common/qat_crypto.h
index 0dcba6fc358c..245b6d9a3650 100644
--- a/drivers/crypto/qat/qat_common/qat_crypto.h
+++ b/drivers/crypto/qat/qat_common/qat_crypto.h
@@ -9,9 +9,17 @@
 #include "adf_accel_devices.h"
 #include "icp_qat_fw_la.h"
 
+struct qat_instance_backlog {
+	struct list_head list;
+	spinlock_t lock; /* protects backlog list */
+};
+
 struct qat_alg_req {
 	u32 *fw_req;
 	struct adf_etr_ring_data *tx_ring;
+	struct crypto_async_request *base;
+	struct list_head list;
+	struct qat_instance_backlog *backlog;
 };
 
 struct qat_crypto_instance {
@@ -24,6 +32,7 @@ struct qat_crypto_instance {
 	unsigned long state;
 	int id;
 	atomic_t refctr;
+	struct qat_instance_backlog backlog;
 };
 
 #define QAT_MAX_BUFF_DESC	4
@@ -82,6 +91,7 @@ struct qat_crypto_request {
 		u8 iv[AES_BLOCK_SIZE];
 	};
 	bool encryption;
+	struct qat_alg_req alg_req;
 };
 
 static inline bool adf_hw_dev_has_crypto(struct adf_accel_dev *accel_dev)
-- 
2.35.1

