Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05AAF2E41F7
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:16:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437488AbgL1PP1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:15:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:39074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437466AbgL1OEq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:04:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F2194206E5;
        Mon, 28 Dec 2020 14:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164245;
        bh=07JNEdDjLnMYSgegPrBwiObllEdipecUT1fBLf6AhlA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XpYwrrLOLqyvhNnPSvHegYP2FAQguwGg2YKQ2SOYc4JBrOQD4cRu5djYB4g70GcAL
         euENdWdh0za5LXENxS3ZyNs6DiLRL7FhmpcCmQ0g/QB9gGA3FlleyUIyl4ZEduujBW
         uliPytxmXilq3jIOrLtVUd97pPSk1VK8awZ33PEM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Qilong <zhangqilong3@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 082/717] spi: imx: fix reference leak in two imx operations
Date:   Mon, 28 Dec 2020 13:41:20 +0100
Message-Id: <20201228125024.913281255@linuxfoundation.org>
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

From: Zhang Qilong <zhangqilong3@huawei.com>

[ Upstream commit 1dcbdd944824369d4569959f8130336fe6fe5f39 ]

pm_runtime_get_sync will increment pm usage counter even it
failed. Forgetting to pm_runtime_put_noidle will result in
reference leak in callers(spi_imx_prepare_message and
spi_imx_remove), so we should fix it.

Fixes: 525c9e5a32bd7 ("spi: imx: enable runtime pm support")
Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Link: https://lore.kernel.org/r/20201102145835.4765-1-zhangqilong3@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-imx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/spi/spi-imx.c b/drivers/spi/spi-imx.c
index 0b597905ee72c..8df5e973404f0 100644
--- a/drivers/spi/spi-imx.c
+++ b/drivers/spi/spi-imx.c
@@ -1538,6 +1538,7 @@ spi_imx_prepare_message(struct spi_master *master, struct spi_message *msg)
 
 	ret = pm_runtime_get_sync(spi_imx->dev);
 	if (ret < 0) {
+		pm_runtime_put_noidle(spi_imx->dev);
 		dev_err(spi_imx->dev, "failed to enable clock\n");
 		return ret;
 	}
@@ -1748,6 +1749,7 @@ static int spi_imx_remove(struct platform_device *pdev)
 
 	ret = pm_runtime_get_sync(spi_imx->dev);
 	if (ret < 0) {
+		pm_runtime_put_noidle(spi_imx->dev);
 		dev_err(spi_imx->dev, "failed to enable clock\n");
 		return ret;
 	}
-- 
2.27.0



