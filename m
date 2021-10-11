Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15A8B42903D
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:05:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238890AbhJKOGY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:06:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:56936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241116AbhJKOEb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 10:04:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B8A9060C49;
        Mon, 11 Oct 2021 13:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960749;
        bh=aRUBQiLKTc1U76VKQgr+lKkvBOulBlt/odEEDJxdU1Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ffR1/6C5A3Em1iZo+jO0Qq1sCgX6bpaUppRN5vplNE9NeoxrurZus3NcVZ5WbsKPE
         eDV8GEVL0VALIr4qNI2BnbR1M8OaKF+ox7OpjJOtcbXxxXjNVMuE1sSeqPSBXCs92U
         8pSpajbDkU+CNaDKSV5LdAY9ZeSyEKHCVnRsMpaQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shay Drory <shayd@nvidia.com>,
        Parav Pandit <parav@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 064/151] net/mlx5: Fix setting number of EQs of SFs
Date:   Mon, 11 Oct 2021 15:45:36 +0200
Message-Id: <20211011134519.905672454@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134517.833565002@linuxfoundation.org>
References: <20211011134517.833565002@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shay Drory <shayd@nvidia.com>

[ Upstream commit f88c4876347400a577598e06f1b230a7b19ee0e9 ]

When setting number of completion EQs of the SF, consider number of
online CPUs.
Without this consideration, when number of online cpus are less than 8,
unnecessary 8 completion EQs are allocated.

Fixes: c36326d38d93 ("net/mlx5: Round-Robin EQs over IRQs")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
index 49e6f5003991..d9345c9ebbff 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
@@ -610,8 +610,9 @@ void mlx5_irq_table_destroy(struct mlx5_core_dev *dev)
 int mlx5_irq_table_get_sfs_vec(struct mlx5_irq_table *table)
 {
 	if (table->sf_comp_pool)
-		return table->sf_comp_pool->xa_num_irqs.max -
-			table->sf_comp_pool->xa_num_irqs.min + 1;
+		return min_t(int, num_online_cpus(),
+			     table->sf_comp_pool->xa_num_irqs.max -
+			     table->sf_comp_pool->xa_num_irqs.min + 1);
 	else
 		return mlx5_irq_table_get_num_comp(table);
 }
-- 
2.33.0



