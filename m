Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2B8F3CD7B1
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 16:59:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241986AbhGSOS1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:18:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:53044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242011AbhGSOSI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:18:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 902A361165;
        Mon, 19 Jul 2021 14:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626706728;
        bh=DZalicG3Ef/s00rI40cRfPHZVROuINZ5gPUr7Dt17H8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fJVz14DDQ/HiXOGzNsFWJ2X7Kr9g0Wd+khrFF+fIWNsI2RljiP0r3Z1lW5FQ3a2Z7
         B12DwbYQ7pifnBdikPfgp9y8Q6W91ABZxep80oUdg2dGFhUJ7qPqm/1dNNmUXo4PZm
         ijj92Rk4H8pv3HeteqqV1XUSu9KuaSgdlCYqbIwM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 071/188] net: ethernet: ezchip: fix UAF in nps_enet_remove
Date:   Mon, 19 Jul 2021 16:50:55 +0200
Message-Id: <20210719144929.563637232@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144913.076563739@linuxfoundation.org>
References: <20210719144913.076563739@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Skripkin <paskripkin@gmail.com>

[ Upstream commit e4b8700e07a86e8eab6916aa5c5ba99042c34089 ]

priv is netdev private data, but it is used
after free_netdev(). It can cause use-after-free when accessing priv
pointer. So, fix it by moving free_netdev() after netif_napi_del()
call.

Fixes: 0dd077093636 ("NET: Add ezchip ethernet driver")
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ezchip/nps_enet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ezchip/nps_enet.c b/drivers/net/ethernet/ezchip/nps_enet.c
index b1026689b78f..73d2bc349b2f 100644
--- a/drivers/net/ethernet/ezchip/nps_enet.c
+++ b/drivers/net/ethernet/ezchip/nps_enet.c
@@ -621,8 +621,8 @@ static s32 nps_enet_remove(struct platform_device *pdev)
 	struct nps_enet_priv *priv = netdev_priv(ndev);
 
 	unregister_netdev(ndev);
-	free_netdev(ndev);
 	netif_napi_del(&priv->napi);
+	free_netdev(ndev);
 
 	return 0;
 }
-- 
2.30.2



