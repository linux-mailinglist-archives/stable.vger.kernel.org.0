Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 480D34520B2
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:53:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343576AbhKPA4O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:56:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:44602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343511AbhKOTVQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:21:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DB847635A3;
        Mon, 15 Nov 2021 18:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001680;
        bh=vJnfOCZ8vea6UkbVMNQ8UAMgF7L+8I8+dl4sj2Vz51k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q5GkEuDr+xt3v97fa/kcC1bM6D3/0UJTup5xNM9Z8CdkksHTL41xEwY2QEa2MslnB
         6prudVb3/jD1cyYlJnAEHfe79q9zgBvNQDXwYFLqeF4F84CxthvnpQ0xtGTeI1mwDm
         Mp/BuBlcS33St6q9flatSh6PjIwGlLXFOHMkWlxQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Israel Rukshin <israelr@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 280/917] nvmet-tcp: fix use-after-free when a port is removed
Date:   Mon, 15 Nov 2021 17:56:15 +0100
Message-Id: <20211115165438.270015588@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Israel Rukshin <israelr@nvidia.com>

[ Upstream commit 2351ead99ce9164fb42555aee3f96af84c4839e9 ]

When removing a port, all its controllers are being removed, but there
are queues on the port that doesn't belong to any controller (during
connection time). This causes a use-after-free bug for any command
that dereferences req->port (like in nvmet_alloc_ctrl). Those queues
should be destroyed before freeing the port via configfs. Destroy
the remaining queues after the accept_work was cancelled guarantees
that no new queue will be created.

Signed-off-by: Israel Rukshin <israelr@nvidia.com>
Reviewed-by: Max Gurtovoy <mgurtovoy@nvidia.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/tcp.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/nvme/target/tcp.c b/drivers/nvme/target/tcp.c
index 46c3b3be7e033..84c387e4bf431 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -1740,6 +1740,17 @@ err_port:
 	return ret;
 }
 
+static void nvmet_tcp_destroy_port_queues(struct nvmet_tcp_port *port)
+{
+	struct nvmet_tcp_queue *queue;
+
+	mutex_lock(&nvmet_tcp_queue_mutex);
+	list_for_each_entry(queue, &nvmet_tcp_queue_list, queue_list)
+		if (queue->port == port)
+			kernel_sock_shutdown(queue->sock, SHUT_RDWR);
+	mutex_unlock(&nvmet_tcp_queue_mutex);
+}
+
 static void nvmet_tcp_remove_port(struct nvmet_port *nport)
 {
 	struct nvmet_tcp_port *port = nport->priv;
@@ -1749,6 +1760,11 @@ static void nvmet_tcp_remove_port(struct nvmet_port *nport)
 	port->sock->sk->sk_user_data = NULL;
 	write_unlock_bh(&port->sock->sk->sk_callback_lock);
 	cancel_work_sync(&port->accept_work);
+	/*
+	 * Destroy the remaining queues, which are not belong to any
+	 * controller yet.
+	 */
+	nvmet_tcp_destroy_port_queues(port);
 
 	sock_release(port->sock);
 	kfree(port);
-- 
2.33.0



