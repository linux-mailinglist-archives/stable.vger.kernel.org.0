Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79CBF395E61
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:56:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231913AbhEaN6B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:58:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:60392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232458AbhEaNzw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:55:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 51CC56191E;
        Mon, 31 May 2021 13:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468064;
        bh=x1pPOSprWzG+lSx5h3f4jjsqv/cvvuQH/fxPSt6chCc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MEZtSnNFOBbuhS8ZycmCRSNR3aX/DIH9PrpOJfZ5b8e8zKuuc4Y6UW0ECJSZCm+zJ
         i6SLsGge8Wv/6vrt/54H68qAzGYFPwBLlijAGFjBhba3FXyFqUk4s8S0pKCvTiQ9tS
         G11cgPgPxK53P9SKMWooSWTmpGg7ai6zmTLJgDac=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 5.10 103/252] net/mlx5e: Fix null deref accessing lag dev
Date:   Mon, 31 May 2021 15:12:48 +0200
Message-Id: <20210531130701.496636325@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130657.971257589@linuxfoundation.org>
References: <20210531130657.971257589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

commit 83026d83186bc48bb41ee4872f339b83f31dfc55 upstream.

It could be the lag dev is null so stop processing the event.
In bond_enslave() the active/backup slave being set before setting the
upper dev so first event is without an upper dev.
After setting the upper dev with bond_master_upper_dev_link() there is
a second event and in that event we have an upper dev.

Fixes: 7e51891a237f ("net/mlx5e: Use netdev events to set/del egress acl forward-to-vport rule")
Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/rep/bond.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bond.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bond.c
@@ -223,6 +223,8 @@ static void mlx5e_rep_changelowerstate_e
 	rpriv = priv->ppriv;
 	fwd_vport_num = rpriv->rep->vport;
 	lag_dev = netdev_master_upper_dev_get(netdev);
+	if (!lag_dev)
+		return;
 
 	netdev_dbg(netdev, "lag_dev(%s)'s slave vport(%d) is txable(%d)\n",
 		   lag_dev->name, fwd_vport_num, net_lag_port_dev_txable(netdev));


