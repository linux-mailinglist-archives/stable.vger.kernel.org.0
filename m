Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 715872475A8
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:27:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732101AbgHQT0Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:26:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:37400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730390AbgHQPdy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:33:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 320FA207DA;
        Mon, 17 Aug 2020 15:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678433;
        bh=4b12TBHVSCwCKRb00ECpu9pazPTpNjuO50tR6Ppigl8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h18ahY0wxh0f9/PelFCuCJGc6oT+xzHDNBeGocU9x4puKJJe0u8sA2jxp8P2VQaA8
         EEu/YRiWntO1rJ+j6QU1K+D0y3JCnBOUJTwLan9JJkMMc7Wi3XBUvdpUK0zilMrTHk
         1DJB4vZLKUp3JLS+hGAJ0YHjyvd24RKmsYWbywyI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wang Hai <wanghai38@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 333/464] net: ll_temac: Use devm_platform_ioremap_resource_byname()
Date:   Mon, 17 Aug 2020 17:14:46 +0200
Message-Id: <20200817143849.738305910@linuxfoundation.org>
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

From: Wang Hai <wanghai38@huawei.com>

[ Upstream commit bd69058f50d5ffa659423bcfa6fe6280ce9c760a ]

platform_get_resource() may fail and return NULL, so we had better
check its return value to avoid a NULL pointer dereference a bit later
in the code. Fix it to use devm_platform_ioremap_resource_byname()
instead of calling platform_get_resource_byname() and devm_ioremap().

Fixes: 8425c41d1ef7 ("net: ll_temac: Extend support to non-device-tree platforms")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/xilinx/ll_temac_main.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index 929244064abd9..9a15f14daa479 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -1407,10 +1407,8 @@ static int temac_probe(struct platform_device *pdev)
 	}
 
 	/* map device registers */
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	lp->regs = devm_ioremap(&pdev->dev, res->start,
-					resource_size(res));
-	if (!lp->regs) {
+	lp->regs = devm_platform_ioremap_resource_byname(pdev, 0);
+	if (IS_ERR(lp->regs)) {
 		dev_err(&pdev->dev, "could not map TEMAC registers\n");
 		return -ENOMEM;
 	}
-- 
2.25.1



