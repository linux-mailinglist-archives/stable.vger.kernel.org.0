Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E77CF3D2A2C
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:07:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234249AbhGVQJ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 12:09:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:43382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233961AbhGVQHM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 12:07:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 332DB61CA2;
        Thu, 22 Jul 2021 16:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626972467;
        bh=Mj/Kloo4/kXkitqGONCHW5JdQ06LzJzJEFnfF7+8FV0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iPGmoJVJQSV0mUYXE+Tzk6AQIRWtFvcNmmVSnFkhaHqc5o1HOezbYqMDgyf/4t7W8
         6HbK2raubOfwryWPw1ZCjRYp6WhH8fHVY4k875rHnitVT5/dHIimFTexpmJvMQRhbI
         jB8QIWRmarK6VS+vPF6QPuJ5qaQgyPlDLr4AbyQs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.13 126/156] net: moxa: fix UAF in moxart_mac_probe
Date:   Thu, 22 Jul 2021 18:31:41 +0200
Message-Id: <20210722155632.436280693@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155628.371356843@linuxfoundation.org>
References: <20210722155628.371356843@linuxfoundation.org>
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
@@ -540,10 +540,8 @@ static int moxart_mac_probe(struct platf
 	SET_NETDEV_DEV(ndev, &pdev->dev);
 
 	ret = register_netdev(ndev);
-	if (ret) {
-		free_netdev(ndev);
+	if (ret)
 		goto init_fail;
-	}
 
 	netdev_dbg(ndev, "%s: IRQ=%d address=%pM\n",
 		   __func__, ndev->irq, ndev->dev_addr);


