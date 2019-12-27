Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98D9A12B8E7
	for <lists+stable@lfdr.de>; Fri, 27 Dec 2019 18:59:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727265AbfL0RlK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Dec 2019 12:41:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:37152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727234AbfL0RlJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Dec 2019 12:41:09 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DEA8B20CC7;
        Fri, 27 Dec 2019 17:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577468468;
        bh=uj5Ey9WFNxyyArdWGA/2RLq9Ho+P3sHFKLdaetsd384=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UU6iUmOOjMo8yYB3OiaRInzTpqnP1FMKM9TnV9wDtKCmaplEUUJ+F9XcySyG+DFBE
         vnqGMV0SbKQBtxqZWXssXQI4knPuoaWH9TU1ibqysWpm/XazbyYdaxZvii5V+bDuHS
         nSyJnAtP0QhbHR/6/eCn8NpOtrXCgZSVd1tb8Z/c=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Christophe Leroy <christophe.leroy@c-s.fr>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 010/187] spi: fsl: Fix GPIO descriptor support
Date:   Fri, 27 Dec 2019 12:37:58 -0500
Message-Id: <20191227174055.4923-10-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227174055.4923-1-sashal@kernel.org>
References: <20191227174055.4923-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 4b80ace1d137..75b765f97df5 100644
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

