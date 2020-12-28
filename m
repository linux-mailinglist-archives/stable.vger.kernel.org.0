Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C663C2E3C04
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:57:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406727AbgL1N5f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:57:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:59186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406728AbgL1N5f (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:57:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B9E85206D4;
        Mon, 28 Dec 2020 13:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163814;
        bh=nVSzycZt+EukXHEr+gvwkZdSZQA/LEWomxafvatUCB8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cK2kjrn3sKgrm3SDPR7jyx+fs+YNNOFP31V40kiAB+evipMbQjSOxPT3LvF0yLmcd
         /JmNWWhSNVgUEQiC9DwF++LNL2zvS9mwKic5nILh58zoxUhkL83/hx4zQwFjV9ziQE
         gEpmnfuvkhHBQQDqed5VbQRh7bIsrDonOifOUm+c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Evan Green <evgreen@chromium.org>
Subject: [PATCH 5.4 417/453] soc: qcom: smp2p: Safely acquire spinlock without IRQs
Date:   Mon, 28 Dec 2020 13:50:53 +0100
Message-Id: <20201228124957.285923389@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Evan Green <evgreen@chromium.org>

commit fc3e62e25c3896855b7c3d72df19ca6be3459c9f upstream.

smp2p_update_bits() should disable interrupts when it acquires its
spinlock. This is important because without the _irqsave, a priority
inversion can occur.

This function is called both with interrupts enabled in
qcom_q6v5_request_stop(), and with interrupts disabled in
ipa_smp2p_panic_notifier(). IRQ handling of spinlocks should be
consistent to avoid the panic notifier deadlocking because it's
sitting on the thread that's already got the lock via _request_stop().

Found via lockdep.

Cc: stable@vger.kernel.org
Fixes: 50e99641413e7 ("soc: qcom: smp2p: Qualcomm Shared Memory Point to Point")
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Evan Green <evgreen@chromium.org>
Link: https://lore.kernel.org/r/20200929133040.RESEND.1.Ideabf6dcdfc577cf39ce3d95b0e4aa1ac8b38f0c@changeid
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/soc/qcom/smp2p.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/soc/qcom/smp2p.c
+++ b/drivers/soc/qcom/smp2p.c
@@ -318,15 +318,16 @@ static int qcom_smp2p_inbound_entry(stru
 static int smp2p_update_bits(void *data, u32 mask, u32 value)
 {
 	struct smp2p_entry *entry = data;
+	unsigned long flags;
 	u32 orig;
 	u32 val;
 
-	spin_lock(&entry->lock);
+	spin_lock_irqsave(&entry->lock, flags);
 	val = orig = readl(entry->value);
 	val &= ~mask;
 	val |= value;
 	writel(val, entry->value);
-	spin_unlock(&entry->lock);
+	spin_unlock_irqrestore(&entry->lock, flags);
 
 	if (val != orig)
 		qcom_smp2p_kick(entry->smp2p);


