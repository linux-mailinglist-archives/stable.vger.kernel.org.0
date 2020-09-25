Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF9392787C9
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 14:51:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729035AbgIYMuW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 08:50:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:54266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729050AbgIYMuV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Sep 2020 08:50:21 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A1BC21741;
        Fri, 25 Sep 2020 12:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601038220;
        bh=ytIlshj3OR06WSOjzGwur6HuZbKtReovabXBz7KS66k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pVnPKFRWz4z0FF69SkqO9cTs/Wa5RVY3Lxa+f4Ajx6qofwvb1GA+QvQPTbxu0R0oj
         QxPT+1nmm5CDpydXnmSL05IYJuqR75aYYMKXuxKToP/oswWGwbpPZZbLg7bKLYY1yC
         4hxeRMDugaWb9mJkCA6F6W300eLpC+hJUil3HgwU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jianbo Liu <jianbol@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 5.8 47/56] net/mlx5e: Fix memory leak of tunnel info when rule under multipath not ready
Date:   Fri, 25 Sep 2020 14:48:37 +0200
Message-Id: <20200925124734.891831137@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200925124727.878494124@linuxfoundation.org>
References: <20200925124727.878494124@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jianbo Liu <jianbol@mellanox.com>

[ Upstream commit 12a240a41427d37b5e70570700704e84c827452f ]

When deleting vxlan flow rule under multipath, tun_info in parse_attr is
not freed when the rule is not ready.

Fixes: ef06c9ee8933 ("net/mlx5e: Allow one failure when offloading tc encap rules under multipath")
Signed-off-by: Jianbo Liu <jianbol@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1399,11 +1399,8 @@ static void mlx5e_tc_del_fdb_flow(struct
 
 	mlx5e_put_flow_tunnel_id(flow);
 
-	if (flow_flag_test(flow, NOT_READY)) {
+	if (flow_flag_test(flow, NOT_READY))
 		remove_unready_flow(flow);
-		kvfree(attr->parse_attr);
-		return;
-	}
 
 	if (mlx5e_is_offloaded_flow(flow)) {
 		if (flow_flag_test(flow, SLOW))


