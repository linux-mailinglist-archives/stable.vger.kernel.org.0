Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 094AE2B648E
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:48:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732171AbgKQNhC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:37:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:47736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732634AbgKQNgm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:36:42 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 59DE920780;
        Tue, 17 Nov 2020 13:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620201;
        bh=r0Is9J5fXUHHtL1HAs2Y/S4Sh8gvigjEuYeP4gwcvao=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Glsm0ZoWAOabNQgzCWPh/YxbFqw/erZqEX8bxjUCiHWOWi6ykA3X6Yx9lbx4Y/ArJ
         pPiLPyholcyL1EqTH5YgwrxyLXO4cQzwGnLpSoi9/U/AD0IIQRc8fGTnq7y4MxRLPs
         EJ9fBsOjGu6tSzUzCHzivOqnlWP9DpCTHjJk90ns=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Parav Pandit <parav@nvidia.com>,
        Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 140/255] net/mlx5: E-switch, Avoid extack error log for disabled vport
Date:   Tue, 17 Nov 2020 14:04:40 +0100
Message-Id: <20201117122145.760139481@linuxfoundation.org>
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

From: Parav Pandit <parav@nvidia.com>

[ Upstream commit ae35859445607f7f18dd4f332749219cd636ed59 ]

When E-switch vport is disabled, querying its hardware address is
unsupported.
Avoid setting extack error log message in such case.

Fixes: f099fde16db3 ("net/mlx5: E-switch, Support querying port function mac address")
Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 6e6a9a5639928..e8e6294c7ccae 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1902,8 +1902,6 @@ int mlx5_devlink_port_function_hw_addr_get(struct devlink *devlink,
 		ether_addr_copy(hw_addr, vport->info.mac);
 		*hw_addr_len = ETH_ALEN;
 		err = 0;
-	} else {
-		NL_SET_ERR_MSG_MOD(extack, "Eswitch vport is disabled");
 	}
 	mutex_unlock(&esw->state_lock);
 	return err;
-- 
2.27.0



