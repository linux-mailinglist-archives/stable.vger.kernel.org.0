Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60AD920DAD3
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:14:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731877AbgF2UBC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 16:01:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:47650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387544AbgF2TkP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:40:15 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 96B6E248B7;
        Mon, 29 Jun 2020 15:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444410;
        bh=W2lKIUT3jvh1ulzHEggBPfEuSFTuH8fB8H2owCNbxLU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DaNDUx0OYV32jLcOj8Ei9n5B08vWHtOen2lVVUw25vgMRhU7xskiJV97CxVmZhnfj
         +fKmgJ9zB6Kgf40P5mDzjL16GHjuYR6dUzfbZBuvn6q4dUZWXZaHwksV17QFQLrLeT
         Zg6JeQ5bln2RuZIN0H4o6kdXLGEIgHPTcaGCsjlU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Fan Guo <guofan5@huawei.com>, Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 088/178] RDMA/mad: Fix possible memory leak in ib_mad_post_receive_mads()
Date:   Mon, 29 Jun 2020 11:23:53 -0400
Message-Id: <20200629152523.2494198-89-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629152523.2494198-1-sashal@kernel.org>
References: <20200629152523.2494198-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.50-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.50-rc1
X-KernelTest-Deadline: 2020-07-01T15:25+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fan Guo <guofan5@huawei.com>

[ Upstream commit a17f4bed811c60712d8131883cdba11a105d0161 ]

If ib_dma_mapping_error() returns non-zero value,
ib_mad_post_receive_mads() will jump out of loops and return -ENOMEM
without freeing mad_priv. Fix this memory-leak problem by freeing mad_priv
in this case.

Fixes: 2c34e68f4261 ("IB/mad: Check and handle potential DMA mapping errors")
Link: https://lore.kernel.org/r/20200612063824.180611-1-guofan5@huawei.com
Signed-off-by: Fan Guo <guofan5@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/mad.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index a9e00cdf717b8..2284930b5f915 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -2960,6 +2960,7 @@ static int ib_mad_post_receive_mads(struct ib_mad_qp_info *qp_info,
 						 DMA_FROM_DEVICE);
 		if (unlikely(ib_dma_mapping_error(qp_info->port_priv->device,
 						  sg_list.addr))) {
+			kfree(mad_priv);
 			ret = -ENOMEM;
 			break;
 		}
-- 
2.25.1

