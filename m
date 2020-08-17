Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96520247542
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:21:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387605AbgHQTVN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:21:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:42868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730499AbgHQPg0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:36:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E584620789;
        Mon, 17 Aug 2020 15:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678586;
        bh=2boSfK9bHD5PLFVLB3Ss/OblrzeBZ8rKAEyrZ1ImRb0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Elyeb9gD3DhPGD7oDdQeV3RptEOpwuw/c+tgJGTKc15nB8yQxgyg6IGHQkFAQiEZL
         AWO0RsTTCBAZwIQyNT2W+9scvoCkJ8lGtyBjmucq0JbVW/5l+MEYr2rMl83bigOp+k
         TmOy06DbWlewc2pZWr/xEt+dR9fzXvNNMDsMKc/8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Matteo Croce <mcroce@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 355/464] net: mvpp2: fix memory leak in mvpp2_rx
Date:   Mon, 17 Aug 2020 17:15:08 +0200
Message-Id: <20200817143850.771658088@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit d6526926de7397a97308780911565e31a6b67b59 ]

Release skb memory in mvpp2_rx() if mvpp2_rx_refill routine fails

Fixes: b5015854674b ("net: mvpp2: fix refilling BM pools in RX path")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Acked-by: Matteo Croce <mcroce@microsoft.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 24f4d8e0da989..ee72397813d41 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -2981,6 +2981,7 @@ static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
 		err = mvpp2_rx_refill(port, bm_pool, pool);
 		if (err) {
 			netdev_err(port->dev, "failed to refill BM pools\n");
+			dev_kfree_skb_any(skb);
 			goto err_drop_frame;
 		}
 
-- 
2.25.1



