Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D4F32A5838
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:50:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729149AbgKCVtv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:49:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:42536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731566AbgKCUta (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:49:30 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D76E52242A;
        Tue,  3 Nov 2020 20:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436569;
        bh=qYjs7RLvnGoWpCuN8en2y4tkw6+i3gHtcyqfSxCnruI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ve/PPVpT128Zg5pGr7X0O/jL6gUW+rkHugldxAE76UMczthRXpue4BNPD0VvdxdTZ
         R3F6UFDunwRpTRWDKg0kPGHWm4mKfy4UDTOoSe09EYcNYamzBaocBlBJpIxgUOYX7W
         7TNO/gVT99XGONyKOS9yqc6u2+ZrGHcMv/1KSKCE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Eugen Hristev <eugen.hristev@microchip.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.9 269/391] iio: adc: at91-sama5d2_adc: fix DMA conversion crash
Date:   Tue,  3 Nov 2020 21:35:20 +0100
Message-Id: <20201103203405.180495932@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eugen Hristev <eugen.hristev@microchip.com>

commit 1a198794451449113fa86994ed491d6986802c23 upstream.

After the move of the postenable code to preenable, the DMA start was
done before the DMA init, which is not correct.
The DMA is initialized in set_watermark. Because of this, we need to call
the DMA start functions in set_watermark, after the DMA init, instead of
preenable hook, when the DMA is not properly setup yet.

Fixes: f3c034f61775 ("iio: at91-sama5d2_adc: adjust iio_triggered_buffer_{predisable,postenable} positions")
Signed-off-by: Eugen Hristev <eugen.hristev@microchip.com>
Link: https://lore.kernel.org/r/20200923121748.49384-1-eugen.hristev@microchip.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/adc/at91-sama5d2_adc.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/drivers/iio/adc/at91-sama5d2_adc.c
+++ b/drivers/iio/adc/at91-sama5d2_adc.c
@@ -884,7 +884,7 @@ static bool at91_adc_current_chan_is_tou
 			       AT91_SAMA5D2_MAX_CHAN_IDX + 1);
 }
 
-static int at91_adc_buffer_preenable(struct iio_dev *indio_dev)
+static int at91_adc_buffer_prepare(struct iio_dev *indio_dev)
 {
 	int ret;
 	u8 bit;
@@ -901,7 +901,7 @@ static int at91_adc_buffer_preenable(str
 	/* we continue with the triggered buffer */
 	ret = at91_adc_dma_start(indio_dev);
 	if (ret) {
-		dev_err(&indio_dev->dev, "buffer postenable failed\n");
+		dev_err(&indio_dev->dev, "buffer prepare failed\n");
 		return ret;
 	}
 
@@ -989,7 +989,6 @@ static int at91_adc_buffer_postdisable(s
 }
 
 static const struct iio_buffer_setup_ops at91_buffer_setup_ops = {
-	.preenable = &at91_adc_buffer_preenable,
 	.postdisable = &at91_adc_buffer_postdisable,
 };
 
@@ -1563,6 +1562,7 @@ static void at91_adc_dma_disable(struct
 static int at91_adc_set_watermark(struct iio_dev *indio_dev, unsigned int val)
 {
 	struct at91_adc_state *st = iio_priv(indio_dev);
+	int ret;
 
 	if (val > AT91_HWFIFO_MAX_SIZE)
 		return -EINVAL;
@@ -1586,7 +1586,15 @@ static int at91_adc_set_watermark(struct
 	else if (val > 1)
 		at91_adc_dma_init(to_platform_device(&indio_dev->dev));
 
-	return 0;
+	/*
+	 * We can start the DMA only after setting the watermark and
+	 * having the DMA initialization completed
+	 */
+	ret = at91_adc_buffer_prepare(indio_dev);
+	if (ret)
+		at91_adc_dma_disable(to_platform_device(&indio_dev->dev));
+
+	return ret;
 }
 
 static int at91_adc_update_scan_mode(struct iio_dev *indio_dev,


