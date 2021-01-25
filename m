Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7D483033C8
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 06:06:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731268AbhAZFFS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 00:05:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:40802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731349AbhAYSyx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:54:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A84A520719;
        Mon, 25 Jan 2021 18:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600877;
        bh=Iqkim9Tke3vfh6w9wCbohMg7M92Z7603lIU1bYQTz3A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hR/TnG8e3NKC4ksTZ38nhWZe2UIhVe6Y+PT+UXlZcNydSfoAOE/fWDdgCycJ0HAGu
         ad2f8kATJtyFBbzZ0HU3/ebpxJ0dCTxK75d/4H1pwO6TP6V060MxLHbzsftF1jcpVG
         blKZ6motoNCtSKjlcmnZAcG9poHIkJRsv0WVRT1I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Douglas Anderson <dianders@chromium.org>,
        Maulik Shah <mkshah@codeaurora.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.10 184/199] pinctrl: qcom: No need to read-modify-write the interrupt status
Date:   Mon, 25 Jan 2021 19:40:06 +0100
Message-Id: <20210125183223.945998725@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Douglas Anderson <dianders@chromium.org>

commit 4079d35fa4fca4ee0ffd66968312fc86a5e8c290 upstream.

When the Qualcomm pinctrl driver wants to Ack an interrupt, it does a
read-modify-write on the interrupt status register.  On some SoCs it
makes sure that the status bit is 1 to "Ack" and on others it makes
sure that the bit is 0 to "Ack".  Presumably the first type of
interrupt controller is a "write 1 to clear" type register and the
second just let you directly set the interrupt status register.

As far as I can tell from scanning structure definitions, the
interrupt status bit is always in a register by itself.  Thus with
both types of interrupt controllers it is safe to "Ack" interrupts
without doing a read-modify-write.  We can do a simple write.

It should be noted that if the interrupt status bit _was_ ever in a
register with other things (like maybe status bits for other GPIOs):
a) For "write 1 clear" type controllers then read-modify-write would
   be totally wrong because we'd accidentally end up clearing
   interrupts we weren't looking at.
b) For "direct set" type controllers then read-modify-write would also
   be wrong because someone setting one of the other bits in the
   register might accidentally clear (or set) our interrupt.
I say this simply to show that the current read-modify-write doesn't
provide any sort of "future proofing" of the code.  In fact (for
"write 1 clear" controllers) the new code is slightly more "future
proof" since it would allow more than one interrupt status bits to
share a register.

NOTE: this code fixes no bugs--it simply avoids an extra register
read.

Signed-off-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Maulik Shah <mkshah@codeaurora.org>
Tested-by: Maulik Shah <mkshah@codeaurora.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20210114191601.v7.2.I3635de080604e1feda770591c5563bd6e63dd39d@changeid
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pinctrl/qcom/pinctrl-msm.c |   23 ++++++++---------------
 1 file changed, 8 insertions(+), 15 deletions(-)

--- a/drivers/pinctrl/qcom/pinctrl-msm.c
+++ b/drivers/pinctrl/qcom/pinctrl-msm.c
@@ -791,16 +791,13 @@ static void msm_gpio_irq_clear_unmask(st
 
 	raw_spin_lock_irqsave(&pctrl->lock, flags);
 
-	if (status_clear) {
-		/*
-		 * clear the interrupt status bit before unmask to avoid
-		 * any erroneous interrupts that would have got latched
-		 * when the interrupt is not in use.
-		 */
-		val = msm_readl_intr_status(pctrl, g);
-		val &= ~BIT(g->intr_status_bit);
-		msm_writel_intr_status(val, pctrl, g);
-	}
+	/*
+	 * clear the interrupt status bit before unmask to avoid
+	 * any erroneous interrupts that would have got latched
+	 * when the interrupt is not in use.
+	 */
+	if (status_clear)
+		msm_writel_intr_status(0, pctrl, g);
 
 	val = msm_readl_intr_cfg(pctrl, g);
 	val |= BIT(g->intr_raw_status_bit);
@@ -905,11 +902,7 @@ static void msm_gpio_irq_ack(struct irq_
 
 	raw_spin_lock_irqsave(&pctrl->lock, flags);
 
-	val = msm_readl_intr_status(pctrl, g);
-	if (g->intr_ack_high)
-		val |= BIT(g->intr_status_bit);
-	else
-		val &= ~BIT(g->intr_status_bit);
+	val = g->intr_ack_high ? BIT(g->intr_status_bit) : 0;
 	msm_writel_intr_status(val, pctrl, g);
 
 	if (test_bit(d->hwirq, pctrl->dual_edge_irqs))


