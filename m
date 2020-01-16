Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F38113FFE3
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:47:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390888AbgAPXWE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:22:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:49780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388394AbgAPXWD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:22:03 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5EA3F2075B;
        Thu, 16 Jan 2020 23:22:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579216922;
        bh=s8TLmbI5O28ao/0WFz+LLo1bxPeLMw8soqZjjhXbPtM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ST6rDSsCD8IORsUu7D6G889UVLcd8M1asu+m4h3JHuySqrU5reDEscGoe6SnJv6PY
         +1dt6wmELfLmXc3Q5h9GxtPKIVJb8xUkxBGpb1d/rYHx81qlVSjVk0M+qIfGi1fgZI
         5A6BdKcJz4C/6TUnzCVl6LvBemt2Pzs/iQ2EBoJI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 5.4 075/203] RDMA/mlx5: Return proper error value
Date:   Fri, 17 Jan 2020 00:16:32 +0100
Message-Id: <20200116231750.786477600@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231745.218684830@linuxfoundation.org>
References: <20200116231745.218684830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

commit 546d30099ed204792083f043cd7e016de86016a3 upstream.

Returned value from mlx5_mr_cache_alloc() is checked to be error or real
pointer. Return proper error code instead of NULL which is not checked
later.

Fixes: 81713d3788d2 ("IB/mlx5: Add implicit MR support")
Link: https://lore.kernel.org/r/20191029055721.7192-1-leon@kernel.org
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/hw/mlx5/mr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -428,7 +428,7 @@ struct mlx5_ib_mr *mlx5_mr_cache_alloc(s
 
 	if (entry < 0 || entry >= MAX_MR_CACHE_ENTRIES) {
 		mlx5_ib_err(dev, "cache entry %d is out of range\n", entry);
-		return NULL;
+		return ERR_PTR(-EINVAL);
 	}
 
 	ent = &cache->ent[entry];


