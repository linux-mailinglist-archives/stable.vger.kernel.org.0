Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 458681AC805
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 17:03:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438461AbgDPPC1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 11:02:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:40462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2897322AbgDPNx4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:53:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2198520786;
        Thu, 16 Apr 2020 13:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587045234;
        bh=mcarTea389bGCU4AeNAGzi63sMO8C9NpkXvFyMsQhU4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y6vdi9rqv/2O420lH6I6T0JUHuAexpHJ6VTzhV0Knz6AeCP7gyR4tWnsktJV4tQqe
         hiDRR7Y+nDvm42PrnXyqnhlztEtYAhtYQqY/YuBHSXkEhV6dqWWRKUPrDKQGen25bA
         Tw90nHbAUsBuXQ8dWMlC/OgIC/9pNZMsK8ZNiyIs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Sverdlin <alexander.sverdlin@nokia.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 049/254] genirq/irqdomain: Check pointer in irq_domain_alloc_irqs_hierarchy()
Date:   Thu, 16 Apr 2020 15:22:18 +0200
Message-Id: <20200416131332.014571203@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.804095985@linuxfoundation.org>
References: <20200416131325.804095985@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Sverdlin <alexander.sverdlin@nokia.com>

[ Upstream commit 87f2d1c662fa1761359fdf558246f97e484d177a ]

irq_domain_alloc_irqs_hierarchy() has 3 call sites in the compilation unit
but only one of them checks for the pointer which is being dereferenced
inside the called function. Move the check into the function. This allows
for catching the error instead of the following crash:

Unable to handle kernel NULL pointer dereference at virtual address 00000000
PC is at 0x0
LR is at gpiochip_hierarchy_irq_domain_alloc+0x11f/0x140
...
[<c06c23ff>] (gpiochip_hierarchy_irq_domain_alloc)
[<c0462a89>] (__irq_domain_alloc_irqs)
[<c0462dad>] (irq_create_fwspec_mapping)
[<c06c2251>] (gpiochip_to_irq)
[<c06c1c9b>] (gpiod_to_irq)
[<bf973073>] (gpio_irqs_init [gpio_irqs])
[<bf974048>] (gpio_irqs_exit+0xecc/0xe84 [gpio_irqs])
Code: bad PC value

Signed-off-by: Alexander Sverdlin <alexander.sverdlin@nokia.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lkml.kernel.org/r/20200306174720.82604-1-alexander.sverdlin@nokia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/irq/irqdomain.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 7527e5ef6fe59..64507c663563f 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -1310,6 +1310,11 @@ int irq_domain_alloc_irqs_hierarchy(struct irq_domain *domain,
 				    unsigned int irq_base,
 				    unsigned int nr_irqs, void *arg)
 {
+	if (!domain->ops->alloc) {
+		pr_debug("domain->ops->alloc() is NULL\n");
+		return -ENOSYS;
+	}
+
 	return domain->ops->alloc(domain, irq_base, nr_irqs, arg);
 }
 
@@ -1347,11 +1352,6 @@ int __irq_domain_alloc_irqs(struct irq_domain *domain, int irq_base,
 			return -EINVAL;
 	}
 
-	if (!domain->ops->alloc) {
-		pr_debug("domain->ops->alloc() is NULL\n");
-		return -ENOSYS;
-	}
-
 	if (realloc && irq_base >= 0) {
 		virq = irq_base;
 	} else {
-- 
2.20.1



