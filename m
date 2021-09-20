Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9DDD411097
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 10:00:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231240AbhITIB7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 04:01:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:58820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230503AbhITIB6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 04:01:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E70CC60FF2;
        Mon, 20 Sep 2021 08:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632124827;
        bh=EQvGqS94czH4UugVkNVXYyZu+bK6qsqKuCvtEzkOaAg=;
        h=Subject:To:Cc:From:Date:From;
        b=AXn+VBSG/P3/QUpMtyViVEiMC9kIT/Lq2tSg2xOrLAmUT2S3z5KUga62aEfU+5vHS
         Yi1mAdjPjm+I1DFjNMKxDm9RjbkebdOs7plTH4j1eBj1kY2Oi5Uj6WMPHSH1FVsz4k
         XnksirQnfbRADhh8KNTPD83zHeoNhJ83ONxrIDSQ=
Subject: FAILED: patch "[PATCH] net/mlx5: Fix potential sleeping in atomic context" failed to apply to 4.14-stable tree
To:     maorg@nvidia.com, dan.carpenter@oracle.com, saeedm@nvidia.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 Sep 2021 10:00:24 +0200
Message-ID: <163212482474189@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ee27e330a953595903979ffdb84926843595a9fe Mon Sep 17 00:00:00 2001
From: Maor Gottlieb <maorg@nvidia.com>
Date: Wed, 1 Sep 2021 11:48:13 +0300
Subject: [PATCH] net/mlx5: Fix potential sleeping in atomic context

Fixes the below flow of sleeping in atomic context by releasing
the RCU lock before calling to free_match_list.

build_match_list() <- disables preempt
-> free_match_list()
   -> tree_put_node()
      -> down_write_ref_node() <- take write lock

Fixes: 693c6883bbc4 ("net/mlx5: Add hash table for flow groups in flow table")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index 9fe8e3c204d6..fe501ba88bea 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -1682,14 +1682,13 @@ static int build_match_list(struct match_list *match_head,
 
 		curr_match = kmalloc(sizeof(*curr_match), GFP_ATOMIC);
 		if (!curr_match) {
+			rcu_read_unlock();
 			free_match_list(match_head, ft_locked);
-			err = -ENOMEM;
-			goto out;
+			return -ENOMEM;
 		}
 		curr_match->g = g;
 		list_add_tail(&curr_match->list, &match_head->list);
 	}
-out:
 	rcu_read_unlock();
 	return err;
 }

