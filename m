Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9076E5F291D
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:14:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbiJCHOM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:14:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229843AbiJCHNR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:13:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A236636437;
        Mon,  3 Oct 2022 00:12:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D59C5B80E68;
        Mon,  3 Oct 2022 07:12:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32FAEC433C1;
        Mon,  3 Oct 2022 07:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781164;
        bh=b7MEc65CBx4yIJYcEfzrChpVR1Lo5PY165CiVWjE3iM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=spiG5EFTZGjTE2NPRJ0sCU04ey3ixlEMp9lODAsCPpCab71xU886YvPZg19oHoK7J
         3cRHSwL/rU0Uf71m466v+ucpBgWxz/AXBRKCfuRUVrrmPAMGA7VwCD898agMgQLq1j
         LjUcTmXP4Nznw9aCRBE12ImmcW1wTC3xtcfvM3IM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Syed Nayyar Waris <syednwaris@gmail.com>,
        Fred Eckert <Frede@cmslaser.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        William Breathitt Gray <william.gray@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 005/101] counter: 104-quad-8: Implement and utilize register structures
Date:   Mon,  3 Oct 2022 09:10:01 +0200
Message-Id: <20221003070724.637322460@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070724.490989164@linuxfoundation.org>
References: <20221003070724.490989164@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: William Breathitt Gray <william.gray@linaro.org>

[ Upstream commit daae1ee572d1f99daddef26afe6c6fc7aeea741d ]

Reduce magic numbers and improve code readability by implementing and
utilizing named register data structures.

Link: https://lore.kernel.org/r/20220707171709.36010-1-william.gray@linaro.org/
Cc: Syed Nayyar Waris <syednwaris@gmail.com>
Tested-by: Fred Eckert <Frede@cmslaser.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: William Breathitt Gray <william.gray@linaro.org>
Link: https://lore.kernel.org/r/285fdc7c03892251f50bdbf2c28c19998243a6a3.1657813472.git.william.gray@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 2bc54aaa65d2 ("counter: 104-quad-8: Fix skipped IRQ lines during events configuration")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/counter/104-quad-8.c | 166 ++++++++++++++++++++---------------
 1 file changed, 93 insertions(+), 73 deletions(-)

diff --git a/drivers/counter/104-quad-8.c b/drivers/counter/104-quad-8.c
index 43dde9abfdcf..62c2b7ac4339 100644
--- a/drivers/counter/104-quad-8.c
+++ b/drivers/counter/104-quad-8.c
@@ -33,6 +33,36 @@ MODULE_PARM_DESC(irq, "ACCES 104-QUAD-8 interrupt line numbers");
 
 #define QUAD8_NUM_COUNTERS 8
 
+/**
+ * struct channel_reg - channel register structure
+ * @data:	Count data
+ * @control:	Channel flags and control
+ */
+struct channel_reg {
+	u8 data;
+	u8 control;
+};
+
+/**
+ * struct quad8_reg - device register structure
+ * @channel:		quadrature counter data and control
+ * @interrupt_status:	channel interrupt status
+ * @channel_oper:	enable/reset counters and interrupt functions
+ * @index_interrupt:	enable channel interrupts
+ * @reserved:		reserved for Factory Use
+ * @index_input_levels:	index signal logical input level
+ * @cable_status:	differential encoder cable status
+ */
+struct quad8_reg {
+	struct channel_reg channel[QUAD8_NUM_COUNTERS];
+	u8 interrupt_status;
+	u8 channel_oper;
+	u8 index_interrupt;
+	u8 reserved[3];
+	u8 index_input_levels;
+	u8 cable_status;
+};
+
 /**
  * struct quad8 - device private data structure
  * @lock:		lock to prevent clobbering device states during R/W ops
@@ -48,7 +78,7 @@ MODULE_PARM_DESC(irq, "ACCES 104-QUAD-8 interrupt line numbers");
  * @synchronous_mode:	array of index function synchronous mode configurations
  * @index_polarity:	array of index function polarity configurations
  * @cable_fault_enable:	differential encoder cable status enable configurations
- * @base:		base port address of the device
+ * @reg:		I/O address offset for the device registers
  */
 struct quad8 {
 	spinlock_t lock;
@@ -63,14 +93,9 @@ struct quad8 {
 	unsigned int synchronous_mode[QUAD8_NUM_COUNTERS];
 	unsigned int index_polarity[QUAD8_NUM_COUNTERS];
 	unsigned int cable_fault_enable;
-	void __iomem *base;
+	struct quad8_reg __iomem *reg;
 };
 
-#define QUAD8_REG_INTERRUPT_STATUS 0x10
-#define QUAD8_REG_CHAN_OP 0x11
-#define QUAD8_REG_INDEX_INTERRUPT 0x12
-#define QUAD8_REG_INDEX_INPUT_LEVELS 0x16
-#define QUAD8_DIFF_ENCODER_CABLE_STATUS 0x17
 /* Borrow Toggle flip-flop */
 #define QUAD8_FLAG_BT BIT(0)
 /* Carry Toggle flip-flop */
@@ -118,8 +143,7 @@ static int quad8_signal_read(struct counter_device *counter,
 	if (signal->id < 16)
 		return -EINVAL;
 
-	state = ioread8(priv->base + QUAD8_REG_INDEX_INPUT_LEVELS) &
-		BIT(signal->id - 16);
+	state = ioread8(&priv->reg->index_input_levels) & BIT(signal->id - 16);
 
 	*level = (state) ? COUNTER_SIGNAL_LEVEL_HIGH : COUNTER_SIGNAL_LEVEL_LOW;
 
@@ -130,14 +154,14 @@ static int quad8_count_read(struct counter_device *counter,
 			    struct counter_count *count, u64 *val)
 {
 	struct quad8 *const priv = counter_priv(counter);
-	void __iomem *const base_offset = priv->base + 2 * count->id;
+	struct channel_reg __iomem *const chan = priv->reg->channel + count->id;
 	unsigned int flags;
 	unsigned int borrow;
 	unsigned int carry;
 	unsigned long irqflags;
 	int i;
 
-	flags = ioread8(base_offset + 1);
+	flags = ioread8(&chan->control);
 	borrow = flags & QUAD8_FLAG_BT;
 	carry = !!(flags & QUAD8_FLAG_CT);
 
@@ -148,10 +172,10 @@ static int quad8_count_read(struct counter_device *counter,
 
 	/* Reset Byte Pointer; transfer Counter to Output Latch */
 	iowrite8(QUAD8_CTR_RLD | QUAD8_RLD_RESET_BP | QUAD8_RLD_CNTR_OUT,
-		 base_offset + 1);
+		 &chan->control);
 
 	for (i = 0; i < 3; i++)
-		*val |= (unsigned long)ioread8(base_offset) << (8 * i);
+		*val |= (unsigned long)ioread8(&chan->data) << (8 * i);
 
 	spin_unlock_irqrestore(&priv->lock, irqflags);
 
@@ -162,7 +186,7 @@ static int quad8_count_write(struct counter_device *counter,
 			     struct counter_count *count, u64 val)
 {
 	struct quad8 *const priv = counter_priv(counter);
-	void __iomem *const base_offset = priv->base + 2 * count->id;
+	struct channel_reg __iomem *const chan = priv->reg->channel + count->id;
 	unsigned long irqflags;
 	int i;
 
@@ -173,27 +197,27 @@ static int quad8_count_write(struct counter_device *counter,
 	spin_lock_irqsave(&priv->lock, irqflags);
 
 	/* Reset Byte Pointer */
-	iowrite8(QUAD8_CTR_RLD | QUAD8_RLD_RESET_BP, base_offset + 1);
+	iowrite8(QUAD8_CTR_RLD | QUAD8_RLD_RESET_BP, &chan->control);
 
 	/* Counter can only be set via Preset Register */
 	for (i = 0; i < 3; i++)
-		iowrite8(val >> (8 * i), base_offset);
+		iowrite8(val >> (8 * i), &chan->data);
 
 	/* Transfer Preset Register to Counter */
-	iowrite8(QUAD8_CTR_RLD | QUAD8_RLD_PRESET_CNTR, base_offset + 1);
+	iowrite8(QUAD8_CTR_RLD | QUAD8_RLD_PRESET_CNTR, &chan->control);
 
 	/* Reset Byte Pointer */
-	iowrite8(QUAD8_CTR_RLD | QUAD8_RLD_RESET_BP, base_offset + 1);
+	iowrite8(QUAD8_CTR_RLD | QUAD8_RLD_RESET_BP, &chan->control);
 
 	/* Set Preset Register back to original value */
 	val = priv->preset[count->id];
 	for (i = 0; i < 3; i++)
-		iowrite8(val >> (8 * i), base_offset);
+		iowrite8(val >> (8 * i), &chan->data);
 
 	/* Reset Borrow, Carry, Compare, and Sign flags */
-	iowrite8(QUAD8_CTR_RLD | QUAD8_RLD_RESET_FLAGS, base_offset + 1);
+	iowrite8(QUAD8_CTR_RLD | QUAD8_RLD_RESET_FLAGS, &chan->control);
 	/* Reset Error flag */
-	iowrite8(QUAD8_CTR_RLD | QUAD8_RLD_RESET_E, base_offset + 1);
+	iowrite8(QUAD8_CTR_RLD | QUAD8_RLD_RESET_E, &chan->control);
 
 	spin_unlock_irqrestore(&priv->lock, irqflags);
 
@@ -246,7 +270,7 @@ static int quad8_function_write(struct counter_device *counter,
 	unsigned int *const quadrature_mode = priv->quadrature_mode + id;
 	unsigned int *const scale = priv->quadrature_scale + id;
 	unsigned int *const synchronous_mode = priv->synchronous_mode + id;
-	void __iomem *const base_offset = priv->base + 2 * id + 1;
+	u8 __iomem *const control = &priv->reg->channel[id].control;
 	unsigned long irqflags;
 	unsigned int mode_cfg;
 	unsigned int idr_cfg;
@@ -266,7 +290,7 @@ static int quad8_function_write(struct counter_device *counter,
 		if (*synchronous_mode) {
 			*synchronous_mode = 0;
 			/* Disable synchronous function mode */
-			iowrite8(QUAD8_CTR_IDR | idr_cfg, base_offset);
+			iowrite8(QUAD8_CTR_IDR | idr_cfg, control);
 		}
 	} else {
 		*quadrature_mode = 1;
@@ -292,7 +316,7 @@ static int quad8_function_write(struct counter_device *counter,
 	}
 
 	/* Load mode configuration to Counter Mode Register */
-	iowrite8(QUAD8_CTR_CMR | mode_cfg, base_offset);
+	iowrite8(QUAD8_CTR_CMR | mode_cfg, control);
 
 	spin_unlock_irqrestore(&priv->lock, irqflags);
 
@@ -305,7 +329,7 @@ static int quad8_direction_read(struct counter_device *counter,
 {
 	const struct quad8 *const priv = counter_priv(counter);
 	unsigned int ud_flag;
-	void __iomem *const flag_addr = priv->base + 2 * count->id + 1;
+	u8 __iomem *const flag_addr = &priv->reg->channel[count->id].control;
 
 	/* U/D flag: nonzero = up, zero = down */
 	ud_flag = ioread8(flag_addr) & QUAD8_FLAG_UD;
@@ -402,7 +426,6 @@ static int quad8_events_configure(struct counter_device *counter)
 	struct counter_event_node *event_node;
 	unsigned int next_irq_trigger;
 	unsigned long ior_cfg;
-	void __iomem *base_offset;
 
 	spin_lock_irqsave(&priv->lock, irqflags);
 
@@ -437,14 +460,14 @@ static int quad8_events_configure(struct counter_device *counter)
 		ior_cfg = priv->ab_enable[event_node->channel] |
 			  priv->preset_enable[event_node->channel] << 1 |
 			  priv->irq_trigger[event_node->channel] << 3;
-		base_offset = priv->base + 2 * event_node->channel + 1;
-		iowrite8(QUAD8_CTR_IOR | ior_cfg, base_offset);
+		iowrite8(QUAD8_CTR_IOR | ior_cfg,
+			 &priv->reg->channel[event_node->channel].control);
 
 		/* Enable IRQ line */
 		irq_enabled |= BIT(event_node->channel);
 	}
 
-	iowrite8(irq_enabled, priv->base + QUAD8_REG_INDEX_INTERRUPT);
+	iowrite8(irq_enabled, &priv->reg->index_interrupt);
 
 	spin_unlock_irqrestore(&priv->lock, irqflags);
 
@@ -508,7 +531,7 @@ static int quad8_index_polarity_set(struct counter_device *counter,
 {
 	struct quad8 *const priv = counter_priv(counter);
 	const size_t channel_id = signal->id - 16;
-	void __iomem *const base_offset = priv->base + 2 * channel_id + 1;
+	u8 __iomem *const control = &priv->reg->channel[channel_id].control;
 	unsigned long irqflags;
 	unsigned int idr_cfg = index_polarity << 1;
 
@@ -519,7 +542,7 @@ static int quad8_index_polarity_set(struct counter_device *counter,
 	priv->index_polarity[channel_id] = index_polarity;
 
 	/* Load Index Control configuration to Index Control Register */
-	iowrite8(QUAD8_CTR_IDR | idr_cfg, base_offset);
+	iowrite8(QUAD8_CTR_IDR | idr_cfg, control);
 
 	spin_unlock_irqrestore(&priv->lock, irqflags);
 
@@ -549,7 +572,7 @@ static int quad8_synchronous_mode_set(struct counter_device *counter,
 {
 	struct quad8 *const priv = counter_priv(counter);
 	const size_t channel_id = signal->id - 16;
-	void __iomem *const base_offset = priv->base + 2 * channel_id + 1;
+	u8 __iomem *const control = &priv->reg->channel[channel_id].control;
 	unsigned long irqflags;
 	unsigned int idr_cfg = synchronous_mode;
 
@@ -566,7 +589,7 @@ static int quad8_synchronous_mode_set(struct counter_device *counter,
 	priv->synchronous_mode[channel_id] = synchronous_mode;
 
 	/* Load Index Control configuration to Index Control Register */
-	iowrite8(QUAD8_CTR_IDR | idr_cfg, base_offset);
+	iowrite8(QUAD8_CTR_IDR | idr_cfg, control);
 
 	spin_unlock_irqrestore(&priv->lock, irqflags);
 
@@ -614,7 +637,7 @@ static int quad8_count_mode_write(struct counter_device *counter,
 	struct quad8 *const priv = counter_priv(counter);
 	unsigned int count_mode;
 	unsigned int mode_cfg;
-	void __iomem *const base_offset = priv->base + 2 * count->id + 1;
+	u8 __iomem *const control = &priv->reg->channel[count->id].control;
 	unsigned long irqflags;
 
 	/* Map Generic Counter count mode to 104-QUAD-8 count mode */
@@ -648,7 +671,7 @@ static int quad8_count_mode_write(struct counter_device *counter,
 		mode_cfg |= (priv->quadrature_scale[count->id] + 1) << 3;
 
 	/* Load mode configuration to Counter Mode Register */
-	iowrite8(QUAD8_CTR_CMR | mode_cfg, base_offset);
+	iowrite8(QUAD8_CTR_CMR | mode_cfg, control);
 
 	spin_unlock_irqrestore(&priv->lock, irqflags);
 
@@ -669,7 +692,7 @@ static int quad8_count_enable_write(struct counter_device *counter,
 				    struct counter_count *count, u8 enable)
 {
 	struct quad8 *const priv = counter_priv(counter);
-	void __iomem *const base_offset = priv->base + 2 * count->id;
+	u8 __iomem *const control = &priv->reg->channel[count->id].control;
 	unsigned long irqflags;
 	unsigned int ior_cfg;
 
@@ -681,7 +704,7 @@ static int quad8_count_enable_write(struct counter_device *counter,
 		  priv->irq_trigger[count->id] << 3;
 
 	/* Load I/O control configuration */
-	iowrite8(QUAD8_CTR_IOR | ior_cfg, base_offset + 1);
+	iowrite8(QUAD8_CTR_IOR | ior_cfg, control);
 
 	spin_unlock_irqrestore(&priv->lock, irqflags);
 
@@ -697,9 +720,9 @@ static int quad8_error_noise_get(struct counter_device *counter,
 				 struct counter_count *count, u32 *noise_error)
 {
 	const struct quad8 *const priv = counter_priv(counter);
-	void __iomem *const base_offset = priv->base + 2 * count->id + 1;
+	u8 __iomem *const flag_addr = &priv->reg->channel[count->id].control;
 
-	*noise_error = !!(ioread8(base_offset) & QUAD8_FLAG_E);
+	*noise_error = !!(ioread8(flag_addr) & QUAD8_FLAG_E);
 
 	return 0;
 }
@@ -717,17 +740,17 @@ static int quad8_count_preset_read(struct counter_device *counter,
 static void quad8_preset_register_set(struct quad8 *const priv, const int id,
 				      const unsigned int preset)
 {
-	void __iomem *const base_offset = priv->base + 2 * id;
+	struct channel_reg __iomem *const chan = priv->reg->channel + id;
 	int i;
 
 	priv->preset[id] = preset;
 
 	/* Reset Byte Pointer */
-	iowrite8(QUAD8_CTR_RLD | QUAD8_RLD_RESET_BP, base_offset + 1);
+	iowrite8(QUAD8_CTR_RLD | QUAD8_RLD_RESET_BP, &chan->control);
 
 	/* Set Preset Register */
 	for (i = 0; i < 3; i++)
-		iowrite8(preset >> (8 * i), base_offset);
+		iowrite8(preset >> (8 * i), &chan->data);
 }
 
 static int quad8_count_preset_write(struct counter_device *counter,
@@ -816,7 +839,7 @@ static int quad8_count_preset_enable_write(struct counter_device *counter,
 					   u8 preset_enable)
 {
 	struct quad8 *const priv = counter_priv(counter);
-	void __iomem *const base_offset = priv->base + 2 * count->id + 1;
+	u8 __iomem *const control = &priv->reg->channel[count->id].control;
 	unsigned long irqflags;
 	unsigned int ior_cfg;
 
@@ -831,7 +854,7 @@ static int quad8_count_preset_enable_write(struct counter_device *counter,
 		  priv->irq_trigger[count->id] << 3;
 
 	/* Load I/O control configuration to Input / Output Control Register */
-	iowrite8(QUAD8_CTR_IOR | ior_cfg, base_offset);
+	iowrite8(QUAD8_CTR_IOR | ior_cfg, control);
 
 	spin_unlock_irqrestore(&priv->lock, irqflags);
 
@@ -858,7 +881,7 @@ static int quad8_signal_cable_fault_read(struct counter_device *counter,
 	}
 
 	/* Logic 0 = cable fault */
-	status = ioread8(priv->base + QUAD8_DIFF_ENCODER_CABLE_STATUS);
+	status = ioread8(&priv->reg->cable_status);
 
 	spin_unlock_irqrestore(&priv->lock, irqflags);
 
@@ -899,8 +922,7 @@ static int quad8_signal_cable_fault_enable_write(struct counter_device *counter,
 	/* Enable is active low in Differential Encoder Cable Status register */
 	cable_fault_enable = ~priv->cable_fault_enable;
 
-	iowrite8(cable_fault_enable,
-		 priv->base + QUAD8_DIFF_ENCODER_CABLE_STATUS);
+	iowrite8(cable_fault_enable, &priv->reg->cable_status);
 
 	spin_unlock_irqrestore(&priv->lock, irqflags);
 
@@ -924,7 +946,7 @@ static int quad8_signal_fck_prescaler_write(struct counter_device *counter,
 {
 	struct quad8 *const priv = counter_priv(counter);
 	const size_t channel_id = signal->id / 2;
-	void __iomem *const base_offset = priv->base + 2 * channel_id;
+	struct channel_reg __iomem *const chan = priv->reg->channel + channel_id;
 	unsigned long irqflags;
 
 	spin_lock_irqsave(&priv->lock, irqflags);
@@ -932,12 +954,12 @@ static int quad8_signal_fck_prescaler_write(struct counter_device *counter,
 	priv->fck_prescaler[channel_id] = prescaler;
 
 	/* Reset Byte Pointer */
-	iowrite8(QUAD8_CTR_RLD | QUAD8_RLD_RESET_BP, base_offset + 1);
+	iowrite8(QUAD8_CTR_RLD | QUAD8_RLD_RESET_BP, &chan->control);
 
 	/* Set filter clock factor */
-	iowrite8(prescaler, base_offset);
+	iowrite8(prescaler, &chan->data);
 	iowrite8(QUAD8_CTR_RLD | QUAD8_RLD_RESET_BP | QUAD8_RLD_PRESET_PSC,
-		 base_offset + 1);
+		 &chan->control);
 
 	spin_unlock_irqrestore(&priv->lock, irqflags);
 
@@ -1085,12 +1107,11 @@ static irqreturn_t quad8_irq_handler(int irq, void *private)
 {
 	struct counter_device *counter = private;
 	struct quad8 *const priv = counter_priv(counter);
-	void __iomem *const base = priv->base;
 	unsigned long irq_status;
 	unsigned long channel;
 	u8 event;
 
-	irq_status = ioread8(base + QUAD8_REG_INTERRUPT_STATUS);
+	irq_status = ioread8(&priv->reg->interrupt_status);
 	if (!irq_status)
 		return IRQ_NONE;
 
@@ -1119,36 +1140,36 @@ static irqreturn_t quad8_irq_handler(int irq, void *private)
 	}
 
 	/* Clear pending interrupts on device */
-	iowrite8(QUAD8_CHAN_OP_ENABLE_INTERRUPT_FUNC, base + QUAD8_REG_CHAN_OP);
+	iowrite8(QUAD8_CHAN_OP_ENABLE_INTERRUPT_FUNC, &priv->reg->channel_oper);
 
 	return IRQ_HANDLED;
 }
 
-static void quad8_init_counter(void __iomem *const base_offset)
+static void quad8_init_counter(struct channel_reg __iomem *const chan)
 {
 	unsigned long i;
 
 	/* Reset Byte Pointer */
-	iowrite8(QUAD8_CTR_RLD | QUAD8_RLD_RESET_BP, base_offset + 1);
+	iowrite8(QUAD8_CTR_RLD | QUAD8_RLD_RESET_BP, &chan->control);
 	/* Reset filter clock factor */
-	iowrite8(0, base_offset);
+	iowrite8(0, &chan->data);
 	iowrite8(QUAD8_CTR_RLD | QUAD8_RLD_RESET_BP | QUAD8_RLD_PRESET_PSC,
-		 base_offset + 1);
+		 &chan->control);
 	/* Reset Byte Pointer */
-	iowrite8(QUAD8_CTR_RLD | QUAD8_RLD_RESET_BP, base_offset + 1);
+	iowrite8(QUAD8_CTR_RLD | QUAD8_RLD_RESET_BP, &chan->control);
 	/* Reset Preset Register */
 	for (i = 0; i < 3; i++)
-		iowrite8(0x00, base_offset);
+		iowrite8(0x00, &chan->data);
 	/* Reset Borrow, Carry, Compare, and Sign flags */
-	iowrite8(QUAD8_CTR_RLD | QUAD8_RLD_RESET_FLAGS, base_offset + 1);
+	iowrite8(QUAD8_CTR_RLD | QUAD8_RLD_RESET_FLAGS, &chan->control);
 	/* Reset Error flag */
-	iowrite8(QUAD8_CTR_RLD | QUAD8_RLD_RESET_E, base_offset + 1);
+	iowrite8(QUAD8_CTR_RLD | QUAD8_RLD_RESET_E, &chan->control);
 	/* Binary encoding; Normal count; non-quadrature mode */
-	iowrite8(QUAD8_CTR_CMR, base_offset + 1);
+	iowrite8(QUAD8_CTR_CMR, &chan->control);
 	/* Disable A and B inputs; preset on index; FLG1 as Carry */
-	iowrite8(QUAD8_CTR_IOR, base_offset + 1);
+	iowrite8(QUAD8_CTR_IOR, &chan->control);
 	/* Disable index function; negative index polarity */
-	iowrite8(QUAD8_CTR_IDR, base_offset + 1);
+	iowrite8(QUAD8_CTR_IDR, &chan->control);
 }
 
 static int quad8_probe(struct device *dev, unsigned int id)
@@ -1169,8 +1190,8 @@ static int quad8_probe(struct device *dev, unsigned int id)
 		return -ENOMEM;
 	priv = counter_priv(counter);
 
-	priv->base = devm_ioport_map(dev, base[id], QUAD8_EXTENT);
-	if (!priv->base)
+	priv->reg = devm_ioport_map(dev, base[id], QUAD8_EXTENT);
+	if (!priv->reg)
 		return -ENOMEM;
 
 	/* Initialize Counter device and driver data */
@@ -1185,17 +1206,16 @@ static int quad8_probe(struct device *dev, unsigned int id)
 	spin_lock_init(&priv->lock);
 
 	/* Reset Index/Interrupt Register */
-	iowrite8(0x00, priv->base + QUAD8_REG_INDEX_INTERRUPT);
+	iowrite8(0x00, &priv->reg->index_interrupt);
 	/* Reset all counters and disable interrupt function */
-	iowrite8(QUAD8_CHAN_OP_RESET_COUNTERS, priv->base + QUAD8_REG_CHAN_OP);
+	iowrite8(QUAD8_CHAN_OP_RESET_COUNTERS, &priv->reg->channel_oper);
 	/* Set initial configuration for all counters */
 	for (i = 0; i < QUAD8_NUM_COUNTERS; i++)
-		quad8_init_counter(priv->base + 2 * i);
+		quad8_init_counter(priv->reg->channel + i);
 	/* Disable Differential Encoder Cable Status for all channels */
-	iowrite8(0xFF, priv->base + QUAD8_DIFF_ENCODER_CABLE_STATUS);
+	iowrite8(0xFF, &priv->reg->cable_status);
 	/* Enable all counters and enable interrupt function */
-	iowrite8(QUAD8_CHAN_OP_ENABLE_INTERRUPT_FUNC,
-		 priv->base + QUAD8_REG_CHAN_OP);
+	iowrite8(QUAD8_CHAN_OP_ENABLE_INTERRUPT_FUNC, &priv->reg->channel_oper);
 
 	err = devm_request_irq(&counter->dev, irq[id], quad8_irq_handler,
 			       IRQF_SHARED, counter->name, counter);
-- 
2.35.1



