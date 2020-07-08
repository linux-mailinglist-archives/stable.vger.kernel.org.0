Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11487218C19
	for <lists+stable@lfdr.de>; Wed,  8 Jul 2020 17:44:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730536AbgGHPoX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jul 2020 11:44:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:47842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730403AbgGHPlZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 Jul 2020 11:41:25 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA3FC20720;
        Wed,  8 Jul 2020 15:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594222885;
        bh=GEJJCDdVm8pUbVjvqKgHBBMZkXtSqzUnyt6nkVra9C4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ELAHhkgGJptcVpMd7kX0vSvpXs78iTXGMe1SuQJW5NUP30mn8+zduqdESZzIwAzEx
         MtzNTJ3j4mc5FGXWZo1Bj/+TGJ+TQf+GjIUgoh3wGZ9fps4asY5CiZCitf/uA62ARO
         kQO+YYdm7X6yd8sTXM1PdWmuyp/d7Dy0BKJPmH5k=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Petteri Aimonen <jpa@git.mail.kapsi.fi>,
        Borislav Petkov <bp@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.7 06/30] x86/fpu: Reset MXCSR to default in kernel_fpu_begin()
Date:   Wed,  8 Jul 2020 11:40:52 -0400
Message-Id: <20200708154116.3199728-6-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200708154116.3199728-1-sashal@kernel.org>
References: <20200708154116.3199728-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Petteri Aimonen <jpa@git.mail.kapsi.fi>

[ Upstream commit 7ad816762f9bf89e940e618ea40c43138b479e10 ]

Previously, kernel floating point code would run with the MXCSR control
register value last set by userland code by the thread that was active
on the CPU core just before kernel call. This could affect calculation
results if rounding mode was changed, or a crash if a FPU/SIMD exception
was unmasked.

Restore MXCSR to the kernel's default value.

 [ bp: Carve out from a bigger patch by Petteri, add feature check, add
   FNINIT call too (amluto). ]

Signed-off-by: Petteri Aimonen <jpa@git.mail.kapsi.fi>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=207979
Link: https://lkml.kernel.org/r/20200624114646.28953-2-bp@alien8.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/fpu/internal.h | 5 +++++
 arch/x86/kernel/fpu/core.c          | 6 ++++++
 2 files changed, 11 insertions(+)

diff --git a/arch/x86/include/asm/fpu/internal.h b/arch/x86/include/asm/fpu/internal.h
index 44c48e34d7994..00eac7f1529b0 100644
--- a/arch/x86/include/asm/fpu/internal.h
+++ b/arch/x86/include/asm/fpu/internal.h
@@ -619,6 +619,11 @@ static inline void switch_fpu_finish(struct fpu *new_fpu)
  * MXCSR and XCR definitions:
  */
 
+static inline void ldmxcsr(u32 mxcsr)
+{
+	asm volatile("ldmxcsr %0" :: "m" (mxcsr));
+}
+
 extern unsigned int mxcsr_feature_mask;
 
 #define XCR_XFEATURE_ENABLED_MASK	0x00000000
diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index 12c70840980e4..cd8839027f66d 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -101,6 +101,12 @@ void kernel_fpu_begin(void)
 		copy_fpregs_to_fpstate(&current->thread.fpu);
 	}
 	__cpu_invalidate_fpregs_state();
+
+	if (boot_cpu_has(X86_FEATURE_XMM))
+		ldmxcsr(MXCSR_DEFAULT);
+
+	if (boot_cpu_has(X86_FEATURE_FPU))
+		asm volatile ("fninit");
 }
 EXPORT_SYMBOL_GPL(kernel_fpu_begin);
 
-- 
2.25.1

