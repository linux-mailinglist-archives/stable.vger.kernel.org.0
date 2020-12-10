Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68ECC2D6643
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 20:22:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393378AbgLJTVf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 14:21:35 -0500
Received: from mailout1.hostsharing.net ([83.223.95.204]:34269 "EHLO
        mailout1.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390446AbgLJTV3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Dec 2020 14:21:29 -0500
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (not verified))
        by mailout1.hostsharing.net (Postfix) with ESMTPS id 85D4D1033E17D;
        Thu, 10 Dec 2020 20:20:10 +0100 (CET)
Received: from localhost (unknown [89.246.108.87])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by h08.hostsharing.net (Postfix) with ESMTPSA id B0518603E128;
        Thu, 10 Dec 2020 20:20:45 +0100 (CET)
X-Mailbox-Line: From 0dc949d865558ca23bd9decf10b9c4092f7576c1 Mon Sep 17 00:00:00 2001
Message-Id: <0dc949d865558ca23bd9decf10b9c4092f7576c1.1607626808.git.lukas@wunner.de>
In-Reply-To: <6a940079e894346e8ee00878ef844decd216e695.1607626808.git.lukas@wunner.de>
References: <6a940079e894346e8ee00878ef844decd216e695.1607626808.git.lukas@wunner.de>
From:   Lukas Wunner <lukas@wunner.de>
Date:   Thu, 10 Dec 2020 20:20:02 +0100
Subject: [PATCH 4.19 4.14 4.9 4.4-stable 2/2] spi: bcm2835aux: Restore err assignment in
 bcm2835aux_spi_probe
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.com>
Cc:     Mark Brown <broonie@kernel.org>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Sasha Levin <sashal@kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        stable@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

[ Upstream commit d853b3406903a7dc5b14eb5bada3e8cd677f66a2 ]

Clang warns:

drivers/spi/spi-bcm2835aux.c:532:50: warning: variable 'err' is
uninitialized when used here [-Wuninitialized]
                dev_err(&pdev->dev, "could not get clk: %d\n", err);
                                                               ^~~
./include/linux/dev_printk.h:112:32: note: expanded from macro 'dev_err'
        _dev_err(dev, dev_fmt(fmt), ##__VA_ARGS__)
                                      ^~~~~~~~~~~
drivers/spi/spi-bcm2835aux.c:495:9: note: initialize the variable 'err'
to silence this warning
        int err;
               ^
                = 0
1 warning generated.

Restore the assignment so that the error value can be used in the
dev_err statement and there is no uninitialized memory being leaked.

Fixes: e13ee6cc4781 ("spi: bcm2835aux: Fix use-after-free on unbind")
Link: https://github.com/ClangBuiltLinux/linux/issues/1199
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Link: https://lore.kernel.org/r/20201113180701.455541-1-natechancellor@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
[lukas: backport to 4.19-stable, add stable designation]
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: <stable@vger.kernel.org> # v4.4+: e13ee6cc4781: spi: bcm2835aux: Fix use-after-free on unbind
Cc: <stable@vger.kernel.org> # v4.4+
---
 drivers/spi/spi-bcm2835aux.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-bcm2835aux.c b/drivers/spi/spi-bcm2835aux.c
index 41980ee115da..8ea7e31b8c2f 100644
--- a/drivers/spi/spi-bcm2835aux.c
+++ b/drivers/spi/spi-bcm2835aux.c
@@ -444,8 +444,9 @@ static int bcm2835aux_spi_probe(struct platform_device *pdev)
 
 	bs->clk = devm_clk_get(&pdev->dev, NULL);
 	if ((!bs->clk) || (IS_ERR(bs->clk))) {
+		err = PTR_ERR(bs->clk);
 		dev_err(&pdev->dev, "could not get clk: %d\n", err);
-		return PTR_ERR(bs->clk);
+		return err;
 	}
 
 	bs->irq = platform_get_irq(pdev, 0);
-- 
2.29.2

