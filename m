Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 160386ECE4E
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 15:31:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232369AbjDXNbQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 09:31:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232408AbjDXNa4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 09:30:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F86E7A91
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 06:30:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 70FEC62342
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 13:30:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85ED1C433EF;
        Mon, 24 Apr 2023 13:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682343024;
        bh=LMdn5b8DYMjLIsno/r7MNoufviBpYbWA6uqi/1Vy1x8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CKV3P0c4BkjwcXiPDPwWBObg+Ppc97xhsWhesoOEPBJGwVzol5xpW2H4d5cAjrjtO
         MMx1U4j46KEqTM4EncwSNefXNhB2pVoCUywmOSY6uusk3XP/9uWoY6aRJM8PqqutLd
         Aeg0Auzo5qStGpjuYDQWpCjf4n0HqQSRGML62l4k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yanjun Zhang <zhangyanjun@cestc.cn>,
        Sagi Grimberg <sagi@grimberg.me>,
        Yanjun Zhang <zhangyanjun@cestc.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 049/110] nvme-tcp: fix a possible UAF when failing to allocate an io queue
Date:   Mon, 24 Apr 2023 15:17:11 +0200
Message-Id: <20230424131138.086722413@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131136.142490414@linuxfoundation.org>
References: <20230424131136.142490414@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sagi Grimberg <sagi@grimberg.me>

[ Upstream commit 88eaba80328b31ef81813a1207b4056efd7006a6 ]

When we allocate a nvme-tcp queue, we set the data_ready callback before
we actually need to use it. This creates the potential that if a stray
controller sends us data on the socket before we connect, we can trigger
the io_work and start consuming the socket.

In this case reported: we failed to allocate one of the io queues, and
as we start releasing the queues that we already allocated, we get
a UAF [1] from the io_work which is running before it should really.

Fix this by setting the socket ops callbacks only before we start the
queue, so that we can't accidentally schedule the io_work in the
initialization phase before the queue started. While we are at it,
rename nvme_tcp_restore_sock_calls to pair with nvme_tcp_setup_sock_ops.

[1]:
[16802.107284] nvme nvme4: starting error recovery
[16802.109166] nvme nvme4: Reconnecting in 10 seconds...
[16812.173535] nvme nvme4: failed to connect socket: -111
[16812.173745] nvme nvme4: Failed reconnect attempt 1
[16812.173747] nvme nvme4: Reconnecting in 10 seconds...
[16822.413555] nvme nvme4: failed to connect socket: -111
[16822.413762] nvme nvme4: Failed reconnect attempt 2
[16822.413765] nvme nvme4: Reconnecting in 10 seconds...
[16832.661274] nvme nvme4: creating 32 I/O queues.
[16833.919887] BUG: kernel NULL pointer dereference, address: 0000000000000088
[16833.920068] nvme nvme4: Failed reconnect attempt 3
[16833.920094] #PF: supervisor write access in kernel mode
[16833.920261] nvme nvme4: Reconnecting in 10 seconds...
[16833.920368] #PF: error_code(0x0002) - not-present page
[16833.921086] Workqueue: nvme_tcp_wq nvme_tcp_io_work [nvme_tcp]
[16833.921191] RIP: 0010:_raw_spin_lock_bh+0x17/0x30
...
[16833.923138] Call Trace:
[16833.923271]  <TASK>
[16833.923402]  lock_sock_nested+0x1e/0x50
[16833.923545]  nvme_tcp_try_recv+0x40/0xa0 [nvme_tcp]
[16833.923685]  nvme_tcp_io_work+0x68/0xa0 [nvme_tcp]
[16833.923824]  process_one_work+0x1e8/0x390
[16833.923969]  worker_thread+0x53/0x3d0
[16833.924104]  ? process_one_work+0x390/0x390
[16833.924240]  kthread+0x124/0x150
[16833.924376]  ? set_kthread_struct+0x50/0x50
[16833.924518]  ret_from_fork+0x1f/0x30
[16833.924655]  </TASK>

Reported-by: Yanjun Zhang <zhangyanjun@cestc.cn>
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Tested-by: Yanjun Zhang <zhangyanjun@cestc.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/tcp.c | 46 +++++++++++++++++++++++------------------
 1 file changed, 26 insertions(+), 20 deletions(-)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 1ca52ac163c2f..2c15412649bab 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -1605,22 +1605,7 @@ static int nvme_tcp_alloc_queue(struct nvme_ctrl *nctrl, int qid)
 	if (ret)
 		goto err_init_connect;
 
-	queue->rd_enabled = true;
 	set_bit(NVME_TCP_Q_ALLOCATED, &queue->flags);
-	nvme_tcp_init_recv_ctx(queue);
-
-	write_lock_bh(&queue->sock->sk->sk_callback_lock);
-	queue->sock->sk->sk_user_data = queue;
-	queue->state_change = queue->sock->sk->sk_state_change;
-	queue->data_ready = queue->sock->sk->sk_data_ready;
-	queue->write_space = queue->sock->sk->sk_write_space;
-	queue->sock->sk->sk_data_ready = nvme_tcp_data_ready;
-	queue->sock->sk->sk_state_change = nvme_tcp_state_change;
-	queue->sock->sk->sk_write_space = nvme_tcp_write_space;
-#ifdef CONFIG_NET_RX_BUSY_POLL
-	queue->sock->sk->sk_ll_usec = 1;
-#endif
-	write_unlock_bh(&queue->sock->sk->sk_callback_lock);
 
 	return 0;
 
@@ -1640,7 +1625,7 @@ static int nvme_tcp_alloc_queue(struct nvme_ctrl *nctrl, int qid)
 	return ret;
 }
 
-static void nvme_tcp_restore_sock_calls(struct nvme_tcp_queue *queue)
+static void nvme_tcp_restore_sock_ops(struct nvme_tcp_queue *queue)
 {
 	struct socket *sock = queue->sock;
 
@@ -1655,7 +1640,7 @@ static void nvme_tcp_restore_sock_calls(struct nvme_tcp_queue *queue)
 static void __nvme_tcp_stop_queue(struct nvme_tcp_queue *queue)
 {
 	kernel_sock_shutdown(queue->sock, SHUT_RDWR);
-	nvme_tcp_restore_sock_calls(queue);
+	nvme_tcp_restore_sock_ops(queue);
 	cancel_work_sync(&queue->io_work);
 }
 
@@ -1673,21 +1658,42 @@ static void nvme_tcp_stop_queue(struct nvme_ctrl *nctrl, int qid)
 	mutex_unlock(&queue->queue_lock);
 }
 
+static void nvme_tcp_setup_sock_ops(struct nvme_tcp_queue *queue)
+{
+	write_lock_bh(&queue->sock->sk->sk_callback_lock);
+	queue->sock->sk->sk_user_data = queue;
+	queue->state_change = queue->sock->sk->sk_state_change;
+	queue->data_ready = queue->sock->sk->sk_data_ready;
+	queue->write_space = queue->sock->sk->sk_write_space;
+	queue->sock->sk->sk_data_ready = nvme_tcp_data_ready;
+	queue->sock->sk->sk_state_change = nvme_tcp_state_change;
+	queue->sock->sk->sk_write_space = nvme_tcp_write_space;
+#ifdef CONFIG_NET_RX_BUSY_POLL
+	queue->sock->sk->sk_ll_usec = 1;
+#endif
+	write_unlock_bh(&queue->sock->sk->sk_callback_lock);
+}
+
 static int nvme_tcp_start_queue(struct nvme_ctrl *nctrl, int idx)
 {
 	struct nvme_tcp_ctrl *ctrl = to_tcp_ctrl(nctrl);
+	struct nvme_tcp_queue *queue = &ctrl->queues[idx];
 	int ret;
 
+	queue->rd_enabled = true;
+	nvme_tcp_init_recv_ctx(queue);
+	nvme_tcp_setup_sock_ops(queue);
+
 	if (idx)
 		ret = nvmf_connect_io_queue(nctrl, idx);
 	else
 		ret = nvmf_connect_admin_queue(nctrl);
 
 	if (!ret) {
-		set_bit(NVME_TCP_Q_LIVE, &ctrl->queues[idx].flags);
+		set_bit(NVME_TCP_Q_LIVE, &queue->flags);
 	} else {
-		if (test_bit(NVME_TCP_Q_ALLOCATED, &ctrl->queues[idx].flags))
-			__nvme_tcp_stop_queue(&ctrl->queues[idx]);
+		if (test_bit(NVME_TCP_Q_ALLOCATED, &queue->flags))
+			__nvme_tcp_stop_queue(queue);
 		dev_err(nctrl->device,
 			"failed to connect queue: %d ret=%d\n", idx, ret);
 	}
-- 
2.39.2



