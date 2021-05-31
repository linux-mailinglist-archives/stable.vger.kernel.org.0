Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 379B1395E2A
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:53:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231889AbhEaNzS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:55:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:54768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232805AbhEaNws (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:52:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6EE4461435;
        Mon, 31 May 2021 13:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467975;
        bh=ynVL04ift/6egESuTKn/Fk2adUED9rKiBWSXS2RVsvc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iAxOknIv8cDiIF3xn+JkhwiESqtoXM0+W+xLxmucZSSMse4K8vQ6neawdcyIdjZTs
         TiR2zG0jwe9jDyj5zwG2v/BPCjjConqYYSahxccOBaxku3WuUhCoZyrflXTeh5LIaR
         Ur/H5pwsjqjyDCS/wYYSCD1eLjHQ8QVtnvrMxdb4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexandru Tachici <alexandru.tachici@analog.com>,
        Alexandru Ardelean <aardelean@deviqon.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Stable@vger.kernel.org
Subject: [PATCH 5.10 069/252] iio: adc: ad7192: handle regulator voltage error first
Date:   Mon, 31 May 2021 15:12:14 +0200
Message-Id: <20210531130700.334230098@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130657.971257589@linuxfoundation.org>
References: <20210531130657.971257589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandru Ardelean <aardelean@deviqon.com>

commit b0f27fca5a6c7652e265aae6a4452ce2f2ed64da upstream.

This change fixes a corner-case, where for a zero regulator value, the
driver would exit early, initializing the driver only partially.
The driver would be in an unknown state.

This change reworks the code to check regulator_voltage() return value
for negative (error) first, and return early. This is the more common
idiom.

Also, this change is removing the 'voltage_uv' variable and using the 'ret'
value directly. The only place where 'voltage_uv' is being used is to
compute the internal reference voltage, and the type of this variable is
'int' (same are for 'ret'). Using only 'ret' avoids having to assign it on
the error path.

Fixes: ab0afa65bbc7 ("staging: iio: adc: ad7192: fail probe on get_voltage")
Cc: Alexandru Tachici <alexandru.tachici@analog.com>
Signed-off-by: Alexandru Ardelean <aardelean@deviqon.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ad7192.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

--- a/drivers/iio/adc/ad7192.c
+++ b/drivers/iio/adc/ad7192.c
@@ -912,7 +912,7 @@ static int ad7192_probe(struct spi_devic
 {
 	struct ad7192_state *st;
 	struct iio_dev *indio_dev;
-	int ret, voltage_uv = 0;
+	int ret;
 
 	if (!spi->irq) {
 		dev_err(&spi->dev, "no IRQ?\n");
@@ -949,15 +949,12 @@ static int ad7192_probe(struct spi_devic
 		goto error_disable_avdd;
 	}
 
-	voltage_uv = regulator_get_voltage(st->avdd);
-
-	if (voltage_uv > 0) {
-		st->int_vref_mv = voltage_uv / 1000;
-	} else {
-		ret = voltage_uv;
+	ret = regulator_get_voltage(st->avdd);
+	if (ret < 0) {
 		dev_err(&spi->dev, "Device tree error, reference voltage undefined\n");
 		goto error_disable_avdd;
 	}
+	st->int_vref_mv = ret / 1000;
 
 	spi_set_drvdata(spi, indio_dev);
 	st->chip_info = of_device_get_match_data(&spi->dev);


