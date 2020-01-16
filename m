Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6015913F654
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 20:03:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389137AbgAPTDJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 14:03:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:33760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388564AbgAPRFS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:05:18 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0BF8324653;
        Thu, 16 Jan 2020 17:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194317;
        bh=pW7Gw8OOC03WmjY5jFqoDEPIzvGcfAEHq8iNMn7Pifc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HfMDKWJwlnceqL/lDfeiuMTTgQfzxM6E0BtRBZABM8wQKEO8SrwQLkxpHoHOq0S4Q
         E2TqIMqf5xv5OWVSyo3UZK/Kx65/kzZll9kQM0sAO5sIomKnDVdRkn9OcOyL7Rv3Go
         h56l8NWOCnNw2mNqIP94bbwq/MeKlxotBlapXIoc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sowjanya Komatineni <skomatineni@nvidia.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 268/671] spi: tegra114: terminate dma and reset on transfer timeout
Date:   Thu, 16 Jan 2020 11:58:26 -0500
Message-Id: <20200116170509.12787-5-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sowjanya Komatineni <skomatineni@nvidia.com>

[ Upstream commit 32bd1a9551cae34e6889afa235c7afdfede9aeac ]

Fixes: terminate DMA and perform controller reset on transfer timeout
to clear the FIFO's and errors.

Signed-off-by: Sowjanya Komatineni <skomatineni@nvidia.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-tegra114.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/spi/spi-tegra114.c b/drivers/spi/spi-tegra114.c
index 17c2c78318f7..b1b726673f85 100644
--- a/drivers/spi/spi-tegra114.c
+++ b/drivers/spi/spi-tegra114.c
@@ -869,7 +869,16 @@ static int tegra_spi_transfer_one_message(struct spi_master *master,
 		if (WARN_ON(ret == 0)) {
 			dev_err(tspi->dev,
 				"spi transfer timeout, err %d\n", ret);
+			if (tspi->is_curr_dma_xfer &&
+			    (tspi->cur_direction & DATA_DIR_TX))
+				dmaengine_terminate_all(tspi->tx_dma_chan);
+			if (tspi->is_curr_dma_xfer &&
+			    (tspi->cur_direction & DATA_DIR_RX))
+				dmaengine_terminate_all(tspi->rx_dma_chan);
 			ret = -EIO;
+			reset_control_assert(tspi->rst);
+			udelay(2);
+			reset_control_deassert(tspi->rst);
 			goto complete_xfer;
 		}
 
-- 
2.20.1

