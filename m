Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3944921FBEA
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 21:05:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730804AbgGNSyw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 14:54:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:52382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730799AbgGNSyv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 14:54:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E76822BF3;
        Tue, 14 Jul 2020 18:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594752891;
        bh=gYrUy+2BPIkfxEAcimiUvhDES1CyrM816VquNjMev6s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kP67fMjXkmPRGUVYtqjmUM2Pj7W/bHY+32gdKYkawlO7rZh7m2tYlREzXxHQXOsOI
         ybCEHxahgi8NjP2uE+n9roA2/9N+60DAS/ldhW9rjBM/TTY2eEDk5ctyvg7Y6U504Z
         k1K7kxqhYpXXgppaCpVkNAnT0OkUM1DSHfqluVOQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Max Gurtovoy <maxg@mellanox.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 040/166] nvme-rdma: assign completion vector correctly
Date:   Tue, 14 Jul 2020 20:43:25 +0200
Message-Id: <20200714184117.797576293@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714184115.844176932@linuxfoundation.org>
References: <20200714184115.844176932@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



