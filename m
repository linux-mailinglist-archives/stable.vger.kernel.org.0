Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 659D628A8C1
	for <lists+stable@lfdr.de>; Sun, 11 Oct 2020 19:58:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730322AbgJKR6b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Oct 2020 13:58:31 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:40228 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388512AbgJKR5r (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Oct 2020 13:57:47 -0400
Date:   Sun, 11 Oct 2020 17:57:44 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1602439065;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BF0Ze4dvqMf0pTwdJ5HFaX1ph4Dhew8fG0GpRsWS0N8=;
        b=rEM8akXbI0/FmpUMJcoK7tv3l1aZC1d8K4qfKlKnKPT9pZIiUcHKCAGsBCLXHJteIEbcNT
        n1wotxb3G+ZJ4rq2GGWDeXijneTwWS/dVAQvNaqcZOdUlhIiB9sqqMZcPzZCbDkDUuUbA3
        uEMFKoP80re4FHBjnEemth+F300NsFj1DDjBO6bm3RPXQ6a5uEf6Mjca44TRzVzWR3xOcA
        x70C3uOtCZ6PvcdDn5SgwBR+e/09hFzpX7QS2kTS5nxfNPy1t2oGj3s3thEV89LhHO/q9E
        0dlExkTn9PwQOsLahLnRYn6EdBWL1THncgteRr8X+v8Qudu44JTM/yv5jjAOGA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1602439065;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BF0Ze4dvqMf0pTwdJ5HFaX1ph4Dhew8fG0GpRsWS0N8=;
        b=KmCVLgmSBO/DAYwKRzSoSFsD7gcUwUOExUCGmN+XjzhF1UE/pwB2CH1SnL2zXNKUr07RvZ
        rUYV8ybE5Z2+3fCQ==
From:   "tip-bot2 for Huacai Chen" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: irq/core] irqchip/loongson-htvec: Fix initial interrupt clearing
Cc:     Huacai Chen <chenhc@lemote.com>, Marc Zyngier <maz@kernel.org>,
        stable@vger.kernel.org, x86 <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1599819978-13999-2-git-send-email-chenhc@lemote.com>
References: <1599819978-13999-2-git-send-email-chenhc@lemote.com>
MIME-Version: 1.0
Message-ID: <160243906476.7002.12870041209542641118.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the irq/core branch of tip:

Commit-ID:     1d1e5630de78f7253ac24b92cee6427c3ff04d56
Gitweb:        https://git.kernel.org/tip/1d1e5630de78f7253ac24b92cee6427c3ff04d56
Author:        Huacai Chen <chenhc@lemote.com>
AuthorDate:    Fri, 11 Sep 2020 18:26:18 +08:00
Committer:     Marc Zyngier <maz@kernel.org>
CommitterDate: Sun, 13 Sep 2020 15:30:11 +01:00

irqchip/loongson-htvec: Fix initial interrupt clearing

In htvec_reset() only the first group of initial interrupts is cleared.
This sometimes causes spurious interrupts, so let's clear all groups.

While at it, fix the nearby comment that to match the reality of what
the driver does.

Fixes: 818e915fbac518e8c78e1877 ("irqchip: Add Loongson HyperTransport Vector support")
Signed-off-by: Huacai Chen <chenhc@lemote.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/1599819978-13999-2-git-send-email-chenhc@lemote.com
---
 drivers/irqchip/irq-loongson-htvec.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/irqchip/irq-loongson-htvec.c b/drivers/irqchip/irq-loongson-htvec.c
index 13e6016..6392aaf 100644
--- a/drivers/irqchip/irq-loongson-htvec.c
+++ b/drivers/irqchip/irq-loongson-htvec.c
@@ -151,7 +151,7 @@ static void htvec_reset(struct htvec *priv)
 	/* Clear IRQ cause registers, mask all interrupts */
 	for (idx = 0; idx < priv->num_parents; idx++) {
 		writel_relaxed(0x0, priv->base + HTVEC_EN_OFF + 4 * idx);
-		writel_relaxed(0xFFFFFFFF, priv->base);
+		writel_relaxed(0xFFFFFFFF, priv->base + 4 * idx);
 	}
 }
 
@@ -172,7 +172,7 @@ static int htvec_of_init(struct device_node *node,
 		goto free_priv;
 	}
 
-	/* Interrupt may come from any of the 4 interrupt line */
+	/* Interrupt may come from any of the 8 interrupt lines */
 	for (i = 0; i < HTVEC_MAX_PARENT_IRQ; i++) {
 		parent_irq[i] = irq_of_parse_and_map(node, i);
 		if (parent_irq[i] <= 0)
