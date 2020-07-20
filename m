Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 807F3226E34
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 20:26:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726381AbgGTS0M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 14:26:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726506AbgGTS0L (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jul 2020 14:26:11 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7E5EC0619D2;
        Mon, 20 Jul 2020 11:26:11 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id f18so18853120wrs.0;
        Mon, 20 Jul 2020 11:26:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=lj9ZknVcrD3MA4t8QmNQ12rpsDUhjiYrWHP/I1wz74s=;
        b=SRV3gLWLaFDivOniTKfXDlRqb5BR+1ORl45h0alrybpcGwh7MwzAnhjDYScrdQqAqG
         lOq7WpXbxUWnuOLBbnG9RFx479KHXJndGnOfGK324YKDf6WK0tAWyhclNcP0Sz9BXvL0
         h05LUSwfwEF9cS4s1p9XCgHvN9qskodgaabbClsTwme6/gsZsOE1/dwmzrIyFEgiXOJj
         hZSXFqFkwLAxF0jIQZhLz6lI5u9UTUUX7Fph6uS/tHMANVbjYFezP1ll6SOsKeidsNqB
         d6GwRwLDsJkqxky3JbTiVVK8aAXHZ9PwIk4SwUBjDuHaKT3aEY3xRIug92j1IxYnM4GG
         /3nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=lj9ZknVcrD3MA4t8QmNQ12rpsDUhjiYrWHP/I1wz74s=;
        b=XvRz4G7RZ5eE3a0/fLJEVkMSPtZTooyxP+EdcD9/+GHG9DZpwbjwq3w8yiAvUqDKXD
         t3SlDENKG0l54USxooaSaSAAvaYhWlzAmGXYfqjinz+BEG7xwKlN/LKew6WwmdJS6r4n
         oBdAxiUTcBEm7m5nl/AzOrIk+s595lYEUTyVK1KfIpFTd7jIeq2oo5R8mWSdxPNZXuxX
         MseVFCKtZsW++lskLdqO7+mLWnLdb8TcpmkF+Cpjc0ZeCLMYlRTluSXeJJ72XusEtac7
         Soh2Ih0DI7nOsB/tKqdcDxAmERkQUfGjnazRGDkuPPh2dgiC5oZz+KHYAyDYfoHMzWX9
         GR7A==
X-Gm-Message-State: AOAM531dzlXIr6mZr14Z0+MwHbOZWVILWXwpOIYdcRMeXsfeBwErCL4m
        eEo+JIuPUS0M0bAkUg5otfvflX7o
X-Google-Smtp-Source: ABdhPJzTmHsYloYlnQp0ihbIybRCflF9ZffwP80u0Ay5lylmf7xqW8rfqcqRdHMBm/3lVw2qdPpZvQ==
X-Received: by 2002:adf:d08d:: with SMTP id y13mr3145410wrh.313.1595269570059;
        Mon, 20 Jul 2020 11:26:10 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id v11sm699363wmb.3.2020.07.20.11.26.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2020 11:26:09 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, will@kernel.org,
        Will Deacon <will.deacon@arm.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Sasha Levin <sashal@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Julien Thierry <julien.thierry@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-kernel@lists.infradead.org (moderated list:ARM64 PORT
        (AARCH64 ARCHITECTURE)),
        kvmarm@lists.cs.columbia.edu (open list:KERNEL VIRTUAL MACHINE FOR
        ARM64 (KVM/arm64))
Subject: [PATCH stable 4.19.y] arm64: entry: Place an SB sequence following an ERET instruction
Date:   Mon, 20 Jul 2020 11:25:37 -0700
Message-Id: <20200720182538.13304-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
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
2.17.1

