Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5823422F00C
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:21:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730043AbgG0OVa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:21:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:50062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730258AbgG0OV2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:21:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A34D2070B;
        Mon, 27 Jul 2020 14:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859688;
        bh=DafwVra6R15YiKS3P4lQV5RXKI9bC2rto+ReRK0TKTw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ww5dUR8PsFuibZATpuAoG/pTJ9Ys5dS0KwZz6CoXrIJO37x9MtnWuVAddHs6M26z8
         1annWHdwTqdapmksBF7+d+WCQVVaFCVh7WLvjyKMLX5QBIINcGbjP7xXzMMbZZ3jXY
         r/vG2CoCV3JVo/d9fRh8fwVo0DUWVtAmL1qiEhQk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Zhang Changzhong <zhangchangzhong@huawei.com>,
        Doug Berger <opendmb@gmail.com>,
        Florian fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 067/179] net: bcmgenet: fix error returns in bcmgenet_probe()
Date:   Mon, 27 Jul 2020 16:04:02 +0200
Message-Id: <20200727134935.932943126@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134932.659499757@linuxfoundation.org>
References: <20200727134932.659499757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Changzhong <zhangchangzhong@huawei.com>

[ Upstream commit 24a63fe6d45d6527db5ab87bcd1da6921f10e89e ]

The driver forgets to call clk_disable_unprepare() in error path after
a success calling for clk_prepare_enable().

Fix to goto err_clk_disable if clk_prepare_enable() is successful.

Fixes: 99d55638d4b0 ("net: bcmgenet: enable NETIF_F_HIGHDMA flag")
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
Acked-by: Doug Berger <opendmb@gmail.com>
Acked-by: Florian fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index dde1c23c8e399..7b95bb77ad3bb 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -3522,7 +3522,7 @@ static int bcmgenet_probe(struct platform_device *pdev)
 	if (err)
 		err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
 	if (err)
-		goto err;
+		goto err_clk_disable;
 
 	/* Mii wait queue */
 	init_waitqueue_head(&priv->wq);
-- 
2.25.1



