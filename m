Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BDD4266101
	for <lists+stable@lfdr.de>; Fri, 11 Sep 2020 16:13:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725920AbgIKNQa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Sep 2020 09:16:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:58964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725941AbgIKNPc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Sep 2020 09:15:32 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 094EE22244;
        Fri, 11 Sep 2020 12:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599829067;
        bh=WrKfuh3yAbeARMYEHR1js9UP1lzjuhWNQKJKsRGMwbg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pirSo71w2yZIoqOUcuLqses2fxB0OqL2CPPn3InnLvm4kIUyeXsMfep0qDYEUpr/v
         CoffsopHQvCyqLtOzq5L6PqjCmX2tv8jzLHGqQLr+i/q8ScJ8JmoqqO7qAvTxzQLiR
         6NRHosyI5FMsoaD3FgqaDjH9K2RsOVQmK/NUooQM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        James Morse <james.morse@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH 4.9 53/71] KVM: arm64: Defer guest entry when an asynchronous exception is pending
Date:   Fri, 11 Sep 2020 14:46:37 +0200
Message-Id: <20200911122507.555558810@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200911122504.928931589@linuxfoundation.org>
References: <20200911122504.928931589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/hyp/entry.S |   10 ++++++++++
 1 file changed, 10 insertions(+)

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


