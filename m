Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82CD23C5379
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:51:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352458AbhGLHyv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:54:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:35480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350398AbhGLHu7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:50:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B5C62617ED;
        Mon, 12 Jul 2021 07:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075904;
        bh=AE7jIRAG/tse4Br2mzz5ghbxOdMVAeBxJs/3J4GaXMk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2RcRtZUf+yz+GO90AOQI5pribUdCQJ3Bjr+lqUiHdRqk3hB924gYmV6XSizAkWRBm
         5xXlBKFz1+8fLe3BxKXFuS43Sh4TZMQFK7TsYMuWbDSF6nPU3jkofoeKWCBKogonGQ
         B9Hw2h53VCzB413acauW22KWFo9oPVMDEkvEheAY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 413/800] net: ftgmac100: add missing error return code in ftgmac100_probe()
Date:   Mon, 12 Jul 2021 08:07:16 +0200
Message-Id: <20210712061011.114832071@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
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
index 04421aec2dfd..11dbbfd38770 100644
--- a/drivers/net/ethernet/faraday/ftgmac100.c
+++ b/drivers/net/ethernet/faraday/ftgmac100.c
@@ -1830,14 +1830,17 @@ static int ftgmac100_probe(struct platform_device *pdev)
 	if (np && of_get_property(np, "use-ncsi", NULL)) {
 		if (!IS_ENABLED(CONFIG_NET_NCSI)) {
 			dev_err(&pdev->dev, "NCSI stack not enabled\n");
+			err = -EINVAL;
 			goto err_phy_connect;
 		}
 
 		dev_info(&pdev->dev, "Using NCSI interface\n");
 		priv->use_ncsi = true;
 		priv->ndev = ncsi_register_dev(netdev, ftgmac100_ncsi_handler);
-		if (!priv->ndev)
+		if (!priv->ndev) {
+			err = -EINVAL;
 			goto err_phy_connect;
+		}
 	} else if (np && of_get_property(np, "phy-handle", NULL)) {
 		struct phy_device *phy;
 
@@ -1856,6 +1859,7 @@ static int ftgmac100_probe(struct platform_device *pdev)
 					     &ftgmac100_adjust_link);
 		if (!phy) {
 			dev_err(&pdev->dev, "Failed to connect to phy\n");
+			err = -EINVAL;
 			goto err_phy_connect;
 		}
 
-- 
2.30.2



