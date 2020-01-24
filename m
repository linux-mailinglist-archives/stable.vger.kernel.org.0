Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E019148952
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 15:34:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728831AbgAXOeK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 09:34:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:40408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392120AbgAXOTu (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 09:19:50 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C70B208C4;
        Fri, 24 Jan 2020 14:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579875589;
        bh=xsufd/3xikqPueUSEBJ072fdiuQ2sXUKcf5CwU+7fu0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lFqpKdt5Ua8AiRayuEzupqIbwoyb7C991o0XwgVyvgqImkIlaiPdvpWaoPLrZKrO9
         gfIbbRPTQC9hDSDaV1euoNZqwQHMdQtjFPp99iVf44DMnWDz51uFHk4t1IoI4RF9Qx
         29vUcvIxczz5MKVs7HhWBDOZNuC90PTYDKLfFAQQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzk@kernel.org>,
        kbuild test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Sasha Levin <sashal@kernel.org>, linux-i2c@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 079/107] i2c: iop3xx: Fix memory leak in probe error path
Date:   Fri, 24 Jan 2020 09:17:49 -0500
Message-Id: <20200124141817.28793-79-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200124141817.28793-1-sashal@kernel.org>
References: <20200124141817.28793-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzk@kernel.org>

[ Upstream commit e64175776d06a8ceebbfd349d7e66a4a46ca39ef ]

When handling devm_gpiod_get_optional() errors, free the memory already
allocated.  This fixes Smatch warnings:

    drivers/i2c/busses/i2c-iop3xx.c:437 iop3xx_i2c_probe() warn: possible memory leak of 'new_adapter'
    drivers/i2c/busses/i2c-iop3xx.c:442 iop3xx_i2c_probe() warn: possible memory leak of 'new_adapter'

Fixes: fdb7e884ad61 ("i2c: iop: Use GPIO descriptors")
Reported-by: kbuild test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-iop3xx.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/i2c/busses/i2c-iop3xx.c b/drivers/i2c/busses/i2c-iop3xx.c
index 38556381f4cad..2f8b8050a2233 100644
--- a/drivers/i2c/busses/i2c-iop3xx.c
+++ b/drivers/i2c/busses/i2c-iop3xx.c
@@ -433,13 +433,17 @@ iop3xx_i2c_probe(struct platform_device *pdev)
 	adapter_data->gpio_scl = devm_gpiod_get_optional(&pdev->dev,
 							 "scl",
 							 GPIOD_ASIS);
-	if (IS_ERR(adapter_data->gpio_scl))
-		return PTR_ERR(adapter_data->gpio_scl);
+	if (IS_ERR(adapter_data->gpio_scl)) {
+		ret = PTR_ERR(adapter_data->gpio_scl);
+		goto free_both;
+	}
 	adapter_data->gpio_sda = devm_gpiod_get_optional(&pdev->dev,
 							 "sda",
 							 GPIOD_ASIS);
-	if (IS_ERR(adapter_data->gpio_sda))
-		return PTR_ERR(adapter_data->gpio_sda);
+	if (IS_ERR(adapter_data->gpio_sda)) {
+		ret = PTR_ERR(adapter_data->gpio_sda);
+		goto free_both;
+	}
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res) {
-- 
2.20.1

