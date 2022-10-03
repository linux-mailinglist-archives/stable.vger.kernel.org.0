Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 191395F291E
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:14:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229944AbiJCHOP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:14:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229842AbiJCHNR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:13:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E6034333B;
        Mon,  3 Oct 2022 00:12:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1AC81B80E65;
        Mon,  3 Oct 2022 07:12:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47954C433D6;
        Mon,  3 Oct 2022 07:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781161;
        bh=EMX1hIXsoJuNfe/hfMW8cmBmiDYk7jG0rtirzCg1I54=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z0y9Ne3bg5xcW2Z1uukKGj/uEq4HDNQfUj/8OwyL8iPvcuA/t1APIZ71yBewE6vul
         3mYRE8zQNlths1mJbRq8lUb/d+6LgCJlo6GxHlYHRSvI5ePsKOyj6lai6YG5OhiV8E
         v5CMw1LjpwbxUQKidgIkGJkUvI6QeHDn7l6OfkBc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Syed Nayyar Waris <syednwaris@gmail.com>,
        David Laight <David.Laight@ACULAB.COM>,
        Linus Walleij <linus.walleij@linaro.org>,
        William Breathitt Gray <william.gray@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 004/101] counter: 104-quad-8: Utilize iomap interface
Date:   Mon,  3 Oct 2022 09:10:00 +0200
Message-Id: <20221003070724.611391952@linuxfoundation.org>
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

[ Upstream commit b6e9cded90d46b1066a1ca260d8b5ecf67787aba ]

This driver doesn't need to access I/O ports directly via inb()/outb()
and friends. This patch abstracts such access by calling ioport_map()
to enable the use of more typical ioread8()/iowrite8() I/O memory
accessor calls.

Link: https://lore.kernel.org/r/861c003318dce3d2bef4061711643bb04f5ec14f.1652201921.git.william.gray@linaro.org
Cc: Syed Nayyar Waris <syednwaris@gmail.com>
Suggested-by: David Laight <David.Laight@ACULAB.COM>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: William Breathitt Gray <william.gray@linaro.org>
Link: https://lore.kernel.org/r/e971b897cacfac4cb2eca478f5533d2875f5cadd.1657813472.git.william.gray@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 2bc54aaa65d2 ("counter: 104-quad-8: Fix skipped IRQ lines during events configuration")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/counter/104-quad-8.c | 169 ++++++++++++++++++-----------------
 1 file changed, 89 insertions(+), 80 deletions(-)

diff --git a/drivers/counter/104-quad-8.c b/drivers/counter/104-quad-8.c
index a17e51d65aca..43dde9abfdcf 100644
--- a/drivers/counter/104-quad-8.c
+++ b/drivers/counter/104-quad-8.c
@@ -63,7 +63,7 @@ struct quad8 {
 	unsigned int synchronous_mode[QUAD8_NUM_COUNTERS];
 	unsigned int index_polarity[QUAD8_NUM_COUNTERS];
 	unsigned int cable_fault_enable;
-	unsigned int base;
+	void __iomem *base;
 };
 
 #define QUAD8_REG_INTERRUPT_STATUS 0x10
@@ -118,8 +118,8 @@ static int quad8_signal_read(struct counter_device *counter,
 	if (signal->id < 16)
 		return -EINVAL;
 
-	state = inb(priv->base + QUAD8_REG_INDEX_INPUT_LEVELS)
-		& BIT(signal->id - 16);
+	state = ioread8(priv->base + QUAD8_REG_INDEX_INPUT_LEVELS) &
+		BIT(signal->id - 16);
 
 	*level = (state) ? COUNTER_SIGNAL_LEVEL_HIGH : COUNTER_SIGNAL_LEVEL_LOW;
 
@@ -130,14 +130,14 @@ static int quad8_count_read(struct counter_device *counter,
 			    struct counter_count *count, u64 *val)
 {
 	struct quad8 *const priv = counter_priv(counter);
-	const int base_offset = priv->base + 2 * count->id;
+	void __iomem *const base_offset = priv->base + 2 * count->id;
 	unsigned int flags;
 	unsigned int borrow;
 	unsigned int carry;
 	unsigned long irqflags;
 	int i;
 
-	flags = inb(base_offset + 1);
+	flags = ioread8(base_offset + 1);
 	borrow = flags & QUAD8_FLAG_BT;
 	carry = !!(flags & QUAD8_FLAG_CT);
 
@@ -147,11 +147,11 @@ static int quad8_count_read(struct counter_device *counter,
 	spin_lock_irqsave(&priv->lock, irqflags);
 
 	/* Reset Byte Pointer; transfer Counter to Output Latch */
-	outb(QUAD8_CTR_RLD | QUAD8_RLD_RESET_BP | QUAD8_RLD_CNTR_OUT,
-	     base_offset + 1);
+	iowrite8(QUAD8_CTR_RLD | QUAD8_RLD_RESET_BP | QUAD8_RLD_CNTR_OUT,
+		 base_offset + 1);
 
 	for (i = 0; i < 3; i++)
-		*val |= (unsigned long)inb(base_offset) << (8 * i);
+		*val |= (unsigned long)ioread8(base_offset) << (8 * i);
 
 	spin_unlock_irqrestore(&priv->lock, irqflags);
 
@@ -162,7 +162,7 @@ static int quad8_count_write(struct counter_device *counter,
 			     struct counter_count *count, u64 val)
 {
 	struct quad8 *const priv = counter_priv(counter);
-	const int base_offset = priv->base + 2 * count->id;
+	void __iomem *const base_offset = priv->base + 2 * count->id;
 	unsigned long irqflags;
 	int i;
 
@@ -173,27 +173,27 @@ static int quad8_count_write(struct counter_device *counter,
 	spin_lock_irqsave(&priv->lock, irqflags);
 
 	/* Reset Byte Pointer */
-	outb(QUAD8_CTR_RLD | QUAD8_RLD_RESET_BP, base_offset + 1);
+	iowrite8(QUAD8_CTR_RLD | QUAD8_RLD_RESET_BP, base_offset + 1);
 
 	/* Counter can only be set via Preset Register */
 	for (i = 0; i < 3; i++)
-		outb(val >> (8 * i), base_offset);
+		iowrite8(val >> (8 * i), base_offset);
 
 	/* Transfer Preset Register to Counter */
-	outb(QUAD8_CTR_RLD | QUAD8_RLD_PRESET_CNTR, base_offset + 1);
+	iowrite8(QUAD8_CTR_RLD | QUAD8_RLD_PRESET_CNTR, base_offset + 1);
 
 	/* Reset Byte Pointer */
-	outb(QUAD8_CTR_RLD | QUAD8_RLD_RESET_BP, base_offset + 1);
+	iowrite8(QUAD8_CTR_RLD | QUAD8_RLD_RESET_BP, base_offset + 1);
 
 	/* Set Preset Register back to original value */
 	val = priv->preset[count->id];
 	for (i = 0; i < 3; i++)
-		outb(val >> (8 * i), base_offset);
+		iowrite8(val >> (8 * i), base_offset);
 
 	/* Reset Borrow, Carry, Compare, and Sign flags */
-	outb(QUAD8_CTR_RLD | QUAD8_RLD_RESET_FLAGS, base_offset + 1);
+	iowrite8(QUAD8_CTR_RLD | QUAD8_RLD_RESET_FLAGS, base_offset + 1);
 	/* Reset Error flag */
-	outb(QUAD8_CTR_RLD | QUAD8_RLD_RESET_E, base_offset + 1);
+	iowrite8(QUAD8_CTR_RLD | QUAD8_RLD_RESET_E, base_offset + 1);
 
 	spin_unlock_irqrestore(&priv->lock, irqflags);
 
@@ -246,7 +246,7 @@ static int quad8_function_write(struct counter_device *counter,
 	unsigned int *const quadrature_mode = priv->quadrature_mode + id;
 	unsigned int *const scale = priv->quadrature_scale + id;
 	unsigned int *const synchronous_mode = priv->synchronous_mode + id;
-	const int base_offset = priv->base + 2 * id + 1;
+	void __iomem *const base_offset = priv->base + 2 * id + 1;
 	unsigned long irqflags;
 	unsigned int mode_cfg;
 	unsigned int idr_cfg;
@@ -266,7 +266,7 @@ static int quad8_function_write(struct counter_device *counter,
 		if (*synchronous_mode) {
 			*synchronous_mode = 0;
 			/* Disable synchronous function mode */
-			outb(QUAD8_CTR_IDR | idr_cfg, base_offset);
+			iowrite8(QUAD8_CTR_IDR | idr_cfg, base_offset);
 		}
 	} else {
 		*quadrature_mode = 1;
@@ -292,7 +292,7 @@ static int quad8_function_write(struct counter_device *counter,
 	}
 
 	/* Load mode configuration to Counter Mode Register */
-	outb(QUAD8_CTR_CMR | mode_cfg, base_offset);
+	iowrite8(QUAD8_CTR_CMR | mode_cfg, base_offset);
 
 	spin_unlock_irqrestore(&priv->lock, irqflags);
 
@@ -305,10 +305,10 @@ static int quad8_direction_read(struct counter_device *counter,
 {
 	const struct quad8 *const priv = counter_priv(counter);
 	unsigned int ud_flag;
-	const unsigned int flag_addr = priv->base + 2 * count->id + 1;
+	void __iomem *const flag_addr = priv->base + 2 * count->id + 1;
 
 	/* U/D flag: nonzero = up, zero = down */
-	ud_flag = inb(flag_addr) & QUAD8_FLAG_UD;
+	ud_flag = ioread8(flag_addr) & QUAD8_FLAG_UD;
 
 	*direction = (ud_flag) ? COUNTER_COUNT_DIRECTION_FORWARD :
 		COUNTER_COUNT_DIRECTION_BACKWARD;
@@ -402,7 +402,7 @@ static int quad8_events_configure(struct counter_device *counter)
 	struct counter_event_node *event_node;
 	unsigned int next_irq_trigger;
 	unsigned long ior_cfg;
-	unsigned long base_offset;
+	void __iomem *base_offset;
 
 	spin_lock_irqsave(&priv->lock, irqflags);
 
@@ -438,13 +438,13 @@ static int quad8_events_configure(struct counter_device *counter)
 			  priv->preset_enable[event_node->channel] << 1 |
 			  priv->irq_trigger[event_node->channel] << 3;
 		base_offset = priv->base + 2 * event_node->channel + 1;
-		outb(QUAD8_CTR_IOR | ior_cfg, base_offset);
+		iowrite8(QUAD8_CTR_IOR | ior_cfg, base_offset);
 
 		/* Enable IRQ line */
 		irq_enabled |= BIT(event_node->channel);
 	}
 
-	outb(irq_enabled, priv->base + QUAD8_REG_INDEX_INTERRUPT);
+	iowrite8(irq_enabled, priv->base + QUAD8_REG_INDEX_INTERRUPT);
 
 	spin_unlock_irqrestore(&priv->lock, irqflags);
 
@@ -508,7 +508,7 @@ static int quad8_index_polarity_set(struct counter_device *counter,
 {
 	struct quad8 *const priv = counter_priv(counter);
 	const size_t channel_id = signal->id - 16;
-	const int base_offset = priv->base + 2 * channel_id + 1;
+	void __iomem *const base_offset = priv->base + 2 * channel_id + 1;
 	unsigned long irqflags;
 	unsigned int idr_cfg = index_polarity << 1;
 
@@ -519,7 +519,7 @@ static int quad8_index_polarity_set(struct counter_device *counter,
 	priv->index_polarity[channel_id] = index_polarity;
 
 	/* Load Index Control configuration to Index Control Register */
-	outb(QUAD8_CTR_IDR | idr_cfg, base_offset);
+	iowrite8(QUAD8_CTR_IDR | idr_cfg, base_offset);
 
 	spin_unlock_irqrestore(&priv->lock, irqflags);
 
@@ -549,7 +549,7 @@ static int quad8_synchronous_mode_set(struct counter_device *counter,
 {
 	struct quad8 *const priv = counter_priv(counter);
 	const size_t channel_id = signal->id - 16;
-	const int base_offset = priv->base + 2 * channel_id + 1;
+	void __iomem *const base_offset = priv->base + 2 * channel_id + 1;
 	unsigned long irqflags;
 	unsigned int idr_cfg = synchronous_mode;
 
@@ -566,7 +566,7 @@ static int quad8_synchronous_mode_set(struct counter_device *counter,
 	priv->synchronous_mode[channel_id] = synchronous_mode;
 
 	/* Load Index Control configuration to Index Control Register */
-	outb(QUAD8_CTR_IDR | idr_cfg, base_offset);
+	iowrite8(QUAD8_CTR_IDR | idr_cfg, base_offset);
 
 	spin_unlock_irqrestore(&priv->lock, irqflags);
 
@@ -614,7 +614,7 @@ static int quad8_count_mode_write(struct counter_device *counter,
 	struct quad8 *const priv = counter_priv(counter);
 	unsigned int count_mode;
 	unsigned int mode_cfg;
-	const int base_offset = priv->base + 2 * count->id + 1;
+	void __iomem *const base_offset = priv->base + 2 * count->id + 1;
 	unsigned long irqflags;
 
 	/* Map Generic Counter count mode to 104-QUAD-8 count mode */
@@ -648,7 +648,7 @@ static int quad8_count_mode_write(struct counter_device *counter,
 		mode_cfg |= (priv->quadrature_scale[count->id] + 1) << 3;
 
 	/* Load mode configuration to Counter Mode Register */
-	outb(QUAD8_CTR_CMR | mode_cfg, base_offset);
+	iowrite8(QUAD8_CTR_CMR | mode_cfg, base_offset);
 
 	spin_unlock_irqrestore(&priv->lock, irqflags);
 
@@ -669,7 +669,7 @@ static int quad8_count_enable_write(struct counter_device *counter,
 				    struct counter_count *count, u8 enable)
 {
 	struct quad8 *const priv = counter_priv(counter);
-	const int base_offset = priv->base + 2 * count->id;
+	void __iomem *const base_offset = priv->base + 2 * count->id;
 	unsigned long irqflags;
 	unsigned int ior_cfg;
 
@@ -681,7 +681,7 @@ static int quad8_count_enable_write(struct counter_device *counter,
 		  priv->irq_trigger[count->id] << 3;
 
 	/* Load I/O control configuration */
-	outb(QUAD8_CTR_IOR | ior_cfg, base_offset + 1);
+	iowrite8(QUAD8_CTR_IOR | ior_cfg, base_offset + 1);
 
 	spin_unlock_irqrestore(&priv->lock, irqflags);
 
@@ -697,9 +697,9 @@ static int quad8_error_noise_get(struct counter_device *counter,
 				 struct counter_count *count, u32 *noise_error)
 {
 	const struct quad8 *const priv = counter_priv(counter);
-	const int base_offset = priv->base + 2 * count->id + 1;
+	void __iomem *const base_offset = priv->base + 2 * count->id + 1;
 
-	*noise_error = !!(inb(base_offset) & QUAD8_FLAG_E);
+	*noise_error = !!(ioread8(base_offset) & QUAD8_FLAG_E);
 
 	return 0;
 }
@@ -717,17 +717,17 @@ static int quad8_count_preset_read(struct counter_device *counter,
 static void quad8_preset_register_set(struct quad8 *const priv, const int id,
 				      const unsigned int preset)
 {
-	const unsigned int base_offset = priv->base + 2 * id;
+	void __iomem *const base_offset = priv->base + 2 * id;
 	int i;
 
 	priv->preset[id] = preset;
 
 	/* Reset Byte Pointer */
-	outb(QUAD8_CTR_RLD | QUAD8_RLD_RESET_BP, base_offset + 1);
+	iowrite8(QUAD8_CTR_RLD | QUAD8_RLD_RESET_BP, base_offset + 1);
 
 	/* Set Preset Register */
 	for (i = 0; i < 3; i++)
-		outb(preset >> (8 * i), base_offset);
+		iowrite8(preset >> (8 * i), base_offset);
 }
 
 static int quad8_count_preset_write(struct counter_device *counter,
@@ -816,7 +816,7 @@ static int quad8_count_preset_enable_write(struct counter_device *counter,
 					   u8 preset_enable)
 {
 	struct quad8 *const priv = counter_priv(counter);
-	const int base_offset = priv->base + 2 * count->id + 1;
+	void __iomem *const base_offset = priv->base + 2 * count->id + 1;
 	unsigned long irqflags;
 	unsigned int ior_cfg;
 
@@ -831,7 +831,7 @@ static int quad8_count_preset_enable_write(struct counter_device *counter,
 		  priv->irq_trigger[count->id] << 3;
 
 	/* Load I/O control configuration to Input / Output Control Register */
-	outb(QUAD8_CTR_IOR | ior_cfg, base_offset);
+	iowrite8(QUAD8_CTR_IOR | ior_cfg, base_offset);
 
 	spin_unlock_irqrestore(&priv->lock, irqflags);
 
@@ -858,7 +858,7 @@ static int quad8_signal_cable_fault_read(struct counter_device *counter,
 	}
 
 	/* Logic 0 = cable fault */
-	status = inb(priv->base + QUAD8_DIFF_ENCODER_CABLE_STATUS);
+	status = ioread8(priv->base + QUAD8_DIFF_ENCODER_CABLE_STATUS);
 
 	spin_unlock_irqrestore(&priv->lock, irqflags);
 
@@ -899,7 +899,8 @@ static int quad8_signal_cable_fault_enable_write(struct counter_device *counter,
 	/* Enable is active low in Differential Encoder Cable Status register */
 	cable_fault_enable = ~priv->cable_fault_enable;
 
-	outb(cable_fault_enable, priv->base + QUAD8_DIFF_ENCODER_CABLE_STATUS);
+	iowrite8(cable_fault_enable,
+		 priv->base + QUAD8_DIFF_ENCODER_CABLE_STATUS);
 
 	spin_unlock_irqrestore(&priv->lock, irqflags);
 
@@ -923,7 +924,7 @@ static int quad8_signal_fck_prescaler_write(struct counter_device *counter,
 {
 	struct quad8 *const priv = counter_priv(counter);
 	const size_t channel_id = signal->id / 2;
-	const int base_offset = priv->base + 2 * channel_id;
+	void __iomem *const base_offset = priv->base + 2 * channel_id;
 	unsigned long irqflags;
 
 	spin_lock_irqsave(&priv->lock, irqflags);
@@ -931,12 +932,12 @@ static int quad8_signal_fck_prescaler_write(struct counter_device *counter,
 	priv->fck_prescaler[channel_id] = prescaler;
 
 	/* Reset Byte Pointer */
-	outb(QUAD8_CTR_RLD | QUAD8_RLD_RESET_BP, base_offset + 1);
+	iowrite8(QUAD8_CTR_RLD | QUAD8_RLD_RESET_BP, base_offset + 1);
 
 	/* Set filter clock factor */
-	outb(prescaler, base_offset);
-	outb(QUAD8_CTR_RLD | QUAD8_RLD_RESET_BP | QUAD8_RLD_PRESET_PSC,
-	     base_offset + 1);
+	iowrite8(prescaler, base_offset);
+	iowrite8(QUAD8_CTR_RLD | QUAD8_RLD_RESET_BP | QUAD8_RLD_PRESET_PSC,
+		 base_offset + 1);
 
 	spin_unlock_irqrestore(&priv->lock, irqflags);
 
@@ -1084,12 +1085,12 @@ static irqreturn_t quad8_irq_handler(int irq, void *private)
 {
 	struct counter_device *counter = private;
 	struct quad8 *const priv = counter_priv(counter);
-	const unsigned long base = priv->base;
+	void __iomem *const base = priv->base;
 	unsigned long irq_status;
 	unsigned long channel;
 	u8 event;
 
-	irq_status = inb(base + QUAD8_REG_INTERRUPT_STATUS);
+	irq_status = ioread8(base + QUAD8_REG_INTERRUPT_STATUS);
 	if (!irq_status)
 		return IRQ_NONE;
 
@@ -1118,17 +1119,43 @@ static irqreturn_t quad8_irq_handler(int irq, void *private)
 	}
 
 	/* Clear pending interrupts on device */
-	outb(QUAD8_CHAN_OP_ENABLE_INTERRUPT_FUNC, base + QUAD8_REG_CHAN_OP);
+	iowrite8(QUAD8_CHAN_OP_ENABLE_INTERRUPT_FUNC, base + QUAD8_REG_CHAN_OP);
 
 	return IRQ_HANDLED;
 }
 
+static void quad8_init_counter(void __iomem *const base_offset)
+{
+	unsigned long i;
+
+	/* Reset Byte Pointer */
+	iowrite8(QUAD8_CTR_RLD | QUAD8_RLD_RESET_BP, base_offset + 1);
+	/* Reset filter clock factor */
+	iowrite8(0, base_offset);
+	iowrite8(QUAD8_CTR_RLD | QUAD8_RLD_RESET_BP | QUAD8_RLD_PRESET_PSC,
+		 base_offset + 1);
+	/* Reset Byte Pointer */
+	iowrite8(QUAD8_CTR_RLD | QUAD8_RLD_RESET_BP, base_offset + 1);
+	/* Reset Preset Register */
+	for (i = 0; i < 3; i++)
+		iowrite8(0x00, base_offset);
+	/* Reset Borrow, Carry, Compare, and Sign flags */
+	iowrite8(QUAD8_CTR_RLD | QUAD8_RLD_RESET_FLAGS, base_offset + 1);
+	/* Reset Error flag */
+	iowrite8(QUAD8_CTR_RLD | QUAD8_RLD_RESET_E, base_offset + 1);
+	/* Binary encoding; Normal count; non-quadrature mode */
+	iowrite8(QUAD8_CTR_CMR, base_offset + 1);
+	/* Disable A and B inputs; preset on index; FLG1 as Carry */
+	iowrite8(QUAD8_CTR_IOR, base_offset + 1);
+	/* Disable index function; negative index polarity */
+	iowrite8(QUAD8_CTR_IDR, base_offset + 1);
+}
+
 static int quad8_probe(struct device *dev, unsigned int id)
 {
 	struct counter_device *counter;
 	struct quad8 *priv;
-	int i, j;
-	unsigned int base_offset;
+	unsigned long i;
 	int err;
 
 	if (!devm_request_region(dev, base[id], QUAD8_EXTENT, dev_name(dev))) {
@@ -1142,6 +1169,10 @@ static int quad8_probe(struct device *dev, unsigned int id)
 		return -ENOMEM;
 	priv = counter_priv(counter);
 
+	priv->base = devm_ioport_map(dev, base[id], QUAD8_EXTENT);
+	if (!priv->base)
+		return -ENOMEM;
+
 	/* Initialize Counter device and driver data */
 	counter->name = dev_name(dev);
 	counter->parent = dev;
@@ -1150,43 +1181,21 @@ static int quad8_probe(struct device *dev, unsigned int id)
 	counter->num_counts = ARRAY_SIZE(quad8_counts);
 	counter->signals = quad8_signals;
 	counter->num_signals = ARRAY_SIZE(quad8_signals);
-	priv->base = base[id];
 
 	spin_lock_init(&priv->lock);
 
 	/* Reset Index/Interrupt Register */
-	outb(0x00, base[id] + QUAD8_REG_INDEX_INTERRUPT);
+	iowrite8(0x00, priv->base + QUAD8_REG_INDEX_INTERRUPT);
 	/* Reset all counters and disable interrupt function */
-	outb(QUAD8_CHAN_OP_RESET_COUNTERS, base[id] + QUAD8_REG_CHAN_OP);
+	iowrite8(QUAD8_CHAN_OP_RESET_COUNTERS, priv->base + QUAD8_REG_CHAN_OP);
 	/* Set initial configuration for all counters */
-	for (i = 0; i < QUAD8_NUM_COUNTERS; i++) {
-		base_offset = base[id] + 2 * i;
-		/* Reset Byte Pointer */
-		outb(QUAD8_CTR_RLD | QUAD8_RLD_RESET_BP, base_offset + 1);
-		/* Reset filter clock factor */
-		outb(0, base_offset);
-		outb(QUAD8_CTR_RLD | QUAD8_RLD_RESET_BP | QUAD8_RLD_PRESET_PSC,
-		     base_offset + 1);
-		/* Reset Byte Pointer */
-		outb(QUAD8_CTR_RLD | QUAD8_RLD_RESET_BP, base_offset + 1);
-		/* Reset Preset Register */
-		for (j = 0; j < 3; j++)
-			outb(0x00, base_offset);
-		/* Reset Borrow, Carry, Compare, and Sign flags */
-		outb(QUAD8_CTR_RLD | QUAD8_RLD_RESET_FLAGS, base_offset + 1);
-		/* Reset Error flag */
-		outb(QUAD8_CTR_RLD | QUAD8_RLD_RESET_E, base_offset + 1);
-		/* Binary encoding; Normal count; non-quadrature mode */
-		outb(QUAD8_CTR_CMR, base_offset + 1);
-		/* Disable A and B inputs; preset on index; FLG1 as Carry */
-		outb(QUAD8_CTR_IOR, base_offset + 1);
-		/* Disable index function; negative index polarity */
-		outb(QUAD8_CTR_IDR, base_offset + 1);
-	}
+	for (i = 0; i < QUAD8_NUM_COUNTERS; i++)
+		quad8_init_counter(priv->base + 2 * i);
 	/* Disable Differential Encoder Cable Status for all channels */
-	outb(0xFF, base[id] + QUAD8_DIFF_ENCODER_CABLE_STATUS);
+	iowrite8(0xFF, priv->base + QUAD8_DIFF_ENCODER_CABLE_STATUS);
 	/* Enable all counters and enable interrupt function */
-	outb(QUAD8_CHAN_OP_ENABLE_INTERRUPT_FUNC, base[id] + QUAD8_REG_CHAN_OP);
+	iowrite8(QUAD8_CHAN_OP_ENABLE_INTERRUPT_FUNC,
+		 priv->base + QUAD8_REG_CHAN_OP);
 
 	err = devm_request_irq(&counter->dev, irq[id], quad8_irq_handler,
 			       IRQF_SHARED, counter->name, counter);
-- 
2.35.1



