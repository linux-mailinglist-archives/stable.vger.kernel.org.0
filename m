Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37DA24522CF
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:14:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378642AbhKPBQV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:16:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:42970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244470AbhKOTPE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:15:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C0CB634C0;
        Mon, 15 Nov 2021 18:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000481;
        bh=ji5dLCwblGr5Eu07zARlCaYRqrv2zsmztEiA+7MAGRg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JvSL7NqywwLmHybh2BPwzGS62pg0h140mimI7Fzh30qmqzi9oVE22lVfyYNAL2qgM
         Qf+gzWiTzZEoRceuZ5JKP8MCGbg6PPkf6+8YvJtxg4zpRJ/UWCJmJxWS5YAVG2elSy
         7xRO9H2YjLkKYCRBln869D1z0UV0nUK/Bv6H8W9g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 642/849] phy: Sparx5 Eth SerDes: Fix return value check in sparx5_serdes_probe()
Date:   Mon, 15 Nov 2021 18:02:05 +0100
Message-Id: <20211115165441.998742417@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
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



