Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9A49344356
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:52:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230021AbhCVMti (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:49:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:42228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232760AbhCVMsM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:48:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2BA17619B6;
        Mon, 22 Mar 2021 12:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616417044;
        bh=m6DurxuMzZEzMMTp7cKzfYTjjKPLthFr8l+qTYn8IJQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jL2tQz8VEJlt8nPCgaAQMZ3qGocIAwB0Vl+Fn5OkI+yWgqz+wxbwp/MkWTUADouS+
         MVsTQGBUa2f6IhK64Ph4GUluNDgj83RMrmWLycJ92mgNR/eN5ayiyRSr6sIzaQTh/w
         LYJFp4oGlpoqM70Z4o1HmpzrU+66QuSOMraNmkMo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabrice Gasnier <fabrice.gasnier@st.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        William Breathitt Gray <vilhelm.gray@gmail.com>,
        Fabrice Gasnier <fabrice.gasnier@foss.st.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 32/60] counter: stm32-timer-cnt: Report count function when SLAVE_MODE_DISABLED
Date:   Mon, 22 Mar 2021 13:28:20 +0100
Message-Id: <20210322121923.447284395@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121922.372583154@linuxfoundation.org>
References: <20210322121922.372583154@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: William Breathitt Gray <vilhelm.gray@gmail.com>

[ Upstream commit fae6f62e6a580b663ecf42c2120a0898deae9137 ]

When in SLAVE_MODE_DISABLED mode, the count still increases if the
counter is enabled because an internal clock is used. This patch fixes
the stm32_count_function_get() and stm32_count_function_set() functions
to properly handle this behavior.

Fixes: ad29937e206f ("counter: Add STM32 Timer quadrature encoder")
Cc: Fabrice Gasnier <fabrice.gasnier@st.com>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
Signed-off-by: William Breathitt Gray <vilhelm.gray@gmail.com>
Reviewed-by: Fabrice Gasnier <fabrice.gasnier@foss.st.com>
Link: https://lore.kernel.org/r/20210226012931.161429-1-vilhelm.gray@gmail.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/counter/stm32-timer-cnt.c | 39 ++++++++++++++++++++-----------
 1 file changed, 25 insertions(+), 14 deletions(-)

diff --git a/drivers/counter/stm32-timer-cnt.c b/drivers/counter/stm32-timer-cnt.c
index 644ba18a72ad..c680c7abdd26 100644
--- a/drivers/counter/stm32-timer-cnt.c
+++ b/drivers/counter/stm32-timer-cnt.c
@@ -35,13 +35,14 @@ struct stm32_timer_cnt {
  * @STM32_COUNT_ENCODER_MODE_3: counts on both TI1FP1 and TI2FP2 edges
  */
 enum stm32_count_function {
-	STM32_COUNT_SLAVE_MODE_DISABLED = -1,
+	STM32_COUNT_SLAVE_MODE_DISABLED,
 	STM32_COUNT_ENCODER_MODE_1,
 	STM32_COUNT_ENCODER_MODE_2,
 	STM32_COUNT_ENCODER_MODE_3,
 };
 
 static enum counter_count_function stm32_count_functions[] = {
+	[STM32_COUNT_SLAVE_MODE_DISABLED] = COUNTER_COUNT_FUNCTION_INCREASE,
 	[STM32_COUNT_ENCODER_MODE_1] = COUNTER_COUNT_FUNCTION_QUADRATURE_X2_A,
 	[STM32_COUNT_ENCODER_MODE_2] = COUNTER_COUNT_FUNCTION_QUADRATURE_X2_B,
 	[STM32_COUNT_ENCODER_MODE_3] = COUNTER_COUNT_FUNCTION_QUADRATURE_X4,
@@ -88,6 +89,9 @@ static int stm32_count_function_get(struct counter_device *counter,
 	regmap_read(priv->regmap, TIM_SMCR, &smcr);
 
 	switch (smcr & TIM_SMCR_SMS) {
+	case 0:
+		*function = STM32_COUNT_SLAVE_MODE_DISABLED;
+		return 0;
 	case 1:
 		*function = STM32_COUNT_ENCODER_MODE_1;
 		return 0;
@@ -97,9 +101,9 @@ static int stm32_count_function_get(struct counter_device *counter,
 	case 3:
 		*function = STM32_COUNT_ENCODER_MODE_3;
 		return 0;
+	default:
+		return -EINVAL;
 	}
-
-	return -EINVAL;
 }
 
 static int stm32_count_function_set(struct counter_device *counter,
@@ -110,6 +114,9 @@ static int stm32_count_function_set(struct counter_device *counter,
 	u32 cr1, sms;
 
 	switch (function) {
+	case STM32_COUNT_SLAVE_MODE_DISABLED:
+		sms = 0;
+		break;
 	case STM32_COUNT_ENCODER_MODE_1:
 		sms = 1;
 		break;
@@ -120,8 +127,7 @@ static int stm32_count_function_set(struct counter_device *counter,
 		sms = 3;
 		break;
 	default:
-		sms = 0;
-		break;
+		return -EINVAL;
 	}
 
 	/* Store enable status */
@@ -269,31 +275,36 @@ static int stm32_action_get(struct counter_device *counter,
 	size_t function;
 	int err;
 
-	/* Default action mode (e.g. STM32_COUNT_SLAVE_MODE_DISABLED) */
-	*action = STM32_SYNAPSE_ACTION_NONE;
-
 	err = stm32_count_function_get(counter, count, &function);
 	if (err)
-		return 0;
+		return err;
 
 	switch (function) {
+	case STM32_COUNT_SLAVE_MODE_DISABLED:
+		/* counts on internal clock when CEN=1 */
+		*action = STM32_SYNAPSE_ACTION_NONE;
+		return 0;
 	case STM32_COUNT_ENCODER_MODE_1:
 		/* counts up/down on TI1FP1 edge depending on TI2FP2 level */
 		if (synapse->signal->id == count->synapses[0].signal->id)
 			*action = STM32_SYNAPSE_ACTION_BOTH_EDGES;
-		break;
+		else
+			*action = STM32_SYNAPSE_ACTION_NONE;
+		return 0;
 	case STM32_COUNT_ENCODER_MODE_2:
 		/* counts up/down on TI2FP2 edge depending on TI1FP1 level */
 		if (synapse->signal->id == count->synapses[1].signal->id)
 			*action = STM32_SYNAPSE_ACTION_BOTH_EDGES;
-		break;
+		else
+			*action = STM32_SYNAPSE_ACTION_NONE;
+		return 0;
 	case STM32_COUNT_ENCODER_MODE_3:
 		/* counts up/down on both TI1FP1 and TI2FP2 edges */
 		*action = STM32_SYNAPSE_ACTION_BOTH_EDGES;
-		break;
+		return 0;
+	default:
+		return -EINVAL;
 	}
-
-	return 0;
 }
 
 static const struct counter_ops stm32_timer_cnt_ops = {
-- 
2.30.1



