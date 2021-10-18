Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44AD6431E6C
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:58:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232834AbhJROA4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 10:00:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:39032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233555AbhJRN7B (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:59:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F6AD61440;
        Mon, 18 Oct 2021 13:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564497;
        bh=u9El7f3gdKdEjCXKeoYIWKP8przCpQMoxZYG1deZ2Xg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GfGn8KGxyDMX7As5fgZznzg7abxv7A10H+x9OzVuuIEOZGNtXjWeocyOVUF8He8kS
         M0iLTeDOtHo98bIeH8PgK3CEMz99jYPOUw4uvInxHZvNbc368NdlMyfqdjRVM9TwFA
         PAyZQkN1/jDXD9VKLpzb4eirVT7TJyAgYyP39qsc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Valentine Fatiev <valentinef@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 5.14 104/151] net/mlx5e: Fix memory leak in mlx5_core_destroy_cq() error path
Date:   Mon, 18 Oct 2021 15:24:43 +0200
Message-Id: <20211018132344.054757337@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132340.682786018@linuxfoundation.org>
References: <20211018132340.682786018@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Valentine Fatiev <valentinef@nvidia.com>

commit 94b960b9deffc02fc0747afc01f72cc62ab099e3 upstream.

Prior to this patch in case mlx5_core_destroy_cq() failed it returns
without completing all destroy operations and that leads to memory leak.
Instead, complete the destroy flow before return error.

Also move mlx5_debug_cq_remove() to the beginning of mlx5_core_destroy_cq()
to be symmetrical with mlx5_core_create_cq().

kmemleak complains on:

unreferenced object 0xc000000038625100 (size 64):
  comm "ethtool", pid 28301, jiffies 4298062946 (age 785.380s)
  hex dump (first 32 bytes):
    60 01 48 94 00 00 00 c0 b8 05 34 c3 00 00 00 c0  `.H.......4.....
    02 00 00 00 00 00 00 00 00 db 7d c1 00 00 00 c0  ..........}.....
  backtrace:
    [<000000009e8643cb>] add_res_tree+0xd0/0x270 [mlx5_core]
    [<00000000e7cb8e6c>] mlx5_debug_cq_add+0x5c/0xc0 [mlx5_core]
    [<000000002a12918f>] mlx5_core_create_cq+0x1d0/0x2d0 [mlx5_core]
    [<00000000cef0a696>] mlx5e_create_cq+0x210/0x3f0 [mlx5_core]
    [<000000009c642c26>] mlx5e_open_cq+0xb4/0x130 [mlx5_core]
    [<0000000058dfa578>] mlx5e_ptp_open+0x7f4/0xe10 [mlx5_core]
    [<0000000081839561>] mlx5e_open_channels+0x9cc/0x13e0 [mlx5_core]
    [<0000000009cf05d4>] mlx5e_switch_priv_channels+0xa4/0x230
[mlx5_core]
    [<0000000042bbedd8>] mlx5e_safe_switch_params+0x14c/0x300
[mlx5_core]
    [<0000000004bc9db8>] set_pflag_tx_port_ts+0x9c/0x160 [mlx5_core]
    [<00000000a0553443>] mlx5e_set_priv_flags+0xd0/0x1b0 [mlx5_core]
    [<00000000a8f3d84b>] ethnl_set_privflags+0x234/0x2d0
    [<00000000fd27f27c>] genl_family_rcv_msg_doit+0x108/0x1d0
    [<00000000f495e2bb>] genl_family_rcv_msg+0xe4/0x1f0
    [<00000000646c5c2c>] genl_rcv_msg+0x78/0x120
    [<00000000d53e384e>] netlink_rcv_skb+0x74/0x1a0

Fixes: e126ba97dba9 ("mlx5: Add driver for Mellanox Connect-IB adapters")
Signed-off-by: Valentine Fatiev <valentinef@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/cq.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/cq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cq.c
@@ -154,6 +154,8 @@ int mlx5_core_destroy_cq(struct mlx5_cor
 	u32 in[MLX5_ST_SZ_DW(destroy_cq_in)] = {};
 	int err;
 
+	mlx5_debug_cq_remove(dev, cq);
+
 	mlx5_eq_del_cq(mlx5_get_async_eq(dev), cq);
 	mlx5_eq_del_cq(&cq->eq->core, cq);
 
@@ -161,16 +163,13 @@ int mlx5_core_destroy_cq(struct mlx5_cor
 	MLX5_SET(destroy_cq_in, in, cqn, cq->cqn);
 	MLX5_SET(destroy_cq_in, in, uid, cq->uid);
 	err = mlx5_cmd_exec_in(dev, destroy_cq, in);
-	if (err)
-		return err;
 
 	synchronize_irq(cq->irqn);
 
-	mlx5_debug_cq_remove(dev, cq);
 	mlx5_cq_put(cq);
 	wait_for_completion(&cq->free);
 
-	return 0;
+	return err;
 }
 EXPORT_SYMBOL(mlx5_core_destroy_cq);
 


