Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D16991D8284
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 19:57:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730788AbgERR5H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:57:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:35338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731729AbgERR5D (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:57:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2FDD220674;
        Mon, 18 May 2020 17:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824622;
        bh=Q5FvV5cPVWRI5q1Z0YUIdKRP3XU6yINX90WbjAROKSg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GNBSuF3oWYc6Y1tBpzX4wfsDUtTfa2wep3MZNc4Jiq9dL3AApoFyBMXM5l1yJSykK
         bl2yd+5F2aVNMyOROkb63bZkeF4IBrlv1OlVkgCsFiYYGF+E3SuhZV7zCEaADJkDnE
         ljIaRSYy7hjaSigsAu8JuGhnYIPkbdizVg8LgagE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jack Morgenstein <jackm@dev.mellanox.co.il>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 086/147] IB/core: Fix potential NULL pointer dereference in pkey cache
Date:   Mon, 18 May 2020 19:36:49 +0200
Message-Id: <20200518173524.288487895@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173513.009514388@linuxfoundation.org>
References: <20200518173513.009514388@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jack Morgenstein <jackm@dev.mellanox.co.il>

[ Upstream commit 1901b91f99821955eac2bd48fe25ee983385dc00 ]

The IB core pkey cache is populated by procedure ib_cache_update().
Initially, the pkey cache pointer is NULL. ib_cache_update allocates a
buffer and populates it with the device's pkeys, via repeated calls to
procedure ib_query_pkey().

If there is a failure in populating the pkey buffer via ib_query_pkey(),
ib_cache_update does not replace the old pkey buffer cache with the
updated one -- it leaves the old cache as is.

Since initially the pkey buffer cache is NULL, when calling
ib_cache_update the first time, a failure in ib_query_pkey() will cause
the pkey buffer cache pointer to remain NULL.

In this situation, any calls subsequent to ib_get_cached_pkey(),
ib_find_cached_pkey(), or ib_find_cached_pkey_exact() will try to
dereference the NULL pkey cache pointer, causing a kernel panic.

Fix this by checking the ib_cache_update() return value.

Fixes: 8faea9fd4a39 ("RDMA/cache: Move the cache per-port data into the main ib_port_data")
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Link: https://lore.kernel.org/r/20200507071012.100594-1-leon@kernel.org
Signed-off-by: Jack Morgenstein <jackm@dev.mellanox.co.il>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/cache.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/cache.c b/drivers/infiniband/core/cache.c
index 65b10efca2b8c..7affe6b4ae210 100644
--- a/drivers/infiniband/core/cache.c
+++ b/drivers/infiniband/core/cache.c
@@ -1542,8 +1542,11 @@ int ib_cache_setup_one(struct ib_device *device)
 	if (err)
 		return err;
 
-	rdma_for_each_port (device, p)
-		ib_cache_update(device, p, true);
+	rdma_for_each_port (device, p) {
+		err = ib_cache_update(device, p, true);
+		if (err)
+			return err;
+	}
 
 	return 0;
 }
-- 
2.20.1



