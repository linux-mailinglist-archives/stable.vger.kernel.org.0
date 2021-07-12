Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F182C3C499A
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:33:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236648AbhGLGpe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:45:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:37274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238815AbhGLGoW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:44:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EEEC261132;
        Mon, 12 Jul 2021 06:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072004;
        bh=+kGmNLDdskpxJHfwq3Oa1nxJA4fwz0ikHH+EWPUnhH0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nIMC4BVLqkDJHRJKa7kXATE4CjEj7WxZzoJOXSfsQqRdfPGhRDroi5dVMRyu+XDSC
         +0Ig9MymOGsq4pzQYIv0wyeNcDtbx/nhiaRrZPAFWPQWmKSI0P5K5aqTmqPVkMYW44
         Yn2CrN96mcHuUiEoInqLjK0h4GPsYSqfvLXu9cA0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 313/593] net: ftgmac100: add missing error return code in ftgmac100_probe()
Date:   Mon, 12 Jul 2021 08:07:53 +0200
Message-Id: <20210712060919.764635006@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
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
index c9c380c50879..5bc11d1bb9df 100644
--- a/drivers/net/ethernet/faraday/ftgmac100.c
+++ b/drivers/net/ethernet/faraday/ftgmac100.c
@@ -1831,14 +1831,17 @@ static int ftgmac100_probe(struct platform_device *pdev)
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
 
@@ -1846,6 +1849,7 @@ static int ftgmac100_probe(struct platform_device *pdev)
 					     &ftgmac100_adjust_link);
 		if (!phy) {
 			dev_err(&pdev->dev, "Failed to connect to phy\n");
+			err = -EINVAL;
 			goto err_setup_mdio;
 		}
 
-- 
2.30.2



