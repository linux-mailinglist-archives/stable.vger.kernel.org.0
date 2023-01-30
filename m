Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31E3068102B
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:01:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236864AbjA3OBK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:01:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236823AbjA3OBE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:01:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D15E239CC2
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:00:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B1FFE61047
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:00:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3A6CC433EF;
        Mon, 30 Jan 2023 14:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087214;
        bh=u/bHuEvwUY1kZpF0c9ICgUNpLJtKGMAKMohQXnpGcCY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Aj0Ub094D58t05Jw/wPCmxlVXGn3t4kQVv2udnDh7MYc8u4/wmlh/HR6/xq+c2/HK
         mNUUkUdoP4+PnODxL6SoJ2KI7+9RmBk+4MA6ffinuZlfr5j0V/PHw0AuhECr+FgrV5
         G949SdXgoZbNJCG5z3j3i8gSBQgJ9oP4t6B3dAfE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Caleb Connolly <caleb.connolly@linaro.org>,
        Alex Elder <elder@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 105/313] net: ipa: disable ipa interrupt during suspend
Date:   Mon, 30 Jan 2023 14:49:00 +0100
Message-Id: <20230130134341.531476705@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
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

From: Caleb Connolly <caleb.connolly@linaro.org>

[ Upstream commit 9ec9b2a30853ba843b70ea16f196e5fe3327be5f ]

The IPA interrupt can fire when pm_runtime is disabled due to it racing
with the PM suspend/resume code. This causes a splat in the interrupt
handler when it tries to call pm_runtime_get().

Explicitly disable the interrupt in our ->suspend callback, and
re-enable it in ->resume to avoid this. If there is an interrupt pending
it will be handled after resuming. The interrupt is a wake_irq, as a
result even when disabled if it fires it will cause the system to wake
from suspend as well as cancel any suspend transition that may be in
progress. If there is an interrupt pending, the ipa_isr_thread handler
will be called after resuming.

Fixes: 1aac309d3207 ("net: ipa: use autosuspend")
Signed-off-by: Caleb Connolly <caleb.connolly@linaro.org>
Reviewed-by: Alex Elder <elder@linaro.org>
Link: https://lore.kernel.org/r/20230115175925.465918-1-caleb.connolly@linaro.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ipa/ipa_interrupt.c | 10 ++++++++++
 drivers/net/ipa/ipa_interrupt.h | 16 ++++++++++++++++
 drivers/net/ipa/ipa_power.c     | 17 +++++++++++++++++
 3 files changed, 43 insertions(+)

diff --git a/drivers/net/ipa/ipa_interrupt.c b/drivers/net/ipa/ipa_interrupt.c
index c269432f9c2e..a89a3e3ff81c 100644
--- a/drivers/net/ipa/ipa_interrupt.c
+++ b/drivers/net/ipa/ipa_interrupt.c
@@ -127,6 +127,16 @@ static irqreturn_t ipa_isr_thread(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
+void ipa_interrupt_irq_disable(struct ipa *ipa)
+{
+	disable_irq(ipa->interrupt->irq);
+}
+
+void ipa_interrupt_irq_enable(struct ipa *ipa)
+{
+	enable_irq(ipa->interrupt->irq);
+}
+
 /* Common function used to enable/disable TX_SUSPEND for an endpoint */
 static void ipa_interrupt_suspend_control(struct ipa_interrupt *interrupt,
 					  u32 endpoint_id, bool enable)
diff --git a/drivers/net/ipa/ipa_interrupt.h b/drivers/net/ipa/ipa_interrupt.h
index f31fd9965fdc..8a1bd5b89393 100644
--- a/drivers/net/ipa/ipa_interrupt.h
+++ b/drivers/net/ipa/ipa_interrupt.h
@@ -85,6 +85,22 @@ void ipa_interrupt_suspend_clear_all(struct ipa_interrupt *interrupt);
  */
 void ipa_interrupt_simulate_suspend(struct ipa_interrupt *interrupt);
 
+/**
+ * ipa_interrupt_irq_enable() - Enable IPA interrupts
+ * @ipa:	IPA pointer
+ *
+ * This enables the IPA interrupt line
+ */
+void ipa_interrupt_irq_enable(struct ipa *ipa);
+
+/**
+ * ipa_interrupt_irq_disable() - Disable IPA interrupts
+ * @ipa:	IPA pointer
+ *
+ * This disables the IPA interrupt line
+ */
+void ipa_interrupt_irq_disable(struct ipa *ipa);
+
 /**
  * ipa_interrupt_config() - Configure the IPA interrupt framework
  * @ipa:	IPA pointer
diff --git a/drivers/net/ipa/ipa_power.c b/drivers/net/ipa/ipa_power.c
index 8420f93128a2..8057be8cda80 100644
--- a/drivers/net/ipa/ipa_power.c
+++ b/drivers/net/ipa/ipa_power.c
@@ -181,6 +181,17 @@ static int ipa_suspend(struct device *dev)
 
 	__set_bit(IPA_POWER_FLAG_SYSTEM, ipa->power->flags);
 
+	/* Increment the disable depth to ensure that the IRQ won't
+	 * be re-enabled until the matching _enable call in
+	 * ipa_resume(). We do this to ensure that the interrupt
+	 * handler won't run whilst PM runtime is disabled.
+	 *
+	 * Note that disabling the IRQ is NOT the same as disabling
+	 * irq wake. If wakeup is enabled for the IPA then the IRQ
+	 * will still cause the system to wake up, see irq_set_irq_wake().
+	 */
+	ipa_interrupt_irq_disable(ipa);
+
 	return pm_runtime_force_suspend(dev);
 }
 
@@ -193,6 +204,12 @@ static int ipa_resume(struct device *dev)
 
 	__clear_bit(IPA_POWER_FLAG_SYSTEM, ipa->power->flags);
 
+	/* Now that PM runtime is enabled again it's safe
+	 * to turn the IRQ back on and process any data
+	 * that was received during suspend.
+	 */
+	ipa_interrupt_irq_enable(ipa);
+
 	return ret;
 }
 
-- 
2.39.0



