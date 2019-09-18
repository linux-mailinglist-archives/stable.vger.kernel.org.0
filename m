Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD8A3B5C87
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 08:27:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727833AbfIRG1T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 02:27:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:49058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730484AbfIRG1Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Sep 2019 02:27:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 32E2E21925;
        Wed, 18 Sep 2019 06:27:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568788035;
        bh=5cgyMrQlcGbBH7HYdOGNmvUJ1xFMujSwA8nnLemSWps=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GbYxQ7pnMHWQqi9nUSPJnTvtpOUGMp2l+nnilp+LLwij6bISQX57BpSdyt7vLiM1W
         6+J69xnWP/vMnH5Ur8CJstdE6qQavZs2kKrAxMGRUt8waBVJGVaQ3k/bpSU4Utnqio
         yj+ViE0tCRL/sVKLqCRMFkv7vv3B4C7tokGcLmfc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Olivier Moysan <olivier.moysan@st.com>,
        Fabrice Gasnier <fabrice.gasnier@st.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.2 75/85] iio: adc: stm32-dfsdm: fix output resolution
Date:   Wed, 18 Sep 2019 08:19:33 +0200
Message-Id: <20190918061237.768624822@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190918061234.107708857@linuxfoundation.org>
References: <20190918061234.107708857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Olivier Moysan <olivier.moysan@st.com>

commit 12c8398d8012ead3d3d68422067ab2f9a66ae76a upstream.

In buffered mode, output samples are shifted left
unconditionally. This works for filter order 3,
but this shift is not adapted for other filter orders.
Compute required shift, left or right, and shift
output data accordingly.
Add also saturation management to avoid wrap-around
when maximum positive sample is reached.

Signed-off-by: Olivier Moysan <olivier.moysan@st.com>
Fixes: eca949800d2d ("IIO: ADC: add stm32 DFSDM support for PDM microphone")
Acked-by: Fabrice Gasnier <fabrice.gasnier@st.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/adc/stm32-dfsdm-adc.c |  158 +++++++++++++++++++++++++++++---------
 drivers/iio/adc/stm32-dfsdm.h     |   24 ++++-
 2 files changed, 142 insertions(+), 40 deletions(-)

--- a/drivers/iio/adc/stm32-dfsdm-adc.c
+++ b/drivers/iio/adc/stm32-dfsdm-adc.c
@@ -39,9 +39,16 @@
 #define DFSDM_MAX_INT_OVERSAMPLING 256
 #define DFSDM_MAX_FL_OVERSAMPLING 1024
 
-/* Max sample resolutions */
-#define DFSDM_MAX_RES BIT(31)
-#define DFSDM_DATA_RES BIT(23)
+/* Limit filter output resolution to 31 bits. (i.e. sample range is +/-2^30) */
+#define DFSDM_DATA_MAX BIT(30)
+/*
+ * Data are output as two's complement data in a 24 bit field.
+ * Data from filters are in the range +/-2^(n-1)
+ * 2^(n-1) maximum positive value cannot be coded in 2's complement n bits
+ * An extra bit is required to avoid wrap-around of the binary code for 2^(n-1)
+ * So, the resolution of samples from filter is actually limited to 23 bits
+ */
+#define DFSDM_DATA_RES 24
 
 /* Filter configuration */
 #define DFSDM_CR1_CFG_MASK (DFSDM_CR1_RCH_MASK | DFSDM_CR1_RCONT_MASK | \
@@ -181,14 +188,15 @@ static int stm32_dfsdm_get_jextsel(struc
 	return -EINVAL;
 }
 
-static int stm32_dfsdm_set_osrs(struct stm32_dfsdm_filter *fl,
-				unsigned int fast, unsigned int oversamp)
+static int stm32_dfsdm_compute_osrs(struct stm32_dfsdm_filter *fl,
+				    unsigned int fast, unsigned int oversamp)
 {
 	unsigned int i, d, fosr, iosr;
-	u64 res;
-	s64 delta;
+	u64 res, max;
+	int bits, shift;
 	unsigned int m = 1;	/* multiplication factor */
 	unsigned int p = fl->ford;	/* filter order (ford) */
+	struct stm32_dfsdm_filter_osr *flo = &fl->flo;
 
 	pr_debug("%s: Requested oversampling: %d\n",  __func__, oversamp);
 	/*
@@ -207,11 +215,9 @@ static int stm32_dfsdm_set_osrs(struct s
 
 	/*
 	 * Look for filter and integrator oversampling ratios which allows
-	 * to reach 24 bits data output resolution.
-	 * Leave as soon as if exact resolution if reached.
-	 * Otherwise the higher resolution below 32 bits is kept.
+	 * to maximize data output resolution.
 	 */
-	fl->res = 0;
+	flo->res = 0;
 	for (fosr = 1; fosr <= DFSDM_MAX_FL_OVERSAMPLING; fosr++) {
 		for (iosr = 1; iosr <= DFSDM_MAX_INT_OVERSAMPLING; iosr++) {
 			if (fast)
@@ -236,32 +242,68 @@ static int stm32_dfsdm_set_osrs(struct s
 			res = fosr;
 			for (i = p - 1; i > 0; i--) {
 				res = res * (u64)fosr;
-				if (res > DFSDM_MAX_RES)
+				if (res > DFSDM_DATA_MAX)
 					break;
 			}
-			if (res > DFSDM_MAX_RES)
+			if (res > DFSDM_DATA_MAX)
 				continue;
+
 			res = res * (u64)m * (u64)iosr;
-			if (res > DFSDM_MAX_RES)
+			if (res > DFSDM_DATA_MAX)
 				continue;
 
-			delta = res - DFSDM_DATA_RES;
-
-			if (res >= fl->res) {
-				fl->res = res;
-				fl->fosr = fosr;
-				fl->iosr = iosr;
-				fl->fast = fast;
-				pr_debug("%s: fosr = %d, iosr = %d\n",
-					 __func__, fl->fosr, fl->iosr);
+			if (res >= flo->res) {
+				flo->res = res;
+				flo->fosr = fosr;
+				flo->iosr = iosr;
+
+				bits = fls(flo->res);
+				/* 8 LBSs in data register contain chan info */
+				max = flo->res << 8;
+
+				/* if resolution is not a power of two */
+				if (flo->res > BIT(bits - 1))
+					bits++;
+				else
+					max--;
+
+				shift = DFSDM_DATA_RES - bits;
+				/*
+				 * Compute right/left shift
+				 * Right shift is performed by hardware
+				 * when transferring samples to data register.
+				 * Left shift is done by software on buffer
+				 */
+				if (shift > 0) {
+					/* Resolution is lower than 24 bits */
+					flo->rshift = 0;
+					flo->lshift = shift;
+				} else {
+					/*
+					 * If resolution is 24 bits or more,
+					 * max positive value may be ambiguous
+					 * (equal to max negative value as sign
+					 * bit is dropped).
+					 * Reduce resolution to 23 bits (rshift)
+					 * to keep the sign on bit 23 and treat
+					 * saturation before rescaling on 24
+					 * bits (lshift).
+					 */
+					flo->rshift = 1 - shift;
+					flo->lshift = 1;
+					max >>= flo->rshift;
+				}
+				flo->max = (s32)max;
+
+				pr_debug("%s: fast %d, fosr %d, iosr %d, res 0x%llx/%d bits, rshift %d, lshift %d\n",
+					 __func__, fast, flo->fosr, flo->iosr,
+					 flo->res, bits, flo->rshift,
+					 flo->lshift);
 			}
-
-			if (!delta)
-				return 0;
 		}
 	}
 
-	if (!fl->res)
+	if (!flo->res)
 		return -EINVAL;
 
 	return 0;
@@ -384,6 +426,36 @@ static int stm32_dfsdm_filter_set_trig(s
 	return 0;
 }
 
+static int stm32_dfsdm_channels_configure(struct stm32_dfsdm_adc *adc,
+					  unsigned int fl_id,
+					  struct iio_trigger *trig)
+{
+	struct iio_dev *indio_dev = iio_priv_to_dev(adc);
+	struct regmap *regmap = adc->dfsdm->regmap;
+	struct stm32_dfsdm_filter *fl = &adc->dfsdm->fl_list[fl_id];
+	struct stm32_dfsdm_filter_osr *flo = &fl->flo;
+	const struct iio_chan_spec *chan;
+	unsigned int bit;
+	int ret;
+
+	if (!flo->res)
+		return -EINVAL;
+
+	for_each_set_bit(bit, &adc->smask,
+			 sizeof(adc->smask) * BITS_PER_BYTE) {
+		chan = indio_dev->channels + bit;
+
+		ret = regmap_update_bits(regmap,
+					 DFSDM_CHCFGR2(chan->channel),
+					 DFSDM_CHCFGR2_DTRBS_MASK,
+					 DFSDM_CHCFGR2_DTRBS(flo->rshift));
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
 static int stm32_dfsdm_filter_configure(struct stm32_dfsdm_adc *adc,
 					unsigned int fl_id,
 					struct iio_trigger *trig)
@@ -391,6 +463,7 @@ static int stm32_dfsdm_filter_configure(
 	struct iio_dev *indio_dev = iio_priv_to_dev(adc);
 	struct regmap *regmap = adc->dfsdm->regmap;
 	struct stm32_dfsdm_filter *fl = &adc->dfsdm->fl_list[fl_id];
+	struct stm32_dfsdm_filter_osr *flo = &fl->flo;
 	u32 cr1;
 	const struct iio_chan_spec *chan;
 	unsigned int bit, jchg = 0;
@@ -398,13 +471,13 @@ static int stm32_dfsdm_filter_configure(
 
 	/* Average integrator oversampling */
 	ret = regmap_update_bits(regmap, DFSDM_FCR(fl_id), DFSDM_FCR_IOSR_MASK,
-				 DFSDM_FCR_IOSR(fl->iosr - 1));
+				 DFSDM_FCR_IOSR(flo->iosr - 1));
 	if (ret)
 		return ret;
 
 	/* Filter order and Oversampling */
 	ret = regmap_update_bits(regmap, DFSDM_FCR(fl_id), DFSDM_FCR_FOSR_MASK,
-				 DFSDM_FCR_FOSR(fl->fosr - 1));
+				 DFSDM_FCR_FOSR(flo->fosr - 1));
 	if (ret)
 		return ret;
 
@@ -573,7 +646,7 @@ static int dfsdm_adc_set_samp_freq(struc
 			"Rate not accurate. requested (%u), actual (%u)\n",
 			sample_freq, spi_freq / oversamp);
 
-	ret = stm32_dfsdm_set_osrs(fl, 0, oversamp);
+	ret = stm32_dfsdm_compute_osrs(fl, 0, oversamp);
 	if (ret < 0) {
 		dev_err(&indio_dev->dev, "No filter parameters that match!\n");
 		return ret;
@@ -623,6 +696,10 @@ static int stm32_dfsdm_start_conv(struct
 	struct regmap *regmap = adc->dfsdm->regmap;
 	int ret;
 
+	ret = stm32_dfsdm_channels_configure(adc, adc->fl_id, trig);
+	if (ret < 0)
+		return ret;
+
 	ret = stm32_dfsdm_start_channel(adc);
 	if (ret < 0)
 		return ret;
@@ -729,6 +806,8 @@ static void stm32_dfsdm_dma_buffer_done(
 {
 	struct iio_dev *indio_dev = data;
 	struct stm32_dfsdm_adc *adc = iio_priv(indio_dev);
+	struct stm32_dfsdm_filter *fl = &adc->dfsdm->fl_list[adc->fl_id];
+	struct stm32_dfsdm_filter_osr *flo = &fl->flo;
 	int available = stm32_dfsdm_adc_dma_residue(adc);
 	size_t old_pos;
 
@@ -751,10 +830,19 @@ static void stm32_dfsdm_dma_buffer_done(
 	old_pos = adc->bufi;
 
 	while (available >= indio_dev->scan_bytes) {
-		u32 *buffer = (u32 *)&adc->rx_buf[adc->bufi];
+		s32 *buffer = (s32 *)&adc->rx_buf[adc->bufi];
 
 		/* Mask 8 LSB that contains the channel ID */
-		*buffer = (*buffer & 0xFFFFFF00) << 8;
+		*buffer &= 0xFFFFFF00;
+		/* Convert 2^(n-1) sample to 2^(n-1)-1 to avoid wrap-around */
+		if (*buffer > flo->max)
+			*buffer -= 1;
+		/*
+		 * Samples from filter are retrieved with 23 bits resolution
+		 * or less. Shift left to align MSB on 24 bits.
+		 */
+		*buffer <<= flo->lshift;
+
 		available -= indio_dev->scan_bytes;
 		adc->bufi += indio_dev->scan_bytes;
 		if (adc->bufi >= adc->buf_sz) {
@@ -1078,7 +1166,7 @@ static int stm32_dfsdm_write_raw(struct
 		ret = iio_device_claim_direct_mode(indio_dev);
 		if (ret)
 			return ret;
-		ret = stm32_dfsdm_set_osrs(fl, 0, val);
+		ret = stm32_dfsdm_compute_osrs(fl, 0, val);
 		if (!ret)
 			adc->oversamp = val;
 		iio_device_release_direct_mode(indio_dev);
@@ -1327,8 +1415,8 @@ static int stm32_dfsdm_adc_init(struct i
 	int ret, chan_idx;
 
 	adc->oversamp = DFSDM_DEFAULT_OVERSAMPLING;
-	ret = stm32_dfsdm_set_osrs(&adc->dfsdm->fl_list[adc->fl_id], 0,
-				   adc->oversamp);
+	ret = stm32_dfsdm_compute_osrs(&adc->dfsdm->fl_list[adc->fl_id], 0,
+				       adc->oversamp);
 	if (ret < 0)
 		return ret;
 
--- a/drivers/iio/adc/stm32-dfsdm.h
+++ b/drivers/iio/adc/stm32-dfsdm.h
@@ -243,19 +243,33 @@ enum stm32_dfsdm_sinc_order {
 };
 
 /**
- * struct stm32_dfsdm_filter - structure relative to stm32 FDSDM filter
+ * struct stm32_dfsdm_filter_osr - DFSDM filter settings linked to oversampling
  * @iosr: integrator oversampling
  * @fosr: filter oversampling
- * @ford: filter order
+ * @rshift: output sample right shift (hardware shift)
+ * @lshift: output sample left shift (software shift)
  * @res: output sample resolution
+ * @max: output sample maximum positive value
+ */
+struct stm32_dfsdm_filter_osr {
+	unsigned int iosr;
+	unsigned int fosr;
+	unsigned int rshift;
+	unsigned int lshift;
+	u64 res;
+	s32 max;
+};
+
+/**
+ * struct stm32_dfsdm_filter - structure relative to stm32 FDSDM filter
+ * @ford: filter order
+ * @flo: filter oversampling structure
  * @sync_mode: filter synchronized with filter 0
  * @fast: filter fast mode
  */
 struct stm32_dfsdm_filter {
-	unsigned int iosr;
-	unsigned int fosr;
 	enum stm32_dfsdm_sinc_order ford;
-	u64 res;
+	struct stm32_dfsdm_filter_osr flo;
 	unsigned int sync_mode;
 	unsigned int fast;
 };


