Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D82AE1A4082
	for <lists+stable@lfdr.de>; Fri, 10 Apr 2020 05:57:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728650AbgDJDtq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Apr 2020 23:49:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:33894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728644AbgDJDtp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Apr 2020 23:49:45 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 638E620936;
        Fri, 10 Apr 2020 03:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586490586;
        bh=skWxrDeaTk6+jv+cXjW6TzCDWVjh/oty9QB9S9uiJkE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CpzwYY7Gr48uD+s4goV7mgIAIPZ+b06Eh5mtKzADW7PYWkz1qltrkW6Zn+0npPmol
         SPg4Gu7+oR2fZ6L7X8zoH5kDsfKODaVV2VZIyt75483cWTCAdjr5Y+Aa0jQ1/19z+8
         wVIOusIk+fAoaDov9f8xXJIrr/TLAWYfIILzWVHc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Sverdlin <alexander.sverdlin@nokia.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 31/46] genirq/irqdomain: Check pointer in irq_domain_alloc_irqs_hierarchy()
Date:   Thu,  9 Apr 2020 23:48:54 -0400
Message-Id: <20200410034909.8922-31-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200410034909.8922-1-sashal@kernel.org>
References: <20200410034909.8922-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 480df36597206..c776b8e86fbcc 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -1293,6 +1293,11 @@ int irq_domain_alloc_irqs_hierarchy(struct irq_domain *domain,
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
 
@@ -1330,11 +1335,6 @@ int __irq_domain_alloc_irqs(struct irq_domain *domain, int irq_base,
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

