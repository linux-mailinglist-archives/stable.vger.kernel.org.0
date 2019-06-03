Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2F6A32C7E
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 11:18:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727354AbfFCJKx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 05:10:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:55410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728232AbfFCJKt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Jun 2019 05:10:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C926D27E5A;
        Mon,  3 Jun 2019 09:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559553048;
        bh=9JEgFvxhhIQgniKx+jrn1ouwU6H8a5d+1vgxoC/FDWg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FfREa+65O0uU6CKYFBdvQ4Ch76Fl9m2gjKDUe+pIpA/7uUCy4pYiifnOZ3NVgNnSq
         Pqv95dASO6ioeSnQvR9dHMhTa/oKZ9hLt8gWs/DvSwKkqA5p5gSZ/EF3fCv3n7jMzD
         +yI0zdAuX2795mpWS3qVXOAYRJWcvDqetMDFMS3k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jisheng Zhang <Jisheng.Zhang@synaptics.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 12/32] net: mvneta: Fix err code path of probe
Date:   Mon,  3 Jun 2019 11:08:06 +0200
Message-Id: <20190603090312.632619465@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190603090308.472021390@linuxfoundation.org>
References: <20190603090308.472021390@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jisheng Zhang <Jisheng.Zhang@synaptics.com>

[ Upstream commit d484e06e25ebb937d841dac02ac1fe76ec7d4ddd ]

Fix below issues in err code path of probe:
1. we don't need to unregister_netdev() because the netdev isn't
registered.
2. when register_netdev() fails, we also need to destroy bm pool for
HWBM case.

Fixes: dc35a10f68d3 ("net: mvneta: bm: add support for hardware buffer management")
Signed-off-by: Jisheng Zhang <Jisheng.Zhang@synaptics.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/mvneta.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -4611,7 +4611,7 @@ static int mvneta_probe(struct platform_
 	err = register_netdev(dev);
 	if (err < 0) {
 		dev_err(&pdev->dev, "failed to register\n");
-		goto err_free_stats;
+		goto err_netdev;
 	}
 
 	netdev_info(dev, "Using %s mac address %pM\n", mac_from,
@@ -4622,14 +4622,12 @@ static int mvneta_probe(struct platform_
 	return 0;
 
 err_netdev:
-	unregister_netdev(dev);
 	if (pp->bm_priv) {
 		mvneta_bm_pool_destroy(pp->bm_priv, pp->pool_long, 1 << pp->id);
 		mvneta_bm_pool_destroy(pp->bm_priv, pp->pool_short,
 				       1 << pp->id);
 		mvneta_bm_put(pp->bm_priv);
 	}
-err_free_stats:
 	free_percpu(pp->stats);
 err_free_ports:
 	free_percpu(pp->ports);


