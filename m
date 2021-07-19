Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C9823CD964
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:09:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243658AbhGSO3A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:29:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:39348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242775AbhGSO1M (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:27:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 97A2A61241;
        Mon, 19 Jul 2021 15:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626707249;
        bh=nPqDtAEpokEUH1MZYzEBofl/ycrJlSrA4FUvobEDXbc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QXhLbsGwzkGr+EVDKrFldKUGSEf1SjficrzYYH1B2s3sJmj+kXE1GN168TszlLnUy
         DvKZMeaw9Lxyy21s1afRCprbe7wTRa+q+sMzKWT+7JnkHexvTOAvzP+7eFIS6ft4zH
         6MlfNX9p03uNaQB+pvr3c4TQzdwfHbV4E9sC8DyI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 085/245] net: ethernet: ezchip: fix UAF in nps_enet_remove
Date:   Mon, 19 Jul 2021 16:50:27 +0200
Message-Id: <20210719144943.150784116@linuxfoundation.org>
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
index 223f35cc034c..1edf1c76c22c 100644
--- a/drivers/net/ethernet/ezchip/nps_enet.c
+++ b/drivers/net/ethernet/ezchip/nps_enet.c
@@ -659,8 +659,8 @@ static s32 nps_enet_remove(struct platform_device *pdev)
 	struct nps_enet_priv *priv = netdev_priv(ndev);
 
 	unregister_netdev(ndev);
-	free_netdev(ndev);
 	netif_napi_del(&priv->napi);
+	free_netdev(ndev);
 
 	return 0;
 }
-- 
2.30.2



