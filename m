Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23ECD29B25B
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:41:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1750050AbgJ0Ojm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:39:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:38976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1761428AbgJ0Ojl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:39:41 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0AC9E207BB;
        Tue, 27 Oct 2020 14:39:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603809580;
        bh=czBi+i+yWR3U8R14MI2nOBnY/yIBtgjCkoed06usKzI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LFPXzRDAZkSkxqVIii6IPu3ZsbQc4K6c+2OeO3JaWxSJWtyK2XpJZUhkCSNv7obr0
         GCbqDaQAPX8yyvYkBnMwXV8gp18vMq3lGPzweJULkPx2C2kc+elOUuUpERnwg3HNug
         3fVDfskoGbDJbAT44CxVMP5lvA31GNvej14DJhr0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 217/408] RDMA/umem: Prevent small pages from being returned by ib_umem_find_best_pgsz()
Date:   Tue, 27 Oct 2020 14:52:35 +0100
Message-Id: <20201027135505.160569924@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit 10c75ccb54e4fe548cb16d7ed426d7d709e6ae76 ]

rdma_for_each_block() makes assumptions about how the SGL is constructed
that don't work if the block size is below the page size used to to build
the SGL.

The rules for umem SGL construction require that the SG's all be PAGE_SIZE
aligned and we don't encode the actual byte offset of the VA range inside
the SGL using offset and length. So rdma_for_each_block() has no idea
where the actual starting/ending point is to compute the first/last block
boundary if the starting address should be within a SGL.

Fixing the SGL construction turns out to be really hard, and will be the
subject of other patches. For now block smaller pages.

Fixes: 4a35339958f1 ("RDMA/umem: Add API to find best driver supported page size in an MR")
Link: https://lore.kernel.org/r/2-v2-270386b7e60b+28f4-umem_1_jgg@nvidia.com
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Reviewed-by: Shiraz Saleem <shiraz.saleem@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/umem.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
index 9be8f6c622db0..650f71dd4ab93 100644
--- a/drivers/infiniband/core/umem.c
+++ b/drivers/infiniband/core/umem.c
@@ -151,6 +151,12 @@ unsigned long ib_umem_find_best_pgsz(struct ib_umem *umem,
 	dma_addr_t mask;
 	int i;
 
+	/* rdma_for_each_block() has a bug if the page size is smaller than the
+	 * page size used to build the umem. For now prevent smaller page sizes
+	 * from being returned.
+	 */
+	pgsz_bitmap &= GENMASK(BITS_PER_LONG - 1, PAGE_SHIFT);
+
 	/* At minimum, drivers must support PAGE_SIZE or smaller */
 	if (WARN_ON(!(pgsz_bitmap & GENMASK(PAGE_SHIFT, 0))))
 		return 0;
-- 
2.25.1



