Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D19573AEF82
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:38:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231563AbhFUQkF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:40:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:55954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232705AbhFUQhV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:37:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 437A061429;
        Mon, 21 Jun 2021 16:28:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292928;
        bh=Ons27rPoPa908i44qsL8CU4TqTNsD/vNBTpfoJqWdlc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QvL1zkq+nqueRYPg8yI2Qxe8H3Hmin3yW5sBDhfeEZwPYpQ/FUvsVQ5D3rzTj9nSw
         fi2J9/TvJpgeDj9MoO+cBQmPqwHUnKvmYQZbJN0scSdT8SLudzf9/fY1Z0Vlv42J47
         57ePIs1CFDtfulQSLCznhaRv8fe7x57kd46Pi2F4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shay Drory <shayd@nvidia.com>,
        Parav Pandit <parav@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 037/178] Revert "net/mlx5: Arm only EQs with EQEs"
Date:   Mon, 21 Jun 2021 18:14:11 +0200
Message-Id: <20210621154923.331869102@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154921.212599475@linuxfoundation.org>
References: <20210621154921.212599475@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shay Drory <shayd@nvidia.com>

[ Upstream commit 7a545077cb6701957e84c7f158630bb5c984e648 ]

In the scenario described below, an EQ can remain in FIRED state which
can result in missing an interrupt generation.

The scenario:

device                       mlx5_core driver
------                       ----------------
EQ1.eqe generated
EQ1.MSI-X sent
EQ1.state = FIRED
EQ2.eqe generated
                             mlx5_irq()
                               polls - eq1_eqes()
                               arm eq1
                               polls - eq2_eqes()
                               arm eq2
EQ2.MSI-X sent
EQ2.state = FIRED
                              mlx5_irq()
                              polls - eq2_eqes() -- no eqes found
                              driver skips EQ arming;

->EQ2 remains fired, misses generating interrupt.

Hence, always arm the EQ by reverting the cited commit in fixes tag.

Fixes: d894892dda25 ("net/mlx5: Arm only EQs with EQEs")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/eq.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index 1fa9c18563da..31c6a3b91f4a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -136,7 +136,7 @@ static int mlx5_eq_comp_int(struct notifier_block *nb,
 
 	eqe = next_eqe_sw(eq);
 	if (!eqe)
-		return 0;
+		goto out;
 
 	do {
 		struct mlx5_core_cq *cq;
@@ -161,6 +161,8 @@ static int mlx5_eq_comp_int(struct notifier_block *nb,
 		++eq->cons_index;
 
 	} while ((++num_eqes < MLX5_EQ_POLLING_BUDGET) && (eqe = next_eqe_sw(eq)));
+
+out:
 	eq_update_ci(eq, 1);
 
 	if (cqn != -1)
@@ -248,9 +250,9 @@ static int mlx5_eq_async_int(struct notifier_block *nb,
 		++eq->cons_index;
 
 	} while ((++num_eqes < MLX5_EQ_POLLING_BUDGET) && (eqe = next_eqe_sw(eq)));
-	eq_update_ci(eq, 1);
 
 out:
+	eq_update_ci(eq, 1);
 	mlx5_eq_async_int_unlock(eq_async, recovery, &flags);
 
 	return unlikely(recovery) ? num_eqes : 0;
-- 
2.30.2



