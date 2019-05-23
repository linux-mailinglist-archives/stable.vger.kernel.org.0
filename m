Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65FF5289A4
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:43:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389978AbfEWTku (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:40:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:57742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389368AbfEWTUs (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:20:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 41792217D9;
        Thu, 23 May 2019 19:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558639247;
        bh=laHD1jWBJrY0MXhlTLyPeumxAmw0dFaifheRZAZDSW8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=juCHr7b3jo12TvwAXk19CIP/y9VXTTHrg8shRFiXgOEQLYDaTR+xRXQvAo92O04WW
         Ol1MLhDbpC5cgvqtYoJW+fo2s0xSeh7aiJqs7je7a07Sqk7qugikR4Rnvjz2/WIfjT
         v7kxUvWHKNgzm+Wzo2+EXlpPRMi6sxhKFyeG/lXo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmytro Linkin <dmitrolin@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 5.0 016/139] net/mlx5e: Additional check for flow destination comparison
Date:   Thu, 23 May 2019 21:05:04 +0200
Message-Id: <20190523181722.662968930@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181720.120897565@linuxfoundation.org>
References: <20190523181720.120897565@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmytro Linkin <dmitrolin@mellanox.com>

[ Upstream commit c979c445a88e1c9dd7d8f90838c10456ae4ecd09 ]

Flow destination comparison has an inaccuracy: code see no
difference between same vf ports, which belong to different pfs.

Example: If start ping from VF0 (PF1) to VF1 (PF1) and mirror
all traffic to VF0 (PF2), icmp reply to VF0 (PF1) and mirrored
flow to VF0 (PF2) would be determined as same destination. It lead
to creating flow handler with rule nodes, which not added to node
tree. When later driver try to delete this flow rules we got
kernel crash.

Add comparison of vhca_id field to avoid this.

Fixes: 1228e912c934 ("net/mlx5: Consider encapsulation properties when comparing destinations")
Signed-off-by: Dmytro Linkin <dmitrolin@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Vlad Buslov <vladbu@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -1375,6 +1375,8 @@ static bool mlx5_flow_dests_cmp(struct m
 		if ((d1->type == MLX5_FLOW_DESTINATION_TYPE_VPORT &&
 		     d1->vport.num == d2->vport.num &&
 		     d1->vport.flags == d2->vport.flags &&
+		     ((d1->vport.flags & MLX5_FLOW_DEST_VPORT_VHCA_ID) ?
+		      (d1->vport.vhca_id == d2->vport.vhca_id) : true) &&
 		     ((d1->vport.flags & MLX5_FLOW_DEST_VPORT_REFORMAT_ID) ?
 		      (d1->vport.reformat_id == d2->vport.reformat_id) : true)) ||
 		    (d1->type == MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE &&


