Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D42E7265DD2
	for <lists+stable@lfdr.de>; Fri, 11 Sep 2020 12:27:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725812AbgIKK1c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Sep 2020 06:27:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725710AbgIKK13 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Sep 2020 06:27:29 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 789DCC061573;
        Fri, 11 Sep 2020 03:27:29 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id v14so168031pjd.4;
        Fri, 11 Sep 2020 03:27:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=lQt4U1iP+l97io+9Y7fL8PAkQ11+CExjcyqCQ8vCFRA=;
        b=uUcpqUl4J+axBPi2cfKLPmynySnRMfC5EpBgmWLEzxFSXrPj5+nKQLDVyX9VOCxhdk
         BdOEZS137xO92s4BG/U92Vhk3woMyqnpbzLRJag/igi73YRR5kpQf7OxO/BZga6KVbfA
         3P18XJDE1rWaKurScyWaFhWoa2ZSNFL04aR1j/iSzcKDd8plYusp8uyyrjAdX8kg/kvL
         W+WQddK1Vz4qFOAwvG0Y9FvaWrEdtVAHrmNZfnc0Bi2Bt7Gi31QQrKTCzI1CMvGpapkH
         Jf0665tj8Xuuyhx6VRKYmY4kQzY9C1f97PLS35ZdhA/XLaX5IJ6q+vZ0lrIKzmRaU13W
         8zKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=lQt4U1iP+l97io+9Y7fL8PAkQ11+CExjcyqCQ8vCFRA=;
        b=QKIcj5uI0SUECDi+/nTmVXMcxD/gYQPuPxBJgnATJQl73Pwu3jB61ILTNT698Qi3Kc
         SNOUyhU5JuQUcHGoVzVoAWo9us0EvIbM9DSpoA5Iccna/PdPogvfBDTY8Sn4E60axU6G
         bzOk+3xnzFeYLBVsZDSiN8b1tGQEdmrh41E6gPGpSqA9sKFm/YTldlD9OZk4EoRBWzwU
         1/pVCnDtXWP7C79XVWDLUu2+mbZXnmwEPyk8QbuYdav5b+7UjBKEvszKCBBa+1rXVa7f
         Fjx670XJY5JARgIw51/Z1+AtKMZPMJAlXN5SKRXbHt7iHlLW6/OLBZoY8SPuRdDbr7/c
         RzqA==
X-Gm-Message-State: AOAM531nUCXeNL32FJqva0OqZC5RgcPPX+UJb/4Cmn05Z1rB6xfmh65W
        EUbzJdvaeLma0CMe9wsbJRA=
X-Google-Smtp-Source: ABdhPJwcUR55ZC7FLF5EZfwaI9zLqj9zqxA7mzSfvZKiNBvZaiLTovujelILqFDHwGe/+eBswzad+A==
X-Received: by 2002:a17:90b:715:: with SMTP id s21mr1549243pjz.113.1599820049108;
        Fri, 11 Sep 2020 03:27:29 -0700 (PDT)
Received: from software.domain.org ([45.77.13.216])
        by smtp.gmail.com with ESMTPSA id j24sm1612727pjy.35.2020.09.11.03.27.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 11 Sep 2020 03:27:28 -0700 (PDT)
From:   Huacai Chen <chenhc@lemote.com>
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <maz@kernel.org>
Cc:     linux-mips@vger.kernel.org, Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhc@lemote.com>, stable@vger.kernel.org
Subject: [PATCH V2 2/2] irqchip/loongson-htvec: Fix initial interrupts clearing
Date:   Fri, 11 Sep 2020 18:26:18 +0800
Message-Id: <1599819978-13999-2-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1599819978-13999-1-git-send-email-chenhc@lemote.com>
References: <1599819978-13999-1-git-send-email-chenhc@lemote.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In htvec_reset() only the first group of initial interrupts is cleared.
This sometimes causes spurious interrupts, so let's clear all groups.

BTW, commit c47e388cfc648421bd821f ("irqchip/loongson-htvec: Support 8
groups of HT vectors") increase interrupt lines from 4 to 8, so update
comments as well.

Cc: stable@vger.kernel.org
Fixes: 818e915fbac518e8c78e1877 ("irqchip: Add Loongson HyperTransport Vector support")
Signed-off-by: Huacai Chen <chenhc@lemote.com>
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
-- 
2.7.0

