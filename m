Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B42799A4F
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:13:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389048AbfHVRLy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:11:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:59506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730641AbfHVRJO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:09:14 -0400
Received: from sasha-vm.mshome.net (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CEF5623404;
        Thu, 22 Aug 2019 17:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566493754;
        bh=oWRieHLty+Rj5FWIVKIVjH/MKr+0xARdLxI9ID2S5yc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XTM+73UOl/MexJOUpssWSdUxxG1einAMRXSoUTgiiOwHt2NtdQHMj8U0R86SYNZE6
         OeSuxD+BlBhSQmQAtt+mkk9PRHlbHwdplJtiylKH4pUe8c3upmqNCT2gNq77OfaeTs
         G0XlXz3RcDsbyVxfMvNVKI7EggYmpObp40bHMJGM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wenwen Wang <wenwen@cs.uga.edu>,
        Tariq Toukan <tariqt@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.2 110/135] net/mlx4_en: fix a memory leak bug
Date:   Thu, 22 Aug 2019 13:07:46 -0400
Message-Id: <20190822170811.13303-111-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190822170811.13303-1-sashal@kernel.org>
References: <20190822170811.13303-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.10-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.2.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.2.10-rc1
X-KernelTest-Deadline: 2019-08-24T17:07+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wenwen Wang <wenwen@cs.uga.edu>

[ Upstream commit 48ec7014c56e5eb2fbf6f479896143622d834f3b ]

In mlx4_en_config_rss_steer(), 'rss_map->indir_qp' is allocated through
kzalloc(). After that, mlx4_qp_alloc() is invoked to configure RSS
indirection. However, if mlx4_qp_alloc() fails, the allocated
'rss_map->indir_qp' is not deallocated, leading to a memory leak bug.

To fix the above issue, add the 'qp_alloc_err' label to free
'rss_map->indir_qp'.

Fixes: 4931c6ef04b4 ("net/mlx4_en: Optimized single ring steering")
Signed-off-by: Wenwen Wang <wenwen@cs.uga.edu>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx4/en_rx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_rx.c b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
index 6c01314e87b09..db3552f2d0877 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
@@ -1187,7 +1187,7 @@ int mlx4_en_config_rss_steer(struct mlx4_en_priv *priv)
 	err = mlx4_qp_alloc(mdev->dev, priv->base_qpn, rss_map->indir_qp);
 	if (err) {
 		en_err(priv, "Failed to allocate RSS indirection QP\n");
-		goto rss_err;
+		goto qp_alloc_err;
 	}
 
 	rss_map->indir_qp->event = mlx4_en_sqp_event;
@@ -1241,6 +1241,7 @@ int mlx4_en_config_rss_steer(struct mlx4_en_priv *priv)
 		       MLX4_QP_STATE_RST, NULL, 0, 0, rss_map->indir_qp);
 	mlx4_qp_remove(mdev->dev, rss_map->indir_qp);
 	mlx4_qp_free(mdev->dev, rss_map->indir_qp);
+qp_alloc_err:
 	kfree(rss_map->indir_qp);
 	rss_map->indir_qp = NULL;
 rss_err:
-- 
2.20.1

