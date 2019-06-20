Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEB364D78E
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 20:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729387AbfFTSOE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 14:14:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:42244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729379AbfFTSOE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 14:14:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D5FA02082C;
        Thu, 20 Jun 2019 18:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561054443;
        bh=51G2RfOZqniUpFsAvtY2p//KMg0DjegK6uTOlGuPi8w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pzLLHj0Ap226XiGenkQuX+SbyDxivpJREiAUTUiWtK8jaD9nyvvY011i+jyIC7wt3
         jmXMQf/BOXmxsbr1F3Q+QJKVHyI4CsyMKrI79YRJb72d7u2GrVPQYF6+keqA6jg32C
         8/6dDE7phHLL2pPWTUxnIJCDF571QaSwGzwhlu4I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alaa Hleihel <alaa@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 5.1 31/98] net/mlx5e: Avoid detaching non-existing netdev under switchdev mode
Date:   Thu, 20 Jun 2019 19:56:58 +0200
Message-Id: <20190620174350.526714136@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190620174349.443386789@linuxfoundation.org>
References: <20190620174349.443386789@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alaa Hleihel <alaa@mellanox.com>

After introducing dedicated uplink representor, the netdev instance
set over the esw manager vport (PF) became no longer in use, so it was
removed in the cited commit once we're on switchdev mode.
However, the mlx5e_detach function was not updated accordingly, and it
still tries to detach a non-existing netdev, causing a kernel crash.

This patch fixes this issue.

Fixes: aec002f6f82c ("net/mlx5e: Uninstantiate esw manager vport netdev on switchdev mode")
Signed-off-by: Alaa Hleihel <alaa@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -5165,6 +5165,11 @@ static void mlx5e_detach(struct mlx5_cor
 	struct mlx5e_priv *priv = vpriv;
 	struct net_device *netdev = priv->netdev;
 
+#ifdef CONFIG_MLX5_ESWITCH
+	if (MLX5_ESWITCH_MANAGER(mdev) && vpriv == mdev)
+		return;
+#endif
+
 	if (!netif_device_present(netdev))
 		return;
 


