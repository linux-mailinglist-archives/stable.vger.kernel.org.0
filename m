Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AFDF3DD7D0
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 15:48:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234464AbhHBNsQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 09:48:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:57866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233981AbhHBNru (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 09:47:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8DD0C60EBB;
        Mon,  2 Aug 2021 13:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912061;
        bh=8rQU6Md/G+S09rLoycAvv8ctRbjJG4KppAwij9NlqZA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PhKkN+doLXO/riycJjzfFM11/0CWBPQU4tDohW7I4soqUFUa974p0mW/ei3eDFDnP
         jkoQgyH1hxPfl+cww/XLcfkJHU/HA4w4+K0pLYmfSl5YxOFu0NhmxjY0JHzVq9X6U9
         wdZzPPv3pU7od+L7yEC0aoueDQBmNxI6oRZIWD+0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maor Gottlieb <maorg@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 30/32] net/mlx5: Fix flow table chaining
Date:   Mon,  2 Aug 2021 15:44:50 +0200
Message-Id: <20210802134333.878761456@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134332.931915241@linuxfoundation.org>
References: <20210802134332.931915241@linuxfoundation.org>
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
index 13dfc197bdd8..6c092dc41c82 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -701,17 +701,19 @@ static int connect_fwd_rules(struct mlx5_core_dev *dev,
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
@@ -1357,7 +1359,7 @@ static int disconnect_flow_table(struct mlx5_flow_table *ft)
 				node.list) == ft))
 		return 0;
 
-	next_ft = find_next_chained_ft(prio);
+	next_ft = find_next_ft(ft);
 	err = connect_fwd_rules(dev, next_ft, ft);
 	if (err)
 		return err;
-- 
2.30.2



