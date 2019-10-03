Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4969CCA9BB
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:21:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392974AbfJCQq5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:46:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:60372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392971AbfJCQq5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:46:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E1A1921848;
        Thu,  3 Oct 2019 16:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570121216;
        bh=UcXwOX4Q3s/OeMb0P6GUol/4vmnAyQo333LJD65XGZo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K29SN5ZyeYUgV4Xlta0I32EWE/37DpoS74ob2V+goolXo/RE7UPgOlMAbtdIDL7P7
         JYcZBnFRXVs5wnN4X7ZbhzBd8xINR4L3PN9gGr5odsdMBjVcjbLxDM5+MVyvoL5gbc
         l69sjmZTf6yayJisIFMl0ocdEYocZD45T1shchBo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Marc Zyngier <maz@kernel.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 198/344] irqchip/sifive-plic: set max threshold for ignored handlers
Date:   Thu,  3 Oct 2019 17:52:43 +0200
Message-Id: <20191003154559.755455322@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154540.062170222@linuxfoundation.org>
References: <20191003154540.062170222@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 9ce06497c2722a0f9109e4cc3ce35b7a69617886 ]

When running in M-mode, the S-mode plic handlers are still listed in the
device tree.  Ignore them by setting the maximum threshold.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Paul Walmsley <paul.walmsley@sifive.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-sifive-plic.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/irqchip/irq-sifive-plic.c b/drivers/irqchip/irq-sifive-plic.c
index cf755964f2f8b..c72c036aea768 100644
--- a/drivers/irqchip/irq-sifive-plic.c
+++ b/drivers/irqchip/irq-sifive-plic.c
@@ -244,6 +244,7 @@ static int __init plic_init(struct device_node *node,
 		struct plic_handler *handler;
 		irq_hw_number_t hwirq;
 		int cpu, hartid;
+		u32 threshold = 0;
 
 		if (of_irq_parse_one(node, i, &parent)) {
 			pr_err("failed to parse parent for context %d.\n", i);
@@ -266,10 +267,16 @@ static int __init plic_init(struct device_node *node,
 			continue;
 		}
 
+		/*
+		 * When running in M-mode we need to ignore the S-mode handler.
+		 * Here we assume it always comes later, but that might be a
+		 * little fragile.
+		 */
 		handler = per_cpu_ptr(&plic_handlers, cpu);
 		if (handler->present) {
 			pr_warn("handler already present for context %d.\n", i);
-			continue;
+			threshold = 0xffffffff;
+			goto done;
 		}
 
 		handler->present = true;
@@ -279,8 +286,9 @@ static int __init plic_init(struct device_node *node,
 		handler->enable_base =
 			plic_regs + ENABLE_BASE + i * ENABLE_PER_HART;
 
+done:
 		/* priority must be > threshold to trigger an interrupt */
-		writel(0, handler->hart_base + CONTEXT_THRESHOLD);
+		writel(threshold, handler->hart_base + CONTEXT_THRESHOLD);
 		for (hwirq = 1; hwirq <= nr_irqs; hwirq++)
 			plic_toggle(handler, hwirq, 0);
 		nr_handlers++;
-- 
2.20.1



