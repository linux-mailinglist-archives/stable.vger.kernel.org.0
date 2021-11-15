Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4212645225E
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:08:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377557AbhKPBLQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:11:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:44626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244845AbhKOTRq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:17:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1BF72634CE;
        Mon, 15 Nov 2021 18:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000681;
        bh=ZCEUYrVNKyHT5pvRUmeBf4GUnRYrr7GSX3UGCtd7HsU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vwefLgkcIrZkJyxp3J1crK/WKceeq0caGuEODIm9daSEM6n7OSzBPQEzuNF4iVFN1
         g3jNrxQzksfoC6UBpnR57A7adDfUYuiilQ1V2KA0PbHUzTWDJYoiMWu4iy1RL2Jp31
         +NnMwvz2tjiDaekyJltuCKViTjMINXqE2BL//QS4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Baolin Wang <baolin.wang7@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 744/849] mfd: sprd: Add SPI device ID table
Date:   Mon, 15 Nov 2021 18:03:47 +0100
Message-Id: <20211115165445.421590334@linuxfoundation.org>
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

From: Mark Brown <broonie@kernel.org>

[ Upstream commit c5c7f0677107052060037583b9c8c15d818afb04 ]

Currently autoloading for SPI devices does not use the DT ID table, it uses
SPI modalises. Supporting OF modalises is going to be difficult if not
impractical, an attempt was made but has been reverted, so ensure that
module autoloading works for this driver by adding a SPI device ID table.

Fixes: 96c8395e2166 ("spi: Revert modalias changes")
Signed-off-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang7@gmail.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Link: https://lore.kernel.org/r/20210924143347.14721-4-broonie@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/sprd-sc27xx-spi.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/mfd/sprd-sc27xx-spi.c b/drivers/mfd/sprd-sc27xx-spi.c
index 6b7956604a0f0..9890882db1ed3 100644
--- a/drivers/mfd/sprd-sc27xx-spi.c
+++ b/drivers/mfd/sprd-sc27xx-spi.c
@@ -236,6 +236,12 @@ static const struct of_device_id sprd_pmic_match[] = {
 };
 MODULE_DEVICE_TABLE(of, sprd_pmic_match);
 
+static const struct spi_device_id sprd_pmic_spi_ids[] = {
+	{ .name = "sc2731", .driver_data = (unsigned long)&sc2731_data },
+	{},
+};
+MODULE_DEVICE_TABLE(spi, sprd_pmic_spi_ids);
+
 static struct spi_driver sprd_pmic_driver = {
 	.driver = {
 		.name = "sc27xx-pmic",
@@ -243,6 +249,7 @@ static struct spi_driver sprd_pmic_driver = {
 		.pm = &sprd_pmic_pm_ops,
 	},
 	.probe = sprd_pmic_probe,
+	.id_table = sprd_pmic_spi_ids,
 };
 
 static int __init sprd_pmic_init(void)
-- 
2.33.0



