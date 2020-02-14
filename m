Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1136915F3EC
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 19:22:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404408AbgBNSQh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 13:16:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:56478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730776AbgBNPv3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:51:29 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C885B24676;
        Fri, 14 Feb 2020 15:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695488;
        bh=9/bnzQ+ER74MOe91Hzqc8GaIE8a7Ubr1rTd8soxdpJY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UFrAZbTVwp+7GoYz4Q/QqMoWRSNcrZp1N6+ugxMakJ6J26pmnbcOUggeXnzmqX6mo
         5f6+kQ8eXSXOyIZegKfbBgpeKOvXMGkOmeson7AFA6Z1gLaA1h6eGVynATTK1jtUF+
         Tz4WuRcqxPHTzAak6l/a3XowXqnzdjIfjMmYublQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Artemy Kovalyov <artemyko@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Gal Pressman <galpress@amazon.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 118/542] RDMA/umem: Fix ib_umem_find_best_pgsz()
Date:   Fri, 14 Feb 2020 10:41:50 -0500
Message-Id: <20200214154854.6746-118-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Artemy Kovalyov <artemyko@mellanox.com>

[ Upstream commit 36798d5ae1af62e830c5e045b2e41ce038690c61 ]

Except for the last entry, the ending iova alignment sets the maximum
possible page size as the low bits of the iova must be zero when starting
the next chunk.

Fixes: 4a35339958f1 ("RDMA/umem: Add API to find best driver supported page size in an MR")
Link: https://lore.kernel.org/r/20200128135612.174820-1-leon@kernel.org
Signed-off-by: Artemy Kovalyov <artemyko@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Tested-by: Gal Pressman <galpress@amazon.com>
Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/umem.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
index 7a3b99597eada..40cadb889114f 100644
--- a/drivers/infiniband/core/umem.c
+++ b/drivers/infiniband/core/umem.c
@@ -166,10 +166,13 @@ unsigned long ib_umem_find_best_pgsz(struct ib_umem *umem,
 		 * for any address.
 		 */
 		mask |= (sg_dma_address(sg) + pgoff) ^ va;
-		if (i && i != (umem->nmap - 1))
-			/* restrict by length as well for interior SGEs */
-			mask |= sg_dma_len(sg);
 		va += sg_dma_len(sg) - pgoff;
+		/* Except for the last entry, the ending iova alignment sets
+		 * the maximum possible page size as the low bits of the iova
+		 * must be zero when starting the next chunk.
+		 */
+		if (i != (umem->nmap - 1))
+			mask |= va;
 		pgoff = 0;
 	}
 	best_pg_bit = rdma_find_pg_bit(mask, pgsz_bitmap);
-- 
2.20.1

