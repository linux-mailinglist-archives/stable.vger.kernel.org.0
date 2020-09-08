Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A15C261CAA
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 21:24:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726657AbgIHTYg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 15:24:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:48726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730845AbgIHQBY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:01:24 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 075C723EF6;
        Tue,  8 Sep 2020 15:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579480;
        bh=i+H5koQax4E1xZlNxo71mIVDMgy5YRr0zxNBvBBJNNg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kaM9w2v1gsAeURcufYPUf+SnIdy+zcviQIauE7P5K0h3kKy9wSQeTbJXVVBEtOAAw
         m8C4WhfcqY1FG67N/keyA10EMf7IouraDLS9DMSgcp0sAfI9omdz2LNrF8thcIHV2O
         QARwxHKBSa+1rzR2GWqX4Lw8g3X+NzF/KUIfiwlM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 095/186] net: ethernet: mlx4: Fix memory allocation in mlx4_buddy_init()
Date:   Tue,  8 Sep 2020 17:23:57 +0200
Message-Id: <20200908152246.239084509@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152241.646390211@linuxfoundation.org>
References: <20200908152241.646390211@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shung-Hsi Yu <shung-hsi.yu@suse.com>

[ Upstream commit cbedcb044e9cc4e14bbe6658111224bb923094f4 ]

On machines with much memory (> 2 TByte) and log_mtts_per_seg == 0, a
max_order of 31 will be passed to mlx_buddy_init(), which results in
s = BITS_TO_LONGS(1 << 31) becoming a negative value, leading to
kvmalloc_array() failure when it is converted to size_t.

  mlx4_core 0000:b1:00.0: Failed to initialize memory region table, aborting
  mlx4_core: probe of 0000:b1:00.0 failed with error -12

Fix this issue by changing the left shifting operand from a signed literal to
an unsigned one.

Fixes: 225c7b1feef1 ("IB/mlx4: Add a driver Mellanox ConnectX InfiniBand adapters")
Signed-off-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx4/mr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/mr.c b/drivers/net/ethernet/mellanox/mlx4/mr.c
index d2986f1f2db02..d7444782bfdd0 100644
--- a/drivers/net/ethernet/mellanox/mlx4/mr.c
+++ b/drivers/net/ethernet/mellanox/mlx4/mr.c
@@ -114,7 +114,7 @@ static int mlx4_buddy_init(struct mlx4_buddy *buddy, int max_order)
 		goto err_out;
 
 	for (i = 0; i <= buddy->max_order; ++i) {
-		s = BITS_TO_LONGS(1 << (buddy->max_order - i));
+		s = BITS_TO_LONGS(1UL << (buddy->max_order - i));
 		buddy->bits[i] = kvmalloc_array(s, sizeof(long), GFP_KERNEL | __GFP_ZERO);
 		if (!buddy->bits[i])
 			goto err_out_free;
-- 
2.25.1



