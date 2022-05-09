Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94F0451FA16
	for <lists+stable@lfdr.de>; Mon,  9 May 2022 12:38:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229703AbiEIKmK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 May 2022 06:42:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230169AbiEIKmJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 May 2022 06:42:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38036EAD02
        for <stable@vger.kernel.org>; Mon,  9 May 2022 03:38:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6AC4B60FD6
        for <stable@vger.kernel.org>; Mon,  9 May 2022 10:33:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B87FC385A8;
        Mon,  9 May 2022 10:33:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652092411;
        bh=aEHUzmcrCsnCIqBebng98NbZHLKmtVaS+8M+WB7sq7A=;
        h=Subject:To:Cc:From:Date:From;
        b=EHmTN6dQF9BE9x06onobqQFDQTsKoAmrtCqccg/5xINZNyv+4wmvkkjl+A/883pyR
         uokYT9CL3H5cHxba0hjbPc9LkxCev+1bhHukQDyPn7T3RZ6OToDaMCQw7g0lt30cTI
         OatSiPWK6QBMZKcyYv2f5eyuyn2c3Lg+ksSr3qEI=
Subject: FAILED: patch "[PATCH] net/mlx5e: Lag, Don't skip fib events on current dst" failed to apply to 5.15-stable tree
To:     vladbu@nvidia.com, maord@nvidia.com, saeedm@nvidia.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 09 May 2022 12:33:20 +0200
Message-ID: <1652092400171158@kroah.com>
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

From 4a2a664ed87962c4ddb806a84b5c9634820bcf55 Mon Sep 17 00:00:00 2001
From: Vlad Buslov <vladbu@nvidia.com>
Date: Mon, 18 Apr 2022 17:40:37 +0300
Subject: [PATCH] net/mlx5e: Lag, Don't skip fib events on current dst

Referenced change added check to skip updating fib when new fib instance
has same or lower priority. However, new fib instance can be an update on
same dst address as existing one even though the structure is another
instance that has different address. Ignoring events on such instances
causes multipath LAG state to not be correctly updated.

Track 'dst' and 'dst_len' fields of fib event fib_entry_notifier_info
structure and don't skip events that have the same value of that fields.

Fixes: ad11c4f1d8fd ("net/mlx5e: Lag, Only handle events from highest priority multipath entry")
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c
index 9a5884e8a8bf..d6c3e6dfd71f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c
@@ -100,10 +100,12 @@ static void mlx5_lag_fib_event_flush(struct notifier_block *nb)
 	flush_workqueue(mp->wq);
 }
 
-static void mlx5_lag_fib_set(struct lag_mp *mp, struct fib_info *fi)
+static void mlx5_lag_fib_set(struct lag_mp *mp, struct fib_info *fi, u32 dst, int dst_len)
 {
 	mp->fib.mfi = fi;
 	mp->fib.priority = fi->fib_priority;
+	mp->fib.dst = dst;
+	mp->fib.dst_len = dst_len;
 }
 
 struct mlx5_fib_event_work {
@@ -116,10 +118,10 @@ struct mlx5_fib_event_work {
 	};
 };
 
-static void mlx5_lag_fib_route_event(struct mlx5_lag *ldev,
-				     unsigned long event,
-				     struct fib_info *fi)
+static void mlx5_lag_fib_route_event(struct mlx5_lag *ldev, unsigned long event,
+				     struct fib_entry_notifier_info *fen_info)
 {
+	struct fib_info *fi = fen_info->fi;
 	struct lag_mp *mp = &ldev->lag_mp;
 	struct fib_nh *fib_nh0, *fib_nh1;
 	unsigned int nhs;
@@ -133,7 +135,9 @@ static void mlx5_lag_fib_route_event(struct mlx5_lag *ldev,
 	}
 
 	/* Handle multipath entry with lower priority value */
-	if (mp->fib.mfi && mp->fib.mfi != fi && fi->fib_priority >= mp->fib.priority)
+	if (mp->fib.mfi && mp->fib.mfi != fi &&
+	    (mp->fib.dst != fen_info->dst || mp->fib.dst_len != fen_info->dst_len) &&
+	    fi->fib_priority >= mp->fib.priority)
 		return;
 
 	/* Handle add/replace event */
@@ -149,7 +153,7 @@ static void mlx5_lag_fib_route_event(struct mlx5_lag *ldev,
 
 			i++;
 			mlx5_lag_set_port_affinity(ldev, i);
-			mlx5_lag_fib_set(mp, fi);
+			mlx5_lag_fib_set(mp, fi, fen_info->dst, fen_info->dst_len);
 		}
 
 		return;
@@ -179,7 +183,7 @@ static void mlx5_lag_fib_route_event(struct mlx5_lag *ldev,
 	}
 
 	mlx5_lag_set_port_affinity(ldev, MLX5_LAG_NORMAL_AFFINITY);
-	mlx5_lag_fib_set(mp, fi);
+	mlx5_lag_fib_set(mp, fi, fen_info->dst, fen_info->dst_len);
 }
 
 static void mlx5_lag_fib_nexthop_event(struct mlx5_lag *ldev,
@@ -220,7 +224,7 @@ static void mlx5_lag_fib_update(struct work_struct *work)
 	case FIB_EVENT_ENTRY_REPLACE:
 	case FIB_EVENT_ENTRY_DEL:
 		mlx5_lag_fib_route_event(ldev, fib_work->event,
-					 fib_work->fen_info.fi);
+					 &fib_work->fen_info);
 		fib_info_put(fib_work->fen_info.fi);
 		break;
 	case FIB_EVENT_NH_ADD:
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/mp.h b/drivers/net/ethernet/mellanox/mlx5/core/lag/mp.h
index 143226753c3a..056a066da604 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/mp.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/mp.h
@@ -18,6 +18,8 @@ struct lag_mp {
 	struct {
 		const void        *mfi; /* used in tracking fib events */
 		u32               priority;
+		u32               dst;
+		int               dst_len;
 	} fib;
 	struct workqueue_struct   *wq;
 };

