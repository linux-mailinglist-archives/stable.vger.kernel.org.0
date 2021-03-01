Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17CB8328AE9
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:26:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239791AbhCASZH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:25:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:39440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239741AbhCASTJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:19:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 735C265182;
        Mon,  1 Mar 2021 17:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618509;
        bh=HtSnCdkCsCToyfk4NKK7G4lrDhBmrZye4dK5WX64hvQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eIJDE9dIvfnHNuSONFWBMRqdGqG4UyvkcVVJHxx8hWjkPLLGq0jHmYhi68xWl2JSx
         F39UIvKvb81dok9geUR3n3QXOFtiHXVu8I03NvqHSrIcXuAplMD2sBux1Q7RRl37u4
         fMM2YRhVkCAxZ70sDK4HfIJDPfT2dsb1r7gHLOtI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Moshe Shemesh <moshe@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 113/663] net/mlx5e: Check tunnel offload is required before setting SWP
Date:   Mon,  1 Mar 2021 17:06:01 +0100
Message-Id: <20210301161147.332229768@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Moshe Shemesh <moshe@nvidia.com>

[ Upstream commit e1c3940c6003d820c787473c65711b49c2d1bc42 ]

Check that tunnel offload is required before setting Software Parser
offsets to get Geneve HW offload. In case of Geneve packet we check HW
offload support of SWP in mlx5e_tunnel_features_check() and set features
accordingly, this should be reflected in skb offload requested by the
kernel and we should add the Software Parser offsets only if requested.
Otherwise, in case HW doesn't support SWP for Geneve, data path will
mistakenly try to offload Geneve SKBs with skb->encapsulation set,
regardless of whether offload was requested or not on this specific SKB.

Fixes: e3cfc7e6b7bd ("net/mlx5e: TX, Add geneve tunnel stateless offload support")
Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
index 1fae7fab8297e..ff81b69a59a9b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
@@ -173,7 +173,7 @@ static inline bool mlx5e_accel_tx_eseg(struct mlx5e_priv *priv,
 #endif
 
 #if IS_ENABLED(CONFIG_GENEVE)
-	if (skb->encapsulation)
+	if (skb->encapsulation && skb->ip_summed == CHECKSUM_PARTIAL)
 		mlx5e_tx_tunnel_accel(skb, eseg, ihs);
 #endif
 
-- 
2.27.0



