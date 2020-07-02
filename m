Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D717321185A
	for <lists+stable@lfdr.de>; Thu,  2 Jul 2020 03:28:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729397AbgGBB1K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jul 2020 21:27:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:58808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729395AbgGBB1J (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Jul 2020 21:27:09 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 46C7D214D8;
        Thu,  2 Jul 2020 01:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593653229;
        bh=7KAztGtg5zIFVJoJpv7CQCGrmy5Zf3wf58AWBtyQj04=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q3Yx1Y6Y+8szKr712igEHEcAP/NQDLSHakcELQX+QtiPF+NYTcoyq+SNkGBGocdVf
         z4EqlgxFFCYWDAjiLCfsk9PtXjGKYAxOBB8Olk5BcAR7EAIxuL7J7nes9vr6/wE0hK
         PeqSCt9QDOG4+UcpHbh/1EYE8Rl7AjcONAab3NNI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 4.14 15/17] nvme-rdma: assign completion vector correctly
Date:   Wed,  1 Jul 2020 21:26:47 -0400
Message-Id: <20200702012649.2701799-15-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200702012649.2701799-1-sashal@kernel.org>
References: <20200702012649.2701799-1-sashal@kernel.org>
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
index 9fffe41ead500..c91bfd839cabe 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -470,7 +470,7 @@ static int nvme_rdma_create_queue_ib(struct nvme_rdma_queue *queue)
 	 * Spread I/O queues completion vectors according their queue index.
 	 * Admin queues can always go on completion vector 0.
 	 */
-	comp_vector = idx == 0 ? idx : idx - 1;
+	comp_vector = (idx == 0 ? idx : idx - 1) % ibdev->num_comp_vectors;
 
 	/* +1 for ib_stop_cq */
 	queue->ib_cq = ib_alloc_cq(ibdev, queue,
-- 
2.25.1

