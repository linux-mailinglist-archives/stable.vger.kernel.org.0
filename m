Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50DBF30CBB7
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 20:36:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239587AbhBBTdN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 14:33:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:43126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232954AbhBBN5Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:57:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 64F8864FE3;
        Tue,  2 Feb 2021 13:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273544;
        bh=GhORz0aQj3aHg5n2dkluzgIHDfVfsEpJGHbD5F2doCA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eODmOX57bYXaMNT70BgxumId5xLkkLvfGmJytPgOZPX9eZ6c2J9qsF8AaxUPNskv5
         nmabEwheUsF0cgt8o3IXa3PQyOQpbgEM5h2sao+RADb5Ni76xKSHPkjRu2Ph/hv6GY
         j8CpIeAzBgADhaRcyhtKbWFpA1i0i7F/6NmjVJEQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 114/142] net/mlx5: Fix memory leak on flow table creation error flow
Date:   Tue,  2 Feb 2021 14:37:57 +0100
Message-Id: <20210202133002.412430716@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132957.692094111@linuxfoundation.org>
References: <20210202132957.692094111@linuxfoundation.org>
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
index 9fdd99272e310..634c2bfd25be1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -1141,6 +1141,7 @@ static struct mlx5_flow_table *__mlx5_create_flow_table(struct mlx5_flow_namespa
 destroy_ft:
 	root->cmds->destroy_flow_table(root, ft);
 free_ft:
+	rhltable_destroy(&ft->fgs_hash);
 	kfree(ft);
 unlock_root:
 	mutex_unlock(&root->chain_lock);
-- 
2.27.0



