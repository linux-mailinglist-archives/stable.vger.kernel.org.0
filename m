Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5561627E96
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 13:49:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237324AbiKNMtO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 07:49:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237340AbiKNMtM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 07:49:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 273082C8
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 04:49:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B7BD461154
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 12:49:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C66A8C433C1;
        Mon, 14 Nov 2022 12:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668430151;
        bh=jnWd8VOqqSpptGSP7zh+PV7v5yD7uVWjL5xU3jukEns=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A4ZlmAz1EI7YmK7bUhgmr0X3qDowUsKkvB1Rtwqdo4J21cqcXlDBpTz3sWvI0G0O0
         3Ga8o7iIpD4URSwP2lnilrJls2EFNIq8HjrQsaN3r6iIJUMwIxtJ7Hc1DXXgEfYES9
         vIVpMH9WGIkkKQpuePUPz2jNa4td4ZJuRc+AM6BY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Roi Dayan <roid@nvidia.com>,
        Chris Mi <cmi@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 40/95] net/mlx5e: E-Switch, Fix comparing termination table instance
Date:   Mon, 14 Nov 2022 13:45:34 +0100
Message-Id: <20221114124444.226482094@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124442.530286937@linuxfoundation.org>
References: <20221114124442.530286937@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

[ Upstream commit f4f4096b410e8d31c3f07f39de3b17d144edd53d ]

The pkt_reformat pointer being saved under flow_act and not
dest attribute in the termination table instance.
Fix the comparison pointers.

Also fix returning success if one pkt_reformat pointer is null
and the other is not.

Fixes: 249ccc3c95bd ("net/mlx5e: Add support for offloading traffic from uplink to uplink")
Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Chris Mi <cmi@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../mellanox/mlx5/core/eswitch_offloads_termtbl.c  | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
index 1cbb330b9f42..6c865cb7f445 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
@@ -30,9 +30,9 @@ mlx5_eswitch_termtbl_hash(struct mlx5_flow_act *flow_act,
 		     sizeof(dest->vport.num), hash);
 	hash = jhash((const void *)&dest->vport.vhca_id,
 		     sizeof(dest->vport.num), hash);
-	if (dest->vport.pkt_reformat)
-		hash = jhash(dest->vport.pkt_reformat,
-			     sizeof(*dest->vport.pkt_reformat),
+	if (flow_act->pkt_reformat)
+		hash = jhash(flow_act->pkt_reformat,
+			     sizeof(*flow_act->pkt_reformat),
 			     hash);
 	return hash;
 }
@@ -53,9 +53,11 @@ mlx5_eswitch_termtbl_cmp(struct mlx5_flow_act *flow_act1,
 	if (ret)
 		return ret;
 
-	return dest1->vport.pkt_reformat && dest2->vport.pkt_reformat ?
-	       memcmp(dest1->vport.pkt_reformat, dest2->vport.pkt_reformat,
-		      sizeof(*dest1->vport.pkt_reformat)) : 0;
+	if (flow_act1->pkt_reformat && flow_act2->pkt_reformat)
+		return memcmp(flow_act1->pkt_reformat, flow_act2->pkt_reformat,
+			      sizeof(*flow_act1->pkt_reformat));
+
+	return !(flow_act1->pkt_reformat == flow_act2->pkt_reformat);
 }
 
 static int
-- 
2.35.1



