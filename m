Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 236A63ED5F7
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:17:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239696AbhHPNQJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:16:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:37184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238046AbhHPNM7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:12:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 684D8632A8;
        Mon, 16 Aug 2021 13:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119428;
        bh=Zs91IUOg8YGIl26LLlpmQ/LtLCLzJsR+KmZ4cVyeSLg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jJ+vS6jyCN6bnw4W4Bg+fLkOOMBD2FKyy24ph0TDTAPK6VqCxBsC0p7i1oyozxqhN
         8IO2xT7wt5ikbiDu5tAKAvAKjy2tt9/yVyWhA4lA8oG8Yythby7ylc0Hlwj7JcNfFa
         eiBHEMKmep7YisXzTUdHQkihLjIB0bnEKP+CHvE0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hannu Hartikainen <hannu@hrtk.in>,
        =?UTF-8?q?Antti=20Ker=C3=A4nen?= <detegr@rbx.email>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.13 004/151] iio: adis: set GPIO reset pin direction
Date:   Mon, 16 Aug 2021 15:00:34 +0200
Message-Id: <20210816125444.229462613@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125444.082226187@linuxfoundation.org>
References: <20210816125444.082226187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Antti Keränen <detegr@rbx.email>

commit 7e77ef8b8d600cf8448a2bbd32f682c28884551f upstream.

Set reset pin direction to output as the reset pin needs to be an active
low output pin.

Co-developed-by: Hannu Hartikainen <hannu@hrtk.in>
Signed-off-by: Hannu Hartikainen <hannu@hrtk.in>
Signed-off-by: Antti Keränen <detegr@rbx.email>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Fixes: ecb010d44108 ("iio: imu: adis: Refactor adis_initial_startup")
Link: https://lore.kernel.org/r/20210708095425.13295-1-detegr@rbx.email
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/adis.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/iio/imu/adis.c
+++ b/drivers/iio/imu/adis.c
@@ -415,12 +415,11 @@ int __adis_initial_startup(struct adis *
 	int ret;
 
 	/* check if the device has rst pin low */
-	gpio = devm_gpiod_get_optional(&adis->spi->dev, "reset", GPIOD_ASIS);
+	gpio = devm_gpiod_get_optional(&adis->spi->dev, "reset", GPIOD_OUT_HIGH);
 	if (IS_ERR(gpio))
 		return PTR_ERR(gpio);
 
 	if (gpio) {
-		gpiod_set_value_cansleep(gpio, 1);
 		msleep(10);
 		/* bring device out of reset */
 		gpiod_set_value_cansleep(gpio, 0);


