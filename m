Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FD8337C8A9
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:43:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236432AbhELQLY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:11:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:34478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238712AbhELQGG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:06:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 54FE961988;
        Wed, 12 May 2021 15:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833702;
        bh=0fRZmrlUU1TCg4DBECMXmd+4nHJbX57y2DCZD1FMSyg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WbaF+BD6YD9s/a3mPtysWHaDfzoeg2lfP8MsjchEmWdGpB4EOzzs8C6wo3+hZMorM
         YEyaGq7t5aukPePJTn6QtcqU0Fp5y1JMkvFAyKr6XY9ubsWpuSr5c50hnQ8ij/fScm
         v9b97+fenJ0iqkM7TJGZDTcUGr2FW0XqngaaK7II=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Paul Cercueil <paul@crapouillou.net>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 219/601] phy: ingenic: Fix a typo in ingenic_usb_phy_probe()
Date:   Wed, 12 May 2021 16:44:56 +0200
Message-Id: <20210512144835.053477971@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit 446c200ee3e8f6faf189ef6f25a0f5bb294afae4 ]

Fix the return value check typo which testing the wrong variable
in ingenic_usb_phy_probe().

Fixes: 31de313dfdcf ("PHY: Ingenic: Add USB PHY driver using generic PHY framework.")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Acked-by: Paul Cercueil <paul@crapouillou.net>
Link: https://lore.kernel.org/r/20210305034933.3240914-1-weiyongjun1@huawei.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/ingenic/phy-ingenic-usb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/phy/ingenic/phy-ingenic-usb.c b/drivers/phy/ingenic/phy-ingenic-usb.c
index 4d1587d82286..878cd4cbb91a 100644
--- a/drivers/phy/ingenic/phy-ingenic-usb.c
+++ b/drivers/phy/ingenic/phy-ingenic-usb.c
@@ -375,8 +375,8 @@ static int ingenic_usb_phy_probe(struct platform_device *pdev)
 	}
 
 	priv->phy = devm_phy_create(dev, NULL, &ingenic_usb_phy_ops);
-	if (IS_ERR(priv))
-		return PTR_ERR(priv);
+	if (IS_ERR(priv->phy))
+		return PTR_ERR(priv->phy);
 
 	phy_set_drvdata(priv->phy, priv);
 
-- 
2.30.2



