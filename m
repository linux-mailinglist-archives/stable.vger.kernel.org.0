Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4106046388A
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 16:02:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243821AbhK3PFA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 10:05:00 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:51916 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243588AbhK3O5h (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 09:57:37 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 09EC2B81A21;
        Tue, 30 Nov 2021 14:54:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDB26C53FCF;
        Tue, 30 Nov 2021 14:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638284052;
        bh=Qqwpqs1P4RB8XLiDq9NEORR5zJ582JHVP48kdWjhepo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dN6Z4Oynk/DR1DXBgzBJE/JHVYtYmJPlVnY3cE38p1q32d9yLE1YL4PLUNDVvfDqv
         r0a+0snI4WZ+l1n5+vPm+PiHGCixZmPQB34XsXoEYonKBcIk8w8MqkRpTWcwdU3hWX
         AcdtCYCV4Csxy77ktvS6rdPvkoR9RC8W6OUO5lhEgY1wybUUZif9SrXbaCFwZRuKeu
         WeFj+JCaQ9fAgeZY3SkjlHCcsAZ1x2V821bW04m96WXkAyYRfViWJuS2xB/Jj3cxGH
         aTamssI7LIUCbtvYQvhutdzqVltStchAgUPWPygC1G3UxGg85YxLrj4qarhF1LIhyD
         RxZU1ov2i1Ifg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jon Hunter <jonathanh@nvidia.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>,
        andriy.shevchenko@linux.intel.com, akpm@linux-foundation.org,
        linux-mmc@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 5/9] mmc: spi: Add device-tree SPI IDs
Date:   Tue, 30 Nov 2021 09:53:58 -0500
Message-Id: <20211130145402.947049-5-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130145402.947049-1-sashal@kernel.org>
References: <20211130145402.947049-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jon Hunter <jonathanh@nvidia.com>

[ Upstream commit 5f719948b5d43eb39356e94e8d0b462568915381 ]

Commit 5fa6863ba692 ("spi: Check we have a spi_device_id for each DT
compatible") added a test to check that every SPI driver has a
spi_device_id for each DT compatiable string defined by the driver
and warns if the spi_device_id is missing. The spi_device_id is
missing for the MMC SPI driver and the following warning is now seen.

 WARNING KERN SPI driver mmc_spi has no spi_device_id for mmc-spi-slot

Fix this by adding the necessary spi_device_id.

Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
Link: https://lore.kernel.org/r/20211115113813.238044-1-jonathanh@nvidia.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/mmc_spi.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/mmc/host/mmc_spi.c b/drivers/mmc/host/mmc_spi.c
index b52489a67097e..a3e049248be8d 100644
--- a/drivers/mmc/host/mmc_spi.c
+++ b/drivers/mmc/host/mmc_spi.c
@@ -1523,6 +1523,12 @@ static int mmc_spi_remove(struct spi_device *spi)
 	return 0;
 }
 
+static const struct spi_device_id mmc_spi_dev_ids[] = {
+	{ "mmc-spi-slot"},
+	{ },
+};
+MODULE_DEVICE_TABLE(spi, mmc_spi_dev_ids);
+
 static const struct of_device_id mmc_spi_of_match_table[] = {
 	{ .compatible = "mmc-spi-slot", },
 	{},
@@ -1534,6 +1540,7 @@ static struct spi_driver mmc_spi_driver = {
 		.name =		"mmc_spi",
 		.of_match_table = mmc_spi_of_match_table,
 	},
+	.id_table =	mmc_spi_dev_ids,
 	.probe =	mmc_spi_probe,
 	.remove =	mmc_spi_remove,
 };
-- 
2.33.0

