Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 058412117F7
	for <lists+stable@lfdr.de>; Thu,  2 Jul 2020 03:28:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728523AbgGBBX4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jul 2020 21:23:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:54690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728521AbgGBBXy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Jul 2020 21:23:54 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C8272082F;
        Thu,  2 Jul 2020 01:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593653033;
        bh=gYrUy+2BPIkfxEAcimiUvhDES1CyrM816VquNjMev6s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F5ZHT+iQ2wRGiCYcw/IkRiVnhCkVmv/YEzZ5bH4EWsRTMyW5pJrLDTBGCn6lIpFSu
         Y184QWXHgBsIYa7zzZgtqQkrbHge2wbvJl1OYl4hQ25KnA6Yc97jHW1mmjmZgjD9wZ
         tgzdW4xc9IogIot0cYmR+H8ionQBmUSN5x9kG8hY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.7 47/53] nvme-rdma: assign completion vector correctly
Date:   Wed,  1 Jul 2020 21:21:56 -0400
Message-Id: <20200702012202.2700645-47-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200702012202.2700645-1-sashal@kernel.org>
References: <20200702012202.2700645-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Max Gurtovoy <maxg@mellanox.com>

[ Upstream commit 032a9966a22a3596addf81dacf0c1736dfedc32a ]

The completion vector index that is given during CQ creation can't
exceed the number of support vectors by the underlying RDMA device. This
violation currently can accure, for example, in case one will try to
connect with N regular read/write queues and M poll queues and the sum
of N + M > num_supported_vectors. This will lead to failure in establish
a connection to remote target. Instead, in that case, share a completion
vector between queues.

Signed-off-by: Max Gurtovoy <maxg@mellanox.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/rdma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index cac8a930396a0..1f9a45145d0d3 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -443,7 +443,7 @@ static int nvme_rdma_create_queue_ib(struct nvme_rdma_queue *queue)
 	 * Spread I/O queues completion vectors according their queue index.
 	 * Admin queues can always go on completion vector 0.
 	 */
-	comp_vector = idx == 0 ? idx : idx - 1;
+	comp_vector = (idx == 0 ? idx : idx - 1) % ibdev->num_comp_vectors;
 
 	/* Polling queues need direct cq polling context */
 	if (nvme_rdma_poll_queue(queue))
-- 
2.25.1

