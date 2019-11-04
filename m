Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63178EEE8C
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:15:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389339AbfKDWFj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:05:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:37084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389855AbfKDWFi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 17:05:38 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 275202084D;
        Mon,  4 Nov 2019 22:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572905137;
        bh=ZsYsQjET2eBXHpj8p6+4hCJCBPZ/9D9ILF5vWY4Tb/w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X9OAwlNPp6tIZbR5D+cXiUTUqmdCsic4LPGruLKkLsmSU4aA4nFSJzF+NmHyq3n95
         dyVvIhztNu6s+/bZOaTr15WYnRq2qxxhf+FQ3khkEhZ9C/wjl+3Qt+iNs2eZ9PS1Ba
         tifMUKM1xqdQHCRJ0bEUu/hAWcS4ljBA6Z28v48k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Artemy Kovalyov <artemyko@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 040/163] RDMA/mlx5: Do not allow rereg of a ODP MR
Date:   Mon,  4 Nov 2019 22:43:50 +0100
Message-Id: <20191104212143.191554020@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212140.046021995@linuxfoundation.org>
References: <20191104212140.046021995@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gunthorpe <jgg@mellanox.com>

[ Upstream commit 880505cfef1d086d18b59d2920eb2160429ffa1f ]

This code is completely broken, the umem of a ODP MR simply cannot be
discarded without a lot more locking, nor can an ODP mkey be blithely
destroyed via destroy_mkey().

Fixes: 6aec21f6a832 ("IB/mlx5: Page faults handling infrastructure")
Link: https://lore.kernel.org/r/20191001153821.23621-2-jgg@ziepe.ca
Reviewed-by: Artemy Kovalyov <artemyko@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/mr.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 3401f5f6792e6..c4ba8838d2c46 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -1423,6 +1423,9 @@ int mlx5_ib_rereg_user_mr(struct ib_mr *ib_mr, int flags, u64 start,
 	if (!mr->umem)
 		return -EINVAL;
 
+	if (is_odp_mr(mr))
+		return -EOPNOTSUPP;
+
 	if (flags & IB_MR_REREG_TRANS) {
 		addr = virt_addr;
 		len = length;
@@ -1468,8 +1471,6 @@ int mlx5_ib_rereg_user_mr(struct ib_mr *ib_mr, int flags, u64 start,
 		}
 
 		mr->allocated_from_cache = 0;
-		if (IS_ENABLED(CONFIG_INFINIBAND_ON_DEMAND_PAGING))
-			mr->live = 1;
 	} else {
 		/*
 		 * Send a UMR WQE
@@ -1498,7 +1499,6 @@ int mlx5_ib_rereg_user_mr(struct ib_mr *ib_mr, int flags, u64 start,
 
 	set_mr_fields(dev, mr, npages, len, access_flags);
 
-	update_odp_mr(mr);
 	return 0;
 
 err:
-- 
2.20.1



