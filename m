Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5544A3CDD38
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:38:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238476AbhGSO4q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:56:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:52466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238412AbhGSOzn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:55:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 54D196128D;
        Mon, 19 Jul 2021 15:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626708821;
        bh=41LjCZkoFw8j9KodFlAdJLBRM03BI3Og3dUoeeKipZA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MOh+iAdic4n+vMwJeCmqY04T8CGW0UOGIA5u+wDcBPz8DWq4CN94GVSgZHV7n53LZ
         UYQUYwe93I9hMZnwD9tKZJ/k3jmf/yc6optmcTognogHhQT7ecH4fyLd2zhrxAPxXx
         xPqIYTk2U+ZmlzB1WVVejNEnDu3ZL84yqHsu8+pQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 142/421] net: ethernet: aeroflex: fix UAF in greth_of_remove
Date:   Mon, 19 Jul 2021 16:49:13 +0200
Message-Id: <20210719144951.417130443@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
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
index 4309be3724ad..a20e95b39cf7 100644
--- a/drivers/net/ethernet/aeroflex/greth.c
+++ b/drivers/net/ethernet/aeroflex/greth.c
@@ -1546,10 +1546,11 @@ static int greth_of_remove(struct platform_device *of_dev)
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



