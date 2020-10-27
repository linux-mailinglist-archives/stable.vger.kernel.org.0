Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B728A29B257
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:41:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1749980AbgJ0Ojg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:39:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:38830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1761407AbgJ0Ojd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:39:33 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 58F72206B2;
        Tue, 27 Oct 2020 14:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603809571;
        bh=p7Ao6xwiYPhTOoUygIuMFHW2Bq6Zrcv+vD1LUZqNAy0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xxNNCa6kZlmda2p7OL7W4quIqsgzQ2yxwof8ZH6JQIMgH50sde/w6eBUbSyxK56/b
         xcEIV+L3j0bIMz2llFFD6uRGosvzx2Pb7fSJ/xShLGrNMX9skbeF0HhFCRpnjsfPIm
         xZYxaDtMcfyEvl6gHUMQ2Ipgqfa98wBIhn0PwtQc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 216/408] RDMA/umem: Fix ib_umem_find_best_pgsz() for mappings that cross a page boundary
Date:   Tue, 27 Oct 2020 14:52:34 +0100
Message-Id: <20201027135505.113316605@linuxfoundation.org>
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
index 0d42ba8c0b696..9be8f6c622db0 100644
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



