Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D150742903A
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:05:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239807AbhJKOGW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:06:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:56888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241074AbhJKOE2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 10:04:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E2E460EDF;
        Mon, 11 Oct 2021 13:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960746;
        bh=rV8McMrKAA6H+qqw5rdLn4og+2p/cV/8o2vY4nADJKs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fpu2DraBdC4Ex7ucWO1vW8/sD4ytUCHclPxa3IYOB5353rpuM/2WOzZ09WjNKz445
         RTS64JFHYXRaVlSSWwSmWzJTV5E1YDhHcifV45OZ7gMTRJ9k51Sj3zkCuYIy73WmiN
         VvOwJFRUouZE9LjkvHGggaVYP/38g+SlLjpN5C6I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shay Drory <shayd@nvidia.com>,
        Parav Pandit <parav@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 063/151] net/mlx5: Fix length of irq_index in chars
Date:   Mon, 11 Oct 2021 15:45:35 +0200
Message-Id: <20211011134519.875577558@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134517.833565002@linuxfoundation.org>
References: <20211011134517.833565002@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shay Drory <shayd@nvidia.com>

[ Upstream commit ac8b7d50ae4c3f5325c599f3d6e939ecef6a585a ]

The maximum irq_index can be 2047, This means irq_name should have 4
characters reserve for the irq_index. Hence, increase it to 4.

Fixes: 3af26495a247 ("net/mlx5: Enlarge interrupt field in CREATE_EQ")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
index 3465b363fc2f..49e6f5003991 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
@@ -13,8 +13,8 @@
 #endif
 
 #define MLX5_MAX_IRQ_NAME (32)
-/* max irq_index is 255. three chars */
-#define MLX5_MAX_IRQ_IDX_CHARS (3)
+/* max irq_index is 2047, so four chars */
+#define MLX5_MAX_IRQ_IDX_CHARS (4)
 
 #define MLX5_SFS_PER_CTRL_IRQ 64
 #define MLX5_IRQ_CTRL_SF_MAX 8
-- 
2.33.0



