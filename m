Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F50A3DD908
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 15:56:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235837AbhHBN4i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 09:56:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:34014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236259AbhHBNzL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 09:55:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A3DC1611BF;
        Mon,  2 Aug 2021 13:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912424;
        bh=evxxwwJa+rRkC6KjjxVuQ/djU386AaH0ztOn5tJr+cU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dNcHU6CCZ9ROSjK1KyEMCg1g1m5ryrBV1yP3VpqCcQlsdSqcPNf2Y4E6Hxrgl2GiP
         e0U2yf0ozT/RjJMalVLhPzPV8da8tlHVArLZ4MhP8QBIbDGMoV65T+PdGL7TVLjtXY
         Rl8ETwYZDfW/dZUoyejBZyh0Z1G92EpV6ajA5eZo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maor Gottlieb <maorg@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 52/67] net/mlx5: Fix flow table chaining
Date:   Mon,  2 Aug 2021 15:45:15 +0200
Message-Id: <20210802134340.815142536@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134339.023067817@linuxfoundation.org>
References: <20210802134339.023067817@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maor Gottlieb <maorg@nvidia.com>

[ Upstream commit 8b54874ef1617185048029a3083d510569e93751 ]

Fix a bug when flow table is created in priority that already
has other flow tables as shown in the below diagram.
If the new flow table (FT-B) has the lowest level in the priority,
we need to connect the flow tables from the previous priority (p0)
to this new table. In addition when this flow table is destroyed
(FT-B), we need to connect the flow tables from the previous
priority (p0) to the next level flow table (FT-C) in the same
priority of the destroyed table (if exists).

                       ---------
                       |root_ns|
                       ---------
                            |
            --------------------------------
            |               |              |
       ----------      ----------      ---------
       |p(prio)-x|     |   p-y  |      |   p-n |
       ----------      ----------      ---------
            |               |
     ----------------  ------------------
     |ns(e.g bypass)|  |ns(e.g. kernel) |
     ----------------  ------------------
            |            |           |
	-------	       ------       ----
        |  p0 |        | p1 |       |p2|
        -------        ------       ----
           |             |    \
        --------       ------- ------
        | FT-A |       |FT-B | |FT-C|
        --------       ------- ------

Fixes: f90edfd279f3 ("net/mlx5_core: Connect flow tables")
Signed-off-by: Maor Gottlieb <maorg@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index 79fc5755735f..1d4b4e6f6fb4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -1024,17 +1024,19 @@ static int connect_fwd_rules(struct mlx5_core_dev *dev,
 static int connect_flow_table(struct mlx5_core_dev *dev, struct mlx5_flow_table *ft,
 			      struct fs_prio *prio)
 {
-	struct mlx5_flow_table *next_ft;
+	struct mlx5_flow_table *next_ft, *first_ft;
 	int err = 0;
 
 	/* Connect_prev_fts and update_root_ft_create are mutually exclusive */
 
-	if (list_empty(&prio->node.children)) {
+	first_ft = list_first_entry_or_null(&prio->node.children,
+					    struct mlx5_flow_table, node.list);
+	if (!first_ft || first_ft->level > ft->level) {
 		err = connect_prev_fts(dev, ft, prio);
 		if (err)
 			return err;
 
-		next_ft = find_next_chained_ft(prio);
+		next_ft = first_ft ? first_ft : find_next_chained_ft(prio);
 		err = connect_fwd_rules(dev, ft, next_ft);
 		if (err)
 			return err;
@@ -2113,7 +2115,7 @@ static int disconnect_flow_table(struct mlx5_flow_table *ft)
 				node.list) == ft))
 		return 0;
 
-	next_ft = find_next_chained_ft(prio);
+	next_ft = find_next_ft(ft);
 	err = connect_fwd_rules(dev, next_ft, ft);
 	if (err)
 		return err;
-- 
2.30.2



