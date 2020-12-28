Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 861A02E665F
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:14:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387550AbgL1NU2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:20:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:48992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387515AbgL1NU2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:20:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D2825207C9;
        Mon, 28 Dec 2020 13:19:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161587;
        bh=loO3fcbnZq6yWGDjrMScXV8PinQTGCawLfaIzEjZKRc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FfMoTsU3+Kek0JxXMdQLmXd4ac7i3GAu+QLcigGagvhF9j7n6RD9sYQ8CCX41Htmu
         nZSGpJm09u9tdq4IoDPUBvRzsUYIQKphk+1g9SEYkP+8rRRcuRn8j73OjoV76/WscM
         svi3MtXhYlMZGyQap0UIuYmHwWoKC76Liyh9ieMc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        Mark Brown <broonie@kernel.org>, Lukas Wunner <lukas@wunner.de>
Subject: [PATCH 4.19 004/346] spi: bcm2835aux: Restore err assignment in bcm2835aux_spi_probe
Date:   Mon, 28 Dec 2020 13:45:23 +0100
Message-Id: <20201228124919.969957866@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-bcm2835aux.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-bcm2835aux.c
+++ b/drivers/spi/spi-bcm2835aux.c
@@ -444,8 +444,9 @@ static int bcm2835aux_spi_probe(struct p
 
 	bs->clk = devm_clk_get(&pdev->dev, NULL);
 	if ((!bs->clk) || (IS_ERR(bs->clk))) {
+		err = PTR_ERR(bs->clk);
 		dev_err(&pdev->dev, "could not get clk: %d\n", err);
-		return PTR_ERR(bs->clk);
+		return err;
 	}
 
 	bs->irq = platform_get_irq(pdev, 0);


