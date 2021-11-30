Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C23246378E
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 15:51:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242713AbhK3Oyq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 09:54:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242908AbhK3Ox1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 09:53:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B11AC061394;
        Tue, 30 Nov 2021 06:48:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E7553B81A1F;
        Tue, 30 Nov 2021 14:48:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9601C53FCD;
        Tue, 30 Nov 2021 14:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638283728;
        bh=iS9fDsftsI3iXhp1kgyJaPiOoC/iRiK0tMDzNVV4m4A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tbFXGgCwUxGhT4PpvPxshcNexuvco3e4rvyxT5L3FYWXtOcCcNBUIT/N8FyEYUkqH
         YpoCJUYpLwX3/Om0YZGUA7NyOuPYtCQkQQ7v55Oq2DA6BnqwQd834eZ/KMpJpDgthy
         MM59D4vPIQzaljkuBQosxgsYHxD7/sUPS1h+wpWHt6QIBrT1pd0iDXR7RHu/DhV5SF
         9dd2Nmy8S8Jgxs99CZ1cZLW86NVxkrZIG9/eyAdTJdksQUoXiDYN6Smdu8dxK1IWJv
         Fzsbk43N8Nzt/tAH47EbBKojH5dFqjGz3RdfYJCXHspRBWcKGTWKyGADH4mKoiiobv
         xWadEDGteepkw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jon Hunter <jonathanh@nvidia.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>,
        andriy.shevchenko@linux.intel.com, akpm@linux-foundation.org,
        linux-mmc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 36/68] mmc: spi: Add device-tree SPI IDs
Date:   Tue, 30 Nov 2021 09:46:32 -0500
Message-Id: <20211130144707.944580-36-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130144707.944580-1-sashal@kernel.org>
References: <20211130144707.944580-1-sashal@kernel.org>
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
index f4c8e1a61f537..b431cdd27353b 100644
--- a/drivers/mmc/host/mmc_spi.c
+++ b/drivers/mmc/host/mmc_spi.c
@@ -1514,6 +1514,12 @@ static int mmc_spi_remove(struct spi_device *spi)
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
@@ -1525,6 +1531,7 @@ static struct spi_driver mmc_spi_driver = {
 		.name =		"mmc_spi",
 		.of_match_table = mmc_spi_of_match_table,
 	},
+	.id_table =	mmc_spi_dev_ids,
 	.probe =	mmc_spi_probe,
 	.remove =	mmc_spi_remove,
 };
-- 
2.33.0

