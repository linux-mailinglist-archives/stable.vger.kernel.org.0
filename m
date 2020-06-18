Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2E2E1FDB84
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 03:13:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728913AbgFRBMb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:12:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:40982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728908AbgFRBM1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:12:27 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F38D620CC7;
        Thu, 18 Jun 2020 01:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442746;
        bh=2UkhSz4l9Xn7rW27ttSB2IEZ/oo6QJvPwkQ59xLynXE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jLAxU0guepCj0slMkEnKlmQmk7TsffJbrKeLdjJSHU/J81s54yP6gC1TZo9VAvZr0
         HtyRa72ETfnPB2D3v9N6GMZc8iFi+DtuB2OyL0g5WZBSvYLSo+56iNoLPZsGNCCQ0W
         vQnlQA61VIDkTquFfT9z7pN/ZhkGPCD3/W2qeCbQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wei Yongjun <weiyongjun1@huawei.com>,
        Hulk Robot <hulkci@huawei.com>, Roger Quadros <rogerq@ti.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.7 199/388] phy: ti: j721e-wiz: Fix some error return code in wiz_probe()
Date:   Wed, 17 Jun 2020 21:04:56 -0400
Message-Id: <20200618010805.600873-199-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit e2ae8bca494481a9f38fcd1d52943ac04e654745 ]

Fix to return negative error code from some error handling
cases instead of 0, as done elsewhere in this function.

Fixes: 091876cc355d ("phy: ti: j721e-wiz: Add support for WIZ module present in TI J721E SoC")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Acked-by: Roger Quadros <rogerq@ti.com>
Link: https://lore.kernel.org/r/20200507054109.110849-1-weiyongjun1@huawei.com
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/ti/phy-j721e-wiz.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/phy/ti/phy-j721e-wiz.c b/drivers/phy/ti/phy-j721e-wiz.c
index 7b51045df783..c8e4ff341cef 100644
--- a/drivers/phy/ti/phy-j721e-wiz.c
+++ b/drivers/phy/ti/phy-j721e-wiz.c
@@ -794,8 +794,10 @@ static int wiz_probe(struct platform_device *pdev)
 	}
 
 	base = devm_ioremap(dev, res.start, resource_size(&res));
-	if (!base)
+	if (!base) {
+		ret = -ENOMEM;
 		goto err_addr_to_resource;
+	}
 
 	regmap = devm_regmap_init_mmio(dev, base, &wiz_regmap_config);
 	if (IS_ERR(regmap)) {
@@ -812,6 +814,7 @@ static int wiz_probe(struct platform_device *pdev)
 
 	if (num_lanes > WIZ_MAX_LANES) {
 		dev_err(dev, "Cannot support %d lanes\n", num_lanes);
+		ret = -ENODEV;
 		goto err_addr_to_resource;
 	}
 
@@ -897,6 +900,7 @@ static int wiz_probe(struct platform_device *pdev)
 	serdes_pdev = of_platform_device_create(child_node, NULL, dev);
 	if (!serdes_pdev) {
 		dev_WARN(dev, "Unable to create SERDES platform device\n");
+		ret = -ENOMEM;
 		goto err_pdev_create;
 	}
 	wiz->serdes_pdev = serdes_pdev;
-- 
2.25.1

