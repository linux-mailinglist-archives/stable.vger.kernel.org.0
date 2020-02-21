Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C664416774B
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:42:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731086AbgBUIlS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:41:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:57334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730129AbgBUH5t (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 02:57:49 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DDC3F24656;
        Fri, 21 Feb 2020 07:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582271862;
        bh=A3r53Ti4W7H0MZfUrZJ9EtnHYp8kTdo1d+21a3Ib3lc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GX8A7WtgLVlJ6Gd4OytZgr4qlD9D5WXzR+z1DEoFyCjxj0ZTEujaYrdso8aAstP3Q
         FErGbPg9bJEbnpkHdHbpPvtdao55BnZx28/ZqNJrYzLFg90LpWMJyiE4FB4/VfnHT9
         il7PhLIjjUWdXcOw81N28DAne/2d9PS/20gq0ZyU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Olof Johansson <olof@lixom.net>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 327/399] net/mlx5e: Fix printk format warning
Date:   Fri, 21 Feb 2020 08:40:52 +0100
Message-Id: <20200221072433.015460603@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072402.315346745@linuxfoundation.org>
References: <20200221072402.315346745@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Olof Johansson <olof@lixom.net>

[ Upstream commit ca9c74ae9be5e78541c2058db9a754947a7d4a9b ]

Use "%zu" for size_t. Seen on ARM allmodconfig:

drivers/net/ethernet/mellanox/mlx5/core/wq.c: In function 'mlx5_wq_cyc_wqe_dump':
include/linux/kern_levels.h:5:18: warning: format '%ld' expects argument of type 'long int', but argument 5 has type 'size_t' {aka 'unsigned int'} [-Wformat=]

Fixes: 130c7b46c93d ("net/mlx5e: TX, Dump WQs wqe descriptors on CQE with error events")
Signed-off-by: Olof Johansson <olof@lixom.net>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/wq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/wq.c b/drivers/net/ethernet/mellanox/mlx5/core/wq.c
index f2a0e72285bac..02f7e4a39578a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/wq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/wq.c
@@ -89,7 +89,7 @@ void mlx5_wq_cyc_wqe_dump(struct mlx5_wq_cyc *wq, u16 ix, u8 nstrides)
 	len = nstrides << wq->fbc.log_stride;
 	wqe = mlx5_wq_cyc_get_wqe(wq, ix);
 
-	pr_info("WQE DUMP: WQ size %d WQ cur size %d, WQE index 0x%x, len: %ld\n",
+	pr_info("WQE DUMP: WQ size %d WQ cur size %d, WQE index 0x%x, len: %zu\n",
 		mlx5_wq_cyc_get_size(wq), wq->cur_sz, ix, len);
 	print_hex_dump(KERN_WARNING, "", DUMP_PREFIX_OFFSET, 16, 1, wqe, len, false);
 }
-- 
2.20.1



