Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B3E13C4BF4
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:37:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239150AbhGLHA6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:00:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:33880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241611AbhGLG7D (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:59:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5A4256102A;
        Mon, 12 Jul 2021 06:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072975;
        bh=DUfuHFIan7YikCK757QFEnJSWizcpjwTGGA6kphbrOg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w3PoXPWJ5YENvHBnUDgoSDq+ttK53n8mbXgrYDh6uG2YlNgas5+RQsLNi/+kNnL+K
         RSFVjN143GyiwBrrdCiC35DGaPHD+y3/fs1YXKSTzS1aZrKxgntd9kFkbpB2ihz/nj
         oukCZzckwFDc5qDABa1Wdhv5N6bKfMZfcdoJhcA8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.12 085/700] iio: frequency: adf4350: disable reg and clk on error in adf4350_probe()
Date:   Mon, 12 Jul 2021 08:02:48 +0200
Message-Id: <20210712060936.705272543@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
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


