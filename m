Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B49EF4626EC
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 23:56:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235758AbhK2W7C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 17:59:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235012AbhK2W5r (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 17:57:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78A9CC048F53;
        Mon, 29 Nov 2021 10:40:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4142CB81630;
        Mon, 29 Nov 2021 18:40:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76C84C53FC7;
        Mon, 29 Nov 2021 18:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638211242;
        bh=RYljZMrYdPQ9JIic2NC++ZrvYCnRuNYnp6mKcrV2l6o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nCYrfnpFxJNCTkhBMpb+r7eS4/nGgH2sRAa2CTFCmhp066b+p7GkDgX4V6FUp3x62
         yxxez251JX9Vv+DigUEXzVzp9le4rUczKthCdgqHwPqti/KvT7Pp5Zjm4aEgz9WuwC
         LdFF8DTvDqkJGlutwKtCsn6aJ306Jc8psxK+QAwo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Elder <elder@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 121/179] net: ipa: directly disable ipa-setup-ready interrupt
Date:   Mon, 29 Nov 2021 19:18:35 +0100
Message-Id: <20211129181722.935693060@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Elder <elder@linaro.org>

[ Upstream commit 33a153100bb3459479bd95d3259c2915b53fefa8 ]

We currently maintain a "disabled" Boolean flag to determine whether
the "ipa-setup-ready" SMP2P IRQ handler does anything.  That flag
must be accessed under protection of a mutex.

Instead, disable the SMP2P interrupt when requested, which prevents
the interrupt handler from ever being called.  More importantly, it
synchronizes a thread disabling the interrupt with the completion of
the interrupt handler in case they run concurrently.

Use the IPA setup_complete flag rather than the disabled flag in the
handler to determine whether to ignore any interrupts arriving after
the first.

Rename the "disabled" flag to be "setup_disabled", to be specific
about its purpose.

Fixes: 530f9216a953 ("soc: qcom: ipa: AP/modem communications")
Signed-off-by: Alex Elder <elder@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ipa/ipa_smp2p.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ipa/ipa_smp2p.c b/drivers/net/ipa/ipa_smp2p.c
index df7639c39d716..24bc112a072c6 100644
--- a/drivers/net/ipa/ipa_smp2p.c
+++ b/drivers/net/ipa/ipa_smp2p.c
@@ -53,7 +53,7 @@
  * @setup_ready_irq:	IPA interrupt triggered by modem to signal GSI ready
  * @power_on:		Whether IPA power is on
  * @notified:		Whether modem has been notified of power state
- * @disabled:		Whether setup ready interrupt handling is disabled
+ * @setup_disabled:	Whether setup ready interrupt handler is disabled
  * @mutex:		Mutex protecting ready-interrupt/shutdown interlock
  * @panic_notifier:	Panic notifier structure
 */
@@ -67,7 +67,7 @@ struct ipa_smp2p {
 	u32 setup_ready_irq;
 	bool power_on;
 	bool notified;
-	bool disabled;
+	bool setup_disabled;
 	struct mutex mutex;
 	struct notifier_block panic_notifier;
 };
@@ -155,11 +155,9 @@ static irqreturn_t ipa_smp2p_modem_setup_ready_isr(int irq, void *dev_id)
 	struct device *dev;
 	int ret;
 
-	mutex_lock(&smp2p->mutex);
-
-	if (smp2p->disabled)
-		goto out_mutex_unlock;
-	smp2p->disabled = true;		/* If any others arrive, ignore them */
+	/* Ignore any (spurious) interrupts received after the first */
+	if (smp2p->ipa->setup_complete)
+		return IRQ_HANDLED;
 
 	/* Power needs to be active for setup */
 	dev = &smp2p->ipa->pdev->dev;
@@ -176,8 +174,6 @@ static irqreturn_t ipa_smp2p_modem_setup_ready_isr(int irq, void *dev_id)
 out_power_put:
 	pm_runtime_mark_last_busy(dev);
 	(void)pm_runtime_put_autosuspend(dev);
-out_mutex_unlock:
-	mutex_unlock(&smp2p->mutex);
 
 	return IRQ_HANDLED;
 }
@@ -322,7 +318,10 @@ void ipa_smp2p_disable(struct ipa *ipa)
 
 	mutex_lock(&smp2p->mutex);
 
-	smp2p->disabled = true;
+	if (!smp2p->setup_disabled) {
+		disable_irq(smp2p->setup_ready_irq);
+		smp2p->setup_disabled = true;
+	}
 
 	mutex_unlock(&smp2p->mutex);
 }
-- 
2.33.0



