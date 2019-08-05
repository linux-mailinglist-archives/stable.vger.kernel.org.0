Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D93981CC1
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 15:27:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730921AbfHENZc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 09:25:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:34058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729788AbfHENZb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 09:25:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6BEC920644;
        Mon,  5 Aug 2019 13:25:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565011530;
        bh=OCT9nKd6QZ6uecD+UbIDaVZJT5ahIUxDc1/sUbTbOuY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nya0AxTcIZJqDyjDKLFlZNhjv9oPaFePZoD/6ZxNRM2Crgetdi43wY/SRfh8d2inn
         Fe1UafG0PYGvxb/z34l3ELpCbNFVYgl34x72uIPotC2yftuTzezDalv38PO2mtGoct
         eaetybis+yDaTu87RCQUOLcJm1JGQKyM8bMAuu94=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yishai Hadas <yishaih@mellanox.com>,
        Artemy Kovalyov <artemyko@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 5.2 123/131] IB/mlx5: Use direct mkey destroy command upon UMR unreg failure
Date:   Mon,  5 Aug 2019 15:03:30 +0200
Message-Id: <20190805125000.200781788@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190805124951.453337465@linuxfoundation.org>
References: <20190805124951.453337465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yishai Hadas <yishaih@mellanox.com>

commit afd1417404fba6dbfa6c0a8e5763bd348da682e4 upstream.

Use a direct firmware command to destroy the mkey in case the unreg UMR
operation has failed.

This prevents a case that a mkey will leak out from the cache post a
failure to be destroyed by a UMR WR.

In case the MR cache limit didn't reach a call to add another entry to the
cache instead of the destroyed one is issued.

In addition, replaced a warn message to WARN_ON() as this flow is fatal
and can't happen unless some bug around.

Link: https://lore.kernel.org/r/20190723065733.4899-4-leon@kernel.org
Cc: <stable@vger.kernel.org> # 4.10
Fixes: 49780d42dfc9 ("IB/mlx5: Expose MR cache for mlx5_ib")
Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Reviewed-by: Artemy Kovalyov <artemyko@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/hw/mlx5/mr.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -545,13 +545,16 @@ void mlx5_mr_cache_free(struct mlx5_ib_d
 		return;
 
 	c = order2idx(dev, mr->order);
-	if (c < 0 || c >= MAX_MR_CACHE_ENTRIES) {
-		mlx5_ib_warn(dev, "order %d, cache index %d\n", mr->order, c);
-		return;
-	}
+	WARN_ON(c < 0 || c >= MAX_MR_CACHE_ENTRIES);
 
-	if (unreg_umr(dev, mr))
+	if (unreg_umr(dev, mr)) {
+		mr->allocated_from_cache = false;
+		destroy_mkey(dev, mr);
+		ent = &cache->ent[c];
+		if (ent->cur < ent->limit)
+			queue_work(cache->wq, &ent->work);
 		return;
+	}
 
 	ent = &cache->ent[c];
 	spin_lock_irq(&ent->lock);


