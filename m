Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 174BF3C4E50
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:41:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243881AbhGLHRt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:17:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:48966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243766AbhGLHRH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:17:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 153B061360;
        Mon, 12 Jul 2021 07:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074051;
        bh=easLhoSpdHPweHz9NCe+8HiANKFsHD4QA0BvtHtT0VM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uWCYHia4kACuJOOSIkQb8ndC3nzaHBMXYeBNmF4Oytp5xVKJVID6glYQldrqb1dXi
         EQeujPFyWEP0VbJgDYKhwPjGDvaIqo3eO10ZVzXYf3sresxphJbmWP9pXvzl7+ELQp
         QRutb9J+Gu9IAKKp6ou+0hYgzxIa+UnJILqOaN+s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 441/700] net: ethernet: aeroflex: fix UAF in greth_of_remove
Date:   Mon, 12 Jul 2021 08:08:44 +0200
Message-Id: <20210712061023.420220686@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Skripkin <paskripkin@gmail.com>

[ Upstream commit e3a5de6d81d8b2199935c7eb3f7d17a50a7075b7 ]

static int greth_of_remove(struct platform_device *of_dev)
{
...
	struct greth_private *greth = netdev_priv(ndev);
...
	unregister_netdev(ndev);
	free_netdev(ndev);

	of_iounmap(&of_dev->resource[0], greth->regs, resource_size(&of_dev->resource[0]));
...
}

greth is netdev private data, but it is used
after free_netdev(). It can cause use-after-free when accessing greth
pointer. So, fix it by moving free_netdev() after of_iounmap()
call.

Fixes: d4c41139df6e ("net: Add Aeroflex Gaisler 10/100/1G Ethernet MAC driver")
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/aeroflex/greth.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/aeroflex/greth.c b/drivers/net/ethernet/aeroflex/greth.c
index 9c5891bbfe61..f4f50b3a472e 100644
--- a/drivers/net/ethernet/aeroflex/greth.c
+++ b/drivers/net/ethernet/aeroflex/greth.c
@@ -1539,10 +1539,11 @@ static int greth_of_remove(struct platform_device *of_dev)
 	mdiobus_unregister(greth->mdio);
 
 	unregister_netdev(ndev);
-	free_netdev(ndev);
 
 	of_iounmap(&of_dev->resource[0], greth->regs, resource_size(&of_dev->resource[0]));
 
+	free_netdev(ndev);
+
 	return 0;
 }
 
-- 
2.30.2



