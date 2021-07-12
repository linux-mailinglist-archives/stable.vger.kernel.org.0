Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D3603C4775
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:27:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235732AbhGLGct (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:32:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:48076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235932AbhGLG3j (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:29:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B2EFB61178;
        Mon, 12 Jul 2021 06:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071177;
        bh=D5QZadi8h3+cAVvfp85hCZiVetkC5sAbPDBiKaoVXdY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IyssuXZzNZlD3UyRvq8u8KLZXIvpi7wWiGNeKy5FcfyFdqp2z1x19bN8PDnh+x3ar
         T7uELWRoKAQ4aLyz50Mb1ufkHk8wuK1RPiLvpByGq0ctZYIsmgmka5/XmxX1wqCO8e
         VuqeKVCCo5ErpC+ROjS7+3ZivltopYJ6DMsq5RsQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 308/348] iio: at91-sama5d2_adc: remove usage of iio_priv_to_dev() helper
Date:   Mon, 12 Jul 2021 08:11:32 +0200
Message-Id: <20210712060744.623900605@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060659.886176320@linuxfoundation.org>
References: <20210712060659.886176320@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandru Ardelean <alexandru.ardelean@analog.com>

[ Upstream commit ebf35aad0baa05823df31fda42df4b67f72e6e72 ]

We may want to get rid of the iio_priv_to_dev() helper. The reason is that
we will hide some of the members of the iio_dev structure (to prevent
drivers from accessing them directly), and that will also mean hiding the
implementation of the iio_priv_to_dev() helper inside the IIO core.

Hiding the implementation of iio_priv_to_dev() implies that some fast-paths
may not be fast anymore, so a general idea is to try to get rid of the
iio_priv_to_dev() altogether.
The iio_priv() helper won't be affected by the rework, as the iio_dev
struct will keep a reference to the private information.

For this driver, not using iio_priv_to_dev(), means reworking some paths to
pass the iio device and using iio_priv() to access the private information,
and also keeping a reference to the iio device for some quirky paths.

One [quirky] path is the at91_adc_workq_handler() which requires the IIO
device & the state struct to push to buffers.
Since this requires the back-ref to the IIO device, the
at91_adc_touch_pos() also uses it. This simplifies the patch a bit. The
information required in this function is mostly for debugging purposes.
Replacing it with a reference to the IIO device would have been a slightly
bigger change, which may not be worth it (for just the debugging purpose
and given that we need the back-ref to the IIO device anyway).

Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/at91-sama5d2_adc.c | 30 +++++++++++++++++-------------
 1 file changed, 17 insertions(+), 13 deletions(-)

diff --git a/drivers/iio/adc/at91-sama5d2_adc.c b/drivers/iio/adc/at91-sama5d2_adc.c
index 2c01963a6a5c..bafb9dded0ea 100644
--- a/drivers/iio/adc/at91-sama5d2_adc.c
+++ b/drivers/iio/adc/at91-sama5d2_adc.c
@@ -399,6 +399,7 @@ struct at91_adc_state {
 	wait_queue_head_t		wq_data_available;
 	struct at91_adc_dma		dma_st;
 	struct at91_adc_touch		touch_st;
+	struct iio_dev			*indio_dev;
 	u16				buffer[AT91_BUFFER_MAX_HWORDS];
 	/*
 	 * lock to prevent concurrent 'single conversion' requests through
@@ -624,13 +625,13 @@ static u16 at91_adc_touch_pos(struct at91_adc_state *st, int reg)
 	/* first half of register is the x or y, second half is the scale */
 	val = at91_adc_readl(st, reg);
 	if (!val)
-		dev_dbg(&iio_priv_to_dev(st)->dev, "pos is 0\n");
+		dev_dbg(&st->indio_dev->dev, "pos is 0\n");
 
 	pos = val & AT91_SAMA5D2_XYZ_MASK;
 	result = (pos << AT91_SAMA5D2_MAX_POS_BITS) - pos;
 	scale = (val >> 16) & AT91_SAMA5D2_XYZ_MASK;
 	if (scale == 0) {
-		dev_err(&iio_priv_to_dev(st)->dev, "scale is 0\n");
+		dev_err(&st->indio_dev->dev, "scale is 0\n");
 		return 0;
 	}
 	result /= scale;
@@ -1154,9 +1155,9 @@ static unsigned at91_adc_startup_time(unsigned startup_time_min,
 	return i;
 }
 
-static void at91_adc_setup_samp_freq(struct at91_adc_state *st, unsigned freq)
+static void at91_adc_setup_samp_freq(struct iio_dev *indio_dev, unsigned freq)
 {
-	struct iio_dev *indio_dev = iio_priv_to_dev(st);
+	struct at91_adc_state *st = iio_priv(indio_dev);
 	unsigned f_per, prescal, startup, mr;
 
 	f_per = clk_get_rate(st->per_clk);
@@ -1225,9 +1226,9 @@ static void at91_adc_pen_detect_interrupt(struct at91_adc_state *st)
 	st->touch_st.touching = true;
 }
 
-static void at91_adc_no_pen_detect_interrupt(struct at91_adc_state *st)
+static void at91_adc_no_pen_detect_interrupt(struct iio_dev *indio_dev)
 {
-	struct iio_dev *indio_dev = iio_priv_to_dev(st);
+	struct at91_adc_state *st = iio_priv(indio_dev);
 
 	at91_adc_writel(st, AT91_SAMA5D2_TRGR,
 			AT91_SAMA5D2_TRGR_TRGMOD_NO_TRIGGER);
@@ -1247,7 +1248,7 @@ static void at91_adc_workq_handler(struct work_struct *workq)
 					struct at91_adc_touch, workq);
 	struct at91_adc_state *st = container_of(touch_st,
 					struct at91_adc_state, touch_st);
-	struct iio_dev *indio_dev = iio_priv_to_dev(st);
+	struct iio_dev *indio_dev = st->indio_dev;
 
 	iio_push_to_buffers(indio_dev, st->buffer);
 }
@@ -1268,7 +1269,7 @@ static irqreturn_t at91_adc_interrupt(int irq, void *private)
 		at91_adc_pen_detect_interrupt(st);
 	} else if ((status & AT91_SAMA5D2_IER_NOPEN)) {
 		/* nopen detected IRQ */
-		at91_adc_no_pen_detect_interrupt(st);
+		at91_adc_no_pen_detect_interrupt(indio);
 	} else if ((status & AT91_SAMA5D2_ISR_PENS) &&
 		   ((status & rdy_mask) == rdy_mask)) {
 		/* periodic trigger IRQ - during pen sense */
@@ -1435,7 +1436,7 @@ static int at91_adc_write_raw(struct iio_dev *indio_dev,
 		    val > st->soc_info.max_sample_rate)
 			return -EINVAL;
 
-		at91_adc_setup_samp_freq(st, val);
+		at91_adc_setup_samp_freq(indio_dev, val);
 		return 0;
 	default:
 		return -EINVAL;
@@ -1573,8 +1574,10 @@ static int at91_adc_update_scan_mode(struct iio_dev *indio_dev,
 	return 0;
 }
 
-static void at91_adc_hw_init(struct at91_adc_state *st)
+static void at91_adc_hw_init(struct iio_dev *indio_dev)
 {
+	struct at91_adc_state *st = iio_priv(indio_dev);
+
 	at91_adc_writel(st, AT91_SAMA5D2_CR, AT91_SAMA5D2_CR_SWRST);
 	at91_adc_writel(st, AT91_SAMA5D2_IDR, 0xffffffff);
 	/*
@@ -1584,7 +1587,7 @@ static void at91_adc_hw_init(struct at91_adc_state *st)
 	at91_adc_writel(st, AT91_SAMA5D2_MR,
 			AT91_SAMA5D2_MR_TRANSFER(2) | AT91_SAMA5D2_MR_ANACH);
 
-	at91_adc_setup_samp_freq(st, st->soc_info.min_sample_rate);
+	at91_adc_setup_samp_freq(indio_dev, st->soc_info.min_sample_rate);
 
 	/* configure extended mode register */
 	at91_adc_config_emr(st);
@@ -1667,6 +1670,7 @@ static int at91_adc_probe(struct platform_device *pdev)
 	indio_dev->num_channels = ARRAY_SIZE(at91_adc_channels);
 
 	st = iio_priv(indio_dev);
+	st->indio_dev = indio_dev;
 
 	bitmap_set(&st->touch_st.channels_bitmask,
 		   AT91_SAMA5D2_TOUCH_X_CHAN_IDX, 1);
@@ -1778,7 +1782,7 @@ static int at91_adc_probe(struct platform_device *pdev)
 		goto vref_disable;
 	}
 
-	at91_adc_hw_init(st);
+	at91_adc_hw_init(indio_dev);
 
 	ret = clk_prepare_enable(st->per_clk);
 	if (ret)
@@ -1894,7 +1898,7 @@ static __maybe_unused int at91_adc_resume(struct device *dev)
 	if (ret)
 		goto vref_disable_resume;
 
-	at91_adc_hw_init(st);
+	at91_adc_hw_init(indio_dev);
 
 	/* reconfiguring trigger hardware state */
 	if (!iio_buffer_enabled(indio_dev))
-- 
2.30.2



