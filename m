Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6676325D743
	for <lists+stable@lfdr.de>; Fri,  4 Sep 2020 13:29:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730101AbgIDL32 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Sep 2020 07:29:28 -0400
Received: from foss.arm.com ([217.140.110.172]:48884 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730203AbgIDL3K (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Sep 2020 07:29:10 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A78C812FC;
        Fri,  4 Sep 2020 04:29:09 -0700 (PDT)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.195.35])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D85093F71F;
        Fri,  4 Sep 2020 04:29:08 -0700 (PDT)
From:   Andre Przywara <andre.przywara@arm.com>
To:     stable@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>, Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH stable v4.9 2/4] KVM: arm64: Defer guest entry when an asynchronous exception is pending
Date:   Fri,  4 Sep 2020 12:28:58 +0100
Message-Id: <20200904112900.230831-3-andre.przywara@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200904112900.230831-1-andre.przywara@arm.com>
References: <20200904112900.230831-1-andre.przywara@arm.com>
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

v4.9-backport: as this kernel version doesn't have the RAS support at
all, remove the RAS alternative.

Cc: stable@vger.kernel.org # v4.9
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
[ James: Removed v8.2 RAS related barriers ]
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 arch/arm64/kvm/hyp/entry.S | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
index 76545f95f704..4e0eac361f87 100644
--- a/arch/arm64/kvm/hyp/entry.S
+++ b/arch/arm64/kvm/hyp/entry.S
@@ -17,6 +17,7 @@
 
 #include <linux/linkage.h>
 
+#include <asm/alternative.h>
 #include <asm/asm-offsets.h>
 #include <asm/assembler.h>
 #include <asm/fpsimdmacros.h>
@@ -62,6 +63,15 @@ ENTRY(__guest_enter)
 	// Store the host regs
 	save_callee_saved_regs x1
 
+	// Now the host state is stored if we have a pending RAS SError it must
+	// affect the host. If any asynchronous exception is pending we defer
+	// the guest entry.
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

