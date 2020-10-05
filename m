Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E274A283A6F
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 17:34:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728278AbgJEPeX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 11:34:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:34958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728275AbgJEPeW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 11:34:22 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E293E2074F;
        Mon,  5 Oct 2020 15:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601912062;
        bh=jAlrg+L9js6uu/wPSB9VsKYBHu+Cn0bHgKhnZi+zcEA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F2pQI4DUpZ6BNIf/rkdBlLvm9pM9Kut4uqh3E/Vb79wBnhCoR5Yd/6GI8Wy19gIV5
         KTfv9uBNdXPI11XXC5bt2ntNuNJaGMgeQMY2Wcnl9/2WiX8x/dbUmulmtzxF2+ypqT
         gtSq7KiUx+KbE4c91zc6KcZVSKjgkhcGV4IDWxw0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 74/85] gpio: pca953x: Correctly initialize registers 6 and 7 for PCA957x
Date:   Mon,  5 Oct 2020 17:27:10 +0200
Message-Id: <20201005142118.291278200@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201005142114.732094228@linuxfoundation.org>
References: <20201005142114.732094228@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 8c1f1c34777bddb633d4a068a9c812d29974c6bd ]

When driver has been converted to the bitmap API the non-bitmap functions
started behaving differently on 32-bit BE architectures since the bytes in
two consequent unsigned longs are in different order in comparison to byte
array. Hence if the chip had had more than 32 lines the memset() call over
it would have not set up upper lines correctly.
Although it's currently a theoretical case (no supported chips of this type
has 32+ lines), it's better to provide a clean code to avoid people thinking
this is okay and potentially producing not fully working things.

Fixes: 35d13d94893f ("gpio: pca953x: convert to use bitmap API")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Link: https://lore.kernel.org/r/20200930142013.59247-2-andriy.shevchenko@linux.intel.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-pca953x.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-pca953x.c b/drivers/gpio/gpio-pca953x.c
index cc95f1630feb0..11c3bbd105f11 100644
--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -938,6 +938,7 @@ static int device_pca95xx_init(struct pca953x_chip *chip, u32 invert)
 static int device_pca957x_init(struct pca953x_chip *chip, u32 invert)
 {
 	DECLARE_BITMAP(val, MAX_LINE);
+	unsigned int i;
 	int ret;
 
 	ret = device_pca95xx_init(chip, invert);
@@ -945,7 +946,9 @@ static int device_pca957x_init(struct pca953x_chip *chip, u32 invert)
 		goto out;
 
 	/* To enable register 6, 7 to control pull up and pull down */
-	memset(val, 0x02, NBANK(chip));
+	for (i = 0; i < NBANK(chip); i++)
+		bitmap_set_value8(val, 0x02, i * BANK_SZ);
+
 	ret = pca953x_write_regs(chip, PCA957X_BKEN, val);
 	if (ret)
 		goto out;
-- 
2.25.1



