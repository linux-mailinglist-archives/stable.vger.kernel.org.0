Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81E312F79EE
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:44:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387705AbhAOMi7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:38:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:45320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733170AbhAOMi5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:38:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3506C221F7;
        Fri, 15 Jan 2021 12:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610714321;
        bh=VqkreAKszS+n/ERWS2oz0G9vE1L6QkQiC9wKE1WxPI0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c+qWKNhn3hOmEveP/FE7iKFS2E5yIglYO9v6vJQ2Nr5rtUzblu9In8yJyUuk6NdCS
         JWD0y3vmKOFQgnp+554qYRk3ydT/JW7GWj0BKnPo2kIrRvF+ra8ZHHiSc7+L3Xapn4
         2qET3WPoVUwEjJcz9MoCmT6fiJu3EsNQJ5ekCpIE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Potnuri Bharat Teja <bharat@chelsio.com>,
        Samuel Jones <sjones@kalrayinc.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5.10 083/103] nvme-tcp: Fix possible race of io_work and direct send
Date:   Fri, 15 Jan 2021 13:28:16 +0100
Message-Id: <20210115122010.034701969@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115122006.047132306@linuxfoundation.org>
References: <20210115122006.047132306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sagi Grimberg <sagi@grimberg.me>

commit 5c11f7d9f843bdd24cd29b95401938bc3f168070 upstream.

We may send a request (with or without its data) from two paths:

  1. From our I/O context nvme_tcp_io_work which is triggered from:
    - queue_rq
    - r2t reception
    - socket data_ready and write_space callbacks
  2. Directly from queue_rq if the send_list is empty (because we want to
     save the context switch associated with scheduling our io_work).

However, given that now we have the send_mutex, we may run into a race
condition where none of these contexts will send the pending payload to
the controller. Both io_work send path and queue_rq send path
opportunistically attempt to acquire the send_mutex however queue_rq only
attempts to send a single request, and if io_work context fails to
acquire the send_mutex it will complete without rescheduling itself.

The race can trigger with the following sequence:

  1. queue_rq sends request (no incapsule data) and blocks
  2. RX path receives r2t - prepares data PDU to send, adds h2cdata PDU
     to the send_list and schedules io_work
  3. io_work triggers and cannot acquire the send_mutex - because of (1),
     ends without self rescheduling
  4. queue_rq completes the send, and completes

==> no context will send the h2cdata - timeout.

Fix this by having queue_rq sending as much as it can from the send_list
such that if it still has any left, its because the socket buffer is
full and the socket write_space callback will trigger, thus guaranteeing
that a context will be scheduled to send the h2cdata PDU.

Fixes: db5ad6b7f8cd ("nvme-tcp: try to send request in queue_rq context")
Reported-by: Potnuri Bharat Teja <bharat@chelsio.com>
Reported-by: Samuel Jones <sjones@kalrayinc.com>
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Tested-by: Potnuri Bharat Teja <bharat@chelsio.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/nvme/host/tcp.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -262,6 +262,16 @@ static inline void nvme_tcp_advance_req(
 	}
 }
 
+static inline void nvme_tcp_send_all(struct nvme_tcp_queue *queue)
+{
+	int ret;
+
+	/* drain the send queue as much as we can... */
+	do {
+		ret = nvme_tcp_try_send(queue);
+	} while (ret > 0);
+}
+
 static inline void nvme_tcp_queue_request(struct nvme_tcp_request *req,
 		bool sync, bool last)
 {
@@ -279,7 +289,7 @@ static inline void nvme_tcp_queue_reques
 	if (queue->io_cpu == smp_processor_id() &&
 	    sync && empty && mutex_trylock(&queue->send_mutex)) {
 		queue->more_requests = !last;
-		nvme_tcp_try_send(queue);
+		nvme_tcp_send_all(queue);
 		queue->more_requests = false;
 		mutex_unlock(&queue->send_mutex);
 	} else if (last) {


