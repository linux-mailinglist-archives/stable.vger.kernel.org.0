Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88738521ADD
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 16:01:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243050AbiEJOCz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 10:02:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245204AbiEJN5S (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:57:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 529412CC13F;
        Tue, 10 May 2022 06:38:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 18639B81D7A;
        Tue, 10 May 2022 13:38:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B0BAC385A6;
        Tue, 10 May 2022 13:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189932;
        bh=FM+9f0lcvYb+RKVxJEYtJHTrKZyJPaTJRirnGzdUu8M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nBjm09h9hiUhO7JytnheFScUWhHM8YvT1ifKHeFsMkt2GDFBuhk043JNhflgXcaIn
         Zsbl2AvOvvr5QhoJdNK75AUsx6IpnacZp3TNfsjBNxmFd5PWvJbA5SSRrrHyndAMyK
         PLvdKxU90ER3/DoGARLkPsNhY2mT1XRmc+vSNTL0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vlad Buslov <vladbu@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 5.17 074/140] net/mlx5e: Lag, Dont skip fib events on current dst
Date:   Tue, 10 May 2022 15:07:44 +0200
Message-Id: <20220510130743.732558194@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130741.600270947@linuxfoundation.org>
References: <20220510130741.600270947@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vlad Buslov <vladbu@nvidia.com>

commit 4a2a664ed87962c4ddb806a84b5c9634820bcf55 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c |   20 ++++++++++++--------
 drivers/net/ethernet/mellanox/mlx5/core/lag/mp.h |    2 ++
 2 files changed, 14 insertions(+), 8 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c
@@ -100,10 +100,12 @@ static void mlx5_lag_fib_event_flush(str
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
@@ -133,7 +135,9 @@ static void mlx5_lag_fib_route_event(str
 	}
 
 	/* Handle multipath entry with lower priority value */
-	if (mp->fib.mfi && mp->fib.mfi != fi && fi->fib_priority >= mp->fib.priority)
+	if (mp->fib.mfi && mp->fib.mfi != fi &&
+	    (mp->fib.dst != fen_info->dst || mp->fib.dst_len != fen_info->dst_len) &&
+	    fi->fib_priority >= mp->fib.priority)
 		return;
 
 	/* Handle add/replace event */
@@ -149,7 +153,7 @@ static void mlx5_lag_fib_route_event(str
 
 			i++;
 			mlx5_lag_set_port_affinity(ldev, i);
-			mlx5_lag_fib_set(mp, fi);
+			mlx5_lag_fib_set(mp, fi, fen_info->dst, fen_info->dst_len);
 		}
 
 		return;
@@ -179,7 +183,7 @@ static void mlx5_lag_fib_route_event(str
 	}
 
 	mlx5_lag_set_port_affinity(ldev, MLX5_LAG_NORMAL_AFFINITY);
-	mlx5_lag_fib_set(mp, fi);
+	mlx5_lag_fib_set(mp, fi, fen_info->dst, fen_info->dst_len);
 }
 
 static void mlx5_lag_fib_nexthop_event(struct mlx5_lag *ldev,
@@ -220,7 +224,7 @@ static void mlx5_lag_fib_update(struct w
 	case FIB_EVENT_ENTRY_REPLACE:
 	case FIB_EVENT_ENTRY_DEL:
 		mlx5_lag_fib_route_event(ldev, fib_work->event,
-					 fib_work->fen_info.fi);
+					 &fib_work->fen_info);
 		fib_info_put(fib_work->fen_info.fi);
 		break;
 	case FIB_EVENT_NH_ADD:
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


