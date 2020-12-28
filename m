Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B1F82E65DC
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:07:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392951AbgL1QFm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 11:05:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:55530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389038AbgL1N1D (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:27:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C442222472;
        Mon, 28 Dec 2020 13:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162006;
        bh=72aZ3cE5St23Eu+A4tMYPMspQtQIOS6Luc8VG2zI4v0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PuQvmvN6k5WJG726+TXtRmrTRHcq3Dno8HKRGNsiX/LU1sdZM3HoC0clbTDRUTGaT
         8KaWvxUCyrQp2MydWTyhQAurbFAdnJoe3vdwhNc8wsHMw2l8dKO2Zdkkgf7yE6vgin
         WJtU35N0gD+SHsvKcJGXFvPezJW0au63WBR+5MzQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Qilong <zhangqilong3@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 126/346] spi: tegra20-slink: fix reference leak in slink ops of tegra20
Date:   Mon, 28 Dec 2020 13:47:25 +0100
Message-Id: <20201228124925.883052683@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Qilong <zhangqilong3@huawei.com>

[ Upstream commit 763eab7074f6e71babd85d796156f05a675f9510 ]

pm_runtime_get_sync will increment pm usage counter even it
failed. Forgetting to pm_runtime_put_noidle will result in
reference leak in two callers(tegra_slink_setup and
tegra_slink_resume), so we should fix it.

Fixes: dc4dc36056392 ("spi: tegra: add spi driver for SLINK controller")
Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Link: https://lore.kernel.org/r/20201103141345.6188-1-zhangqilong3@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-tegra20-slink.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/spi/spi-tegra20-slink.c b/drivers/spi/spi-tegra20-slink.c
index d1187317bb5d7..c6b80a60951b1 100644
--- a/drivers/spi/spi-tegra20-slink.c
+++ b/drivers/spi/spi-tegra20-slink.c
@@ -761,6 +761,7 @@ static int tegra_slink_setup(struct spi_device *spi)
 
 	ret = pm_runtime_get_sync(tspi->dev);
 	if (ret < 0) {
+		pm_runtime_put_noidle(tspi->dev);
 		dev_err(tspi->dev, "pm runtime failed, e = %d\n", ret);
 		return ret;
 	}
@@ -1197,6 +1198,7 @@ static int tegra_slink_resume(struct device *dev)
 
 	ret = pm_runtime_get_sync(dev);
 	if (ret < 0) {
+		pm_runtime_put_noidle(dev);
 		dev_err(dev, "pm runtime failed, e = %d\n", ret);
 		return ret;
 	}
-- 
2.27.0



