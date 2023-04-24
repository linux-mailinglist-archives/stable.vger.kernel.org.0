Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72E996E6350
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:39:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231823AbjDRMjh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:39:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231814AbjDRMjf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:39:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC7751386F
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:39:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E3EEC632F0
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:39:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BF6EC433D2;
        Tue, 18 Apr 2023 12:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681821568;
        bh=U9w/OtvsjTFnYtikhW5annpQs5NI7LDCzbkXY9sAAAc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1jjGDltA6ZL54CDm0Obm31PknsCECkIKFro5Hjpkre93yB5l+wLQfaXja2YgpzZ9S
         xlZRQe9y0nrKAslGfAEQTd1RR4gnPEcGILxDOOQdkn/dGHRU/l9y00xgiK3dYDL/3g
         E4y3mZIHbaJ9lKcqKGzrMkmc/ds0ml9l+5Kc/7Zg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        Patrick Havelange <patrick.havelange@essensium.com>,
        Kamel Bouhara <kamel.bouhara@bootlin.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Syed Nayyar Waris <syednwaris@gmail.com>,
        David Lechner <david@lechnology.com>,
        William Breathitt Gray <vilhelm.gray@gmail.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>,
        Fabrice Gasnier <fabrice.gasnier@foss.st.com>
Subject: [PATCH 5.15 51/91] counter: Internalize sysfs interface code
Date:   Tue, 18 Apr 2023 14:21:55 +0200
Message-Id: <20230418120307.356208456@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120305.520719816@linuxfoundation.org>
References: <20230418120305.520719816@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: William Breathitt Gray <vilhelm.gray@gmail.com>

[ Upstream commit aaec1a0f76ec25f46bbb17b81487c4b0e1c318c5 ]

This is a reimplementation of the Generic Counter driver interface.
There are no modifications to the Counter subsystem userspace interface,
so existing userspace applications should continue to run seamlessly.

The purpose of this patch is to internalize the sysfs interface code
among the various counter drivers into a shared module. Counter drivers
pass and take data natively (i.e. u8, u64, etc.) and the shared counter
module handles the translation between the sysfs interface and the
device drivers. This guarantees a standard userspace interface for all
counter drivers, and helps generalize the Generic Counter driver ABI in
order to support the Generic Counter chrdev interface (introduced in a
subsequent patch) without significant changes to the existing counter
drivers.

Note, Counter device registration is the same as before: drivers
populate a struct counter_device with components and callbacks, then
pass the structure to the devm_counter_register function. However,
what's different now is how the Counter subsystem code handles this
registration internally.

Whereas before callbacks would interact directly with sysfs data, this
interaction is now abstracted and instead callbacks interact with native
C data types. The counter_comp structure forms the basis for Counter
extensions.

The counter-sysfs.c file contains the code to parse through the
counter_device structure and register the requested components and
extensions. Attributes are created and populated based on type, with
respective translation functions to handle the mapping between sysfs and
the counter driver callbacks.

The translation performed for each attribute is straightforward: the
attribute type and data is parsed from the counter_attribute structure,
the respective counter driver read/write callback is called, and sysfs
I/O is handled before or after the driver read/write function is called.

Cc: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Cc: Patrick Havelange <patrick.havelange@essensium.com>
Cc: Kamel Bouhara <kamel.bouhara@bootlin.com>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Syed Nayyar Waris <syednwaris@gmail.com>
Reviewed-by: David Lechner <david@lechnology.com>
Tested-by: David Lechner <david@lechnology.com>
Signed-off-by: William Breathitt Gray <vilhelm.gray@gmail.com>
Reviewed-by: Fabrice Gasnier <fabrice.gasnier@foss.st.com> # for stm32
Link: https://lore.kernel.org/r/c68b4a1ffb195c1a2f65e8dd5ad7b7c14e79c6ef.1630031207.git.vilhelm.gray@gmail.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Stable-dep-of: 00f4bc5184c1 ("counter: 104-quad-8: Fix Synapse action reported for Index signals")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 MAINTAINERS                             |    1 -
 drivers/counter/104-quad-8.c            |  449 +++----
 drivers/counter/Makefile                |    1 +
 drivers/counter/counter-core.c          |  142 +++
 drivers/counter/counter-sysfs.c         |  849 +++++++++++++
 drivers/counter/counter-sysfs.h         |   13 +
 drivers/counter/counter.c               | 1496 -----------------------
 drivers/counter/ftm-quaddec.c           |   60 +-
 drivers/counter/intel-qep.c             |  146 +--
 drivers/counter/interrupt-cnt.c         |   62 +-
 drivers/counter/microchip-tcb-capture.c |   91 +-
 drivers/counter/stm32-lptimer-cnt.c     |  212 ++--
 drivers/counter/stm32-timer-cnt.c       |  179 ++-
 drivers/counter/ti-eqep.c               |  180 +--
 include/linux/counter.h                 |  658 +++++-----
 include/linux/counter_enum.h            |   45 -
 16 files changed, 1950 insertions(+), 2634 deletions(-)
 create mode 100644 drivers/counter/counter-core.c
 create mode 100644 drivers/counter/counter-sysfs.c
 create mode 100644 drivers/counter/counter-sysfs.h
 delete mode 100644 drivers/counter/counter.c
 delete mode 100644 include/linux/counter_enum.h

diff --git a/MAINTAINERS b/MAINTAINERS
index d0884a5d49b99..2d3d2155c744d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4813,7 +4813,6 @@ F:	Documentation/ABI/testing/sysfs-bus-counter
 F:	Documentation/driver-api/generic-counter.rst
 F:	drivers/counter/
 F:	include/linux/counter.h
-F:	include/linux/counter_enum.h
 
 CP2615 I2C DRIVER
 M:	Bence Csókás <bence98@sch.bme.hu>
diff --git a/drivers/counter/104-quad-8.c b/drivers/counter/104-quad-8.c
index 0caa60537b142..c587f295d720e 100644
--- a/drivers/counter/104-quad-8.c
+++ b/drivers/counter/104-quad-8.c
@@ -117,7 +117,7 @@ static int quad8_signal_read(struct counter_device *counter,
 }
 
 static int quad8_count_read(struct counter_device *counter,
-	struct counter_count *count, unsigned long *val)
+			    struct counter_count *count, u64 *val)
 {
 	struct quad8 *const priv = counter->priv;
 	const int base_offset = priv->base + 2 * count->id;
@@ -148,7 +148,7 @@ static int quad8_count_read(struct counter_device *counter,
 }
 
 static int quad8_count_write(struct counter_device *counter,
-	struct counter_count *count, unsigned long val)
+			     struct counter_count *count, u64 val)
 {
 	struct quad8 *const priv = counter->priv;
 	const int base_offset = priv->base + 2 * count->id;
@@ -188,22 +188,16 @@ static int quad8_count_write(struct counter_device *counter,
 	return 0;
 }
 
-enum quad8_count_function {
-	QUAD8_COUNT_FUNCTION_PULSE_DIRECTION = 0,
-	QUAD8_COUNT_FUNCTION_QUADRATURE_X1,
-	QUAD8_COUNT_FUNCTION_QUADRATURE_X2,
-	QUAD8_COUNT_FUNCTION_QUADRATURE_X4
-};
-
 static const enum counter_function quad8_count_functions_list[] = {
-	[QUAD8_COUNT_FUNCTION_PULSE_DIRECTION] = COUNTER_FUNCTION_PULSE_DIRECTION,
-	[QUAD8_COUNT_FUNCTION_QUADRATURE_X1] = COUNTER_FUNCTION_QUADRATURE_X1_A,
-	[QUAD8_COUNT_FUNCTION_QUADRATURE_X2] = COUNTER_FUNCTION_QUADRATURE_X2_A,
-	[QUAD8_COUNT_FUNCTION_QUADRATURE_X4] = COUNTER_FUNCTION_QUADRATURE_X4
+	COUNTER_FUNCTION_PULSE_DIRECTION,
+	COUNTER_FUNCTION_QUADRATURE_X1_A,
+	COUNTER_FUNCTION_QUADRATURE_X2_A,
+	COUNTER_FUNCTION_QUADRATURE_X4,
 };
 
-static int quad8_function_get(struct counter_device *counter,
-	struct counter_count *count, size_t *function)
+static int quad8_function_read(struct counter_device *counter,
+			       struct counter_count *count,
+			       enum counter_function *function)
 {
 	struct quad8 *const priv = counter->priv;
 	const int id = count->id;
@@ -213,25 +207,26 @@ static int quad8_function_get(struct counter_device *counter,
 	if (priv->quadrature_mode[id])
 		switch (priv->quadrature_scale[id]) {
 		case 0:
-			*function = QUAD8_COUNT_FUNCTION_QUADRATURE_X1;
+			*function = COUNTER_FUNCTION_QUADRATURE_X1_A;
 			break;
 		case 1:
-			*function = QUAD8_COUNT_FUNCTION_QUADRATURE_X2;
+			*function = COUNTER_FUNCTION_QUADRATURE_X2_A;
 			break;
 		case 2:
-			*function = QUAD8_COUNT_FUNCTION_QUADRATURE_X4;
+			*function = COUNTER_FUNCTION_QUADRATURE_X4;
 			break;
 		}
 	else
-		*function = QUAD8_COUNT_FUNCTION_PULSE_DIRECTION;
+		*function = COUNTER_FUNCTION_PULSE_DIRECTION;
 
 	mutex_unlock(&priv->lock);
 
 	return 0;
 }
 
-static int quad8_function_set(struct counter_device *counter,
-	struct counter_count *count, size_t function)
+static int quad8_function_write(struct counter_device *counter,
+				struct counter_count *count,
+				enum counter_function function)
 {
 	struct quad8 *const priv = counter->priv;
 	const int id = count->id;
@@ -247,7 +242,7 @@ static int quad8_function_set(struct counter_device *counter,
 	mode_cfg = priv->count_mode[id] << 1;
 	idr_cfg = priv->index_polarity[id] << 1;
 
-	if (function == QUAD8_COUNT_FUNCTION_PULSE_DIRECTION) {
+	if (function == COUNTER_FUNCTION_PULSE_DIRECTION) {
 		*quadrature_mode = 0;
 
 		/* Quadrature scaling only available in quadrature mode */
@@ -263,15 +258,15 @@ static int quad8_function_set(struct counter_device *counter,
 		*quadrature_mode = 1;
 
 		switch (function) {
-		case QUAD8_COUNT_FUNCTION_QUADRATURE_X1:
+		case COUNTER_FUNCTION_QUADRATURE_X1_A:
 			*scale = 0;
 			mode_cfg |= QUAD8_CMR_QUADRATURE_X1;
 			break;
-		case QUAD8_COUNT_FUNCTION_QUADRATURE_X2:
+		case COUNTER_FUNCTION_QUADRATURE_X2_A:
 			*scale = 1;
 			mode_cfg |= QUAD8_CMR_QUADRATURE_X2;
 			break;
-		case QUAD8_COUNT_FUNCTION_QUADRATURE_X4:
+		case COUNTER_FUNCTION_QUADRATURE_X4:
 			*scale = 2;
 			mode_cfg |= QUAD8_CMR_QUADRATURE_X4;
 			break;
@@ -290,8 +285,9 @@ static int quad8_function_set(struct counter_device *counter,
 	return 0;
 }
 
-static void quad8_direction_get(struct counter_device *counter,
-	struct counter_count *count, enum counter_count_direction *direction)
+static int quad8_direction_read(struct counter_device *counter,
+				struct counter_count *count,
+				enum counter_count_direction *direction)
 {
 	const struct quad8 *const priv = counter->priv;
 	unsigned int ud_flag;
@@ -302,76 +298,74 @@ static void quad8_direction_get(struct counter_device *counter,
 
 	*direction = (ud_flag) ? COUNTER_COUNT_DIRECTION_FORWARD :
 		COUNTER_COUNT_DIRECTION_BACKWARD;
-}
 
-enum quad8_synapse_action {
-	QUAD8_SYNAPSE_ACTION_NONE = 0,
-	QUAD8_SYNAPSE_ACTION_RISING_EDGE,
-	QUAD8_SYNAPSE_ACTION_FALLING_EDGE,
-	QUAD8_SYNAPSE_ACTION_BOTH_EDGES
-};
+	return 0;
+}
 
 static const enum counter_synapse_action quad8_index_actions_list[] = {
-	[QUAD8_SYNAPSE_ACTION_NONE] = COUNTER_SYNAPSE_ACTION_NONE,
-	[QUAD8_SYNAPSE_ACTION_RISING_EDGE] = COUNTER_SYNAPSE_ACTION_RISING_EDGE
+	COUNTER_SYNAPSE_ACTION_NONE,
+	COUNTER_SYNAPSE_ACTION_RISING_EDGE,
 };
 
 static const enum counter_synapse_action quad8_synapse_actions_list[] = {
-	[QUAD8_SYNAPSE_ACTION_NONE] = COUNTER_SYNAPSE_ACTION_NONE,
-	[QUAD8_SYNAPSE_ACTION_RISING_EDGE] = COUNTER_SYNAPSE_ACTION_RISING_EDGE,
-	[QUAD8_SYNAPSE_ACTION_FALLING_EDGE] = COUNTER_SYNAPSE_ACTION_FALLING_EDGE,
-	[QUAD8_SYNAPSE_ACTION_BOTH_EDGES] = COUNTER_SYNAPSE_ACTION_BOTH_EDGES
+	COUNTER_SYNAPSE_ACTION_NONE,
+	COUNTER_SYNAPSE_ACTION_RISING_EDGE,
+	COUNTER_SYNAPSE_ACTION_FALLING_EDGE,
+	COUNTER_SYNAPSE_ACTION_BOTH_EDGES,
 };
 
-static int quad8_action_get(struct counter_device *counter,
-	struct counter_count *count, struct counter_synapse *synapse,
-	size_t *action)
+static int quad8_action_read(struct counter_device *counter,
+			     struct counter_count *count,
+			     struct counter_synapse *synapse,
+			     enum counter_synapse_action *action)
 {
 	struct quad8 *const priv = counter->priv;
 	int err;
-	size_t function = 0;
+	enum counter_function function;
 	const size_t signal_a_id = count->synapses[0].signal->id;
 	enum counter_count_direction direction;
 
 	/* Handle Index signals */
 	if (synapse->signal->id >= 16) {
 		if (priv->preset_enable[count->id])
-			*action = QUAD8_SYNAPSE_ACTION_RISING_EDGE;
+			*action = COUNTER_SYNAPSE_ACTION_RISING_EDGE;
 		else
-			*action = QUAD8_SYNAPSE_ACTION_NONE;
+			*action = COUNTER_SYNAPSE_ACTION_NONE;
 
 		return 0;
 	}
 
-	err = quad8_function_get(counter, count, &function);
+	err = quad8_function_read(counter, count, &function);
 	if (err)
 		return err;
 
 	/* Default action mode */
-	*action = QUAD8_SYNAPSE_ACTION_NONE;
+	*action = COUNTER_SYNAPSE_ACTION_NONE;
 
 	/* Determine action mode based on current count function mode */
 	switch (function) {
-	case QUAD8_COUNT_FUNCTION_PULSE_DIRECTION:
+	case COUNTER_FUNCTION_PULSE_DIRECTION:
 		if (synapse->signal->id == signal_a_id)
-			*action = QUAD8_SYNAPSE_ACTION_RISING_EDGE;
+			*action = COUNTER_SYNAPSE_ACTION_RISING_EDGE;
 		return 0;
-	case QUAD8_COUNT_FUNCTION_QUADRATURE_X1:
+	case COUNTER_FUNCTION_QUADRATURE_X1_A:
 		if (synapse->signal->id == signal_a_id) {
-			quad8_direction_get(counter, count, &direction);
+			err = quad8_direction_read(counter, count, &direction);
+			if (err)
+				return err;
 
 			if (direction == COUNTER_COUNT_DIRECTION_FORWARD)
-				*action = QUAD8_SYNAPSE_ACTION_RISING_EDGE;
+				*action = COUNTER_SYNAPSE_ACTION_RISING_EDGE;
 			else
-				*action = QUAD8_SYNAPSE_ACTION_FALLING_EDGE;
+				*action = COUNTER_SYNAPSE_ACTION_FALLING_EDGE;
 		}
 		return 0;
-	case QUAD8_COUNT_FUNCTION_QUADRATURE_X2:
+	case COUNTER_FUNCTION_QUADRATURE_X2_A:
 		if (synapse->signal->id == signal_a_id)
-			*action = QUAD8_SYNAPSE_ACTION_BOTH_EDGES;
+			*action = COUNTER_SYNAPSE_ACTION_BOTH_EDGES;
 		return 0;
-	case QUAD8_COUNT_FUNCTION_QUADRATURE_X4:
-		*action = QUAD8_SYNAPSE_ACTION_BOTH_EDGES;
+	case COUNTER_FUNCTION_QUADRATURE_X4:
+		*action = COUNTER_SYNAPSE_ACTION_BOTH_EDGES;
 		return 0;
 	default:
 		/* should never reach this path */
@@ -383,9 +377,9 @@ static const struct counter_ops quad8_ops = {
 	.signal_read = quad8_signal_read,
 	.count_read = quad8_count_read,
 	.count_write = quad8_count_write,
-	.function_get = quad8_function_get,
-	.function_set = quad8_function_set,
-	.action_get = quad8_action_get
+	.function_read = quad8_function_read,
+	.function_write = quad8_function_write,
+	.action_read = quad8_action_read
 };
 
 static const char *const quad8_index_polarity_modes[] = {
@@ -394,7 +388,8 @@ static const char *const quad8_index_polarity_modes[] = {
 };
 
 static int quad8_index_polarity_get(struct counter_device *counter,
-	struct counter_signal *signal, size_t *index_polarity)
+				    struct counter_signal *signal,
+				    u32 *index_polarity)
 {
 	const struct quad8 *const priv = counter->priv;
 	const size_t channel_id = signal->id - 16;
@@ -405,7 +400,8 @@ static int quad8_index_polarity_get(struct counter_device *counter,
 }
 
 static int quad8_index_polarity_set(struct counter_device *counter,
-	struct counter_signal *signal, size_t index_polarity)
+				    struct counter_signal *signal,
+				    u32 index_polarity)
 {
 	struct quad8 *const priv = counter->priv;
 	const size_t channel_id = signal->id - 16;
@@ -426,20 +422,14 @@ static int quad8_index_polarity_set(struct counter_device *counter,
 	return 0;
 }
 
-static struct counter_signal_enum_ext quad8_index_pol_enum = {
-	.items = quad8_index_polarity_modes,
-	.num_items = ARRAY_SIZE(quad8_index_polarity_modes),
-	.get = quad8_index_polarity_get,
-	.set = quad8_index_polarity_set
-};
-
 static const char *const quad8_synchronous_modes[] = {
 	"non-synchronous",
 	"synchronous"
 };
 
 static int quad8_synchronous_mode_get(struct counter_device *counter,
-	struct counter_signal *signal, size_t *synchronous_mode)
+				      struct counter_signal *signal,
+				      u32 *synchronous_mode)
 {
 	const struct quad8 *const priv = counter->priv;
 	const size_t channel_id = signal->id - 16;
@@ -450,7 +440,8 @@ static int quad8_synchronous_mode_get(struct counter_device *counter,
 }
 
 static int quad8_synchronous_mode_set(struct counter_device *counter,
-	struct counter_signal *signal, size_t synchronous_mode)
+				      struct counter_signal *signal,
+				      u32 synchronous_mode)
 {
 	struct quad8 *const priv = counter->priv;
 	const size_t channel_id = signal->id - 16;
@@ -477,22 +468,18 @@ static int quad8_synchronous_mode_set(struct counter_device *counter,
 	return 0;
 }
 
-static struct counter_signal_enum_ext quad8_syn_mode_enum = {
-	.items = quad8_synchronous_modes,
-	.num_items = ARRAY_SIZE(quad8_synchronous_modes),
-	.get = quad8_synchronous_mode_get,
-	.set = quad8_synchronous_mode_set
-};
-
-static ssize_t quad8_count_floor_read(struct counter_device *counter,
-	struct counter_count *count, void *private, char *buf)
+static int quad8_count_floor_read(struct counter_device *counter,
+				  struct counter_count *count, u64 *floor)
 {
 	/* Only a floor of 0 is supported */
-	return sprintf(buf, "0\n");
+	*floor = 0;
+
+	return 0;
 }
 
-static int quad8_count_mode_get(struct counter_device *counter,
-	struct counter_count *count, size_t *cnt_mode)
+static int quad8_count_mode_read(struct counter_device *counter,
+				 struct counter_count *count,
+				 enum counter_count_mode *cnt_mode)
 {
 	const struct quad8 *const priv = counter->priv;
 
@@ -515,26 +502,28 @@ static int quad8_count_mode_get(struct counter_device *counter,
 	return 0;
 }
 
-static int quad8_count_mode_set(struct counter_device *counter,
-	struct counter_count *count, size_t cnt_mode)
+static int quad8_count_mode_write(struct counter_device *counter,
+				  struct counter_count *count,
+				  enum counter_count_mode cnt_mode)
 {
 	struct quad8 *const priv = counter->priv;
+	unsigned int count_mode;
 	unsigned int mode_cfg;
 	const int base_offset = priv->base + 2 * count->id + 1;
 
 	/* Map Generic Counter count mode to 104-QUAD-8 count mode */
 	switch (cnt_mode) {
 	case COUNTER_COUNT_MODE_NORMAL:
-		cnt_mode = 0;
+		count_mode = 0;
 		break;
 	case COUNTER_COUNT_MODE_RANGE_LIMIT:
-		cnt_mode = 1;
+		count_mode = 1;
 		break;
 	case COUNTER_COUNT_MODE_NON_RECYCLE:
-		cnt_mode = 2;
+		count_mode = 2;
 		break;
 	case COUNTER_COUNT_MODE_MODULO_N:
-		cnt_mode = 3;
+		count_mode = 3;
 		break;
 	default:
 		/* should never reach this path */
@@ -543,10 +532,10 @@ static int quad8_count_mode_set(struct counter_device *counter,
 
 	mutex_lock(&priv->lock);
 
-	priv->count_mode[count->id] = cnt_mode;
+	priv->count_mode[count->id] = count_mode;
 
 	/* Set count mode configuration value */
-	mode_cfg = cnt_mode << 1;
+	mode_cfg = count_mode << 1;
 
 	/* Add quadrature mode configuration */
 	if (priv->quadrature_mode[count->id])
@@ -560,56 +549,35 @@ static int quad8_count_mode_set(struct counter_device *counter,
 	return 0;
 }
 
-static struct counter_count_enum_ext quad8_cnt_mode_enum = {
-	.items = counter_count_mode_str,
-	.num_items = ARRAY_SIZE(counter_count_mode_str),
-	.get = quad8_count_mode_get,
-	.set = quad8_count_mode_set
-};
-
-static ssize_t quad8_count_direction_read(struct counter_device *counter,
-	struct counter_count *count, void *priv, char *buf)
-{
-	enum counter_count_direction dir;
-
-	quad8_direction_get(counter, count, &dir);
-
-	return sprintf(buf, "%s\n", counter_count_direction_str[dir]);
-}
-
-static ssize_t quad8_count_enable_read(struct counter_device *counter,
-	struct counter_count *count, void *private, char *buf)
+static int quad8_count_enable_read(struct counter_device *counter,
+				   struct counter_count *count, u8 *enable)
 {
 	const struct quad8 *const priv = counter->priv;
 
-	return sprintf(buf, "%u\n", priv->ab_enable[count->id]);
+	*enable = priv->ab_enable[count->id];
+
+	return 0;
 }
 
-static ssize_t quad8_count_enable_write(struct counter_device *counter,
-	struct counter_count *count, void *private, const char *buf, size_t len)
+static int quad8_count_enable_write(struct counter_device *counter,
+				    struct counter_count *count, u8 enable)
 {
 	struct quad8 *const priv = counter->priv;
 	const int base_offset = priv->base + 2 * count->id;
-	int err;
-	bool ab_enable;
 	unsigned int ior_cfg;
 
-	err = kstrtobool(buf, &ab_enable);
-	if (err)
-		return err;
-
 	mutex_lock(&priv->lock);
 
-	priv->ab_enable[count->id] = ab_enable;
+	priv->ab_enable[count->id] = enable;
 
-	ior_cfg = ab_enable | priv->preset_enable[count->id] << 1;
+	ior_cfg = enable | priv->preset_enable[count->id] << 1;
 
 	/* Load I/O control configuration */
 	outb(QUAD8_CTR_IOR | ior_cfg, base_offset + 1);
 
 	mutex_unlock(&priv->lock);
 
-	return len;
+	return 0;
 }
 
 static const char *const quad8_noise_error_states[] = {
@@ -618,7 +586,7 @@ static const char *const quad8_noise_error_states[] = {
 };
 
 static int quad8_error_noise_get(struct counter_device *counter,
-	struct counter_count *count, size_t *noise_error)
+				 struct counter_count *count, u32 *noise_error)
 {
 	const struct quad8 *const priv = counter->priv;
 	const int base_offset = priv->base + 2 * count->id + 1;
@@ -628,18 +596,14 @@ static int quad8_error_noise_get(struct counter_device *counter,
 	return 0;
 }
 
-static struct counter_count_enum_ext quad8_error_noise_enum = {
-	.items = quad8_noise_error_states,
-	.num_items = ARRAY_SIZE(quad8_noise_error_states),
-	.get = quad8_error_noise_get
-};
-
-static ssize_t quad8_count_preset_read(struct counter_device *counter,
-	struct counter_count *count, void *private, char *buf)
+static int quad8_count_preset_read(struct counter_device *counter,
+				   struct counter_count *count, u64 *preset)
 {
 	const struct quad8 *const priv = counter->priv;
 
-	return sprintf(buf, "%u\n", priv->preset[count->id]);
+	*preset = priv->preset[count->id];
+
+	return 0;
 }
 
 static void quad8_preset_register_set(struct quad8 *const priv, const int id,
@@ -658,16 +622,10 @@ static void quad8_preset_register_set(struct quad8 *const priv, const int id,
 		outb(preset >> (8 * i), base_offset);
 }
 
-static ssize_t quad8_count_preset_write(struct counter_device *counter,
-	struct counter_count *count, void *private, const char *buf, size_t len)
+static int quad8_count_preset_write(struct counter_device *counter,
+				    struct counter_count *count, u64 preset)
 {
 	struct quad8 *const priv = counter->priv;
-	unsigned int preset;
-	int ret;
-
-	ret = kstrtouint(buf, 0, &preset);
-	if (ret)
-		return ret;
 
 	/* Only 24-bit values are supported */
 	if (preset > 0xFFFFFF)
@@ -679,11 +637,11 @@ static ssize_t quad8_count_preset_write(struct counter_device *counter,
 
 	mutex_unlock(&priv->lock);
 
-	return len;
+	return 0;
 }
 
-static ssize_t quad8_count_ceiling_read(struct counter_device *counter,
-	struct counter_count *count, void *private, char *buf)
+static int quad8_count_ceiling_read(struct counter_device *counter,
+				    struct counter_count *count, u64 *ceiling)
 {
 	struct quad8 *const priv = counter->priv;
 
@@ -693,26 +651,23 @@ static ssize_t quad8_count_ceiling_read(struct counter_device *counter,
 	switch (priv->count_mode[count->id]) {
 	case 1:
 	case 3:
-		mutex_unlock(&priv->lock);
-		return sprintf(buf, "%u\n", priv->preset[count->id]);
+		*ceiling = priv->preset[count->id];
+		break;
+	default:
+		/* By default 0x1FFFFFF (25 bits unsigned) is maximum count */
+		*ceiling = 0x1FFFFFF;
+		break;
 	}
 
 	mutex_unlock(&priv->lock);
 
-	/* By default 0x1FFFFFF (25 bits unsigned) is maximum count */
-	return sprintf(buf, "33554431\n");
+	return 0;
 }
 
-static ssize_t quad8_count_ceiling_write(struct counter_device *counter,
-	struct counter_count *count, void *private, const char *buf, size_t len)
+static int quad8_count_ceiling_write(struct counter_device *counter,
+				     struct counter_count *count, u64 ceiling)
 {
 	struct quad8 *const priv = counter->priv;
-	unsigned int ceiling;
-	int ret;
-
-	ret = kstrtouint(buf, 0, &ceiling);
-	if (ret)
-		return ret;
 
 	/* Only 24-bit values are supported */
 	if (ceiling > 0xFFFFFF)
@@ -726,7 +681,7 @@ static ssize_t quad8_count_ceiling_write(struct counter_device *counter,
 	case 3:
 		quad8_preset_register_set(priv, count->id, ceiling);
 		mutex_unlock(&priv->lock);
-		return len;
+		return 0;
 	}
 
 	mutex_unlock(&priv->lock);
@@ -734,27 +689,25 @@ static ssize_t quad8_count_ceiling_write(struct counter_device *counter,
 	return -EINVAL;
 }
 
-static ssize_t quad8_count_preset_enable_read(struct counter_device *counter,
-	struct counter_count *count, void *private, char *buf)
+static int quad8_count_preset_enable_read(struct counter_device *counter,
+					  struct counter_count *count,
+					  u8 *preset_enable)
 {
 	const struct quad8 *const priv = counter->priv;
 
-	return sprintf(buf, "%u\n", !priv->preset_enable[count->id]);
+	*preset_enable = !priv->preset_enable[count->id];
+
+	return 0;
 }
 
-static ssize_t quad8_count_preset_enable_write(struct counter_device *counter,
-	struct counter_count *count, void *private, const char *buf, size_t len)
+static int quad8_count_preset_enable_write(struct counter_device *counter,
+					   struct counter_count *count,
+					   u8 preset_enable)
 {
 	struct quad8 *const priv = counter->priv;
 	const int base_offset = priv->base + 2 * count->id + 1;
-	bool preset_enable;
-	int ret;
 	unsigned int ior_cfg;
 
-	ret = kstrtobool(buf, &preset_enable);
-	if (ret)
-		return ret;
-
 	/* Preset enable is active low in Input/Output Control register */
 	preset_enable = !preset_enable;
 
@@ -762,25 +715,24 @@ static ssize_t quad8_count_preset_enable_write(struct counter_device *counter,
 
 	priv->preset_enable[count->id] = preset_enable;
 
-	ior_cfg = priv->ab_enable[count->id] | (unsigned int)preset_enable << 1;
+	ior_cfg = priv->ab_enable[count->id] | preset_enable << 1;
 
 	/* Load I/O control configuration to Input / Output Control Register */
 	outb(QUAD8_CTR_IOR | ior_cfg, base_offset);
 
 	mutex_unlock(&priv->lock);
 
-	return len;
+	return 0;
 }
 
-static ssize_t quad8_signal_cable_fault_read(struct counter_device *counter,
-					     struct counter_signal *signal,
-					     void *private, char *buf)
+static int quad8_signal_cable_fault_read(struct counter_device *counter,
+					 struct counter_signal *signal,
+					 u8 *cable_fault)
 {
 	struct quad8 *const priv = counter->priv;
 	const size_t channel_id = signal->id / 2;
 	bool disabled;
 	unsigned int status;
-	unsigned int fault;
 
 	mutex_lock(&priv->lock);
 
@@ -797,36 +749,31 @@ static ssize_t quad8_signal_cable_fault_read(struct counter_device *counter,
 	mutex_unlock(&priv->lock);
 
 	/* Mask respective channel and invert logic */
-	fault = !(status & BIT(channel_id));
+	*cable_fault = !(status & BIT(channel_id));
 
-	return sprintf(buf, "%u\n", fault);
+	return 0;
 }
 
-static ssize_t quad8_signal_cable_fault_enable_read(
-	struct counter_device *counter, struct counter_signal *signal,
-	void *private, char *buf)
+static int quad8_signal_cable_fault_enable_read(struct counter_device *counter,
+						struct counter_signal *signal,
+						u8 *enable)
 {
 	const struct quad8 *const priv = counter->priv;
 	const size_t channel_id = signal->id / 2;
-	const unsigned int enb = !!(priv->cable_fault_enable & BIT(channel_id));
 
-	return sprintf(buf, "%u\n", enb);
+	*enable = !!(priv->cable_fault_enable & BIT(channel_id));
+
+	return 0;
 }
 
-static ssize_t quad8_signal_cable_fault_enable_write(
-	struct counter_device *counter, struct counter_signal *signal,
-	void *private, const char *buf, size_t len)
+static int quad8_signal_cable_fault_enable_write(struct counter_device *counter,
+						 struct counter_signal *signal,
+						 u8 enable)
 {
 	struct quad8 *const priv = counter->priv;
 	const size_t channel_id = signal->id / 2;
-	bool enable;
-	int ret;
 	unsigned int cable_fault_enable;
 
-	ret = kstrtobool(buf, &enable);
-	if (ret)
-		return ret;
-
 	mutex_lock(&priv->lock);
 
 	if (enable)
@@ -841,31 +788,27 @@ static ssize_t quad8_signal_cable_fault_enable_write(
 
 	mutex_unlock(&priv->lock);
 
-	return len;
+	return 0;
 }
 
-static ssize_t quad8_signal_fck_prescaler_read(struct counter_device *counter,
-	struct counter_signal *signal, void *private, char *buf)
+static int quad8_signal_fck_prescaler_read(struct counter_device *counter,
+					   struct counter_signal *signal,
+					   u8 *prescaler)
 {
 	const struct quad8 *const priv = counter->priv;
-	const size_t channel_id = signal->id / 2;
 
-	return sprintf(buf, "%u\n", priv->fck_prescaler[channel_id]);
+	*prescaler = priv->fck_prescaler[signal->id / 2];
+
+	return 0;
 }
 
-static ssize_t quad8_signal_fck_prescaler_write(struct counter_device *counter,
-	struct counter_signal *signal, void *private, const char *buf,
-	size_t len)
+static int quad8_signal_fck_prescaler_write(struct counter_device *counter,
+					    struct counter_signal *signal,
+					    u8 prescaler)
 {
 	struct quad8 *const priv = counter->priv;
 	const size_t channel_id = signal->id / 2;
 	const int base_offset = priv->base + 2 * channel_id;
-	u8 prescaler;
-	int ret;
-
-	ret = kstrtou8(buf, 0, &prescaler);
-	if (ret)
-		return ret;
 
 	mutex_lock(&priv->lock);
 
@@ -881,31 +824,30 @@ static ssize_t quad8_signal_fck_prescaler_write(struct counter_device *counter,
 
 	mutex_unlock(&priv->lock);
 
-	return len;
+	return 0;
 }
 
-static const struct counter_signal_ext quad8_signal_ext[] = {
-	{
-		.name = "cable_fault",
-		.read = quad8_signal_cable_fault_read
-	},
-	{
-		.name = "cable_fault_enable",
-		.read = quad8_signal_cable_fault_enable_read,
-		.write = quad8_signal_cable_fault_enable_write
-	},
-	{
-		.name = "filter_clock_prescaler",
-		.read = quad8_signal_fck_prescaler_read,
-		.write = quad8_signal_fck_prescaler_write
-	}
+static struct counter_comp quad8_signal_ext[] = {
+	COUNTER_COMP_SIGNAL_BOOL("cable_fault", quad8_signal_cable_fault_read,
+				 NULL),
+	COUNTER_COMP_SIGNAL_BOOL("cable_fault_enable",
+				 quad8_signal_cable_fault_enable_read,
+				 quad8_signal_cable_fault_enable_write),
+	COUNTER_COMP_SIGNAL_U8("filter_clock_prescaler",
+			       quad8_signal_fck_prescaler_read,
+			       quad8_signal_fck_prescaler_write)
 };
 
-static const struct counter_signal_ext quad8_index_ext[] = {
-	COUNTER_SIGNAL_ENUM("index_polarity", &quad8_index_pol_enum),
-	COUNTER_SIGNAL_ENUM_AVAILABLE("index_polarity",	&quad8_index_pol_enum),
-	COUNTER_SIGNAL_ENUM("synchronous_mode", &quad8_syn_mode_enum),
-	COUNTER_SIGNAL_ENUM_AVAILABLE("synchronous_mode", &quad8_syn_mode_enum)
+static DEFINE_COUNTER_ENUM(quad8_index_pol_enum, quad8_index_polarity_modes);
+static DEFINE_COUNTER_ENUM(quad8_synch_mode_enum, quad8_synchronous_modes);
+
+static struct counter_comp quad8_index_ext[] = {
+	COUNTER_COMP_SIGNAL_ENUM("index_polarity", quad8_index_polarity_get,
+				 quad8_index_polarity_set,
+				 quad8_index_pol_enum),
+	COUNTER_COMP_SIGNAL_ENUM("synchronous_mode", quad8_synchronous_mode_get,
+				 quad8_synchronous_mode_set,
+				 quad8_synch_mode_enum),
 };
 
 #define QUAD8_QUAD_SIGNAL(_id, _name) {		\
@@ -974,39 +916,30 @@ static struct counter_synapse quad8_count_synapses[][3] = {
 	QUAD8_COUNT_SYNAPSES(6), QUAD8_COUNT_SYNAPSES(7)
 };
 
-static const struct counter_count_ext quad8_count_ext[] = {
-	{
-		.name = "ceiling",
-		.read = quad8_count_ceiling_read,
-		.write = quad8_count_ceiling_write
-	},
-	{
-		.name = "floor",
-		.read = quad8_count_floor_read
-	},
-	COUNTER_COUNT_ENUM("count_mode", &quad8_cnt_mode_enum),
-	COUNTER_COUNT_ENUM_AVAILABLE("count_mode", &quad8_cnt_mode_enum),
-	{
-		.name = "direction",
-		.read = quad8_count_direction_read
-	},
-	{
-		.name = "enable",
-		.read = quad8_count_enable_read,
-		.write = quad8_count_enable_write
-	},
-	COUNTER_COUNT_ENUM("error_noise", &quad8_error_noise_enum),
-	COUNTER_COUNT_ENUM_AVAILABLE("error_noise", &quad8_error_noise_enum),
-	{
-		.name = "preset",
-		.read = quad8_count_preset_read,
-		.write = quad8_count_preset_write
-	},
-	{
-		.name = "preset_enable",
-		.read = quad8_count_preset_enable_read,
-		.write = quad8_count_preset_enable_write
-	}
+static const enum counter_count_mode quad8_cnt_modes[] = {
+	COUNTER_COUNT_MODE_NORMAL,
+	COUNTER_COUNT_MODE_RANGE_LIMIT,
+	COUNTER_COUNT_MODE_NON_RECYCLE,
+	COUNTER_COUNT_MODE_MODULO_N,
+};
+
+static DEFINE_COUNTER_AVAILABLE(quad8_count_mode_available, quad8_cnt_modes);
+
+static DEFINE_COUNTER_ENUM(quad8_error_noise_enum, quad8_noise_error_states);
+
+static struct counter_comp quad8_count_ext[] = {
+	COUNTER_COMP_CEILING(quad8_count_ceiling_read,
+			     quad8_count_ceiling_write),
+	COUNTER_COMP_FLOOR(quad8_count_floor_read, NULL),
+	COUNTER_COMP_COUNT_MODE(quad8_count_mode_read, quad8_count_mode_write,
+				quad8_count_mode_available),
+	COUNTER_COMP_DIRECTION(quad8_direction_read),
+	COUNTER_COMP_ENABLE(quad8_count_enable_read, quad8_count_enable_write),
+	COUNTER_COMP_COUNT_ENUM("error_noise", quad8_error_noise_get, NULL,
+				quad8_error_noise_enum),
+	COUNTER_COMP_PRESET(quad8_count_preset_read, quad8_count_preset_write),
+	COUNTER_COMP_PRESET_ENABLE(quad8_count_preset_enable_read,
+				   quad8_count_preset_enable_write),
 };
 
 #define QUAD8_COUNT(_id, _cntname) {					\
diff --git a/drivers/counter/Makefile b/drivers/counter/Makefile
index 19742e6f5e3eb..1ab7e087fdc26 100644
--- a/drivers/counter/Makefile
+++ b/drivers/counter/Makefile
@@ -4,6 +4,7 @@
 #
 
 obj-$(CONFIG_COUNTER) += counter.o
+counter-y := counter-core.o counter-sysfs.o
 
 obj-$(CONFIG_104_QUAD_8)	+= 104-quad-8.o
 obj-$(CONFIG_INTERRUPT_CNT)		+= interrupt-cnt.o
diff --git a/drivers/counter/counter-core.c b/drivers/counter/counter-core.c
new file mode 100644
index 0000000000000..c533a6ff12cf7
--- /dev/null
+++ b/drivers/counter/counter-core.c
@@ -0,0 +1,142 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Generic Counter interface
+ * Copyright (C) 2020 William Breathitt Gray
+ */
+#include <linux/counter.h>
+#include <linux/device.h>
+#include <linux/export.h>
+#include <linux/gfp.h>
+#include <linux/idr.h>
+#include <linux/init.h>
+#include <linux/module.h>
+
+#include "counter-sysfs.h"
+
+/* Provides a unique ID for each counter device */
+static DEFINE_IDA(counter_ida);
+
+static void counter_device_release(struct device *dev)
+{
+	ida_free(&counter_ida, dev->id);
+}
+
+static struct device_type counter_device_type = {
+	.name = "counter_device",
+	.release = counter_device_release,
+};
+
+static struct bus_type counter_bus_type = {
+	.name = "counter",
+	.dev_name = "counter",
+};
+
+/**
+ * counter_register - register Counter to the system
+ * @counter:	pointer to Counter to register
+ *
+ * This function registers a Counter to the system. A sysfs "counter" directory
+ * will be created and populated with sysfs attributes correlating with the
+ * Counter Signals, Synapses, and Counts respectively.
+ */
+int counter_register(struct counter_device *const counter)
+{
+	struct device *const dev = &counter->dev;
+	int id;
+	int err;
+
+	/* Acquire unique ID */
+	id = ida_alloc(&counter_ida, GFP_KERNEL);
+	if (id < 0)
+		return id;
+
+	/* Configure device structure for Counter */
+	dev->id = id;
+	dev->type = &counter_device_type;
+	dev->bus = &counter_bus_type;
+	if (counter->parent) {
+		dev->parent = counter->parent;
+		dev->of_node = counter->parent->of_node;
+	}
+	device_initialize(dev);
+	dev_set_drvdata(dev, counter);
+
+	/* Add Counter sysfs attributes */
+	err = counter_sysfs_add(counter);
+	if (err < 0)
+		goto err_free_id;
+
+	/* Add device to system */
+	err = device_add(dev);
+	if (err < 0)
+		goto err_free_id;
+
+	return 0;
+
+err_free_id:
+	put_device(dev);
+	return err;
+}
+EXPORT_SYMBOL_GPL(counter_register);
+
+/**
+ * counter_unregister - unregister Counter from the system
+ * @counter:	pointer to Counter to unregister
+ *
+ * The Counter is unregistered from the system.
+ */
+void counter_unregister(struct counter_device *const counter)
+{
+	if (!counter)
+		return;
+
+	device_unregister(&counter->dev);
+}
+EXPORT_SYMBOL_GPL(counter_unregister);
+
+static void devm_counter_release(void *counter)
+{
+	counter_unregister(counter);
+}
+
+/**
+ * devm_counter_register - Resource-managed counter_register
+ * @dev:	device to allocate counter_device for
+ * @counter:	pointer to Counter to register
+ *
+ * Managed counter_register. The Counter registered with this function is
+ * automatically unregistered on driver detach. This function calls
+ * counter_register internally. Refer to that function for more information.
+ *
+ * RETURNS:
+ * 0 on success, negative error number on failure.
+ */
+int devm_counter_register(struct device *dev,
+			  struct counter_device *const counter)
+{
+	int err;
+
+	err = counter_register(counter);
+	if (err < 0)
+		return err;
+
+	return devm_add_action_or_reset(dev, devm_counter_release, counter);
+}
+EXPORT_SYMBOL_GPL(devm_counter_register);
+
+static int __init counter_init(void)
+{
+	return bus_register(&counter_bus_type);
+}
+
+static void __exit counter_exit(void)
+{
+	bus_unregister(&counter_bus_type);
+}
+
+subsys_initcall(counter_init);
+module_exit(counter_exit);
+
+MODULE_AUTHOR("William Breathitt Gray <vilhelm.gray@gmail.com>");
+MODULE_DESCRIPTION("Generic Counter interface");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/counter/counter-sysfs.c b/drivers/counter/counter-sysfs.c
new file mode 100644
index 0000000000000..108cbd838eb92
--- /dev/null
+++ b/drivers/counter/counter-sysfs.c
@@ -0,0 +1,849 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Generic Counter sysfs interface
+ * Copyright (C) 2020 William Breathitt Gray
+ */
+#include <linux/counter.h>
+#include <linux/device.h>
+#include <linux/err.h>
+#include <linux/gfp.h>
+#include <linux/kernel.h>
+#include <linux/kstrtox.h>
+#include <linux/list.h>
+#include <linux/string.h>
+#include <linux/sysfs.h>
+#include <linux/types.h>
+
+#include "counter-sysfs.h"
+
+/**
+ * struct counter_attribute - Counter sysfs attribute
+ * @dev_attr:	device attribute for sysfs
+ * @l:		node to add Counter attribute to attribute group list
+ * @comp:	Counter component callbacks and data
+ * @scope:	Counter scope of the attribute
+ * @parent:	pointer to the parent component
+ */
+struct counter_attribute {
+	struct device_attribute dev_attr;
+	struct list_head l;
+
+	struct counter_comp comp;
+	enum counter_scope scope;
+	void *parent;
+};
+
+#define to_counter_attribute(_dev_attr) \
+	container_of(_dev_attr, struct counter_attribute, dev_attr)
+
+/**
+ * struct counter_attribute_group - container for attribute group
+ * @name:	name of the attribute group
+ * @attr_list:	list to keep track of created attributes
+ * @num_attr:	number of attributes
+ */
+struct counter_attribute_group {
+	const char *name;
+	struct list_head attr_list;
+	size_t num_attr;
+};
+
+static const char *const counter_function_str[] = {
+	[COUNTER_FUNCTION_INCREASE] = "increase",
+	[COUNTER_FUNCTION_DECREASE] = "decrease",
+	[COUNTER_FUNCTION_PULSE_DIRECTION] = "pulse-direction",
+	[COUNTER_FUNCTION_QUADRATURE_X1_A] = "quadrature x1 a",
+	[COUNTER_FUNCTION_QUADRATURE_X1_B] = "quadrature x1 b",
+	[COUNTER_FUNCTION_QUADRATURE_X2_A] = "quadrature x2 a",
+	[COUNTER_FUNCTION_QUADRATURE_X2_B] = "quadrature x2 b",
+	[COUNTER_FUNCTION_QUADRATURE_X4] = "quadrature x4"
+};
+
+static const char *const counter_signal_value_str[] = {
+	[COUNTER_SIGNAL_LEVEL_LOW] = "low",
+	[COUNTER_SIGNAL_LEVEL_HIGH] = "high"
+};
+
+static const char *const counter_synapse_action_str[] = {
+	[COUNTER_SYNAPSE_ACTION_NONE] = "none",
+	[COUNTER_SYNAPSE_ACTION_RISING_EDGE] = "rising edge",
+	[COUNTER_SYNAPSE_ACTION_FALLING_EDGE] = "falling edge",
+	[COUNTER_SYNAPSE_ACTION_BOTH_EDGES] = "both edges"
+};
+
+static const char *const counter_count_direction_str[] = {
+	[COUNTER_COUNT_DIRECTION_FORWARD] = "forward",
+	[COUNTER_COUNT_DIRECTION_BACKWARD] = "backward"
+};
+
+static const char *const counter_count_mode_str[] = {
+	[COUNTER_COUNT_MODE_NORMAL] = "normal",
+	[COUNTER_COUNT_MODE_RANGE_LIMIT] = "range limit",
+	[COUNTER_COUNT_MODE_NON_RECYCLE] = "non-recycle",
+	[COUNTER_COUNT_MODE_MODULO_N] = "modulo-n"
+};
+
+static ssize_t counter_comp_u8_show(struct device *dev,
+				    struct device_attribute *attr, char *buf)
+{
+	const struct counter_attribute *const a = to_counter_attribute(attr);
+	struct counter_device *const counter = dev_get_drvdata(dev);
+	int err;
+	u8 data = 0;
+
+	switch (a->scope) {
+	case COUNTER_SCOPE_DEVICE:
+		err = a->comp.device_u8_read(counter, &data);
+		break;
+	case COUNTER_SCOPE_SIGNAL:
+		err = a->comp.signal_u8_read(counter, a->parent, &data);
+		break;
+	case COUNTER_SCOPE_COUNT:
+		err = a->comp.count_u8_read(counter, a->parent, &data);
+		break;
+	default:
+		return -EINVAL;
+	}
+	if (err < 0)
+		return err;
+
+	if (a->comp.type == COUNTER_COMP_BOOL)
+		/* data should already be boolean but ensure just to be safe */
+		data = !!data;
+
+	return sprintf(buf, "%u\n", (unsigned int)data);
+}
+
+static ssize_t counter_comp_u8_store(struct device *dev,
+				     struct device_attribute *attr,
+				     const char *buf, size_t len)
+{
+	const struct counter_attribute *const a = to_counter_attribute(attr);
+	struct counter_device *const counter = dev_get_drvdata(dev);
+	int err;
+	bool bool_data = 0;
+	u8 data = 0;
+
+	if (a->comp.type == COUNTER_COMP_BOOL) {
+		err = kstrtobool(buf, &bool_data);
+		data = bool_data;
+	} else
+		err = kstrtou8(buf, 0, &data);
+	if (err < 0)
+		return err;
+
+	switch (a->scope) {
+	case COUNTER_SCOPE_DEVICE:
+		err = a->comp.device_u8_write(counter, data);
+		break;
+	case COUNTER_SCOPE_SIGNAL:
+		err = a->comp.signal_u8_write(counter, a->parent, data);
+		break;
+	case COUNTER_SCOPE_COUNT:
+		err = a->comp.count_u8_write(counter, a->parent, data);
+		break;
+	default:
+		return -EINVAL;
+	}
+	if (err < 0)
+		return err;
+
+	return len;
+}
+
+static ssize_t counter_comp_u32_show(struct device *dev,
+				     struct device_attribute *attr, char *buf)
+{
+	const struct counter_attribute *const a = to_counter_attribute(attr);
+	struct counter_device *const counter = dev_get_drvdata(dev);
+	const struct counter_available *const avail = a->comp.priv;
+	int err;
+	u32 data = 0;
+
+	switch (a->scope) {
+	case COUNTER_SCOPE_DEVICE:
+		err = a->comp.device_u32_read(counter, &data);
+		break;
+	case COUNTER_SCOPE_SIGNAL:
+		err = a->comp.signal_u32_read(counter, a->parent, &data);
+		break;
+	case COUNTER_SCOPE_COUNT:
+		if (a->comp.type == COUNTER_COMP_SYNAPSE_ACTION)
+			err = a->comp.action_read(counter, a->parent,
+						  a->comp.priv, &data);
+		else
+			err = a->comp.count_u32_read(counter, a->parent, &data);
+		break;
+	default:
+		return -EINVAL;
+	}
+	if (err < 0)
+		return err;
+
+	switch (a->comp.type) {
+	case COUNTER_COMP_FUNCTION:
+		return sysfs_emit(buf, "%s\n", counter_function_str[data]);
+	case COUNTER_COMP_SIGNAL_LEVEL:
+		return sysfs_emit(buf, "%s\n", counter_signal_value_str[data]);
+	case COUNTER_COMP_SYNAPSE_ACTION:
+		return sysfs_emit(buf, "%s\n", counter_synapse_action_str[data]);
+	case COUNTER_COMP_ENUM:
+		return sysfs_emit(buf, "%s\n", avail->strs[data]);
+	case COUNTER_COMP_COUNT_DIRECTION:
+		return sysfs_emit(buf, "%s\n", counter_count_direction_str[data]);
+	case COUNTER_COMP_COUNT_MODE:
+		return sysfs_emit(buf, "%s\n", counter_count_mode_str[data]);
+	default:
+		return sprintf(buf, "%u\n", (unsigned int)data);
+	}
+}
+
+static int counter_find_enum(u32 *const enum_item, const u32 *const enums,
+			     const size_t num_enums, const char *const buf,
+			     const char *const string_array[])
+{
+	size_t index;
+
+	for (index = 0; index < num_enums; index++) {
+		*enum_item = enums[index];
+		if (sysfs_streq(buf, string_array[*enum_item]))
+			return 0;
+	}
+
+	return -EINVAL;
+}
+
+static ssize_t counter_comp_u32_store(struct device *dev,
+				      struct device_attribute *attr,
+				      const char *buf, size_t len)
+{
+	const struct counter_attribute *const a = to_counter_attribute(attr);
+	struct counter_device *const counter = dev_get_drvdata(dev);
+	struct counter_count *const count = a->parent;
+	struct counter_synapse *const synapse = a->comp.priv;
+	const struct counter_available *const avail = a->comp.priv;
+	int err;
+	u32 data = 0;
+
+	switch (a->comp.type) {
+	case COUNTER_COMP_FUNCTION:
+		err = counter_find_enum(&data, count->functions_list,
+					count->num_functions, buf,
+					counter_function_str);
+		break;
+	case COUNTER_COMP_SYNAPSE_ACTION:
+		err = counter_find_enum(&data, synapse->actions_list,
+					synapse->num_actions, buf,
+					counter_synapse_action_str);
+		break;
+	case COUNTER_COMP_ENUM:
+		err = __sysfs_match_string(avail->strs, avail->num_items, buf);
+		data = err;
+		break;
+	case COUNTER_COMP_COUNT_MODE:
+		err = counter_find_enum(&data, avail->enums, avail->num_items,
+					buf, counter_count_mode_str);
+		break;
+	default:
+		err = kstrtou32(buf, 0, &data);
+		break;
+	}
+	if (err < 0)
+		return err;
+
+	switch (a->scope) {
+	case COUNTER_SCOPE_DEVICE:
+		err = a->comp.device_u32_write(counter, data);
+		break;
+	case COUNTER_SCOPE_SIGNAL:
+		err = a->comp.signal_u32_write(counter, a->parent, data);
+		break;
+	case COUNTER_SCOPE_COUNT:
+		if (a->comp.type == COUNTER_COMP_SYNAPSE_ACTION)
+			err = a->comp.action_write(counter, count, synapse,
+						   data);
+		else
+			err = a->comp.count_u32_write(counter, count, data);
+		break;
+	default:
+		return -EINVAL;
+	}
+	if (err < 0)
+		return err;
+
+	return len;
+}
+
+static ssize_t counter_comp_u64_show(struct device *dev,
+				     struct device_attribute *attr, char *buf)
+{
+	const struct counter_attribute *const a = to_counter_attribute(attr);
+	struct counter_device *const counter = dev_get_drvdata(dev);
+	int err;
+	u64 data = 0;
+
+	switch (a->scope) {
+	case COUNTER_SCOPE_DEVICE:
+		err = a->comp.device_u64_read(counter, &data);
+		break;
+	case COUNTER_SCOPE_SIGNAL:
+		err = a->comp.signal_u64_read(counter, a->parent, &data);
+		break;
+	case COUNTER_SCOPE_COUNT:
+		err = a->comp.count_u64_read(counter, a->parent, &data);
+		break;
+	default:
+		return -EINVAL;
+	}
+	if (err < 0)
+		return err;
+
+	return sprintf(buf, "%llu\n", (unsigned long long)data);
+}
+
+static ssize_t counter_comp_u64_store(struct device *dev,
+				      struct device_attribute *attr,
+				      const char *buf, size_t len)
+{
+	const struct counter_attribute *const a = to_counter_attribute(attr);
+	struct counter_device *const counter = dev_get_drvdata(dev);
+	int err;
+	u64 data = 0;
+
+	err = kstrtou64(buf, 0, &data);
+	if (err < 0)
+		return err;
+
+	switch (a->scope) {
+	case COUNTER_SCOPE_DEVICE:
+		err = a->comp.device_u64_write(counter, data);
+		break;
+	case COUNTER_SCOPE_SIGNAL:
+		err = a->comp.signal_u64_write(counter, a->parent, data);
+		break;
+	case COUNTER_SCOPE_COUNT:
+		err = a->comp.count_u64_write(counter, a->parent, data);
+		break;
+	default:
+		return -EINVAL;
+	}
+	if (err < 0)
+		return err;
+
+	return len;
+}
+
+static ssize_t enums_available_show(const u32 *const enums,
+				    const size_t num_enums,
+				    const char *const strs[], char *buf)
+{
+	size_t len = 0;
+	size_t index;
+
+	for (index = 0; index < num_enums; index++)
+		len += sysfs_emit_at(buf, len, "%s\n", strs[enums[index]]);
+
+	return len;
+}
+
+static ssize_t strs_available_show(const struct counter_available *const avail,
+				   char *buf)
+{
+	size_t len = 0;
+	size_t index;
+
+	for (index = 0; index < avail->num_items; index++)
+		len += sysfs_emit_at(buf, len, "%s\n", avail->strs[index]);
+
+	return len;
+}
+
+static ssize_t counter_comp_available_show(struct device *dev,
+					   struct device_attribute *attr,
+					   char *buf)
+{
+	const struct counter_attribute *const a = to_counter_attribute(attr);
+	const struct counter_count *const count = a->parent;
+	const struct counter_synapse *const synapse = a->comp.priv;
+	const struct counter_available *const avail = a->comp.priv;
+
+	switch (a->comp.type) {
+	case COUNTER_COMP_FUNCTION:
+		return enums_available_show(count->functions_list,
+					    count->num_functions,
+					    counter_function_str, buf);
+	case COUNTER_COMP_SYNAPSE_ACTION:
+		return enums_available_show(synapse->actions_list,
+					    synapse->num_actions,
+					    counter_synapse_action_str, buf);
+	case COUNTER_COMP_ENUM:
+		return strs_available_show(avail, buf);
+	case COUNTER_COMP_COUNT_MODE:
+		return enums_available_show(avail->enums, avail->num_items,
+					    counter_count_mode_str, buf);
+	default:
+		return -EINVAL;
+	}
+}
+
+static int counter_avail_attr_create(struct device *const dev,
+	struct counter_attribute_group *const group,
+	const struct counter_comp *const comp, void *const parent)
+{
+	struct counter_attribute *counter_attr;
+	struct device_attribute *dev_attr;
+
+	counter_attr = devm_kzalloc(dev, sizeof(*counter_attr), GFP_KERNEL);
+	if (!counter_attr)
+		return -ENOMEM;
+
+	/* Configure Counter attribute */
+	counter_attr->comp.type = comp->type;
+	counter_attr->comp.priv = comp->priv;
+	counter_attr->parent = parent;
+
+	/* Initialize sysfs attribute */
+	dev_attr = &counter_attr->dev_attr;
+	sysfs_attr_init(&dev_attr->attr);
+
+	/* Configure device attribute */
+	dev_attr->attr.name = devm_kasprintf(dev, GFP_KERNEL, "%s_available",
+					     comp->name);
+	if (!dev_attr->attr.name)
+		return -ENOMEM;
+	dev_attr->attr.mode = 0444;
+	dev_attr->show = counter_comp_available_show;
+
+	/* Store list node */
+	list_add(&counter_attr->l, &group->attr_list);
+	group->num_attr++;
+
+	return 0;
+}
+
+static int counter_attr_create(struct device *const dev,
+			       struct counter_attribute_group *const group,
+			       const struct counter_comp *const comp,
+			       const enum counter_scope scope,
+			       void *const parent)
+{
+	struct counter_attribute *counter_attr;
+	struct device_attribute *dev_attr;
+
+	counter_attr = devm_kzalloc(dev, sizeof(*counter_attr), GFP_KERNEL);
+	if (!counter_attr)
+		return -ENOMEM;
+
+	/* Configure Counter attribute */
+	counter_attr->comp = *comp;
+	counter_attr->scope = scope;
+	counter_attr->parent = parent;
+
+	/* Configure device attribute */
+	dev_attr = &counter_attr->dev_attr;
+	sysfs_attr_init(&dev_attr->attr);
+	dev_attr->attr.name = comp->name;
+	switch (comp->type) {
+	case COUNTER_COMP_U8:
+	case COUNTER_COMP_BOOL:
+		if (comp->device_u8_read) {
+			dev_attr->attr.mode |= 0444;
+			dev_attr->show = counter_comp_u8_show;
+		}
+		if (comp->device_u8_write) {
+			dev_attr->attr.mode |= 0200;
+			dev_attr->store = counter_comp_u8_store;
+		}
+		break;
+	case COUNTER_COMP_SIGNAL_LEVEL:
+	case COUNTER_COMP_FUNCTION:
+	case COUNTER_COMP_SYNAPSE_ACTION:
+	case COUNTER_COMP_ENUM:
+	case COUNTER_COMP_COUNT_DIRECTION:
+	case COUNTER_COMP_COUNT_MODE:
+		if (comp->device_u32_read) {
+			dev_attr->attr.mode |= 0444;
+			dev_attr->show = counter_comp_u32_show;
+		}
+		if (comp->device_u32_write) {
+			dev_attr->attr.mode |= 0200;
+			dev_attr->store = counter_comp_u32_store;
+		}
+		break;
+	case COUNTER_COMP_U64:
+		if (comp->device_u64_read) {
+			dev_attr->attr.mode |= 0444;
+			dev_attr->show = counter_comp_u64_show;
+		}
+		if (comp->device_u64_write) {
+			dev_attr->attr.mode |= 0200;
+			dev_attr->store = counter_comp_u64_store;
+		}
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	/* Store list node */
+	list_add(&counter_attr->l, &group->attr_list);
+	group->num_attr++;
+
+	/* Create "*_available" attribute if needed */
+	switch (comp->type) {
+	case COUNTER_COMP_FUNCTION:
+	case COUNTER_COMP_SYNAPSE_ACTION:
+	case COUNTER_COMP_ENUM:
+	case COUNTER_COMP_COUNT_MODE:
+		return counter_avail_attr_create(dev, group, comp, parent);
+	default:
+		return 0;
+	}
+}
+
+static ssize_t counter_comp_name_show(struct device *dev,
+				      struct device_attribute *attr, char *buf)
+{
+	return sysfs_emit(buf, "%s\n", to_counter_attribute(attr)->comp.name);
+}
+
+static int counter_name_attr_create(struct device *const dev,
+				    struct counter_attribute_group *const group,
+				    const char *const name)
+{
+	struct counter_attribute *counter_attr;
+
+	counter_attr = devm_kzalloc(dev, sizeof(*counter_attr), GFP_KERNEL);
+	if (!counter_attr)
+		return -ENOMEM;
+
+	/* Configure Counter attribute */
+	counter_attr->comp.name = name;
+
+	/* Configure device attribute */
+	sysfs_attr_init(&counter_attr->dev_attr.attr);
+	counter_attr->dev_attr.attr.name = "name";
+	counter_attr->dev_attr.attr.mode = 0444;
+	counter_attr->dev_attr.show = counter_comp_name_show;
+
+	/* Store list node */
+	list_add(&counter_attr->l, &group->attr_list);
+	group->num_attr++;
+
+	return 0;
+}
+
+static struct counter_comp counter_signal_comp = {
+	.type = COUNTER_COMP_SIGNAL_LEVEL,
+	.name = "signal",
+};
+
+static int counter_signal_attrs_create(struct counter_device *const counter,
+	struct counter_attribute_group *const cattr_group,
+	struct counter_signal *const signal)
+{
+	const enum counter_scope scope = COUNTER_SCOPE_SIGNAL;
+	struct device *const dev = &counter->dev;
+	int err;
+	struct counter_comp comp;
+	size_t i;
+
+	/* Create main Signal attribute */
+	comp = counter_signal_comp;
+	comp.signal_u32_read = counter->ops->signal_read;
+	err = counter_attr_create(dev, cattr_group, &comp, scope, signal);
+	if (err < 0)
+		return err;
+
+	/* Create Signal name attribute */
+	err = counter_name_attr_create(dev, cattr_group, signal->name);
+	if (err < 0)
+		return err;
+
+	/* Create an attribute for each extension */
+	for (i = 0; i < signal->num_ext; i++) {
+		err = counter_attr_create(dev, cattr_group, signal->ext + i,
+					  scope, signal);
+		if (err < 0)
+			return err;
+	}
+
+	return 0;
+}
+
+static int counter_sysfs_signals_add(struct counter_device *const counter,
+	struct counter_attribute_group *const groups)
+{
+	size_t i;
+	int err;
+
+	/* Add each Signal */
+	for (i = 0; i < counter->num_signals; i++) {
+		/* Generate Signal attribute directory name */
+		groups[i].name = devm_kasprintf(&counter->dev, GFP_KERNEL,
+						"signal%zu", i);
+		if (!groups[i].name)
+			return -ENOMEM;
+
+		/* Create all attributes associated with Signal */
+		err = counter_signal_attrs_create(counter, groups + i,
+						  counter->signals + i);
+		if (err < 0)
+			return err;
+	}
+
+	return 0;
+}
+
+static int counter_sysfs_synapses_add(struct counter_device *const counter,
+	struct counter_attribute_group *const group,
+	struct counter_count *const count)
+{
+	size_t i;
+
+	/* Add each Synapse */
+	for (i = 0; i < count->num_synapses; i++) {
+		struct device *const dev = &counter->dev;
+		struct counter_synapse *synapse;
+		size_t id;
+		struct counter_comp comp;
+		int err;
+
+		synapse = count->synapses + i;
+
+		/* Generate Synapse action name */
+		id = synapse->signal - counter->signals;
+		comp.name = devm_kasprintf(dev, GFP_KERNEL, "signal%zu_action",
+					   id);
+		if (!comp.name)
+			return -ENOMEM;
+
+		/* Create action attribute */
+		comp.type = COUNTER_COMP_SYNAPSE_ACTION;
+		comp.action_read = counter->ops->action_read;
+		comp.action_write = counter->ops->action_write;
+		comp.priv = synapse;
+		err = counter_attr_create(dev, group, &comp,
+					  COUNTER_SCOPE_COUNT, count);
+		if (err < 0)
+			return err;
+	}
+
+	return 0;
+}
+
+static struct counter_comp counter_count_comp =
+	COUNTER_COMP_COUNT_U64("count", NULL, NULL);
+
+static struct counter_comp counter_function_comp = {
+	.type = COUNTER_COMP_FUNCTION,
+	.name = "function",
+};
+
+static int counter_count_attrs_create(struct counter_device *const counter,
+	struct counter_attribute_group *const cattr_group,
+	struct counter_count *const count)
+{
+	const enum counter_scope scope = COUNTER_SCOPE_COUNT;
+	struct device *const dev = &counter->dev;
+	int err;
+	struct counter_comp comp;
+	size_t i;
+
+	/* Create main Count attribute */
+	comp = counter_count_comp;
+	comp.count_u64_read = counter->ops->count_read;
+	comp.count_u64_write = counter->ops->count_write;
+	err = counter_attr_create(dev, cattr_group, &comp, scope, count);
+	if (err < 0)
+		return err;
+
+	/* Create Count name attribute */
+	err = counter_name_attr_create(dev, cattr_group, count->name);
+	if (err < 0)
+		return err;
+
+	/* Create Count function attribute */
+	comp = counter_function_comp;
+	comp.count_u32_read = counter->ops->function_read;
+	comp.count_u32_write = counter->ops->function_write;
+	err = counter_attr_create(dev, cattr_group, &comp, scope, count);
+	if (err < 0)
+		return err;
+
+	/* Create an attribute for each extension */
+	for (i = 0; i < count->num_ext; i++) {
+		err = counter_attr_create(dev, cattr_group, count->ext + i,
+					  scope, count);
+		if (err < 0)
+			return err;
+	}
+
+	return 0;
+}
+
+static int counter_sysfs_counts_add(struct counter_device *const counter,
+	struct counter_attribute_group *const groups)
+{
+	size_t i;
+	struct counter_count *count;
+	int err;
+
+	/* Add each Count */
+	for (i = 0; i < counter->num_counts; i++) {
+		count = counter->counts + i;
+
+		/* Generate Count attribute directory name */
+		groups[i].name = devm_kasprintf(&counter->dev, GFP_KERNEL,
+						"count%zu", i);
+		if (!groups[i].name)
+			return -ENOMEM;
+
+		/* Add sysfs attributes of the Synapses */
+		err = counter_sysfs_synapses_add(counter, groups + i, count);
+		if (err < 0)
+			return err;
+
+		/* Create all attributes associated with Count */
+		err = counter_count_attrs_create(counter, groups + i, count);
+		if (err < 0)
+			return err;
+	}
+
+	return 0;
+}
+
+static int counter_num_signals_read(struct counter_device *counter, u8 *val)
+{
+	*val = counter->num_signals;
+	return 0;
+}
+
+static int counter_num_counts_read(struct counter_device *counter, u8 *val)
+{
+	*val = counter->num_counts;
+	return 0;
+}
+
+static struct counter_comp counter_num_signals_comp =
+	COUNTER_COMP_DEVICE_U8("num_signals", counter_num_signals_read, NULL);
+
+static struct counter_comp counter_num_counts_comp =
+	COUNTER_COMP_DEVICE_U8("num_counts", counter_num_counts_read, NULL);
+
+static int counter_sysfs_attr_add(struct counter_device *const counter,
+				  struct counter_attribute_group *cattr_group)
+{
+	const enum counter_scope scope = COUNTER_SCOPE_DEVICE;
+	struct device *const dev = &counter->dev;
+	int err;
+	size_t i;
+
+	/* Add Signals sysfs attributes */
+	err = counter_sysfs_signals_add(counter, cattr_group);
+	if (err < 0)
+		return err;
+	cattr_group += counter->num_signals;
+
+	/* Add Counts sysfs attributes */
+	err = counter_sysfs_counts_add(counter, cattr_group);
+	if (err < 0)
+		return err;
+	cattr_group += counter->num_counts;
+
+	/* Create name attribute */
+	err = counter_name_attr_create(dev, cattr_group, counter->name);
+	if (err < 0)
+		return err;
+
+	/* Create num_signals attribute */
+	err = counter_attr_create(dev, cattr_group, &counter_num_signals_comp,
+				  scope, NULL);
+	if (err < 0)
+		return err;
+
+	/* Create num_counts attribute */
+	err = counter_attr_create(dev, cattr_group, &counter_num_counts_comp,
+				  scope, NULL);
+	if (err < 0)
+		return err;
+
+	/* Create an attribute for each extension */
+	for (i = 0; i < counter->num_ext; i++) {
+		err = counter_attr_create(dev, cattr_group, counter->ext + i,
+					  scope, NULL);
+		if (err < 0)
+			return err;
+	}
+
+	return 0;
+}
+
+/**
+ * counter_sysfs_add - Adds Counter sysfs attributes to the device structure
+ * @counter:	Pointer to the Counter device structure
+ *
+ * Counter sysfs attributes are created and added to the respective device
+ * structure for later registration to the system. Resource-managed memory
+ * allocation is performed by this function, and this memory should be freed
+ * when no longer needed (automatically by a device_unregister call, or
+ * manually by a devres_release_all call).
+ */
+int counter_sysfs_add(struct counter_device *const counter)
+{
+	struct device *const dev = &counter->dev;
+	const size_t num_groups = counter->num_signals + counter->num_counts + 1;
+	struct counter_attribute_group *cattr_groups;
+	size_t i, j;
+	int err;
+	struct attribute_group *groups;
+	struct counter_attribute *p;
+
+	/* Allocate space for attribute groups (signals, counts, and ext) */
+	cattr_groups = devm_kcalloc(dev, num_groups, sizeof(*cattr_groups),
+				    GFP_KERNEL);
+	if (!cattr_groups)
+		return -ENOMEM;
+
+	/* Initialize attribute lists */
+	for (i = 0; i < num_groups; i++)
+		INIT_LIST_HEAD(&cattr_groups[i].attr_list);
+
+	/* Add Counter device sysfs attributes */
+	err = counter_sysfs_attr_add(counter, cattr_groups);
+	if (err < 0)
+		return err;
+
+	/* Allocate attribute group pointers for association with device */
+	dev->groups = devm_kcalloc(dev, num_groups + 1, sizeof(*dev->groups),
+				   GFP_KERNEL);
+	if (!dev->groups)
+		return -ENOMEM;
+
+	/* Allocate space for attribute groups */
+	groups = devm_kcalloc(dev, num_groups, sizeof(*groups), GFP_KERNEL);
+	if (!groups)
+		return -ENOMEM;
+
+	/* Prepare each group of attributes for association */
+	for (i = 0; i < num_groups; i++) {
+		groups[i].name = cattr_groups[i].name;
+
+		/* Allocate space for attribute pointers */
+		groups[i].attrs = devm_kcalloc(dev,
+					       cattr_groups[i].num_attr + 1,
+					       sizeof(*groups[i].attrs),
+					       GFP_KERNEL);
+		if (!groups[i].attrs)
+			return -ENOMEM;
+
+		/* Add attribute pointers to attribute group */
+		j = 0;
+		list_for_each_entry(p, &cattr_groups[i].attr_list, l)
+			groups[i].attrs[j++] = &p->dev_attr.attr;
+
+		/* Associate attribute group */
+		dev->groups[i] = &groups[i];
+	}
+
+	return 0;
+}
diff --git a/drivers/counter/counter-sysfs.h b/drivers/counter/counter-sysfs.h
new file mode 100644
index 0000000000000..14fe566aca0e0
--- /dev/null
+++ b/drivers/counter/counter-sysfs.h
@@ -0,0 +1,13 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Counter sysfs interface
+ * Copyright (C) 2020 William Breathitt Gray
+ */
+#ifndef _COUNTER_SYSFS_H_
+#define _COUNTER_SYSFS_H_
+
+#include <linux/counter.h>
+
+int counter_sysfs_add(struct counter_device *const counter);
+
+#endif /* _COUNTER_SYSFS_H_ */
diff --git a/drivers/counter/counter.c b/drivers/counter/counter.c
deleted file mode 100644
index de921e8a3f721..0000000000000
--- a/drivers/counter/counter.c
+++ /dev/null
@@ -1,1496 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/*
- * Generic Counter interface
- * Copyright (C) 2018 William Breathitt Gray
- */
-#include <linux/counter.h>
-#include <linux/device.h>
-#include <linux/err.h>
-#include <linux/export.h>
-#include <linux/fs.h>
-#include <linux/gfp.h>
-#include <linux/idr.h>
-#include <linux/init.h>
-#include <linux/kernel.h>
-#include <linux/list.h>
-#include <linux/module.h>
-#include <linux/printk.h>
-#include <linux/slab.h>
-#include <linux/string.h>
-#include <linux/sysfs.h>
-#include <linux/types.h>
-
-const char *const counter_count_direction_str[2] = {
-	[COUNTER_COUNT_DIRECTION_FORWARD] = "forward",
-	[COUNTER_COUNT_DIRECTION_BACKWARD] = "backward"
-};
-EXPORT_SYMBOL_GPL(counter_count_direction_str);
-
-const char *const counter_count_mode_str[4] = {
-	[COUNTER_COUNT_MODE_NORMAL] = "normal",
-	[COUNTER_COUNT_MODE_RANGE_LIMIT] = "range limit",
-	[COUNTER_COUNT_MODE_NON_RECYCLE] = "non-recycle",
-	[COUNTER_COUNT_MODE_MODULO_N] = "modulo-n"
-};
-EXPORT_SYMBOL_GPL(counter_count_mode_str);
-
-ssize_t counter_signal_enum_read(struct counter_device *counter,
-				 struct counter_signal *signal, void *priv,
-				 char *buf)
-{
-	const struct counter_signal_enum_ext *const e = priv;
-	int err;
-	size_t index;
-
-	if (!e->get)
-		return -EINVAL;
-
-	err = e->get(counter, signal, &index);
-	if (err)
-		return err;
-
-	if (index >= e->num_items)
-		return -EINVAL;
-
-	return sprintf(buf, "%s\n", e->items[index]);
-}
-EXPORT_SYMBOL_GPL(counter_signal_enum_read);
-
-ssize_t counter_signal_enum_write(struct counter_device *counter,
-				  struct counter_signal *signal, void *priv,
-				  const char *buf, size_t len)
-{
-	const struct counter_signal_enum_ext *const e = priv;
-	ssize_t index;
-	int err;
-
-	if (!e->set)
-		return -EINVAL;
-
-	index = __sysfs_match_string(e->items, e->num_items, buf);
-	if (index < 0)
-		return index;
-
-	err = e->set(counter, signal, index);
-	if (err)
-		return err;
-
-	return len;
-}
-EXPORT_SYMBOL_GPL(counter_signal_enum_write);
-
-ssize_t counter_signal_enum_available_read(struct counter_device *counter,
-					   struct counter_signal *signal,
-					   void *priv, char *buf)
-{
-	const struct counter_signal_enum_ext *const e = priv;
-	size_t i;
-	size_t len = 0;
-
-	if (!e->num_items)
-		return 0;
-
-	for (i = 0; i < e->num_items; i++)
-		len += sprintf(buf + len, "%s\n", e->items[i]);
-
-	return len;
-}
-EXPORT_SYMBOL_GPL(counter_signal_enum_available_read);
-
-ssize_t counter_count_enum_read(struct counter_device *counter,
-				struct counter_count *count, void *priv,
-				char *buf)
-{
-	const struct counter_count_enum_ext *const e = priv;
-	int err;
-	size_t index;
-
-	if (!e->get)
-		return -EINVAL;
-
-	err = e->get(counter, count, &index);
-	if (err)
-		return err;
-
-	if (index >= e->num_items)
-		return -EINVAL;
-
-	return sprintf(buf, "%s\n", e->items[index]);
-}
-EXPORT_SYMBOL_GPL(counter_count_enum_read);
-
-ssize_t counter_count_enum_write(struct counter_device *counter,
-				 struct counter_count *count, void *priv,
-				 const char *buf, size_t len)
-{
-	const struct counter_count_enum_ext *const e = priv;
-	ssize_t index;
-	int err;
-
-	if (!e->set)
-		return -EINVAL;
-
-	index = __sysfs_match_string(e->items, e->num_items, buf);
-	if (index < 0)
-		return index;
-
-	err = e->set(counter, count, index);
-	if (err)
-		return err;
-
-	return len;
-}
-EXPORT_SYMBOL_GPL(counter_count_enum_write);
-
-ssize_t counter_count_enum_available_read(struct counter_device *counter,
-					  struct counter_count *count,
-					  void *priv, char *buf)
-{
-	const struct counter_count_enum_ext *const e = priv;
-	size_t i;
-	size_t len = 0;
-
-	if (!e->num_items)
-		return 0;
-
-	for (i = 0; i < e->num_items; i++)
-		len += sprintf(buf + len, "%s\n", e->items[i]);
-
-	return len;
-}
-EXPORT_SYMBOL_GPL(counter_count_enum_available_read);
-
-ssize_t counter_device_enum_read(struct counter_device *counter, void *priv,
-				 char *buf)
-{
-	const struct counter_device_enum_ext *const e = priv;
-	int err;
-	size_t index;
-
-	if (!e->get)
-		return -EINVAL;
-
-	err = e->get(counter, &index);
-	if (err)
-		return err;
-
-	if (index >= e->num_items)
-		return -EINVAL;
-
-	return sprintf(buf, "%s\n", e->items[index]);
-}
-EXPORT_SYMBOL_GPL(counter_device_enum_read);
-
-ssize_t counter_device_enum_write(struct counter_device *counter, void *priv,
-				  const char *buf, size_t len)
-{
-	const struct counter_device_enum_ext *const e = priv;
-	ssize_t index;
-	int err;
-
-	if (!e->set)
-		return -EINVAL;
-
-	index = __sysfs_match_string(e->items, e->num_items, buf);
-	if (index < 0)
-		return index;
-
-	err = e->set(counter, index);
-	if (err)
-		return err;
-
-	return len;
-}
-EXPORT_SYMBOL_GPL(counter_device_enum_write);
-
-ssize_t counter_device_enum_available_read(struct counter_device *counter,
-					   void *priv, char *buf)
-{
-	const struct counter_device_enum_ext *const e = priv;
-	size_t i;
-	size_t len = 0;
-
-	if (!e->num_items)
-		return 0;
-
-	for (i = 0; i < e->num_items; i++)
-		len += sprintf(buf + len, "%s\n", e->items[i]);
-
-	return len;
-}
-EXPORT_SYMBOL_GPL(counter_device_enum_available_read);
-
-struct counter_attr_parm {
-	struct counter_device_attr_group *group;
-	const char *prefix;
-	const char *name;
-	ssize_t (*show)(struct device *dev, struct device_attribute *attr,
-			char *buf);
-	ssize_t (*store)(struct device *dev, struct device_attribute *attr,
-			 const char *buf, size_t len);
-	void *component;
-};
-
-struct counter_device_attr {
-	struct device_attribute dev_attr;
-	struct list_head l;
-	void *component;
-};
-
-static int counter_attribute_create(const struct counter_attr_parm *const parm)
-{
-	struct counter_device_attr *counter_attr;
-	struct device_attribute *dev_attr;
-	int err;
-	struct list_head *const attr_list = &parm->group->attr_list;
-
-	/* Allocate a Counter device attribute */
-	counter_attr = kzalloc(sizeof(*counter_attr), GFP_KERNEL);
-	if (!counter_attr)
-		return -ENOMEM;
-	dev_attr = &counter_attr->dev_attr;
-
-	sysfs_attr_init(&dev_attr->attr);
-
-	/* Configure device attribute */
-	dev_attr->attr.name = kasprintf(GFP_KERNEL, "%s%s", parm->prefix,
-					parm->name);
-	if (!dev_attr->attr.name) {
-		err = -ENOMEM;
-		goto err_free_counter_attr;
-	}
-	if (parm->show) {
-		dev_attr->attr.mode |= 0444;
-		dev_attr->show = parm->show;
-	}
-	if (parm->store) {
-		dev_attr->attr.mode |= 0200;
-		dev_attr->store = parm->store;
-	}
-
-	/* Store associated Counter component with attribute */
-	counter_attr->component = parm->component;
-
-	/* Keep track of the attribute for later cleanup */
-	list_add(&counter_attr->l, attr_list);
-	parm->group->num_attr++;
-
-	return 0;
-
-err_free_counter_attr:
-	kfree(counter_attr);
-	return err;
-}
-
-#define to_counter_attr(_dev_attr) \
-	container_of(_dev_attr, struct counter_device_attr, dev_attr)
-
-struct counter_signal_unit {
-	struct counter_signal *signal;
-};
-
-static const char *const counter_signal_level_str[] = {
-	[COUNTER_SIGNAL_LEVEL_LOW] = "low",
-	[COUNTER_SIGNAL_LEVEL_HIGH] = "high"
-};
-
-static ssize_t counter_signal_show(struct device *dev,
-				   struct device_attribute *attr, char *buf)
-{
-	struct counter_device *const counter = dev_get_drvdata(dev);
-	const struct counter_device_attr *const devattr = to_counter_attr(attr);
-	const struct counter_signal_unit *const component = devattr->component;
-	struct counter_signal *const signal = component->signal;
-	int err;
-	enum counter_signal_level level;
-
-	err = counter->ops->signal_read(counter, signal, &level);
-	if (err)
-		return err;
-
-	return sprintf(buf, "%s\n", counter_signal_level_str[level]);
-}
-
-struct counter_name_unit {
-	const char *name;
-};
-
-static ssize_t counter_device_attr_name_show(struct device *dev,
-					     struct device_attribute *attr,
-					     char *buf)
-{
-	const struct counter_name_unit *const comp = to_counter_attr(attr)->component;
-
-	return sprintf(buf, "%s\n", comp->name);
-}
-
-static int counter_name_attribute_create(
-	struct counter_device_attr_group *const group,
-	const char *const name)
-{
-	struct counter_name_unit *name_comp;
-	struct counter_attr_parm parm;
-	int err;
-
-	/* Skip if no name */
-	if (!name)
-		return 0;
-
-	/* Allocate name attribute component */
-	name_comp = kmalloc(sizeof(*name_comp), GFP_KERNEL);
-	if (!name_comp)
-		return -ENOMEM;
-	name_comp->name = name;
-
-	/* Allocate Signal name attribute */
-	parm.group = group;
-	parm.prefix = "";
-	parm.name = "name";
-	parm.show = counter_device_attr_name_show;
-	parm.store = NULL;
-	parm.component = name_comp;
-	err = counter_attribute_create(&parm);
-	if (err)
-		goto err_free_name_comp;
-
-	return 0;
-
-err_free_name_comp:
-	kfree(name_comp);
-	return err;
-}
-
-struct counter_signal_ext_unit {
-	struct counter_signal *signal;
-	const struct counter_signal_ext *ext;
-};
-
-static ssize_t counter_signal_ext_show(struct device *dev,
-				       struct device_attribute *attr, char *buf)
-{
-	const struct counter_device_attr *const devattr = to_counter_attr(attr);
-	const struct counter_signal_ext_unit *const comp = devattr->component;
-	const struct counter_signal_ext *const ext = comp->ext;
-
-	return ext->read(dev_get_drvdata(dev), comp->signal, ext->priv, buf);
-}
-
-static ssize_t counter_signal_ext_store(struct device *dev,
-					struct device_attribute *attr,
-					const char *buf, size_t len)
-{
-	const struct counter_device_attr *const devattr = to_counter_attr(attr);
-	const struct counter_signal_ext_unit *const comp = devattr->component;
-	const struct counter_signal_ext *const ext = comp->ext;
-
-	return ext->write(dev_get_drvdata(dev), comp->signal, ext->priv, buf,
-		len);
-}
-
-static void counter_device_attr_list_free(struct list_head *attr_list)
-{
-	struct counter_device_attr *p, *n;
-
-	list_for_each_entry_safe(p, n, attr_list, l) {
-		/* free attribute name and associated component memory */
-		kfree(p->dev_attr.attr.name);
-		kfree(p->component);
-		list_del(&p->l);
-		kfree(p);
-	}
-}
-
-static int counter_signal_ext_register(
-	struct counter_device_attr_group *const group,
-	struct counter_signal *const signal)
-{
-	const size_t num_ext = signal->num_ext;
-	size_t i;
-	const struct counter_signal_ext *ext;
-	struct counter_signal_ext_unit *signal_ext_comp;
-	struct counter_attr_parm parm;
-	int err;
-
-	/* Create an attribute for each extension */
-	for (i = 0 ; i < num_ext; i++) {
-		ext = signal->ext + i;
-
-		/* Allocate signal_ext attribute component */
-		signal_ext_comp = kmalloc(sizeof(*signal_ext_comp), GFP_KERNEL);
-		if (!signal_ext_comp) {
-			err = -ENOMEM;
-			goto err_free_attr_list;
-		}
-		signal_ext_comp->signal = signal;
-		signal_ext_comp->ext = ext;
-
-		/* Allocate a Counter device attribute */
-		parm.group = group;
-		parm.prefix = "";
-		parm.name = ext->name;
-		parm.show = (ext->read) ? counter_signal_ext_show : NULL;
-		parm.store = (ext->write) ? counter_signal_ext_store : NULL;
-		parm.component = signal_ext_comp;
-		err = counter_attribute_create(&parm);
-		if (err) {
-			kfree(signal_ext_comp);
-			goto err_free_attr_list;
-		}
-	}
-
-	return 0;
-
-err_free_attr_list:
-	counter_device_attr_list_free(&group->attr_list);
-	return err;
-}
-
-static int counter_signal_attributes_create(
-	struct counter_device_attr_group *const group,
-	const struct counter_device *const counter,
-	struct counter_signal *const signal)
-{
-	struct counter_signal_unit *signal_comp;
-	struct counter_attr_parm parm;
-	int err;
-
-	/* Allocate Signal attribute component */
-	signal_comp = kmalloc(sizeof(*signal_comp), GFP_KERNEL);
-	if (!signal_comp)
-		return -ENOMEM;
-	signal_comp->signal = signal;
-
-	/* Create main Signal attribute */
-	parm.group = group;
-	parm.prefix = "";
-	parm.name = "signal";
-	parm.show = (counter->ops->signal_read) ? counter_signal_show : NULL;
-	parm.store = NULL;
-	parm.component = signal_comp;
-	err = counter_attribute_create(&parm);
-	if (err) {
-		kfree(signal_comp);
-		return err;
-	}
-
-	/* Create Signal name attribute */
-	err = counter_name_attribute_create(group, signal->name);
-	if (err)
-		goto err_free_attr_list;
-
-	/* Register Signal extension attributes */
-	err = counter_signal_ext_register(group, signal);
-	if (err)
-		goto err_free_attr_list;
-
-	return 0;
-
-err_free_attr_list:
-	counter_device_attr_list_free(&group->attr_list);
-	return err;
-}
-
-static int counter_signals_register(
-	struct counter_device_attr_group *const groups_list,
-	const struct counter_device *const counter)
-{
-	const size_t num_signals = counter->num_signals;
-	size_t i;
-	struct counter_signal *signal;
-	const char *name;
-	int err;
-
-	/* Register each Signal */
-	for (i = 0; i < num_signals; i++) {
-		signal = counter->signals + i;
-
-		/* Generate Signal attribute directory name */
-		name = kasprintf(GFP_KERNEL, "signal%d", signal->id);
-		if (!name) {
-			err = -ENOMEM;
-			goto err_free_attr_groups;
-		}
-		groups_list[i].attr_group.name = name;
-
-		/* Create all attributes associated with Signal */
-		err = counter_signal_attributes_create(groups_list + i, counter,
-						       signal);
-		if (err)
-			goto err_free_attr_groups;
-	}
-
-	return 0;
-
-err_free_attr_groups:
-	do {
-		kfree(groups_list[i].attr_group.name);
-		counter_device_attr_list_free(&groups_list[i].attr_list);
-	} while (i--);
-	return err;
-}
-
-static const char *const counter_synapse_action_str[] = {
-	[COUNTER_SYNAPSE_ACTION_NONE] = "none",
-	[COUNTER_SYNAPSE_ACTION_RISING_EDGE] = "rising edge",
-	[COUNTER_SYNAPSE_ACTION_FALLING_EDGE] = "falling edge",
-	[COUNTER_SYNAPSE_ACTION_BOTH_EDGES] = "both edges"
-};
-
-struct counter_action_unit {
-	struct counter_synapse *synapse;
-	struct counter_count *count;
-};
-
-static ssize_t counter_action_show(struct device *dev,
-				   struct device_attribute *attr, char *buf)
-{
-	const struct counter_device_attr *const devattr = to_counter_attr(attr);
-	int err;
-	struct counter_device *const counter = dev_get_drvdata(dev);
-	const struct counter_action_unit *const component = devattr->component;
-	struct counter_count *const count = component->count;
-	struct counter_synapse *const synapse = component->synapse;
-	size_t action_index;
-	enum counter_synapse_action action;
-
-	err = counter->ops->action_get(counter, count, synapse, &action_index);
-	if (err)
-		return err;
-
-	synapse->action = action_index;
-
-	action = synapse->actions_list[action_index];
-	return sprintf(buf, "%s\n", counter_synapse_action_str[action]);
-}
-
-static ssize_t counter_action_store(struct device *dev,
-				    struct device_attribute *attr,
-				    const char *buf, size_t len)
-{
-	const struct counter_device_attr *const devattr = to_counter_attr(attr);
-	const struct counter_action_unit *const component = devattr->component;
-	struct counter_synapse *const synapse = component->synapse;
-	size_t action_index;
-	const size_t num_actions = synapse->num_actions;
-	enum counter_synapse_action action;
-	int err;
-	struct counter_device *const counter = dev_get_drvdata(dev);
-	struct counter_count *const count = component->count;
-
-	/* Find requested action mode */
-	for (action_index = 0; action_index < num_actions; action_index++) {
-		action = synapse->actions_list[action_index];
-		if (sysfs_streq(buf, counter_synapse_action_str[action]))
-			break;
-	}
-	/* If requested action mode not found */
-	if (action_index >= num_actions)
-		return -EINVAL;
-
-	err = counter->ops->action_set(counter, count, synapse, action_index);
-	if (err)
-		return err;
-
-	synapse->action = action_index;
-
-	return len;
-}
-
-struct counter_action_avail_unit {
-	const enum counter_synapse_action *actions_list;
-	size_t num_actions;
-};
-
-static ssize_t counter_synapse_action_available_show(struct device *dev,
-	struct device_attribute *attr, char *buf)
-{
-	const struct counter_device_attr *const devattr = to_counter_attr(attr);
-	const struct counter_action_avail_unit *const component = devattr->component;
-	size_t i;
-	enum counter_synapse_action action;
-	ssize_t len = 0;
-
-	for (i = 0; i < component->num_actions; i++) {
-		action = component->actions_list[i];
-		len += sprintf(buf + len, "%s\n",
-			       counter_synapse_action_str[action]);
-	}
-
-	return len;
-}
-
-static int counter_synapses_register(
-	struct counter_device_attr_group *const group,
-	const struct counter_device *const counter,
-	struct counter_count *const count, const char *const count_attr_name)
-{
-	size_t i;
-	struct counter_synapse *synapse;
-	const char *prefix;
-	struct counter_action_unit *action_comp;
-	struct counter_attr_parm parm;
-	int err;
-	struct counter_action_avail_unit *avail_comp;
-
-	/* Register each Synapse */
-	for (i = 0; i < count->num_synapses; i++) {
-		synapse = count->synapses + i;
-
-		/* Generate attribute prefix */
-		prefix = kasprintf(GFP_KERNEL, "signal%d_",
-				   synapse->signal->id);
-		if (!prefix) {
-			err = -ENOMEM;
-			goto err_free_attr_list;
-		}
-
-		/* Allocate action attribute component */
-		action_comp = kmalloc(sizeof(*action_comp), GFP_KERNEL);
-		if (!action_comp) {
-			err = -ENOMEM;
-			goto err_free_prefix;
-		}
-		action_comp->synapse = synapse;
-		action_comp->count = count;
-
-		/* Create action attribute */
-		parm.group = group;
-		parm.prefix = prefix;
-		parm.name = "action";
-		parm.show = (counter->ops->action_get) ? counter_action_show : NULL;
-		parm.store = (counter->ops->action_set) ? counter_action_store : NULL;
-		parm.component = action_comp;
-		err = counter_attribute_create(&parm);
-		if (err) {
-			kfree(action_comp);
-			goto err_free_prefix;
-		}
-
-		/* Allocate action available attribute component */
-		avail_comp = kmalloc(sizeof(*avail_comp), GFP_KERNEL);
-		if (!avail_comp) {
-			err = -ENOMEM;
-			goto err_free_prefix;
-		}
-		avail_comp->actions_list = synapse->actions_list;
-		avail_comp->num_actions = synapse->num_actions;
-
-		/* Create action_available attribute */
-		parm.group = group;
-		parm.prefix = prefix;
-		parm.name = "action_available";
-		parm.show = counter_synapse_action_available_show;
-		parm.store = NULL;
-		parm.component = avail_comp;
-		err = counter_attribute_create(&parm);
-		if (err) {
-			kfree(avail_comp);
-			goto err_free_prefix;
-		}
-
-		kfree(prefix);
-	}
-
-	return 0;
-
-err_free_prefix:
-	kfree(prefix);
-err_free_attr_list:
-	counter_device_attr_list_free(&group->attr_list);
-	return err;
-}
-
-struct counter_count_unit {
-	struct counter_count *count;
-};
-
-static ssize_t counter_count_show(struct device *dev,
-				  struct device_attribute *attr,
-				  char *buf)
-{
-	struct counter_device *const counter = dev_get_drvdata(dev);
-	const struct counter_device_attr *const devattr = to_counter_attr(attr);
-	const struct counter_count_unit *const component = devattr->component;
-	struct counter_count *const count = component->count;
-	int err;
-	unsigned long val;
-
-	err = counter->ops->count_read(counter, count, &val);
-	if (err)
-		return err;
-
-	return sprintf(buf, "%lu\n", val);
-}
-
-static ssize_t counter_count_store(struct device *dev,
-				   struct device_attribute *attr,
-				   const char *buf, size_t len)
-{
-	struct counter_device *const counter = dev_get_drvdata(dev);
-	const struct counter_device_attr *const devattr = to_counter_attr(attr);
-	const struct counter_count_unit *const component = devattr->component;
-	struct counter_count *const count = component->count;
-	int err;
-	unsigned long val;
-
-	err = kstrtoul(buf, 0, &val);
-	if (err)
-		return err;
-
-	err = counter->ops->count_write(counter, count, val);
-	if (err)
-		return err;
-
-	return len;
-}
-
-static const char *const counter_function_str[] = {
-	[COUNTER_FUNCTION_INCREASE] = "increase",
-	[COUNTER_FUNCTION_DECREASE] = "decrease",
-	[COUNTER_FUNCTION_PULSE_DIRECTION] = "pulse-direction",
-	[COUNTER_FUNCTION_QUADRATURE_X1_A] = "quadrature x1 a",
-	[COUNTER_FUNCTION_QUADRATURE_X1_B] = "quadrature x1 b",
-	[COUNTER_FUNCTION_QUADRATURE_X2_A] = "quadrature x2 a",
-	[COUNTER_FUNCTION_QUADRATURE_X2_B] = "quadrature x2 b",
-	[COUNTER_FUNCTION_QUADRATURE_X4] = "quadrature x4"
-};
-
-static ssize_t counter_function_show(struct device *dev,
-				     struct device_attribute *attr, char *buf)
-{
-	int err;
-	struct counter_device *const counter = dev_get_drvdata(dev);
-	const struct counter_device_attr *const devattr = to_counter_attr(attr);
-	const struct counter_count_unit *const component = devattr->component;
-	struct counter_count *const count = component->count;
-	size_t func_index;
-	enum counter_function function;
-
-	err = counter->ops->function_get(counter, count, &func_index);
-	if (err)
-		return err;
-
-	count->function = func_index;
-
-	function = count->functions_list[func_index];
-	return sprintf(buf, "%s\n", counter_function_str[function]);
-}
-
-static ssize_t counter_function_store(struct device *dev,
-				      struct device_attribute *attr,
-				      const char *buf, size_t len)
-{
-	const struct counter_device_attr *const devattr = to_counter_attr(attr);
-	const struct counter_count_unit *const component = devattr->component;
-	struct counter_count *const count = component->count;
-	const size_t num_functions = count->num_functions;
-	size_t func_index;
-	enum counter_function function;
-	int err;
-	struct counter_device *const counter = dev_get_drvdata(dev);
-
-	/* Find requested Count function mode */
-	for (func_index = 0; func_index < num_functions; func_index++) {
-		function = count->functions_list[func_index];
-		if (sysfs_streq(buf, counter_function_str[function]))
-			break;
-	}
-	/* Return error if requested Count function mode not found */
-	if (func_index >= num_functions)
-		return -EINVAL;
-
-	err = counter->ops->function_set(counter, count, func_index);
-	if (err)
-		return err;
-
-	count->function = func_index;
-
-	return len;
-}
-
-struct counter_count_ext_unit {
-	struct counter_count *count;
-	const struct counter_count_ext *ext;
-};
-
-static ssize_t counter_count_ext_show(struct device *dev,
-				      struct device_attribute *attr, char *buf)
-{
-	const struct counter_device_attr *const devattr = to_counter_attr(attr);
-	const struct counter_count_ext_unit *const comp = devattr->component;
-	const struct counter_count_ext *const ext = comp->ext;
-
-	return ext->read(dev_get_drvdata(dev), comp->count, ext->priv, buf);
-}
-
-static ssize_t counter_count_ext_store(struct device *dev,
-				       struct device_attribute *attr,
-				       const char *buf, size_t len)
-{
-	const struct counter_device_attr *const devattr = to_counter_attr(attr);
-	const struct counter_count_ext_unit *const comp = devattr->component;
-	const struct counter_count_ext *const ext = comp->ext;
-
-	return ext->write(dev_get_drvdata(dev), comp->count, ext->priv, buf,
-		len);
-}
-
-static int counter_count_ext_register(
-	struct counter_device_attr_group *const group,
-	struct counter_count *const count)
-{
-	size_t i;
-	const struct counter_count_ext *ext;
-	struct counter_count_ext_unit *count_ext_comp;
-	struct counter_attr_parm parm;
-	int err;
-
-	/* Create an attribute for each extension */
-	for (i = 0 ; i < count->num_ext; i++) {
-		ext = count->ext + i;
-
-		/* Allocate count_ext attribute component */
-		count_ext_comp = kmalloc(sizeof(*count_ext_comp), GFP_KERNEL);
-		if (!count_ext_comp) {
-			err = -ENOMEM;
-			goto err_free_attr_list;
-		}
-		count_ext_comp->count = count;
-		count_ext_comp->ext = ext;
-
-		/* Allocate count_ext attribute */
-		parm.group = group;
-		parm.prefix = "";
-		parm.name = ext->name;
-		parm.show = (ext->read) ? counter_count_ext_show : NULL;
-		parm.store = (ext->write) ? counter_count_ext_store : NULL;
-		parm.component = count_ext_comp;
-		err = counter_attribute_create(&parm);
-		if (err) {
-			kfree(count_ext_comp);
-			goto err_free_attr_list;
-		}
-	}
-
-	return 0;
-
-err_free_attr_list:
-	counter_device_attr_list_free(&group->attr_list);
-	return err;
-}
-
-struct counter_func_avail_unit {
-	const enum counter_function *functions_list;
-	size_t num_functions;
-};
-
-static ssize_t counter_function_available_show(struct device *dev,
-	struct device_attribute *attr, char *buf)
-{
-	const struct counter_device_attr *const devattr = to_counter_attr(attr);
-	const struct counter_func_avail_unit *const component = devattr->component;
-	const enum counter_function *const func_list = component->functions_list;
-	const size_t num_functions = component->num_functions;
-	size_t i;
-	enum counter_function function;
-	ssize_t len = 0;
-
-	for (i = 0; i < num_functions; i++) {
-		function = func_list[i];
-		len += sprintf(buf + len, "%s\n",
-			       counter_function_str[function]);
-	}
-
-	return len;
-}
-
-static int counter_count_attributes_create(
-	struct counter_device_attr_group *const group,
-	const struct counter_device *const counter,
-	struct counter_count *const count)
-{
-	struct counter_count_unit *count_comp;
-	struct counter_attr_parm parm;
-	int err;
-	struct counter_count_unit *func_comp;
-	struct counter_func_avail_unit *avail_comp;
-
-	/* Allocate count attribute component */
-	count_comp = kmalloc(sizeof(*count_comp), GFP_KERNEL);
-	if (!count_comp)
-		return -ENOMEM;
-	count_comp->count = count;
-
-	/* Create main Count attribute */
-	parm.group = group;
-	parm.prefix = "";
-	parm.name = "count";
-	parm.show = (counter->ops->count_read) ? counter_count_show : NULL;
-	parm.store = (counter->ops->count_write) ? counter_count_store : NULL;
-	parm.component = count_comp;
-	err = counter_attribute_create(&parm);
-	if (err) {
-		kfree(count_comp);
-		return err;
-	}
-
-	/* Allocate function attribute component */
-	func_comp = kmalloc(sizeof(*func_comp), GFP_KERNEL);
-	if (!func_comp) {
-		err = -ENOMEM;
-		goto err_free_attr_list;
-	}
-	func_comp->count = count;
-
-	/* Create Count function attribute */
-	parm.group = group;
-	parm.prefix = "";
-	parm.name = "function";
-	parm.show = (counter->ops->function_get) ? counter_function_show : NULL;
-	parm.store = (counter->ops->function_set) ? counter_function_store : NULL;
-	parm.component = func_comp;
-	err = counter_attribute_create(&parm);
-	if (err) {
-		kfree(func_comp);
-		goto err_free_attr_list;
-	}
-
-	/* Allocate function available attribute component */
-	avail_comp = kmalloc(sizeof(*avail_comp), GFP_KERNEL);
-	if (!avail_comp) {
-		err = -ENOMEM;
-		goto err_free_attr_list;
-	}
-	avail_comp->functions_list = count->functions_list;
-	avail_comp->num_functions = count->num_functions;
-
-	/* Create Count function_available attribute */
-	parm.group = group;
-	parm.prefix = "";
-	parm.name = "function_available";
-	parm.show = counter_function_available_show;
-	parm.store = NULL;
-	parm.component = avail_comp;
-	err = counter_attribute_create(&parm);
-	if (err) {
-		kfree(avail_comp);
-		goto err_free_attr_list;
-	}
-
-	/* Create Count name attribute */
-	err = counter_name_attribute_create(group, count->name);
-	if (err)
-		goto err_free_attr_list;
-
-	/* Register Count extension attributes */
-	err = counter_count_ext_register(group, count);
-	if (err)
-		goto err_free_attr_list;
-
-	return 0;
-
-err_free_attr_list:
-	counter_device_attr_list_free(&group->attr_list);
-	return err;
-}
-
-static int counter_counts_register(
-	struct counter_device_attr_group *const groups_list,
-	const struct counter_device *const counter)
-{
-	size_t i;
-	struct counter_count *count;
-	const char *name;
-	int err;
-
-	/* Register each Count */
-	for (i = 0; i < counter->num_counts; i++) {
-		count = counter->counts + i;
-
-		/* Generate Count attribute directory name */
-		name = kasprintf(GFP_KERNEL, "count%d", count->id);
-		if (!name) {
-			err = -ENOMEM;
-			goto err_free_attr_groups;
-		}
-		groups_list[i].attr_group.name = name;
-
-		/* Register the Synapses associated with each Count */
-		err = counter_synapses_register(groups_list + i, counter, count,
-						name);
-		if (err)
-			goto err_free_attr_groups;
-
-		/* Create all attributes associated with Count */
-		err = counter_count_attributes_create(groups_list + i, counter,
-						      count);
-		if (err)
-			goto err_free_attr_groups;
-	}
-
-	return 0;
-
-err_free_attr_groups:
-	do {
-		kfree(groups_list[i].attr_group.name);
-		counter_device_attr_list_free(&groups_list[i].attr_list);
-	} while (i--);
-	return err;
-}
-
-struct counter_size_unit {
-	size_t size;
-};
-
-static ssize_t counter_device_attr_size_show(struct device *dev,
-					     struct device_attribute *attr,
-					     char *buf)
-{
-	const struct counter_size_unit *const comp = to_counter_attr(attr)->component;
-
-	return sprintf(buf, "%zu\n", comp->size);
-}
-
-static int counter_size_attribute_create(
-	struct counter_device_attr_group *const group,
-	const size_t size, const char *const name)
-{
-	struct counter_size_unit *size_comp;
-	struct counter_attr_parm parm;
-	int err;
-
-	/* Allocate size attribute component */
-	size_comp = kmalloc(sizeof(*size_comp), GFP_KERNEL);
-	if (!size_comp)
-		return -ENOMEM;
-	size_comp->size = size;
-
-	parm.group = group;
-	parm.prefix = "";
-	parm.name = name;
-	parm.show = counter_device_attr_size_show;
-	parm.store = NULL;
-	parm.component = size_comp;
-	err = counter_attribute_create(&parm);
-	if (err)
-		goto err_free_size_comp;
-
-	return 0;
-
-err_free_size_comp:
-	kfree(size_comp);
-	return err;
-}
-
-struct counter_ext_unit {
-	const struct counter_device_ext *ext;
-};
-
-static ssize_t counter_device_ext_show(struct device *dev,
-				       struct device_attribute *attr, char *buf)
-{
-	const struct counter_device_attr *const devattr = to_counter_attr(attr);
-	const struct counter_ext_unit *const component = devattr->component;
-	const struct counter_device_ext *const ext = component->ext;
-
-	return ext->read(dev_get_drvdata(dev), ext->priv, buf);
-}
-
-static ssize_t counter_device_ext_store(struct device *dev,
-					struct device_attribute *attr,
-					const char *buf, size_t len)
-{
-	const struct counter_device_attr *const devattr = to_counter_attr(attr);
-	const struct counter_ext_unit *const component = devattr->component;
-	const struct counter_device_ext *const ext = component->ext;
-
-	return ext->write(dev_get_drvdata(dev), ext->priv, buf, len);
-}
-
-static int counter_device_ext_register(
-	struct counter_device_attr_group *const group,
-	struct counter_device *const counter)
-{
-	size_t i;
-	struct counter_ext_unit *ext_comp;
-	struct counter_attr_parm parm;
-	int err;
-
-	/* Create an attribute for each extension */
-	for (i = 0 ; i < counter->num_ext; i++) {
-		/* Allocate extension attribute component */
-		ext_comp = kmalloc(sizeof(*ext_comp), GFP_KERNEL);
-		if (!ext_comp) {
-			err = -ENOMEM;
-			goto err_free_attr_list;
-		}
-
-		ext_comp->ext = counter->ext + i;
-
-		/* Allocate extension attribute */
-		parm.group = group;
-		parm.prefix = "";
-		parm.name = counter->ext[i].name;
-		parm.show = (counter->ext[i].read) ? counter_device_ext_show : NULL;
-		parm.store = (counter->ext[i].write) ? counter_device_ext_store : NULL;
-		parm.component = ext_comp;
-		err = counter_attribute_create(&parm);
-		if (err) {
-			kfree(ext_comp);
-			goto err_free_attr_list;
-		}
-	}
-
-	return 0;
-
-err_free_attr_list:
-	counter_device_attr_list_free(&group->attr_list);
-	return err;
-}
-
-static int counter_global_attr_register(
-	struct counter_device_attr_group *const group,
-	struct counter_device *const counter)
-{
-	int err;
-
-	/* Create name attribute */
-	err = counter_name_attribute_create(group, counter->name);
-	if (err)
-		return err;
-
-	/* Create num_counts attribute */
-	err = counter_size_attribute_create(group, counter->num_counts,
-					    "num_counts");
-	if (err)
-		goto err_free_attr_list;
-
-	/* Create num_signals attribute */
-	err = counter_size_attribute_create(group, counter->num_signals,
-					    "num_signals");
-	if (err)
-		goto err_free_attr_list;
-
-	/* Register Counter device extension attributes */
-	err = counter_device_ext_register(group, counter);
-	if (err)
-		goto err_free_attr_list;
-
-	return 0;
-
-err_free_attr_list:
-	counter_device_attr_list_free(&group->attr_list);
-	return err;
-}
-
-static void counter_device_groups_list_free(
-	struct counter_device_attr_group *const groups_list,
-	const size_t num_groups)
-{
-	struct counter_device_attr_group *group;
-	size_t i;
-
-	/* loop through all attribute groups (signals, counts, global, etc.) */
-	for (i = 0; i < num_groups; i++) {
-		group = groups_list + i;
-
-		/* free all attribute group and associated attributes memory */
-		kfree(group->attr_group.name);
-		kfree(group->attr_group.attrs);
-		counter_device_attr_list_free(&group->attr_list);
-	}
-
-	kfree(groups_list);
-}
-
-static int counter_device_groups_list_prepare(
-	struct counter_device *const counter)
-{
-	const size_t total_num_groups =
-		counter->num_signals + counter->num_counts + 1;
-	struct counter_device_attr_group *groups_list;
-	size_t i;
-	int err;
-	size_t num_groups = 0;
-
-	/* Allocate space for attribute groups (signals, counts, and ext) */
-	groups_list = kcalloc(total_num_groups, sizeof(*groups_list),
-			      GFP_KERNEL);
-	if (!groups_list)
-		return -ENOMEM;
-
-	/* Initialize attribute lists */
-	for (i = 0; i < total_num_groups; i++)
-		INIT_LIST_HEAD(&groups_list[i].attr_list);
-
-	/* Register Signals */
-	err = counter_signals_register(groups_list, counter);
-	if (err)
-		goto err_free_groups_list;
-	num_groups += counter->num_signals;
-
-	/* Register Counts and respective Synapses */
-	err = counter_counts_register(groups_list + num_groups, counter);
-	if (err)
-		goto err_free_groups_list;
-	num_groups += counter->num_counts;
-
-	/* Register Counter global attributes */
-	err = counter_global_attr_register(groups_list + num_groups, counter);
-	if (err)
-		goto err_free_groups_list;
-	num_groups++;
-
-	/* Store groups_list in device_state */
-	counter->device_state->groups_list = groups_list;
-	counter->device_state->num_groups = num_groups;
-
-	return 0;
-
-err_free_groups_list:
-	counter_device_groups_list_free(groups_list, num_groups);
-	return err;
-}
-
-static int counter_device_groups_prepare(
-	struct counter_device_state *const device_state)
-{
-	size_t i, j;
-	struct counter_device_attr_group *group;
-	int err;
-	struct counter_device_attr *p;
-
-	/* Allocate attribute groups for association with device */
-	device_state->groups = kcalloc(device_state->num_groups + 1,
-				       sizeof(*device_state->groups),
-				       GFP_KERNEL);
-	if (!device_state->groups)
-		return -ENOMEM;
-
-	/* Prepare each group of attributes for association */
-	for (i = 0; i < device_state->num_groups; i++) {
-		group = device_state->groups_list + i;
-
-		/* Allocate space for attribute pointers in attribute group */
-		group->attr_group.attrs = kcalloc(group->num_attr + 1,
-			sizeof(*group->attr_group.attrs), GFP_KERNEL);
-		if (!group->attr_group.attrs) {
-			err = -ENOMEM;
-			goto err_free_groups;
-		}
-
-		/* Add attribute pointers to attribute group */
-		j = 0;
-		list_for_each_entry(p, &group->attr_list, l)
-			group->attr_group.attrs[j++] = &p->dev_attr.attr;
-
-		/* Group attributes in attribute group */
-		device_state->groups[i] = &group->attr_group;
-	}
-	/* Associate attributes with device */
-	device_state->dev.groups = device_state->groups;
-
-	return 0;
-
-err_free_groups:
-	do {
-		group = device_state->groups_list + i;
-		kfree(group->attr_group.attrs);
-		group->attr_group.attrs = NULL;
-	} while (i--);
-	kfree(device_state->groups);
-	return err;
-}
-
-/* Provides a unique ID for each counter device */
-static DEFINE_IDA(counter_ida);
-
-static void counter_device_release(struct device *dev)
-{
-	struct counter_device *const counter = dev_get_drvdata(dev);
-	struct counter_device_state *const device_state = counter->device_state;
-
-	kfree(device_state->groups);
-	counter_device_groups_list_free(device_state->groups_list,
-					device_state->num_groups);
-	ida_simple_remove(&counter_ida, device_state->id);
-	kfree(device_state);
-}
-
-static struct device_type counter_device_type = {
-	.name = "counter_device",
-	.release = counter_device_release
-};
-
-static struct bus_type counter_bus_type = {
-	.name = "counter"
-};
-
-/**
- * counter_register - register Counter to the system
- * @counter:	pointer to Counter to register
- *
- * This function registers a Counter to the system. A sysfs "counter" directory
- * will be created and populated with sysfs attributes correlating with the
- * Counter Signals, Synapses, and Counts respectively.
- */
-int counter_register(struct counter_device *const counter)
-{
-	struct counter_device_state *device_state;
-	int err;
-
-	/* Allocate internal state container for Counter device */
-	device_state = kzalloc(sizeof(*device_state), GFP_KERNEL);
-	if (!device_state)
-		return -ENOMEM;
-	counter->device_state = device_state;
-
-	/* Acquire unique ID */
-	device_state->id = ida_simple_get(&counter_ida, 0, 0, GFP_KERNEL);
-	if (device_state->id < 0) {
-		err = device_state->id;
-		goto err_free_device_state;
-	}
-
-	/* Configure device structure for Counter */
-	device_state->dev.type = &counter_device_type;
-	device_state->dev.bus = &counter_bus_type;
-	if (counter->parent) {
-		device_state->dev.parent = counter->parent;
-		device_state->dev.of_node = counter->parent->of_node;
-	}
-	dev_set_name(&device_state->dev, "counter%d", device_state->id);
-	device_initialize(&device_state->dev);
-	dev_set_drvdata(&device_state->dev, counter);
-
-	/* Prepare device attributes */
-	err = counter_device_groups_list_prepare(counter);
-	if (err)
-		goto err_free_id;
-
-	/* Organize device attributes to groups and match to device */
-	err = counter_device_groups_prepare(device_state);
-	if (err)
-		goto err_free_groups_list;
-
-	/* Add device to system */
-	err = device_add(&device_state->dev);
-	if (err)
-		goto err_free_groups;
-
-	return 0;
-
-err_free_groups:
-	kfree(device_state->groups);
-err_free_groups_list:
-	counter_device_groups_list_free(device_state->groups_list,
-					device_state->num_groups);
-err_free_id:
-	ida_simple_remove(&counter_ida, device_state->id);
-err_free_device_state:
-	kfree(device_state);
-	return err;
-}
-EXPORT_SYMBOL_GPL(counter_register);
-
-/**
- * counter_unregister - unregister Counter from the system
- * @counter:	pointer to Counter to unregister
- *
- * The Counter is unregistered from the system; all allocated memory is freed.
- */
-void counter_unregister(struct counter_device *const counter)
-{
-	if (counter)
-		device_del(&counter->device_state->dev);
-}
-EXPORT_SYMBOL_GPL(counter_unregister);
-
-static void devm_counter_unreg(struct device *dev, void *res)
-{
-	counter_unregister(*(struct counter_device **)res);
-}
-
-/**
- * devm_counter_register - Resource-managed counter_register
- * @dev:	device to allocate counter_device for
- * @counter:	pointer to Counter to register
- *
- * Managed counter_register. The Counter registered with this function is
- * automatically unregistered on driver detach. This function calls
- * counter_register internally. Refer to that function for more information.
- *
- * If an Counter registered with this function needs to be unregistered
- * separately, devm_counter_unregister must be used.
- *
- * RETURNS:
- * 0 on success, negative error number on failure.
- */
-int devm_counter_register(struct device *dev,
-			  struct counter_device *const counter)
-{
-	struct counter_device **ptr;
-	int ret;
-
-	ptr = devres_alloc(devm_counter_unreg, sizeof(*ptr), GFP_KERNEL);
-	if (!ptr)
-		return -ENOMEM;
-
-	ret = counter_register(counter);
-	if (!ret) {
-		*ptr = counter;
-		devres_add(dev, ptr);
-	} else {
-		devres_free(ptr);
-	}
-
-	return ret;
-}
-EXPORT_SYMBOL_GPL(devm_counter_register);
-
-static int devm_counter_match(struct device *dev, void *res, void *data)
-{
-	struct counter_device **r = res;
-
-	if (!r || !*r) {
-		WARN_ON(!r || !*r);
-		return 0;
-	}
-
-	return *r == data;
-}
-
-/**
- * devm_counter_unregister - Resource-managed counter_unregister
- * @dev:	device this counter_device belongs to
- * @counter:	pointer to Counter associated with the device
- *
- * Unregister Counter registered with devm_counter_register.
- */
-void devm_counter_unregister(struct device *dev,
-			     struct counter_device *const counter)
-{
-	int rc;
-
-	rc = devres_release(dev, devm_counter_unreg, devm_counter_match,
-			    counter);
-	WARN_ON(rc);
-}
-EXPORT_SYMBOL_GPL(devm_counter_unregister);
-
-static int __init counter_init(void)
-{
-	return bus_register(&counter_bus_type);
-}
-
-static void __exit counter_exit(void)
-{
-	bus_unregister(&counter_bus_type);
-}
-
-subsys_initcall(counter_init);
-module_exit(counter_exit);
-
-MODULE_AUTHOR("William Breathitt Gray <vilhelm.gray@gmail.com>");
-MODULE_DESCRIPTION("Generic Counter interface");
-MODULE_LICENSE("GPL v2");
diff --git a/drivers/counter/ftm-quaddec.c b/drivers/counter/ftm-quaddec.c
index 53c15f84909b9..5ef0478709cd8 100644
--- a/drivers/counter/ftm-quaddec.c
+++ b/drivers/counter/ftm-quaddec.c
@@ -14,6 +14,7 @@
 #include <linux/mutex.h>
 #include <linux/counter.h>
 #include <linux/bitfield.h>
+#include <linux/types.h>
 
 #define FTM_FIELD_UPDATE(ftm, offset, mask, val)			\
 	({								\
@@ -115,8 +116,7 @@ static void ftm_quaddec_disable(void *ftm)
 }
 
 static int ftm_quaddec_get_prescaler(struct counter_device *counter,
-				     struct counter_count *count,
-				     size_t *cnt_mode)
+				     struct counter_count *count, u32 *cnt_mode)
 {
 	struct ftm_quaddec *ftm = counter->priv;
 	uint32_t scflags;
@@ -129,8 +129,7 @@ static int ftm_quaddec_get_prescaler(struct counter_device *counter,
 }
 
 static int ftm_quaddec_set_prescaler(struct counter_device *counter,
-				     struct counter_count *count,
-				     size_t cnt_mode)
+				     struct counter_count *count, u32 cnt_mode)
 {
 	struct ftm_quaddec *ftm = counter->priv;
 
@@ -151,33 +150,17 @@ static const char * const ftm_quaddec_prescaler[] = {
 	"1", "2", "4", "8", "16", "32", "64", "128"
 };
 
-static struct counter_count_enum_ext ftm_quaddec_prescaler_enum = {
-	.items = ftm_quaddec_prescaler,
-	.num_items = ARRAY_SIZE(ftm_quaddec_prescaler),
-	.get = ftm_quaddec_get_prescaler,
-	.set = ftm_quaddec_set_prescaler
-};
-
-enum ftm_quaddec_synapse_action {
-	FTM_QUADDEC_SYNAPSE_ACTION_BOTH_EDGES,
-};
-
 static const enum counter_synapse_action ftm_quaddec_synapse_actions[] = {
-	[FTM_QUADDEC_SYNAPSE_ACTION_BOTH_EDGES] =
 	COUNTER_SYNAPSE_ACTION_BOTH_EDGES
 };
 
-enum ftm_quaddec_count_function {
-	FTM_QUADDEC_COUNT_ENCODER_MODE_1,
-};
-
 static const enum counter_function ftm_quaddec_count_functions[] = {
-	[FTM_QUADDEC_COUNT_ENCODER_MODE_1] = COUNTER_FUNCTION_QUADRATURE_X4
+	COUNTER_FUNCTION_QUADRATURE_X4
 };
 
 static int ftm_quaddec_count_read(struct counter_device *counter,
 				  struct counter_count *count,
-				  unsigned long *val)
+				  u64 *val)
 {
 	struct ftm_quaddec *const ftm = counter->priv;
 	uint32_t cntval;
@@ -191,7 +174,7 @@ static int ftm_quaddec_count_read(struct counter_device *counter,
 
 static int ftm_quaddec_count_write(struct counter_device *counter,
 				   struct counter_count *count,
-				   const unsigned long val)
+				   const u64 val)
 {
 	struct ftm_quaddec *const ftm = counter->priv;
 
@@ -205,21 +188,21 @@ static int ftm_quaddec_count_write(struct counter_device *counter,
 	return 0;
 }
 
-static int ftm_quaddec_count_function_get(struct counter_device *counter,
-					  struct counter_count *count,
-					  size_t *function)
+static int ftm_quaddec_count_function_read(struct counter_device *counter,
+					   struct counter_count *count,
+					   enum counter_function *function)
 {
-	*function = FTM_QUADDEC_COUNT_ENCODER_MODE_1;
+	*function = COUNTER_FUNCTION_QUADRATURE_X4;
 
 	return 0;
 }
 
-static int ftm_quaddec_action_get(struct counter_device *counter,
-				  struct counter_count *count,
-				  struct counter_synapse *synapse,
-				  size_t *action)
+static int ftm_quaddec_action_read(struct counter_device *counter,
+				   struct counter_count *count,
+				   struct counter_synapse *synapse,
+				   enum counter_synapse_action *action)
 {
-	*action = FTM_QUADDEC_SYNAPSE_ACTION_BOTH_EDGES;
+	*action = COUNTER_SYNAPSE_ACTION_BOTH_EDGES;
 
 	return 0;
 }
@@ -227,8 +210,8 @@ static int ftm_quaddec_action_get(struct counter_device *counter,
 static const struct counter_ops ftm_quaddec_cnt_ops = {
 	.count_read = ftm_quaddec_count_read,
 	.count_write = ftm_quaddec_count_write,
-	.function_get = ftm_quaddec_count_function_get,
-	.action_get = ftm_quaddec_action_get,
+	.function_read = ftm_quaddec_count_function_read,
+	.action_read = ftm_quaddec_action_read,
 };
 
 static struct counter_signal ftm_quaddec_signals[] = {
@@ -255,9 +238,12 @@ static struct counter_synapse ftm_quaddec_count_synapses[] = {
 	}
 };
 
-static const struct counter_count_ext ftm_quaddec_count_ext[] = {
-	COUNTER_COUNT_ENUM("prescaler", &ftm_quaddec_prescaler_enum),
-	COUNTER_COUNT_ENUM_AVAILABLE("prescaler", &ftm_quaddec_prescaler_enum),
+static DEFINE_COUNTER_ENUM(ftm_quaddec_prescaler_enum, ftm_quaddec_prescaler);
+
+static struct counter_comp ftm_quaddec_count_ext[] = {
+	COUNTER_COMP_COUNT_ENUM("prescaler", ftm_quaddec_get_prescaler,
+				ftm_quaddec_set_prescaler,
+				ftm_quaddec_prescaler_enum),
 };
 
 static struct counter_count ftm_quaddec_counts = {
diff --git a/drivers/counter/intel-qep.c b/drivers/counter/intel-qep.c
index 8a6847d5fb2bd..0924d16de6e26 100644
--- a/drivers/counter/intel-qep.c
+++ b/drivers/counter/intel-qep.c
@@ -62,13 +62,6 @@
 
 #define INTEL_QEP_CLK_PERIOD_NS		10
 
-#define INTEL_QEP_COUNTER_EXT_RW(_name)				\
-{								\
-	.name = #_name,						\
-	.read = _name##_read,					\
-	.write = _name##_write,					\
-}
-
 struct intel_qep {
 	struct counter_device counter;
 	struct mutex lock;
@@ -114,8 +107,7 @@ static void intel_qep_init(struct intel_qep *qep)
 }
 
 static int intel_qep_count_read(struct counter_device *counter,
-				struct counter_count *count,
-				unsigned long *val)
+				struct counter_count *count, u64 *val)
 {
 	struct intel_qep *const qep = counter->priv;
 
@@ -130,11 +122,11 @@ static const enum counter_function intel_qep_count_functions[] = {
 	COUNTER_FUNCTION_QUADRATURE_X4,
 };
 
-static int intel_qep_function_get(struct counter_device *counter,
-				  struct counter_count *count,
-				  size_t *function)
+static int intel_qep_function_read(struct counter_device *counter,
+				   struct counter_count *count,
+				   enum counter_function *function)
 {
-	*function = 0;
+	*function = COUNTER_FUNCTION_QUADRATURE_X4;
 
 	return 0;
 }
@@ -143,19 +135,19 @@ static const enum counter_synapse_action intel_qep_synapse_actions[] = {
 	COUNTER_SYNAPSE_ACTION_BOTH_EDGES,
 };
 
-static int intel_qep_action_get(struct counter_device *counter,
-				struct counter_count *count,
-				struct counter_synapse *synapse,
-				size_t *action)
+static int intel_qep_action_read(struct counter_device *counter,
+				 struct counter_count *count,
+				 struct counter_synapse *synapse,
+				 enum counter_synapse_action *action)
 {
-	*action = 0;
+	*action = COUNTER_SYNAPSE_ACTION_BOTH_EDGES;
 	return 0;
 }
 
 static const struct counter_ops intel_qep_counter_ops = {
 	.count_read = intel_qep_count_read,
-	.function_get = intel_qep_function_get,
-	.action_get = intel_qep_action_get,
+	.function_read = intel_qep_function_read,
+	.action_read = intel_qep_action_read,
 };
 
 #define INTEL_QEP_SIGNAL(_id, _name) {				\
@@ -181,31 +173,27 @@ static struct counter_synapse intel_qep_count_synapses[] = {
 	INTEL_QEP_SYNAPSE(2),
 };
 
-static ssize_t ceiling_read(struct counter_device *counter,
-			    struct counter_count *count,
-			    void *priv, char *buf)
+static int intel_qep_ceiling_read(struct counter_device *counter,
+				  struct counter_count *count, u64 *ceiling)
 {
 	struct intel_qep *qep = counter->priv;
-	u32 reg;
 
 	pm_runtime_get_sync(qep->dev);
-	reg = intel_qep_readl(qep, INTEL_QEPMAX);
+	*ceiling = intel_qep_readl(qep, INTEL_QEPMAX);
 	pm_runtime_put(qep->dev);
 
-	return sysfs_emit(buf, "%u\n", reg);
+	return 0;
 }
 
-static ssize_t ceiling_write(struct counter_device *counter,
-			     struct counter_count *count,
-			     void *priv, const char *buf, size_t len)
+static int intel_qep_ceiling_write(struct counter_device *counter,
+				   struct counter_count *count, u64 max)
 {
 	struct intel_qep *qep = counter->priv;
-	u32 max;
-	int ret;
+	int ret = 0;
 
-	ret = kstrtou32(buf, 0, &max);
-	if (ret < 0)
-		return ret;
+	/* Intel QEP ceiling configuration only supports 32-bit values */
+	if (max != (u32)max)
+		return -ERANGE;
 
 	mutex_lock(&qep->lock);
 	if (qep->enabled) {
@@ -216,34 +204,28 @@ static ssize_t ceiling_write(struct counter_device *counter,
 	pm_runtime_get_sync(qep->dev);
 	intel_qep_writel(qep, INTEL_QEPMAX, max);
 	pm_runtime_put(qep->dev);
-	ret = len;
 
 out:
 	mutex_unlock(&qep->lock);
 	return ret;
 }
 
-static ssize_t enable_read(struct counter_device *counter,
-			   struct counter_count *count,
-			   void *priv, char *buf)
+static int intel_qep_enable_read(struct counter_device *counter,
+				 struct counter_count *count, u8 *enable)
 {
 	struct intel_qep *qep = counter->priv;
 
-	return sysfs_emit(buf, "%u\n", qep->enabled);
+	*enable = qep->enabled;
+
+	return 0;
 }
 
-static ssize_t enable_write(struct counter_device *counter,
-			    struct counter_count *count,
-			    void *priv, const char *buf, size_t len)
+static int intel_qep_enable_write(struct counter_device *counter,
+				  struct counter_count *count, u8 val)
 {
 	struct intel_qep *qep = counter->priv;
 	u32 reg;
-	bool val, changed;
-	int ret;
-
-	ret = kstrtobool(buf, &val);
-	if (ret)
-		return ret;
+	bool changed;
 
 	mutex_lock(&qep->lock);
 	changed = val ^ qep->enabled;
@@ -267,12 +249,12 @@ static ssize_t enable_write(struct counter_device *counter,
 
 out:
 	mutex_unlock(&qep->lock);
-	return len;
+	return 0;
 }
 
-static ssize_t spike_filter_ns_read(struct counter_device *counter,
-				    struct counter_count *count,
-				    void *priv, char *buf)
+static int intel_qep_spike_filter_ns_read(struct counter_device *counter,
+					  struct counter_count *count,
+					  u64 *length)
 {
 	struct intel_qep *qep = counter->priv;
 	u32 reg;
@@ -281,33 +263,31 @@ static ssize_t spike_filter_ns_read(struct counter_device *counter,
 	reg = intel_qep_readl(qep, INTEL_QEPCON);
 	if (!(reg & INTEL_QEPCON_FLT_EN)) {
 		pm_runtime_put(qep->dev);
-		return sysfs_emit(buf, "0\n");
+		return 0;
 	}
 	reg = INTEL_QEPFLT_MAX_COUNT(intel_qep_readl(qep, INTEL_QEPFLT));
 	pm_runtime_put(qep->dev);
 
-	return sysfs_emit(buf, "%u\n", (reg + 2) * INTEL_QEP_CLK_PERIOD_NS);
+	*length = (reg + 2) * INTEL_QEP_CLK_PERIOD_NS;
+
+	return 0;
 }
 
-static ssize_t spike_filter_ns_write(struct counter_device *counter,
-				     struct counter_count *count,
-				     void *priv, const char *buf, size_t len)
+static int intel_qep_spike_filter_ns_write(struct counter_device *counter,
+					   struct counter_count *count,
+					   u64 length)
 {
 	struct intel_qep *qep = counter->priv;
-	u32 reg, length;
+	u32 reg;
 	bool enable;
-	int ret;
-
-	ret = kstrtou32(buf, 0, &length);
-	if (ret < 0)
-		return ret;
+	int ret = 0;
 
 	/*
 	 * Spike filter length is (MAX_COUNT + 2) clock periods.
 	 * Disable filter when userspace writes 0, enable for valid
 	 * nanoseconds values and error out otherwise.
 	 */
-	length /= INTEL_QEP_CLK_PERIOD_NS;
+	do_div(length, INTEL_QEP_CLK_PERIOD_NS);
 	if (length == 0) {
 		enable = false;
 		length = 0;
@@ -336,16 +316,15 @@ static ssize_t spike_filter_ns_write(struct counter_device *counter,
 	intel_qep_writel(qep, INTEL_QEPFLT, length);
 	intel_qep_writel(qep, INTEL_QEPCON, reg);
 	pm_runtime_put(qep->dev);
-	ret = len;
 
 out:
 	mutex_unlock(&qep->lock);
 	return ret;
 }
 
-static ssize_t preset_enable_read(struct counter_device *counter,
-				  struct counter_count *count,
-				  void *priv, char *buf)
+static int intel_qep_preset_enable_read(struct counter_device *counter,
+					struct counter_count *count,
+					u8 *preset_enable)
 {
 	struct intel_qep *qep = counter->priv;
 	u32 reg;
@@ -353,21 +332,18 @@ static ssize_t preset_enable_read(struct counter_device *counter,
 	pm_runtime_get_sync(qep->dev);
 	reg = intel_qep_readl(qep, INTEL_QEPCON);
 	pm_runtime_put(qep->dev);
-	return sysfs_emit(buf, "%u\n", !(reg & INTEL_QEPCON_COUNT_RST_MODE));
+
+	*preset_enable = !(reg & INTEL_QEPCON_COUNT_RST_MODE);
+
+	return 0;
 }
 
-static ssize_t preset_enable_write(struct counter_device *counter,
-				   struct counter_count *count,
-				   void *priv, const char *buf, size_t len)
+static int intel_qep_preset_enable_write(struct counter_device *counter,
+					 struct counter_count *count, u8 val)
 {
 	struct intel_qep *qep = counter->priv;
 	u32 reg;
-	bool val;
-	int ret;
-
-	ret = kstrtobool(buf, &val);
-	if (ret)
-		return ret;
+	int ret = 0;
 
 	mutex_lock(&qep->lock);
 	if (qep->enabled) {
@@ -384,7 +360,6 @@ static ssize_t preset_enable_write(struct counter_device *counter,
 
 	intel_qep_writel(qep, INTEL_QEPCON, reg);
 	pm_runtime_put(qep->dev);
-	ret = len;
 
 out:
 	mutex_unlock(&qep->lock);
@@ -392,11 +367,14 @@ static ssize_t preset_enable_write(struct counter_device *counter,
 	return ret;
 }
 
-static const struct counter_count_ext intel_qep_count_ext[] = {
-	INTEL_QEP_COUNTER_EXT_RW(ceiling),
-	INTEL_QEP_COUNTER_EXT_RW(enable),
-	INTEL_QEP_COUNTER_EXT_RW(spike_filter_ns),
-	INTEL_QEP_COUNTER_EXT_RW(preset_enable)
+static struct counter_comp intel_qep_count_ext[] = {
+	COUNTER_COMP_ENABLE(intel_qep_enable_read, intel_qep_enable_write),
+	COUNTER_COMP_CEILING(intel_qep_ceiling_read, intel_qep_ceiling_write),
+	COUNTER_COMP_PRESET_ENABLE(intel_qep_preset_enable_read,
+				   intel_qep_preset_enable_write),
+	COUNTER_COMP_COUNT_U64("spike_filter_ns",
+			       intel_qep_spike_filter_ns_read,
+			       intel_qep_spike_filter_ns_write),
 };
 
 static struct counter_count intel_qep_counter_count[] = {
diff --git a/drivers/counter/interrupt-cnt.c b/drivers/counter/interrupt-cnt.c
index 1de4243db488c..8514a87fcbee0 100644
--- a/drivers/counter/interrupt-cnt.c
+++ b/drivers/counter/interrupt-cnt.c
@@ -10,6 +10,7 @@
 #include <linux/mod_devicetable.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
+#include <linux/types.h>
 
 #define INTERRUPT_CNT_NAME "interrupt-cnt"
 
@@ -33,30 +34,23 @@ static irqreturn_t interrupt_cnt_isr(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-static ssize_t interrupt_cnt_enable_read(struct counter_device *counter,
-					 struct counter_count *count,
-					 void *private, char *buf)
+static int interrupt_cnt_enable_read(struct counter_device *counter,
+				     struct counter_count *count, u8 *enable)
 {
 	struct interrupt_cnt_priv *priv = counter->priv;
 
-	return sysfs_emit(buf, "%d\n", priv->enabled);
+	*enable = priv->enabled;
+
+	return 0;
 }
 
-static ssize_t interrupt_cnt_enable_write(struct counter_device *counter,
-					  struct counter_count *count,
-					  void *private, const char *buf,
-					  size_t len)
+static int interrupt_cnt_enable_write(struct counter_device *counter,
+				      struct counter_count *count, u8 enable)
 {
 	struct interrupt_cnt_priv *priv = counter->priv;
-	bool enable;
-	ssize_t ret;
-
-	ret = kstrtobool(buf, &enable);
-	if (ret)
-		return ret;
 
 	if (priv->enabled == enable)
-		return len;
+		return 0;
 
 	if (enable) {
 		priv->enabled = true;
@@ -66,33 +60,30 @@ static ssize_t interrupt_cnt_enable_write(struct counter_device *counter,
 		priv->enabled = false;
 	}
 
-	return len;
+	return 0;
 }
 
-static const struct counter_count_ext interrupt_cnt_ext[] = {
-	{
-		.name = "enable",
-		.read = interrupt_cnt_enable_read,
-		.write = interrupt_cnt_enable_write,
-	},
+static struct counter_comp interrupt_cnt_ext[] = {
+	COUNTER_COMP_ENABLE(interrupt_cnt_enable_read,
+			    interrupt_cnt_enable_write),
 };
 
 static const enum counter_synapse_action interrupt_cnt_synapse_actions[] = {
 	COUNTER_SYNAPSE_ACTION_RISING_EDGE,
 };
 
-static int interrupt_cnt_action_get(struct counter_device *counter,
-				    struct counter_count *count,
-				    struct counter_synapse *synapse,
-				    size_t *action)
+static int interrupt_cnt_action_read(struct counter_device *counter,
+				     struct counter_count *count,
+				     struct counter_synapse *synapse,
+				     enum counter_synapse_action *action)
 {
-	*action = 0;
+	*action = COUNTER_SYNAPSE_ACTION_RISING_EDGE;
 
 	return 0;
 }
 
 static int interrupt_cnt_read(struct counter_device *counter,
-			      struct counter_count *count, unsigned long *val)
+			      struct counter_count *count, u64 *val)
 {
 	struct interrupt_cnt_priv *priv = counter->priv;
 
@@ -102,8 +93,7 @@ static int interrupt_cnt_read(struct counter_device *counter,
 }
 
 static int interrupt_cnt_write(struct counter_device *counter,
-			       struct counter_count *count,
-			       const unsigned long val)
+			       struct counter_count *count, const u64 val)
 {
 	struct interrupt_cnt_priv *priv = counter->priv;
 
@@ -119,11 +109,11 @@ static const enum counter_function interrupt_cnt_functions[] = {
 	COUNTER_FUNCTION_INCREASE,
 };
 
-static int interrupt_cnt_function_get(struct counter_device *counter,
-				      struct counter_count *count,
-				      size_t *function)
+static int interrupt_cnt_function_read(struct counter_device *counter,
+				       struct counter_count *count,
+				       enum counter_function *function)
 {
-	*function = 0;
+	*function = COUNTER_FUNCTION_INCREASE;
 
 	return 0;
 }
@@ -148,10 +138,10 @@ static int interrupt_cnt_signal_read(struct counter_device *counter,
 }
 
 static const struct counter_ops interrupt_cnt_ops = {
-	.action_get = interrupt_cnt_action_get,
+	.action_read = interrupt_cnt_action_read,
 	.count_read = interrupt_cnt_read,
 	.count_write = interrupt_cnt_write,
-	.function_get = interrupt_cnt_function_get,
+	.function_read = interrupt_cnt_function_read,
 	.signal_read  = interrupt_cnt_signal_read,
 };
 
diff --git a/drivers/counter/microchip-tcb-capture.c b/drivers/counter/microchip-tcb-capture.c
index 22563dcded751..4edfe1f8fff7a 100644
--- a/drivers/counter/microchip-tcb-capture.c
+++ b/drivers/counter/microchip-tcb-capture.c
@@ -31,28 +31,16 @@ struct mchp_tc_data {
 	int channel[2];
 };
 
-enum mchp_tc_count_function {
-	MCHP_TC_FUNCTION_INCREASE,
-	MCHP_TC_FUNCTION_QUADRATURE,
-};
-
 static const enum counter_function mchp_tc_count_functions[] = {
-	[MCHP_TC_FUNCTION_INCREASE] = COUNTER_FUNCTION_INCREASE,
-	[MCHP_TC_FUNCTION_QUADRATURE] = COUNTER_FUNCTION_QUADRATURE_X4,
-};
-
-enum mchp_tc_synapse_action {
-	MCHP_TC_SYNAPSE_ACTION_NONE = 0,
-	MCHP_TC_SYNAPSE_ACTION_RISING_EDGE,
-	MCHP_TC_SYNAPSE_ACTION_FALLING_EDGE,
-	MCHP_TC_SYNAPSE_ACTION_BOTH_EDGE
+	COUNTER_FUNCTION_INCREASE,
+	COUNTER_FUNCTION_QUADRATURE_X4,
 };
 
 static const enum counter_synapse_action mchp_tc_synapse_actions[] = {
-	[MCHP_TC_SYNAPSE_ACTION_NONE] = COUNTER_SYNAPSE_ACTION_NONE,
-	[MCHP_TC_SYNAPSE_ACTION_RISING_EDGE] = COUNTER_SYNAPSE_ACTION_RISING_EDGE,
-	[MCHP_TC_SYNAPSE_ACTION_FALLING_EDGE] = COUNTER_SYNAPSE_ACTION_FALLING_EDGE,
-	[MCHP_TC_SYNAPSE_ACTION_BOTH_EDGE] = COUNTER_SYNAPSE_ACTION_BOTH_EDGES,
+	COUNTER_SYNAPSE_ACTION_NONE,
+	COUNTER_SYNAPSE_ACTION_RISING_EDGE,
+	COUNTER_SYNAPSE_ACTION_FALLING_EDGE,
+	COUNTER_SYNAPSE_ACTION_BOTH_EDGES,
 };
 
 static struct counter_signal mchp_tc_count_signals[] = {
@@ -79,23 +67,23 @@ static struct counter_synapse mchp_tc_count_synapses[] = {
 	}
 };
 
-static int mchp_tc_count_function_get(struct counter_device *counter,
-				      struct counter_count *count,
-				      size_t *function)
+static int mchp_tc_count_function_read(struct counter_device *counter,
+				       struct counter_count *count,
+				       enum counter_function *function)
 {
 	struct mchp_tc_data *const priv = counter->priv;
 
 	if (priv->qdec_mode)
-		*function = MCHP_TC_FUNCTION_QUADRATURE;
+		*function = COUNTER_FUNCTION_QUADRATURE_X4;
 	else
-		*function = MCHP_TC_FUNCTION_INCREASE;
+		*function = COUNTER_FUNCTION_INCREASE;
 
 	return 0;
 }
 
-static int mchp_tc_count_function_set(struct counter_device *counter,
-				      struct counter_count *count,
-				      size_t function)
+static int mchp_tc_count_function_write(struct counter_device *counter,
+					struct counter_count *count,
+					enum counter_function function)
 {
 	struct mchp_tc_data *const priv = counter->priv;
 	u32 bmr, cmr;
@@ -107,7 +95,7 @@ static int mchp_tc_count_function_set(struct counter_device *counter,
 	cmr &= ~ATMEL_TC_WAVE;
 
 	switch (function) {
-	case MCHP_TC_FUNCTION_INCREASE:
+	case COUNTER_FUNCTION_INCREASE:
 		priv->qdec_mode = 0;
 		/* Set highest rate based on whether soc has gclk or not */
 		bmr &= ~(ATMEL_TC_QDEN | ATMEL_TC_POSEN);
@@ -119,7 +107,7 @@ static int mchp_tc_count_function_set(struct counter_device *counter,
 		cmr |=  ATMEL_TC_CMR_MASK;
 		cmr &= ~(ATMEL_TC_ABETRG | ATMEL_TC_XC0);
 		break;
-	case MCHP_TC_FUNCTION_QUADRATURE:
+	case COUNTER_FUNCTION_QUADRATURE_X4:
 		if (!priv->tc_cfg->has_qdec)
 			return -EINVAL;
 		/* In QDEC mode settings both channels 0 and 1 are required */
@@ -175,10 +163,10 @@ static int mchp_tc_count_signal_read(struct counter_device *counter,
 	return 0;
 }
 
-static int mchp_tc_count_action_get(struct counter_device *counter,
-				    struct counter_count *count,
-				    struct counter_synapse *synapse,
-				    size_t *action)
+static int mchp_tc_count_action_read(struct counter_device *counter,
+				     struct counter_count *count,
+				     struct counter_synapse *synapse,
+				     enum counter_synapse_action *action)
 {
 	struct mchp_tc_data *const priv = counter->priv;
 	u32 cmr;
@@ -198,26 +186,26 @@ static int mchp_tc_count_action_get(struct counter_device *counter,
 
 	switch (cmr & ATMEL_TC_ETRGEDG) {
 	default:
-		*action = MCHP_TC_SYNAPSE_ACTION_NONE;
+		*action = COUNTER_SYNAPSE_ACTION_NONE;
 		break;
 	case ATMEL_TC_ETRGEDG_RISING:
-		*action = MCHP_TC_SYNAPSE_ACTION_RISING_EDGE;
+		*action = COUNTER_SYNAPSE_ACTION_RISING_EDGE;
 		break;
 	case ATMEL_TC_ETRGEDG_FALLING:
-		*action = MCHP_TC_SYNAPSE_ACTION_FALLING_EDGE;
+		*action = COUNTER_SYNAPSE_ACTION_FALLING_EDGE;
 		break;
 	case ATMEL_TC_ETRGEDG_BOTH:
-		*action = MCHP_TC_SYNAPSE_ACTION_BOTH_EDGE;
+		*action = COUNTER_SYNAPSE_ACTION_BOTH_EDGES;
 		break;
 	}
 
 	return 0;
 }
 
-static int mchp_tc_count_action_set(struct counter_device *counter,
-				    struct counter_count *count,
-				    struct counter_synapse *synapse,
-				    size_t action)
+static int mchp_tc_count_action_write(struct counter_device *counter,
+				      struct counter_count *count,
+				      struct counter_synapse *synapse,
+				      enum counter_synapse_action action)
 {
 	struct mchp_tc_data *const priv = counter->priv;
 	u32 edge = ATMEL_TC_ETRGEDG_NONE;
@@ -227,16 +215,16 @@ static int mchp_tc_count_action_set(struct counter_device *counter,
 		return -EINVAL;
 
 	switch (action) {
-	case MCHP_TC_SYNAPSE_ACTION_NONE:
+	case COUNTER_SYNAPSE_ACTION_NONE:
 		edge = ATMEL_TC_ETRGEDG_NONE;
 		break;
-	case MCHP_TC_SYNAPSE_ACTION_RISING_EDGE:
+	case COUNTER_SYNAPSE_ACTION_RISING_EDGE:
 		edge = ATMEL_TC_ETRGEDG_RISING;
 		break;
-	case MCHP_TC_SYNAPSE_ACTION_FALLING_EDGE:
+	case COUNTER_SYNAPSE_ACTION_FALLING_EDGE:
 		edge = ATMEL_TC_ETRGEDG_FALLING;
 		break;
-	case MCHP_TC_SYNAPSE_ACTION_BOTH_EDGE:
+	case COUNTER_SYNAPSE_ACTION_BOTH_EDGES:
 		edge = ATMEL_TC_ETRGEDG_BOTH;
 		break;
 	default:
@@ -250,8 +238,7 @@ static int mchp_tc_count_action_set(struct counter_device *counter,
 }
 
 static int mchp_tc_count_read(struct counter_device *counter,
-			      struct counter_count *count,
-			      unsigned long *val)
+			      struct counter_count *count, u64 *val)
 {
 	struct mchp_tc_data *const priv = counter->priv;
 	u32 cnt;
@@ -274,12 +261,12 @@ static struct counter_count mchp_tc_counts[] = {
 };
 
 static const struct counter_ops mchp_tc_ops = {
-	.signal_read  = mchp_tc_count_signal_read,
-	.count_read   = mchp_tc_count_read,
-	.function_get = mchp_tc_count_function_get,
-	.function_set = mchp_tc_count_function_set,
-	.action_get   = mchp_tc_count_action_get,
-	.action_set   = mchp_tc_count_action_set
+	.signal_read    = mchp_tc_count_signal_read,
+	.count_read     = mchp_tc_count_read,
+	.function_read  = mchp_tc_count_function_read,
+	.function_write = mchp_tc_count_function_write,
+	.action_read    = mchp_tc_count_action_read,
+	.action_write   = mchp_tc_count_action_write
 };
 
 static const struct atmel_tcb_config tcb_rm9200_config = {
diff --git a/drivers/counter/stm32-lptimer-cnt.c b/drivers/counter/stm32-lptimer-cnt.c
index a56fbe598e119..637b3f0b4fa34 100644
--- a/drivers/counter/stm32-lptimer-cnt.c
+++ b/drivers/counter/stm32-lptimer-cnt.c
@@ -17,6 +17,7 @@
 #include <linux/module.h>
 #include <linux/pinctrl/consumer.h>
 #include <linux/platform_device.h>
+#include <linux/types.h>
 
 struct stm32_lptim_cnt {
 	struct counter_device counter;
@@ -107,11 +108,7 @@ static int stm32_lptim_setup(struct stm32_lptim_cnt *priv, int enable)
 	return regmap_update_bits(priv->regmap, STM32_LPTIM_CFGR, mask, val);
 }
 
-/**
- * enum stm32_lptim_cnt_function - enumerates LPTimer counter & encoder modes
- * @STM32_LPTIM_COUNTER_INCREASE: up count on IN1 rising, falling or both edges
- * @STM32_LPTIM_ENCODER_BOTH_EDGE: count on both edges (IN1 & IN2 quadrature)
- *
+/*
  * In non-quadrature mode, device counts up on active edge.
  * In quadrature mode, encoder counting scenarios are as follows:
  * +---------+----------+--------------------+--------------------+
@@ -129,33 +126,20 @@ static int stm32_lptim_setup(struct stm32_lptim_cnt *priv, int enable)
  * | edges   | Low  ->  |   Up     |   Down  |   Down   |   Up    |
  * +---------+----------+----------+---------+----------+---------+
  */
-enum stm32_lptim_cnt_function {
-	STM32_LPTIM_COUNTER_INCREASE,
-	STM32_LPTIM_ENCODER_BOTH_EDGE,
-};
-
 static const enum counter_function stm32_lptim_cnt_functions[] = {
-	[STM32_LPTIM_COUNTER_INCREASE] = COUNTER_FUNCTION_INCREASE,
-	[STM32_LPTIM_ENCODER_BOTH_EDGE] = COUNTER_FUNCTION_QUADRATURE_X4,
-};
-
-enum stm32_lptim_synapse_action {
-	STM32_LPTIM_SYNAPSE_ACTION_RISING_EDGE = STM32_LPTIM_CKPOL_RISING_EDGE,
-	STM32_LPTIM_SYNAPSE_ACTION_FALLING_EDGE = STM32_LPTIM_CKPOL_FALLING_EDGE,
-	STM32_LPTIM_SYNAPSE_ACTION_BOTH_EDGES = STM32_LPTIM_CKPOL_BOTH_EDGES,
-	STM32_LPTIM_SYNAPSE_ACTION_NONE,
+	COUNTER_FUNCTION_INCREASE,
+	COUNTER_FUNCTION_QUADRATURE_X4,
 };
 
 static const enum counter_synapse_action stm32_lptim_cnt_synapse_actions[] = {
-	/* Index must match with stm32_lptim_cnt_polarity[] (priv->polarity) */
-	[STM32_LPTIM_SYNAPSE_ACTION_RISING_EDGE] = COUNTER_SYNAPSE_ACTION_RISING_EDGE,
-	[STM32_LPTIM_SYNAPSE_ACTION_FALLING_EDGE] = COUNTER_SYNAPSE_ACTION_FALLING_EDGE,
-	[STM32_LPTIM_SYNAPSE_ACTION_BOTH_EDGES] = COUNTER_SYNAPSE_ACTION_BOTH_EDGES,
-	[STM32_LPTIM_SYNAPSE_ACTION_NONE] = COUNTER_SYNAPSE_ACTION_NONE,
+	COUNTER_SYNAPSE_ACTION_RISING_EDGE,
+	COUNTER_SYNAPSE_ACTION_FALLING_EDGE,
+	COUNTER_SYNAPSE_ACTION_BOTH_EDGES,
+	COUNTER_SYNAPSE_ACTION_NONE,
 };
 
 static int stm32_lptim_cnt_read(struct counter_device *counter,
-				struct counter_count *count, unsigned long *val)
+				struct counter_count *count, u64 *val)
 {
 	struct stm32_lptim_cnt *const priv = counter->priv;
 	u32 cnt;
@@ -170,28 +154,28 @@ static int stm32_lptim_cnt_read(struct counter_device *counter,
 	return 0;
 }
 
-static int stm32_lptim_cnt_function_get(struct counter_device *counter,
-					struct counter_count *count,
-					size_t *function)
+static int stm32_lptim_cnt_function_read(struct counter_device *counter,
+					 struct counter_count *count,
+					 enum counter_function *function)
 {
 	struct stm32_lptim_cnt *const priv = counter->priv;
 
 	if (!priv->quadrature_mode) {
-		*function = STM32_LPTIM_COUNTER_INCREASE;
+		*function = COUNTER_FUNCTION_INCREASE;
 		return 0;
 	}
 
-	if (priv->polarity == STM32_LPTIM_SYNAPSE_ACTION_BOTH_EDGES) {
-		*function = STM32_LPTIM_ENCODER_BOTH_EDGE;
+	if (priv->polarity == STM32_LPTIM_CKPOL_BOTH_EDGES) {
+		*function = COUNTER_FUNCTION_QUADRATURE_X4;
 		return 0;
 	}
 
 	return -EINVAL;
 }
 
-static int stm32_lptim_cnt_function_set(struct counter_device *counter,
-					struct counter_count *count,
-					size_t function)
+static int stm32_lptim_cnt_function_write(struct counter_device *counter,
+					  struct counter_count *count,
+					  enum counter_function function)
 {
 	struct stm32_lptim_cnt *const priv = counter->priv;
 
@@ -199,12 +183,12 @@ static int stm32_lptim_cnt_function_set(struct counter_device *counter,
 		return -EBUSY;
 
 	switch (function) {
-	case STM32_LPTIM_COUNTER_INCREASE:
+	case COUNTER_FUNCTION_INCREASE:
 		priv->quadrature_mode = 0;
 		return 0;
-	case STM32_LPTIM_ENCODER_BOTH_EDGE:
+	case COUNTER_FUNCTION_QUADRATURE_X4:
 		priv->quadrature_mode = 1;
-		priv->polarity = STM32_LPTIM_SYNAPSE_ACTION_BOTH_EDGES;
+		priv->polarity = STM32_LPTIM_CKPOL_BOTH_EDGES;
 		return 0;
 	default:
 		/* should never reach this path */
@@ -212,9 +196,9 @@ static int stm32_lptim_cnt_function_set(struct counter_device *counter,
 	}
 }
 
-static ssize_t stm32_lptim_cnt_enable_read(struct counter_device *counter,
-					   struct counter_count *count,
-					   void *private, char *buf)
+static int stm32_lptim_cnt_enable_read(struct counter_device *counter,
+				       struct counter_count *count,
+				       u8 *enable)
 {
 	struct stm32_lptim_cnt *const priv = counter->priv;
 	int ret;
@@ -223,22 +207,18 @@ static ssize_t stm32_lptim_cnt_enable_read(struct counter_device *counter,
 	if (ret < 0)
 		return ret;
 
-	return scnprintf(buf, PAGE_SIZE, "%u\n", ret);
+	*enable = ret;
+
+	return 0;
 }
 
-static ssize_t stm32_lptim_cnt_enable_write(struct counter_device *counter,
-					    struct counter_count *count,
-					    void *private,
-					    const char *buf, size_t len)
+static int stm32_lptim_cnt_enable_write(struct counter_device *counter,
+					struct counter_count *count,
+					u8 enable)
 {
 	struct stm32_lptim_cnt *const priv = counter->priv;
-	bool enable;
 	int ret;
 
-	ret = kstrtobool(buf, &enable);
-	if (ret)
-		return ret;
-
 	/* Check nobody uses the timer, or already disabled/enabled */
 	ret = stm32_lptim_is_enabled(priv);
 	if ((ret < 0) || (!ret && !enable))
@@ -254,78 +234,81 @@ static ssize_t stm32_lptim_cnt_enable_write(struct counter_device *counter,
 	if (ret)
 		return ret;
 
-	return len;
+	return 0;
 }
 
-static ssize_t stm32_lptim_cnt_ceiling_read(struct counter_device *counter,
-					    struct counter_count *count,
-					    void *private, char *buf)
+static int stm32_lptim_cnt_ceiling_read(struct counter_device *counter,
+					struct counter_count *count,
+					u64 *ceiling)
 {
 	struct stm32_lptim_cnt *const priv = counter->priv;
 
-	return snprintf(buf, PAGE_SIZE, "%u\n", priv->ceiling);
+	*ceiling = priv->ceiling;
+
+	return 0;
 }
 
-static ssize_t stm32_lptim_cnt_ceiling_write(struct counter_device *counter,
-					     struct counter_count *count,
-					     void *private,
-					     const char *buf, size_t len)
+static int stm32_lptim_cnt_ceiling_write(struct counter_device *counter,
+					 struct counter_count *count,
+					 u64 ceiling)
 {
 	struct stm32_lptim_cnt *const priv = counter->priv;
-	unsigned int ceiling;
-	int ret;
 
 	if (stm32_lptim_is_enabled(priv))
 		return -EBUSY;
 
-	ret = kstrtouint(buf, 0, &ceiling);
-	if (ret)
-		return ret;
-
 	if (ceiling > STM32_LPTIM_MAX_ARR)
 		return -ERANGE;
 
 	priv->ceiling = ceiling;
 
-	return len;
+	return 0;
 }
 
-static const struct counter_count_ext stm32_lptim_cnt_ext[] = {
-	{
-		.name = "enable",
-		.read = stm32_lptim_cnt_enable_read,
-		.write = stm32_lptim_cnt_enable_write
-	},
-	{
-		.name = "ceiling",
-		.read = stm32_lptim_cnt_ceiling_read,
-		.write = stm32_lptim_cnt_ceiling_write
-	},
+static struct counter_comp stm32_lptim_cnt_ext[] = {
+	COUNTER_COMP_ENABLE(stm32_lptim_cnt_enable_read,
+			    stm32_lptim_cnt_enable_write),
+	COUNTER_COMP_CEILING(stm32_lptim_cnt_ceiling_read,
+			     stm32_lptim_cnt_ceiling_write),
 };
 
-static int stm32_lptim_cnt_action_get(struct counter_device *counter,
-				      struct counter_count *count,
-				      struct counter_synapse *synapse,
-				      size_t *action)
+static int stm32_lptim_cnt_action_read(struct counter_device *counter,
+				       struct counter_count *count,
+				       struct counter_synapse *synapse,
+				       enum counter_synapse_action *action)
 {
 	struct stm32_lptim_cnt *const priv = counter->priv;
-	size_t function;
+	enum counter_function function;
 	int err;
 
-	err = stm32_lptim_cnt_function_get(counter, count, &function);
+	err = stm32_lptim_cnt_function_read(counter, count, &function);
 	if (err)
 		return err;
 
 	switch (function) {
-	case STM32_LPTIM_COUNTER_INCREASE:
+	case COUNTER_FUNCTION_INCREASE:
 		/* LP Timer acts as up-counter on input 1 */
-		if (synapse->signal->id == count->synapses[0].signal->id)
-			*action = priv->polarity;
-		else
-			*action = STM32_LPTIM_SYNAPSE_ACTION_NONE;
-		return 0;
-	case STM32_LPTIM_ENCODER_BOTH_EDGE:
-		*action = priv->polarity;
+		if (synapse->signal->id != count->synapses[0].signal->id) {
+			*action = COUNTER_SYNAPSE_ACTION_NONE;
+			return 0;
+		}
+
+		switch (priv->polarity) {
+		case STM32_LPTIM_CKPOL_RISING_EDGE:
+			*action = COUNTER_SYNAPSE_ACTION_RISING_EDGE;
+			return 0;
+		case STM32_LPTIM_CKPOL_FALLING_EDGE:
+			*action = COUNTER_SYNAPSE_ACTION_FALLING_EDGE;
+			return 0;
+		case STM32_LPTIM_CKPOL_BOTH_EDGES:
+			*action = COUNTER_SYNAPSE_ACTION_BOTH_EDGES;
+			return 0;
+		default:
+			/* should never reach this path */
+			return -EINVAL;
+		}
+	case COUNTER_FUNCTION_QUADRATURE_X4:
+		*action = COUNTER_SYNAPSE_ACTION_BOTH_EDGES;
 		return 0;
 	default:
 		/* should never reach this path */
@@ -333,43 +316,48 @@ static int stm32_lptim_cnt_action_get(struct counter_device *counter,
 	}
 }
 
-static int stm32_lptim_cnt_action_set(struct counter_device *counter,
-				      struct counter_count *count,
-				      struct counter_synapse *synapse,
-				      size_t action)
+static int stm32_lptim_cnt_action_write(struct counter_device *counter,
+					struct counter_count *count,
+					struct counter_synapse *synapse,
+					enum counter_synapse_action action)
 {
 	struct stm32_lptim_cnt *const priv = counter->priv;
-	size_t function;
+	enum counter_function function;
 	int err;
 
 	if (stm32_lptim_is_enabled(priv))
 		return -EBUSY;
 
-	err = stm32_lptim_cnt_function_get(counter, count, &function);
+	err = stm32_lptim_cnt_function_read(counter, count, &function);
 	if (err)
 		return err;
 
 	/* only set polarity when in counter mode (on input 1) */
-	if (function == STM32_LPTIM_COUNTER_INCREASE
-	    && synapse->signal->id == count->synapses[0].signal->id) {
-		switch (action) {
-		case STM32_LPTIM_SYNAPSE_ACTION_RISING_EDGE:
-		case STM32_LPTIM_SYNAPSE_ACTION_FALLING_EDGE:
-		case STM32_LPTIM_SYNAPSE_ACTION_BOTH_EDGES:
-			priv->polarity = action;
-			return 0;
-		}
-	}
+	if (function != COUNTER_FUNCTION_INCREASE
+	    || synapse->signal->id != count->synapses[0].signal->id)
+		return -EINVAL;
 
-	return -EINVAL;
+	switch (action) {
+	case COUNTER_SYNAPSE_ACTION_RISING_EDGE:
+		priv->polarity = STM32_LPTIM_CKPOL_RISING_EDGE;
+		return 0;
+	case COUNTER_SYNAPSE_ACTION_FALLING_EDGE:
+		priv->polarity = STM32_LPTIM_CKPOL_FALLING_EDGE;
+		return 0;
+	case COUNTER_SYNAPSE_ACTION_BOTH_EDGES:
+		priv->polarity = STM32_LPTIM_CKPOL_BOTH_EDGES;
+		return 0;
+	default:
+		return -EINVAL;
+	}
 }
 
 static const struct counter_ops stm32_lptim_cnt_ops = {
 	.count_read = stm32_lptim_cnt_read,
-	.function_get = stm32_lptim_cnt_function_get,
-	.function_set = stm32_lptim_cnt_function_set,
-	.action_get = stm32_lptim_cnt_action_get,
-	.action_set = stm32_lptim_cnt_action_set,
+	.function_read = stm32_lptim_cnt_function_read,
+	.function_write = stm32_lptim_cnt_function_write,
+	.action_read = stm32_lptim_cnt_action_read,
+	.action_write = stm32_lptim_cnt_action_write,
 };
 
 static struct counter_signal stm32_lptim_cnt_signals[] = {
diff --git a/drivers/counter/stm32-timer-cnt.c b/drivers/counter/stm32-timer-cnt.c
index 1fbc46f4ee66e..0546e932db0c1 100644
--- a/drivers/counter/stm32-timer-cnt.c
+++ b/drivers/counter/stm32-timer-cnt.c
@@ -13,6 +13,7 @@
 #include <linux/module.h>
 #include <linux/pinctrl/consumer.h>
 #include <linux/platform_device.h>
+#include <linux/types.h>
 
 #define TIM_CCMR_CCXS	(BIT(8) | BIT(0))
 #define TIM_CCMR_MASK	(TIM_CCMR_CC1S | TIM_CCMR_CC2S | \
@@ -36,29 +37,15 @@ struct stm32_timer_cnt {
 	struct stm32_timer_regs bak;
 };
 
-/**
- * enum stm32_count_function - enumerates stm32 timer counter encoder modes
- * @STM32_COUNT_SLAVE_MODE_DISABLED: counts on internal clock when CEN=1
- * @STM32_COUNT_ENCODER_MODE_1: counts TI1FP1 edges, depending on TI2FP2 level
- * @STM32_COUNT_ENCODER_MODE_2: counts TI2FP2 edges, depending on TI1FP1 level
- * @STM32_COUNT_ENCODER_MODE_3: counts on both TI1FP1 and TI2FP2 edges
- */
-enum stm32_count_function {
-	STM32_COUNT_SLAVE_MODE_DISABLED,
-	STM32_COUNT_ENCODER_MODE_1,
-	STM32_COUNT_ENCODER_MODE_2,
-	STM32_COUNT_ENCODER_MODE_3,
-};
-
 static const enum counter_function stm32_count_functions[] = {
-	[STM32_COUNT_SLAVE_MODE_DISABLED] = COUNTER_FUNCTION_INCREASE,
-	[STM32_COUNT_ENCODER_MODE_1] = COUNTER_FUNCTION_QUADRATURE_X2_A,
-	[STM32_COUNT_ENCODER_MODE_2] = COUNTER_FUNCTION_QUADRATURE_X2_B,
-	[STM32_COUNT_ENCODER_MODE_3] = COUNTER_FUNCTION_QUADRATURE_X4,
+	COUNTER_FUNCTION_INCREASE,
+	COUNTER_FUNCTION_QUADRATURE_X2_A,
+	COUNTER_FUNCTION_QUADRATURE_X2_B,
+	COUNTER_FUNCTION_QUADRATURE_X4,
 };
 
 static int stm32_count_read(struct counter_device *counter,
-			    struct counter_count *count, unsigned long *val)
+			    struct counter_count *count, u64 *val)
 {
 	struct stm32_timer_cnt *const priv = counter->priv;
 	u32 cnt;
@@ -70,8 +57,7 @@ static int stm32_count_read(struct counter_device *counter,
 }
 
 static int stm32_count_write(struct counter_device *counter,
-			     struct counter_count *count,
-			     const unsigned long val)
+			     struct counter_count *count, const u64 val)
 {
 	struct stm32_timer_cnt *const priv = counter->priv;
 	u32 ceiling;
@@ -83,9 +69,9 @@ static int stm32_count_write(struct counter_device *counter,
 	return regmap_write(priv->regmap, TIM_CNT, val);
 }
 
-static int stm32_count_function_get(struct counter_device *counter,
-				    struct counter_count *count,
-				    size_t *function)
+static int stm32_count_function_read(struct counter_device *counter,
+				     struct counter_count *count,
+				     enum counter_function *function)
 {
 	struct stm32_timer_cnt *const priv = counter->priv;
 	u32 smcr;
@@ -94,40 +80,40 @@ static int stm32_count_function_get(struct counter_device *counter,
 
 	switch (smcr & TIM_SMCR_SMS) {
 	case TIM_SMCR_SMS_SLAVE_MODE_DISABLED:
-		*function = STM32_COUNT_SLAVE_MODE_DISABLED;
+		*function = COUNTER_FUNCTION_INCREASE;
 		return 0;
 	case TIM_SMCR_SMS_ENCODER_MODE_1:
-		*function = STM32_COUNT_ENCODER_MODE_1;
+		*function = COUNTER_FUNCTION_QUADRATURE_X2_A;
 		return 0;
 	case TIM_SMCR_SMS_ENCODER_MODE_2:
-		*function = STM32_COUNT_ENCODER_MODE_2;
+		*function = COUNTER_FUNCTION_QUADRATURE_X2_B;
 		return 0;
 	case TIM_SMCR_SMS_ENCODER_MODE_3:
-		*function = STM32_COUNT_ENCODER_MODE_3;
+		*function = COUNTER_FUNCTION_QUADRATURE_X4;
 		return 0;
 	default:
 		return -EINVAL;
 	}
 }
 
-static int stm32_count_function_set(struct counter_device *counter,
-				    struct counter_count *count,
-				    size_t function)
+static int stm32_count_function_write(struct counter_device *counter,
+				      struct counter_count *count,
+				      enum counter_function function)
 {
 	struct stm32_timer_cnt *const priv = counter->priv;
 	u32 cr1, sms;
 
 	switch (function) {
-	case STM32_COUNT_SLAVE_MODE_DISABLED:
+	case COUNTER_FUNCTION_INCREASE:
 		sms = TIM_SMCR_SMS_SLAVE_MODE_DISABLED;
 		break;
-	case STM32_COUNT_ENCODER_MODE_1:
+	case COUNTER_FUNCTION_QUADRATURE_X2_A:
 		sms = TIM_SMCR_SMS_ENCODER_MODE_1;
 		break;
-	case STM32_COUNT_ENCODER_MODE_2:
+	case COUNTER_FUNCTION_QUADRATURE_X2_B:
 		sms = TIM_SMCR_SMS_ENCODER_MODE_2;
 		break;
-	case STM32_COUNT_ENCODER_MODE_3:
+	case COUNTER_FUNCTION_QUADRATURE_X4:
 		sms = TIM_SMCR_SMS_ENCODER_MODE_3;
 		break;
 	default:
@@ -150,44 +136,37 @@ static int stm32_count_function_set(struct counter_device *counter,
 	return 0;
 }
 
-static ssize_t stm32_count_direction_read(struct counter_device *counter,
+static int stm32_count_direction_read(struct counter_device *counter,
 				      struct counter_count *count,
-				      void *private, char *buf)
+				      enum counter_count_direction *direction)
 {
 	struct stm32_timer_cnt *const priv = counter->priv;
-	const char *direction;
 	u32 cr1;
 
 	regmap_read(priv->regmap, TIM_CR1, &cr1);
-	direction = (cr1 & TIM_CR1_DIR) ? "backward" : "forward";
+	*direction = (cr1 & TIM_CR1_DIR) ? COUNTER_COUNT_DIRECTION_BACKWARD :
+		COUNTER_COUNT_DIRECTION_FORWARD;
 
-	return scnprintf(buf, PAGE_SIZE, "%s\n", direction);
+	return 0;
 }
 
-static ssize_t stm32_count_ceiling_read(struct counter_device *counter,
-					struct counter_count *count,
-					void *private, char *buf)
+static int stm32_count_ceiling_read(struct counter_device *counter,
+				    struct counter_count *count, u64 *ceiling)
 {
 	struct stm32_timer_cnt *const priv = counter->priv;
 	u32 arr;
 
 	regmap_read(priv->regmap, TIM_ARR, &arr);
 
-	return snprintf(buf, PAGE_SIZE, "%u\n", arr);
+	*ceiling = arr;
+
+	return 0;
 }
 
-static ssize_t stm32_count_ceiling_write(struct counter_device *counter,
-					 struct counter_count *count,
-					 void *private,
-					 const char *buf, size_t len)
+static int stm32_count_ceiling_write(struct counter_device *counter,
+				     struct counter_count *count, u64 ceiling)
 {
 	struct stm32_timer_cnt *const priv = counter->priv;
-	unsigned int ceiling;
-	int ret;
-
-	ret = kstrtouint(buf, 0, &ceiling);
-	if (ret)
-		return ret;
 
 	if (ceiling > priv->max_arr)
 		return -ERANGE;
@@ -196,34 +175,27 @@ static ssize_t stm32_count_ceiling_write(struct counter_device *counter,
 	regmap_update_bits(priv->regmap, TIM_CR1, TIM_CR1_ARPE, 0);
 	regmap_write(priv->regmap, TIM_ARR, ceiling);
 
-	return len;
+	return 0;
 }
 
-static ssize_t stm32_count_enable_read(struct counter_device *counter,
-				       struct counter_count *count,
-				       void *private, char *buf)
+static int stm32_count_enable_read(struct counter_device *counter,
+				   struct counter_count *count, u8 *enable)
 {
 	struct stm32_timer_cnt *const priv = counter->priv;
 	u32 cr1;
 
 	regmap_read(priv->regmap, TIM_CR1, &cr1);
 
-	return scnprintf(buf, PAGE_SIZE, "%d\n", (bool)(cr1 & TIM_CR1_CEN));
+	*enable = cr1 & TIM_CR1_CEN;
+
+	return 0;
 }
 
-static ssize_t stm32_count_enable_write(struct counter_device *counter,
-					struct counter_count *count,
-					void *private,
-					const char *buf, size_t len)
+static int stm32_count_enable_write(struct counter_device *counter,
+				    struct counter_count *count, u8 enable)
 {
 	struct stm32_timer_cnt *const priv = counter->priv;
-	int err;
 	u32 cr1;
-	bool enable;
-
-	err = kstrtobool(buf, &enable);
-	if (err)
-		return err;
 
 	if (enable) {
 		regmap_read(priv->regmap, TIM_CR1, &cr1);
@@ -242,70 +214,55 @@ static ssize_t stm32_count_enable_write(struct counter_device *counter,
 	/* Keep enabled state to properly handle low power states */
 	priv->enabled = enable;
 
-	return len;
+	return 0;
 }
 
-static const struct counter_count_ext stm32_count_ext[] = {
-	{
-		.name = "direction",
-		.read = stm32_count_direction_read,
-	},
-	{
-		.name = "enable",
-		.read = stm32_count_enable_read,
-		.write = stm32_count_enable_write
-	},
-	{
-		.name = "ceiling",
-		.read = stm32_count_ceiling_read,
-		.write = stm32_count_ceiling_write
-	},
-};
-
-enum stm32_synapse_action {
-	STM32_SYNAPSE_ACTION_NONE,
-	STM32_SYNAPSE_ACTION_BOTH_EDGES
+static struct counter_comp stm32_count_ext[] = {
+	COUNTER_COMP_DIRECTION(stm32_count_direction_read),
+	COUNTER_COMP_ENABLE(stm32_count_enable_read, stm32_count_enable_write),
+	COUNTER_COMP_CEILING(stm32_count_ceiling_read,
+			     stm32_count_ceiling_write),
 };
 
 static const enum counter_synapse_action stm32_synapse_actions[] = {
-	[STM32_SYNAPSE_ACTION_NONE] = COUNTER_SYNAPSE_ACTION_NONE,
-	[STM32_SYNAPSE_ACTION_BOTH_EDGES] = COUNTER_SYNAPSE_ACTION_BOTH_EDGES
+	COUNTER_SYNAPSE_ACTION_NONE,
+	COUNTER_SYNAPSE_ACTION_BOTH_EDGES
 };
 
-static int stm32_action_get(struct counter_device *counter,
-			    struct counter_count *count,
-			    struct counter_synapse *synapse,
-			    size_t *action)
+static int stm32_action_read(struct counter_device *counter,
+			     struct counter_count *count,
+			     struct counter_synapse *synapse,
+			     enum counter_synapse_action *action)
 {
-	size_t function;
+	enum counter_function function;
 	int err;
 
-	err = stm32_count_function_get(counter, count, &function);
+	err = stm32_count_function_read(counter, count, &function);
 	if (err)
 		return err;
 
 	switch (function) {
-	case STM32_COUNT_SLAVE_MODE_DISABLED:
+	case COUNTER_FUNCTION_INCREASE:
 		/* counts on internal clock when CEN=1 */
-		*action = STM32_SYNAPSE_ACTION_NONE;
+		*action = COUNTER_SYNAPSE_ACTION_NONE;
 		return 0;
-	case STM32_COUNT_ENCODER_MODE_1:
+	case COUNTER_FUNCTION_QUADRATURE_X2_A:
 		/* counts up/down on TI1FP1 edge depending on TI2FP2 level */
 		if (synapse->signal->id == count->synapses[0].signal->id)
-			*action = STM32_SYNAPSE_ACTION_BOTH_EDGES;
+			*action = COUNTER_SYNAPSE_ACTION_BOTH_EDGES;
 		else
-			*action = STM32_SYNAPSE_ACTION_NONE;
+			*action = COUNTER_SYNAPSE_ACTION_NONE;
 		return 0;
-	case STM32_COUNT_ENCODER_MODE_2:
+	case COUNTER_FUNCTION_QUADRATURE_X2_B:
 		/* counts up/down on TI2FP2 edge depending on TI1FP1 level */
 		if (synapse->signal->id == count->synapses[1].signal->id)
-			*action = STM32_SYNAPSE_ACTION_BOTH_EDGES;
+			*action = COUNTER_SYNAPSE_ACTION_BOTH_EDGES;
 		else
-			*action = STM32_SYNAPSE_ACTION_NONE;
+			*action = COUNTER_SYNAPSE_ACTION_NONE;
 		return 0;
-	case STM32_COUNT_ENCODER_MODE_3:
+	case COUNTER_FUNCTION_QUADRATURE_X4:
 		/* counts up/down on both TI1FP1 and TI2FP2 edges */
-		*action = STM32_SYNAPSE_ACTION_BOTH_EDGES;
+		*action = COUNTER_SYNAPSE_ACTION_BOTH_EDGES;
 		return 0;
 	default:
 		return -EINVAL;
@@ -315,9 +272,9 @@ static int stm32_action_get(struct counter_device *counter,
 static const struct counter_ops stm32_timer_cnt_ops = {
 	.count_read = stm32_count_read,
 	.count_write = stm32_count_write,
-	.function_get = stm32_count_function_get,
-	.function_set = stm32_count_function_set,
-	.action_get = stm32_action_get,
+	.function_read = stm32_count_function_read,
+	.function_write = stm32_count_function_write,
+	.action_read = stm32_action_read,
 };
 
 static struct counter_signal stm32_signals[] = {
diff --git a/drivers/counter/ti-eqep.c b/drivers/counter/ti-eqep.c
index 94fe58bb3eab3..09817c953f9ab 100644
--- a/drivers/counter/ti-eqep.c
+++ b/drivers/counter/ti-eqep.c
@@ -13,6 +13,7 @@
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
 #include <linux/regmap.h>
+#include <linux/types.h>
 
 /* 32-bit registers */
 #define QPOSCNT		0x0
@@ -73,19 +74,13 @@ enum {
 };
 
 /* Position Counter Input Modes */
-enum {
+enum ti_eqep_count_func {
 	TI_EQEP_COUNT_FUNC_QUAD_COUNT,
 	TI_EQEP_COUNT_FUNC_DIR_COUNT,
 	TI_EQEP_COUNT_FUNC_UP_COUNT,
 	TI_EQEP_COUNT_FUNC_DOWN_COUNT,
 };
 
-enum {
-	TI_EQEP_SYNAPSE_ACTION_BOTH_EDGES,
-	TI_EQEP_SYNAPSE_ACTION_RISING_EDGE,
-	TI_EQEP_SYNAPSE_ACTION_NONE,
-};
-
 struct ti_eqep_cnt {
 	struct counter_device counter;
 	struct regmap *regmap32;
@@ -93,7 +88,7 @@ struct ti_eqep_cnt {
 };
 
 static int ti_eqep_count_read(struct counter_device *counter,
-			      struct counter_count *count, unsigned long *val)
+			      struct counter_count *count, u64 *val)
 {
 	struct ti_eqep_cnt *priv = counter->priv;
 	u32 cnt;
@@ -105,7 +100,7 @@ static int ti_eqep_count_read(struct counter_device *counter,
 }
 
 static int ti_eqep_count_write(struct counter_device *counter,
-			       struct counter_count *count, unsigned long val)
+			       struct counter_count *count, u64 val)
 {
 	struct ti_eqep_cnt *priv = counter->priv;
 	u32 max;
@@ -117,64 +112,100 @@ static int ti_eqep_count_write(struct counter_device *counter,
 	return regmap_write(priv->regmap32, QPOSCNT, val);
 }
 
-static int ti_eqep_function_get(struct counter_device *counter,
-				struct counter_count *count, size_t *function)
+static int ti_eqep_function_read(struct counter_device *counter,
+				 struct counter_count *count,
+				 enum counter_function *function)
 {
 	struct ti_eqep_cnt *priv = counter->priv;
 	u32 qdecctl;
 
 	regmap_read(priv->regmap16, QDECCTL, &qdecctl);
-	*function = (qdecctl & QDECCTL_QSRC) >> QDECCTL_QSRC_SHIFT;
+
+	switch ((qdecctl & QDECCTL_QSRC) >> QDECCTL_QSRC_SHIFT) {
+	case TI_EQEP_COUNT_FUNC_QUAD_COUNT:
+		*function = COUNTER_FUNCTION_QUADRATURE_X4;
+		break;
+	case TI_EQEP_COUNT_FUNC_DIR_COUNT:
+		*function = COUNTER_FUNCTION_PULSE_DIRECTION;
+		break;
+	case TI_EQEP_COUNT_FUNC_UP_COUNT:
+		*function = COUNTER_FUNCTION_INCREASE;
+		break;
+	case TI_EQEP_COUNT_FUNC_DOWN_COUNT:
+		*function = COUNTER_FUNCTION_DECREASE;
+		break;
+	}
 
 	return 0;
 }
 
-static int ti_eqep_function_set(struct counter_device *counter,
-				struct counter_count *count, size_t function)
+static int ti_eqep_function_write(struct counter_device *counter,
+				  struct counter_count *count,
+				  enum counter_function function)
 {
 	struct ti_eqep_cnt *priv = counter->priv;
+	enum ti_eqep_count_func qsrc;
+
+	switch (function) {
+	case COUNTER_FUNCTION_QUADRATURE_X4:
+		qsrc = TI_EQEP_COUNT_FUNC_QUAD_COUNT;
+		break;
+	case COUNTER_FUNCTION_PULSE_DIRECTION:
+		qsrc = TI_EQEP_COUNT_FUNC_DIR_COUNT;
+		break;
+	case COUNTER_FUNCTION_INCREASE:
+		qsrc = TI_EQEP_COUNT_FUNC_UP_COUNT;
+		break;
+	case COUNTER_FUNCTION_DECREASE:
+		qsrc = TI_EQEP_COUNT_FUNC_DOWN_COUNT;
+		break;
+	default:
+		/* should never reach this path */
+		return -EINVAL;
+	}
 
 	return regmap_write_bits(priv->regmap16, QDECCTL, QDECCTL_QSRC,
-				 function << QDECCTL_QSRC_SHIFT);
+				 qsrc << QDECCTL_QSRC_SHIFT);
 }
 
-static int ti_eqep_action_get(struct counter_device *counter,
-			      struct counter_count *count,
-			      struct counter_synapse *synapse, size_t *action)
+static int ti_eqep_action_read(struct counter_device *counter,
+			       struct counter_count *count,
+			       struct counter_synapse *synapse,
+			       enum counter_synapse_action *action)
 {
 	struct ti_eqep_cnt *priv = counter->priv;
-	size_t function;
+	enum counter_function function;
 	u32 qdecctl;
 	int err;
 
-	err = ti_eqep_function_get(counter, count, &function);
+	err = ti_eqep_function_read(counter, count, &function);
 	if (err)
 		return err;
 
 	switch (function) {
-	case TI_EQEP_COUNT_FUNC_QUAD_COUNT:
+	case COUNTER_FUNCTION_QUADRATURE_X4:
 		/* In quadrature mode, the rising and falling edge of both
 		 * QEPA and QEPB trigger QCLK.
 		 */
-		*action = TI_EQEP_SYNAPSE_ACTION_BOTH_EDGES;
+		*action = COUNTER_SYNAPSE_ACTION_BOTH_EDGES;
 		return 0;
-	case TI_EQEP_COUNT_FUNC_DIR_COUNT:
+	case COUNTER_FUNCTION_PULSE_DIRECTION:
 		/* In direction-count mode only rising edge of QEPA is counted
 		 * and QEPB gives direction.
 		 */
 		switch (synapse->signal->id) {
 		case TI_EQEP_SIGNAL_QEPA:
-			*action = TI_EQEP_SYNAPSE_ACTION_RISING_EDGE;
+			*action = COUNTER_SYNAPSE_ACTION_RISING_EDGE;
 			return 0;
 		case TI_EQEP_SIGNAL_QEPB:
-			*action = TI_EQEP_SYNAPSE_ACTION_NONE;
+			*action = COUNTER_SYNAPSE_ACTION_NONE;
 			return 0;
 		default:
 			/* should never reach this path */
 			return -EINVAL;
 		}
-	case TI_EQEP_COUNT_FUNC_UP_COUNT:
-	case TI_EQEP_COUNT_FUNC_DOWN_COUNT:
+	case COUNTER_FUNCTION_INCREASE:
+	case COUNTER_FUNCTION_DECREASE:
 		/* In up/down-count modes only QEPA is counted and QEPB is not
 		 * used.
 		 */
@@ -185,12 +216,12 @@ static int ti_eqep_action_get(struct counter_device *counter,
 				return err;
 
 			if (qdecctl & QDECCTL_XCR)
-				*action = TI_EQEP_SYNAPSE_ACTION_BOTH_EDGES;
+				*action = COUNTER_SYNAPSE_ACTION_BOTH_EDGES;
 			else
-				*action = TI_EQEP_SYNAPSE_ACTION_RISING_EDGE;
+				*action = COUNTER_SYNAPSE_ACTION_RISING_EDGE;
 			return 0;
 		case TI_EQEP_SIGNAL_QEPB:
-			*action = TI_EQEP_SYNAPSE_ACTION_NONE;
+			*action = COUNTER_SYNAPSE_ACTION_NONE;
 			return 0;
 		default:
 			/* should never reach this path */
@@ -205,82 +236,67 @@ static int ti_eqep_action_get(struct counter_device *counter,
 static const struct counter_ops ti_eqep_counter_ops = {
 	.count_read	= ti_eqep_count_read,
 	.count_write	= ti_eqep_count_write,
-	.function_get	= ti_eqep_function_get,
-	.function_set	= ti_eqep_function_set,
-	.action_get	= ti_eqep_action_get,
+	.function_read	= ti_eqep_function_read,
+	.function_write	= ti_eqep_function_write,
+	.action_read	= ti_eqep_action_read,
 };
 
-static ssize_t ti_eqep_position_ceiling_read(struct counter_device *counter,
-					     struct counter_count *count,
-					     void *ext_priv, char *buf)
+static int ti_eqep_position_ceiling_read(struct counter_device *counter,
+					 struct counter_count *count,
+					 u64 *ceiling)
 {
 	struct ti_eqep_cnt *priv = counter->priv;
 	u32 qposmax;
 
 	regmap_read(priv->regmap32, QPOSMAX, &qposmax);
 
-	return sprintf(buf, "%u\n", qposmax);
+	*ceiling = qposmax;
+
+	return 0;
 }
 
-static ssize_t ti_eqep_position_ceiling_write(struct counter_device *counter,
-					      struct counter_count *count,
-					      void *ext_priv, const char *buf,
-					      size_t len)
+static int ti_eqep_position_ceiling_write(struct counter_device *counter,
+					  struct counter_count *count,
+					  u64 ceiling)
 {
 	struct ti_eqep_cnt *priv = counter->priv;
-	int err;
-	u32 res;
 
-	err = kstrtouint(buf, 0, &res);
-	if (err < 0)
-		return err;
+	if (ceiling != (u32)ceiling)
+		return -ERANGE;
 
-	regmap_write(priv->regmap32, QPOSMAX, res);
+	regmap_write(priv->regmap32, QPOSMAX, ceiling);
 
-	return len;
+	return 0;
 }
 
-static ssize_t ti_eqep_position_enable_read(struct counter_device *counter,
-					    struct counter_count *count,
-					    void *ext_priv, char *buf)
+static int ti_eqep_position_enable_read(struct counter_device *counter,
+					struct counter_count *count, u8 *enable)
 {
 	struct ti_eqep_cnt *priv = counter->priv;
 	u32 qepctl;
 
 	regmap_read(priv->regmap16, QEPCTL, &qepctl);
 
-	return sprintf(buf, "%u\n", !!(qepctl & QEPCTL_PHEN));
+	*enable = !!(qepctl & QEPCTL_PHEN);
+
+	return 0;
 }
 
-static ssize_t ti_eqep_position_enable_write(struct counter_device *counter,
-					     struct counter_count *count,
-					     void *ext_priv, const char *buf,
-					     size_t len)
+static int ti_eqep_position_enable_write(struct counter_device *counter,
+					 struct counter_count *count, u8 enable)
 {
 	struct ti_eqep_cnt *priv = counter->priv;
-	int err;
-	bool res;
-
-	err = kstrtobool(buf, &res);
-	if (err < 0)
-		return err;
 
-	regmap_write_bits(priv->regmap16, QEPCTL, QEPCTL_PHEN, res ? -1 : 0);
+	regmap_write_bits(priv->regmap16, QEPCTL, QEPCTL_PHEN, enable ? -1 : 0);
 
-	return len;
+	return 0;
 }
 
-static struct counter_count_ext ti_eqep_position_ext[] = {
-	{
-		.name	= "ceiling",
-		.read	= ti_eqep_position_ceiling_read,
-		.write	= ti_eqep_position_ceiling_write,
-	},
-	{
-		.name	= "enable",
-		.read	= ti_eqep_position_enable_read,
-		.write	= ti_eqep_position_enable_write,
-	},
+static struct counter_comp ti_eqep_position_ext[] = {
+	COUNTER_COMP_CEILING(ti_eqep_position_ceiling_read,
+			     ti_eqep_position_ceiling_write),
+	COUNTER_COMP_ENABLE(ti_eqep_position_enable_read,
+			    ti_eqep_position_enable_write),
 };
 
 static struct counter_signal ti_eqep_signals[] = {
@@ -295,16 +311,16 @@ static struct counter_signal ti_eqep_signals[] = {
 };
 
 static const enum counter_function ti_eqep_position_functions[] = {
-	[TI_EQEP_COUNT_FUNC_QUAD_COUNT]	= COUNTER_FUNCTION_QUADRATURE_X4,
-	[TI_EQEP_COUNT_FUNC_DIR_COUNT]	= COUNTER_FUNCTION_PULSE_DIRECTION,
-	[TI_EQEP_COUNT_FUNC_UP_COUNT]	= COUNTER_FUNCTION_INCREASE,
-	[TI_EQEP_COUNT_FUNC_DOWN_COUNT]	= COUNTER_FUNCTION_DECREASE,
+	COUNTER_FUNCTION_QUADRATURE_X4,
+	COUNTER_FUNCTION_PULSE_DIRECTION,
+	COUNTER_FUNCTION_INCREASE,
+	COUNTER_FUNCTION_DECREASE,
 };
 
 static const enum counter_synapse_action ti_eqep_position_synapse_actions[] = {
-	[TI_EQEP_SYNAPSE_ACTION_BOTH_EDGES]	= COUNTER_SYNAPSE_ACTION_BOTH_EDGES,
-	[TI_EQEP_SYNAPSE_ACTION_RISING_EDGE]	= COUNTER_SYNAPSE_ACTION_RISING_EDGE,
-	[TI_EQEP_SYNAPSE_ACTION_NONE]		= COUNTER_SYNAPSE_ACTION_NONE,
+	COUNTER_SYNAPSE_ACTION_BOTH_EDGES,
+	COUNTER_SYNAPSE_ACTION_RISING_EDGE,
+	COUNTER_SYNAPSE_ACTION_NONE,
 };
 
 static struct counter_synapse ti_eqep_position_synapses[] = {
diff --git a/include/linux/counter.h b/include/linux/counter.h
index d16ce2819b48b..b69277f5c4c5e 100644
--- a/include/linux/counter.h
+++ b/include/linux/counter.h
@@ -6,42 +6,184 @@
 #ifndef _COUNTER_H_
 #define _COUNTER_H_
 
-#include <linux/counter_enum.h>
 #include <linux/device.h>
+#include <linux/kernel.h>
 #include <linux/types.h>
 
+struct counter_device;
+struct counter_count;
+struct counter_synapse;
+struct counter_signal;
+
+enum counter_comp_type {
+	COUNTER_COMP_U8,
+	COUNTER_COMP_U64,
+	COUNTER_COMP_BOOL,
+	COUNTER_COMP_SIGNAL_LEVEL,
+	COUNTER_COMP_FUNCTION,
+	COUNTER_COMP_SYNAPSE_ACTION,
+	COUNTER_COMP_ENUM,
+	COUNTER_COMP_COUNT_DIRECTION,
+	COUNTER_COMP_COUNT_MODE,
+};
+
+enum counter_scope {
+	COUNTER_SCOPE_DEVICE,
+	COUNTER_SCOPE_SIGNAL,
+	COUNTER_SCOPE_COUNT,
+};
+
 enum counter_count_direction {
-	COUNTER_COUNT_DIRECTION_FORWARD = 0,
-	COUNTER_COUNT_DIRECTION_BACKWARD
+	COUNTER_COUNT_DIRECTION_FORWARD,
+	COUNTER_COUNT_DIRECTION_BACKWARD,
 };
-extern const char *const counter_count_direction_str[2];
 
 enum counter_count_mode {
-	COUNTER_COUNT_MODE_NORMAL = 0,
+	COUNTER_COUNT_MODE_NORMAL,
 	COUNTER_COUNT_MODE_RANGE_LIMIT,
 	COUNTER_COUNT_MODE_NON_RECYCLE,
-	COUNTER_COUNT_MODE_MODULO_N
+	COUNTER_COUNT_MODE_MODULO_N,
 };
-extern const char *const counter_count_mode_str[4];
 
-struct counter_device;
-struct counter_signal;
+enum counter_function {
+	COUNTER_FUNCTION_INCREASE,
+	COUNTER_FUNCTION_DECREASE,
+	COUNTER_FUNCTION_PULSE_DIRECTION,
+	COUNTER_FUNCTION_QUADRATURE_X1_A,
+	COUNTER_FUNCTION_QUADRATURE_X1_B,
+	COUNTER_FUNCTION_QUADRATURE_X2_A,
+	COUNTER_FUNCTION_QUADRATURE_X2_B,
+	COUNTER_FUNCTION_QUADRATURE_X4,
+};
+
+enum counter_signal_level {
+	COUNTER_SIGNAL_LEVEL_LOW,
+	COUNTER_SIGNAL_LEVEL_HIGH,
+};
+
+enum counter_synapse_action {
+	COUNTER_SYNAPSE_ACTION_NONE,
+	COUNTER_SYNAPSE_ACTION_RISING_EDGE,
+	COUNTER_SYNAPSE_ACTION_FALLING_EDGE,
+	COUNTER_SYNAPSE_ACTION_BOTH_EDGES,
+};
 
 /**
- * struct counter_signal_ext - Counter Signal extensions
- * @name:	attribute name
- * @read:	read callback for this attribute; may be NULL
- * @write:	write callback for this attribute; may be NULL
- * @priv:	data private to the driver
+ * struct counter_comp - Counter component node
+ * @type:		Counter component data type
+ * @name:		device-specific component name
+ * @priv:		component-relevant data
+ * @action_read		Synapse action mode read callback. The read value of the
+ *			respective Synapse action mode should be passed back via
+ *			the action parameter.
+ * @device_u8_read	Device u8 component read callback. The read value of the
+ *			respective Device u8 component should be passed back via
+ *			the val parameter.
+ * @count_u8_read	Count u8 component read callback. The read value of the
+ *			respective Count u8 component should be passed back via
+ *			the val parameter.
+ * @signal_u8_read	Signal u8 component read callback. The read value of the
+ *			respective Signal u8 component should be passed back via
+ *			the val parameter.
+ * @device_u32_read	Device u32 component read callback. The read value of
+ *			the respective Device u32 component should be passed
+ *			back via the val parameter.
+ * @count_u32_read	Count u32 component read callback. The read value of the
+ *			respective Count u32 component should be passed back via
+ *			the val parameter.
+ * @signal_u32_read	Signal u32 component read callback. The read value of
+ *			the respective Signal u32 component should be passed
+ *			back via the val parameter.
+ * @device_u64_read	Device u64 component read callback. The read value of
+ *			the respective Device u64 component should be passed
+ *			back via the val parameter.
+ * @count_u64_read	Count u64 component read callback. The read value of the
+ *			respective Count u64 component should be passed back via
+ *			the val parameter.
+ * @signal_u64_read	Signal u64 component read callback. The read value of
+ *			the respective Signal u64 component should be passed
+ *			back via the val parameter.
+ * @action_write	Synapse action mode write callback. The write value of
+ *			the respective Synapse action mode is passed via the
+ *			action parameter.
+ * @device_u8_write	Device u8 component write callback. The write value of
+ *			the respective Device u8 component is passed via the val
+ *			parameter.
+ * @count_u8_write	Count u8 component write callback. The write value of
+ *			the respective Count u8 component is passed via the val
+ *			parameter.
+ * @signal_u8_write	Signal u8 component write callback. The write value of
+ *			the respective Signal u8 component is passed via the val
+ *			parameter.
+ * @device_u32_write	Device u32 component write callback. The write value of
+ *			the respective Device u32 component is passed via the
+ *			val parameter.
+ * @count_u32_write	Count u32 component write callback. The write value of
+ *			the respective Count u32 component is passed via the val
+ *			parameter.
+ * @signal_u32_write	Signal u32 component write callback. The write value of
+ *			the respective Signal u32 component is passed via the
+ *			val parameter.
+ * @device_u64_write	Device u64 component write callback. The write value of
+ *			the respective Device u64 component is passed via the
+ *			val parameter.
+ * @count_u64_write	Count u64 component write callback. The write value of
+ *			the respective Count u64 component is passed via the val
+ *			parameter.
+ * @signal_u64_write	Signal u64 component write callback. The write value of
+ *			the respective Signal u64 component is passed via the
+ *			val parameter.
  */
-struct counter_signal_ext {
+struct counter_comp {
+	enum counter_comp_type type;
 	const char *name;
-	ssize_t (*read)(struct counter_device *counter,
-			struct counter_signal *signal, void *priv, char *buf);
-	ssize_t (*write)(struct counter_device *counter,
-			 struct counter_signal *signal, void *priv,
-			 const char *buf, size_t len);
 	void *priv;
+	union {
+		int (*action_read)(struct counter_device *counter,
+				   struct counter_count *count,
+				   struct counter_synapse *synapse,
+				   enum counter_synapse_action *action);
+		int (*device_u8_read)(struct counter_device *counter, u8 *val);
+		int (*count_u8_read)(struct counter_device *counter,
+				     struct counter_count *count, u8 *val);
+		int (*signal_u8_read)(struct counter_device *counter,
+				      struct counter_signal *signal, u8 *val);
+		int (*device_u32_read)(struct counter_device *counter,
+				       u32 *val);
+		int (*count_u32_read)(struct counter_device *counter,
+				      struct counter_count *count, u32 *val);
+		int (*signal_u32_read)(struct counter_device *counter,
+				       struct counter_signal *signal, u32 *val);
+		int (*device_u64_read)(struct counter_device *counter,
+				       u64 *val);
+		int (*count_u64_read)(struct counter_device *counter,
+				      struct counter_count *count, u64 *val);
+		int (*signal_u64_read)(struct counter_device *counter,
+				       struct counter_signal *signal, u64 *val);
+	};
+	union {
+		int (*action_write)(struct counter_device *counter,
+				    struct counter_count *count,
+				    struct counter_synapse *synapse,
+				    enum counter_synapse_action action);
+		int (*device_u8_write)(struct counter_device *counter, u8 val);
+		int (*count_u8_write)(struct counter_device *counter,
+				      struct counter_count *count, u8 val);
+		int (*signal_u8_write)(struct counter_device *counter,
+				       struct counter_signal *signal, u8 val);
+		int (*device_u32_write)(struct counter_device *counter,
+					u32 val);
+		int (*count_u32_write)(struct counter_device *counter,
+				       struct counter_count *count, u32 val);
+		int (*signal_u32_write)(struct counter_device *counter,
+					struct counter_signal *signal, u32 val);
+		int (*device_u64_write)(struct counter_device *counter,
+					u64 val);
+		int (*count_u64_write)(struct counter_device *counter,
+				       struct counter_count *count, u64 val);
+		int (*signal_u64_write)(struct counter_device *counter,
+					struct counter_signal *signal, u64 val);
+	};
 };
 
 /**
@@ -51,248 +193,52 @@ struct counter_signal_ext {
  *		as it appears in the datasheet documentation
  * @ext:	optional array of Counter Signal extensions
  * @num_ext:	number of Counter Signal extensions specified in @ext
- * @priv:	optional private data supplied by driver
  */
 struct counter_signal {
 	int id;
 	const char *name;
 
-	const struct counter_signal_ext *ext;
+	struct counter_comp *ext;
 	size_t num_ext;
-
-	void *priv;
-};
-
-/**
- * struct counter_signal_enum_ext - Signal enum extension attribute
- * @items:	Array of strings
- * @num_items:	Number of items specified in @items
- * @set:	Set callback function; may be NULL
- * @get:	Get callback function; may be NULL
- *
- * The counter_signal_enum_ext structure can be used to implement enum style
- * Signal extension attributes. Enum style attributes are those which have a set
- * of strings that map to unsigned integer values. The Generic Counter Signal
- * enum extension helper code takes care of mapping between value and string, as
- * well as generating a "_available" file which contains a list of all available
- * items. The get callback is used to query the currently active item; the index
- * of the item within the respective items array is returned via the 'item'
- * parameter. The set callback is called when the attribute is updated; the
- * 'item' parameter contains the index of the newly activated item within the
- * respective items array.
- */
-struct counter_signal_enum_ext {
-	const char * const *items;
-	size_t num_items;
-	int (*get)(struct counter_device *counter,
-		   struct counter_signal *signal, size_t *item);
-	int (*set)(struct counter_device *counter,
-		   struct counter_signal *signal, size_t item);
-};
-
-/**
- * COUNTER_SIGNAL_ENUM() - Initialize Signal enum extension
- * @_name:	Attribute name
- * @_e:		Pointer to a counter_signal_enum_ext structure
- *
- * This should usually be used together with COUNTER_SIGNAL_ENUM_AVAILABLE()
- */
-#define COUNTER_SIGNAL_ENUM(_name, _e) \
-{ \
-	.name = (_name), \
-	.read = counter_signal_enum_read, \
-	.write = counter_signal_enum_write, \
-	.priv = (_e) \
-}
-
-/**
- * COUNTER_SIGNAL_ENUM_AVAILABLE() - Initialize Signal enum available extension
- * @_name:	Attribute name ("_available" will be appended to the name)
- * @_e:		Pointer to a counter_signal_enum_ext structure
- *
- * Creates a read only attribute that lists all the available enum items in a
- * newline separated list. This should usually be used together with
- * COUNTER_SIGNAL_ENUM()
- */
-#define COUNTER_SIGNAL_ENUM_AVAILABLE(_name, _e) \
-{ \
-	.name = (_name "_available"), \
-	.read = counter_signal_enum_available_read, \
-	.priv = (_e) \
-}
-
-enum counter_synapse_action {
-	COUNTER_SYNAPSE_ACTION_NONE = 0,
-	COUNTER_SYNAPSE_ACTION_RISING_EDGE,
-	COUNTER_SYNAPSE_ACTION_FALLING_EDGE,
-	COUNTER_SYNAPSE_ACTION_BOTH_EDGES
 };
 
 /**
  * struct counter_synapse - Counter Synapse node
- * @action:		index of current action mode
  * @actions_list:	array of available action modes
  * @num_actions:	number of action modes specified in @actions_list
  * @signal:		pointer to associated signal
  */
 struct counter_synapse {
-	size_t action;
 	const enum counter_synapse_action *actions_list;
 	size_t num_actions;
 
 	struct counter_signal *signal;
 };
 
-struct counter_count;
-
-/**
- * struct counter_count_ext - Counter Count extension
- * @name:	attribute name
- * @read:	read callback for this attribute; may be NULL
- * @write:	write callback for this attribute; may be NULL
- * @priv:	data private to the driver
- */
-struct counter_count_ext {
-	const char *name;
-	ssize_t (*read)(struct counter_device *counter,
-			struct counter_count *count, void *priv, char *buf);
-	ssize_t (*write)(struct counter_device *counter,
-			 struct counter_count *count, void *priv,
-			 const char *buf, size_t len);
-	void *priv;
-};
-
-enum counter_function {
-	COUNTER_FUNCTION_INCREASE = 0,
-	COUNTER_FUNCTION_DECREASE,
-	COUNTER_FUNCTION_PULSE_DIRECTION,
-	COUNTER_FUNCTION_QUADRATURE_X1_A,
-	COUNTER_FUNCTION_QUADRATURE_X1_B,
-	COUNTER_FUNCTION_QUADRATURE_X2_A,
-	COUNTER_FUNCTION_QUADRATURE_X2_B,
-	COUNTER_FUNCTION_QUADRATURE_X4
-};
-
 /**
  * struct counter_count - Counter Count node
  * @id:			unique ID used to identify Count
  * @name:		device-specific Count name; ideally, this should match
  *			the name as it appears in the datasheet documentation
- * @function:		index of current function mode
  * @functions_list:	array available function modes
  * @num_functions:	number of function modes specified in @functions_list
  * @synapses:		array of synapses for initialization
  * @num_synapses:	number of synapses specified in @synapses
  * @ext:		optional array of Counter Count extensions
  * @num_ext:		number of Counter Count extensions specified in @ext
- * @priv:		optional private data supplied by driver
  */
 struct counter_count {
 	int id;
 	const char *name;
 
-	size_t function;
 	const enum counter_function *functions_list;
 	size_t num_functions;
 
 	struct counter_synapse *synapses;
 	size_t num_synapses;
 
-	const struct counter_count_ext *ext;
+	struct counter_comp *ext;
 	size_t num_ext;
-
-	void *priv;
-};
-
-/**
- * struct counter_count_enum_ext - Count enum extension attribute
- * @items:	Array of strings
- * @num_items:	Number of items specified in @items
- * @set:	Set callback function; may be NULL
- * @get:	Get callback function; may be NULL
- *
- * The counter_count_enum_ext structure can be used to implement enum style
- * Count extension attributes. Enum style attributes are those which have a set
- * of strings that map to unsigned integer values. The Generic Counter Count
- * enum extension helper code takes care of mapping between value and string, as
- * well as generating a "_available" file which contains a list of all available
- * items. The get callback is used to query the currently active item; the index
- * of the item within the respective items array is returned via the 'item'
- * parameter. The set callback is called when the attribute is updated; the
- * 'item' parameter contains the index of the newly activated item within the
- * respective items array.
- */
-struct counter_count_enum_ext {
-	const char * const *items;
-	size_t num_items;
-	int (*get)(struct counter_device *counter, struct counter_count *count,
-		   size_t *item);
-	int (*set)(struct counter_device *counter, struct counter_count *count,
-		   size_t item);
-};
-
-/**
- * COUNTER_COUNT_ENUM() - Initialize Count enum extension
- * @_name:	Attribute name
- * @_e:		Pointer to a counter_count_enum_ext structure
- *
- * This should usually be used together with COUNTER_COUNT_ENUM_AVAILABLE()
- */
-#define COUNTER_COUNT_ENUM(_name, _e) \
-{ \
-	.name = (_name), \
-	.read = counter_count_enum_read, \
-	.write = counter_count_enum_write, \
-	.priv = (_e) \
-}
-
-/**
- * COUNTER_COUNT_ENUM_AVAILABLE() - Initialize Count enum available extension
- * @_name:	Attribute name ("_available" will be appended to the name)
- * @_e:		Pointer to a counter_count_enum_ext structure
- *
- * Creates a read only attribute that lists all the available enum items in a
- * newline separated list. This should usually be used together with
- * COUNTER_COUNT_ENUM()
- */
-#define COUNTER_COUNT_ENUM_AVAILABLE(_name, _e) \
-{ \
-	.name = (_name "_available"), \
-	.read = counter_count_enum_available_read, \
-	.priv = (_e) \
-}
-
-/**
- * struct counter_device_attr_group - internal container for attribute group
- * @attr_group:	Counter sysfs attributes group
- * @attr_list:	list to keep track of created Counter sysfs attributes
- * @num_attr:	number of Counter sysfs attributes
- */
-struct counter_device_attr_group {
-	struct attribute_group attr_group;
-	struct list_head attr_list;
-	size_t num_attr;
-};
-
-/**
- * struct counter_device_state - internal state container for a Counter device
- * @id:			unique ID used to identify the Counter
- * @dev:		internal device structure
- * @groups_list:	attribute groups list (for Signals, Counts, and ext)
- * @num_groups:		number of attribute groups containers
- * @groups:		Counter sysfs attribute groups (to populate @dev.groups)
- */
-struct counter_device_state {
-	int id;
-	struct device dev;
-	struct counter_device_attr_group *groups_list;
-	size_t num_groups;
-	const struct attribute_group **groups;
-};
-
-enum counter_signal_level {
-	COUNTER_SIGNAL_LEVEL_LOW,
-	COUNTER_SIGNAL_LEVEL_HIGH,
 };
 
 /**
@@ -306,117 +252,47 @@ enum counter_signal_level {
  * @count_write:	optional write callback for Count attribute. The write
  *			value for the respective Count is passed in via the val
  *			parameter.
- * @function_get:	function to get the current count function mode. Returns
- *			0 on success and negative error code on error. The index
- *			of the respective Count's returned function mode should
- *			be passed back via the function parameter.
- * @function_set:	function to set the count function mode. function is the
- *			index of the requested function mode from the respective
- *			Count's functions_list array.
- * @action_get:		function to get the current action mode. Returns 0 on
- *			success and negative error code on error. The index of
- *			the respective Synapse's returned action mode should be
- *			passed back via the action parameter.
- * @action_set:		function to set the action mode. action is the index of
- *			the requested action mode from the respective Synapse's
- *			actions_list array.
+ * @function_read:	read callback the Count function modes. The read
+ *			function mode of the respective Count should be passed
+ *			back via the function parameter.
+ * @function_write:	write callback for Count function modes. The function
+ *			mode to write for the respective Count is passed in via
+ *			the function parameter.
+ * @action_read:	read callback the Synapse action modes. The read action
+ *			mode of the respective Synapse should be passed back via
+ *			the action parameter.
+ * @action_write:	write callback for Synapse action modes. The action mode
+ *			to write for the respective Synapse is passed in via the
+ *			action parameter.
  */
 struct counter_ops {
 	int (*signal_read)(struct counter_device *counter,
 			   struct counter_signal *signal,
 			   enum counter_signal_level *level);
 	int (*count_read)(struct counter_device *counter,
-			  struct counter_count *count, unsigned long *val);
+			  struct counter_count *count, u64 *value);
 	int (*count_write)(struct counter_device *counter,
-			   struct counter_count *count, unsigned long val);
-	int (*function_get)(struct counter_device *counter,
-			    struct counter_count *count, size_t *function);
-	int (*function_set)(struct counter_device *counter,
-			    struct counter_count *count, size_t function);
-	int (*action_get)(struct counter_device *counter,
-			  struct counter_count *count,
-			  struct counter_synapse *synapse, size_t *action);
-	int (*action_set)(struct counter_device *counter,
-			  struct counter_count *count,
-			  struct counter_synapse *synapse, size_t action);
-};
-
-/**
- * struct counter_device_ext - Counter device extension
- * @name:	attribute name
- * @read:	read callback for this attribute; may be NULL
- * @write:	write callback for this attribute; may be NULL
- * @priv:	data private to the driver
- */
-struct counter_device_ext {
-	const char *name;
-	ssize_t (*read)(struct counter_device *counter, void *priv, char *buf);
-	ssize_t (*write)(struct counter_device *counter, void *priv,
-			 const char *buf, size_t len);
-	void *priv;
+			   struct counter_count *count, u64 value);
+	int (*function_read)(struct counter_device *counter,
+			     struct counter_count *count,
+			     enum counter_function *function);
+	int (*function_write)(struct counter_device *counter,
+			      struct counter_count *count,
+			      enum counter_function function);
+	int (*action_read)(struct counter_device *counter,
+			   struct counter_count *count,
+			   struct counter_synapse *synapse,
+			   enum counter_synapse_action *action);
+	int (*action_write)(struct counter_device *counter,
+			    struct counter_count *count,
+			    struct counter_synapse *synapse,
+			    enum counter_synapse_action action);
 };
 
-/**
- * struct counter_device_enum_ext - Counter enum extension attribute
- * @items:	Array of strings
- * @num_items:	Number of items specified in @items
- * @set:	Set callback function; may be NULL
- * @get:	Get callback function; may be NULL
- *
- * The counter_device_enum_ext structure can be used to implement enum style
- * Counter extension attributes. Enum style attributes are those which have a
- * set of strings that map to unsigned integer values. The Generic Counter enum
- * extension helper code takes care of mapping between value and string, as well
- * as generating a "_available" file which contains a list of all available
- * items. The get callback is used to query the currently active item; the index
- * of the item within the respective items array is returned via the 'item'
- * parameter. The set callback is called when the attribute is updated; the
- * 'item' parameter contains the index of the newly activated item within the
- * respective items array.
- */
-struct counter_device_enum_ext {
-	const char * const *items;
-	size_t num_items;
-	int (*get)(struct counter_device *counter, size_t *item);
-	int (*set)(struct counter_device *counter, size_t item);
-};
-
-/**
- * COUNTER_DEVICE_ENUM() - Initialize Counter enum extension
- * @_name:	Attribute name
- * @_e:		Pointer to a counter_device_enum_ext structure
- *
- * This should usually be used together with COUNTER_DEVICE_ENUM_AVAILABLE()
- */
-#define COUNTER_DEVICE_ENUM(_name, _e) \
-{ \
-	.name = (_name), \
-	.read = counter_device_enum_read, \
-	.write = counter_device_enum_write, \
-	.priv = (_e) \
-}
-
-/**
- * COUNTER_DEVICE_ENUM_AVAILABLE() - Initialize Counter enum available extension
- * @_name:	Attribute name ("_available" will be appended to the name)
- * @_e:		Pointer to a counter_device_enum_ext structure
- *
- * Creates a read only attribute that lists all the available enum items in a
- * newline separated list. This should usually be used together with
- * COUNTER_DEVICE_ENUM()
- */
-#define COUNTER_DEVICE_ENUM_AVAILABLE(_name, _e) \
-{ \
-	.name = (_name "_available"), \
-	.read = counter_device_enum_available_read, \
-	.priv = (_e) \
-}
-
 /**
  * struct counter_device - Counter data structure
  * @name:		name of the device as it appears in the datasheet
  * @parent:		optional parent device providing the counters
- * @device_state:	internal device state container
  * @ops:		callbacks from driver
  * @signals:		array of Signals
  * @num_signals:	number of Signals specified in @signals
@@ -425,11 +301,11 @@ struct counter_device_enum_ext {
  * @ext:		optional array of Counter device extensions
  * @num_ext:		number of Counter device extensions specified in @ext
  * @priv:		optional private data supplied by driver
+ * @dev:		internal device structure
  */
 struct counter_device {
 	const char *name;
 	struct device *parent;
-	struct counter_device_state *device_state;
 
 	const struct counter_ops *ops;
 
@@ -438,17 +314,159 @@ struct counter_device {
 	struct counter_count *counts;
 	size_t num_counts;
 
-	const struct counter_device_ext *ext;
+	struct counter_comp *ext;
 	size_t num_ext;
 
 	void *priv;
+
+	struct device dev;
 };
 
 int counter_register(struct counter_device *const counter);
 void counter_unregister(struct counter_device *const counter);
 int devm_counter_register(struct device *dev,
 			  struct counter_device *const counter);
-void devm_counter_unregister(struct device *dev,
-			     struct counter_device *const counter);
+
+#define COUNTER_COMP_DEVICE_U8(_name, _read, _write) \
+{ \
+	.type = COUNTER_COMP_U8, \
+	.name = (_name), \
+	.device_u8_read = (_read), \
+	.device_u8_write = (_write), \
+}
+#define COUNTER_COMP_COUNT_U8(_name, _read, _write) \
+{ \
+	.type = COUNTER_COMP_U8, \
+	.name = (_name), \
+	.count_u8_read = (_read), \
+	.count_u8_write = (_write), \
+}
+#define COUNTER_COMP_SIGNAL_U8(_name, _read, _write) \
+{ \
+	.type = COUNTER_COMP_U8, \
+	.name = (_name), \
+	.signal_u8_read = (_read), \
+	.signal_u8_write = (_write), \
+}
+
+#define COUNTER_COMP_DEVICE_U64(_name, _read, _write) \
+{ \
+	.type = COUNTER_COMP_U64, \
+	.name = (_name), \
+	.device_u64_read = (_read), \
+	.device_u64_write = (_write), \
+}
+#define COUNTER_COMP_COUNT_U64(_name, _read, _write) \
+{ \
+	.type = COUNTER_COMP_U64, \
+	.name = (_name), \
+	.count_u64_read = (_read), \
+	.count_u64_write = (_write), \
+}
+#define COUNTER_COMP_SIGNAL_U64(_name, _read, _write) \
+{ \
+	.type = COUNTER_COMP_U64, \
+	.name = (_name), \
+	.signal_u64_read = (_read), \
+	.signal_u64_write = (_write), \
+}
+
+#define COUNTER_COMP_DEVICE_BOOL(_name, _read, _write) \
+{ \
+	.type = COUNTER_COMP_BOOL, \
+	.name = (_name), \
+	.device_u8_read = (_read), \
+	.device_u8_write = (_write), \
+}
+#define COUNTER_COMP_COUNT_BOOL(_name, _read, _write) \
+{ \
+	.type = COUNTER_COMP_BOOL, \
+	.name = (_name), \
+	.count_u8_read = (_read), \
+	.count_u8_write = (_write), \
+}
+#define COUNTER_COMP_SIGNAL_BOOL(_name, _read, _write) \
+{ \
+	.type = COUNTER_COMP_BOOL, \
+	.name = (_name), \
+	.signal_u8_read = (_read), \
+	.signal_u8_write = (_write), \
+}
+
+struct counter_available {
+	union {
+		const u32 *enums;
+		const char *const *strs;
+	};
+	size_t num_items;
+};
+
+#define DEFINE_COUNTER_AVAILABLE(_name, _enums) \
+	struct counter_available _name = { \
+		.enums = (_enums), \
+		.num_items = ARRAY_SIZE(_enums), \
+	}
+
+#define DEFINE_COUNTER_ENUM(_name, _strs) \
+	struct counter_available _name = { \
+		.strs = (_strs), \
+		.num_items = ARRAY_SIZE(_strs), \
+	}
+
+#define COUNTER_COMP_DEVICE_ENUM(_name, _get, _set, _available) \
+{ \
+	.type = COUNTER_COMP_ENUM, \
+	.name = (_name), \
+	.device_u32_read = (_get), \
+	.device_u32_write = (_set), \
+	.priv = &(_available), \
+}
+#define COUNTER_COMP_COUNT_ENUM(_name, _get, _set, _available) \
+{ \
+	.type = COUNTER_COMP_ENUM, \
+	.name = (_name), \
+	.count_u32_read = (_get), \
+	.count_u32_write = (_set), \
+	.priv = &(_available), \
+}
+#define COUNTER_COMP_SIGNAL_ENUM(_name, _get, _set, _available) \
+{ \
+	.type = COUNTER_COMP_ENUM, \
+	.name = (_name), \
+	.signal_u32_read = (_get), \
+	.signal_u32_write = (_set), \
+	.priv = &(_available), \
+}
+
+#define COUNTER_COMP_CEILING(_read, _write) \
+	COUNTER_COMP_COUNT_U64("ceiling", _read, _write)
+
+#define COUNTER_COMP_COUNT_MODE(_read, _write, _available) \
+{ \
+	.type = COUNTER_COMP_COUNT_MODE, \
+	.name = "count_mode", \
+	.count_u32_read = (_read), \
+	.count_u32_write = (_write), \
+	.priv = &(_available), \
+}
+
+#define COUNTER_COMP_DIRECTION(_read) \
+{ \
+	.type = COUNTER_COMP_COUNT_DIRECTION, \
+	.name = "direction", \
+	.count_u32_read = (_read), \
+}
+
+#define COUNTER_COMP_ENABLE(_read, _write) \
+	COUNTER_COMP_COUNT_BOOL("enable", _read, _write)
+
+#define COUNTER_COMP_FLOOR(_read, _write) \
+	COUNTER_COMP_COUNT_U64("floor", _read, _write)
+
+#define COUNTER_COMP_PRESET(_read, _write) \
+	COUNTER_COMP_COUNT_U64("preset", _read, _write)
+
+#define COUNTER_COMP_PRESET_ENABLE(_read, _write) \
+	COUNTER_COMP_COUNT_BOOL("preset_enable", _read, _write)
 
 #endif /* _COUNTER_H_ */
diff --git a/include/linux/counter_enum.h b/include/linux/counter_enum.h
deleted file mode 100644
index 9f917298a88f8..0000000000000
--- a/include/linux/counter_enum.h
+++ /dev/null
@@ -1,45 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-/*
- * Counter interface enum functions
- * Copyright (C) 2018 William Breathitt Gray
- */
-#ifndef _COUNTER_ENUM_H_
-#define _COUNTER_ENUM_H_
-
-#include <linux/types.h>
-
-struct counter_device;
-struct counter_signal;
-struct counter_count;
-
-ssize_t counter_signal_enum_read(struct counter_device *counter,
-				 struct counter_signal *signal, void *priv,
-				 char *buf);
-ssize_t counter_signal_enum_write(struct counter_device *counter,
-				  struct counter_signal *signal, void *priv,
-				  const char *buf, size_t len);
-
-ssize_t counter_signal_enum_available_read(struct counter_device *counter,
-					   struct counter_signal *signal,
-					   void *priv, char *buf);
-
-ssize_t counter_count_enum_read(struct counter_device *counter,
-				struct counter_count *count, void *priv,
-				char *buf);
-ssize_t counter_count_enum_write(struct counter_device *counter,
-				 struct counter_count *count, void *priv,
-				 const char *buf, size_t len);
-
-ssize_t counter_count_enum_available_read(struct counter_device *counter,
-					  struct counter_count *count,
-					  void *priv, char *buf);
-
-ssize_t counter_device_enum_read(struct counter_device *counter, void *priv,
-				 char *buf);
-ssize_t counter_device_enum_write(struct counter_device *counter, void *priv,
-				  const char *buf, size_t len);
-
-ssize_t counter_device_enum_available_read(struct counter_device *counter,
-					   void *priv, char *buf);
-
-#endif /* _COUNTER_ENUM_H_ */
-- 
2.39.2



