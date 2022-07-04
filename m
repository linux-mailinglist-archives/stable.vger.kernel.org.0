Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6CAF565756
	for <lists+stable@lfdr.de>; Mon,  4 Jul 2022 15:33:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232656AbiGDNcz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jul 2022 09:32:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234210AbiGDNcT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jul 2022 09:32:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39DE712AB4
        for <stable@vger.kernel.org>; Mon,  4 Jul 2022 06:30:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E7EBDB80F00
        for <stable@vger.kernel.org>; Mon,  4 Jul 2022 13:30:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 450A6C3411E;
        Mon,  4 Jul 2022 13:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656941407;
        bh=iOcmg1D13MaNnMixPwanZn+NRayh8apurhZxCf3FVKs=;
        h=Subject:To:Cc:From:Date:From;
        b=CuCLo71482OpV9YwuEwZgTq+oGS0gBcmOIwYUpVO7bcBvbLrAoK+jrwFfT8Wz2COH
         dTUk7ZfyXf7C0OJcdXBA3OVXzxQyDV6xkmZNao5bTf6V+MbQQDcChHEiUbQPX+qAG5
         63vwBHJudS1gWo+XILh2bNm6ayC2xgK0Fegvt8VI=
Subject: FAILED: patch "[PATCH] mlxsw: spectrum_router: Fix rollback in tunnel next hop init" failed to apply to 5.10-stable tree
To:     petrm@nvidia.com, amcohen@nvidia.com, idosch@nvidia.com,
        pabeni@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 04 Jul 2022 15:30:05 +0200
Message-ID: <165694140522419@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 665030fd0c1ed9f505932e6e73e7a2c788787a0a Mon Sep 17 00:00:00 2001
From: Petr Machata <petrm@nvidia.com>
Date: Wed, 29 Jun 2022 10:02:05 +0300
Subject: [PATCH] mlxsw: spectrum_router: Fix rollback in tunnel next hop init

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

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 9dbb573d53ea..0d8a0068e4ca 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -4415,6 +4415,8 @@ static int mlxsw_sp_nexthop4_init(struct mlxsw_sp *mlxsw_sp,
 	return 0;
 
 err_nexthop_neigh_init:
+	list_del(&nh->router_list_node);
+	mlxsw_sp_nexthop_counter_free(mlxsw_sp, nh);
 	mlxsw_sp_nexthop_remove(mlxsw_sp, nh);
 	return err;
 }
@@ -6740,6 +6742,7 @@ static int mlxsw_sp_nexthop6_init(struct mlxsw_sp *mlxsw_sp,
 				  const struct fib6_info *rt)
 {
 	struct net_device *dev = rt->fib6_nh->fib_nh_dev;
+	int err;
 
 	nh->nhgi = nh_grp->nhgi;
 	nh->nh_weight = rt->fib6_nh->fib_nh_weight;
@@ -6755,7 +6758,16 @@ static int mlxsw_sp_nexthop6_init(struct mlxsw_sp *mlxsw_sp,
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

