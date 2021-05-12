Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE44737CE4A
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:18:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239298AbhELREu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 13:04:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:35726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237825AbhELQnN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:43:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C290B61D4E;
        Wed, 12 May 2021 16:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620836017;
        bh=f6E9qvdhSvOB7wXmL2DAOHYP+zIJXgQ4Lfm1sI9vjcY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tx1LoJ3wjuYywKazMZNj+6XZoWlmuIXUwrb4KUanVxhBLcJGWRFUEoXKMk3ZTeoHE
         H3N/FA2Z89i6qgprZmCYUDkO4Mrqjl2GVb3+oZL2L2rBPU3/QvzRI+lTnbdeFrWIwU
         JpveSgtQzt8P4yppJalPRHu8UjVcrpsV0MqoNfTs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 577/677] net/mlx5: Fix bit-wise and with zero
Date:   Wed, 12 May 2021 16:50:23 +0200
Message-Id: <20210512144856.560160622@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
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
index 22bee4990232..bb61f52d782d 100644
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



