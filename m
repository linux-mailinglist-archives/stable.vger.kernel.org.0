Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DEFD24B476
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 12:07:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730638AbgHTKGq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 06:06:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:35810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730487AbgHTKGm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:06:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B08B1206DA;
        Thu, 20 Aug 2020 10:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597918002;
        bh=AmTZtyZUnDO5InHBHtS78KWfPouKRkGH35AeeRiiGuM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NSTtuxV+Lqx2IOUHnokU7XutmNkSQ5uwy2u4PBbIeMZEEeAyqSlJC9GRdSg7Mk8hL
         9WfNe2BqElz5phC9u2sI0/Jg3M6da1xYOtihapElnfV8Nd7ITZGnMjVtU2XXCmFP8z
         kOmsHqjc4LugJa0M4D7ijp0ve3EKxewuHOX2WRx8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 4.14 002/228] net/mlx5e: Dont support phys switch id if not in switchdev mode
Date:   Thu, 20 Aug 2020 11:19:37 +0200
Message-Id: <20200820091607.648150053@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091607.532711107@linuxfoundation.org>
References: <20200820091607.532711107@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


From: Roi Dayan <roid@mellanox.com>

Support for phys switch id ndo added for representors and if
we do not have representors there is no need to support it.
Since each port return different switch id supporting this
block support for creating bond over PFs and attaching to bridge
in legacy mode.

This bug doesn't exist upstream as the code got refactored and the
netdev api is totally different.

Fixes: cb67b832921c ("net/mlx5e: Introduce SRIOV VF representors")
Signed-off-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -180,7 +180,7 @@ int mlx5e_attr_get(struct net_device *de
 	struct mlx5_eswitch_rep *rep = rpriv->rep;
 	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
 
-	if (esw->mode == SRIOV_NONE)
+	if (esw->mode != SRIOV_OFFLOADS)
 		return -EOPNOTSUPP;
 
 	switch (attr->id) {


