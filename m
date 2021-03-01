Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ABC6328C85
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:54:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240665AbhCASxX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:53:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:53936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240421AbhCASqp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:46:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7853264F45;
        Mon,  1 Mar 2021 17:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618851;
        bh=UDF5jyk/gV0RH6B4X9+TOSmZZHyWmpJTDx6OtgDFrbw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zPaETHoe3fH9ggu/kvnGeFmVVKtOMEIY/35XsWnwuou6aG576AOcLf+4v9OkFJrQI
         3Fwq3jKmi2kOthDdPkonhZwBlnXW0ktWJDhFx0Qo2+nWZdV5kwgZnpraH6ll1/0F1C
         VMSPuorHgmE2C1CEGOHPR2JQv+Olhz9YzV+7JGVg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Elad Grupi <elad.grupi@dell.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 241/663] nvmet-tcp: fix potential race of tcp socket closing accept_work
Date:   Mon,  1 Mar 2021 17:08:09 +0100
Message-Id: <20210301161153.745307078@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sagi Grimberg <sagi@grimberg.me>

[ Upstream commit 0fbcfb089a3f2f2a731d01f0aec8f7697a849c28 ]

When we accept a TCP connection and allocate an nvmet-tcp queue we should
make sure not to fully establish it or reference it as the connection may
be already closing, which triggers queue release work, which does not
fence against queue establishment.

In order to address such a race, we make sure to check the sk_state and
contain the queue reference to be done underneath the sk_callback_lock
such that the queue release work correctly fences against it.

Fixes: 872d26a391da ("nvmet-tcp: add NVMe over TCP target driver")
Reported-by: Elad Grupi <elad.grupi@dell.com>
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/tcp.c | 28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/drivers/nvme/target/tcp.c b/drivers/nvme/target/tcp.c
index 577ce7d403ae9..8b0485ada315b 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -1485,17 +1485,27 @@ static int nvmet_tcp_set_queue_sock(struct nvmet_tcp_queue *queue)
 	if (inet->rcv_tos > 0)
 		ip_sock_set_tos(sock->sk, inet->rcv_tos);
 
+	ret = 0;
 	write_lock_bh(&sock->sk->sk_callback_lock);
-	sock->sk->sk_user_data = queue;
-	queue->data_ready = sock->sk->sk_data_ready;
-	sock->sk->sk_data_ready = nvmet_tcp_data_ready;
-	queue->state_change = sock->sk->sk_state_change;
-	sock->sk->sk_state_change = nvmet_tcp_state_change;
-	queue->write_space = sock->sk->sk_write_space;
-	sock->sk->sk_write_space = nvmet_tcp_write_space;
+	if (sock->sk->sk_state != TCP_ESTABLISHED) {
+		/*
+		 * If the socket is already closing, don't even start
+		 * consuming it
+		 */
+		ret = -ENOTCONN;
+	} else {
+		sock->sk->sk_user_data = queue;
+		queue->data_ready = sock->sk->sk_data_ready;
+		sock->sk->sk_data_ready = nvmet_tcp_data_ready;
+		queue->state_change = sock->sk->sk_state_change;
+		sock->sk->sk_state_change = nvmet_tcp_state_change;
+		queue->write_space = sock->sk->sk_write_space;
+		sock->sk->sk_write_space = nvmet_tcp_write_space;
+		queue_work_on(queue_cpu(queue), nvmet_tcp_wq, &queue->io_work);
+	}
 	write_unlock_bh(&sock->sk->sk_callback_lock);
 
-	return 0;
+	return ret;
 }
 
 static int nvmet_tcp_alloc_queue(struct nvmet_tcp_port *port,
@@ -1543,8 +1553,6 @@ static int nvmet_tcp_alloc_queue(struct nvmet_tcp_port *port,
 	if (ret)
 		goto out_destroy_sq;
 
-	queue_work_on(queue_cpu(queue), nvmet_tcp_wq, &queue->io_work);
-
 	return 0;
 out_destroy_sq:
 	mutex_lock(&nvmet_tcp_queue_mutex);
-- 
2.27.0



