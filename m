Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DB0F29198A
	for <lists+stable@lfdr.de>; Sun, 18 Oct 2020 21:18:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727755AbgJRTSk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Oct 2020 15:18:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:56648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727705AbgJRTSe (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 18 Oct 2020 15:18:34 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 03391222D9;
        Sun, 18 Oct 2020 19:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603048713;
        bh=24E4I2wVgcDcC8lMsXnny7Jl2B8AmMs8vL8BoWMURYE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bIY/VPWveQ4VE2UZhMUW/65sSNnvXsIMIIlK9kaejN1Xo+Wrjd4FsphDsT4hJS8Tv
         pHwOTiLFU5M2PyQ2si/gX6rSUc+Q2Gc9RQXFcr/x+JnBpS64noLC5kBIA74OmVWL4L
         euYE3gqlCLsePcF/kbm0WlQNUd4K9p+ddJgXEzRk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Brad Bishop <bradleyb@fuzziesquirrel.com>,
        Eddie James <eajames@linux.ibm.com>,
        Joel Stanley <joel@jms.id.au>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.9 021/111] spi: fsi: Fix clock running too fast
Date:   Sun, 18 Oct 2020 15:16:37 -0400
Message-Id: <20201018191807.4052726-21-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018191807.4052726-1-sashal@kernel.org>
References: <20201018191807.4052726-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brad Bishop <bradleyb@fuzziesquirrel.com>

[ Upstream commit 0b546bbe9474ff23e6843916ad6d567f703b2396 ]

Use a clock divider tuned to a 200MHz FSI bus frequency (the maximum). Use
of the previous divider at 200MHz results in corrupt data from endpoint
devices. Ideally the clock divider would be calculated from the FSI clock,
but that would require some significant work on the FSI driver. With FSI
frequencies slower than 200MHz, the SPI clock will simply run slower, but
safely.

Signed-off-by: Brad Bishop <bradleyb@fuzziesquirrel.com>
Signed-off-by: Eddie James <eajames@linux.ibm.com>
Signed-off-by: Joel Stanley <joel@jms.id.au>
Link: https://lore.kernel.org/r/20200909222857.28653-3-eajames@linux.ibm.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-fsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-fsi.c b/drivers/spi/spi-fsi.c
index 37a3e0f8e7526..6e6b3c6437288 100644
--- a/drivers/spi/spi-fsi.c
+++ b/drivers/spi/spi-fsi.c
@@ -350,7 +350,7 @@ static int fsi_spi_transfer_init(struct fsi_spi *ctx)
 	u64 status = 0ULL;
 	u64 wanted_clock_cfg = SPI_FSI_CLOCK_CFG_ECC_DISABLE |
 		SPI_FSI_CLOCK_CFG_SCK_NO_DEL |
-		FIELD_PREP(SPI_FSI_CLOCK_CFG_SCK_DIV, 4);
+		FIELD_PREP(SPI_FSI_CLOCK_CFG_SCK_DIV, 19);
 
 	end = jiffies + msecs_to_jiffies(SPI_FSI_INIT_TIMEOUT_MS);
 	do {
-- 
2.25.1

