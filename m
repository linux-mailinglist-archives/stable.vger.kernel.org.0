Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D65649A31F
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:02:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2366132AbiAXXwX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:52:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1844719AbiAXXKI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:10:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE4A6C09F83C;
        Mon, 24 Jan 2022 13:18:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9BE99B81057;
        Mon, 24 Jan 2022 21:18:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF1F2C340E4;
        Mon, 24 Jan 2022 21:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059091;
        bh=t17sdjoAhhTXB6mNYjmpfzPShpRY5qOINxI54UzVfxY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v8savHB4RRxlDPLgUIqZDBlXb6Y7JAUiIptlbguALrSbW3EZ6MYRJCSwYioKG/evQ
         ZX4cnRT2Do1eLGCCTKN0+J2RGT815rgduZLJ1TwUBEBDWB+Y3g+gE+N1NDRwqtJj2q
         tbkiBPHnaD+9/xOA9/Cz81ad9ZmjVdF6YtTwe3Pw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Syed Nayyar Waris <syednwaris@gmail.com>,
        William Breathitt Gray <vilhelm.gray@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0501/1039] counter: 104-quad-8: Fix persistent enabled events bug
Date:   Mon, 24 Jan 2022 19:38:10 +0100
Message-Id: <20220124184142.105182450@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: William Breathitt Gray <vilhelm.gray@gmail.com>

[ Upstream commit c95cc0d95702523f8f361b802c9b7d4eeae07f5d ]

A bug exists if the user executes a COUNTER_ADD_WATCH_IOCTL ioctl call,
and then executes a COUNTER_DISABLE_EVENTS_IOCTL ioctl call. Disabling
the events should disable the 104-QUAD-8 interrupts, but because of this
bug the interrupts are not disabling.

The reason this bug is occurring is because quad8_events_configure() is
called when COUNTER_DISABLE_EVENTS_IOCTL is handled, but the
next_irq_trigger[] array has not been cleared before it is checked in
the loop.

This patch fixes the bug by removing the next_irq_trigger array and
instead utilizing a different algorithm of walking the events_list list
for the current requested events. When a COUNTER_DISABLE_EVENTS_IOCTL is
handled, events_list will be empty and thus all device channels end up
with interrupts disabled.

Fixes: 7aa2ba0df651 ("counter: 104-quad-8: Add IRQ support for the ACCES 104-QUAD-8")
Cc: Syed Nayyar Waris <syednwaris@gmail.com>
Signed-off-by: William Breathitt Gray <vilhelm.gray@gmail.com>
Link: https://lore.kernel.org/r/5fd5731cec1c251acee30eefb7c19160d03c9d39.1640072891.git.vilhelm.gray@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/counter/104-quad-8.c | 82 +++++++++++++++++-------------------
 1 file changed, 39 insertions(+), 43 deletions(-)

diff --git a/drivers/counter/104-quad-8.c b/drivers/counter/104-quad-8.c
index 1cbd60aaed697..a97027db0446d 100644
--- a/drivers/counter/104-quad-8.c
+++ b/drivers/counter/104-quad-8.c
@@ -14,6 +14,7 @@
 #include <linux/interrupt.h>
 #include <linux/isa.h>
 #include <linux/kernel.h>
+#include <linux/list.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/types.h>
@@ -44,7 +45,6 @@ MODULE_PARM_DESC(irq, "ACCES 104-QUAD-8 interrupt line numbers");
  * @ab_enable:		array of A and B inputs enable configurations
  * @preset_enable:	array of set_to_preset_on_index attribute configurations
  * @irq_trigger:	array of current IRQ trigger function configurations
- * @next_irq_trigger:	array of next IRQ trigger function configurations
  * @synchronous_mode:	array of index function synchronous mode configurations
  * @index_polarity:	array of index function polarity configurations
  * @cable_fault_enable:	differential encoder cable status enable configurations
@@ -61,7 +61,6 @@ struct quad8 {
 	unsigned int ab_enable[QUAD8_NUM_COUNTERS];
 	unsigned int preset_enable[QUAD8_NUM_COUNTERS];
 	unsigned int irq_trigger[QUAD8_NUM_COUNTERS];
-	unsigned int next_irq_trigger[QUAD8_NUM_COUNTERS];
 	unsigned int synchronous_mode[QUAD8_NUM_COUNTERS];
 	unsigned int index_polarity[QUAD8_NUM_COUNTERS];
 	unsigned int cable_fault_enable;
@@ -390,7 +389,6 @@ static int quad8_action_read(struct counter_device *counter,
 }
 
 enum {
-	QUAD8_EVENT_NONE = -1,
 	QUAD8_EVENT_CARRY = 0,
 	QUAD8_EVENT_COMPARE = 1,
 	QUAD8_EVENT_CARRY_BORROW = 2,
@@ -402,34 +400,49 @@ static int quad8_events_configure(struct counter_device *counter)
 	struct quad8 *const priv = counter->priv;
 	unsigned long irq_enabled = 0;
 	unsigned long irqflags;
-	size_t channel;
+	struct counter_event_node *event_node;
+	unsigned int next_irq_trigger;
 	unsigned long ior_cfg;
 	unsigned long base_offset;
 
 	spin_lock_irqsave(&priv->lock, irqflags);
 
-	/* Enable interrupts for the requested channels, disable for the rest */
-	for (channel = 0; channel < QUAD8_NUM_COUNTERS; channel++) {
-		if (priv->next_irq_trigger[channel] == QUAD8_EVENT_NONE)
-			continue;
+	list_for_each_entry(event_node, &counter->events_list, l) {
+		switch (event_node->event) {
+		case COUNTER_EVENT_OVERFLOW:
+			next_irq_trigger = QUAD8_EVENT_CARRY;
+			break;
+		case COUNTER_EVENT_THRESHOLD:
+			next_irq_trigger = QUAD8_EVENT_COMPARE;
+			break;
+		case COUNTER_EVENT_OVERFLOW_UNDERFLOW:
+			next_irq_trigger = QUAD8_EVENT_CARRY_BORROW;
+			break;
+		case COUNTER_EVENT_INDEX:
+			next_irq_trigger = QUAD8_EVENT_INDEX;
+			break;
+		default:
+			/* should never reach this path */
+			spin_unlock_irqrestore(&priv->lock, irqflags);
+			return -EINVAL;
+		}
 
-		if (priv->irq_trigger[channel] != priv->next_irq_trigger[channel]) {
-			/* Save new IRQ function configuration */
-			priv->irq_trigger[channel] = priv->next_irq_trigger[channel];
+		/* Skip configuration if it is the same as previously set */
+		if (priv->irq_trigger[event_node->channel] == next_irq_trigger)
+			continue;
 
-			/* Load configuration to I/O Control Register */
-			ior_cfg = priv->ab_enable[channel] |
-				  priv->preset_enable[channel] << 1 |
-				  priv->irq_trigger[channel] << 3;
-			base_offset = priv->base + 2 * channel + 1;
-			outb(QUAD8_CTR_IOR | ior_cfg, base_offset);
-		}
+		/* Save new IRQ function configuration */
+		priv->irq_trigger[event_node->channel] = next_irq_trigger;
 
-		/* Reset next IRQ trigger function configuration */
-		priv->next_irq_trigger[channel] = QUAD8_EVENT_NONE;
+		/* Load configuration to I/O Control Register */
+		ior_cfg = priv->ab_enable[event_node->channel] |
+			  priv->preset_enable[event_node->channel] << 1 |
+			  priv->irq_trigger[event_node->channel] << 3;
+		base_offset = priv->base + 2 * event_node->channel + 1;
+		outb(QUAD8_CTR_IOR | ior_cfg, base_offset);
 
 		/* Enable IRQ line */
-		irq_enabled |= BIT(channel);
+		irq_enabled |= BIT(event_node->channel);
 	}
 
 	outb(irq_enabled, priv->base + QUAD8_REG_INDEX_INTERRUPT);
@@ -442,35 +455,20 @@ static int quad8_events_configure(struct counter_device *counter)
 static int quad8_watch_validate(struct counter_device *counter,
 				const struct counter_watch *watch)
 {
-	struct quad8 *const priv = counter->priv;
+	struct counter_event_node *event_node;
 
 	if (watch->channel > QUAD8_NUM_COUNTERS - 1)
 		return -EINVAL;
 
 	switch (watch->event) {
 	case COUNTER_EVENT_OVERFLOW:
-		if (priv->next_irq_trigger[watch->channel] == QUAD8_EVENT_NONE)
-			priv->next_irq_trigger[watch->channel] = QUAD8_EVENT_CARRY;
-		else if (priv->next_irq_trigger[watch->channel] != QUAD8_EVENT_CARRY)
-			return -EINVAL;
-		return 0;
 	case COUNTER_EVENT_THRESHOLD:
-		if (priv->next_irq_trigger[watch->channel] == QUAD8_EVENT_NONE)
-			priv->next_irq_trigger[watch->channel] = QUAD8_EVENT_COMPARE;
-		else if (priv->next_irq_trigger[watch->channel] != QUAD8_EVENT_COMPARE)
-			return -EINVAL;
-		return 0;
 	case COUNTER_EVENT_OVERFLOW_UNDERFLOW:
-		if (priv->next_irq_trigger[watch->channel] == QUAD8_EVENT_NONE)
-			priv->next_irq_trigger[watch->channel] = QUAD8_EVENT_CARRY_BORROW;
-		else if (priv->next_irq_trigger[watch->channel] != QUAD8_EVENT_CARRY_BORROW)
-			return -EINVAL;
-		return 0;
 	case COUNTER_EVENT_INDEX:
-		if (priv->next_irq_trigger[watch->channel] == QUAD8_EVENT_NONE)
-			priv->next_irq_trigger[watch->channel] = QUAD8_EVENT_INDEX;
-		else if (priv->next_irq_trigger[watch->channel] != QUAD8_EVENT_INDEX)
-			return -EINVAL;
+		list_for_each_entry(event_node, &counter->next_events_list, l)
+			if (watch->channel == event_node->channel &&
+				watch->event != event_node->event)
+				return -EINVAL;
 		return 0;
 	default:
 		return -EINVAL;
@@ -1183,8 +1181,6 @@ static int quad8_probe(struct device *dev, unsigned int id)
 		outb(QUAD8_CTR_IOR, base_offset + 1);
 		/* Disable index function; negative index polarity */
 		outb(QUAD8_CTR_IDR, base_offset + 1);
-		/* Initialize next IRQ trigger function configuration */
-		priv->next_irq_trigger[i] = QUAD8_EVENT_NONE;
 	}
 	/* Disable Differential Encoder Cable Status for all channels */
 	outb(0xFF, base[id] + QUAD8_DIFF_ENCODER_CABLE_STATUS);
-- 
2.34.1



