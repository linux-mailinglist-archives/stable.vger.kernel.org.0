Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC353226E45
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 20:30:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728001AbgGTSaB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 14:30:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726506AbgGTSaB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jul 2020 14:30:01 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3499C061794;
        Mon, 20 Jul 2020 11:30:00 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id s10so18761124wrw.12;
        Mon, 20 Jul 2020 11:30:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=D95gU7RsNuUebcW/DXQQNWzRuFfBAwdF1di0SQ6P2nw=;
        b=sDanTDz9hQdQObRogJlHwmOHojVMQOpAxSiTkEanBT0XY9l3Gpd0ajVJ39dh28KnZ1
         5WVKz547vQqodfPVaymCAI1W15ib7JdeC/iXEtH0vt92s9EvfoPPBmKbrBUeKZFa/vam
         6Mn2576MlwaWKATO4KYwr6c4l+BIS0n+PMG9gmiz0pU4U2IHOHdIhqgximQmuAmo0dI/
         F9I/YvZ90hvtqeyeCzC04Gg844jbh5ZtqwqVrfoqkQfY5j1r5ltoOdZ61drE6LA8z5V9
         8kXX1s0QZSseZl4+ErzFEWNoZHGQpV5MWkiCQIA5nQWtrEepgnPUGY5ct9mxdyb45VfB
         ai+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=D95gU7RsNuUebcW/DXQQNWzRuFfBAwdF1di0SQ6P2nw=;
        b=MjjYJ7Z1KtQrF7gvYElGvwxTH30tH9CcxJnrWup01LtWjZkjlQMz9gEPYHF9Mh8Z9k
         YSHv5kYUWpDN+Sagz2GyLz7MaraUSneqp8y0JzwlYudbyPhokN86Jo4JguGwkP0aF+5O
         N1yLqmIjKISHNE6abCb2VOVhU1i+5MyqlNvfdZSqvT6Ws1hgB5xjby+Z5EFIAGlv4XjF
         g/f87Q0EHF+exPMYukf1l9AqG0zNJ2A4UAcrc/POYn9563xMdQUZSuBowID6zfToYwEZ
         LxS3MP7mSSVzM+eUsn5BsTd1yFido8dEZFpKY4Ic+NplK5/f6av6AffN2ofrmL4nKdfe
         Bfag==
X-Gm-Message-State: AOAM533AZH5nzd7xcwu8A+acNZF65le/G/9A6pK2ncSNclE8aUrS3X5p
        JrZ3RvZSE3fAma7Ma4CEo+DhNaIX
X-Google-Smtp-Source: ABdhPJz4JeI1ahtujTSu2VCDPPbOIBBdqG4fNC2Gz8FXvh7yofmruG+BZqPQ9YB/fWEZCzxa10YD9g==
X-Received: by 2002:a5d:6603:: with SMTP id n3mr24164764wru.142.1595269799106;
        Mon, 20 Jul 2020 11:29:59 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id t15sm477825wmj.14.2020.07.20.11.29.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2020 11:29:58 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, will@kernel.org,
        Will Deacon <will.deacon@arm.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Shanker Donthineni <shankerd@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-arm-kernel@lists.infradead.org (moderated list:ARM64 PORT
        (AARCH64 ARCHITECTURE)),
        kvmarm@lists.cs.columbia.edu (open list:KERNEL VIRTUAL MACHINE FOR
        ARM64 (KVM/arm64))
Subject: [PATCH stable 4.14.y] arm64: entry: Place an SB sequence following an ERET instruction
Date:   Mon, 20 Jul 2020 11:29:36 -0700
Message-Id: <20200720182937.14099-1-f.fainelli@gmail.com>
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
[florian: update arch/arm64/kvm/entry.S::__fpsimd_guest_restore]
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 arch/arm64/kernel/entry.S      | 2 ++
 arch/arm64/kvm/hyp/entry.S     | 2 ++
 arch/arm64/kvm/hyp/hyp-entry.S | 4 ++++
 3 files changed, 8 insertions(+)

diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index c1ffa95c0ad2..f70e0893ba51 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -367,6 +367,7 @@ alternative_insn eret, nop, ARM64_UNMAP_KERNEL_AT_EL0
 	.else
 	eret
 	.endif
+	sb
 	.endm
 
 	.macro	irq_stack_entry
@@ -1046,6 +1047,7 @@ alternative_insn isb, nop, ARM64_WORKAROUND_QCOM_FALKOR_E1003
 	mrs	x30, far_el1
 	.endif
 	eret
+	sb
 	.endm
 
 	.align	11
diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
index a360ac6e89e9..93704e6894d2 100644
--- a/arch/arm64/kvm/hyp/entry.S
+++ b/arch/arm64/kvm/hyp/entry.S
@@ -83,6 +83,7 @@ ENTRY(__guest_enter)
 
 	// Do not touch any register after this!
 	eret
+	sb
 ENDPROC(__guest_enter)
 
 ENTRY(__guest_exit)
@@ -195,4 +196,5 @@ alternative_endif
 	ldp	x0, x1, [sp], #16
 
 	eret
+	sb
 ENDPROC(__fpsimd_guest_restore)
diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
index 3c283fd8c8f5..b4d6a6c6c6ce 100644
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
@@ -204,6 +206,7 @@ el2_error:
 	b.ne	__hyp_panic
 	mov	x0, #(1 << ARM_EXIT_WITH_SERROR_BIT)
 	eret
+	sb
 
 ENTRY(__hyp_do_panic)
 	mov	lr, #(PSR_F_BIT | PSR_I_BIT | PSR_A_BIT | PSR_D_BIT |\
@@ -212,6 +215,7 @@ ENTRY(__hyp_do_panic)
 	ldr	lr, =panic
 	msr	elr_el2, lr
 	eret
+	sb
 ENDPROC(__hyp_do_panic)
 
 ENTRY(__hyp_panic)
-- 
2.17.1

