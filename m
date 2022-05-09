Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0EDF51FA40
	for <lists+stable@lfdr.de>; Mon,  9 May 2022 12:46:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbiEIKrq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 May 2022 06:47:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230410AbiEIKro (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 May 2022 06:47:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 382A62D2E1F
        for <stable@vger.kernel.org>; Mon,  9 May 2022 03:42:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3AF3160FC8
        for <stable@vger.kernel.org>; Mon,  9 May 2022 10:33:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BEA0C385AB;
        Mon,  9 May 2022 10:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652092393;
        bh=BoHor2/dWjC9qQ2Ah+qNeZIhmJqvmv/DEp5s+mknn1A=;
        h=Subject:To:Cc:From:Date:From;
        b=wMNkN7NpFNsYtwxciwhxQ4LGJZMHUWucKOxnyNDCURpnQr0QQXscs/LvXFCVzovtb
         8fxa3Bm0rDdmz70QkqsLs72ZvGLbzZPAUns15vwuYqDlWaqEk5mLjOkskqM1kwQw97
         LTi6xvehXyTzr1vLCNfOz+GJJ6LUWJIepilu563U=
Subject: FAILED: patch "[PATCH] net/mlx5e: Lag, Fix fib_info pointer assignment" failed to apply to 5.15-stable tree
To:     vladbu@nvidia.com, maord@nvidia.com, saeedm@nvidia.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 09 May 2022 12:33:02 +0200
Message-ID: <165209238261142@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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

From a6589155ec9847918e00e7279b8aa6d4c272bea7 Mon Sep 17 00:00:00 2001
From: Vlad Buslov <vladbu@nvidia.com>
Date: Mon, 18 Apr 2022 17:32:54 +0300
Subject: [PATCH] net/mlx5e: Lag, Fix fib_info pointer assignment

Referenced change incorrectly sets single path fib_info even when LAG is
not active. Fix it by moving call to mlx5_lag_fib_set() into conditional
that verifies LAG state.

Fixes: ad11c4f1d8fd ("net/mlx5e: Lag, Only handle events from highest priority multipath entry")
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c
index bc77aba97ac1..9a5884e8a8bf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c
@@ -149,9 +149,9 @@ static void mlx5_lag_fib_route_event(struct mlx5_lag *ldev,
 
 			i++;
 			mlx5_lag_set_port_affinity(ldev, i);
+			mlx5_lag_fib_set(mp, fi);
 		}
 
-		mlx5_lag_fib_set(mp, fi);
 		return;
 	}
 

