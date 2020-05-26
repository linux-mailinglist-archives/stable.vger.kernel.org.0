Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A02611C1633
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 16:08:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731195AbgEANlv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:41:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:42250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731433AbgEANlu (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:41:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA0D4205C9;
        Fri,  1 May 2020 13:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588340509;
        bh=8BrJ37OrIKQb9B3/BMOi7ekoVp7sGo6P/3+7KRYRSAw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LsvKjKniItGaoBnDGQwBPJihbJfJcT22EpwAzPghmRUuky0tMauCfkXCb7JFATOU+
         cagxvZVeQ8S3ErtqHdIu4wUpW0FH0dd8JPRVULaUhPGuYLF3G1p1621FLli/68CTJA
         ny3nK60fExwUJ6PPqeEXC5Vstja9mPmXz6003G9Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Syed Nayyar Waris <syednwaris@gmail.com>,
        William Breathitt Gray <vilhelm.gray@gmail.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.6 015/106] counter: 104-quad-8: Add lock guards - generic interface
Date:   Fri,  1 May 2020 15:22:48 +0200
Message-Id: <20200501131546.087320826@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131543.421333643@linuxfoundation.org>
References: <20200501131543.421333643@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Syed Nayyar Waris <syednwaris@gmail.com>

commit fc069262261c43ed11d639dadcf982e79bfe652b upstream.

Add lock protection from race conditions to 104-quad-8 counter driver
generic interface code changes. Mutex calls used for protection.

Fixes: f1d8a071d45b ("counter: 104-quad-8: Add Generic Counter interface support")

Signed-off-by: Syed Nayyar Waris <syednwaris@gmail.com>
Signed-off-by: William Breathitt Gray <vilhelm.gray@gmail.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/counter/104-quad-8.c |  194 +++++++++++++++++++++++++++++++++++--------
 1 file changed, 160 insertions(+), 34 deletions(-)

--- a/drivers/counter/104-quad-8.c
+++ b/drivers/counter/104-quad-8.c
@@ -42,6 +42,7 @@ MODULE_PARM_DESC(base, "ACCES 104-QUAD-8
  * @base:		base port address of the IIO device
  */
 struct quad8_iio {
+	struct mutex lock;
 	struct counter_device counter;
 	unsigned int preset[QUAD8_NUM_COUNTERS];
 	unsigned int count_mode[QUAD8_NUM_COUNTERS];
@@ -116,6 +117,8 @@ static int quad8_read_raw(struct iio_dev
 		/* Borrow XOR Carry effectively doubles count range */
 		*val = (borrow ^ carry) << 24;
 
+		mutex_lock(&priv->lock);
+
 		/* Reset Byte Pointer; transfer Counter to Output Latch */
 		outb(QUAD8_CTR_RLD | QUAD8_RLD_RESET_BP | QUAD8_RLD_CNTR_OUT,
 		     base_offset + 1);
@@ -123,6 +126,8 @@ static int quad8_read_raw(struct iio_dev
 		for (i = 0; i < 3; i++)
 			*val |= (unsigned int)inb(base_offset) << (8 * i);
 
+		mutex_unlock(&priv->lock);
+
 		return IIO_VAL_INT;
 	case IIO_CHAN_INFO_ENABLE:
 		*val = priv->ab_enable[chan->channel];
@@ -153,6 +158,8 @@ static int quad8_write_raw(struct iio_de
 		if ((unsigned int)val > 0xFFFFFF)
 			return -EINVAL;
 
+		mutex_lock(&priv->lock);
+
 		/* Reset Byte Pointer */
 		outb(QUAD8_CTR_RLD | QUAD8_RLD_RESET_BP, base_offset + 1);
 
@@ -176,12 +183,16 @@ static int quad8_write_raw(struct iio_de
 		/* Reset Error flag */
 		outb(QUAD8_CTR_RLD | QUAD8_RLD_RESET_E, base_offset + 1);
 
+		mutex_unlock(&priv->lock);
+
 		return 0;
 	case IIO_CHAN_INFO_ENABLE:
 		/* only boolean values accepted */
 		if (val < 0 || val > 1)
 			return -EINVAL;
 
+		mutex_lock(&priv->lock);
+
 		priv->ab_enable[chan->channel] = val;
 
 		ior_cfg = val | priv->preset_enable[chan->channel] << 1;
@@ -189,11 +200,18 @@ static int quad8_write_raw(struct iio_de
 		/* Load I/O control configuration */
 		outb(QUAD8_CTR_IOR | ior_cfg, base_offset + 1);
 
+		mutex_unlock(&priv->lock);
+
 		return 0;
 	case IIO_CHAN_INFO_SCALE:
+		mutex_lock(&priv->lock);
+
 		/* Quadrature scaling only available in quadrature mode */
-		if (!priv->quadrature_mode[chan->channel] && (val2 || val != 1))
+		if (!priv->quadrature_mode[chan->channel] &&
+				(val2 || val != 1)) {
+			mutex_unlock(&priv->lock);
 			return -EINVAL;
+		}
 
 		/* Only three gain states (1, 0.5, 0.25) */
 		if (val == 1 && !val2)
@@ -207,11 +225,15 @@ static int quad8_write_raw(struct iio_de
 				priv->quadrature_scale[chan->channel] = 2;
 				break;
 			default:
+				mutex_unlock(&priv->lock);
 				return -EINVAL;
 			}
-		else
+		else {
+			mutex_unlock(&priv->lock);
 			return -EINVAL;
+		}
 
+		mutex_unlock(&priv->lock);
 		return 0;
 	}
 
@@ -248,6 +270,8 @@ static ssize_t quad8_write_preset(struct
 	if (preset > 0xFFFFFF)
 		return -EINVAL;
 
+	mutex_lock(&priv->lock);
+
 	priv->preset[chan->channel] = preset;
 
 	/* Reset Byte Pointer */
@@ -257,6 +281,8 @@ static ssize_t quad8_write_preset(struct
 	for (i = 0; i < 3; i++)
 		outb(preset >> (8 * i), base_offset);
 
+	mutex_unlock(&priv->lock);
+
 	return len;
 }
 
@@ -286,6 +312,8 @@ static ssize_t quad8_write_set_to_preset
 	/* Preset enable is active low in Input/Output Control register */
 	preset_enable = !preset_enable;
 
+	mutex_lock(&priv->lock);
+
 	priv->preset_enable[chan->channel] = preset_enable;
 
 	ior_cfg = priv->ab_enable[chan->channel] |
@@ -294,6 +322,8 @@ static ssize_t quad8_write_set_to_preset
 	/* Load I/O control configuration to Input / Output Control Register */
 	outb(QUAD8_CTR_IOR | ior_cfg, base_offset);
 
+	mutex_unlock(&priv->lock);
+
 	return len;
 }
 
@@ -351,6 +381,8 @@ static int quad8_set_count_mode(struct i
 	unsigned int mode_cfg = cnt_mode << 1;
 	const int base_offset = priv->base + 2 * chan->channel + 1;
 
+	mutex_lock(&priv->lock);
+
 	priv->count_mode[chan->channel] = cnt_mode;
 
 	/* Add quadrature mode configuration */
@@ -360,6 +392,8 @@ static int quad8_set_count_mode(struct i
 	/* Load mode configuration to Counter Mode Register */
 	outb(QUAD8_CTR_CMR | mode_cfg, base_offset);
 
+	mutex_unlock(&priv->lock);
+
 	return 0;
 }
 
@@ -387,19 +421,26 @@ static int quad8_set_synchronous_mode(st
 	const struct iio_chan_spec *chan, unsigned int synchronous_mode)
 {
 	struct quad8_iio *const priv = iio_priv(indio_dev);
-	const unsigned int idr_cfg = synchronous_mode |
-		priv->index_polarity[chan->channel] << 1;
 	const int base_offset = priv->base + 2 * chan->channel + 1;
+	unsigned int idr_cfg = synchronous_mode;
+
+	mutex_lock(&priv->lock);
+
+	idr_cfg |= priv->index_polarity[chan->channel] << 1;
 
 	/* Index function must be non-synchronous in non-quadrature mode */
-	if (synchronous_mode && !priv->quadrature_mode[chan->channel])
+	if (synchronous_mode && !priv->quadrature_mode[chan->channel]) {
+		mutex_unlock(&priv->lock);
 		return -EINVAL;
+	}
 
 	priv->synchronous_mode[chan->channel] = synchronous_mode;
 
 	/* Load Index Control configuration to Index Control Register */
 	outb(QUAD8_CTR_IDR | idr_cfg, base_offset);
 
+	mutex_unlock(&priv->lock);
+
 	return 0;
 }
 
@@ -427,8 +468,12 @@ static int quad8_set_quadrature_mode(str
 	const struct iio_chan_spec *chan, unsigned int quadrature_mode)
 {
 	struct quad8_iio *const priv = iio_priv(indio_dev);
-	unsigned int mode_cfg = priv->count_mode[chan->channel] << 1;
 	const int base_offset = priv->base + 2 * chan->channel + 1;
+	unsigned int mode_cfg;
+
+	mutex_lock(&priv->lock);
+
+	mode_cfg = priv->count_mode[chan->channel] << 1;
 
 	if (quadrature_mode)
 		mode_cfg |= (priv->quadrature_scale[chan->channel] + 1) << 3;
@@ -446,6 +491,8 @@ static int quad8_set_quadrature_mode(str
 	/* Load mode configuration to Counter Mode Register */
 	outb(QUAD8_CTR_CMR | mode_cfg, base_offset);
 
+	mutex_unlock(&priv->lock);
+
 	return 0;
 }
 
@@ -473,15 +520,20 @@ static int quad8_set_index_polarity(stru
 	const struct iio_chan_spec *chan, unsigned int index_polarity)
 {
 	struct quad8_iio *const priv = iio_priv(indio_dev);
-	const unsigned int idr_cfg = priv->synchronous_mode[chan->channel] |
-		index_polarity << 1;
 	const int base_offset = priv->base + 2 * chan->channel + 1;
+	unsigned int idr_cfg = index_polarity << 1;
+
+	mutex_lock(&priv->lock);
+
+	idr_cfg |= priv->synchronous_mode[chan->channel];
 
 	priv->index_polarity[chan->channel] = index_polarity;
 
 	/* Load Index Control configuration to Index Control Register */
 	outb(QUAD8_CTR_IDR | idr_cfg, base_offset);
 
+	mutex_unlock(&priv->lock);
+
 	return 0;
 }
 
@@ -582,7 +634,7 @@ static int quad8_signal_read(struct coun
 static int quad8_count_read(struct counter_device *counter,
 	struct counter_count *count, unsigned long *val)
 {
-	const struct quad8_iio *const priv = counter->priv;
+	struct quad8_iio *const priv = counter->priv;
 	const int base_offset = priv->base + 2 * count->id;
 	unsigned int flags;
 	unsigned int borrow;
@@ -596,6 +648,8 @@ static int quad8_count_read(struct count
 	/* Borrow XOR Carry effectively doubles count range */
 	*val = (unsigned long)(borrow ^ carry) << 24;
 
+	mutex_lock(&priv->lock);
+
 	/* Reset Byte Pointer; transfer Counter to Output Latch */
 	outb(QUAD8_CTR_RLD | QUAD8_RLD_RESET_BP | QUAD8_RLD_CNTR_OUT,
 	     base_offset + 1);
@@ -603,13 +657,15 @@ static int quad8_count_read(struct count
 	for (i = 0; i < 3; i++)
 		*val |= (unsigned long)inb(base_offset) << (8 * i);
 
+	mutex_unlock(&priv->lock);
+
 	return 0;
 }
 
 static int quad8_count_write(struct counter_device *counter,
 	struct counter_count *count, unsigned long val)
 {
-	const struct quad8_iio *const priv = counter->priv;
+	struct quad8_iio *const priv = counter->priv;
 	const int base_offset = priv->base + 2 * count->id;
 	int i;
 
@@ -617,6 +673,8 @@ static int quad8_count_write(struct coun
 	if (val > 0xFFFFFF)
 		return -EINVAL;
 
+	mutex_lock(&priv->lock);
+
 	/* Reset Byte Pointer */
 	outb(QUAD8_CTR_RLD | QUAD8_RLD_RESET_BP, base_offset + 1);
 
@@ -640,6 +698,8 @@ static int quad8_count_write(struct coun
 	/* Reset Error flag */
 	outb(QUAD8_CTR_RLD | QUAD8_RLD_RESET_E, base_offset + 1);
 
+	mutex_unlock(&priv->lock);
+
 	return 0;
 }
 
@@ -660,13 +720,13 @@ static enum counter_count_function quad8
 static int quad8_function_get(struct counter_device *counter,
 	struct counter_count *count, size_t *function)
 {
-	const struct quad8_iio *const priv = counter->priv;
+	struct quad8_iio *const priv = counter->priv;
 	const int id = count->id;
-	const unsigned int quadrature_mode = priv->quadrature_mode[id];
-	const unsigned int scale = priv->quadrature_scale[id];
 
-	if (quadrature_mode)
-		switch (scale) {
+	mutex_lock(&priv->lock);
+
+	if (priv->quadrature_mode[id])
+		switch (priv->quadrature_scale[id]) {
 		case 0:
 			*function = QUAD8_COUNT_FUNCTION_QUADRATURE_X1;
 			break;
@@ -680,6 +740,8 @@ static int quad8_function_get(struct cou
 	else
 		*function = QUAD8_COUNT_FUNCTION_PULSE_DIRECTION;
 
+	mutex_unlock(&priv->lock);
+
 	return 0;
 }
 
@@ -690,10 +752,15 @@ static int quad8_function_set(struct cou
 	const int id = count->id;
 	unsigned int *const quadrature_mode = priv->quadrature_mode + id;
 	unsigned int *const scale = priv->quadrature_scale + id;
-	unsigned int mode_cfg = priv->count_mode[id] << 1;
 	unsigned int *const synchronous_mode = priv->synchronous_mode + id;
-	const unsigned int idr_cfg = priv->index_polarity[id] << 1;
 	const int base_offset = priv->base + 2 * id + 1;
+	unsigned int mode_cfg;
+	unsigned int idr_cfg;
+
+	mutex_lock(&priv->lock);
+
+	mode_cfg = priv->count_mode[id] << 1;
+	idr_cfg = priv->index_polarity[id] << 1;
 
 	if (function == QUAD8_COUNT_FUNCTION_PULSE_DIRECTION) {
 		*quadrature_mode = 0;
@@ -729,6 +796,8 @@ static int quad8_function_set(struct cou
 	/* Load mode configuration to Counter Mode Register */
 	outb(QUAD8_CTR_CMR | mode_cfg, base_offset);
 
+	mutex_unlock(&priv->lock);
+
 	return 0;
 }
 
@@ -845,15 +914,20 @@ static int quad8_index_polarity_set(stru
 {
 	struct quad8_iio *const priv = counter->priv;
 	const size_t channel_id = signal->id - 16;
-	const unsigned int idr_cfg = priv->synchronous_mode[channel_id] |
-		index_polarity << 1;
 	const int base_offset = priv->base + 2 * channel_id + 1;
+	unsigned int idr_cfg = index_polarity << 1;
+
+	mutex_lock(&priv->lock);
+
+	idr_cfg |= priv->synchronous_mode[channel_id];
 
 	priv->index_polarity[channel_id] = index_polarity;
 
 	/* Load Index Control configuration to Index Control Register */
 	outb(QUAD8_CTR_IDR | idr_cfg, base_offset);
 
+	mutex_unlock(&priv->lock);
+
 	return 0;
 }
 
@@ -880,19 +954,26 @@ static int quad8_synchronous_mode_set(st
 {
 	struct quad8_iio *const priv = counter->priv;
 	const size_t channel_id = signal->id - 16;
-	const unsigned int idr_cfg = synchronous_mode |
-		priv->index_polarity[channel_id] << 1;
 	const int base_offset = priv->base + 2 * channel_id + 1;
+	unsigned int idr_cfg = synchronous_mode;
+
+	mutex_lock(&priv->lock);
+
+	idr_cfg |= priv->index_polarity[channel_id] << 1;
 
 	/* Index function must be non-synchronous in non-quadrature mode */
-	if (synchronous_mode && !priv->quadrature_mode[channel_id])
+	if (synchronous_mode && !priv->quadrature_mode[channel_id]) {
+		mutex_unlock(&priv->lock);
 		return -EINVAL;
+	}
 
 	priv->synchronous_mode[channel_id] = synchronous_mode;
 
 	/* Load Index Control configuration to Index Control Register */
 	outb(QUAD8_CTR_IDR | idr_cfg, base_offset);
 
+	mutex_unlock(&priv->lock);
+
 	return 0;
 }
 
@@ -957,6 +1038,8 @@ static int quad8_count_mode_set(struct c
 		break;
 	}
 
+	mutex_lock(&priv->lock);
+
 	priv->count_mode[count->id] = cnt_mode;
 
 	/* Set count mode configuration value */
@@ -969,6 +1052,8 @@ static int quad8_count_mode_set(struct c
 	/* Load mode configuration to Counter Mode Register */
 	outb(QUAD8_CTR_CMR | mode_cfg, base_offset);
 
+	mutex_unlock(&priv->lock);
+
 	return 0;
 }
 
@@ -1010,6 +1095,8 @@ static ssize_t quad8_count_enable_write(
 	if (err)
 		return err;
 
+	mutex_lock(&priv->lock);
+
 	priv->ab_enable[count->id] = ab_enable;
 
 	ior_cfg = ab_enable | priv->preset_enable[count->id] << 1;
@@ -1017,6 +1104,8 @@ static ssize_t quad8_count_enable_write(
 	/* Load I/O control configuration */
 	outb(QUAD8_CTR_IOR | ior_cfg, base_offset + 1);
 
+	mutex_unlock(&priv->lock);
+
 	return len;
 }
 
@@ -1045,14 +1134,28 @@ static ssize_t quad8_count_preset_read(s
 	return sprintf(buf, "%u\n", priv->preset[count->id]);
 }
 
+static void quad8_preset_register_set(struct quad8_iio *quad8iio, int id,
+		unsigned int preset)
+{
+	const unsigned int base_offset = quad8iio->base + 2 * id;
+	int i;
+
+	quad8iio->preset[id] = preset;
+
+	/* Reset Byte Pointer */
+	outb(QUAD8_CTR_RLD | QUAD8_RLD_RESET_BP, base_offset + 1);
+
+	/* Set Preset Register */
+	for (i = 0; i < 3; i++)
+		outb(preset >> (8 * i), base_offset);
+}
+
 static ssize_t quad8_count_preset_write(struct counter_device *counter,
 	struct counter_count *count, void *private, const char *buf, size_t len)
 {
 	struct quad8_iio *const priv = counter->priv;
-	const int base_offset = priv->base + 2 * count->id;
 	unsigned int preset;
 	int ret;
-	int i;
 
 	ret = kstrtouint(buf, 0, &preset);
 	if (ret)
@@ -1062,14 +1165,11 @@ static ssize_t quad8_count_preset_write(
 	if (preset > 0xFFFFFF)
 		return -EINVAL;
 
-	priv->preset[count->id] = preset;
+	mutex_lock(&priv->lock);
 
-	/* Reset Byte Pointer */
-	outb(QUAD8_CTR_RLD | QUAD8_RLD_RESET_BP, base_offset + 1);
+	quad8_preset_register_set(priv, count->id, preset);
 
-	/* Set Preset Register */
-	for (i = 0; i < 3; i++)
-		outb(preset >> (8 * i), base_offset);
+	mutex_unlock(&priv->lock);
 
 	return len;
 }
@@ -1077,15 +1177,20 @@ static ssize_t quad8_count_preset_write(
 static ssize_t quad8_count_ceiling_read(struct counter_device *counter,
 	struct counter_count *count, void *private, char *buf)
 {
-	const struct quad8_iio *const priv = counter->priv;
+	struct quad8_iio *const priv = counter->priv;
+
+	mutex_lock(&priv->lock);
 
 	/* Range Limit and Modulo-N count modes use preset value as ceiling */
 	switch (priv->count_mode[count->id]) {
 	case 1:
 	case 3:
-		return quad8_count_preset_read(counter, count, private, buf);
+		mutex_unlock(&priv->lock);
+		return sprintf(buf, "%u\n", priv->preset[count->id]);
 	}
 
+	mutex_unlock(&priv->lock);
+
 	/* By default 0x1FFFFFF (25 bits unsigned) is maximum count */
 	return sprintf(buf, "33554431\n");
 }
@@ -1094,15 +1199,29 @@ static ssize_t quad8_count_ceiling_write
 	struct counter_count *count, void *private, const char *buf, size_t len)
 {
 	struct quad8_iio *const priv = counter->priv;
+	unsigned int ceiling;
+	int ret;
+
+	ret = kstrtouint(buf, 0, &ceiling);
+	if (ret)
+		return ret;
+
+	/* Only 24-bit values are supported */
+	if (ceiling > 0xFFFFFF)
+		return -EINVAL;
+
+	mutex_lock(&priv->lock);
 
 	/* Range Limit and Modulo-N count modes use preset value as ceiling */
 	switch (priv->count_mode[count->id]) {
 	case 1:
 	case 3:
-		return quad8_count_preset_write(counter, count, private, buf,
-						len);
+		quad8_preset_register_set(priv, count->id, ceiling);
+		break;
 	}
 
+	mutex_unlock(&priv->lock);
+
 	return len;
 }
 
@@ -1130,6 +1249,8 @@ static ssize_t quad8_count_preset_enable
 	/* Preset enable is active low in Input/Output Control register */
 	preset_enable = !preset_enable;
 
+	mutex_lock(&priv->lock);
+
 	priv->preset_enable[count->id] = preset_enable;
 
 	ior_cfg = priv->ab_enable[count->id] | (unsigned int)preset_enable << 1;
@@ -1137,6 +1258,8 @@ static ssize_t quad8_count_preset_enable
 	/* Load I/O control configuration to Input / Output Control Register */
 	outb(QUAD8_CTR_IOR | ior_cfg, base_offset);
 
+	mutex_unlock(&priv->lock);
+
 	return len;
 }
 
@@ -1307,6 +1430,9 @@ static int quad8_probe(struct device *de
 	quad8iio->counter.priv = quad8iio;
 	quad8iio->base = base[id];
 
+	/* Initialize mutex */
+	mutex_init(&quad8iio->lock);
+
 	/* Reset all counters and disable interrupt function */
 	outb(QUAD8_CHAN_OP_RESET_COUNTERS, base[id] + QUAD8_REG_CHAN_OP);
 	/* Set initial configuration for all counters */


