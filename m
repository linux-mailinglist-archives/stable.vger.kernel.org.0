Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A01160402D
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234244AbiJSJm4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:42:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234757AbiJSJlS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:41:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41BF0D57C1;
        Wed, 19 Oct 2022 02:17:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D2222617ED;
        Wed, 19 Oct 2022 09:14:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF503C433D7;
        Wed, 19 Oct 2022 09:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170895;
        bh=P76NqlLy/+PZwCIIZvaC8DZgX9q9lu+DZUsFci9KUYg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=buc5oqVvmctq2dOwmW8N/va2w8b0xR1EhcFF+5BuNnAZREmonZQPDYltNJ7rNUQ4D
         q62DteNKSG7iRBe5r34nzrJro5k+OCgatVgolcyBAXCz5h5SJRxQ2iTVsDoWZ7D67O
         NOLrzS7xADYYg3q3Z2mDn6wKfZH0Psdok3Xmzll4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Derrick <Jonathan.Derrick@solidigm.com>,
        Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        Chao Leng <lengchao@huawei.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 828/862] nvme: handle effects after freeing the request
Date:   Wed, 19 Oct 2022 10:35:15 +0200
Message-Id: <20221019083326.495237379@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 8d5a7ae19844..7991d28e6a6a 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1111,8 +1111,8 @@ static u32 nvme_passthru_start(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 	return effects;
 }
 
-static void nvme_passthru_end(struct nvme_ctrl *ctrl, u32 effects,
-			      struct nvme_command *cmd, int status)
+void nvme_passthru_end(struct nvme_ctrl *ctrl, u32 effects,
+		       struct nvme_command *cmd, int status)
 {
 	if (effects & NVME_CMD_EFFECTS_CSE_MASK) {
 		nvme_unfreeze(ctrl);
@@ -1148,21 +1148,16 @@ static void nvme_passthru_end(struct nvme_ctrl *ctrl, u32 effects,
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
index 27614bee7380..d3281f87cd6e 100644
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
index 1bdf714dcd9e..a0bf9560cf67 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -1023,7 +1023,9 @@ static inline void nvme_auth_free(struct nvme_ctrl *ctrl) {};
 
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



