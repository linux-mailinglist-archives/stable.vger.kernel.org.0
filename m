Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F04D3D2917
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:05:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233917AbhGVQBA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 12:01:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:35506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233506AbhGVP7M (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 11:59:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8F82E61358;
        Thu, 22 Jul 2021 16:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626971986;
        bh=8ScPzJtdqD0V4/1kgDz5+HEl++3OkPdkRNYZRR90o/U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HEzLvURUvIY8AwwVlk6xJpWBHk6WDC8rsjnP/7VEQ0d+AwtOgBu5V818oOZ1YLr4D
         ZoxDLBmCyhio5P6ui6DTHYmEz6bnXCisV6Qxomc6Tk/OuMYAuIrB6WsUAZ7AaobYt8
         t9MFleLbNrYL3v9hOMDF2swuuIfvy8i9d6Twkhg4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 103/125] net: moxa: fix UAF in moxart_mac_probe
Date:   Thu, 22 Jul 2021 18:31:34 +0200
Message-Id: <20210722155628.119266393@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155624.672583740@linuxfoundation.org>
References: <20210722155624.672583740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Skripkin <paskripkin@gmail.com>

commit c78eaeebe855fd93f2e77142ffd0404a54070d84 upstream.

In case of netdev registration failure the code path will
jump to init_fail label:

init_fail:
	netdev_err(ndev, "init failed\n");
	moxart_mac_free_memory(ndev);
irq_map_fail:
	free_netdev(ndev);
	return ret;

So, there is no need to call free_netdev() before jumping
to error handling path, since it can cause UAF or double-free
bug.

Fixes: 6c821bd9edc9 ("net: Add MOXA ART SoCs ethernet driver")
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/moxa/moxart_ether.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/net/ethernet/moxa/moxart_ether.c
+++ b/drivers/net/ethernet/moxa/moxart_ether.c
@@ -541,10 +541,8 @@ static int moxart_mac_probe(struct platf
 	SET_NETDEV_DEV(ndev, &pdev->dev);
 
 	ret = register_netdev(ndev);
-	if (ret) {
-		free_netdev(ndev);
+	if (ret)
 		goto init_fail;
-	}
 
 	netdev_dbg(ndev, "%s: IRQ=%d address=%pM\n",
 		   __func__, ndev->irq, ndev->dev_addr);


