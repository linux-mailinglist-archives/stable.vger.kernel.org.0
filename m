Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69E913C467F
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:25:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235318AbhGLG0b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:26:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:47330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233517AbhGLGZm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:25:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2913561106;
        Mon, 12 Jul 2021 06:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626070966;
        bh=L+BA82XUhqQv2PJnE1acFbYimkXnO4bUdVOMrVrR2T4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=px5YUCQabAKrtHwoF5zp+FkB8pZXUWRsPt1iMVVgsTcDXfM3DTkgW4ewzz4Uk+TV+
         CpiU4hwv5sZ0U7D5cgGPu+eucnAo+G1xRGxgVmMnAEdg/hnga/o/vc6p0ejPLbtq0I
         aUlEgACSyh75T3MiawHvb49HtC2rYXj5oNKxpPMw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 218/348] net: ethernet: ezchip: fix UAF in nps_enet_remove
Date:   Mon, 12 Jul 2021 08:10:02 +0200
Message-Id: <20210712060730.490942478@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060659.886176320@linuxfoundation.org>
References: <20210712060659.886176320@linuxfoundation.org>
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
index 815fb62c4b02..026a3ec19b6e 100644
--- a/drivers/net/ethernet/ezchip/nps_enet.c
+++ b/drivers/net/ethernet/ezchip/nps_enet.c
@@ -645,8 +645,8 @@ static s32 nps_enet_remove(struct platform_device *pdev)
 	struct nps_enet_priv *priv = netdev_priv(ndev);
 
 	unregister_netdev(ndev);
-	free_netdev(ndev);
 	netif_napi_del(&priv->napi);
+	free_netdev(ndev);
 
 	return 0;
 }
-- 
2.30.2



