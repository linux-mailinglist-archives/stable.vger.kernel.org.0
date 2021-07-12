Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA0473C510A
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:47:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239286AbhGLHgN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:36:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:57416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245740AbhGLHdr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:33:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 77EC3613F2;
        Mon, 12 Jul 2021 07:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075058;
        bh=DUfuHFIan7YikCK757QFEnJSWizcpjwTGGA6kphbrOg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aob8mwPtXu3PObb4Fkp4ndxRYiTctgAFS4XDqH3+aaT+tlz7UgH2lyiF7OU+Neg91
         ZaSev4fK1Xgmhs0Ikwy9u5ErpSTxH//V2klQMHKrez81huYP9Sc4HVIR66I1Kk5H9B
         sCxqn3MrdLniWuzQizO/p+ZQVFQ/z1/7AKI5kz/0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.13 091/800] iio: frequency: adf4350: disable reg and clk on error in adf4350_probe()
Date:   Mon, 12 Jul 2021 08:01:54 +0200
Message-Id: <20210712060925.851503762@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

commit c8cc4cf60b000fb9f4b29bed131fb6cf1fe42d67 upstream.

Disable reg and clk when devm_gpiod_get_optional() fails in adf4350_probe().

Fixes:4a89d2f47ccd ("iio: adf4350: Convert to use GPIO descriptor")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20210601142605.3613605-1-yangyingliang@huawei.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/frequency/adf4350.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/iio/frequency/adf4350.c
+++ b/drivers/iio/frequency/adf4350.c
@@ -563,8 +563,10 @@ static int adf4350_probe(struct spi_devi
 
 	st->lock_detect_gpiod = devm_gpiod_get_optional(&spi->dev, NULL,
 							GPIOD_IN);
-	if (IS_ERR(st->lock_detect_gpiod))
-		return PTR_ERR(st->lock_detect_gpiod);
+	if (IS_ERR(st->lock_detect_gpiod)) {
+		ret = PTR_ERR(st->lock_detect_gpiod);
+		goto error_disable_reg;
+	}
 
 	if (pdata->power_up_frequency) {
 		ret = adf4350_set_freq(st, pdata->power_up_frequency);


