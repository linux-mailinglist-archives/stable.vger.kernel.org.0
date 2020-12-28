Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 268D02E3F44
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:38:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504591AbgL1Ob7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:31:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:39888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2504570AbgL1Obi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:31:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 62F1D221F0;
        Mon, 28 Dec 2020 14:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165857;
        bh=GRGnv1kv8/gEUPXoQjFlI3y8IkFzSXCvc5nt/zfAd+k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2KhGGxLIuKK+Ac+pNH/SiowpnpEGSd0I5g4rXfvgTqYF8VRaVi0J2k4aqXCNAU/b+
         Z2mY5w81HrYKG0zIcIDey3QJXqgTjtheXO2AtfUoe2BEhSu8F80Xlsa2FizVKtdHjM
         S7vtHAsJLGbqtAMi2nEKjk1kFPy/WoK+WU/hgw7k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Wunner <lukas@wunner.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Andrey Smirnov <andrew.smirnov@gmail.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 648/717] spi: gpio: Dont leak SPI master in probe error path
Date:   Mon, 28 Dec 2020 13:50:46 +0100
Message-Id: <20201228125051.992756403@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Wunner <lukas@wunner.de>

commit 7174dc655ef0578877b0b4598e69619d2be28b4d upstream.

If the call to devm_spi_register_master() fails on probe of the GPIO SPI
driver, the spi_master struct is erroneously not freed:

After allocating the spi_master, its reference count is 1.  The driver
unconditionally decrements the reference count on unbind using a devm
action.  Before calling devm_spi_register_master(), the driver
unconditionally increments the reference count because on success,
that function will decrement the reference count on unbind.  However on
failure, devm_spi_register_master() does *not* decrement the reference
count, so the spi_master is leaked.

The issue was introduced by commits 8b797490b4db ("spi: gpio: Make sure
spi_master_put() is called in every error path") and 79567c1a321e ("spi:
gpio: Use devm_spi_register_master()"), which sought to plug leaks
introduced by 9b00bc7b901f ("spi: spi-gpio: Rewrite to use GPIO
descriptors") but missed this remaining leak.

The situation was later aggravated by commit d3b0ffa1d75d ("spi: gpio:
prevent memory leak in spi_gpio_probe"), which introduced a
use-after-free because it releases a reference on the spi_master if
devm_add_action_or_reset() fails even though the function already
does that.

Fix by switching over to the new devm_spi_alloc_master() helper.

Fixes: 9b00bc7b901f ("spi: spi-gpio: Rewrite to use GPIO descriptors")
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Cc: <stable@vger.kernel.org> # v4.17+: 5e844cc37a5c: spi: Introduce device-managed SPI controller allocation
Cc: <stable@vger.kernel.org> # v5.1-: 8b797490b4db: spi: gpio: Make sure spi_master_put() is called in every error path
Cc: <stable@vger.kernel.org> # v5.1-: 45beec351998: spi: bitbang: Introduce spi_bitbang_init()
Cc: <stable@vger.kernel.org> # v5.1-: 79567c1a321e: spi: gpio: Use devm_spi_register_master()
Cc: <stable@vger.kernel.org> # v5.4-: d3b0ffa1d75d: spi: gpio: prevent memory leak in spi_gpio_probe
Cc: <stable@vger.kernel.org> # v4.17+
Cc: Navid Emamdoost <navid.emamdoost@gmail.com>
Cc: Andrey Smirnov <andrew.smirnov@gmail.com>
Link: https://lore.kernel.org/r/86eaed27431c3d709e3748eb76ceecbfc790dd37.1607286887.git.lukas@wunner.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/spi/spi-gpio.c |   15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

--- a/drivers/spi/spi-gpio.c
+++ b/drivers/spi/spi-gpio.c
@@ -350,11 +350,6 @@ static int spi_gpio_probe_pdata(struct p
 	return 0;
 }
 
-static void spi_gpio_put(void *data)
-{
-	spi_master_put(data);
-}
-
 static int spi_gpio_probe(struct platform_device *pdev)
 {
 	int				status;
@@ -363,16 +358,10 @@ static int spi_gpio_probe(struct platfor
 	struct device			*dev = &pdev->dev;
 	struct spi_bitbang		*bb;
 
-	master = spi_alloc_master(dev, sizeof(*spi_gpio));
+	master = devm_spi_alloc_master(dev, sizeof(*spi_gpio));
 	if (!master)
 		return -ENOMEM;
 
-	status = devm_add_action_or_reset(&pdev->dev, spi_gpio_put, master);
-	if (status) {
-		spi_master_put(master);
-		return status;
-	}
-
 	if (pdev->dev.of_node)
 		status = spi_gpio_probe_dt(pdev, master);
 	else
@@ -432,7 +421,7 @@ static int spi_gpio_probe(struct platfor
 	if (status)
 		return status;
 
-	return devm_spi_register_master(&pdev->dev, spi_master_get(master));
+	return devm_spi_register_master(&pdev->dev, master);
 }
 
 MODULE_ALIAS("platform:" DRIVER_NAME);


