Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5648A262620
	for <lists+stable@lfdr.de>; Wed,  9 Sep 2020 06:13:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725864AbgIIENX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Sep 2020 00:13:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725767AbgIIENX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Sep 2020 00:13:23 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 955F5C061573;
        Tue,  8 Sep 2020 21:13:22 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id s2so684541pjr.4;
        Tue, 08 Sep 2020 21:13:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=lQt4U1iP+l97io+9Y7fL8PAkQ11+CExjcyqCQ8vCFRA=;
        b=p/blGdmgrz0MGuPluJGs7YvUAd2rUGzhj8WK8QU/Vrp15gpsz2ZDSErz4eQk3ysmHt
         Zpr9kiZrJCnLlOQXwwX4HLdicnMQDscdRPsOMRMLkbpmx0K0dhal3ud8p+zTRBL2hvEE
         be6hcg2uXQ7LnKu0tUy2+64AxLmnajdcQEv0z1Ce2kP36dQ/cjug5X6dHwoz0I7bqU1l
         G7NpwDBvq+VBIpVmtChaLtTPv5vKFXin5sWLBT/28FCnazHm4lshFP+vqr95qQCx0Gl5
         DxlbY0FLDiOMy63+oJ5Uvtn7vEeqgQ7j+nLLM92T+yCn9uTWqtAxkl5Ff4pEvp9mWcAO
         1U4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=lQt4U1iP+l97io+9Y7fL8PAkQ11+CExjcyqCQ8vCFRA=;
        b=FWQqfP1qAILTSCj8b8t9AsD1KPLp9StapSE2GclDfxBWraEA9n15LkwV08JgGx327o
         FhciVd3Lk/F7xVNbPSVtM/3hldReIPgH7FenvZbr8HeXGUK2GprZbaknSqL0KUnmb25u
         AmdiIeAj4Uk6WzoVrkAJTToil7Thj9P+Wuw7HIZKrPJRclgPNhAFTGfcAjVptx1S3LJC
         L9L/bVlLHlf4PQBzr2OCIHGS81JhDbua3PPqxOQTvsJuDvvOBDWkElXQmLFeYCHujC3H
         nMSGBO5XaDAQfEUaNp2DIQQf8XTQDAFIYr0qpjasjh3Ol6SX6zwtqiR2FEzsUqMgTBKc
         XcaQ==
X-Gm-Message-State: AOAM532DQDpddijSL1BaPhX8KcJY+UmjeBv7Wd2GV5qL4N7fYu6flAq/
        /nMOHsI5x/HR9Oomk9RonkrbJRs5IOVFdQ==
X-Google-Smtp-Source: ABdhPJx/6uvrGfCJFnrWEzdkdqWFXBlq0UAQBBHMZpi+zIyrSZAzrQ2ko6Y93CVNfPZSoPRDzvO68g==
X-Received: by 2002:a17:90b:20a:: with SMTP id fy10mr1923767pjb.209.1599624802211;
        Tue, 08 Sep 2020 21:13:22 -0700 (PDT)
Received: from software.domain.org ([45.77.13.216])
        by smtp.gmail.com with ESMTPSA id m7sm901436pfm.31.2020.09.08.21.13.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Sep 2020 21:13:21 -0700 (PDT)
From:   Huacai Chen <chenhc@lemote.com>
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <maz@kernel.org>
Cc:     linux-mips@vger.kernel.org, Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhc@lemote.com>, stable@vger.kernel.org
Subject: [PATCH 2/3] irqchip/loongson-htvec: Fix initial interrupts clearing
Date:   Wed,  9 Sep 2020 12:09:11 +0800
Message-Id: <1599624552-17523-2-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1599624552-17523-1-git-send-email-chenhc@lemote.com>
References: <1599624552-17523-1-git-send-email-chenhc@lemote.com>
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

