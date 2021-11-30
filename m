Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBF2E4638B5
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 16:02:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238789AbhK3PFl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 10:05:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244470AbhK3PB7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 10:01:59 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 765AFC06175D;
        Tue, 30 Nov 2021 06:53:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C3857CE1A78;
        Tue, 30 Nov 2021 14:53:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 235EBC53FC1;
        Tue, 30 Nov 2021 14:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638283987;
        bh=3Xiy9B3sFa5Zeqv0fSiv/4/3j5IRLpcjPGzFQJOQTpg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EejOzwFMewSyOfXcCy/5csNjBeSrxzq+/+HwZhBVIRN8jpNpEldOFohXkNSqg3tv5
         sOsFO4THxynvZiYaxdnH9KHytvp8xIrL5PLA006DYgzG4k7IQiJKBrj6uFCa4TZ/SR
         BPnFK9dPr4Hzdfss3nnbMH9vwiy2+ft/47GJubh0VqLRnGZxAIHpyaLuTtu4nWR+/M
         2lVywZbDRc3E/r/AlmrIDScp/yrmfA1YZwu92BQJsUbqWqtpZcJbO5DSBrFQoIEeyw
         /wCEtE106dyc1KNRhiib4kBmXJEMPIKxQaS7hQC2QA2Amcb6Lsgwv1lVqxe4jsVJs0
         uGFjLX0Smwu6A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jon Hunter <jonathanh@nvidia.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>,
        andriy.shevchenko@linux.intel.com, akpm@linux-foundation.org,
        linux-mmc@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 11/17] mmc: spi: Add device-tree SPI IDs
Date:   Tue, 30 Nov 2021 09:52:35 -0500
Message-Id: <20211130145243.946407-11-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130145243.946407-1-sashal@kernel.org>
References: <20211130145243.946407-1-sashal@kernel.org>
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
index 24795454d1066..a8722bfeb55de 100644
--- a/drivers/mmc/host/mmc_spi.c
+++ b/drivers/mmc/host/mmc_spi.c
@@ -1531,6 +1531,12 @@ static int mmc_spi_remove(struct spi_device *spi)
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
@@ -1542,6 +1548,7 @@ static struct spi_driver mmc_spi_driver = {
 		.name =		"mmc_spi",
 		.of_match_table = mmc_spi_of_match_table,
 	},
+	.id_table =	mmc_spi_dev_ids,
 	.probe =	mmc_spi_probe,
 	.remove =	mmc_spi_remove,
 };
-- 
2.33.0

