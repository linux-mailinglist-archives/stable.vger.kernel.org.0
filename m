Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8075B412533
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:40:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349264AbhITSmU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:42:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:55446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1382289AbhITSkR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:40:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0DAE361AE3;
        Mon, 20 Sep 2021 17:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632159057;
        bh=GQ9Hjf8jdHUQKaUZs0FQHaJeQIsI/aTAi3HlkZztRWw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wGEaNQ+onQQ4l75I8WNoFaOScRYJGrGamgO7k/O6fpQFtjx9GBDafldIj+MQDPc3L
         UEUSm/WvNsCMw/i+vK5hXsi0aqmVQqMv6QX+HrcCe/MAGlfBFlvtV5G7Sc9KKCJQeU
         aa1Mchl0s6q9eJCEEe0+BsBsk1xqVim3jjN7e0Gc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Samuel Jones <sjones@kalrayinc.com>,
        Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5.14 055/168] nvme-tcp: fix io_work priority inversion
Date:   Mon, 20 Sep 2021 18:43:13 +0200
Message-Id: <20210920163923.447961491@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163921.633181900@linuxfoundation.org>
References: <20210920163921.633181900@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Keith Busch <kbusch@kernel.org>

commit 70f437fb4395ad4d1d16fab9a1ad9fbc9fc0579b upstream.

Dispatching requests inline with the .queue_rq() call may block while
holding the send_mutex. If the tcp io_work also happens to schedule, it
may see the req_list is non-empty, leaving "pending" true and remaining
in TASK_RUNNING. Since io_work is of higher scheduling priority, the
.queue_rq task may not get a chance to run, blocking forward progress
and leading to io timeouts.

Instead of checking for pending requests within io_work, let the queueing
restart io_work outside the send_mutex lock if there is more work to be
done.

Fixes: a0fdd1418007f ("nvme-tcp: rerun io_work if req_list is not empty")
Reported-by: Samuel Jones <sjones@kalrayinc.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/tcp.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -273,6 +273,12 @@ static inline void nvme_tcp_send_all(str
 	} while (ret > 0);
 }
 
+static inline bool nvme_tcp_queue_more(struct nvme_tcp_queue *queue)
+{
+	return !list_empty(&queue->send_list) ||
+		!llist_empty(&queue->req_list) || queue->more_requests;
+}
+
 static inline void nvme_tcp_queue_request(struct nvme_tcp_request *req,
 		bool sync, bool last)
 {
@@ -293,9 +299,10 @@ static inline void nvme_tcp_queue_reques
 		nvme_tcp_send_all(queue);
 		queue->more_requests = false;
 		mutex_unlock(&queue->send_mutex);
-	} else if (last) {
-		queue_work_on(queue->io_cpu, nvme_tcp_wq, &queue->io_work);
 	}
+
+	if (last && nvme_tcp_queue_more(queue))
+		queue_work_on(queue->io_cpu, nvme_tcp_wq, &queue->io_work);
 }
 
 static void nvme_tcp_process_req_list(struct nvme_tcp_queue *queue)
@@ -893,12 +900,6 @@ done:
 	read_unlock_bh(&sk->sk_callback_lock);
 }
 
-static inline bool nvme_tcp_queue_more(struct nvme_tcp_queue *queue)
-{
-	return !list_empty(&queue->send_list) ||
-		!llist_empty(&queue->req_list) || queue->more_requests;
-}
-
 static inline void nvme_tcp_done_send_req(struct nvme_tcp_queue *queue)
 {
 	queue->request = NULL;
@@ -1132,8 +1133,7 @@ static void nvme_tcp_io_work(struct work
 				pending = true;
 			else if (unlikely(result < 0))
 				break;
-		} else
-			pending = !llist_empty(&queue->req_list);
+		}
 
 		result = nvme_tcp_try_recv(queue);
 		if (result > 0)


