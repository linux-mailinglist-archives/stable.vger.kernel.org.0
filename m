Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CE68613097
	for <lists+stable@lfdr.de>; Mon, 31 Oct 2022 07:41:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbiJaGlJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Oct 2022 02:41:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbiJaGlJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Oct 2022 02:41:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB41EBE36
        for <stable@vger.kernel.org>; Sun, 30 Oct 2022 23:41:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F080D60FDF
        for <stable@vger.kernel.org>; Mon, 31 Oct 2022 06:41:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F9A7C433D6;
        Mon, 31 Oct 2022 06:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667198466;
        bh=63dwigOT1xzrEnOuAYbz8vkAVfYQRHskeJorZsSl9nY=;
        h=Subject:To:Cc:From:Date:From;
        b=EKJJdYlXCuEcACvVX3a+1Zi/Oa6vkrxZz8daZA6+SnUWA7nS12qWMkqSNczXcru/J
         3OdyCWfdJxy7RmFEHcjCH6Ej3yg5qCFXXIEGGGku/AB2+8ihzr1U6s4uPrChyBCJkj
         O8OQRzNFGzMaXquR96KZoUsI1fnssMvCfFmuF/C8=
Subject: FAILED: patch "[PATCH] counter: 104-quad-8: Fix race getting function mode and" failed to apply to 5.4-stable tree
To:     william.gray@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 31 Oct 2022 07:41:52 +0100
Message-ID: <166719851253141@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

d501d37841d3 ("counter: 104-quad-8: Fix race getting function mode and direction")
aea8334b24fe ("counter: 104-quad-8: Convert to counter_priv() wrapper")
7aa2ba0df651 ("counter: 104-quad-8: Add IRQ support for the ACCES 104-QUAD-8")
09db4678bfbb ("counter: 104-quad-8: Replace mutex with spinlock")
aaec1a0f76ec ("counter: Internalize sysfs interface code")
ea434ff82649 ("counter: stm32-timer-cnt: Provide defines for slave mode selection")
05593a3fd103 ("counter: stm32-lptimer-cnt: Provide defines for clock polarities")
394a0150a064 ("counter: Rename counter_count_function to counter_function")
493b938a14ed ("counter: Rename counter_signal_value to counter_signal_level")
b11eed1554e8 ("counter: Return error code on invalid modes")
728246e8f726 ("counter: 104-quad-8: Return error when invalid mode during ceiling_write")
d0ce3d5cf77d ("counter: stm32-timer-cnt: Add const qualifier for actions_list array")
f83e6e59366b ("counter: stm32-lptimer-cnt: Add const qualifier for actions_list array")
0056a405c7ad ("counter: microchip-tcb-capture: Add const qualifier for actions_list array")
9b2574f61c49 ("counter: ftm-quaddec: Add const qualifier for actions_list array")
6a9eb0e31044 ("counter: 104-quad-8: Add const qualifier for actions_list array")
45af9ae84c60 ("counter: stm32-timer-cnt: Add const qualifier for functions_list array")
8a00fed665ad ("counter: stm32-lptimer-cnt: Add const qualifier for functions_list array")
7e0dcfcefeca ("counter: microchip-tcb-capture: Add const qualifier for functions_list array")
891b58b35fd6 ("counter: interrupt-cnt: Add const qualifier for functions_list array")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From d501d37841d3b7f18402d71a9ef057eb9dde127e Mon Sep 17 00:00:00 2001
From: William Breathitt Gray <william.gray@linaro.org>
Date: Thu, 20 Oct 2022 10:11:21 -0400
Subject: [PATCH] counter: 104-quad-8: Fix race getting function mode and
 direction

The quad8_action_read() function checks the Count function mode and
Count direction without first acquiring a lock. This is a race condition
because the function mode could change by the time the direction is
checked.

Because the quad8_function_read() already acquires a lock internally,
the quad8_function_read() is refactored to spin out the no-lock code to
a new quad8_function_get() function.

To resolve the race condition in quad8_action_read(), a lock is acquired
before calling quad8_function_get() and quad8_direction_read() in order
to get both function mode and direction atomically.

Fixes: f1d8a071d45b ("counter: 104-quad-8: Add Generic Counter interface support")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20221020141121.15434-1-william.gray@linaro.org/
Signed-off-by: William Breathitt Gray <william.gray@linaro.org>

diff --git a/drivers/counter/104-quad-8.c b/drivers/counter/104-quad-8.c
index 77a863b7eefe..deed4afadb29 100644
--- a/drivers/counter/104-quad-8.c
+++ b/drivers/counter/104-quad-8.c
@@ -232,34 +232,45 @@ static const enum counter_function quad8_count_functions_list[] = {
 	COUNTER_FUNCTION_QUADRATURE_X4,
 };
 
+static int quad8_function_get(const struct quad8 *const priv, const size_t id,
+			      enum counter_function *const function)
+{
+	if (!priv->quadrature_mode[id]) {
+		*function = COUNTER_FUNCTION_PULSE_DIRECTION;
+		return 0;
+	}
+
+	switch (priv->quadrature_scale[id]) {
+	case 0:
+		*function = COUNTER_FUNCTION_QUADRATURE_X1_A;
+		return 0;
+	case 1:
+		*function = COUNTER_FUNCTION_QUADRATURE_X2_A;
+		return 0;
+	case 2:
+		*function = COUNTER_FUNCTION_QUADRATURE_X4;
+		return 0;
+	default:
+		/* should never reach this path */
+		return -EINVAL;
+	}
+}
+
 static int quad8_function_read(struct counter_device *counter,
 			       struct counter_count *count,
 			       enum counter_function *function)
 {
 	struct quad8 *const priv = counter_priv(counter);
-	const int id = count->id;
 	unsigned long irqflags;
+	int retval;
 
 	spin_lock_irqsave(&priv->lock, irqflags);
 
-	if (priv->quadrature_mode[id])
-		switch (priv->quadrature_scale[id]) {
-		case 0:
-			*function = COUNTER_FUNCTION_QUADRATURE_X1_A;
-			break;
-		case 1:
-			*function = COUNTER_FUNCTION_QUADRATURE_X2_A;
-			break;
-		case 2:
-			*function = COUNTER_FUNCTION_QUADRATURE_X4;
-			break;
-		}
-	else
-		*function = COUNTER_FUNCTION_PULSE_DIRECTION;
+	retval = quad8_function_get(priv, count->id, function);
 
 	spin_unlock_irqrestore(&priv->lock, irqflags);
 
-	return 0;
+	return retval;
 }
 
 static int quad8_function_write(struct counter_device *counter,
@@ -359,6 +370,7 @@ static int quad8_action_read(struct counter_device *counter,
 			     enum counter_synapse_action *action)
 {
 	struct quad8 *const priv = counter_priv(counter);
+	unsigned long irqflags;
 	int err;
 	enum counter_function function;
 	const size_t signal_a_id = count->synapses[0].signal->id;
@@ -374,9 +386,21 @@ static int quad8_action_read(struct counter_device *counter,
 		return 0;
 	}
 
-	err = quad8_function_read(counter, count, &function);
-	if (err)
+	spin_lock_irqsave(&priv->lock, irqflags);
+
+	/* Get Count function and direction atomically */
+	err = quad8_function_get(priv, count->id, &function);
+	if (err) {
+		spin_unlock_irqrestore(&priv->lock, irqflags);
+		return err;
+	}
+	err = quad8_direction_read(counter, count, &direction);
+	if (err) {
+		spin_unlock_irqrestore(&priv->lock, irqflags);
 		return err;
+	}
+
+	spin_unlock_irqrestore(&priv->lock, irqflags);
 
 	/* Default action mode */
 	*action = COUNTER_SYNAPSE_ACTION_NONE;
@@ -389,10 +413,6 @@ static int quad8_action_read(struct counter_device *counter,
 		return 0;
 	case COUNTER_FUNCTION_QUADRATURE_X1_A:
 		if (synapse->signal->id == signal_a_id) {
-			err = quad8_direction_read(counter, count, &direction);
-			if (err)
-				return err;
-
 			if (direction == COUNTER_COUNT_DIRECTION_FORWARD)
 				*action = COUNTER_SYNAPSE_ACTION_RISING_EDGE;
 			else

