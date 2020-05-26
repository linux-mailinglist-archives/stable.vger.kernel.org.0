Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D8081BA5AA
	for <lists+stable@lfdr.de>; Mon, 27 Apr 2020 16:05:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727855AbgD0OFL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Apr 2020 10:05:11 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:47837 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727010AbgD0OFL (ORCPT
        <rfc822;Stable@vger.kernel.org>); Mon, 27 Apr 2020 10:05:11 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id ECD71194035A;
        Mon, 27 Apr 2020 10:05:09 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 27 Apr 2020 10:05:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=3gOGqR
        +3/fgB4gLnvF+uCyIWI/BVF27O8uD/iMTL3ZU=; b=x44xzraqIoK7E6OBnsEmvN
        KsfdFwLgyOxX58lr6b5Bn6ILGlTkN3ag+mcVVdQeqhr+SBoVmMo12RmLjETIti2A
        E46s9TAD8Ko4XtH2fSJOhXJtCMd/7N5yJvpXvJ9Uhe+bQD6p1mQssb5i8CQyc5o0
        PZ7cz4C8zvbflk6/q2k7E4Q2DT6vOCH48key9o24Bzs5fbC6yWpcGCUk22n/B+rE
        nru+zwxtzyemk3hEU434rSOrE/4Cl9TrjwagBxATGefdhz+81Zu4R2OvxU839uvm
        /jZJltPq+P0kfV6klwB91/X2XvKQTEBuemo7uw4U+aVrj431LxsImFpXKxfMpvgQ
        ==
X-ME-Sender: <xms:leamXuQ90hMFhfxEbAndnbp9_27ZPEQPF4i7B9Nh2_3f6lc-wY6ugA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrheelgdejtdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepudenuc
    frrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:leamXqKwuWzC1mJ-NXGl6uT9CIkGIYi_pWo1gChKdZ_W9t2soV6YzQ>
    <xmx:leamXoHiCe7lZdQ2wjl7CvfNArVrPH_JTaw6oTTA5NRjmwiPT6fiDw>
    <xmx:leamXn32Dk7LArJGZbRvRHba-m7GBpOV1zDAD8DEUJEqtjkQoNWjSw>
    <xmx:leamXh-AQ-x9vQsqOMcW9_s1vcT8Lxpqdc5oAS4lpPrYDdwKwae2bA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id EC1F73280067;
        Mon, 27 Apr 2020 10:05:08 -0400 (EDT)
Subject: FAILED: patch "[PATCH] iio: xilinx-xadc: Make sure not exceed maximum samplerate" failed to apply to 4.14-stable tree
To:     lars@metafoo.de, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 27 Apr 2020 16:05:07 +0200
Message-ID: <15879963072514@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 3b7f9dbb827ce8680b98490215e698b6079a9ec5 Mon Sep 17 00:00:00 2001
From: Lars-Peter Clausen <lars@metafoo.de>
Date: Fri, 3 Apr 2020 15:27:16 +0200
Subject: [PATCH] iio: xilinx-xadc: Make sure not exceed maximum samplerate

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

