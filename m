Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 666BD370C4A
	for <lists+stable@lfdr.de>; Sun,  2 May 2021 16:05:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232937AbhEBOFv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 May 2021 10:05:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:51056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232936AbhEBOFb (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 2 May 2021 10:05:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 22AE5613DC;
        Sun,  2 May 2021 14:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619964279;
        bh=t6uuShaQBFm1A+tFPwZuHJ2zxR2QAMsD2HA7eO5/v58=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gng2sX3YiZP5VcxoUj+izURWBS3POeDkwsb6N2Ttt+/ahUbEzgaP8a/2tKnyYULlQ
         nibC3eydKsNtgKTaZ5wVXigP7mvzCdkm0oJutXAw2xIUCwt2qKGHjBWNvmW06iN3Xs
         QNYlu/5q9ECGkpEudaw5RDwkvt+7sXCs2XtX+Lxp0mZ8JD0jEfB6KDQ2RIQxhtY733
         jXca+BUCq3BZGoBfUpnQQPfZ8FY+sAA1CtUNVo2kc5OVrL3JjXV4dtIHYbosid7Bjp
         Mw+yFtS1K6+t37c5ZI2mKfH8FUhXRTObE6zGCj7o54wp5ikutWkUhyrnmuSoUcW8dK
         PcT6z6xvkeHyA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Bauer <mail@david-bauer.net>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 04/34] spi: ath79: remove spi-master setup and cleanup assignment
Date:   Sun,  2 May 2021 10:04:04 -0400
Message-Id: <20210502140434.2719553-4-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210502140434.2719553-1-sashal@kernel.org>
References: <20210502140434.2719553-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

