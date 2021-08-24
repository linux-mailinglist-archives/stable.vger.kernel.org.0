Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 239753F665A
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:22:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237478AbhHXRWw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:22:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:59744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240309AbhHXRUv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:20:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5549B61AFE;
        Tue, 24 Aug 2021 17:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824598;
        bh=vjhx9QaUF1cYhAou2qRTGUOQ/2gopYijrcJTqCGNfuU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SNm1alv9Mm2WvYQpiPZJFoP+urnNor4SRd54IhQhBVFucWTOjUhrhpF2lwYfzQoCW
         9E7xt9krSkm7PAyxjUAJxkhSkXcS/PKuD3tr/t8isuQlV4GXVZeeYOX1fC09/vthJT
         vhtAt1+aOQblDB5R0AXz20fSmegPC7xwSUd18sn5mEUevaXW3RkEHeNC07R8jL/bM7
         FLoKTiOi3EaC25AGwubytKn2nuB4K4nhojx7S6rYQjUPhmHjj/NN0ibx3a/Sz6HvmR
         Gu9H6tuq3HgzUc1FZ9j3LKYQr8tVqndJAICdOLb6i/55SAgIJK8dVooIsO7RlELRd5
         y7FA8OI15GiuQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.19 28/84] x86/ioapic: Force affinity setup before startup
Date:   Tue, 24 Aug 2021 13:01:54 -0400
Message-Id: <20210824170250.710392-29-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170250.710392-1-sashal@kernel.org>
References: <20210824170250.710392-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.205-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.205-rc1
X-KernelTest-Deadline: 2021-08-26T17:02+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit 0c0e37dc11671384e53ba6ede53a4d91162a2cc5 upstream.

The IO/APIC cannot handle interrupt affinity changes safely after startup
other than from an interrupt handler. The startup sequence in the generic
interrupt code violates that assumption.

Mark the irq chip with the new IRQCHIP_AFFINITY_PRE_STARTUP flag so that
the default interrupt setting happens before the interrupt is started up
for the first time.

Fixes: 18404756765c ("genirq: Expose default irq affinity mask (take 3)")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210729222542.832143400@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/apic/io_apic.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index a89dac380243..677508baf95a 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1958,7 +1958,8 @@ static struct irq_chip ioapic_chip __read_mostly = {
 	.irq_set_affinity	= ioapic_set_affinity,
 	.irq_retrigger		= irq_chip_retrigger_hierarchy,
 	.irq_get_irqchip_state	= ioapic_irq_get_chip_state,
-	.flags			= IRQCHIP_SKIP_SET_WAKE,
+	.flags			= IRQCHIP_SKIP_SET_WAKE |
+				  IRQCHIP_AFFINITY_PRE_STARTUP,
 };
 
 static struct irq_chip ioapic_ir_chip __read_mostly = {
@@ -1971,7 +1972,8 @@ static struct irq_chip ioapic_ir_chip __read_mostly = {
 	.irq_set_affinity	= ioapic_set_affinity,
 	.irq_retrigger		= irq_chip_retrigger_hierarchy,
 	.irq_get_irqchip_state	= ioapic_irq_get_chip_state,
-	.flags			= IRQCHIP_SKIP_SET_WAKE,
+	.flags			= IRQCHIP_SKIP_SET_WAKE |
+				  IRQCHIP_AFFINITY_PRE_STARTUP,
 };
 
 static inline void init_IO_APIC_traps(void)
-- 
2.30.2

