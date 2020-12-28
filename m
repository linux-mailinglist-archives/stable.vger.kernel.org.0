Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFEF12E3D70
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:16:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439162AbgL1OPh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:15:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:50570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2440700AbgL1OPg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:15:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2BEB3205CB;
        Mon, 28 Dec 2020 14:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164895;
        bh=sWakMOXdwCC/ypmEv8UgTB3TrosXYNhtfgw1bY55Dms=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u3RANovK0sRnnJEAtYz7sLQ0NJH5bioyzrR7bgjzDNw4K1E2c3CZnmaTwCdh0Wo0v
         EqYh+MsM5bEnNP34c0QFo4EKhGSk3mTEyP7nCXDza3HT/60inbwthV3Gvy+03ycfsH
         S58jiX4xgZVr7j21uR1cuKs6OXr/qU4mPSm4dy7Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhang Changzhong <zhangchangzhong@huawei.com>,
        Serge Semin <fancer.lancer@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 337/717] spi: dw: Fix error return code in dw_spi_bt1_probe()
Date:   Mon, 28 Dec 2020 13:45:35 +0100
Message-Id: <20201228125037.167602366@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Changzhong <zhangchangzhong@huawei.com>

[ Upstream commit e748edd9841306908b4e02dddd0afd1aa1f8b973 ]

Fix to return a negative error code from the error handling
case instead of 0, as done elsewhere in this function.

Fixes: abf00907538e ("spi: dw: Add Baikal-T1 SPI Controller glue driver")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
Acked-by: Serge Semin <fancer.lancer@gmail.com>
Link: https://lore.kernel.org/r/1607071357-33378-1-git-send-email-zhangchangzhong@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-dw-bt1.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-dw-bt1.c b/drivers/spi/spi-dw-bt1.c
index f382dfad78421..c279b7891e3ac 100644
--- a/drivers/spi/spi-dw-bt1.c
+++ b/drivers/spi/spi-dw-bt1.c
@@ -280,8 +280,10 @@ static int dw_spi_bt1_probe(struct platform_device *pdev)
 	dws->bus_num = pdev->id;
 	dws->reg_io_width = 4;
 	dws->max_freq = clk_get_rate(dwsbt1->clk);
-	if (!dws->max_freq)
+	if (!dws->max_freq) {
+		ret = -EINVAL;
 		goto err_disable_clk;
+	}
 
 	init_func = device_get_match_data(&pdev->dev);
 	ret = init_func(pdev, dwsbt1);
-- 
2.27.0



