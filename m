Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1317859D53A
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:09:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243935AbiHWImu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:42:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348940AbiHWImG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:42:06 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8651279A56;
        Tue, 23 Aug 2022 01:20:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 80480CE1B3B;
        Tue, 23 Aug 2022 08:19:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CE45C433C1;
        Tue, 23 Aug 2022 08:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242743;
        bh=7wVN8IvfazuS84SzkZjlK5R+FeYjsoVJzWDg/BbbF1M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i/OEkvk8NObS7kCq0txdgr5pq/cCmFYFCStWggwRmQqCVY+poK6qFGmMLWCdlADHj
         jrhxxlE6vIpJolyNE8TUTTC2AETbH4xCQou2yZfHQTBGKITIGF3UT/F6leY3xy3H+E
         DS8BRXYT1SEySzRl+WnXJH+u5VA2at0Z8x6eRRbg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>
Subject: [PATCH 5.19 186/365] RDMA/mlx5: Use the proper number of ports
Date:   Tue, 23 Aug 2022 10:01:27 +0200
Message-Id: <20220823080126.002460213@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Bloch <mbloch@nvidia.com>

commit 4b83c3caf289b80acecc539c79f10a6937cc42dd upstream.

The cited commit allowed the driver to operate over HCAs that have
4 physical ports. Use the number of ports of the RDMA device in the for
loop instead of using the struct size.

Fixes: 4cd14d44b11d ("net/mlx5: Support devices with more than 2 ports")
Link: https://lore.kernel.org/r/a54a56c2ede16044a29d119209b35189c662ac72.1659944855.git.leonro@nvidia.com
Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/mlx5/main.c | 34 +++++++++++++++----------------
 1 file changed, 16 insertions(+), 18 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index a174a0eee8dc..fc94a1b25485 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -2738,26 +2738,24 @@ static int set_has_smi_cap(struct mlx5_ib_dev *dev)
 	int err;
 	int port;
 
-	for (port = 1; port <= ARRAY_SIZE(dev->port_caps); port++) {
-		dev->port_caps[port - 1].has_smi = false;
-		if (MLX5_CAP_GEN(dev->mdev, port_type) ==
-		    MLX5_CAP_PORT_TYPE_IB) {
-			if (MLX5_CAP_GEN(dev->mdev, ib_virt)) {
-				err = mlx5_query_hca_vport_context(dev->mdev, 0,
-								   port, 0,
-								   &vport_ctx);
-				if (err) {
-					mlx5_ib_err(dev, "query_hca_vport_context for port=%d failed %d\n",
-						    port, err);
-					return err;
-				}
-				dev->port_caps[port - 1].has_smi =
-					vport_ctx.has_smi;
-			} else {
-				dev->port_caps[port - 1].has_smi = true;
-			}
+	if (MLX5_CAP_GEN(dev->mdev, port_type) != MLX5_CAP_PORT_TYPE_IB)
+		return 0;
+
+	for (port = 1; port <= dev->num_ports; port++) {
+		if (!MLX5_CAP_GEN(dev->mdev, ib_virt)) {
+			dev->port_caps[port - 1].has_smi = true;
+			continue;
 		}
+		err = mlx5_query_hca_vport_context(dev->mdev, 0, port, 0,
+						   &vport_ctx);
+		if (err) {
+			mlx5_ib_err(dev, "query_hca_vport_context for port=%d failed %d\n",
+				    port, err);
+			return err;
+		}
+		dev->port_caps[port - 1].has_smi = vport_ctx.has_smi;
 	}
+
 	return 0;
 }
 
-- 
2.37.2



