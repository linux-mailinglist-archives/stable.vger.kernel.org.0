Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 141912C9D74
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:40:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729510AbgLAJXf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:23:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:43594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388800AbgLAJGi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:06:38 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 87283206D8;
        Tue,  1 Dec 2020 09:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813558;
        bh=wvaSC8J3X+XnxkAYFGxM9nb0rkFcHkxNLsvw+QZCyBs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sNsjyi8atQoprc36CP/Lnuu+0XfteO0vf58E8tA6K7HbkGBuFaDGNPM1tUR1i5Dbm
         JLHI34V5xDWxhGbEDIFyeHYmrXucGiAktd2cJdcbQaia3hM/ya0el7LO827sBl84co
         v2f+v5o4hj5T6qgca0sIWiGI4fsBbiSYtd2PYKt8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.4 80/98] spi: bcm2835aux: Restore err assignment in bcm2835aux_spi_probe
Date:   Tue,  1 Dec 2020 09:53:57 +0100
Message-Id: <20201201084658.970047013@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084652.827177826@linuxfoundation.org>
References: <20201201084652.827177826@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

commit d853b3406903a7dc5b14eb5bada3e8cd677f66a2 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/spi/spi-bcm2835aux.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-bcm2835aux.c
+++ b/drivers/spi/spi-bcm2835aux.c
@@ -529,8 +529,9 @@ static int bcm2835aux_spi_probe(struct p
 
 	bs->clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(bs->clk)) {
+		err = PTR_ERR(bs->clk);
 		dev_err(&pdev->dev, "could not get clk: %d\n", err);
-		return PTR_ERR(bs->clk);
+		return err;
 	}
 
 	bs->irq = platform_get_irq(pdev, 0);


