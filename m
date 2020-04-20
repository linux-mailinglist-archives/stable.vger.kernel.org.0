Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 144311B08DF
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 14:09:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725886AbgDTMJU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 08:09:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:47656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726813AbgDTMJT (ORCPT <rfc822;Stable@vger.kernel.org>);
        Mon, 20 Apr 2020 08:09:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 056522075A;
        Mon, 20 Apr 2020 12:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587384558;
        bh=VJHpvIj0tfzqVOVTRoriHEyi42ENm1mtGVjMjBFCiV8=;
        h=Subject:To:From:Date:From;
        b=gi5r6CGte6iXh5s4MxQ6pEL9wDh68DLV92r0L57fkBbfT+pJAR/iEUam5OkrBsoGi
         J50zMJqA84jH0mWkdZpaSwYP9I5e8ulaNj2sbLc62sq+PgKHfnOkqKOX0U5mwAjpEB
         kT4iHhiuNcB7kd04d3+v+n+8DfukF50hzjf5mDl8=
Subject: patch "iio: xilinx-xadc: Make sure not exceed maximum samplerate" added to staging-linus
To:     lars@metafoo.de, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 Apr 2020 14:08:49 +0200
Message-ID: <15873845298361@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: xilinx-xadc: Make sure not exceed maximum samplerate

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 3b7f9dbb827ce8680b98490215e698b6079a9ec5 Mon Sep 17 00:00:00 2001
From: Lars-Peter Clausen <lars@metafoo.de>
Date: Fri, 3 Apr 2020 15:27:16 +0200
Subject: iio: xilinx-xadc: Make sure not exceed maximum samplerate

The XADC supports a samplerate of up to 1MSPS. Unfortunately the hardware
does not have a FIFO, which means it generates an interrupt for each
conversion sequence. At one 1MSPS this creates an interrupt storm that
causes the system to soft-lock.

For this reason the driver limits the maximum samplerate to 150kSPS.
Currently this check is only done when setting a new samplerate. But it is
also possible that the initial samplerate configured in the FPGA bitstream
exceeds the limit.

In this case when starting to capture data without first changing the
samplerate the system can overload.

To prevent this check the currently configured samplerate in the probe
function and reduce it to the maximum if necessary.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Fixes: bdc8cda1d010 ("iio:adc: Add Xilinx XADC driver")
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/adc/xilinx-xadc-core.c | 78 +++++++++++++++++++++++-------
 1 file changed, 60 insertions(+), 18 deletions(-)

diff --git a/drivers/iio/adc/xilinx-xadc-core.c b/drivers/iio/adc/xilinx-xadc-core.c
index 1aeaeafce589..6fd06e4eff73 100644
--- a/drivers/iio/adc/xilinx-xadc-core.c
+++ b/drivers/iio/adc/xilinx-xadc-core.c
@@ -102,6 +102,16 @@ static const unsigned int XADC_ZYNQ_UNMASK_TIMEOUT = 500;
 
 #define XADC_FLAGS_BUFFERED BIT(0)
 
+/*
+ * The XADC hardware supports a samplerate of up to 1MSPS. Unfortunately it does
+ * not have a hardware FIFO. Which means an interrupt is generated for each
+ * conversion sequence. At 1MSPS sample rate the CPU in ZYNQ7000 is completely
+ * overloaded by the interrupts that it soft-lockups. For this reason the driver
+ * limits the maximum samplerate 150kSPS. At this rate the CPU is fairly busy,
+ * but still responsive.
+ */
+#define XADC_MAX_SAMPLERATE 150000
+
 static void xadc_write_reg(struct xadc *xadc, unsigned int reg,
 	uint32_t val)
 {
@@ -834,11 +844,27 @@ static const struct iio_buffer_setup_ops xadc_buffer_ops = {
 	.postdisable = &xadc_postdisable,
 };
 
+static int xadc_read_samplerate(struct xadc *xadc)
+{
+	unsigned int div;
+	uint16_t val16;
+	int ret;
+
+	ret = xadc_read_adc_reg(xadc, XADC_REG_CONF2, &val16);
+	if (ret)
+		return ret;
+
+	div = (val16 & XADC_CONF2_DIV_MASK) >> XADC_CONF2_DIV_OFFSET;
+	if (div < 2)
+		div = 2;
+
+	return xadc_get_dclk_rate(xadc) / div / 26;
+}
+
 static int xadc_read_raw(struct iio_dev *indio_dev,
 	struct iio_chan_spec const *chan, int *val, int *val2, long info)
 {
 	struct xadc *xadc = iio_priv(indio_dev);
-	unsigned int div;
 	uint16_t val16;
 	int ret;
 
@@ -891,41 +917,31 @@ static int xadc_read_raw(struct iio_dev *indio_dev,
 		*val = -((273150 << 12) / 503975);
 		return IIO_VAL_INT;
 	case IIO_CHAN_INFO_SAMP_FREQ:
-		ret = xadc_read_adc_reg(xadc, XADC_REG_CONF2, &val16);
-		if (ret)
+		ret = xadc_read_samplerate(xadc);
+		if (ret < 0)
 			return ret;
 
-		div = (val16 & XADC_CONF2_DIV_MASK) >> XADC_CONF2_DIV_OFFSET;
-		if (div < 2)
-			div = 2;
-
-		*val = xadc_get_dclk_rate(xadc) / div / 26;
-
+		*val = ret;
 		return IIO_VAL_INT;
 	default:
 		return -EINVAL;
 	}
 }
 
-static int xadc_write_raw(struct iio_dev *indio_dev,
-	struct iio_chan_spec const *chan, int val, int val2, long info)
+static int xadc_write_samplerate(struct xadc *xadc, int val)
 {
-	struct xadc *xadc = iio_priv(indio_dev);
 	unsigned long clk_rate = xadc_get_dclk_rate(xadc);
 	unsigned int div;
 
 	if (!clk_rate)
 		return -EINVAL;
 
-	if (info != IIO_CHAN_INFO_SAMP_FREQ)
-		return -EINVAL;
-
 	if (val <= 0)
 		return -EINVAL;
 
 	/* Max. 150 kSPS */
-	if (val > 150000)
-		val = 150000;
+	if (val > XADC_MAX_SAMPLERATE)
+		val = XADC_MAX_SAMPLERATE;
 
 	val *= 26;
 
@@ -938,7 +954,7 @@ static int xadc_write_raw(struct iio_dev *indio_dev,
 	 * limit.
 	 */
 	div = clk_rate / val;
-	if (clk_rate / div / 26 > 150000)
+	if (clk_rate / div / 26 > XADC_MAX_SAMPLERATE)
 		div++;
 	if (div < 2)
 		div = 2;
@@ -949,6 +965,17 @@ static int xadc_write_raw(struct iio_dev *indio_dev,
 		div << XADC_CONF2_DIV_OFFSET);
 }
 
+static int xadc_write_raw(struct iio_dev *indio_dev,
+	struct iio_chan_spec const *chan, int val, int val2, long info)
+{
+	struct xadc *xadc = iio_priv(indio_dev);
+
+	if (info != IIO_CHAN_INFO_SAMP_FREQ)
+		return -EINVAL;
+
+	return xadc_write_samplerate(xadc, val);
+}
+
 static const struct iio_event_spec xadc_temp_events[] = {
 	{
 		.type = IIO_EV_TYPE_THRESH,
@@ -1234,6 +1261,21 @@ static int xadc_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_free_samplerate_trigger;
 
+	/*
+	 * Make sure not to exceed the maximum samplerate since otherwise the
+	 * resulting interrupt storm will soft-lock the system.
+	 */
+	if (xadc->ops->flags & XADC_FLAGS_BUFFERED) {
+		ret = xadc_read_samplerate(xadc);
+		if (ret < 0)
+			goto err_free_samplerate_trigger;
+		if (ret > XADC_MAX_SAMPLERATE) {
+			ret = xadc_write_samplerate(xadc, XADC_MAX_SAMPLERATE);
+			if (ret < 0)
+				goto err_free_samplerate_trigger;
+		}
+	}
+
 	ret = request_irq(xadc->irq, xadc->ops->interrupt_handler, 0,
 			dev_name(&pdev->dev), indio_dev);
 	if (ret)
-- 
2.26.1


