Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9300124F94A
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 11:43:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728692AbgHXJnz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 05:43:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:38570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729076AbgHXInq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:43:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 15EBC2074D;
        Mon, 24 Aug 2020 08:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598258625;
        bh=TMMB5eBADth6RpEHYshCIv0cC+3m/MrHY2nIaZf+iOg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JjaVvIqrz3TVbqKa7XEMbXwzrbM3F9Ij6//e9jpFu2RD/FDEkaZAbz1VEDKzoee2s
         TK5MbDSEjORzHUq9oCFqyo6e9jHYSdIRe/qtdxsIp/q6BYFsMju3i42eaq/IUjFL1R
         y4s/2LAxU9zJct8ogU+szR60Qr7OZ4ZnPiH2XBKc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wang Hai <wanghai38@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 113/124] net: gemini: Fix missing free_netdev() in error path of gemini_ethernet_port_probe()
Date:   Mon, 24 Aug 2020 10:30:47 +0200
Message-Id: <20200824082414.963718313@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082409.368269240@linuxfoundation.org>
References: <20200824082409.368269240@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang Hai <wanghai38@huawei.com>

[ Upstream commit cf96d977381d4a23957bade2ddf1c420b74a26b6 ]

Replace alloc_etherdev_mq with devm_alloc_etherdev_mqs. In this way,
when probe fails, netdev can be freed automatically.

Fixes: 4d5ae32f5e1e ("net: ethernet: Add a driver for Gemini gigabit ethernet")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cortina/gemini.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/cortina/gemini.c b/drivers/net/ethernet/cortina/gemini.c
index 5359fb40578db..e641890e9702f 100644
--- a/drivers/net/ethernet/cortina/gemini.c
+++ b/drivers/net/ethernet/cortina/gemini.c
@@ -2388,7 +2388,7 @@ static int gemini_ethernet_port_probe(struct platform_device *pdev)
 
 	dev_info(dev, "probe %s ID %d\n", dev_name(dev), id);
 
-	netdev = alloc_etherdev_mq(sizeof(*port), TX_QUEUE_NUM);
+	netdev = devm_alloc_etherdev_mqs(dev, sizeof(*port), TX_QUEUE_NUM, TX_QUEUE_NUM);
 	if (!netdev) {
 		dev_err(dev, "Can't allocate ethernet device #%d\n", id);
 		return -ENOMEM;
@@ -2520,7 +2520,6 @@ static int gemini_ethernet_port_probe(struct platform_device *pdev)
 	}
 
 	port->netdev = NULL;
-	free_netdev(netdev);
 	return ret;
 }
 
@@ -2529,7 +2528,6 @@ static int gemini_ethernet_port_remove(struct platform_device *pdev)
 	struct gemini_ethernet_port *port = platform_get_drvdata(pdev);
 
 	gemini_port_remove(port);
-	free_netdev(port->netdev);
 	return 0;
 }
 
-- 
2.25.1



