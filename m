Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8BCE15DE9B
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 17:05:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388822AbgBNQEG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:04:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:51876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389841AbgBNQEF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:04:05 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C614F24676;
        Fri, 14 Feb 2020 16:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696244;
        bh=amYH3ceF7CJnpOkXmLfBOhz0UF9g7Vo4PvHExPucgLQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fo60p2OdVQkdaJU5HcwGRGyvBtNuwhaM8Vl6I4STAUIzxGjCtTx5j4Ts2s/RFwWB4
         9JT/LscJyblTh36Di89a6egCzIa+vGqgrt1k8rZGbYF7okXuRyLCbURmjCxkXYfka6
         0J+YJz9DkTJq0yS9wYjCkTCN7N/PFVykMAgaRLw8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Artemy Kovalyov <artemyko@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Gal Pressman <galpress@amazon.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 102/459] RDMA/umem: Fix ib_umem_find_best_pgsz()
Date:   Fri, 14 Feb 2020 10:55:52 -0500
Message-Id: <20200214160149.11681-102-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
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
index 24244a2f68cc5..0d42ba8c0b696 100644
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

