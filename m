Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D22C28B841
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:50:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390081AbgJLNul (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:50:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:55260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731883AbgJLNsR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:48:17 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0CF8220757;
        Mon, 12 Oct 2020 13:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602510443;
        bh=cPrSRxu5v0r3pPl6CCqx4d8TBHk+0J4x4MMMXTVo6gs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SYkro7IDekdN3FOXjyWE8GwcTqOwn+LR5VGiMeLOe7nco55+i52fja6PQhyD+1IbI
         +8M1M/NsxmSGd1uAsCeQNorYhJa79xJbgekQJy5+kxVxcqJhEoVKEj3Osird4tWvaR
         X+Wtxfr4mhFLMcdZzoUYDMVpWdKi3uFNzyqZN0Ko=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eran Ben Elisha <eranbe@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 084/124] net/mlx5: Fix a race when moving command interface to polling mode
Date:   Mon, 12 Oct 2020 15:31:28 +0200
Message-Id: <20201012133150.931001928@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012133146.834528783@linuxfoundation.org>
References: <20201012133146.834528783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eran Ben Elisha <eranbe@mellanox.com>

[ Upstream commit 432161ea26d6d5e5c3f7306d9407d26ed1e1953e ]

As part of driver unload, it destroys the commands EQ (via FW command).
As the commands EQ is destroyed, FW will not generate EQEs for any command
that driver sends afterwards. Driver should poll for later commands status.

Driver commands mode metadata is updated before the commands EQ is
actually destroyed. This can lead for double completion handle by the
driver (polling and interrupt), if a command is executed and completed by
FW after the mode was changed, but before the EQ was destroyed.

Fix that by using the mlx5_cmd_allowed_opcode mechanism to guarantee
that only DESTROY_EQ command can be executed during this time period.

Fixes: e126ba97dba9 ("mlx5: Add driver for Mellanox Connect-IB adapters")
Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
Reviewed-by: Moshe Shemesh <moshe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/eq.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index 31ef9f8420c87..1318d774b18f2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -656,8 +656,10 @@ static void destroy_async_eqs(struct mlx5_core_dev *dev)
 
 	cleanup_async_eq(dev, &table->pages_eq, "pages");
 	cleanup_async_eq(dev, &table->async_eq, "async");
+	mlx5_cmd_allowed_opcode(dev, MLX5_CMD_OP_DESTROY_EQ);
 	mlx5_cmd_use_polling(dev);
 	cleanup_async_eq(dev, &table->cmd_eq, "cmd");
+	mlx5_cmd_allowed_opcode(dev, CMD_ALLOWED_OPCODE_ALL);
 	mlx5_eq_notifier_unregister(dev, &table->cq_err_nb);
 }
 
-- 
2.25.1



