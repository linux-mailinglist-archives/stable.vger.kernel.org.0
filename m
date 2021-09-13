Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 115F5409357
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242176AbhIMOUy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:20:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:40122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343617AbhIMORM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:17:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 03BD161505;
        Mon, 13 Sep 2021 13:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540698;
        bh=BKAMv4qCwoIHZLJss/UEAte4OVck1eTxLt8vzO6ndA8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aSi/i23c6BXMQdihftrNFFjBdMLcesL59Wu5oF3fbg4mmO9u+0DOH1URRJo/6AUql
         OaUphVNmxiggAg/62y5plDiUFjA3H74aMKp+ORigM8fh4uZhFW08SXSbImCtCmouv1
         qZCbS4afgiyZp0FDVOvbOYzKVtjIbycAscQLSzBM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Niklas Schnelle <schnelle@linux.ibm.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 5.13 298/300] RDMA/mlx5: Fix number of allocated XLT entries
Date:   Mon, 13 Sep 2021 15:15:59 +0200
Message-Id: <20210913131119.433584265@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131109.253835823@linuxfoundation.org>
References: <20210913131109.253835823@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Niklas Schnelle <schnelle@linux.ibm.com>

commit 9660dcbe0d9186976917c94bce4e69dbd8d7a974 upstream.

In commit 8010d74b9965b ("RDMA/mlx5: Split the WR setup out of
mlx5_ib_update_xlt()") the allocation logic was split out of
mlx5_ib_update_xlt() and the logic was changed to enable better OOM
handling. Sadly this change introduced a miscalculation of the number of
entries that were actually allocated when under memory pressure where it
can actually become 0 which on s390 lets dma_map_single() fail.

It can also lead to corruption of the free pages list when the wrong
number of entries is used in the calculation of sg->length which is used
as argument for free_pages().

Fix this by using the allocation size instead of misusing get_order(size).

Cc: stable@vger.kernel.org
Fixes: 8010d74b9965 ("RDMA/mlx5: Split the WR setup out of mlx5_ib_update_xlt()")
Link: https://lore.kernel.org/r/20210908081849.7948-1-schnelle@linux.ibm.com
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/mlx5/mr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -1022,7 +1022,7 @@ static void *mlx5_ib_alloc_xlt(size_t *n
 
 	if (size > MLX5_SPARE_UMR_CHUNK) {
 		size = MLX5_SPARE_UMR_CHUNK;
-		*nents = get_order(size) / ent_size;
+		*nents = size / ent_size;
 		res = (void *)__get_free_pages(gfp_mask | __GFP_NOWARN,
 					       get_order(size));
 		if (res)


