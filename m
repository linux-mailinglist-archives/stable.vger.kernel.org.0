Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6911A2507E4
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 20:36:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726853AbgHXSgK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 14:36:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726818AbgHXSgF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Aug 2020 14:36:05 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10605C061574;
        Mon, 24 Aug 2020 11:36:05 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id m71so5307620pfd.1;
        Mon, 24 Aug 2020 11:36:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=addwi+DuL+3In4jU8eTGvwYHm2hYzX6lkO3UYwBb/tE=;
        b=vc6dI0Skbh92KdhKcVQmbgbIz8zrp7NX2TL+pDNCWRMOmhEq78EETPi0jYncIEg8pE
         GJfJEHHqPbG+aH5PsJ4KsQr0tfA57DSH9u8qxqFgY5j4zsod+ze93XXmjQSi7/qkAPv5
         poTsfxPpPQ+4mngHTY8zKO+9i4qbkPbKQGwbFgMktJ2NMUGSBv0fysS12rcL5n5fuFLA
         w/HSd9dqXG8DPhu1aRRFZBmnV32qEeGH7XDfjOs10EIqrB93FK8NWlB7vqnsLaDKvBvf
         g39Rz2PADypNU5TC4Col2JevZqeextTMdln1yA4oun1QHSfSCL2et1kgcMfngQxF9U4d
         EqtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=addwi+DuL+3In4jU8eTGvwYHm2hYzX6lkO3UYwBb/tE=;
        b=B4ofwAUgLXpepel2SgB34IekMqllWkQIC1i+znzYeLUp9CbmNAEwSW9PP354mWF0nf
         fHGfAwvNWt87GdDpvB7ZB76I+BjjMqcy1LGYnvhkaWfUvIcQ7US9YCoO1LDwqcznUpIf
         PbqYRAXItLvfzPKYfgHFr65mmXBSPZ/52dTh5ua0ymS5rUoJBzFRddw6dHvLaIg6yhU5
         4ez9177dRZUQSBKOUb31Kv5Z+Vh3ynnoQQCE/fuvHB0V8eDlt0qBFOEeU2wYVhnEVyFu
         0Nia6aFP0aJgMtwM6RTMOGAAIQWrNprFUGmYqc4dqLjEwCVykZX8dzDkjvbOfof8UEkA
         S58A==
X-Gm-Message-State: AOAM5303FRQsvUyAGdx+j+9V+lm2m1FeKtOH7UiirUUkFwe8l2LTVHb0
        Dp91LOU/5ZY43oIaQPKoL6E=
X-Google-Smtp-Source: ABdhPJzoksw/EyZJ9KdYrRMgXJ+MLx0l2lfCD2Dyj/Mjal/XTfEZX2oBb8RIB+0xeXksj9e7svHmuA==
X-Received: by 2002:a17:902:788e:: with SMTP id q14mr4624503pll.140.1598294164572;
        Mon, 24 Aug 2020 11:36:04 -0700 (PDT)
Received: from stbirv-lnx-3.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j10sm12167900pff.171.2020.08.24.11.36.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Aug 2020 11:36:03 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     linux-arm-kernel@lists.infradead.org
Cc:     Will Deacon <will.deacon@arm.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Will Deacon <will@kernel.org>, stable@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Mark Brown <broonie@kernel.org>,
        Kristina Martsenko <kristina.martsenko@arm.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Fangrui Song <maskray@google.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)" 
        <kvmarm@lists.cs.columbia.edu>
Subject: [PATCH stable 4.19 v2 2/2] arm64: entry: Place an SB sequence following an ERET instruction
Date:   Mon, 24 Aug 2020 11:35:12 -0700
Message-Id: <1598294112-19197-3-git-send-email-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1598294112-19197-1-git-send-email-f.fainelli@gmail.com>
References: <1598294112-19197-1-git-send-email-f.fainelli@gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will Deacon <will.deacon@arm.com>

commit 679db70801da9fda91d26caf13bf5b5ccc74e8e8 upstream

Some CPUs can speculate past an ERET instruction and potentially perform
speculative accesses to memory before processing the exception return.
Since the register state is often controlled by a lower privilege level
at the point of an ERET, this could potentially be used as part of a
side-channel attack.

This patch emits an SB sequence after each ERET so that speculation is
held up on exception return.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 arch/arm64/kernel/entry.S      | 2 ++
 arch/arm64/kvm/hyp/entry.S     | 1 +
 arch/arm64/kvm/hyp/hyp-entry.S | 4 ++++
 3 files changed, 7 insertions(+)

diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index 5f800384cb9a..49f80b5627fa 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -363,6 +363,7 @@ alternative_insn eret, nop, ARM64_UNMAP_KERNEL_AT_EL0
 	.else
 	eret
 	.endif
+	sb
 	.endm
 
 	.macro	irq_stack_entry
@@ -994,6 +995,7 @@ alternative_insn isb, nop, ARM64_WORKAROUND_QCOM_FALKOR_E1003
 	mrs	x30, far_el1
 	.endif
 	eret
+	sb
 	.endm
 
 	.align	11
diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
index fad1e164fe48..675fdc186e3b 100644
--- a/arch/arm64/kvm/hyp/entry.S
+++ b/arch/arm64/kvm/hyp/entry.S
@@ -83,6 +83,7 @@ ENTRY(__guest_enter)
 
 	// Do not touch any register after this!
 	eret
+	sb
 ENDPROC(__guest_enter)
 
 ENTRY(__guest_exit)
diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
index 24b4fbafe3e4..e35abf84eb96 100644
--- a/arch/arm64/kvm/hyp/hyp-entry.S
+++ b/arch/arm64/kvm/hyp/hyp-entry.S
@@ -96,6 +96,7 @@ el1_sync:				// Guest trapped into EL2
 	do_el2_call
 
 	eret
+	sb
 
 el1_hvc_guest:
 	/*
@@ -146,6 +147,7 @@ wa_epilogue:
 	mov	x0, xzr
 	add	sp, sp, #16
 	eret
+	sb
 
 el1_trap:
 	get_vcpu_ptr	x1, x0
@@ -185,6 +187,7 @@ el2_error:
 	b.ne	__hyp_panic
 	mov	x0, #(1 << ARM_EXIT_WITH_SERROR_BIT)
 	eret
+	sb
 
 ENTRY(__hyp_do_panic)
 	mov	lr, #(PSR_F_BIT | PSR_I_BIT | PSR_A_BIT | PSR_D_BIT |\
@@ -193,6 +196,7 @@ ENTRY(__hyp_do_panic)
 	ldr	lr, =panic
 	msr	elr_el2, lr
 	eret
+	sb
 ENDPROC(__hyp_do_panic)
 
 ENTRY(__hyp_panic)
-- 
2.7.4

