Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C669F3C47F6
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:28:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236200AbhGLGfb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:35:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:54932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237287AbhGLGeQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:34:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 893B961179;
        Mon, 12 Jul 2021 06:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071441;
        bh=DUfuHFIan7YikCK757QFEnJSWizcpjwTGGA6kphbrOg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VEpQw2v/O4od9+yIPv35aTPvoOMnPW/JB7WRgGNZU+3pN01Kmxbb3Hctnh2037abx
         iviV7zEvAalxxxMhOA8dNF47EHmftF/xNRT8Fv033u5UL2rcbpB9G+meLIL3Jx98Jt
         5B6dEmDA1Htn/AJpCqRBVra/yFeryqZv1RybVs4g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.10 072/593] iio: frequency: adf4350: disable reg and clk on error in adf4350_probe()
Date:   Mon, 12 Jul 2021 08:03:52 +0200
Message-Id: <20210712060851.062365994@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
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


