Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83AE62F7A28
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:47:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387616AbhAOMpv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:45:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:45282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388097AbhAOMh6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:37:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 288A2236FB;
        Fri, 15 Jan 2021 12:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610714237;
        bh=BHiPwUk0kgkxoKiyEtkXtu9Q2RNxqneyASUDnlnHUu4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EehqI4ivdhuK+tRL9eowNb/55yzVH8NkwMuZjxjBNt6dclLWQ5G2g52hXhLRnc7qs
         /8aLqZQQBH3bKJkLkwaJXiDMC5zb/auuSZechphG+431jV5oRxFsy/RmDCAQeRriJ+
         3tr9mjDK4WjAUFRsDkqUdubORGaEIZpI3OhVePIM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maor Dickman <maord@nvidia.com>,
        Raed Salem <raeds@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 5.10 046/103] net/mlx5e: In skb build skip setting mark in switchdev mode
Date:   Fri, 15 Jan 2021 13:27:39 +0100
Message-Id: <20210115122008.284628924@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115122006.047132306@linuxfoundation.org>
References: <20210115122006.047132306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maor Dickman <maord@nvidia.com>

[ Upstream commit e13ed0ac064dd6ee964155ba9fdc2f3c3785934c ]

sop_drop_qpn field in the cqe is used by two features, in SWITCHDEV mode
to restore the chain id in case of a miss and in LEGACY mode to support
skbedit mark action. In build RX skb, the skb mark field is set regardless
of the configured mode which cause a corruption of the mark field in case
of switchdev mode.

Fix by overriding the mark value back to 0 in the representor tc update
skb flow.

Fixes: 8f1e0b97cc70 ("net/mlx5: E-Switch, Mark miss packets with new chain id mapping")
Signed-off-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Raed Salem <raeds@nvidia.com>
Reviewed-by: Oz Shlomo <ozsh@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
@@ -626,6 +626,11 @@ bool mlx5e_rep_tc_update_skb(struct mlx5
 	if (!reg_c0)
 		return true;
 
+	/* If reg_c0 is not equal to the default flow tag then skb->mark
+	 * is not supported and must be reset back to 0.
+	 */
+	skb->mark = 0;
+
 	priv = netdev_priv(skb->dev);
 	esw = priv->mdev->priv.eswitch;
 


