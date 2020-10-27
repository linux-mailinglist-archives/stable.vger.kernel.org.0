Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 195A329B982
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:11:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802553AbgJ0PuE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:50:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:59510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1801324AbgJ0PkC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:40:02 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 104DE22283;
        Tue, 27 Oct 2020 15:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813200;
        bh=ZJqjsdKlIez/izupHcMQW/SuMX9IgbuRMm3o5iN5rcc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wooLhz8E8YIaKpSi/P6GuWqA025CzEWFsl0S1rXlP9hzMtZ17AN2KLmfyEnPne+BK
         LM4B1wbKzd78Jqu10pOIHER8Mhp9B4CORzfcbyXOJp1B4kIDpu99Scor40XoSkVl7t
         6muFu7Z3Se/P7ty5zC0IDHg8GlmPoIVYWBG2GbaU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liu Shixin <liushixin2@huawei.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 470/757] RDMA/mlx5: Fix type warning of sizeof in __mlx5_ib_alloc_counters()
Date:   Tue, 27 Oct 2020 14:52:00 +0100
Message-Id: <20201027135512.558148464@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liu Shixin <liushixin2@huawei.com>

[ Upstream commit b942fc0319a72b83146b79619eb578e989062911 ]

sizeof() when applied to a pointer typed expression should give the size
of the pointed data, even if the data is a pointer.

Fixes: e1f24a79f424 ("IB/mlx5: Support congestion related counters")
Link: https://lore.kernel.org/r/20200917081354.2083293-1-liushixin2@huawei.com
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Acked-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/counters.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/counters.c b/drivers/infiniband/hw/mlx5/counters.c
index 145f3cb40ccba..aeeb14ecb3ee7 100644
--- a/drivers/infiniband/hw/mlx5/counters.c
+++ b/drivers/infiniband/hw/mlx5/counters.c
@@ -456,12 +456,12 @@ static int __mlx5_ib_alloc_counters(struct mlx5_ib_dev *dev,
 		cnts->num_ext_ppcnt_counters = ARRAY_SIZE(ext_ppcnt_cnts);
 		num_counters += ARRAY_SIZE(ext_ppcnt_cnts);
 	}
-	cnts->names = kcalloc(num_counters, sizeof(cnts->names), GFP_KERNEL);
+	cnts->names = kcalloc(num_counters, sizeof(*cnts->names), GFP_KERNEL);
 	if (!cnts->names)
 		return -ENOMEM;
 
 	cnts->offsets = kcalloc(num_counters,
-				sizeof(cnts->offsets), GFP_KERNEL);
+				sizeof(*cnts->offsets), GFP_KERNEL);
 	if (!cnts->offsets)
 		goto err_names;
 
-- 
2.25.1



