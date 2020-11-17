Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F275A2B622D
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:27:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729970AbgKQN0M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:26:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:33510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728494AbgKQN0L (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:26:11 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B9AFE2465E;
        Tue, 17 Nov 2020 13:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619571;
        bh=5E9a1Rlc1Xtv+4lEtT34pz0foWwpAf/Lsin33Ryk8BI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O9re7WP/yWWgNlzykmHnXwCxhEZQ/CoQE90xiAZfc0/eACn9nsyrfmSCuag8m9t9Z
         l/Qb/wMCTWYR22sBFuIkYtZ6gnCVOVQPHXghrZXNl+j1z2uswyRt7LUZKh16blw0VD
         5R2MncCUuDXqaK3ZNCIf9Bggn2bKEVg0nDTfKYP4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Martin=20Hundeb=C3=B8ll?= <martin@geanix.com>,
        Mark Brown <broonie@kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH 5.4 084/151] spi: bcm2835: remove use of uninitialized gpio flags variable
Date:   Tue, 17 Nov 2020 14:05:14 +0100
Message-Id: <20201117122125.498570896@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122121.381905960@linuxfoundation.org>
References: <20201117122121.381905960@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Hundebøll <martin@geanix.com>

commit bc7f2cd7559c5595dc38b909ae9a8d43e0215994 upstream.

Removing the duplicate gpio chip select level handling in
bcm2835_spi_setup() left the lflags variable uninitialized. Avoid trhe
use of such variable by passing default flags to
gpiochip_request_own_desc().

Fixes: 5e31ba0c0543 ("spi: bcm2835: fix gpio cs level inversion")
Signed-off-by: Martin Hundebøll <martin@geanix.com>
Link: https://lore.kernel.org/r/20201105090615.620315-1-martin@geanix.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/spi/spi-bcm2835.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/spi/spi-bcm2835.c
+++ b/drivers/spi/spi-bcm2835.c
@@ -1179,7 +1179,6 @@ static int bcm2835_spi_setup(struct spi_
 	struct spi_controller *ctlr = spi->controller;
 	struct bcm2835_spi *bs = spi_controller_get_devdata(ctlr);
 	struct gpio_chip *chip;
-	enum gpio_lookup_flags lflags;
 	u32 cs;
 
 	/*
@@ -1247,7 +1246,7 @@ static int bcm2835_spi_setup(struct spi_
 
 	spi->cs_gpiod = gpiochip_request_own_desc(chip, 8 - spi->chip_select,
 						  DRV_NAME,
-						  lflags,
+						  GPIO_LOOKUP_FLAGS_DEFAULT,
 						  GPIOD_OUT_LOW);
 	if (IS_ERR(spi->cs_gpiod))
 		return PTR_ERR(spi->cs_gpiod);


