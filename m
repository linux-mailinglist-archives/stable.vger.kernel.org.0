Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEE532B634C
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:37:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732178AbgKQNhD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:37:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:47420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732590AbgKQNg2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:36:28 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A3C820780;
        Tue, 17 Nov 2020 13:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620188;
        bh=H21UDbvjmEtYzVfm+j2/I6W7vViXbI6wL+dUmYixjDs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ImQE/HOSY4LQjojQ9GYJi5X/3IIa0Mp9SHTTKc2OvbQliBe4gAy6JYo1sNJOku00V
         U+aTnXp1lZRwtPesEOBx5NKMy7iqTqc4mEeqcqwceHWSTk26pRTahjW7lM2MN36dGh
         QbSClvLZDyNuCw1VFnyp6qXvTjYiy5x6uCA4z/4o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maor Dickman <maord@nvidia.com>,
        Paul Blakey <paulb@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 136/255] net/mlx5e: Fix modify header actions memory leak
Date:   Tue, 17 Nov 2020 14:04:36 +0100
Message-Id: <20201117122145.559907072@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maor Dickman <maord@nvidia.com>

[ Upstream commit e68e28b4a9d71261e3f8fd05a72d6cf0b443a493 ]

Modify header actions are allocated during parse tc actions and only
freed during the flow creation, however, on error flow the allocated
memory is wrongly unfreed.

Fix this by calling dealloc_mod_hdr_actions in __mlx5e_add_fdb_flow
and mlx5e_add_nic_flow error flow.

Fixes: d7e75a325cb2 ("net/mlx5e: Add offloading of E-Switch TC pedit (header re-write) actions")
Fixes: 2f4fe4cab073 ("net/mlx5e: Add offloading of NIC TC pedit (header re-write) actions")
Signed-off-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Paul Blakey <paulb@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 1c93f92d9210a..44947b054dc4c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -4430,6 +4430,7 @@ __mlx5e_add_fdb_flow(struct mlx5e_priv *priv,
 	return flow;
 
 err_free:
+	dealloc_mod_hdr_actions(&parse_attr->mod_hdr_acts);
 	mlx5e_flow_put(priv, flow);
 out:
 	return ERR_PTR(err);
@@ -4564,6 +4565,7 @@ mlx5e_add_nic_flow(struct mlx5e_priv *priv,
 	return 0;
 
 err_free:
+	dealloc_mod_hdr_actions(&parse_attr->mod_hdr_acts);
 	mlx5e_flow_put(priv, flow);
 	kvfree(parse_attr);
 out:
-- 
2.27.0



