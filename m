Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B1763AEFE0
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:41:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232679AbhFUQnN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:43:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:33868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232689AbhFUQlN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:41:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BBAC66143F;
        Mon, 21 Jun 2021 16:30:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624293035;
        bh=gWLfIzXJZK4LxcX4VlDVRxc7ggcOR+XhL+IFOjhYs8I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rVt068AxKA85fLeCM34KGfwzrbhsM+hrR6fH0111kLEhoTQc0hcbK15eK7rWei1HW
         tr6GRYFjtX9wHsm/tmAxRH2qSqzrNUNUNhY9JQyKgHOb9iS75CnBILGSAk6UVNfZRe
         m+IL9zzRcXHb4d8WuuSyrC8Zwdx9sks+tcX06pIg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Parav Pandit <parav@nvidia.com>,
        Vu Pham <vuhuong@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 075/178] net/mlx5: SF_DEV, remove SF device on invalid state
Date:   Mon, 21 Jun 2021 18:14:49 +0200
Message-Id: <20210621154925.128806325@linuxfoundation.org>
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

From: Parav Pandit <parav@nvidia.com>

[ Upstream commit c7d6c19b3bde66d7aebbe93e0f9e6d9ff57fc3fa ]

When auxiliary bus autoprobe is disabled and SF is in ACTIVE state,
on SF port deletion it transitions from ACTIVE->ALLOCATED->INVALID.

When VHCA event handler queries the state, it is already transition
to INVALID state.

In this scenario, event handler missed to delete the SF device.

Fix it by deleting the SF when SF state is INVALID.

Fixes: 90d010b8634b ("net/mlx5: SF, Add auxiliary device support")
Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Vu Pham <vuhuong@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c
index 90b524c59f3c..c4139f4648bf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c
@@ -153,6 +153,7 @@ mlx5_sf_dev_state_change_handler(struct notifier_block *nb, unsigned long event_
 	sf_index = event->function_id - MLX5_CAP_GEN(table->dev, sf_base_id);
 	sf_dev = xa_load(&table->devices, sf_index);
 	switch (event->new_vhca_state) {
+	case MLX5_VHCA_STATE_INVALID:
 	case MLX5_VHCA_STATE_ALLOCATED:
 		if (sf_dev)
 			mlx5_sf_dev_del(table->dev, sf_dev, sf_index);
-- 
2.30.2



