Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76F9F34C859
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:25:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232883AbhC2IVi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:21:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:37810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232290AbhC2IUt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:20:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9737161601;
        Mon, 29 Mar 2021 08:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006049;
        bh=SYxeOhqfQo1AdueVitiqw7jOCAaQFi5n0p20gIk1kyo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D/6zazSYRcpe9U754nDShoMel9+HQ2SgL9OgwDNTHSBDt3T4t4kdjL7jx6UYbB3yr
         7VfllJwuJixUWVWuneXP2vNODUsZvOUdXgQR1DFfRymoWXOFRCzKkjKACv73KnHvbc
         CjxAkRsnVBal+LYBk8h6PVhuthcw6iHuprtW1rvw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Mikityanskiy <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 098/221] net/mlx5e: When changing XDP program without reset, take refs for XSK RQs
Date:   Mon, 29 Mar 2021 09:57:09 +0200
Message-Id: <20210329075632.474593670@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075629.172032742@linuxfoundation.org>
References: <20210329075629.172032742@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

[ Upstream commit e5eb01344e9b09bb9d255b9727449186f7168df8 ]

Each RQ (including XSK RQs) takes a reference to the XDP program. When
an XDP program is attached or detached, the channels and queues are
recreated, however, there is a special flow for changing an active XDP
program to another one. In that flow, channels and queues stay alive,
but the refcounts of the old and new XDP programs are adjusted. This
flow didn't increment refcount by the number of active XSK RQs, and this
commit fixes it.

Fixes: db05815b36cb ("net/mlx5e: Add XSK zero-copy support")
Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 8b0826d689c0..0dc572aaf177 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4494,8 +4494,10 @@ static int mlx5e_xdp_set(struct net_device *netdev, struct bpf_prog *prog)
 		struct mlx5e_channel *c = priv->channels.c[i];
 
 		mlx5e_rq_replace_xdp_prog(&c->rq, prog);
-		if (test_bit(MLX5E_CHANNEL_STATE_XSK, c->state))
+		if (test_bit(MLX5E_CHANNEL_STATE_XSK, c->state)) {
+			bpf_prog_inc(prog);
 			mlx5e_rq_replace_xdp_prog(&c->xskrq, prog);
+		}
 	}
 
 unlock:
-- 
2.30.1



