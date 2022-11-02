Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 694F16157F8
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:42:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230303AbiKBCm3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:42:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230297AbiKBCm2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:42:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8901820BDF
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:42:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 25AB1601C6
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 02:42:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC336C433C1;
        Wed,  2 Nov 2022 02:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667356946;
        bh=mA9+XhGEU4sQK+PX2ITHu4AuBwMOSw1F8M+ewnZM7pE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fov+ifwsDh2k8ZKp8EqWlauxJI09ZF1382SDFkrK8J48hs7ExA/VnNG6I0JwHe//I
         y7fbRC3TLGe73gNuX1SGy8saGZQWHvpJOGZYorne5nUlGnJ5SiytbvUvp1G328gbkw
         tYqmCnfLVc8oQSaXZvCwvTPDLPpVv3ZMqxGSRDSY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        William Breathitt Gray <william.gray@linaro.org>
Subject: [PATCH 6.0 086/240] counter: 104-quad-8: Fix race getting function mode and direction
Date:   Wed,  2 Nov 2022 03:31:01 +0100
Message-Id: <20221102022113.344398967@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: William Breathitt Gray <william.gray@linaro.org>

commit d501d37841d3b7f18402d71a9ef057eb9dde127e upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/counter/104-quad-8.c |   64 ++++++++++++++++++++++++++++---------------
 1 file changed, 42 insertions(+), 22 deletions(-)

--- a/drivers/counter/104-quad-8.c
+++ b/drivers/counter/104-quad-8.c
@@ -231,34 +231,45 @@ static const enum counter_function quad8
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
@@ -358,6 +369,7 @@ static int quad8_action_read(struct coun
 			     enum counter_synapse_action *action)
 {
 	struct quad8 *const priv = counter_priv(counter);
+	unsigned long irqflags;
 	int err;
 	enum counter_function function;
 	const size_t signal_a_id = count->synapses[0].signal->id;
@@ -373,9 +385,21 @@ static int quad8_action_read(struct coun
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
 		return err;
+	}
+	err = quad8_direction_read(counter, count, &direction);
+	if (err) {
+		spin_unlock_irqrestore(&priv->lock, irqflags);
+		return err;
+	}
+
+	spin_unlock_irqrestore(&priv->lock, irqflags);
 
 	/* Default action mode */
 	*action = COUNTER_SYNAPSE_ACTION_NONE;
@@ -388,10 +412,6 @@ static int quad8_action_read(struct coun
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


