Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F8816810C5
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:06:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237085AbjA3OGf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:06:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237088AbjA3OGe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:06:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BEB21F5E6
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:06:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E76F7B81145
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:06:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D29FC433D2;
        Mon, 30 Jan 2023 14:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087590;
        bh=6B49tPf7Yh4d+JaVXRuJRfB7Mpp2mAvEKuL1d/mwQBA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xx1+cqD9OC+4LqnCKWk/0oBkBzrl6hGhCeqEpqTvKuwnBpUJDfVRRMRXnvsZeHmbH
         XkPyD9y5r00mSefp8iQtilJdV4FWwaXmcrasQTP2YGdTCPT18O9F4AiRj7MqorVtY1
         kJDFAAA67j6XmzYkBVIh+h/UI0qOHdui/FBRzfrM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 258/313] nvme: consolidate setting the tagset flags
Date:   Mon, 30 Jan 2023 14:51:33 +0100
Message-Id: <20230130134348.741689092@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit db45e1a5ddccc034eb60d62fc5352022d7963ae2 ]

All nvme transports should be using the same flags for their tagsets,
with the exception for the blocking flag that should only be set for
transports that can block in ->queue_rq.

Add a NVME_F_BLOCKING flag to nvme_ctrl_ops to control the blocking
behavior and lift setting the flags into nvme_alloc_{admin,io}_tag_set.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Stable-dep-of: 98e3528012cd ("nvme-fc: fix initialization order")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c   | 15 +++++++++------
 drivers/nvme/host/fc.c     |  4 ++--
 drivers/nvme/host/nvme.h   |  9 +++++----
 drivers/nvme/host/rdma.c   |  3 +--
 drivers/nvme/host/tcp.c    |  5 ++---
 drivers/nvme/target/loop.c |  4 ++--
 6 files changed, 21 insertions(+), 19 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index badc6984ff83..9e9ad91618ab 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -4840,8 +4840,7 @@ void nvme_complete_async_event(struct nvme_ctrl *ctrl, __le16 status,
 EXPORT_SYMBOL_GPL(nvme_complete_async_event);
 
 int nvme_alloc_admin_tag_set(struct nvme_ctrl *ctrl, struct blk_mq_tag_set *set,
-		const struct blk_mq_ops *ops, unsigned int flags,
-		unsigned int cmd_size)
+		const struct blk_mq_ops *ops, unsigned int cmd_size)
 {
 	int ret;
 
@@ -4851,7 +4850,9 @@ int nvme_alloc_admin_tag_set(struct nvme_ctrl *ctrl, struct blk_mq_tag_set *set,
 	if (ctrl->ops->flags & NVME_F_FABRICS)
 		set->reserved_tags = NVMF_RESERVED_TAGS;
 	set->numa_node = ctrl->numa_node;
-	set->flags = flags;
+	set->flags = BLK_MQ_F_NO_SCHED;
+	if (ctrl->ops->flags & NVME_F_BLOCKING)
+		set->flags |= BLK_MQ_F_BLOCKING;
 	set->cmd_size = cmd_size;
 	set->driver_data = ctrl;
 	set->nr_hw_queues = 1;
@@ -4895,8 +4896,8 @@ void nvme_remove_admin_tag_set(struct nvme_ctrl *ctrl)
 EXPORT_SYMBOL_GPL(nvme_remove_admin_tag_set);
 
 int nvme_alloc_io_tag_set(struct nvme_ctrl *ctrl, struct blk_mq_tag_set *set,
-		const struct blk_mq_ops *ops, unsigned int flags,
-		unsigned int nr_maps, unsigned int cmd_size)
+		const struct blk_mq_ops *ops, unsigned int nr_maps,
+		unsigned int cmd_size)
 {
 	int ret;
 
@@ -4905,7 +4906,9 @@ int nvme_alloc_io_tag_set(struct nvme_ctrl *ctrl, struct blk_mq_tag_set *set,
 	set->queue_depth = ctrl->sqsize + 1;
 	set->reserved_tags = NVMF_RESERVED_TAGS;
 	set->numa_node = ctrl->numa_node;
-	set->flags = flags;
+	set->flags = BLK_MQ_F_SHOULD_MERGE;
+	if (ctrl->ops->flags & NVME_F_BLOCKING)
+		set->flags |= BLK_MQ_F_BLOCKING;
 	set->cmd_size = cmd_size,
 	set->driver_data = ctrl;
 	set->nr_hw_queues = ctrl->queue_count - 1;
diff --git a/drivers/nvme/host/fc.c b/drivers/nvme/host/fc.c
index 20b0c29a9a34..5f07a6b29276 100644
--- a/drivers/nvme/host/fc.c
+++ b/drivers/nvme/host/fc.c
@@ -2903,7 +2903,7 @@ nvme_fc_create_io_queues(struct nvme_fc_ctrl *ctrl)
 	nvme_fc_init_io_queues(ctrl);
 
 	ret = nvme_alloc_io_tag_set(&ctrl->ctrl, &ctrl->tag_set,
-			&nvme_fc_mq_ops, BLK_MQ_F_SHOULD_MERGE, 1,
+			&nvme_fc_mq_ops, 1,
 			struct_size((struct nvme_fcp_op_w_sgl *)NULL, priv,
 				    ctrl->lport->ops->fcprqst_priv_sz));
 	if (ret)
@@ -3509,7 +3509,7 @@ nvme_fc_init_ctrl(struct device *dev, struct nvmf_ctrl_options *opts,
 	nvme_fc_init_queue(ctrl, 0);
 
 	ret = nvme_alloc_admin_tag_set(&ctrl->ctrl, &ctrl->admin_tag_set,
-			&nvme_fc_admin_mq_ops, BLK_MQ_F_NO_SCHED,
+			&nvme_fc_admin_mq_ops,
 			struct_size((struct nvme_fcp_op_w_sgl *)NULL, priv,
 				    ctrl->lport->ops->fcprqst_priv_sz));
 	if (ret)
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index aef3693ba5d3..01d90424af53 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -508,6 +508,8 @@ struct nvme_ctrl_ops {
 	unsigned int flags;
 #define NVME_F_FABRICS			(1 << 0)
 #define NVME_F_METADATA_SUPPORTED	(1 << 1)
+#define NVME_F_BLOCKING			(1 << 2)
+
 	const struct attribute_group **dev_attr_groups;
 	int (*reg_read32)(struct nvme_ctrl *ctrl, u32 off, u32 *val);
 	int (*reg_write32)(struct nvme_ctrl *ctrl, u32 off, u32 val);
@@ -739,12 +741,11 @@ void nvme_start_ctrl(struct nvme_ctrl *ctrl);
 void nvme_stop_ctrl(struct nvme_ctrl *ctrl);
 int nvme_init_ctrl_finish(struct nvme_ctrl *ctrl);
 int nvme_alloc_admin_tag_set(struct nvme_ctrl *ctrl, struct blk_mq_tag_set *set,
-		const struct blk_mq_ops *ops, unsigned int flags,
-		unsigned int cmd_size);
+		const struct blk_mq_ops *ops, unsigned int cmd_size);
 void nvme_remove_admin_tag_set(struct nvme_ctrl *ctrl);
 int nvme_alloc_io_tag_set(struct nvme_ctrl *ctrl, struct blk_mq_tag_set *set,
-		const struct blk_mq_ops *ops, unsigned int flags,
-		unsigned int nr_maps, unsigned int cmd_size);
+		const struct blk_mq_ops *ops, unsigned int nr_maps,
+		unsigned int cmd_size);
 void nvme_remove_io_tag_set(struct nvme_ctrl *ctrl);
 
 void nvme_remove_namespaces(struct nvme_ctrl *ctrl);
diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index a55d3e8b607d..6f918e61b6ae 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -798,7 +798,7 @@ static int nvme_rdma_alloc_tag_set(struct nvme_ctrl *ctrl)
 			    NVME_RDMA_METADATA_SGL_SIZE;
 
 	return nvme_alloc_io_tag_set(ctrl, &to_rdma_ctrl(ctrl)->tag_set,
-			&nvme_rdma_mq_ops, BLK_MQ_F_SHOULD_MERGE,
+			&nvme_rdma_mq_ops,
 			ctrl->opts->nr_poll_queues ? HCTX_MAX_TYPES : 2,
 			cmd_size);
 }
@@ -848,7 +848,6 @@ static int nvme_rdma_configure_admin_queue(struct nvme_rdma_ctrl *ctrl,
 	if (new) {
 		error = nvme_alloc_admin_tag_set(&ctrl->ctrl,
 				&ctrl->admin_tag_set, &nvme_rdma_admin_mq_ops,
-				BLK_MQ_F_NO_SCHED,
 				sizeof(struct nvme_rdma_request) +
 				NVME_RDMA_DATA_SGL_SIZE);
 		if (error)
diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 83735c52d34a..eacd445b5333 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -1867,7 +1867,6 @@ static int nvme_tcp_configure_io_queues(struct nvme_ctrl *ctrl, bool new)
 	if (new) {
 		ret = nvme_alloc_io_tag_set(ctrl, &to_tcp_ctrl(ctrl)->tag_set,
 				&nvme_tcp_mq_ops,
-				BLK_MQ_F_SHOULD_MERGE | BLK_MQ_F_BLOCKING,
 				ctrl->opts->nr_poll_queues ? HCTX_MAX_TYPES : 2,
 				sizeof(struct nvme_tcp_request));
 		if (ret)
@@ -1943,7 +1942,7 @@ static int nvme_tcp_configure_admin_queue(struct nvme_ctrl *ctrl, bool new)
 	if (new) {
 		error = nvme_alloc_admin_tag_set(ctrl,
 				&to_tcp_ctrl(ctrl)->admin_tag_set,
-				&nvme_tcp_admin_mq_ops, BLK_MQ_F_BLOCKING,
+				&nvme_tcp_admin_mq_ops,
 				sizeof(struct nvme_tcp_request));
 		if (error)
 			goto out_free_queue;
@@ -2524,7 +2523,7 @@ static const struct blk_mq_ops nvme_tcp_admin_mq_ops = {
 static const struct nvme_ctrl_ops nvme_tcp_ctrl_ops = {
 	.name			= "tcp",
 	.module			= THIS_MODULE,
-	.flags			= NVME_F_FABRICS,
+	.flags			= NVME_F_FABRICS | NVME_F_BLOCKING,
 	.reg_read32		= nvmf_reg_read32,
 	.reg_read64		= nvmf_reg_read64,
 	.reg_write32		= nvmf_reg_write32,
diff --git a/drivers/nvme/target/loop.c b/drivers/nvme/target/loop.c
index 08c583258e90..c864e902e91e 100644
--- a/drivers/nvme/target/loop.c
+++ b/drivers/nvme/target/loop.c
@@ -353,7 +353,7 @@ static int nvme_loop_configure_admin_queue(struct nvme_loop_ctrl *ctrl)
 	ctrl->ctrl.queue_count = 1;
 
 	error = nvme_alloc_admin_tag_set(&ctrl->ctrl, &ctrl->admin_tag_set,
-			&nvme_loop_admin_mq_ops, BLK_MQ_F_NO_SCHED,
+			&nvme_loop_admin_mq_ops,
 			sizeof(struct nvme_loop_iod) +
 			NVME_INLINE_SG_CNT * sizeof(struct scatterlist));
 	if (error)
@@ -494,7 +494,7 @@ static int nvme_loop_create_io_queues(struct nvme_loop_ctrl *ctrl)
 		return ret;
 
 	ret = nvme_alloc_io_tag_set(&ctrl->ctrl, &ctrl->tag_set,
-			&nvme_loop_mq_ops, BLK_MQ_F_SHOULD_MERGE, 1,
+			&nvme_loop_mq_ops, 1,
 			sizeof(struct nvme_loop_iod) +
 			NVME_INLINE_SG_CNT * sizeof(struct scatterlist));
 	if (ret)
-- 
2.39.0



