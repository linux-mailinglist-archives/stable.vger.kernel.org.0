Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A77A51FA13
	for <lists+stable@lfdr.de>; Mon,  9 May 2022 12:38:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229938AbiEIKlk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 May 2022 06:41:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229943AbiEIKli (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 May 2022 06:41:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 452512BD0C1
        for <stable@vger.kernel.org>; Mon,  9 May 2022 03:37:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 31D9560FA8
        for <stable@vger.kernel.org>; Mon,  9 May 2022 10:33:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24815C385A8;
        Mon,  9 May 2022 10:33:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652092385;
        bh=kp/Sahh7G9+hQPdViEEKBQ8v2cZglob6V577ciauru4=;
        h=Subject:To:Cc:From:Date:From;
        b=1uyOXl0/OrZs1uQ2r3ImSWsbJvL6CQoKA+AeDaOx3m2A8BYcQuuWk/xNJN337cqZc
         uA5LrH4ZoZ+gUV6yhGHnhyfkHmL0jlfAPDvYyxo/bPeCVCgClHMOpZPrk+r4XTyYMe
         bvTMLNdyMARe0baUVln7fxSmSCL/khIOh26EEp0Q=
Subject: FAILED: patch "[PATCH] net/mlx5e: Lag, Fix fib_info pointer assignment" failed to apply to 5.10-stable tree
To:     vladbu@nvidia.com, maord@nvidia.com, saeedm@nvidia.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 09 May 2022 12:33:02 +0200
Message-ID: <1652092382154232@kroah.com>
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


The patch below does not apply to the 5.10-stable tree.
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
 

