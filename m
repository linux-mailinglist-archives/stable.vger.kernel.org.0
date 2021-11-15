Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69B9845101F
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:39:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239222AbhKOSlp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:41:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:46110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242594AbhKOSiw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:38:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9065361B31;
        Mon, 15 Nov 2021 18:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999441;
        bh=GUBZCDcM+14HimVrjOfSaQj1OnzYDQvIihXlxTd5mmQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2UzPts2lRPdEM9p5IZ7A3FQN/soJ16X7bfnpgvNtVg9RLI51IpvsscEr6V6OLtePy
         eTggnS/IQl+vpBH9y6YdAEnjY0vBH3wbBsp0f+7ogic0ZHvh7l413t4YIvYL/nE4I0
         /5UC7Tf6d5RICBx2+QVY/OrurpVLMV3x54CTbcUA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Israel Rukshin <israelr@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 298/849] nvmet-rdma: fix use-after-free when a port is removed
Date:   Mon, 15 Nov 2021 17:56:21 +0100
Message-Id: <20211115165430.340106572@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Israel Rukshin <israelr@nvidia.com>

[ Upstream commit fcf73a804c7d6bbf0ea63531c6122aa363852e04 ]

When removing a port, all its controllers are being removed, but there
are queues on the port that doesn't belong to any controller (during
connection time). This causes a use-after-free bug for any command
that dereferences req->port (like in nvmet_alloc_ctrl). Those queues
should be destroyed before freeing the port via configfs. Destroy the
remaining queues after the RDMA-CM was destroyed guarantees that no
new queue will be created.

Signed-off-by: Israel Rukshin <israelr@nvidia.com>
Reviewed-by: Max Gurtovoy <mgurtovoy@nvidia.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/rdma.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/nvme/target/rdma.c b/drivers/nvme/target/rdma.c
index 891174ccd44bb..f1eedbf493d5b 100644
--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -1818,12 +1818,36 @@ restart:
 	mutex_unlock(&nvmet_rdma_queue_mutex);
 }
 
+static void nvmet_rdma_destroy_port_queues(struct nvmet_rdma_port *port)
+{
+	struct nvmet_rdma_queue *queue, *tmp;
+	struct nvmet_port *nport = port->nport;
+
+	mutex_lock(&nvmet_rdma_queue_mutex);
+	list_for_each_entry_safe(queue, tmp, &nvmet_rdma_queue_list,
+				 queue_list) {
+		if (queue->port != nport)
+			continue;
+
+		list_del_init(&queue->queue_list);
+		__nvmet_rdma_queue_disconnect(queue);
+	}
+	mutex_unlock(&nvmet_rdma_queue_mutex);
+}
+
 static void nvmet_rdma_disable_port(struct nvmet_rdma_port *port)
 {
 	struct rdma_cm_id *cm_id = xchg(&port->cm_id, NULL);
 
 	if (cm_id)
 		rdma_destroy_id(cm_id);
+
+	/*
+	 * Destroy the remaining queues, which are not belong to any
+	 * controller yet. Do it here after the RDMA-CM was destroyed
+	 * guarantees that no new queue will be created.
+	 */
+	nvmet_rdma_destroy_port_queues(port);
 }
 
 static int nvmet_rdma_enable_port(struct nvmet_rdma_port *port)
-- 
2.33.0



