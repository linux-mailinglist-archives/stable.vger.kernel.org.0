Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4441A468B18
	for <lists+stable@lfdr.de>; Sun,  5 Dec 2021 14:35:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234162AbhLENjB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Dec 2021 08:39:01 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:54322 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbhLENjA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Dec 2021 08:39:00 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 80BEC60FED
        for <stable@vger.kernel.org>; Sun,  5 Dec 2021 13:35:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42809C341C5;
        Sun,  5 Dec 2021 13:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638711332;
        bh=dHvjaIIS1fEdRjBvvxbCl7NduKJEZY7pQpbybkAkICw=;
        h=Subject:To:Cc:From:Date:From;
        b=j9AkOMAmm/6iPcpfwnrvcDvbBmXqigzGVJI9Sjr+CWlGhh+bAsbxS20BDPBTBRl4D
         NlXKZ6hsONRzj5tG3jmpEbXfYVfxuahmQ0szP+H8nLvQxYPTlkkdvO29efnHBvYo8t
         jio0m/+yBC0kgLm/+O682mgoh1jBPxemubyudltg=
Subject: FAILED: patch "[PATCH] net/mlx5: E-Switch, Use indirect table only if all" failed to apply to 5.15-stable tree
To:     maord@nvidia.com, roid@nvidia.com, saeedm@nvidia.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 05 Dec 2021 14:35:26 +0100
Message-ID: <163871132611176@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From e219440da0c3a63b3cec23d08473436ae7d95fa6 Mon Sep 17 00:00:00 2001
From: Maor Dickman <maord@nvidia.com>
Date: Tue, 23 Nov 2021 14:37:11 +0200
Subject: [PATCH] net/mlx5: E-Switch, Use indirect table only if all
 destinations support it

When adding rule with multiple destinations, indirect table is used for all of
the destinations if at least one of the destinations support it, this can cause
creation of invalid indirect tables for the destinations that doesn't support it.

Fixed it by using indirect table only if all destinations support it.

Fixes: a508728a4c8b ("net/mlx5e: VF tunnel RX traffic offloading")
Signed-off-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 275af1d2b4d3..32bc08a39925 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -329,14 +329,25 @@ static bool
 esw_is_indir_table(struct mlx5_eswitch *esw, struct mlx5_flow_attr *attr)
 {
 	struct mlx5_esw_flow_attr *esw_attr = attr->esw_attr;
+	bool result = false;
 	int i;
 
-	for (i = esw_attr->split_count; i < esw_attr->out_count; i++)
+	/* Indirect table is supported only for flows with in_port uplink
+	 * and the destination is vport on the same eswitch as the uplink,
+	 * return false in case at least one of destinations doesn't meet
+	 * this criteria.
+	 */
+	for (i = esw_attr->split_count; i < esw_attr->out_count; i++) {
 		if (esw_attr->dests[i].rep &&
 		    mlx5_esw_indir_table_needed(esw, attr, esw_attr->dests[i].rep->vport,
-						esw_attr->dests[i].mdev))
-			return true;
-	return false;
+						esw_attr->dests[i].mdev)) {
+			result = true;
+		} else {
+			result = false;
+			break;
+		}
+	}
+	return result;
 }
 
 static int

