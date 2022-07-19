Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55E4B579F10
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 15:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243199AbiGSNKU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 09:10:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243464AbiGSNJ3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 09:09:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B758D64E2C;
        Tue, 19 Jul 2022 05:28:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E5ED360908;
        Tue, 19 Jul 2022 12:28:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C485DC341CA;
        Tue, 19 Jul 2022 12:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233697;
        bh=evHbPrbLErwFnenjaPOjmPLeCXe9hedm/8y5RIUGgxs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0K7D+CEo/MJqo6YyynWw+omvcGNIKdC1hA8My/rgAeUm7F+V+gUw5btSwLH/plsB3
         4lKucXOEp+Awwo0yCYorQLoq/vmD+8wXizvZwAI/++FVO7gmcIXj/wCvnb8gH3uvQ1
         yGqYSTzQeQ0ivVy90j7jkJWPlcY48JZNZSTqgudI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ruozhu Li <liruozhu@huawei.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 181/231] nvme: fix regression when disconnect a recovering ctrl
Date:   Tue, 19 Jul 2022 13:54:26 +0200
Message-Id: <20220719114729.438020723@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114714.247441733@linuxfoundation.org>
References: <20220719114714.247441733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ruozhu Li <liruozhu@huawei.com>

[ Upstream commit f7f70f4aa09dc43d7455c060143e86a017c30548 ]

We encountered a problem that the disconnect command hangs.
After analyzing the log and stack, we found that the triggering
process is as follows:
CPU0                          CPU1
                                nvme_rdma_error_recovery_work
                                  nvme_rdma_teardown_io_queues
nvme_do_delete_ctrl                 nvme_stop_queues
  nvme_remove_namespaces
  --clear ctrl->namespaces
                                    nvme_start_queues
                                    --no ns in ctrl->namespaces
    nvme_ns_remove                  return(because ctrl is deleting)
      blk_freeze_queue
        blk_mq_freeze_queue_wait
        --wait for ns to unquiesce to clean infligt IO, hang forever

This problem was not found in older kernels because we will flush
err work in nvme_stop_ctrl before nvme_remove_namespaces.It does not
seem to be modified for functional reasons, the patch can be revert
to solve the problem.

Revert commit 794a4cb3d2f7 ("nvme: remove the .stop_ctrl callout")

Signed-off-by: Ruozhu Li <liruozhu@huawei.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c |  2 ++
 drivers/nvme/host/nvme.h |  1 +
 drivers/nvme/host/rdma.c | 12 +++++++++---
 drivers/nvme/host/tcp.c  | 10 +++++++---
 4 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 0fef31c935de..c9831daafbc6 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -4519,6 +4519,8 @@ void nvme_stop_ctrl(struct nvme_ctrl *ctrl)
 	nvme_stop_failfast_work(ctrl);
 	flush_work(&ctrl->async_event_work);
 	cancel_work_sync(&ctrl->fw_act_work);
+	if (ctrl->ops->stop_ctrl)
+		ctrl->ops->stop_ctrl(ctrl);
 }
 EXPORT_SYMBOL_GPL(nvme_stop_ctrl);
 
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index a2b53ca63335..337ae1e3ad25 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -501,6 +501,7 @@ struct nvme_ctrl_ops {
 	void (*free_ctrl)(struct nvme_ctrl *ctrl);
 	void (*submit_async_event)(struct nvme_ctrl *ctrl);
 	void (*delete_ctrl)(struct nvme_ctrl *ctrl);
+	void (*stop_ctrl)(struct nvme_ctrl *ctrl);
 	int (*get_address)(struct nvme_ctrl *ctrl, char *buf, int size);
 };
 
diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index d9f19d901313..5aef2b81dbec 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -1048,6 +1048,14 @@ static void nvme_rdma_teardown_io_queues(struct nvme_rdma_ctrl *ctrl,
 	}
 }
 
+static void nvme_rdma_stop_ctrl(struct nvme_ctrl *nctrl)
+{
+	struct nvme_rdma_ctrl *ctrl = to_rdma_ctrl(nctrl);
+
+	cancel_work_sync(&ctrl->err_work);
+	cancel_delayed_work_sync(&ctrl->reconnect_work);
+}
+
 static void nvme_rdma_free_ctrl(struct nvme_ctrl *nctrl)
 {
 	struct nvme_rdma_ctrl *ctrl = to_rdma_ctrl(nctrl);
@@ -2255,9 +2263,6 @@ static const struct blk_mq_ops nvme_rdma_admin_mq_ops = {
 
 static void nvme_rdma_shutdown_ctrl(struct nvme_rdma_ctrl *ctrl, bool shutdown)
 {
-	cancel_work_sync(&ctrl->err_work);
-	cancel_delayed_work_sync(&ctrl->reconnect_work);
-
 	nvme_rdma_teardown_io_queues(ctrl, shutdown);
 	nvme_stop_admin_queue(&ctrl->ctrl);
 	if (shutdown)
@@ -2307,6 +2312,7 @@ static const struct nvme_ctrl_ops nvme_rdma_ctrl_ops = {
 	.submit_async_event	= nvme_rdma_submit_async_event,
 	.delete_ctrl		= nvme_rdma_delete_ctrl,
 	.get_address		= nvmf_get_address,
+	.stop_ctrl		= nvme_rdma_stop_ctrl,
 };
 
 /*
diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index e44d0570e694..1fb4f9b1621e 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -2193,9 +2193,6 @@ static void nvme_tcp_error_recovery_work(struct work_struct *work)
 
 static void nvme_tcp_teardown_ctrl(struct nvme_ctrl *ctrl, bool shutdown)
 {
-	cancel_work_sync(&to_tcp_ctrl(ctrl)->err_work);
-	cancel_delayed_work_sync(&to_tcp_ctrl(ctrl)->connect_work);
-
 	nvme_tcp_teardown_io_queues(ctrl, shutdown);
 	nvme_stop_admin_queue(ctrl);
 	if (shutdown)
@@ -2235,6 +2232,12 @@ static void nvme_reset_ctrl_work(struct work_struct *work)
 	nvme_tcp_reconnect_or_remove(ctrl);
 }
 
+static void nvme_tcp_stop_ctrl(struct nvme_ctrl *ctrl)
+{
+	cancel_work_sync(&to_tcp_ctrl(ctrl)->err_work);
+	cancel_delayed_work_sync(&to_tcp_ctrl(ctrl)->connect_work);
+}
+
 static void nvme_tcp_free_ctrl(struct nvme_ctrl *nctrl)
 {
 	struct nvme_tcp_ctrl *ctrl = to_tcp_ctrl(nctrl);
@@ -2559,6 +2562,7 @@ static const struct nvme_ctrl_ops nvme_tcp_ctrl_ops = {
 	.submit_async_event	= nvme_tcp_submit_async_event,
 	.delete_ctrl		= nvme_tcp_delete_ctrl,
 	.get_address		= nvmf_get_address,
+	.stop_ctrl		= nvme_tcp_stop_ctrl,
 };
 
 static bool
-- 
2.35.1



