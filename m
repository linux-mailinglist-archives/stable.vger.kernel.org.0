Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73EE63CD95D
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:09:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241656AbhGSO2x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:28:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:37472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243738AbhGSO1N (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:27:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DEE1F61221;
        Mon, 19 Jul 2021 15:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626707246;
        bh=45YPANXbslf0qjkU5QEiMfpYFDx+ydOaFiDvvwIVJS0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j9FN8xImDeuYS5eisLCfd2aiBwTq9xzfAXwmLn84of4oJmAj60rXdMP/ZEoI9Sn3p
         DF8aXuwjaGy2kElcbr84swi/cVrnCVjYiOu2AXq7+qz/BwuX1/072Xz5TC7WSYINEs
         SZBcuV1VQ/lank0m77ZS/JqxtG4HfumDXPSsYai8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 084/245] net: ethernet: aeroflex: fix UAF in greth_of_remove
Date:   Mon, 19 Jul 2021 16:50:26 +0200
Message-Id: <20210719144943.119339978@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.288257948@linuxfoundation.org>
References: <20210719144940.288257948@linuxfoundation.org>
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
index f8df8248035e..31e02ca56572 100644
--- a/drivers/net/ethernet/aeroflex/greth.c
+++ b/drivers/net/ethernet/aeroflex/greth.c
@@ -1554,10 +1554,11 @@ static int greth_of_remove(struct platform_device *of_dev)
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



