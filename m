Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83048378179
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:26:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231414AbhEJK06 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:26:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:59860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231416AbhEJK0O (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:26:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B6AA56144E;
        Mon, 10 May 2021 10:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620642309;
        bh=t6uuShaQBFm1A+tFPwZuHJ2zxR2QAMsD2HA7eO5/v58=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zHjHavcogVoxiXTc0FqEXTMbBG9XwymohD4uKMppql8HJiVxVEQ+OPjsSOfd6Yq5g
         dpDlPhKvM2DULyC2yS1s1wokIOhb4p8S8bZyZlpAo9WU/F5J+eEoP/rpI13FNJeQdQ
         5+i5n0F+cklX4Xqym3aUq+9LEK/umiuQ5x4IXvGE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Bauer <mail@david-bauer.net>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 041/184] spi: ath79: remove spi-master setup and cleanup assignment
Date:   Mon, 10 May 2021 12:18:55 +0200
Message-Id: <20210510101951.557293713@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510101950.200777181@linuxfoundation.org>
References: <20210510101950.200777181@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Bauer <mail@david-bauer.net>

[ Upstream commit ffb597b2bd3cd78b9bfb68f536743cd46dbb2cc4 ]

This removes the assignment of setup and cleanup functions for the ath79
target. Assigning the setup-method will lead to 'setup_transfer' not
being assigned in spi_bitbang_init. Because of this, performing any
TX/RX operation will lead to a kernel oops.

Also drop the redundant cleanup assignment, as it's also assigned in
spi_bitbang_init.

Signed-off-by: David Bauer <mail@david-bauer.net>
Link: https://lore.kernel.org/r/20210303160837.165771-2-mail@david-bauer.net
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-ath79.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/spi/spi-ath79.c b/drivers/spi/spi-ath79.c
index 436327fb58de..98ace748cd98 100644
--- a/drivers/spi/spi-ath79.c
+++ b/drivers/spi/spi-ath79.c
@@ -156,8 +156,6 @@ static int ath79_spi_probe(struct platform_device *pdev)
 
 	master->use_gpio_descriptors = true;
 	master->bits_per_word_mask = SPI_BPW_RANGE_MASK(1, 32);
-	master->setup = spi_bitbang_setup;
-	master->cleanup = spi_bitbang_cleanup;
 	master->flags = SPI_MASTER_GPIO_SS;
 	if (pdata) {
 		master->bus_num = pdata->bus_num;
-- 
2.30.2



