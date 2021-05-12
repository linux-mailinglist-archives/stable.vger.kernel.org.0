Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2808337C634
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:50:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236343AbhELPti (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:49:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:41538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233909AbhELPnG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:43:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 994B161C85;
        Wed, 12 May 2021 15:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832935;
        bh=dO3+MpS8nYIZjeo0TclKHpYAABOpa2lmNKT0CUcdCN0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gfAwTEcp9tXqmUa/V+JPxRPad8wdUQMGgVBAZvzbiywM64A+E1xJA6TB/MGbkEQpe
         xmc9BlLtEGJYa3bQOb27H0zlwMfViYaqJ+5Z72pmTDv9zjUvI11QlYxHqJj7mR6Z+8
         brVBLZCDQewB0q9dO2xfGNy1bF0djBTYlw6nzzfk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 447/530] net/mlx5: Fix bit-wise and with zero
Date:   Wed, 12 May 2021 16:49:17 +0200
Message-Id: <20210512144834.460832842@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 82c3ba31c370b6001cbf90689e98da1fb6f26aef ]

The bit-wise and of the action field with MLX5_ACCEL_ESP_ACTION_DECRYPT
is incorrect as MLX5_ACCEL_ESP_ACTION_DECRYPT is zero and not intended
to be a bit-flag. Fix this by using the == operator as was originally
intended.

Addresses-Coverity: ("Logically dead code")
Fixes: 7dfee4b1d79e ("net/mlx5: IPsec, Refactor SA handle creation and destruction")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c
index cc67366495b0..bed154e9a1ef 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c
@@ -850,7 +850,7 @@ mlx5_fpga_ipsec_release_sa_ctx(struct mlx5_fpga_ipsec_sa_ctx *sa_ctx)
 		return;
 	}
 
-	if (sa_ctx->fpga_xfrm->accel_xfrm.attrs.action &
+	if (sa_ctx->fpga_xfrm->accel_xfrm.attrs.action ==
 	    MLX5_ACCEL_ESP_ACTION_DECRYPT)
 		ida_simple_remove(&fipsec->halloc, sa_ctx->sa_handle);
 
-- 
2.30.2



