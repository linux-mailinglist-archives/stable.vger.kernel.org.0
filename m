Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CD046089EC
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:45:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231818AbiJVIpa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:45:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234713AbiJVInj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:43:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5B552E9E17;
        Sat, 22 Oct 2022 01:07:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CA3E660B94;
        Sat, 22 Oct 2022 08:07:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3CBBC433C1;
        Sat, 22 Oct 2022 08:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666426021;
        bh=Bwh7M+IYDioMz+ftqtGfp/Hd9LUyK5obbUWZGXdGeUQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mawu8gre/JZTSlkTuE4B9NLH+Gf4wAIb5oCV7Pig7Ex7cXbKBjSuGpM4bq0ieZn8a
         6t+X5clq3Z0P/r0maUnNFUIE8fL0duMCsic1so1MVLOyHxW01Z7dqZVkUhlPVtrACS
         pmTHcNO0IfsPLvjShDM3lXmhjZgrFIAMLid9vb24=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Derrick <Jonathan.Derrick@solidigm.com>,
        Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        Chao Leng <lengchao@huawei.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 685/717] nvme: handle effects after freeing the request
Date:   Sat, 22 Oct 2022 09:29:24 +0200
Message-Id: <20221022072528.792980614@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit bc8fb906b0ff9339b4286698cb7cd9cd5b8c53eb ]

If a reset occurs after the scan work attempts to issue a command, the
reset may quisce the admin queue, which blocks the scan work's command
from dispatching. The scan work will not be able to complete while the
queue is quiesced.

Meanwhile, the reset work will cancel all outstanding admin tags and
wait until all requests have transitioned to idle, which includes the
passthrough request. But the passthrough request won't be set to idle
until after the scan_work flushes, so we're deadlocked.

Fix this by handling the end effects after the request has been freed.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=216354
Reported-by: Jonathan Derrick <Jonathan.Derrick@solidigm.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Chao Leng <lengchao@huawei.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c       | 17 ++++++-----------
 drivers/nvme/host/ioctl.c      |  9 ++++++++-
 drivers/nvme/host/nvme.h       |  4 +++-
 drivers/nvme/target/passthru.c |  7 ++++++-
 4 files changed, 23 insertions(+), 14 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 326ad33537ed..47fd9d528c83 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1089,8 +1089,8 @@ static u32 nvme_passthru_start(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 	return effects;
 }
 
-static void nvme_passthru_end(struct nvme_ctrl *ctrl, u32 effects,
-			      struct nvme_command *cmd, int status)
+void nvme_passthru_end(struct nvme_ctrl *ctrl, u32 effects,
+		       struct nvme_command *cmd, int status)
 {
 	if (effects & NVME_CMD_EFFECTS_CSE_MASK) {
 		nvme_unfreeze(ctrl);
@@ -1126,21 +1126,16 @@ static void nvme_passthru_end(struct nvme_ctrl *ctrl, u32 effects,
 		break;
 	}
 }
+EXPORT_SYMBOL_NS_GPL(nvme_passthru_end, NVME_TARGET_PASSTHRU);
 
-int nvme_execute_passthru_rq(struct request *rq)
+int nvme_execute_passthru_rq(struct request *rq, u32 *effects)
 {
 	struct nvme_command *cmd = nvme_req(rq)->cmd;
 	struct nvme_ctrl *ctrl = nvme_req(rq)->ctrl;
 	struct nvme_ns *ns = rq->q->queuedata;
-	u32 effects;
-	int  ret;
 
-	effects = nvme_passthru_start(ctrl, ns, cmd->common.opcode);
-	ret = nvme_execute_rq(rq, false);
-	if (effects) /* nothing to be done for zero cmd effects */
-		nvme_passthru_end(ctrl, effects, cmd, ret);
-
-	return ret;
+	*effects = nvme_passthru_start(ctrl, ns, cmd->common.opcode);
+	return nvme_execute_rq(rq, false);
 }
 EXPORT_SYMBOL_NS_GPL(nvme_execute_passthru_rq, NVME_TARGET_PASSTHRU);
 
diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index a2e89db1cd63..15a60e1f290a 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -136,9 +136,11 @@ static int nvme_submit_user_cmd(struct request_queue *q,
 		unsigned bufflen, void __user *meta_buffer, unsigned meta_len,
 		u32 meta_seed, u64 *result, unsigned timeout, bool vec)
 {
+	struct nvme_ctrl *ctrl;
 	struct request *req;
 	void *meta = NULL;
 	struct bio *bio;
+	u32 effects;
 	int ret;
 
 	req = nvme_alloc_user_request(q, cmd, ubuffer, bufflen, meta_buffer,
@@ -147,8 +149,9 @@ static int nvme_submit_user_cmd(struct request_queue *q,
 		return PTR_ERR(req);
 
 	bio = req->bio;
+	ctrl = nvme_req(req)->ctrl;
 
-	ret = nvme_execute_passthru_rq(req);
+	ret = nvme_execute_passthru_rq(req, &effects);
 
 	if (result)
 		*result = le64_to_cpu(nvme_req(req)->result.u64);
@@ -158,6 +161,10 @@ static int nvme_submit_user_cmd(struct request_queue *q,
 	if (bio)
 		blk_rq_unmap_user(bio);
 	blk_mq_free_request(req);
+
+	if (effects)
+		nvme_passthru_end(ctrl, effects, cmd, ret);
+
 	return ret;
 }
 
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 5558f8812157..e154e2304203 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -994,7 +994,9 @@ static inline bool nvme_ctrl_sgl_supported(struct nvme_ctrl *ctrl)
 
 u32 nvme_command_effects(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 			 u8 opcode);
-int nvme_execute_passthru_rq(struct request *rq);
+int nvme_execute_passthru_rq(struct request *rq, u32 *effects);
+void nvme_passthru_end(struct nvme_ctrl *ctrl, u32 effects,
+		       struct nvme_command *cmd, int status);
 struct nvme_ctrl *nvme_ctrl_from_file(struct file *file);
 struct nvme_ns *nvme_find_get_ns(struct nvme_ctrl *ctrl, unsigned nsid);
 void nvme_put_ns(struct nvme_ns *ns);
diff --git a/drivers/nvme/target/passthru.c b/drivers/nvme/target/passthru.c
index 6f39a29828b1..94d3153bae54 100644
--- a/drivers/nvme/target/passthru.c
+++ b/drivers/nvme/target/passthru.c
@@ -215,9 +215,11 @@ static void nvmet_passthru_execute_cmd_work(struct work_struct *w)
 {
 	struct nvmet_req *req = container_of(w, struct nvmet_req, p.work);
 	struct request *rq = req->p.rq;
+	struct nvme_ctrl *ctrl = nvme_req(rq)->ctrl;
+	u32 effects;
 	int status;
 
-	status = nvme_execute_passthru_rq(rq);
+	status = nvme_execute_passthru_rq(rq, &effects);
 
 	if (status == NVME_SC_SUCCESS &&
 	    req->cmd->common.opcode == nvme_admin_identify) {
@@ -238,6 +240,9 @@ static void nvmet_passthru_execute_cmd_work(struct work_struct *w)
 	req->cqe->result = nvme_req(rq)->result;
 	nvmet_req_complete(req, status);
 	blk_mq_free_request(rq);
+
+	if (effects)
+		nvme_passthru_end(ctrl, effects, req->cmd, status);
 }
 
 static void nvmet_passthru_req_done(struct request *rq,
-- 
2.35.1



