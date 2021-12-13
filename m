Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD6F747257D
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:44:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235614AbhLMJoB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:44:01 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:56148 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235592AbhLMJmI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:42:08 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D8CFCB80E0B;
        Mon, 13 Dec 2021 09:42:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 265ABC341C5;
        Mon, 13 Dec 2021 09:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388525;
        bh=Bqm4uNLeZnbvldjYex0G4C8ThaOGvMgc/e1N8u7oayY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qvxmma0oExYVTB3g7t7FwaiZRGrxFb397F4Hz2o17NPCbeBS3eo4QIi9pFU6gWJzr
         bOMjiunU1IXszt06R06QYjhJrRl54YDMr6szmH6XU26RaJg1jKuzzE3CUCVU5GHYev
         SJPwPtUJyhfzmBAT1oCCUVev4zWtWTkIb8tCevEw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evgeny Boger <boger@wirenboard.com>,
        Chen-Yu Tsai <wens@csie.org>, Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 4.19 67/74] iio: adc: axp20x_adc: fix charging current reporting on AXP22x
Date:   Mon, 13 Dec 2021 10:30:38 +0100
Message-Id: <20211213092933.031421622@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092930.763200615@linuxfoundation.org>
References: <20211213092930.763200615@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Evgeny Boger <boger@wirenboard.com>

commit 92beafb76a31bdc02649eb44e93a8e4f4cfcdbe8 upstream.

Both the charging and discharging currents on AXP22x are stored as
12-bit integers, in accordance with the datasheet.
It's also confirmed by vendor BSP (axp20x_adc.c:axp22_icharge_to_mA).

The scale factor of 0.5 is never mentioned in datasheet, nor in the
vendor source code. I think it was here to compensate for
erroneous addition bit in register width.

Tested on custom A40i+AXP221s board with external ammeter as
a reference.

Fixes: 0e34d5de961d ("iio: adc: add support for X-Powers AXP20X and AXP22X PMICs ADCs")
Signed-off-by: Evgeny Boger <boger@wirenboard.com>
Acked-by: Chen-Yu Tsai <wens@csie.org>
Link: https://lore.kernel.org/r/20211116213746.264378-1-boger@wirenboard.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/axp20x_adc.c |   18 +++---------------
 1 file changed, 3 insertions(+), 15 deletions(-)

--- a/drivers/iio/adc/axp20x_adc.c
+++ b/drivers/iio/adc/axp20x_adc.c
@@ -254,19 +254,8 @@ static int axp22x_adc_raw(struct iio_dev
 			  struct iio_chan_spec const *chan, int *val)
 {
 	struct axp20x_adc_iio *info = iio_priv(indio_dev);
-	int size;
 
-	/*
-	 * N.B.: Unlike the Chinese datasheets tell, the charging current is
-	 * stored on 12 bits, not 13 bits. Only discharging current is on 13
-	 * bits.
-	 */
-	if (chan->type == IIO_CURRENT && chan->channel == AXP22X_BATT_DISCHRG_I)
-		size = 13;
-	else
-		size = 12;
-
-	*val = axp20x_read_variable_width(info->regmap, chan->address, size);
+	*val = axp20x_read_variable_width(info->regmap, chan->address, 12);
 	if (*val < 0)
 		return *val;
 
@@ -389,9 +378,8 @@ static int axp22x_adc_scale(struct iio_c
 		return IIO_VAL_INT_PLUS_MICRO;
 
 	case IIO_CURRENT:
-		*val = 0;
-		*val2 = 500000;
-		return IIO_VAL_INT_PLUS_MICRO;
+		*val = 1;
+		return IIO_VAL_INT;
 
 	case IIO_TEMP:
 		*val = 100;


