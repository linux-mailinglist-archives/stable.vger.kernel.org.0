Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 592AB579B15
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:25:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239571AbiGSMZD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:25:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239967AbiGSMYZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:24:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5D5061B2C;
        Tue, 19 Jul 2022 05:09:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 45127B81B1A;
        Tue, 19 Jul 2022 12:08:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91DD7C341C6;
        Tue, 19 Jul 2022 12:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658232524;
        bh=0FML8zziQm5o5Gv0XRhLDhuolhnJbtR+Wkd+wNGpKkQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0CVGBbkK4Qa+dLopt5GSZKNBLM2554+CjhZ0w4kAjX8ip2My+ijs6R+iJOi8++fLI
         yiYVGIFkFzez0vOQBAjIZrN3+f77+GOcXGr08rRpAUdQrd9qJlZlBG72Gfbkx5LW0h
         B9Jqcs5o3e43BPKtE+jNINSFgFc6MgE031QWBRWM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ruozhu Li <liruozhu@huawei.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 086/112] nvme: fix regression when disconnect a recovering ctrl
Date:   Tue, 19 Jul 2022 13:54:19 +0200
Message-Id: <20220719114634.985702444@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114626.156073229@linuxfoundation.org>
References: <20220719114626.156073229@linuxfoundation.org>
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
index af2902d70b19..ab060b4911ff 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -4460,6 +4460,8 @@ void nvme_stop_ctrl(struct nvme_ctrl *ctrl)
 	nvme_stop_keep_alive(ctrl);
 	flush_work(&ctrl->async_event_work);
 	cancel_work_sync(&ctrl->fw_act_work);
+	if (ctrl->ops->stop_ctrl)
+		ctrl->ops->stop_ctrl(ctrl);
 }
 EXPORT_SYMBOL_GPL(nvme_stop_ctrl);
 
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 8e40a6306e53..58cf9e39d613 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -478,6 +478,7 @@ struct nvme_ctrl_ops {
 	void (*free_ctrl)(struct nvme_ctrl *ctrl);
 	void (*submit_async_event)(struct nvme_ctrl *ctrl);
 	void (*delete_ctrl)(struct nvme_ctrl *ctrl);
+	void (*stop_ctrl)(struct nvme_ctrl *ctrl);
 	int (*get_address)(struct nvme_ctrl *ctrl, char *buf, int size);
 };
 
diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index 8eacc9bd58f5..b61924394032 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -1057,6 +1057,14 @@ static void nvme_rdma_teardown_io_queues(struct nvme_rdma_ctrl *ctrl,
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
@@ -2236,9 +2244,6 @@ static const struct blk_mq_ops nvme_rdma_admin_mq_ops = {
 
 static void nvme_rdma_shutdown_ctrl(struct nvme_rdma_ctrl *ctrl, bool shutdown)
 {
-	cancel_work_sync(&ctrl->err_work);
-	cancel_delayed_work_sync(&ctrl->reconnect_work);
-
 	nvme_rdma_teardown_io_queues(ctrl, shutdown);
 	blk_mq_quiesce_queue(ctrl->ctrl.admin_q);
 	if (shutdown)
@@ -2288,6 +2293,7 @@ static const struct nvme_ctrl_ops nvme_rdma_ctrl_ops = {
 	.submit_async_event	= nvme_rdma_submit_async_event,
 	.delete_ctrl		= nvme_rdma_delete_ctrl,
 	.get_address		= nvmf_get_address,
+	.stop_ctrl		= nvme_rdma_stop_ctrl,
 };
 
 /*
diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index d5e162f2c23a..fe8c27bbc3f2 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -2135,9 +2135,6 @@ static void nvme_tcp_error_recovery_work(struct work_struct *work)
 
 static void nvme_tcp_teardown_ctrl(struct nvme_ctrl *ctrl, bool shutdown)
 {
-	cancel_work_sync(&to_tcp_ctrl(ctrl)->err_work);
-	cancel_delayed_work_sync(&to_tcp_ctrl(ctrl)->connect_work);
-
 	nvme_tcp_teardown_io_queues(ctrl, shutdown);
 	blk_mq_quiesce_queue(ctrl->admin_q);
 	if (shutdown)
@@ -2177,6 +2174,12 @@ static void nvme_reset_ctrl_work(struct work_struct *work)
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
@@ -2499,6 +2502,7 @@ static const struct nvme_ctrl_ops nvme_tcp_ctrl_ops = {
 	.submit_async_event	= nvme_tcp_submit_async_event,
 	.delete_ctrl		= nvme_tcp_delete_ctrl,
 	.get_address		= nvmf_get_address,
+	.stop_ctrl		= nvme_tcp_stop_ctrl,
 };
 
 static bool
-- 
2.35.1



