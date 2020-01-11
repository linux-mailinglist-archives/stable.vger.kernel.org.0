Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B6E6137FB6
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:22:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729395AbgAKKWY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:22:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:47422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730333AbgAKKWW (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:22:22 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 84CD5205F4;
        Sat, 11 Jan 2020 10:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578738142;
        bh=tu7Sl4ogZwaO849WOpl7I9VcnFryYUZMC8/N6yzu66w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wNfo96UcaSLS8pZ0pjhBcwowuEoNSxIxhjw+ayu8vbI8ZDI0bGjwrNCXFCHj8Ii3+
         JAtFM05FpIgS4ckL19pHsnQ6tTuA7OKgGV/JXNojsg5dSwkdTCIG8dwUM2Vf7xnm3P
         HK/tkxh7qlTRUY+CP8bsfC7LrW+F3nJ8/agIDccY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christophe Leroy <christophe.leroy@c-s.fr>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 007/165] spi: fsl: Fix GPIO descriptor support
Date:   Sat, 11 Jan 2020 10:48:46 +0100
Message-Id: <20200111094921.875977602@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094921.347491861@linuxfoundation.org>
References: <20200111094921.347491861@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit f106904968e2a075e64653b9b79dda9f0f070ab5 ]

This makes the driver actually support looking up GPIO
descriptor. A coding mistake in the initial descriptor
support patch was that it was failing to turn on the very
feature it was implementing. Mea culpa.

Cc: Christophe Leroy <christophe.leroy@c-s.fr>
Reported-by: Christophe Leroy <christophe.leroy@c-s.fr>
Fixes: 0f0581b24bd0 ("spi: fsl: Convert to use CS GPIO descriptors")
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Tested-by: Christophe Leroy <christophe.leroy@c-s.fr>
Link: https://lore.kernel.org/r/20191128083718.39177-1-linus.walleij@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-fsl-spi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/spi-fsl-spi.c b/drivers/spi/spi-fsl-spi.c
index 2d563874b4ac..ad1abea6e8b0 100644
--- a/drivers/spi/spi-fsl-spi.c
+++ b/drivers/spi/spi-fsl-spi.c
@@ -612,6 +612,7 @@ static struct spi_master * fsl_spi_probe(struct device *dev,
 	master->setup = fsl_spi_setup;
 	master->cleanup = fsl_spi_cleanup;
 	master->transfer_one_message = fsl_spi_do_one_msg;
+	master->use_gpio_descriptors = true;
 
 	mpc8xxx_spi = spi_master_get_devdata(master);
 	mpc8xxx_spi->max_bits_per_word = 32;
-- 
2.20.1



