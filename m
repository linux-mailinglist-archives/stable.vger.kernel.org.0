Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF658566E39
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:35:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238073AbiGEMcE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:32:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237998AbiGEM0y (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:26:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32D5218B30;
        Tue,  5 Jul 2022 05:19:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C2CEC61A3D;
        Tue,  5 Jul 2022 12:19:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE4E0C341CB;
        Tue,  5 Jul 2022 12:19:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657023576;
        bh=qdd5LhemVJpkIKRTjx/m2JL5J9QYtLjcJ48EPcaVsEo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FwOflWiU+siwbhbjsBWBbZmQ0QZaN0Yp7juWybxj1KGGUJ8CWxEijo3Y+/eZKkVtv
         VqRpbXVEO4auVq2umXHmIOoHmY677BRaRaw//3C3TXIyf+HK34arsbhxWcL8j6APSP
         wPft8Em+ergoe4HKRyv761LxyCFzvu9TbPjI0a1g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Petr Machata <petrm@nvidia.com>,
        Amit Cohen <amcohen@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.18 079/102] mlxsw: spectrum_router: Fix rollback in tunnel next hop init
Date:   Tue,  5 Jul 2022 13:58:45 +0200
Message-Id: <20220705115620.653529683@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115618.410217782@linuxfoundation.org>
References: <20220705115618.410217782@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

commit 665030fd0c1ed9f505932e6e73e7a2c788787a0a upstream.

In mlxsw_sp_nexthop6_init(), a next hop is always added to the router
linked list, and mlxsw_sp_nexthop_type_init() is invoked afterwards. When
that function results in an error, the next hop will not have been removed
from the linked list. As the error is propagated upwards and the caller
frees the next hop object, the linked list ends up holding an invalid
object.

A similar issue comes up with mlxsw_sp_nexthop4_init(), where rollback
block does exist, however does not include the linked list removal.

Both IPv6 and IPv4 next hops have a similar issue with next-hop counter
rollbacks. As these were introduced in the same patchset as the next hop
linked list, include the cleanup in this patch.

Fixes: dbe4598c1e92 ("mlxsw: spectrum_router: Keep nexthops in a linked list")
Fixes: a5390278a5eb ("mlxsw: spectrum: Add support for setting counters on nexthops")
Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Link: https://lore.kernel.org/r/20220629070205.803952-1-idosch@nvidia.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -4418,6 +4418,8 @@ static int mlxsw_sp_nexthop4_init(struct
 	return 0;
 
 err_nexthop_neigh_init:
+	list_del(&nh->router_list_node);
+	mlxsw_sp_nexthop_counter_free(mlxsw_sp, nh);
 	mlxsw_sp_nexthop_remove(mlxsw_sp, nh);
 	return err;
 }
@@ -6743,6 +6745,7 @@ static int mlxsw_sp_nexthop6_init(struct
 				  const struct fib6_info *rt)
 {
 	struct net_device *dev = rt->fib6_nh->fib_nh_dev;
+	int err;
 
 	nh->nhgi = nh_grp->nhgi;
 	nh->nh_weight = rt->fib6_nh->fib_nh_weight;
@@ -6758,7 +6761,16 @@ static int mlxsw_sp_nexthop6_init(struct
 		return 0;
 	nh->ifindex = dev->ifindex;
 
-	return mlxsw_sp_nexthop_type_init(mlxsw_sp, nh, dev);
+	err = mlxsw_sp_nexthop_type_init(mlxsw_sp, nh, dev);
+	if (err)
+		goto err_nexthop_type_init;
+
+	return 0;
+
+err_nexthop_type_init:
+	list_del(&nh->router_list_node);
+	mlxsw_sp_nexthop_counter_free(mlxsw_sp, nh);
+	return err;
 }
 
 static void mlxsw_sp_nexthop6_fini(struct mlxsw_sp *mlxsw_sp,


