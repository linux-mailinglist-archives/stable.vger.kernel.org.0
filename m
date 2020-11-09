Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38B2C2AB9D4
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:13:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731886AbgKINNK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:13:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:38926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732867AbgKINNG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:13:06 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9A5E820867;
        Mon,  9 Nov 2020 13:13:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927586;
        bh=/wHBwqn5w1NOF3XMl5ZV5K9HZa/eE6X7dhUJFFY+5OY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=befigCPRfv8awpIz0BDT3slJBmskQUEnMwGG6GHXDkIT1oYo6zs+P29C+7W+7bJxu
         KfdpwUfi2SjSUauWsNpzdl7+w+ltmLMnT9GK7K/fzyVSlAPetYxik4+meNuAJVcMqi
         AS6MXIeN0cQa9OjVvYZR4zomk9HpKDOK79C7iBLY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Martin=20Hundeb=C3=B8ll?= <martin@geanix.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.4 39/85] spi: bcm2835: fix gpio cs level inversion
Date:   Mon,  9 Nov 2020 13:55:36 +0100
Message-Id: <20201109125024.465850684@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125022.614792961@linuxfoundation.org>
References: <20201109125022.614792961@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Hundebøll <martin@geanix.com>

commit 5e31ba0c0543a04483b53151eb5b7413efece94c upstream.

The work on improving gpio chip-select in spi core, and the following
fixes, has caused the bcm2835 spi driver to use wrong levels. Fix this
by simply removing level handling in the bcm2835 driver, and let the
core do its work.

Fixes: 3e5ec1db8bfe ("spi: Fix SPI_CS_HIGH setting when using native and GPIO CS")
Cc: <stable@vger.kernel.org>
Signed-off-by: Martin Hundebøll <martin@geanix.com>
Link: https://lore.kernel.org/r/20201014090230.2706810-1-martin@geanix.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/spi/spi-bcm2835.c |   12 ------------
 1 file changed, 12 deletions(-)

--- a/drivers/spi/spi-bcm2835.c
+++ b/drivers/spi/spi-bcm2835.c
@@ -1245,18 +1245,6 @@ static int bcm2835_spi_setup(struct spi_
 	if (!chip)
 		return 0;
 
-	/*
-	 * Retrieve the corresponding GPIO line used for CS.
-	 * The inversion semantics will be handled by the GPIO core
-	 * code, so we pass GPIOS_OUT_LOW for "unasserted" and
-	 * the correct flag for inversion semantics. The SPI_CS_HIGH
-	 * on spi->mode cannot be checked for polarity in this case
-	 * as the flag use_gpio_descriptors enforces SPI_CS_HIGH.
-	 */
-	if (of_property_read_bool(spi->dev.of_node, "spi-cs-high"))
-		lflags = GPIO_ACTIVE_HIGH;
-	else
-		lflags = GPIO_ACTIVE_LOW;
 	spi->cs_gpiod = gpiochip_request_own_desc(chip, 8 - spi->chip_select,
 						  DRV_NAME,
 						  lflags,


