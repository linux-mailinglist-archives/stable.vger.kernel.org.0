Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EF0524B2CB
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 11:37:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728683AbgHTJhF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 05:37:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:52842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728649AbgHTJhE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:37:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A29120724;
        Thu, 20 Aug 2020 09:37:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597916223;
        bh=ov1CrJpVQeLLIsOKM+hyYHl1kAdRmAxP2gMG4EbotJ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UNM8WVprMuxf7LjDHupMpn+4L3V0GDDUpQEOdDGkTaW2iwqEkE05yoplMgA1ZOgsR
         BFlJ+aNZ78vyMQNa9PAeyqsfvdnYbkFRxrvkrdq4/wUPJjV7wv6NUI3jehjAw/Bdvp
         lDjYXKNLDgPeEhrfM3Z+Lrjlz2bsLRxpm0a2nrY4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Huacai Chen <chenhc@lemote.com>,
        Marc Zyngier <maz@kernel.org>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>
Subject: [PATCH 5.7 053/204] irqchip/loongson-liointc: Fix misuse of gc->mask_cache
Date:   Thu, 20 Aug 2020 11:19:10 +0200
Message-Id: <20200820091608.924942423@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091606.194320503@linuxfoundation.org>
References: <20200820091606.194320503@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Huacai Chen <chenhc@lemote.com>

commit c9c73a05413ea4a465cae1cb3593b01b190a233f upstream.

In gc->mask_cache bits, 1 means enabled and 0 means disabled, but in the
loongson-liointc driver mask_cache is misused by reverting its meaning.
This patch fix the bug and update the comments as well.

Fixes: dbb152267908c4b2c3639492a ("irqchip: Add driver for Loongson I/O Local Interrupt Controller")
Signed-off-by: Huacai Chen <chenhc@lemote.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/1596099090-23516-4-git-send-email-chenhc@lemote.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/irqchip/irq-loongson-liointc.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/irqchip/irq-loongson-liointc.c
+++ b/drivers/irqchip/irq-loongson-liointc.c
@@ -60,7 +60,7 @@ static void liointc_chained_handle_irq(s
 	if (!pending) {
 		/* Always blame LPC IRQ if we have that bug */
 		if (handler->priv->has_lpc_irq_errata &&
-			(handler->parent_int_map & ~gc->mask_cache &
+			(handler->parent_int_map & gc->mask_cache &
 			BIT(LIOINTC_ERRATA_IRQ)))
 			pending = BIT(LIOINTC_ERRATA_IRQ);
 		else
@@ -132,11 +132,11 @@ static void liointc_resume(struct irq_ch
 	irq_gc_lock_irqsave(gc, flags);
 	/* Disable all at first */
 	writel(0xffffffff, gc->reg_base + LIOINTC_REG_INTC_DISABLE);
-	/* Revert map cache */
+	/* Restore map cache */
 	for (i = 0; i < LIOINTC_CHIP_IRQ; i++)
 		writeb(priv->map_cache[i], gc->reg_base + i);
-	/* Revert mask cache */
-	writel(~gc->mask_cache, gc->reg_base + LIOINTC_REG_INTC_ENABLE);
+	/* Restore mask cache */
+	writel(gc->mask_cache, gc->reg_base + LIOINTC_REG_INTC_ENABLE);
 	irq_gc_unlock_irqrestore(gc, flags);
 }
 
@@ -244,7 +244,7 @@ int __init liointc_of_init(struct device
 	ct->chip.irq_mask_ack = irq_gc_mask_disable_reg;
 	ct->chip.irq_set_type = liointc_set_type;
 
-	gc->mask_cache = 0xffffffff;
+	gc->mask_cache = 0;
 	priv->gc = gc;
 
 	for (i = 0; i < LIOINTC_NUM_PARENT; i++) {


