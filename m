Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEC8024BA78
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 14:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726868AbgHTMJk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 08:09:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:42418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730396AbgHTJ6U (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:58:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C68BE2067C;
        Thu, 20 Aug 2020 09:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597917500;
        bh=JsURKU+at4PyZKU9WGEk0JLiJmJsdg1SxQO1vPdg47s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RYEG1Yc9nQBcqPc0lVHfbIN5gv3llaqCC6w74AJmlmapeOGg4Z5ZsqTCcs4+TSIXX
         CmfNN88tgXSZ4auqfOCnRMG5VZmhoUFcN5SpUGtIPx4xYXHDxlPZ0xTW+iYT/pqr1E
         dAhxLRM9gSB+RjfUAPIHaQ04XzQZER2R/Gygvzzc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 4.9 052/212] net/mlx5e: Dont support phys switch id if not in switchdev mode
Date:   Thu, 20 Aug 2020 11:20:25 +0200
Message-Id: <20200820091604.996996071@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091602.251285210@linuxfoundation.org>
References: <20200820091602.251285210@linuxfoundation.org>
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
@@ -139,7 +139,7 @@ int mlx5e_attr_get(struct net_device *de
 	struct mlx5_eswitch_rep *rep = priv->ppriv;
 	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
 
-	if (esw->mode == SRIOV_NONE)
+	if (esw->mode != SRIOV_OFFLOADS)
 		return -EOPNOTSUPP;
 
 	switch (attr->id) {


