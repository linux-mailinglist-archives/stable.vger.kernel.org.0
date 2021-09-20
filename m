Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4F08412519
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:40:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353644AbhITSl0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:41:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:56388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1382094AbhITSj5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:39:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 58ADA61AE2;
        Mon, 20 Sep 2021 17:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632159048;
        bh=apE6AM+TnTjolPcH5nTELBboWRG2RCmWabYE60Kdojw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QY2K/fbkXRvWfEZWxILqbM9iheqOXjEmiQEnCxAXgL9SP9pOKWcUaQvwPvAwl2ID+
         +vvsvvBDhKFGFKnpyfZinMTioTildez1azwrqWsB4DqbKatCF8X5F1AgMbJJsY8X5u
         eCQryW9YiTB2MtSsDLNlOprXKK4WgQS/cRFgal1g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Maor Gottlieb <maorg@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 5.14 052/168] net/mlx5: Fix potential sleeping in atomic context
Date:   Mon, 20 Sep 2021 18:43:10 +0200
Message-Id: <20210920163923.345892196@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163921.633181900@linuxfoundation.org>
References: <20210920163921.633181900@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maor Gottlieb <maorg@nvidia.com>

commit ee27e330a953595903979ffdb84926843595a9fe upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -1682,14 +1682,13 @@ static int build_match_list(struct match
 
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


