Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7FD529B501
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:12:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1793671AbgJ0PHp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:07:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:39906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1790977AbgJ0PF1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:05:27 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 795E721D24;
        Tue, 27 Oct 2020 15:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811127;
        bh=9f4+uAfiCuPnTchHdA/S0iTbc7bUScTWH8ZY+V7qBY0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ep2l+5pcAoE9JdqtrFws+TuB0kPO/b4kOpmNx+PjOiP++s9q+neHOBYtVDh8gi9zH
         Tc2C9CRum+Br6jk6C0nfi+tQ705zY1X3D/bpFLZx3KvIb+wgHgXxbX4jH7w8ymxQ6H
         OAnklPkr/vqEycDd1xYgKjvyvyivZnQ3QrXI7Pyo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 352/633] RDMA/umem: Fix ib_umem_find_best_pgsz() for mappings that cross a page boundary
Date:   Tue, 27 Oct 2020 14:51:35 +0100
Message-Id: <20201027135539.201018525@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit a40c20dabdf9045270767c75918feb67f0727c89 ]

It is possible for a single SGL to span an aligned boundary, eg if the SGL
is

  61440 -> 90112

Then the length is 28672, which currently limits the block size to
32k. With a 32k page size the two covering blocks will be:

  32768->65536 and 65536->98304

However, the correct answer is a 128K block size which will span the whole
28672 bytes in a single block.

Instead of limiting based on length figure out which high IOVA bits don't
change between the start and end addresses. That is the highest useful
page size.

Fixes: 4a35339958f1 ("RDMA/umem: Add API to find best driver supported page size in an MR")
Link: https://lore.kernel.org/r/1-v2-270386b7e60b+28f4-umem_1_jgg@nvidia.com
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Reviewed-by: Shiraz Saleem <shiraz.saleem@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/umem.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
index 82455a1392f1d..1173b8cbe92b5 100644
--- a/drivers/infiniband/core/umem.c
+++ b/drivers/infiniband/core/umem.c
@@ -156,8 +156,13 @@ unsigned long ib_umem_find_best_pgsz(struct ib_umem *umem,
 		return 0;
 
 	va = virt;
-	/* max page size not to exceed MR length */
-	mask = roundup_pow_of_two(umem->length);
+	/* The best result is the smallest page size that results in the minimum
+	 * number of required pages. Compute the largest page size that could
+	 * work based on VA address bits that don't change.
+	 */
+	mask = pgsz_bitmap &
+	       GENMASK(BITS_PER_LONG - 1,
+		       bits_per((umem->length - 1 + virt) ^ virt));
 	/* offset into first SGL */
 	pgoff = umem->address & ~PAGE_MASK;
 
-- 
2.25.1



