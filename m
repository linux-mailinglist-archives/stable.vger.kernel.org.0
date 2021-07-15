Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93BEA3CA88F
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:00:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243218AbhGOTBe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:01:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:38160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242135AbhGOTAl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:00:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6972E613D0;
        Thu, 15 Jul 2021 18:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375458;
        bh=oaC2icxJ1FzLUjUeegnixedcm9xmDZEyvww90mFno2k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jwcp0s6vw4oZarxvsU0KV9xCGLJyFYr2yRYyl/tgy0u1lih5e1XMYqo6JdUfj+xd8
         jMNY+lAsmvC4BUJ6baIJKDZ9BKGCLZsOZ8OlrQjq0Vh5USYlQKCS4xadOs197wXmdz
         aZBXL58gcUflOUl+DaBW33X10aWOEpeuCAORNBR4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Yingliang <yangyingliang@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 069/242] net: moxa: Use devm_platform_get_and_ioremap_resource()
Date:   Thu, 15 Jul 2021 20:37:11 +0200
Message-Id: <20210715182604.693120995@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182551.731989182@linuxfoundation.org>
References: <20210715182551.731989182@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 35cba15a504bf4f585bb9d78f47b22b28a1a06b2 ]

Use devm_platform_get_and_ioremap_resource() to simplify
code and avoid a null-ptr-deref by checking 'res' in it.

Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/moxa/moxart_ether.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/moxa/moxart_ether.c b/drivers/net/ethernet/moxa/moxart_ether.c
index 49fd843c4c8a..a4380c45f668 100644
--- a/drivers/net/ethernet/moxa/moxart_ether.c
+++ b/drivers/net/ethernet/moxa/moxart_ether.c
@@ -481,14 +481,13 @@ static int moxart_mac_probe(struct platform_device *pdev)
 	priv->ndev = ndev;
 	priv->pdev = pdev;
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	ndev->base_addr = res->start;
-	priv->base = devm_ioremap_resource(p_dev, res);
+	priv->base = devm_platform_get_and_ioremap_resource(pdev, 0, &res);
 	if (IS_ERR(priv->base)) {
 		dev_err(p_dev, "devm_ioremap_resource failed\n");
 		ret = PTR_ERR(priv->base);
 		goto init_fail;
 	}
+	ndev->base_addr = res->start;
 
 	spin_lock_init(&priv->txlock);
 
-- 
2.30.2



