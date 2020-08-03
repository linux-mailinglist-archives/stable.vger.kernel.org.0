Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4712523A6EF
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:56:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726823AbgHCM4M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:56:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:56080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729349AbgHCMz7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:55:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B7BA20678;
        Mon,  3 Aug 2020 12:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596459357;
        bh=BeTP5E8N4TxHgMJsyoBUItQTsU9Pz7lqhT9OygRn2fQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q384vg0KQ0kX8W2mC5CRWdfcQc9pFoT309rijIeIAE4T7X2j6LaR5XYyO1HvF+CH9
         mWix7Nqi2accfd1CE3Drm42+bj+IZAEQqxbfvWhVH+TcxzsB9497EsOfBfoXnd2mqa
         ZgX1NnJBOI4Z03NwkAY+9UvpamUxDd3JqqMkr154=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 081/120] RDMA/core: Free DIM memory in error unwind
Date:   Mon,  3 Aug 2020 14:18:59 +0200
Message-Id: <20200803121906.816057541@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121902.860751811@linuxfoundation.org>
References: <20200803121902.860751811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

[ Upstream commit fb448ce87a4a9482b084e67faf804aec79ed9b43 ]

The memory allocated for the DIM wasn't freed in in error unwind path, fix
it by calling to rdma_dim_destroy().

Fixes: da6629793aa6 ("RDMA/core: Provide RDMA DIM support for ULPs")
Link: https://lore.kernel.org/r/20200730082719.1582397-4-leon@kernel.org
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Reviewed-by: Max Gurtovoy <maxg@mellanox.com <mailto:maxg@mellanox.com>>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/cq.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/core/cq.c b/drivers/infiniband/core/cq.c
index c259f632f257f..6bb62d04030ac 100644
--- a/drivers/infiniband/core/cq.c
+++ b/drivers/infiniband/core/cq.c
@@ -270,6 +270,7 @@ struct ib_cq *__ib_alloc_cq_user(struct ib_device *dev, void *private,
 	return cq;
 
 out_destroy_cq:
+	rdma_dim_destroy(cq);
 	rdma_restrack_del(&cq->res);
 	cq->device->ops.destroy_cq(cq, udata);
 out_free_wc:
-- 
2.25.1



