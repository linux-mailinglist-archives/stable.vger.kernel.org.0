Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92AED313745
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:24:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233817AbhBHPWt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:22:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:58716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230303AbhBHPP7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:15:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 85D3464ED1;
        Mon,  8 Feb 2021 15:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612797074;
        bh=vJw3/se5p5IgzQrAXmzA1rjxPEZXb6shSptwNaI/XTw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YzBEG7h1+E+q4P/zvUohbI7BSbysqBI+m1uh0g49k1EpGeXe15pCQeX+U2imPoUK2
         7mq0nWwPmiHAPr3G7UV8j+fmsZR6zAJBhPF7iVdnDnIiCyx/p+F+JHpSzTAuz5JlEu
         6neRtrxgQaKWJpKIi5B9aPMXs2Ryh6Ve12ZGl9f0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maor Gottlieb <maorg@nvidia.com>,
        Alaa Hleihel <alaa@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 16/65] net/mlx5: Fix leak upon failure of rule creation
Date:   Mon,  8 Feb 2021 16:00:48 +0100
Message-Id: <20210208145810.873577004@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145810.230485165@linuxfoundation.org>
References: <20210208145810.230485165@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maor Gottlieb <maorg@nvidia.com>

[ Upstream commit a5bfe6b4675e0eefbd9418055b5cc6e89af27eb4 ]

When creation of a new rule that requires allocation of an FTE fails,
need to call to tree_put_node on the FTE in order to release its'
resource.

Fixes: cefc23554fc2 ("net/mlx5: Fix FTE cleanup")
Signed-off-by: Maor Gottlieb <maorg@nvidia.com>
Reviewed-by: Alaa Hleihel <alaa@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index 4944c40436f08..11e12761b0a6e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -1697,6 +1697,7 @@ search_again_locked:
 		if (!fte_tmp)
 			continue;
 		rule = add_rule_fg(g, spec, flow_act, dest, dest_num, fte_tmp);
+		/* No error check needed here, because insert_fte() is not called */
 		up_write_ref_node(&fte_tmp->node, false);
 		tree_put_node(&fte_tmp->node, false);
 		kmem_cache_free(steering->ftes_cache, fte);
@@ -1745,6 +1746,8 @@ skip_search:
 		up_write_ref_node(&g->node, false);
 		rule = add_rule_fg(g, spec, flow_act, dest, dest_num, fte);
 		up_write_ref_node(&fte->node, false);
+		if (IS_ERR(rule))
+			tree_put_node(&fte->node, false);
 		return rule;
 	}
 	rule = ERR_PTR(-ENOENT);
@@ -1844,6 +1847,8 @@ search_again_locked:
 	up_write_ref_node(&g->node, false);
 	rule = add_rule_fg(g, spec, flow_act, dest, dest_num, fte);
 	up_write_ref_node(&fte->node, false);
+	if (IS_ERR(rule))
+		tree_put_node(&fte->node, false);
 	tree_put_node(&g->node, false);
 	return rule;
 
-- 
2.27.0



