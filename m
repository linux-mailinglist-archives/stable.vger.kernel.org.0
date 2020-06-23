Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62156205F6E
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:33:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390224AbgFWUcq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:32:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:53778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391353AbgFWUcq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:32:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A613206C3;
        Tue, 23 Jun 2020 20:32:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592944366;
        bh=BuHtDyIL+/1LfFaZxMMQgvnNoWYsGzWxgoMN6OTKQ2E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KcHnIsaJpeNy1KxC35DNwmYijRBuqYvJVd3mOrZpDkrE1x5ntS65P5HKdC3XVoS0B
         elqXglKuVNlqBheQAh5ogu6iCK4RNF9wWPXS4xFzcW66sLDqgWwAKda3T8VOQJFARa
         Egkz9gBPoypk52A//fY0ain/J98F15p261byx7Yw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sven Auhagen <sven.auhagen@voleatech.de>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 277/314] mvpp2: remove module bugfix
Date:   Tue, 23 Jun 2020 21:57:52 +0200
Message-Id: <20200623195352.197436951@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195338.770401005@linuxfoundation.org>
References: <20200623195338.770401005@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Auhagen <sven.auhagen@voleatech.de>

[ Upstream commit 807eaf99688ce162a98a7501477644782d4af098 ]

The remove function does not destroy all
BM Pools when per cpu pool is active.

When reloading the mvpp2 as a module the BM Pools
are still active in hardware and due to the bug
have twice the size now old + new.

This eventually leads to a kernel crash.

v2:
* add Fixes tag

Fixes: 7d04b0b13b11 ("mvpp2: percpu buffers")
Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 373b8c8328501..cf5d447af7db2 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -5925,8 +5925,8 @@ static int mvpp2_remove(struct platform_device *pdev)
 {
 	struct mvpp2 *priv = platform_get_drvdata(pdev);
 	struct fwnode_handle *fwnode = pdev->dev.fwnode;
+	int i = 0, poolnum = MVPP2_BM_POOLS_NUM;
 	struct fwnode_handle *port_fwnode;
-	int i = 0;
 
 	mvpp2_dbgfs_cleanup(priv);
 
@@ -5940,7 +5940,10 @@ static int mvpp2_remove(struct platform_device *pdev)
 
 	destroy_workqueue(priv->stats_queue);
 
-	for (i = 0; i < MVPP2_BM_POOLS_NUM; i++) {
+	if (priv->percpu_pools)
+		poolnum = mvpp2_get_nrxqs(priv) * 2;
+
+	for (i = 0; i < poolnum; i++) {
 		struct mvpp2_bm_pool *bm_pool = &priv->bm_pools[i];
 
 		mvpp2_bm_pool_destroy(&pdev->dev, priv, bm_pool);
-- 
2.25.1



