Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E31534F3200
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:53:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350115AbiDEKvO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:51:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345599AbiDEJnk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:43:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 402B2C337B;
        Tue,  5 Apr 2022 02:28:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6C8D8B81CB2;
        Tue,  5 Apr 2022 09:28:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFF9EC385A3;
        Tue,  5 Apr 2022 09:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649150933;
        bh=YNF+91Oul/8FbqE+JE40TuO4ibnBfixTTRe5SmoLFNg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J9wY5FJLzA0Pi/Ewq7T2DFUSYw2fa5cFx/rHSaVs8Rc2mVvxUG6L66+P8/EAruKzc
         k/r0i03aX1Dhbc2h/lLBJDUMKAk5bfv+2RUUVUbkU4ABMQBQXgT0Q5bXw1cSRVya1k
         tp0JObps0JjxezJkzaHP6PFuSg7ukgr+rRuzo/Qk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Marc Zyngier <maz@kernel.org>, Mark Brown <broonie@kernel.org>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 233/913] arm64: prevent instrumentation of bp hardening callbacks
Date:   Tue,  5 Apr 2022 09:21:35 +0200
Message-Id: <20220405070346.840223974@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Rutland <mark.rutland@arm.com>

[ Upstream commit 614c0b9fee711dd89b1dd65c88ba83612a373fdc ]

We may call arm64_apply_bp_hardening() early during entry (e.g. in
el0_ia()) before it is safe to run instrumented code. Unfortunately this
may result in running instrumented code in two cases:

* The hardening callbacks called by arm64_apply_bp_hardening() are not
  marked as `noinstr`, and have been observed to be instrumented when
  compiled with either GCC or LLVM.

* Since arm64_apply_bp_hardening() itself is only marked as `inline`
  rather than `__always_inline`, it is possible that the compiler
  decides to place it out-of-line, whereupon it may be instrumented.

For example, with defconfig built with clang 13.0.0,
call_hvc_arch_workaround_1() is compiled as:

| <call_hvc_arch_workaround_1>:
|        d503233f        paciasp
|        f81f0ffe        str     x30, [sp, #-16]!
|        320183e0        mov     w0, #0x80008000
|        d503201f        nop
|        d4000002        hvc     #0x0
|        f84107fe        ldr     x30, [sp], #16
|        d50323bf        autiasp
|        d65f03c0        ret

... but when CONFIG_FTRACE=y and CONFIG_KCOV=y this is compiled as:

| <call_hvc_arch_workaround_1>:
|        d503245f        bti     c
|        d503201f        nop
|        d503201f        nop
|        d503233f        paciasp
|        a9bf7bfd        stp     x29, x30, [sp, #-16]!
|        910003fd        mov     x29, sp
|        94000000        bl      0 <__sanitizer_cov_trace_pc>
|        320183e0        mov     w0, #0x80008000
|        d503201f        nop
|        d4000002        hvc     #0x0
|        a8c17bfd        ldp     x29, x30, [sp], #16
|        d50323bf        autiasp
|        d65f03c0        ret

... with a patchable function entry registered with ftrace, and a direct
call to __sanitizer_cov_trace_pc(). Neither of these are safe early
during entry sequences.

This patch avoids the unsafe instrumentation by marking
arm64_apply_bp_hardening() as `__always_inline` and by marking the
hardening functions as `noinstr`. This avoids the potential for
instrumentation, and causes clang to consistently generate the function
as with the defconfig sample.

Note: in the defconfig compilation, when CONFIG_SVE=y, x30 is spilled to
the stack without being placed in a frame record, which will result in a
missing entry if call_hvc_arch_workaround_1() is backtraced. Similar is
true of qcom_link_stack_sanitisation(), where inline asm spills the LR
to a GPR prior to corrupting it. This is not a significant issue
presently as we will only backtrace here if an exception is taken, and
in such cases we may omit entries for other reasons today.

The relevant hardening functions were introduced in commits:

  ec82b567a74fbdff ("arm64: Implement branch predictor hardening for Falkor")
  b092201e00206141 ("arm64: Add ARM_SMCCC_ARCH_WORKAROUND_1 BP hardening support")

... and these were subsequently moved in commit:

  d4647f0a2ad71110 ("arm64: Rewrite Spectre-v2 mitigation code")

The arm64_apply_bp_hardening() function was introduced in commit:

  0f15adbb2861ce6f ("arm64: Add skeleton to harden the branch predictor against aliasing attacks")

... and was subsequently moved and reworked in commit:

  6279017e807708a0 ("KVM: arm64: Move BP hardening helpers into spectre.h")

Fixes: ec82b567a74fbdff ("arm64: Implement branch predictor hardening for Falkor")
Fixes: b092201e00206141 ("arm64: Add ARM_SMCCC_ARCH_WORKAROUND_1 BP hardening support")
Fixes: d4647f0a2ad71110 ("arm64: Rewrite Spectre-v2 mitigation code")
Fixes: 0f15adbb2861ce6f ("arm64: Add skeleton to harden the branch predictor against aliasing attacks")
Fixes: 6279017e807708a0 ("KVM: arm64: Move BP hardening helpers into spectre.h")
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: James Morse <james.morse@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Will Deacon <will@kernel.org>
Acked-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20220224181028.512873-1-mark.rutland@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/spectre.h | 3 ++-
 arch/arm64/kernel/proton-pack.c  | 9 ++++++---
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/spectre.h b/arch/arm64/include/asm/spectre.h
index 86e0cc9b9c68..aa3d3607d5c8 100644
--- a/arch/arm64/include/asm/spectre.h
+++ b/arch/arm64/include/asm/spectre.h
@@ -67,7 +67,8 @@ struct bp_hardening_data {
 
 DECLARE_PER_CPU_READ_MOSTLY(struct bp_hardening_data, bp_hardening_data);
 
-static inline void arm64_apply_bp_hardening(void)
+/* Called during entry so must be __always_inline */
+static __always_inline void arm64_apply_bp_hardening(void)
 {
 	struct bp_hardening_data *d;
 
diff --git a/arch/arm64/kernel/proton-pack.c b/arch/arm64/kernel/proton-pack.c
index 6d45c63c6454..5777929d35bf 100644
--- a/arch/arm64/kernel/proton-pack.c
+++ b/arch/arm64/kernel/proton-pack.c
@@ -233,17 +233,20 @@ static void install_bp_hardening_cb(bp_hardening_cb_t fn)
 	__this_cpu_write(bp_hardening_data.slot, HYP_VECTOR_SPECTRE_DIRECT);
 }
 
-static void call_smc_arch_workaround_1(void)
+/* Called during entry so must be noinstr */
+static noinstr void call_smc_arch_workaround_1(void)
 {
 	arm_smccc_1_1_smc(ARM_SMCCC_ARCH_WORKAROUND_1, NULL);
 }
 
-static void call_hvc_arch_workaround_1(void)
+/* Called during entry so must be noinstr */
+static noinstr void call_hvc_arch_workaround_1(void)
 {
 	arm_smccc_1_1_hvc(ARM_SMCCC_ARCH_WORKAROUND_1, NULL);
 }
 
-static void qcom_link_stack_sanitisation(void)
+/* Called during entry so must be noinstr */
+static noinstr void qcom_link_stack_sanitisation(void)
 {
 	u64 tmp;
 
-- 
2.34.1



