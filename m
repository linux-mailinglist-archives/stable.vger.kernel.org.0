Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D9BB6E634E
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:39:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231754AbjDRMj2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:39:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231829AbjDRMj1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:39:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FE1713872
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:39:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C9DA8632EC
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:39:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8219C433EF;
        Tue, 18 Apr 2023 12:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681821565;
        bh=Dh0mpvG9Sy7u64XeR4kb8Q9jSntgUYXHrNWwxiNroLI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S2Lscn/57vEA3vrKuGLRNdqiVtkSsf3pvrHw1oZk9cx0EB1tNAC2GyFgLrGGk94lx
         LavcQV7YikLmwRX0c+gEscJWDfTZv1MaL9jvRoLxDcxuQhU2QL3dwL4c/mCxhlE7Ou
         /iz+ASzv/IwSwUd0a815iLcJOpjfO1DPOvXtopFU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Fabrice Gasnier <fabrice.gasnier@foss.st.com>,
        William Breathitt Gray <vilhelm.gray@gmail.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 50/91] counter: stm32-timer-cnt: Provide defines for slave mode selection
Date:   Tue, 18 Apr 2023 14:21:54 +0200
Message-Id: <20230418120307.317426243@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120305.520719816@linuxfoundation.org>
References: <20230418120305.520719816@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: William Breathitt Gray <vilhelm.gray@gmail.com>

[ Upstream commit ea434ff82649111de4fcabd76187270f8abdb63a ]

The STM32 timer permits configuration of the counter encoder mode via
the slave mode control register (SMCR) slave mode selection (SMS) bits.
This patch provides preprocessor defines for the supported encoder
modes.

Cc: Fabrice Gasnier <fabrice.gasnier@foss.st.com>
Signed-off-by: William Breathitt Gray <vilhelm.gray@gmail.com>
Reviewed-by: Fabrice Gasnier <fabrice.gasnier@foss.st.com>
Link: https://lore.kernel.org/r/ad3d9cd7af580d586316d368f74964cbc394f981.1630031207.git.vilhelm.gray@gmail.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Stable-dep-of: 00f4bc5184c1 ("counter: 104-quad-8: Fix Synapse action reported for Index signals")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/counter/stm32-timer-cnt.c | 16 ++++++++--------
 include/linux/mfd/stm32-timers.h  |  4 ++++
 2 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/counter/stm32-timer-cnt.c b/drivers/counter/stm32-timer-cnt.c
index 3fb0debd7425d..1fbc46f4ee66e 100644
--- a/drivers/counter/stm32-timer-cnt.c
+++ b/drivers/counter/stm32-timer-cnt.c
@@ -93,16 +93,16 @@ static int stm32_count_function_get(struct counter_device *counter,
 	regmap_read(priv->regmap, TIM_SMCR, &smcr);
 
 	switch (smcr & TIM_SMCR_SMS) {
-	case 0:
+	case TIM_SMCR_SMS_SLAVE_MODE_DISABLED:
 		*function = STM32_COUNT_SLAVE_MODE_DISABLED;
 		return 0;
-	case 1:
+	case TIM_SMCR_SMS_ENCODER_MODE_1:
 		*function = STM32_COUNT_ENCODER_MODE_1;
 		return 0;
-	case 2:
+	case TIM_SMCR_SMS_ENCODER_MODE_2:
 		*function = STM32_COUNT_ENCODER_MODE_2;
 		return 0;
-	case 3:
+	case TIM_SMCR_SMS_ENCODER_MODE_3:
 		*function = STM32_COUNT_ENCODER_MODE_3;
 		return 0;
 	default:
@@ -119,16 +119,16 @@ static int stm32_count_function_set(struct counter_device *counter,
 
 	switch (function) {
 	case STM32_COUNT_SLAVE_MODE_DISABLED:
-		sms = 0;
+		sms = TIM_SMCR_SMS_SLAVE_MODE_DISABLED;
 		break;
 	case STM32_COUNT_ENCODER_MODE_1:
-		sms = 1;
+		sms = TIM_SMCR_SMS_ENCODER_MODE_1;
 		break;
 	case STM32_COUNT_ENCODER_MODE_2:
-		sms = 2;
+		sms = TIM_SMCR_SMS_ENCODER_MODE_2;
 		break;
 	case STM32_COUNT_ENCODER_MODE_3:
-		sms = 3;
+		sms = TIM_SMCR_SMS_ENCODER_MODE_3;
 		break;
 	default:
 		return -EINVAL;
diff --git a/include/linux/mfd/stm32-timers.h b/include/linux/mfd/stm32-timers.h
index f8db83aedb2b5..5f5c43fd69ddd 100644
--- a/include/linux/mfd/stm32-timers.h
+++ b/include/linux/mfd/stm32-timers.h
@@ -82,6 +82,10 @@
 #define MAX_TIM_ICPSC		0x3
 #define TIM_CR2_MMS_SHIFT	4
 #define TIM_CR2_MMS2_SHIFT	20
+#define TIM_SMCR_SMS_SLAVE_MODE_DISABLED	0 /* counts on internal clock when CEN=1 */
+#define TIM_SMCR_SMS_ENCODER_MODE_1		1 /* counts TI1FP1 edges, depending on TI2FP2 level */
+#define TIM_SMCR_SMS_ENCODER_MODE_2		2 /* counts TI2FP2 edges, depending on TI1FP1 level */
+#define TIM_SMCR_SMS_ENCODER_MODE_3		3 /* counts on both TI1FP1 and TI2FP2 edges */
 #define TIM_SMCR_TS_SHIFT	4
 #define TIM_BDTR_BKF_MASK	0xF
 #define TIM_BDTR_BKF_SHIFT(x)	(16 + (x) * 4)
-- 
2.39.2



