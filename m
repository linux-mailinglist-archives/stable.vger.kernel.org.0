Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ACF22664E3
	for <lists+stable@lfdr.de>; Fri, 11 Sep 2020 18:47:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725904AbgIKQrC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Sep 2020 12:47:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:49232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726296AbgIKPIE (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Sep 2020 11:08:04 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 30122223C6;
        Fri, 11 Sep 2020 12:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599829117;
        bh=4Xk5YfXF6sqYijZ5aWjpFFEN3fF6lqguy/KbKh6p48k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hycLCDxuMJV15lE9re3Ios9fis84chndcLYUTiNbw5WPP+fi9upjqeL/R79LodMaY
         bmxVSC+FFEHVvHB1mkwhpcp4udll22qy8X0770ese3OIgNFz20HO9NZgRVhdO7KDAn
         XzwEBnOHremxgm9FxaiMeKE/6fiE3iRQbcDhbp54=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 66/71] net: ethernet: mlx4: Fix memory allocation in mlx4_buddy_init()
Date:   Fri, 11 Sep 2020 14:46:50 +0200
Message-Id: <20200911122508.228000858@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200911122504.928931589@linuxfoundation.org>
References: <20200911122504.928931589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shung-Hsi Yu <shung-hsi.yu@suse.com>

commit cbedcb044e9cc4e14bbe6658111224bb923094f4 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/mellanox/mlx4/mr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/mellanox/mlx4/mr.c
+++ b/drivers/net/ethernet/mellanox/mlx4/mr.c
@@ -114,7 +114,7 @@ static int mlx4_buddy_init(struct mlx4_b
 		goto err_out;
 
 	for (i = 0; i <= buddy->max_order; ++i) {
-		s = BITS_TO_LONGS(1 << (buddy->max_order - i));
+		s = BITS_TO_LONGS(1UL << (buddy->max_order - i));
 		buddy->bits[i] = kcalloc(s, sizeof (long), GFP_KERNEL | __GFP_NOWARN);
 		if (!buddy->bits[i]) {
 			buddy->bits[i] = vzalloc(s * sizeof(long));


