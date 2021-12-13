Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D728472A5B
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:40:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243185AbhLMKj6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:39:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244226AbhLMKjs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 05:39:48 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A5CDC08EC70;
        Mon, 13 Dec 2021 01:52:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 76DE2CE0E7D;
        Mon, 13 Dec 2021 09:52:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22B08C00446;
        Mon, 13 Dec 2021 09:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389144;
        bh=lujrZBCoAyyE7Zc4QDqaa8wcKuPXGjH4z1p1kBbQ8Ig=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nuHHwpYPgOFXhWweMeKbD051gxLApPOTzAZZf3ehCNOK5IbYxErUdsP2oHT+D7Rli
         wGCWA6ikGW9xdEO2QKChJnzTWl6dUgAVg1w+GaaXNLIBoEJz0ouFW+bvllmAabb2uu
         kG4y9htbIbsQf04BJ6dzcMKE3Mx5PtxkTZc0ur6g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evgeny Boger <boger@wirenboard.com>,
        Chen-Yu Tsai <wens@csie.org>, Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.10 118/132] iio: adc: axp20x_adc: fix charging current reporting on AXP22x
Date:   Mon, 13 Dec 2021 10:30:59 +0100
Message-Id: <20211213092943.145446843@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092939.074326017@linuxfoundation.org>
References: <20211213092939.074326017@linuxfoundation.org>
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
@@ -251,19 +251,8 @@ static int axp22x_adc_raw(struct iio_dev
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
 
@@ -386,9 +375,8 @@ static int axp22x_adc_scale(struct iio_c
 		return IIO_VAL_INT_PLUS_MICRO;
 
 	case IIO_CURRENT:
-		*val = 0;
-		*val2 = 500000;
-		return IIO_VAL_INT_PLUS_MICRO;
+		*val = 1;
+		return IIO_VAL_INT;
 
 	case IIO_TEMP:
 		*val = 100;


