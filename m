Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92FFD395C80
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:33:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231871AbhEaNdi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:33:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:39364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232378AbhEaNbb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:31:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 104F3613C8;
        Mon, 31 May 2021 13:23:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467424;
        bh=+w22d5Lh5qfl2TsfF9L41caHmM9xpcYax38cT+6efQY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rTlE0oo3D6C5t/ykWNWrAJ7XH+bppPjU2WsUBZh8AilwnkNnNeXu6L0hWbiLsFOZS
         YqGhQ+kGa8PDNQh3qOMvki1LhIl7OuXyQ16UsVw8am1QwqF4EYJOGmIo3o5EJ9upsd
         Ol0OL0iES+k5EQPFKDIHyoajaoGkKja2herfqcw4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Wunner <lukas@wunner.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Andrey Smirnov <andrew.smirnov@gmail.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 4.19 059/116] spi: gpio: Dont leak SPI master in probe error path
Date:   Mon, 31 May 2021 15:13:55 +0200
Message-Id: <20210531130642.176191748@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130640.131924542@linuxfoundation.org>
References: <20210531130640.131924542@linuxfoundation.org>
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
[lukas: backport to v4.19.192]
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-gpio.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/drivers/spi/spi-gpio.c
+++ b/drivers/spi/spi-gpio.c
@@ -382,7 +382,7 @@ static int spi_gpio_probe(struct platfor
 		return -ENODEV;
 #endif
 
-	master = spi_alloc_master(&pdev->dev, sizeof(*spi_gpio));
+	master = devm_spi_alloc_master(&pdev->dev, sizeof(*spi_gpio));
 	if (!master)
 		return -ENOMEM;
 
@@ -438,11 +438,7 @@ static int spi_gpio_probe(struct platfor
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


