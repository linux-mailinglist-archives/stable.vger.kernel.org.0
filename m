Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52D0646D3CF
	for <lists+stable@lfdr.de>; Wed,  8 Dec 2021 13:54:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233854AbhLHM6Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Dec 2021 07:58:16 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:48188 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229743AbhLHM6Q (ORCPT
        <rfc822;Stable@vger.kernel.org>); Wed, 8 Dec 2021 07:58:16 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6507CCE216D
        for <Stable@vger.kernel.org>; Wed,  8 Dec 2021 12:54:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14F3CC00446;
        Wed,  8 Dec 2021 12:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638968080;
        bh=oHzYZwN+rX8vBUD3UkuiVBxxS5J9lyjvywee5NKPWP8=;
        h=Subject:To:From:Date:From;
        b=0MlKXFDj8sN10kxnds1SnrgphbEHRt9hVowcmd4PnN8eahdhKpmRMWuND6cbjLule
         0uUhhXB4NeQtEOGeNGRw3wnKEwTdPU2f0EUKAAbwCRFHCK8I7hiwgvHSNfVufkrLpe
         jMdAexCO9IcrEpvgBAWYgktbaH1UqtCOHAjuq+IU=
Subject: patch "iio: adc: axp20x_adc: fix charging current reporting on AXP22x" added to char-misc-linus
To:     boger@wirenboard.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, wens@csie.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 08 Dec 2021 13:53:58 +0100
Message-ID: <16389680383192@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: adc: axp20x_adc: fix charging current reporting on AXP22x

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 92beafb76a31bdc02649eb44e93a8e4f4cfcdbe8 Mon Sep 17 00:00:00 2001
From: Evgeny Boger <boger@wirenboard.com>
Date: Wed, 17 Nov 2021 00:37:46 +0300
Subject: iio: adc: axp20x_adc: fix charging current reporting on AXP22x

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
---
 drivers/iio/adc/axp20x_adc.c | 18 +++---------------
 1 file changed, 3 insertions(+), 15 deletions(-)

diff --git a/drivers/iio/adc/axp20x_adc.c b/drivers/iio/adc/axp20x_adc.c
index 3e0c0233b431..df99f1365c39 100644
--- a/drivers/iio/adc/axp20x_adc.c
+++ b/drivers/iio/adc/axp20x_adc.c
@@ -251,19 +251,8 @@ static int axp22x_adc_raw(struct iio_dev *indio_dev,
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
 
@@ -386,9 +375,8 @@ static int axp22x_adc_scale(struct iio_chan_spec const *chan, int *val,
 		return IIO_VAL_INT_PLUS_MICRO;
 
 	case IIO_CURRENT:
-		*val = 0;
-		*val2 = 500000;
-		return IIO_VAL_INT_PLUS_MICRO;
+		*val = 1;
+		return IIO_VAL_INT;
 
 	case IIO_TEMP:
 		*val = 100;
-- 
2.34.1


