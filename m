Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6535E13E891
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 18:33:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404604AbgAPRaj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:30:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:43244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404595AbgAPRah (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:30:37 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4983424713;
        Thu, 16 Jan 2020 17:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579195837;
        bh=dnaNne4GSkC2Muvq5tt3Y2IwM3WltMgeSzV1DPWsPyU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2AdEGaycO9zflI/JBer8zuCGcfng3tC4WBHuiOmnqXyeZ04CwPzw4i3iKcU/iXR//
         O0bC+k2BY1gHfMpyhXaXGhFpM8Nf3aDE3mh/9ktQU0qTKxs15KQJLDFSB4fbfSdSlO
         0lDHhkgppM1ibToQRtW5E9QsZFDv+V25jmex9DVk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 341/371] RDMA/mlx5: Return proper error value
Date:   Thu, 16 Jan 2020 12:23:33 -0500
Message-Id: <20200116172403.18149-284-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116172403.18149-1-sashal@kernel.org>
References: <20200116172403.18149-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

[ Upstream commit 546d30099ed204792083f043cd7e016de86016a3 ]

Returned value from mlx5_mr_cache_alloc() is checked to be error or real
pointer. Return proper error code instead of NULL which is not checked
later.

Fixes: 81713d3788d2 ("IB/mlx5: Add implicit MR support")
Link: https://lore.kernel.org/r/20191029055721.7192-1-leon@kernel.org
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/mr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index cfddca850cb4..fb45bfa4f845 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -460,7 +460,7 @@ struct mlx5_ib_mr *mlx5_mr_cache_alloc(struct mlx5_ib_dev *dev, int entry)
 
 	if (entry < 0 || entry >= MAX_MR_CACHE_ENTRIES) {
 		mlx5_ib_err(dev, "cache entry %d is out of range\n", entry);
-		return NULL;
+		return ERR_PTR(-EINVAL);
 	}
 
 	ent = &cache->ent[entry];
-- 
2.20.1

