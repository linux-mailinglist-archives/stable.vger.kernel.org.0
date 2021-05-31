Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB906396295
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:56:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233868AbhEaO6H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:58:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:48434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232823AbhEaOzy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:55:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 134D06193D;
        Mon, 31 May 2021 14:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469604;
        bh=8XjnCDL8kMj+nqjnPthI6CSCqVl2sDsWa7iM43VD2Xs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wsvxVjAHW7Q+uz0d2KOn18ax5wag3n4o0au6c1/ArEdtw4xu47tFIMuaJ3plCZvfz
         d8OIGdLFah60ralrOKJUKjmPAiVWanBNRlMR27ndhn4uApTnPoOf3aMBNWlUbXMGxF
         p9PB9aeadjedAeVpJR7CLmYpRVjMPRDVkFuUzPRg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dennis Afanasev <dennis.afanasev@stateless.net>,
        Roi Dayan <roid@nvidia.com>, Maor Dickman <maord@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 262/296] net/mlx5e: Make sure fib dev exists in fib event
Date:   Mon, 31 May 2021 15:15:17 +0200
Message-Id: <20210531130712.560785449@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

[ Upstream commit eb96cc15926f4ddde3a28c42feeffdf002451c24 ]

For unreachable route entry the fib dev does not exists.

Fixes: 8914add2c9e5 ("net/mlx5e: Handle FIB events to update tunnel endpoint device")
Reported-by: Dennis Afanasev <dennis.afanasev@stateless.net>
Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
index 9f16ad2c0710..1560fcbf4ac7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
@@ -1504,7 +1504,7 @@ mlx5e_init_fib_work_ipv4(struct mlx5e_priv *priv,
 
 	fen_info = container_of(info, struct fib_entry_notifier_info, info);
 	fib_dev = fib_info_nh(fen_info->fi, 0)->fib_nh_dev;
-	if (fib_dev->netdev_ops != &mlx5e_netdev_ops ||
+	if (!fib_dev || fib_dev->netdev_ops != &mlx5e_netdev_ops ||
 	    fen_info->dst_len != 32)
 		return NULL;
 
-- 
2.30.2



