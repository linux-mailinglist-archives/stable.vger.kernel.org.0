Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 067363C456F
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 08:23:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235452AbhGLGZY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:25:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:39102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235261AbhGLGYi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:24:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C142D6113C;
        Mon, 12 Jul 2021 06:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626070908;
        bh=0OGOPHnm1JGsTNmevIKpd2GMPvY1mtN+xsHLLGOJhtg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rplnor7KZzxm9gIN6JERCXYp3hNMB5QwUJbzrOItYICi6sKa8zvtF++NvvYKjB+H6
         N+L5dLtNZfNv+CRdg5Ahu+JMhIKFo1SLKliw746CvM6FKPWXgzodR64tS9ahBzZtdr
         n7hIF1y6ShN6RaRJ30A6WYYMNhgRcwl/d+vk5Qlc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 191/348] net: ftgmac100: add missing error return code in ftgmac100_probe()
Date:   Mon, 12 Jul 2021 08:09:35 +0200
Message-Id: <20210712060726.398649426@linuxfoundation.org>
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

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 52af13a41489d7bbc1932d17583eff6e5fffc820 ]

The variables will be free on path err_phy_connect, it should
return error code, or it will cause double free when calling
ftgmac100_remove().

Fixes: bd466c3fb5a4 ("net/faraday: Support NCSI mode")
Fixes: 39bfab8844a0 ("net: ftgmac100: Add support for DT phy-handle property")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/faraday/ftgmac100.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/faraday/ftgmac100.c b/drivers/net/ethernet/faraday/ftgmac100.c
index 4050f81f788c..2c06cdcd3e75 100644
--- a/drivers/net/ethernet/faraday/ftgmac100.c
+++ b/drivers/net/ethernet/faraday/ftgmac100.c
@@ -1821,14 +1821,17 @@ static int ftgmac100_probe(struct platform_device *pdev)
 	if (np && of_get_property(np, "use-ncsi", NULL)) {
 		if (!IS_ENABLED(CONFIG_NET_NCSI)) {
 			dev_err(&pdev->dev, "NCSI stack not enabled\n");
+			err = -EINVAL;
 			goto err_ncsi_dev;
 		}
 
 		dev_info(&pdev->dev, "Using NCSI interface\n");
 		priv->use_ncsi = true;
 		priv->ndev = ncsi_register_dev(netdev, ftgmac100_ncsi_handler);
-		if (!priv->ndev)
+		if (!priv->ndev) {
+			err = -EINVAL;
 			goto err_ncsi_dev;
+		}
 	} else if (np && of_get_property(np, "phy-handle", NULL)) {
 		struct phy_device *phy;
 
@@ -1836,6 +1839,7 @@ static int ftgmac100_probe(struct platform_device *pdev)
 					     &ftgmac100_adjust_link);
 		if (!phy) {
 			dev_err(&pdev->dev, "Failed to connect to phy\n");
+			err = -EINVAL;
 			goto err_setup_mdio;
 		}
 
-- 
2.30.2



