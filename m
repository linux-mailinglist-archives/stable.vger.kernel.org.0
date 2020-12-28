Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A84792E39A9
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:27:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389084AbgL1N0V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:26:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:54730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389099AbgL1N0B (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:26:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 782BF207CF;
        Mon, 28 Dec 2020 13:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161921;
        bh=rXPopBDqyD3dT3dsIt2Hw+Dd4hszfUpNkyQjeCgt8TA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Iq9dlBFT9hYfyiFJyH6loHFX7nvYVoEND2Gbbp4viZo0Coj264NfxyrlA/BITR8Xz
         hlqyxXN16J4KOUH1uvAIgIcU8qlbvConEIDYE6hKQ3flZ7o3VYOzYcuddSZThhlhGU
         kY1DzJIYThUKoCn7dIqOSMa6DhYVbj52qeRoNHGQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Qilong <zhangqilong3@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 128/346] spi: tegra114: fix reference leak in tegra spi ops
Date:   Mon, 28 Dec 2020 13:47:27 +0100
Message-Id: <20201228124925.974382235@linuxfoundation.org>
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

[ Upstream commit a042184c7fb99961ea083d4ec192614bec671969 ]

pm_runtime_get_sync will increment pm usage counter even it
failed. Forgetting to pm_runtime_put_noidle will result in
reference leak in two callers(tegra_spi_setup and
tegra_spi_resume), so we should fix it.

Fixes: f333a331adfac ("spi/tegra114: add spi driver")
Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Link: https://lore.kernel.org/r/20201103141306.5607-1-zhangqilong3@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-tegra114.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/spi/spi-tegra114.c b/drivers/spi/spi-tegra114.c
index 09cfae3abce2d..c510b53e5e3f5 100644
--- a/drivers/spi/spi-tegra114.c
+++ b/drivers/spi/spi-tegra114.c
@@ -827,6 +827,7 @@ static int tegra_spi_setup(struct spi_device *spi)
 
 	ret = pm_runtime_get_sync(tspi->dev);
 	if (ret < 0) {
+		pm_runtime_put_noidle(tspi->dev);
 		dev_err(tspi->dev, "pm runtime failed, e = %d\n", ret);
 		return ret;
 	}
@@ -1252,6 +1253,7 @@ static int tegra_spi_resume(struct device *dev)
 
 	ret = pm_runtime_get_sync(dev);
 	if (ret < 0) {
+		pm_runtime_put_noidle(dev);
 		dev_err(dev, "pm runtime failed, e = %d\n", ret);
 		return ret;
 	}
-- 
2.27.0



