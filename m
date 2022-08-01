Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 861E3586A40
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 14:14:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234126AbiHAMOK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 08:14:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234140AbiHAMNZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 08:13:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9589753AD;
        Mon,  1 Aug 2022 04:57:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A05AAB81177;
        Mon,  1 Aug 2022 11:57:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0AAFC43470;
        Mon,  1 Aug 2022 11:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659355050;
        bh=FyEep/jFRSTtylJI1Fb5kcB37dDN715UCJD70qJGHJE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lzdlSMpy0In8chgiOrBZx1yozdP81uRKxMMII4XrvIKoJm+OhhE/s9NryJAJ1oyhV
         pP6kJegIDcA1Cy0jgV3T3Qaq2oShwetdTWpop6WhOfCwYvmYiJhtu4tYqqOqCWieEZ
         njFvr7pMJ64+8DhFW+HABlFcJAkJLq6rGoPcWjOU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Rix <trix@redhat.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 45/88] mlxsw: spectrum_router: simplify list unwinding
Date:   Mon,  1 Aug 2022 13:46:59 +0200
Message-Id: <20220801114140.109582978@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220801114138.041018499@linuxfoundation.org>
References: <20220801114138.041018499@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Rix <trix@redhat.com>

[ Upstream commit 6f2f36e5f932c58e370bff79aba7f05963ea1c2a ]

The setting of i here
err_nexthop6_group_get:
	i = nrt6;
Is redundant, i is already nrt6.  So remove
this statement.

The for loop for the unwinding
err_rt6_create:
	for (i--; i >= 0; i--) {
Is equivelent to
	for (; i > 0; i--) {

Two consecutive labels can be reduced to one.

Signed-off-by: Tom Rix <trix@redhat.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://lore.kernel.org/r/20220402121516.2750284-1-trix@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 20 ++++++++-----------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index c00d6c4ed37c..245d36696486 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -7022,7 +7022,7 @@ mlxsw_sp_fib6_entry_nexthop_add(struct mlxsw_sp *mlxsw_sp,
 		mlxsw_sp_rt6 = mlxsw_sp_rt6_create(rt_arr[i]);
 		if (IS_ERR(mlxsw_sp_rt6)) {
 			err = PTR_ERR(mlxsw_sp_rt6);
-			goto err_rt6_create;
+			goto err_rt6_unwind;
 		}
 
 		list_add_tail(&mlxsw_sp_rt6->list, &fib6_entry->rt6_list);
@@ -7031,14 +7031,12 @@ mlxsw_sp_fib6_entry_nexthop_add(struct mlxsw_sp *mlxsw_sp,
 
 	err = mlxsw_sp_nexthop6_group_update(mlxsw_sp, op_ctx, fib6_entry);
 	if (err)
-		goto err_nexthop6_group_update;
+		goto err_rt6_unwind;
 
 	return 0;
 
-err_nexthop6_group_update:
-	i = nrt6;
-err_rt6_create:
-	for (i--; i >= 0; i--) {
+err_rt6_unwind:
+	for (; i > 0; i--) {
 		fib6_entry->nrt6--;
 		mlxsw_sp_rt6 = list_last_entry(&fib6_entry->rt6_list,
 					       struct mlxsw_sp_rt6, list);
@@ -7166,7 +7164,7 @@ mlxsw_sp_fib6_entry_create(struct mlxsw_sp *mlxsw_sp,
 		mlxsw_sp_rt6 = mlxsw_sp_rt6_create(rt_arr[i]);
 		if (IS_ERR(mlxsw_sp_rt6)) {
 			err = PTR_ERR(mlxsw_sp_rt6);
-			goto err_rt6_create;
+			goto err_rt6_unwind;
 		}
 		list_add_tail(&mlxsw_sp_rt6->list, &fib6_entry->rt6_list);
 		fib6_entry->nrt6++;
@@ -7174,7 +7172,7 @@ mlxsw_sp_fib6_entry_create(struct mlxsw_sp *mlxsw_sp,
 
 	err = mlxsw_sp_nexthop6_group_get(mlxsw_sp, fib6_entry);
 	if (err)
-		goto err_nexthop6_group_get;
+		goto err_rt6_unwind;
 
 	err = mlxsw_sp_nexthop_group_vr_link(fib_entry->nh_group,
 					     fib_node->fib);
@@ -7193,10 +7191,8 @@ mlxsw_sp_fib6_entry_create(struct mlxsw_sp *mlxsw_sp,
 	mlxsw_sp_nexthop_group_vr_unlink(fib_entry->nh_group, fib_node->fib);
 err_nexthop_group_vr_link:
 	mlxsw_sp_nexthop6_group_put(mlxsw_sp, fib_entry);
-err_nexthop6_group_get:
-	i = nrt6;
-err_rt6_create:
-	for (i--; i >= 0; i--) {
+err_rt6_unwind:
+	for (; i > 0; i--) {
 		fib6_entry->nrt6--;
 		mlxsw_sp_rt6 = list_last_entry(&fib6_entry->rt6_list,
 					       struct mlxsw_sp_rt6, list);
-- 
2.35.1



