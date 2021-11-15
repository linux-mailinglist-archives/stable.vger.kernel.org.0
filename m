Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C3B7451F01
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:36:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348269AbhKPAiM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:38:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:45204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344567AbhKOTZA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 443A463260;
        Mon, 15 Nov 2021 19:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002801;
        bh=ji5dLCwblGr5Eu07zARlCaYRqrv2zsmztEiA+7MAGRg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VyGnjTW37sh/LahPDxPuW/6zYC1Ui+IbGiE4ab3e3EWmzhmDBwcGH2ym5WLbPJzuU
         RQDDzLDnFZx2ajQrEn7vBvw5PXuppVNsbPr7nw2/0FEOJM7cUHsR0vIfvu1TkhPfUg
         D7bJRapxuSVRDqvliZd/+dgy1BG6UeCEBEq9toXY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 669/917] phy: Sparx5 Eth SerDes: Fix return value check in sparx5_serdes_probe()
Date:   Mon, 15 Nov 2021 18:02:44 +0100
Message-Id: <20211115165451.576909425@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit b4dc97ab0a629eda8bda20d96ef47dac08a505d9 ]

In case of error, the function devm_ioremap() returns NULL
pointer not ERR_PTR(). The IS_ERR() test in the return value
check should be replaced with NULL test.

Fixes: 2ff8a1eeb5aa ("phy: Add Sparx5 ethernet serdes PHY driver")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20210909072149.2934047-1-yangyingliang@huawei.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/microchip/sparx5_serdes.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/phy/microchip/sparx5_serdes.c b/drivers/phy/microchip/sparx5_serdes.c
index 4076580fc2cd9..ab1b0986aa671 100644
--- a/drivers/phy/microchip/sparx5_serdes.c
+++ b/drivers/phy/microchip/sparx5_serdes.c
@@ -2475,10 +2475,10 @@ static int sparx5_serdes_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 	iomem = devm_ioremap(priv->dev, iores->start, resource_size(iores));
-	if (IS_ERR(iomem)) {
+	if (!iomem) {
 		dev_err(priv->dev, "Unable to get serdes registers: %s\n",
 			iores->name);
-		return PTR_ERR(iomem);
+		return -ENOMEM;
 	}
 	for (idx = 0; idx < ARRAY_SIZE(sparx5_serdes_iomap); idx++) {
 		struct sparx5_serdes_io_resource *iomap = &sparx5_serdes_iomap[idx];
-- 
2.33.0



