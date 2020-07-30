Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B06D232EEE
	for <lists+stable@lfdr.de>; Thu, 30 Jul 2020 10:50:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728904AbgG3IuE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jul 2020 04:50:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726899AbgG3IuD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jul 2020 04:50:03 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA735C061794;
        Thu, 30 Jul 2020 01:50:02 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id e4so334495pjd.0;
        Thu, 30 Jul 2020 01:50:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=DA36TOmA1PD/0mCPsEB57TyuMgX2vtehFyCbtd+xX9k=;
        b=ksw7S/NPAiAINSHeIBvQ6xx3kDKrPMigAe4mWDNe93bFVHv4MNhgColtvNzsLrdW7y
         I1OPzUHZnguuNCRKWNhTr7oAMos5ffA/bshtdmOUOUDZeQ06itySQtY5ro6aF+KYraaI
         qbi7IN+7QIS0M4M398DkETASF+QwFn/J7U6NKjFs3EOP1xwKbZONX9jz90R/A3jd6PKP
         hcFBQGsYDWT6iFJnS7fhPnfOm3fSW4vPePkYappXmH9ISD95KUV/LoM9Xh6Tksv7X3zY
         X908v3+vEzZtjz0xMUOvEp6oUkGABZvUULI1R/oAViUkvrPiFMCV/PUUdO0Y8G4XCz8+
         Xyyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=DA36TOmA1PD/0mCPsEB57TyuMgX2vtehFyCbtd+xX9k=;
        b=s1qt7b+WUWJuPSGJNMjwfpGeWCVLy7wsTneEtiUv1UGeEQDhYy9z8/CLfAe2lnjIc5
         3ST+RaX/eH7v3I3acCpfjmoyQnUoK++RgcqsjFqCDnPV0+yDMrn+V31Sgx0CDjN4sc2c
         QqxaqnUOyo5CCUqiXlEl1l0KY+fyXiH7ZUbdLbKfRoddbEZEJehqDgUBtSC4CGdCaWfK
         Z+XKrKHFmKzTYblecsFfXgDw1QgOvzsYe++CZyBmA0GYTQ36yys824YMObD5Ko2xDMls
         nNjQrbXyFmffKuTq1tLaiuPg84wr/IS2MzpnjrdNBkS6gySFK8c+DuVNulwmFvKdWGGT
         u7Sg==
X-Gm-Message-State: AOAM533DCFDZLHSP4orSImY2a2fVJca0suOB6x/etTWdMy9HVTXoe+zA
        2+vXpgQDxGr0zk+3l8x2vq28Fgi/0G5VXA==
X-Google-Smtp-Source: ABdhPJz9v6NeQjzox+rx7h5LXULsrVjC3LdguJ0WsqR6YXy411sJ0g9t4JGD1EueJ22W5JcFFLbRTA==
X-Received: by 2002:a63:8ec7:: with SMTP id k190mr32558429pge.261.1596099002457;
        Thu, 30 Jul 2020 01:50:02 -0700 (PDT)
Received: from software.domain.org ([45.77.13.216])
        by smtp.gmail.com with ESMTPSA id m26sm5235345pff.84.2020.07.30.01.49.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 Jul 2020 01:50:01 -0700 (PDT)
From:   Huacai Chen <chenhc@lemote.com>
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <maz@kernel.org>, Rob Herring <robh+dt@kernel.org>
Cc:     linux-mips@vger.kernel.org, Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhc@lemote.com>, stable@vger.kernel.org
Subject: [PATCH V2 3/5] irqchip: loongson-liointc: Fix misuse of gc->mask_cache
Date:   Thu, 30 Jul 2020 16:51:28 +0800
Message-Id: <1596099090-23516-4-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1596099090-23516-1-git-send-email-chenhc@lemote.com>
References: <1596099090-23516-1-git-send-email-chenhc@lemote.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In gc->mask_cache bits, 1 means enabled and 0 means disabled, but in the
loongson-liointc driver mask_cache is misused by reverting its meaning.
This patch fix the bug and update the comments as well.

Fixes: dbb152267908c4b2c3639492a ("irqchip: Add driver for Loongson I/O Local Interrupt Controller")
Cc: stable@vger.kernel.org
Reviewed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Signed-off-by: Huacai Chen <chenhc@lemote.com>
---
 drivers/irqchip/irq-loongson-liointc.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/irqchip/irq-loongson-liointc.c b/drivers/irqchip/irq-loongson-liointc.c
index 63b6147..08165c5 100644
--- a/drivers/irqchip/irq-loongson-liointc.c
+++ b/drivers/irqchip/irq-loongson-liointc.c
@@ -60,7 +60,7 @@ static void liointc_chained_handle_irq(struct irq_desc *desc)
 	if (!pending) {
 		/* Always blame LPC IRQ if we have that bug */
 		if (handler->priv->has_lpc_irq_errata &&
-			(handler->parent_int_map & ~gc->mask_cache &
+			(handler->parent_int_map & gc->mask_cache &
 			BIT(LIOINTC_ERRATA_IRQ)))
 			pending = BIT(LIOINTC_ERRATA_IRQ);
 		else
@@ -131,11 +131,11 @@ static void liointc_resume(struct irq_chip_generic *gc)
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
 
@@ -243,7 +243,7 @@ int __init liointc_of_init(struct device_node *node,
 	ct->chip.irq_mask_ack = irq_gc_mask_disable_reg;
 	ct->chip.irq_set_type = liointc_set_type;
 
-	gc->mask_cache = 0xffffffff;
+	gc->mask_cache = 0;
 	priv->gc = gc;
 
 	for (i = 0; i < LIOINTC_NUM_PARENT; i++) {
-- 
2.7.0

