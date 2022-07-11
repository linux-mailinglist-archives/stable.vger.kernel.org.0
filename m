Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FD6B55C921
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 14:56:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235026AbiF0L0J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:26:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234933AbiF0LZd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:25:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD8BA65D7;
        Mon, 27 Jun 2022 04:25:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 37FEF61460;
        Mon, 27 Jun 2022 11:25:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FF55C341C8;
        Mon, 27 Jun 2022 11:25:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329112;
        bh=A0N7TifsSibSRK8uFy/orcZg3ad15+XZSy20VJiIHTo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lf+pF04V7MhVW7lTf928bSJurUnKleTQngA333jJse8vvo/W1AdBhECTwvJgfWxUu
         4c9ZnJDtLQAdMNVNElUPGsdysBm+C1xHZwvlUZhYCBXnvvbNbOLdd6pANpp9+mAjyG
         KR15JHCasbhxRIt0rvdeIkrAWbWjhhFP7AfvZZX8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 055/102] nvme: split nvme_alloc_request()
Date:   Mon, 27 Jun 2022 13:21:06 +0200
Message-Id: <20220627111935.103674971@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111933.455024953@linuxfoundation.org>
References: <20220627111933.455024953@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>

[ Upstream commit 39dfe84451b4526a8054cc5a127337bca980dfa3 ]

Right now nvme_alloc_request() allocates a request from block layer
based on the value of the qid. When qid set to NVME_QID_ANY it used
blk_mq_alloc_request() else blk_mq_alloc_request_hctx().

The function nvme_alloc_request() is called from different context, The
only place where it uses non NVME_QID_ANY value is for fabrics connect
commands :-

nvme_submit_sync_cmd()		NVME_QID_ANY
nvme_features()			NVME_QID_ANY
nvme_sec_submit()		NVME_QID_ANY
nvmf_reg_read32()		NVME_QID_ANY
nvmf_reg_read64()		NVME_QID_ANY
nvmf_reg_write32()		NVME_QID_ANY
nvmf_connect_admin_queue()	NVME_QID_ANY
nvme_submit_user_cmd()		NVME_QID_ANY
	nvme_alloc_request()
nvme_keep_alive()		NVME_QID_ANY
	nvme_alloc_request()
nvme_timeout()			NVME_QID_ANY
	nvme_alloc_request()
nvme_delete_queue()		NVME_QID_ANY
	nvme_alloc_request()
nvmet_passthru_execute_cmd()	NVME_QID_ANY
	nvme_alloc_request()
nvmf_connect_io_queue() 	QID
	__nvme_submit_sync_cmd()
		nvme_alloc_request()

With passthru nvme_alloc_request() now falls into the I/O fast path such
that blk_mq_alloc_request_hctx() is never gets called and that adds
additional branch check in fast path.

Split the nvme_alloc_request() into nvme_alloc_request() and
nvme_alloc_request_qid().

Replace each call of the nvme_alloc_request() with NVME_QID_ANY param
with a call to newly added nvme_alloc_request() without NVME_QID_ANY.

Replace a call to nvme_alloc_request() with QID param with a call to
newly added nvme_alloc_request() and nvme_alloc_request_qid()
based on the qid value set in the __nvme_submit_sync_cmd().

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c       | 52 +++++++++++++++++++++++-----------
 drivers/nvme/host/lightnvm.c   |  5 ++--
 drivers/nvme/host/nvme.h       |  2 ++
 drivers/nvme/host/pci.c        |  4 +--
 drivers/nvme/target/passthru.c |  2 +-
 5 files changed, 42 insertions(+), 23 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 4a7154cbca50..68395dcd067c 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -538,21 +538,14 @@ static inline void nvme_clear_nvme_request(struct request *req)
 	}
 }
 
-struct request *nvme_alloc_request(struct request_queue *q,
-		struct nvme_command *cmd, blk_mq_req_flags_t flags, int qid)
+static inline unsigned int nvme_req_op(struct nvme_command *cmd)
 {
-	unsigned op = nvme_is_write(cmd) ? REQ_OP_DRV_OUT : REQ_OP_DRV_IN;
-	struct request *req;
-
-	if (qid == NVME_QID_ANY) {
-		req = blk_mq_alloc_request(q, op, flags);
-	} else {
-		req = blk_mq_alloc_request_hctx(q, op, flags,
-				qid ? qid - 1 : 0);
-	}
-	if (IS_ERR(req))
-		return req;
+	return nvme_is_write(cmd) ? REQ_OP_DRV_OUT : REQ_OP_DRV_IN;
+}
 
+static inline void nvme_init_request(struct request *req,
+		struct nvme_command *cmd)
+{
 	if (req->q->queuedata)
 		req->timeout = NVME_IO_TIMEOUT;
 	else /* no queuedata implies admin queue */
@@ -561,11 +554,33 @@ struct request *nvme_alloc_request(struct request_queue *q,
 	req->cmd_flags |= REQ_FAILFAST_DRIVER;
 	nvme_clear_nvme_request(req);
 	nvme_req(req)->cmd = cmd;
+}
 
+struct request *nvme_alloc_request(struct request_queue *q,
+		struct nvme_command *cmd, blk_mq_req_flags_t flags)
+{
+	struct request *req;
+
+	req = blk_mq_alloc_request(q, nvme_req_op(cmd), flags);
+	if (!IS_ERR(req))
+		nvme_init_request(req, cmd);
 	return req;
 }
 EXPORT_SYMBOL_GPL(nvme_alloc_request);
 
+struct request *nvme_alloc_request_qid(struct request_queue *q,
+		struct nvme_command *cmd, blk_mq_req_flags_t flags, int qid)
+{
+	struct request *req;
+
+	req = blk_mq_alloc_request_hctx(q, nvme_req_op(cmd), flags,
+			qid ? qid - 1 : 0);
+	if (!IS_ERR(req))
+		nvme_init_request(req, cmd);
+	return req;
+}
+EXPORT_SYMBOL_GPL(nvme_alloc_request_qid);
+
 static int nvme_toggle_streams(struct nvme_ctrl *ctrl, bool enable)
 {
 	struct nvme_command c;
@@ -928,7 +943,10 @@ int __nvme_submit_sync_cmd(struct request_queue *q, struct nvme_command *cmd,
 	struct request *req;
 	int ret;
 
-	req = nvme_alloc_request(q, cmd, flags, qid);
+	if (qid == NVME_QID_ANY)
+		req = nvme_alloc_request(q, cmd, flags);
+	else
+		req = nvme_alloc_request_qid(q, cmd, flags, qid);
 	if (IS_ERR(req))
 		return PTR_ERR(req);
 
@@ -1099,7 +1117,7 @@ static int nvme_submit_user_cmd(struct request_queue *q,
 	void *meta = NULL;
 	int ret;
 
-	req = nvme_alloc_request(q, cmd, 0, NVME_QID_ANY);
+	req = nvme_alloc_request(q, cmd, 0);
 	if (IS_ERR(req))
 		return PTR_ERR(req);
 
@@ -1174,8 +1192,8 @@ static int nvme_keep_alive(struct nvme_ctrl *ctrl)
 {
 	struct request *rq;
 
-	rq = nvme_alloc_request(ctrl->admin_q, &ctrl->ka_cmd, BLK_MQ_REQ_RESERVED,
-			NVME_QID_ANY);
+	rq = nvme_alloc_request(ctrl->admin_q, &ctrl->ka_cmd,
+			BLK_MQ_REQ_RESERVED);
 	if (IS_ERR(rq))
 		return PTR_ERR(rq);
 
diff --git a/drivers/nvme/host/lightnvm.c b/drivers/nvme/host/lightnvm.c
index 88a7c8eac455..470cef3abec3 100644
--- a/drivers/nvme/host/lightnvm.c
+++ b/drivers/nvme/host/lightnvm.c
@@ -653,7 +653,7 @@ static struct request *nvme_nvm_alloc_request(struct request_queue *q,
 
 	nvme_nvm_rqtocmd(rqd, ns, cmd);
 
-	rq = nvme_alloc_request(q, (struct nvme_command *)cmd, 0, NVME_QID_ANY);
+	rq = nvme_alloc_request(q, (struct nvme_command *)cmd, 0);
 	if (IS_ERR(rq))
 		return rq;
 
@@ -767,8 +767,7 @@ static int nvme_nvm_submit_user_cmd(struct request_queue *q,
 	DECLARE_COMPLETION_ONSTACK(wait);
 	int ret = 0;
 
-	rq = nvme_alloc_request(q, (struct nvme_command *)vcmd, 0,
-			NVME_QID_ANY);
+	rq = nvme_alloc_request(q, (struct nvme_command *)vcmd, 0);
 	if (IS_ERR(rq)) {
 		ret = -ENOMEM;
 		goto err_cmd;
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 95b9657cabaf..8e40a6306e53 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -662,6 +662,8 @@ void nvme_start_freeze(struct nvme_ctrl *ctrl);
 
 #define NVME_QID_ANY -1
 struct request *nvme_alloc_request(struct request_queue *q,
+		struct nvme_command *cmd, blk_mq_req_flags_t flags);
+struct request *nvme_alloc_request_qid(struct request_queue *q,
 		struct nvme_command *cmd, blk_mq_req_flags_t flags, int qid);
 void nvme_cleanup_cmd(struct request *req);
 blk_status_t nvme_setup_cmd(struct nvme_ns *ns, struct request *req,
diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index f2d0148d4050..07a4d5d387cd 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1350,7 +1350,7 @@ static enum blk_eh_timer_return nvme_timeout(struct request *req, bool reserved)
 		 req->tag, nvmeq->qid);
 
 	abort_req = nvme_alloc_request(dev->ctrl.admin_q, &cmd,
-			BLK_MQ_REQ_NOWAIT, NVME_QID_ANY);
+			BLK_MQ_REQ_NOWAIT);
 	if (IS_ERR(abort_req)) {
 		atomic_inc(&dev->ctrl.abort_limit);
 		return BLK_EH_RESET_TIMER;
@@ -2278,7 +2278,7 @@ static int nvme_delete_queue(struct nvme_queue *nvmeq, u8 opcode)
 	cmd.delete_queue.opcode = opcode;
 	cmd.delete_queue.qid = cpu_to_le16(nvmeq->qid);
 
-	req = nvme_alloc_request(q, &cmd, BLK_MQ_REQ_NOWAIT, NVME_QID_ANY);
+	req = nvme_alloc_request(q, &cmd, BLK_MQ_REQ_NOWAIT);
 	if (IS_ERR(req))
 		return PTR_ERR(req);
 
diff --git a/drivers/nvme/target/passthru.c b/drivers/nvme/target/passthru.c
index 8ee94f056898..d24251ece502 100644
--- a/drivers/nvme/target/passthru.c
+++ b/drivers/nvme/target/passthru.c
@@ -244,7 +244,7 @@ static void nvmet_passthru_execute_cmd(struct nvmet_req *req)
 		q = ns->queue;
 	}
 
-	rq = nvme_alloc_request(q, req->cmd, 0, NVME_QID_ANY);
+	rq = nvme_alloc_request(q, req->cmd, 0);
 	if (IS_ERR(rq)) {
 		status = NVME_SC_INTERNAL;
 		goto out_put_ns;
-- 
2.35.1



