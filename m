Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5589125A91E
	for <lists+stable@lfdr.de>; Wed,  2 Sep 2020 12:08:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726140AbgIBKIb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Sep 2020 06:08:31 -0400
Received: from foss.arm.com ([217.140.110.172]:34846 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726285AbgIBKI3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 2 Sep 2020 06:08:29 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 714C0D6E;
        Wed,  2 Sep 2020 03:08:29 -0700 (PDT)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.195.35])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C17503F66F;
        Wed,  2 Sep 2020 03:08:28 -0700 (PDT)
From:   Andre Przywara <andre.przywara@arm.com>
To:     stable@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>, Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH stable v4.19 2/4] KVM: arm64: Defer guest entry when an asynchronous exception is pending
Date:   Wed,  2 Sep 2020 11:08:19 +0100
Message-Id: <20200902100821.149574-3-andre.przywara@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200902100821.149574-1-andre.przywara@arm.com>
References: <20200902100821.149574-1-andre.przywara@arm.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Morse <james.morse@arm.com>

commit 5dcd0fdbb492d49dac6bf21c436dfcb5ded0a895 upstream.

SError that occur during world-switch's entry to the guest will be
accounted to the guest, as the exception is masked until we enter the
guest... but we want to attribute the SError as precisely as possible.

Reading DISR_EL1 before guest entry requires free registers, and using
ESB+DISR_EL1 to consume and read back the ESR would leave KVM holding
a host SError... We would rather leave the SError pending and let the
host take it once we exit world-switch. To do this, we need to defer
guest-entry if an SError is pending.

Read the ISR to see if SError (or an IRQ) is pending. If so fake an
exit. Place this check between __guest_enter()'s save of the host
registers, and restore of the guest's. SError that occur between
here and the eret into the guest must have affected the guest's
registers, which we can naturally attribute to the guest.

The dsb is needed to ensure any previous writes have been done before
we read ISR_EL1. On systems without the v8.2 RAS extensions this
doesn't give us anything as we can't contain errors, and the ESR bits
to describe the severity are all implementation-defined. Replace
this with a nop for these systems.

Cc: stable@vger.kernel.org # v4.19
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 arch/arm64/kvm/hyp/entry.S | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
index c21d279a5aab..fc83e932afbe 100644
--- a/arch/arm64/kvm/hyp/entry.S
+++ b/arch/arm64/kvm/hyp/entry.S
@@ -17,6 +17,7 @@
 
 #include <linux/linkage.h>
 
+#include <asm/alternative.h>
 #include <asm/asm-offsets.h>
 #include <asm/assembler.h>
 #include <asm/fpsimdmacros.h>
@@ -62,6 +63,20 @@ ENTRY(__guest_enter)
 	// Store the host regs
 	save_callee_saved_regs x1
 
+	// Now the host state is stored if we have a pending RAS SError it must
+	// affect the host. If any asynchronous exception is pending we defer
+	// the guest entry. The DSB isn't necessary before v8.2 as any SError
+	// would be fatal.
+alternative_if ARM64_HAS_RAS_EXTN
+	dsb	nshst
+	isb
+alternative_else_nop_endif
+	mrs	x1, isr_el1
+	cbz	x1,  1f
+	mov	x0, #ARM_EXCEPTION_IRQ
+	ret
+
+1:
 	add	x18, x0, #VCPU_CONTEXT
 
 	// Restore guest regs x0-x17
-- 
2.17.1

