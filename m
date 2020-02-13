Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7141515C480
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:53:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729435AbgBMPrw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:47:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:47986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727986AbgBMP06 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:26:58 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 23AAF24677;
        Thu, 13 Feb 2020 15:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607618;
        bh=Qi7UqkWj3azxCJlMz34Rq3df9Z8YUBZlDpzh1tYSrkc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oRm4rnDUArGq0hMl+SMRmNOZ4gR0eAHq4lIf04cHObxre5HlF2dTtfv/aZSAfnhiU
         ZQMcNeIrEnKPPeCJl/iLjXDCswdRMVUI0CMHaEIcnEZf4mTIVp85FSPsRWikZ/LDSU
         a4cSmhBsacLKdlhA65+w31WpxONhm9OZc6bwJ7DQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Artemy Kovalyov <artemyko@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Gal Pressman <galpress@amazon.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 5.4 11/96] RDMA/umem: Fix ib_umem_find_best_pgsz()
Date:   Thu, 13 Feb 2020 07:20:18 -0800
Message-Id: <20200213151843.594895581@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151839.156309910@linuxfoundation.org>
References: <20200213151839.156309910@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Artemy Kovalyov <artemyko@mellanox.com>

commit 36798d5ae1af62e830c5e045b2e41ce038690c61 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/core/umem.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/infiniband/core/umem.c
+++ b/drivers/infiniband/core/umem.c
@@ -166,10 +166,13 @@ unsigned long ib_umem_find_best_pgsz(str
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


