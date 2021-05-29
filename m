Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED9B7394CD4
	for <lists+stable@lfdr.de>; Sat, 29 May 2021 17:19:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbhE2PUy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 May 2021 11:20:54 -0400
Received: from bmailout1.hostsharing.net ([83.223.95.100]:35985 "EHLO
        bmailout1.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbhE2PUv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 May 2021 11:20:51 -0400
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by bmailout1.hostsharing.net (Postfix) with ESMTPS id 6CE96300002A5;
        Sat, 29 May 2021 17:19:13 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id 5FFC0210E76; Sat, 29 May 2021 17:19:13 +0200 (CEST)
Date:   Sat, 29 May 2021 17:19:13 +0200
From:   Lukas Wunner <lukas@wunner.de>
To:     gregkh@linuxfoundation.org
Cc:     andrew.smirnov@gmail.com, broonie@kernel.org,
        linus.walleij@linaro.org, navid.emamdoost@gmail.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] spi: gpio: Don't leak SPI master in probe
 error path" failed to apply to 4.19-stable tree
Message-ID: <20210529151913.GA20981@wunner.de>
References: <1609153159153229@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1609153159153229@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 28, 2020 at 11:59:19AM +0100, gregkh@linuxfoundation.org wrote:
> The patch below does not apply to the 4.19-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here's the backport of 7174dc655ef0 to v4.19.192:

-- >8 --
From: Lukas Wunner <lukas@wunner.de>
Date: Mon, 7 Dec 2020 09:17:09 +0100
Subject: [PATCH] spi: gpio: Don't leak SPI master in probe error path

commit 7174dc655ef0578877b0b4598e69619d2be28b4d upstream.

If the calls to devm_kcalloc() or spi_gpio_request() fail on probe of
the GPIO SPI driver, the spi_master struct is erroneously not freed
because the required calls to spi_master_put() are missing.

Fix by switching over to the new devm_spi_alloc_master() helper.

Fixes: 9b00bc7b901f ("spi: spi-gpio: Rewrite to use GPIO descriptors")
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Cc: <stable@vger.kernel.org> # v4.17+: 5e844cc37a5c: spi: Introduce device-managed SPI controller allocation
Cc: <stable@vger.kernel.org> # v4.17+
Cc: Navid Emamdoost <navid.emamdoost@gmail.com>
Cc: Andrey Smirnov <andrew.smirnov@gmail.com>
Link: https://lore.kernel.org/r/86eaed27431c3d709e3748eb76ceecbfc790dd37.1607286887.git.lukas@wunner.de
Signed-off-by: Mark Brown <broonie@kernel.org>
[lukas: backport to v4.19.192]
Signed-off-by: Lukas Wunner <lukas@wunner.de>
---
 drivers/spi/spi-gpio.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/spi/spi-gpio.c b/drivers/spi/spi-gpio.c
index 77838d8fd9bb..341d2953d7fc 100644
--- a/drivers/spi/spi-gpio.c
+++ b/drivers/spi/spi-gpio.c
@@ -382,7 +382,7 @@ static int spi_gpio_probe(struct platform_device *pdev)
 		return -ENODEV;
 #endif
 
-	master = spi_alloc_master(&pdev->dev, sizeof(*spi_gpio));
+	master = devm_spi_alloc_master(&pdev->dev, sizeof(*spi_gpio));
 	if (!master)
 		return -ENOMEM;
 
@@ -438,11 +438,7 @@ static int spi_gpio_probe(struct platform_device *pdev)
 	}
 	spi_gpio->bitbang.setup_transfer = spi_bitbang_setup_transfer;
 
-	status = spi_bitbang_start(&spi_gpio->bitbang);
-	if (status)
-		spi_master_put(master);
-
-	return status;
+	return spi_bitbang_start(&spi_gpio->bitbang);
 }
 
 static int spi_gpio_remove(struct platform_device *pdev)
-- 
2.31.1

