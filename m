Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0537296068
	for <lists+stable@lfdr.de>; Tue, 20 Aug 2019 15:41:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730200AbfHTNko (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Aug 2019 09:40:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:35528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730191AbfHTNko (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Aug 2019 09:40:44 -0400
Received: from sasha-vm.mshome.net (unknown [12.236.144.82])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 06E6F233FD;
        Tue, 20 Aug 2019 13:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566308442;
        bh=wrtHcq4kfUS2OeuyILfRvP+0aTPZhyJjoVgq26BJaiw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CUXMCtF0eEsSXw0Rt63uQcJ2UxeyrNIeEABfPDMjwmZRnYN+gAxXngyuUCXW3zwIx
         jlwz+9j4elue6P0TO7IsTgOs2V/uC8ZQ3p7+T7f4KuVjN3b0oZwPwYMN1JYik1U1Ly
         sXdFMQhcVAkphWBtwYeS0MMzUJe/uq/UnxZaD7BU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sagi Grimberg <sagi@grimberg.me>,
        Nicolas Morey-Chaisemartin <NMoreyChaisemartin@suse.com>,
        Max Gurtovoy <maxg@mellanox.com>,
        Hannes Reinecke <hare@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.2 15/44] nvme-rdma: fix possible use-after-free in connect error flow
Date:   Tue, 20 Aug 2019 09:39:59 -0400
Message-Id: <20190820134028.10829-15-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190820134028.10829-1-sashal@kernel.org>
References: <20190820134028.10829-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sagi Grimberg <sagi@grimberg.me>

[ Upstream commit d94211b8bad3787e0655a67284105f57db728cb1 ]

When start_queue fails, we need to make sure to drain the
queue cq before freeing the rdma resources because we might
still race with the completion path. Have start_queue() error
path safely stop the queue.

--
[30371.808111] nvme nvme1: Failed reconnect attempt 11
[30371.808113] nvme nvme1: Reconnecting in 10 seconds...
[...]
[30382.069315] nvme nvme1: creating 4 I/O queues.
[30382.257058] nvme nvme1: Connect Invalid SQE Parameter, qid 4
[30382.257061] nvme nvme1: failed to connect queue: 4 ret=386
[30382.305001] BUG: unable to handle kernel NULL pointer dereference at 0000000000000018
[30382.305022] IP: qedr_poll_cq+0x8a3/0x1170 [qedr]
[30382.305028] PGD 0 P4D 0
[30382.305037] Oops: 0000 [#1] SMP PTI
[...]
[30382.305153] Call Trace:
[30382.305166]  ? __switch_to_asm+0x34/0x70
[30382.305187]  __ib_process_cq+0x56/0xd0 [ib_core]
[30382.305201]  ib_poll_handler+0x26/0x70 [ib_core]
[30382.305213]  irq_poll_softirq+0x88/0x110
[30382.305223]  ? sort_range+0x20/0x20
[30382.305232]  __do_softirq+0xde/0x2c6
[30382.305241]  ? sort_range+0x20/0x20
[30382.305249]  run_ksoftirqd+0x1c/0x60
[30382.305258]  smpboot_thread_fn+0xef/0x160
[30382.305265]  kthread+0x113/0x130
[30382.305273]  ? kthread_create_worker_on_cpu+0x50/0x50
[30382.305281]  ret_from_fork+0x35/0x40
--

Reported-by: Nicolas Morey-Chaisemartin <NMoreyChaisemartin@suse.com>
Reviewed-by: Max Gurtovoy <maxg@mellanox.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/rdma.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index 97f668a39ae1c..7b074323bcdf2 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -562,13 +562,17 @@ static int nvme_rdma_alloc_queue(struct nvme_rdma_ctrl *ctrl,
 	return ret;
 }
 
+static void __nvme_rdma_stop_queue(struct nvme_rdma_queue *queue)
+{
+	rdma_disconnect(queue->cm_id);
+	ib_drain_qp(queue->qp);
+}
+
 static void nvme_rdma_stop_queue(struct nvme_rdma_queue *queue)
 {
 	if (!test_and_clear_bit(NVME_RDMA_Q_LIVE, &queue->flags))
 		return;
-
-	rdma_disconnect(queue->cm_id);
-	ib_drain_qp(queue->qp);
+	__nvme_rdma_stop_queue(queue);
 }
 
 static void nvme_rdma_free_queue(struct nvme_rdma_queue *queue)
@@ -607,11 +611,13 @@ static int nvme_rdma_start_queue(struct nvme_rdma_ctrl *ctrl, int idx)
 	else
 		ret = nvmf_connect_admin_queue(&ctrl->ctrl);
 
-	if (!ret)
+	if (!ret) {
 		set_bit(NVME_RDMA_Q_LIVE, &queue->flags);
-	else
+	} else {
+		__nvme_rdma_stop_queue(queue);
 		dev_info(ctrl->ctrl.device,
 			"failed to connect queue: %d ret=%d\n", idx, ret);
+	}
 	return ret;
 }
 
-- 
2.20.1

