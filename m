Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8605F4094DE
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:35:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345345AbhIMOgH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:36:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:51240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345904AbhIMOdQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:33:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E9D1C6137C;
        Mon, 13 Sep 2021 13:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631541155;
        bh=92VlfVONk7XtZ4VLYb1V6TBE5RSZxNPQllZl6+L+/kE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WWO5yTp82I0v/41kv4OpmeU2yPkl+fk6ubsCRqBTMdHFKX2ouPFw7iFYRhalX2RNC
         cnalVCqw+chT/da1kUMMcvMuOgxob9IwAyOrZmu8pa9CRlHvbnvLFST+CVsXKBbNkD
         jeuNSYxB5oHtOWyASkY4DeNXGxF+u7kY1dM6KtKg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephan Gerhold <stephan@gerhold.net>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 168/334] soc: qcom: smsm: Fix missed interrupts if state changes while masked
Date:   Mon, 13 Sep 2021 15:13:42 +0200
Message-Id: <20210913131119.021142341@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephan Gerhold <stephan@gerhold.net>

[ Upstream commit e3d4571955050736bbf3eda0a9538a09d9fcfce8 ]

The SMSM driver detects interrupt edges by tracking the last state
it has seen (and has triggered the interrupt handler for). This works
fine, but only if the interrupt does not change state while masked.

For example, if an interrupt is unmasked while the state is HIGH,
the stored last_value for that interrupt might still be LOW. Then,
when the remote processor triggers smsm_intr() we assume that nothing
has changed, even though the state might have changed from HIGH to LOW.

Attempt to fix this by checking the current remote state before
unmasking an IRQ. Use atomic operations to avoid the interrupt handler
from interfering with the unmask function.

This fixes modem crashes in some edge cases with the BAM-DMUX driver.
Specifically, the BAM-DMUX interrupt handler is not called for the
HIGH -> LOW smsm state transition if the BAM-DMUX driver is loaded
(and therefore unmasks the interrupt) after the modem was already started:

qcom-q6v5-mss 4080000.remoteproc: fatal error received: a2_task.c:3188:
  Assert FALSE failed: A2 DL PER deadlock timer expired waiting for Apps ACK

Fixes: c97c4090ff72 ("soc: qcom: smsm: Add driver for Qualcomm SMSM")
Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
Link: https://lore.kernel.org/r/20210712135703.324748-2-stephan@gerhold.net
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/smsm.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/soc/qcom/smsm.c b/drivers/soc/qcom/smsm.c
index 1d3d5e3ec2b0..6e9a9cd28b17 100644
--- a/drivers/soc/qcom/smsm.c
+++ b/drivers/soc/qcom/smsm.c
@@ -109,7 +109,7 @@ struct smsm_entry {
 	DECLARE_BITMAP(irq_enabled, 32);
 	DECLARE_BITMAP(irq_rising, 32);
 	DECLARE_BITMAP(irq_falling, 32);
-	u32 last_value;
+	unsigned long last_value;
 
 	u32 *remote_state;
 	u32 *subscription;
@@ -204,8 +204,7 @@ static irqreturn_t smsm_intr(int irq, void *data)
 	u32 val;
 
 	val = readl(entry->remote_state);
-	changed = val ^ entry->last_value;
-	entry->last_value = val;
+	changed = val ^ xchg(&entry->last_value, val);
 
 	for_each_set_bit(i, entry->irq_enabled, 32) {
 		if (!(changed & BIT(i)))
@@ -264,6 +263,12 @@ static void smsm_unmask_irq(struct irq_data *irqd)
 	struct qcom_smsm *smsm = entry->smsm;
 	u32 val;
 
+	/* Make sure our last cached state is up-to-date */
+	if (readl(entry->remote_state) & BIT(irq))
+		set_bit(irq, &entry->last_value);
+	else
+		clear_bit(irq, &entry->last_value);
+
 	set_bit(irq, entry->irq_enabled);
 
 	if (entry->subscription) {
-- 
2.30.2



