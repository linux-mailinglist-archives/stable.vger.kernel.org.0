Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 755731F7319
	for <lists+stable@lfdr.de>; Fri, 12 Jun 2020 06:42:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725947AbgFLEme (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jun 2020 00:42:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725763AbgFLEme (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Jun 2020 00:42:34 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B728C03E96F;
        Thu, 11 Jun 2020 21:42:34 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id g12so3242332pll.10;
        Thu, 11 Jun 2020 21:42:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=tnkNvIy4NyhOcfhzdkEEgf5Q0aBBdpOiKM99Ch2kRHo=;
        b=p2J2k390abBAM4NCbA9yAEM/LrDNElIECJSQNv3Nr8adiQVAS5SzbFY95WgXXxsQIh
         WJkHweRSLgzRw+GhG7AdtIsCCWhBM8XJSKuStAPyg5GzWrP6UfZokkvvSDuCia7LKDe8
         71ujb6m40rMGRbwrRU+cN48oUNWf6r0I2VKCdk3XFkhd7SI1mBjeH2MYM00dZWC5qOCP
         FHXiJVbAQiG/K5Obfn+8x9PhykJbXAlXcTajBOJKJlM1Wemqs6OzfESWAa5E+VfI9uFY
         0/YzlC1zdTftffN4s1iJyIMA8CW79XvwgF/CZ2Um4s/Uxf3elaXGjlbcz4Tn9Hlj3jV0
         d2tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=tnkNvIy4NyhOcfhzdkEEgf5Q0aBBdpOiKM99Ch2kRHo=;
        b=jnbxLZSaU7SwEo9AWESk+sdWpRd0acuQbNxVGlvA178Yr3FThVn9nxmrSnfij3jgYh
         AbDNn0ylgjdUqtmpRWt3ncPcSIU8t5D/y/fZ2E2em3n82W7QIK5DE+ZgwsXvsTzjbf3q
         WTjPi+44VD5V1UhCsBJUdD2SsfdNJQ/Tj/iCAstzTsCbNw5pEZS0rJMQ5aQ9XawhEVbM
         Wm44JjZi4/SOq6RotGy4vZR2CTYHJ3YxpvnqHo92ijzOIvkRA/ZQr12CjDc56u8qLN21
         bzjToWMY8SN2aLQ6+QRSBx3j6Ee2pWygpbaLPBtTEI4uNxocvoB6Bug2rjD2LnGJQyPM
         Y2ug==
X-Gm-Message-State: AOAM530n+c/lTU6DkdV0kw91aOr8y6QHbomFPES85YR/QxpC6TsRrqhu
        LWugph0OAvPpHEYWa1g7HRo=
X-Google-Smtp-Source: ABdhPJwVfVwWuvBqsmyJQUwzIkKhTVDfAOSa0G75EXUmTNsmKXeQmrkCijvdn4svfC9O7GaAMKn6pA==
X-Received: by 2002:a17:902:c30c:: with SMTP id k12mr10389411plx.130.1591936953486;
        Thu, 11 Jun 2020 21:42:33 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id s9sm4084239pgo.22.2020.06.11.21.42.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2020 21:42:32 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     linux-arm-kernel@lists.infradead.org
Cc:     stable@vger.kernel.org, will@kernel.org,
        Will Deacon <will.deacon@arm.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        linux-kernel@vger.kernel.org (open list),
        kvm@vger.kernel.org (open list:KERNEL VIRTUAL MACHINE (KVM)),
        kvmarm@lists.cs.columbia.edu (open list:KERNEL VIRTUAL MACHINE FOR
        ARM64 (KVM/arm64))
Subject: [PATCH stable 4.9] arm64: entry: Place an SB sequence following an ERET instruction
Date:   Thu, 11 Jun 2020 21:42:18 -0700
Message-Id: <20200612044219.31606-1-f.fainelli@gmail.com>
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
[florian: Adjust hyp-entry.S to account for the label]
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
Will,

Can you confirm that for 4.9 these are the only places that require
patching? Thank you!

 arch/arm64/kernel/entry.S      | 2 ++
 arch/arm64/kvm/hyp/entry.S     | 1 +
 arch/arm64/kvm/hyp/hyp-entry.S | 4 ++++
 3 files changed, 7 insertions(+)

diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index ca978d7d98eb..3408c782702c 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -255,6 +255,7 @@ alternative_insn eret, nop, ARM64_UNMAP_KERNEL_AT_EL0
 	.else
 	eret
 	.endif
+	sb
 	.endm
 
 	.macro	get_thread_info, rd
@@ -945,6 +946,7 @@ __ni_sys_trace:
 	mrs	x30, far_el1
 	.endif
 	eret
+	sb
 	.endm
 
 	.align	11
diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
index a360ac6e89e9..bc5c6cdb8538 100644
--- a/arch/arm64/kvm/hyp/entry.S
+++ b/arch/arm64/kvm/hyp/entry.S
@@ -83,6 +83,7 @@ ENTRY(__guest_enter)
 
 	// Do not touch any register after this!
 	eret
+	sb
 ENDPROC(__guest_enter)
 
 ENTRY(__guest_exit)
diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
index bf4988f9dae8..3675e7f0ab72 100644
--- a/arch/arm64/kvm/hyp/hyp-entry.S
+++ b/arch/arm64/kvm/hyp/hyp-entry.S
@@ -97,6 +97,7 @@ el1_sync:				// Guest trapped into EL2
 	do_el2_call
 
 2:	eret
+	sb
 
 el1_hvc_guest:
 	/*
@@ -147,6 +148,7 @@ wa_epilogue:
 	mov	x0, xzr
 	add	sp, sp, #16
 	eret
+	sb
 
 el1_trap:
 	get_vcpu_ptr	x1, x0
@@ -198,6 +200,7 @@ el2_error:
 	b.ne	__hyp_panic
 	mov	x0, #(1 << ARM_EXIT_WITH_SERROR_BIT)
 	eret
+	sb
 
 ENTRY(__hyp_do_panic)
 	mov	lr, #(PSR_F_BIT | PSR_I_BIT | PSR_A_BIT | PSR_D_BIT |\
@@ -206,6 +209,7 @@ ENTRY(__hyp_do_panic)
 	ldr	lr, =panic
 	msr	elr_el2, lr
 	eret
+	sb
 ENDPROC(__hyp_do_panic)
 
 ENTRY(__hyp_panic)
-- 
2.17.1

