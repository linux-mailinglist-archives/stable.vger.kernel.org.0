Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8FFA463813
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 15:55:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237177AbhK3O56 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 09:57:58 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:59426 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243024AbhK3Ozq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 09:55:46 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D21D2CE1A69;
        Tue, 30 Nov 2021 14:52:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47D48C8D185;
        Tue, 30 Nov 2021 14:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638283944;
        bh=8Lyi+Zy2+dtrZ3otjcmH0W5e3EP2u373+I1bwNvzey0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LeFiBbkxrONlOi6H4VO40WlQVaO2eBL5K/2nAzeJ2HbTEVTCNynbszn5e7rvHMsfr
         L/4Wgnf8TyA+BBaHtRnGP4pRlpMdifc3NXNu7zD9Rzw2s9MMls7lVn6WyxnMQ8Fwg5
         6FKjty5y5hzIjtqtMEaTTdrH48hiBLarzhX6XVp84W3L7HDiyYhWK1pO4Vjk/PNAaD
         /Id3iS39hng6MVeN2jdZiG3rSxu9WcYozPMRl4uH/Rz1yJZX9l2ocVyihXtpdHpBYq
         qJ2LsPzvnwy5WrzrEH+/ZJc/EHtYE5IDLahfuxaHw4D1nV4o5W5uD3SRMqoCWcZIes
         adACeK7J7Lx0A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jon Hunter <jonathanh@nvidia.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>,
        andriy.shevchenko@linux.intel.com, akpm@linux-foundation.org,
        linux-mmc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 13/25] mmc: spi: Add device-tree SPI IDs
Date:   Tue, 30 Nov 2021 09:51:43 -0500
Message-Id: <20211130145156.946083-13-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130145156.946083-1-sashal@kernel.org>
References: <20211130145156.946083-1-sashal@kernel.org>
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
index 7083d8ddd4951..2694b15b09bfa 100644
--- a/drivers/mmc/host/mmc_spi.c
+++ b/drivers/mmc/host/mmc_spi.c
@@ -1507,6 +1507,12 @@ static int mmc_spi_remove(struct spi_device *spi)
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
@@ -1518,6 +1524,7 @@ static struct spi_driver mmc_spi_driver = {
 		.name =		"mmc_spi",
 		.of_match_table = mmc_spi_of_match_table,
 	},
+	.id_table =	mmc_spi_dev_ids,
 	.probe =	mmc_spi_probe,
 	.remove =	mmc_spi_remove,
 };
-- 
2.33.0

