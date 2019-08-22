Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4BB799A1D
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:11:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726422AbfHVRK3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:10:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:59656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390762AbfHVRJZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:09:25 -0400
Received: from sasha-vm.mshome.net (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 31683233FE;
        Thu, 22 Aug 2019 17:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566493764;
        bh=hCKc/49FPlbfa3AGQa8eMrdEN7HZiVv40ny/YIV8kbw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fp8H602oPnv5kvP46qE452RyUlDYM/zV2okMSzbIGnj6cG/GJiiMLzGn9bY4aRdq4
         qjQqsGMgVGu7RQa+TLX5zfpQFQ//a/g3NltpJ0DKabT3+gv+8rpInDVbtXpZfrpWxg
         ehVhaiKmM/xDL0FxH3KwQDfu6sixjzKzslIusPXA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Aya Levin <ayal@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.2 130/135] net/mlx5e: Remove redundant check in CQE recovery flow of tx reporter
Date:   Thu, 22 Aug 2019 13:08:06 -0400
Message-Id: <20190822170811.13303-131-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190822170811.13303-1-sashal@kernel.org>
References: <20190822170811.13303-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.10-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.2.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.2.10-rc1
X-KernelTest-Deadline: 2019-08-24T17:07+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

[ Upstream commit a4e508cab623951dc4754f346e5673714f3bbade ]

Remove check of recovery bit, in the beginning of the CQE recovery
function. This test is already performed right before the reporter
is invoked, when CQE error is detected.

Fixes: de8650a82071 ("net/mlx5e: Add tx reporter support")
Signed-off-by: Aya Levin <ayal@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
index b307234b4e05b..c1caf14bc3346 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
@@ -76,9 +76,6 @@ static int mlx5e_tx_reporter_err_cqe_recover(struct mlx5e_txqsq *sq)
 	u8 state;
 	int err;
 
-	if (!test_bit(MLX5E_SQ_STATE_RECOVERING, &sq->state))
-		return 0;
-
 	err = mlx5_core_query_sq_state(mdev, sq->sqn, &state);
 	if (err) {
 		netdev_err(dev, "Failed to query SQ 0x%x state. err = %d\n",
-- 
2.20.1

