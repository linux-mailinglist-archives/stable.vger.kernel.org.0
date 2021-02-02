Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7F4E30C301
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 16:08:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230165AbhBBPHW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 10:07:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:51360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231592AbhBBOQD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 09:16:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 260B265057;
        Tue,  2 Feb 2021 13:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612274039;
        bh=JYrKGDC3c9rThQxDNpNSC2kgIMiEx40Yw0/FD3gQdjE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0k2C6DOtFbjLV7nFOeJhLE+27F5ea/XoTQFWcYtnhaEHPpciWFrQGOO6NVUSjf92D
         3gvLSyQUWJ0TlLIKP/1qF+yvi4qpOHe/U56Irol62196zDxtBI6ql1Vm0vekMpLGI3
         gVlyBdnIvs4AcFMoSAgGYL7R25VCKNz2qsFw/9Bo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 29/37] net/mlx5: Fix memory leak on flow table creation error flow
Date:   Tue,  2 Feb 2021 14:39:12 +0100
Message-Id: <20210202132944.139994159@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132942.915040339@linuxfoundation.org>
References: <20210202132942.915040339@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

[ Upstream commit 487c6ef81eb98d0a43cb08be91b1fcc9b4250626 ]

When we create the ft object we also init rhltable in ft->fgs_hash.
So in error flow before kfree of ft we need to destroy that rhltable.

Fixes: 693c6883bbc4 ("net/mlx5: Add hash table for flow groups in flow table")
Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index b16e0f45d28c5..a38a0c86705ab 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -1004,6 +1004,7 @@ static struct mlx5_flow_table *__mlx5_create_flow_table(struct mlx5_flow_namespa
 destroy_ft:
 	root->cmds->destroy_flow_table(root->dev, ft);
 free_ft:
+	rhltable_destroy(&ft->fgs_hash);
 	kfree(ft);
 unlock_root:
 	mutex_unlock(&root->chain_lock);
-- 
2.27.0



