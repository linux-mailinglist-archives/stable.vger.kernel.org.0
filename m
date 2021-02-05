Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3ADFF311451
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 23:07:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232916AbhBEWDs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 17:03:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:44972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232854AbhBEOyx (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 09:54:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6CEFD65010;
        Fri,  5 Feb 2021 14:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612534245;
        bh=oBhnYsNMVV66Fz+ghIBTYR3QPCl/lhKdqgigRhN0PgE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WNECPeSnlqY0S69DrPtcfbyKyoOhBmG5Ab4ZLyypLar5a9V85ao+ZZLxhiNnSU7s9
         2IwSgh1QEbaSWIjzYY1+poLEVVWRp6TaPmoZ9EXV4nWJMFteXTIANs2GXwURrSirlw
         UFKxUd4ttd+SREKACceHkT5av9SYameq2qDH7sDE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Leng <lengchao@huawei.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 41/57] nvme-tcp: avoid request double completion for concurrent nvme_tcp_timeout
Date:   Fri,  5 Feb 2021 15:07:07 +0100
Message-Id: <20210205140657.738614307@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210205140655.982616732@linuxfoundation.org>
References: <20210205140655.982616732@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Leng <lengchao@huawei.com>

[ Upstream commit 9ebbfe495ecd2e51bc92ac21ed5817c3b9e223ce ]

Each name space has a request queue, if complete request long time,
multi request queues may have time out requests at the same time,
nvme_tcp_timeout will execute concurrently. Multi requests in different
request queues may be queued in the same tcp queue, multi
nvme_tcp_timeout may call nvme_tcp_stop_queue at the same time.
The first nvme_tcp_stop_queue will clear NVME_TCP_Q_LIVE and continue
stopping the tcp queue(cancel io_work), but the others check
NVME_TCP_Q_LIVE is already cleared, and then directly complete the
requests, complete request before the io work is completely canceled may
lead to a use-after-free condition.
Add a multex lock to serialize nvme_tcp_stop_queue.

Signed-off-by: Chao Leng <lengchao@huawei.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/tcp.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 81db2331f6d78..6487b7897d1fb 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -76,6 +76,7 @@ struct nvme_tcp_queue {
 	struct work_struct	io_work;
 	int			io_cpu;
 
+	struct mutex		queue_lock;
 	struct mutex		send_mutex;
 	struct llist_head	req_list;
 	struct list_head	send_list;
@@ -1219,6 +1220,7 @@ static void nvme_tcp_free_queue(struct nvme_ctrl *nctrl, int qid)
 
 	sock_release(queue->sock);
 	kfree(queue->pdu);
+	mutex_destroy(&queue->queue_lock);
 }
 
 static int nvme_tcp_init_connection(struct nvme_tcp_queue *queue)
@@ -1380,6 +1382,7 @@ static int nvme_tcp_alloc_queue(struct nvme_ctrl *nctrl,
 	struct nvme_tcp_queue *queue = &ctrl->queues[qid];
 	int ret, rcv_pdu_size;
 
+	mutex_init(&queue->queue_lock);
 	queue->ctrl = ctrl;
 	init_llist_head(&queue->req_list);
 	INIT_LIST_HEAD(&queue->send_list);
@@ -1398,7 +1401,7 @@ static int nvme_tcp_alloc_queue(struct nvme_ctrl *nctrl,
 	if (ret) {
 		dev_err(nctrl->device,
 			"failed to create socket: %d\n", ret);
-		return ret;
+		goto err_destroy_mutex;
 	}
 
 	/* Single syn retry */
@@ -1507,6 +1510,8 @@ err_crypto:
 err_sock:
 	sock_release(queue->sock);
 	queue->sock = NULL;
+err_destroy_mutex:
+	mutex_destroy(&queue->queue_lock);
 	return ret;
 }
 
@@ -1534,9 +1539,10 @@ static void nvme_tcp_stop_queue(struct nvme_ctrl *nctrl, int qid)
 	struct nvme_tcp_ctrl *ctrl = to_tcp_ctrl(nctrl);
 	struct nvme_tcp_queue *queue = &ctrl->queues[qid];
 
-	if (!test_and_clear_bit(NVME_TCP_Q_LIVE, &queue->flags))
-		return;
-	__nvme_tcp_stop_queue(queue);
+	mutex_lock(&queue->queue_lock);
+	if (test_and_clear_bit(NVME_TCP_Q_LIVE, &queue->flags))
+		__nvme_tcp_stop_queue(queue);
+	mutex_unlock(&queue->queue_lock);
 }
 
 static int nvme_tcp_start_queue(struct nvme_ctrl *nctrl, int idx)
-- 
2.27.0



