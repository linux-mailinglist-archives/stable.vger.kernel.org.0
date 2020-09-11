Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08F61266140
	for <lists+stable@lfdr.de>; Fri, 11 Sep 2020 16:33:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725834AbgIKOdX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Sep 2020 10:33:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:57612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726215AbgIKNMA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Sep 2020 09:12:00 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AAD7322475;
        Fri, 11 Sep 2020 13:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599829254;
        bh=4Huu70dJ+HjD8QlR9LohnstfTGmLMG6oxi13lowcang=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2vbhglolyzEBItOTzJAT4/vUIkm3izDju9qkvsUxArYblkNzGpkKL/mXAeEIXAp5V
         aD7cMe/H7Auj05wcFyAXl2yqN4pJm3+OjEGRW8pEMLbcHkBG1bmmxbRElv76u0YMTs
         r8BVagdextxHYfNWja/Z2zIO9wlrCmwbxwYy9EHg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 4.19 8/8] net/mlx5e: Dont support phys switch id if not in switchdev mode
Date:   Fri, 11 Sep 2020 14:54:55 +0200
Message-Id: <20200911125422.103702175@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200911125421.695645838@linuxfoundation.org>
References: <20200911125421.695645838@linuxfoundation.org>
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
@@ -198,7 +198,7 @@ int mlx5e_attr_get(struct net_device *de
 	struct mlx5_eswitch_rep *rep = rpriv->rep;
 	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
 
-	if (esw->mode == SRIOV_NONE)
+	if (esw->mode != SRIOV_OFFLOADS)
 		return -EOPNOTSUPP;
 
 	switch (attr->id) {


