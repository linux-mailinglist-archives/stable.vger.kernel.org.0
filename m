Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABC72378389
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:45:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230507AbhEJKqe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:46:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:59296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232484AbhEJKoU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:44:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DA73B6198B;
        Mon, 10 May 2021 10:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620642790;
        bh=pgd1252rTW4FmboBZqeKmdDft2iOwqQhjAW9jP4Q6SE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jG6t39gGgfieIjtxEoVrOGUAj0a+PgSj65mI/stagVKJ1bpqA1QcUhEwNpXzeg9tp
         bEHKUhadpjcKPVHCTxtxUtXeuVtSeTrbkJmtEDFLXte0dxQAXNvrZ67y9pfafkdsEf
         nfk++AALhhoowQnhF8MXp6Q+oIj2xQZI0HVKLs2I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Bauer <mail@david-bauer.net>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 053/299] spi: ath79: always call chipselect function
Date:   Mon, 10 May 2021 12:17:30 +0200
Message-Id: <20210510102006.633898492@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102004.821838356@linuxfoundation.org>
References: <20210510102004.821838356@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Bauer <mail@david-bauer.net>

[ Upstream commit 19e2132174583beb90c1bd3e9c842bc6d5c944d1 ]

spi-bitbang has to call the chipselect function on the ath79 SPI driver
in order to communicate with the SPI slave device, as the ath79 SPI
driver has three dedicated chipselect lines but can also be used with
GPIOs for the CS lines.

Fixes commit 4a07b8bcd503 ("spi: bitbang: Make chipselect callback optional")

Signed-off-by: David Bauer <mail@david-bauer.net>
Link: https://lore.kernel.org/r/20210303160837.165771-1-mail@david-bauer.net
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-ath79.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/spi-ath79.c b/drivers/spi/spi-ath79.c
index eb9a243e9526..436327fb58de 100644
--- a/drivers/spi/spi-ath79.c
+++ b/drivers/spi/spi-ath79.c
@@ -158,6 +158,7 @@ static int ath79_spi_probe(struct platform_device *pdev)
 	master->bits_per_word_mask = SPI_BPW_RANGE_MASK(1, 32);
 	master->setup = spi_bitbang_setup;
 	master->cleanup = spi_bitbang_cleanup;
+	master->flags = SPI_MASTER_GPIO_SS;
 	if (pdata) {
 		master->bus_num = pdata->bus_num;
 		master->num_chipselect = pdata->num_chipselect;
-- 
2.30.2



