Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33B736AEB77
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:45:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232376AbjCGRpf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:45:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232112AbjCGRo0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:44:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9095797B7D
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:40:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 72540614FF
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86F0BC433EF;
        Tue,  7 Mar 2023 17:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678210811;
        bh=iOmt3RrNlbIEjx/KReScnh9+gup0ENoJQXZIu7UBVKU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gbgdVg8jWjh3Fh3Vgn7miS+bWRika9Hn0Nq38SS4I+xW+Pe5FzL5CyAqJDhpp2Ps+
         iL5LEPEkxJ/01oeeDyjTBWNduNo1xWcvkS79CQgAc3SPKhTRBup2ScEl9mHejGPl1M
         wHSySxzTUcu+P486GCrjeJRXE0mAXlJ2q2RMnD20=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0631/1001] cpuidle, intel_idle: Fix CPUIDLE_FLAG_INIT_XSTATE
Date:   Tue,  7 Mar 2023 17:56:43 +0100
Message-Id: <20230307170048.952561140@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 821ad23d0eaff73ef599ece39ecc77482df20a8c ]

Fix instrumentation bugs objtool found:

  vmlinux.o: warning: objtool: intel_idle_s2idle+0xd5: call to fpu_idle_fpregs() leaves .noinstr.text section
  vmlinux.o: warning: objtool: intel_idle_xstate+0x11: call to fpu_idle_fpregs() leaves .noinstr.text section
  vmlinux.o: warning: objtool: fpu_idle_fpregs+0x9: call to xfeatures_in_use() leaves .noinstr.text section

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Tested-by: Tony Lindgren <tony@atomide.com>
Tested-by: Ulf Hansson <ulf.hansson@linaro.org>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Acked-by: Frederic Weisbecker <frederic@kernel.org>
Link: https://lore.kernel.org/r/20230112195540.494977795@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/fpu/xcr.h       | 4 ++--
 arch/x86/include/asm/special_insns.h | 2 +-
 arch/x86/kernel/fpu/core.c           | 4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/fpu/xcr.h b/arch/x86/include/asm/fpu/xcr.h
index 9656a5bc6feae..9a710c0604457 100644
--- a/arch/x86/include/asm/fpu/xcr.h
+++ b/arch/x86/include/asm/fpu/xcr.h
@@ -5,7 +5,7 @@
 #define XCR_XFEATURE_ENABLED_MASK	0x00000000
 #define XCR_XFEATURE_IN_USE_MASK	0x00000001
 
-static inline u64 xgetbv(u32 index)
+static __always_inline u64 xgetbv(u32 index)
 {
 	u32 eax, edx;
 
@@ -27,7 +27,7 @@ static inline void xsetbv(u32 index, u64 value)
  *
  * Callers should check X86_FEATURE_XGETBV1.
  */
-static inline u64 xfeatures_in_use(void)
+static __always_inline u64 xfeatures_in_use(void)
 {
 	return xgetbv(XCR_XFEATURE_IN_USE_MASK);
 }
diff --git a/arch/x86/include/asm/special_insns.h b/arch/x86/include/asm/special_insns.h
index 35f709f619fb4..c2e322189f853 100644
--- a/arch/x86/include/asm/special_insns.h
+++ b/arch/x86/include/asm/special_insns.h
@@ -295,7 +295,7 @@ static inline int enqcmds(void __iomem *dst, const void *src)
 	return 0;
 }
 
-static inline void tile_release(void)
+static __always_inline void tile_release(void)
 {
 	/*
 	 * Instruction opcode for TILERELEASE; supported in binutils
diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index 9baa89a8877d0..dccce58201b7c 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -853,12 +853,12 @@ int fpu__exception_code(struct fpu *fpu, int trap_nr)
  * Initialize register state that may prevent from entering low-power idle.
  * This function will be invoked from the cpuidle driver only when needed.
  */
-void fpu_idle_fpregs(void)
+noinstr void fpu_idle_fpregs(void)
 {
 	/* Note: AMX_TILE being enabled implies XGETBV1 support */
 	if (cpu_feature_enabled(X86_FEATURE_AMX_TILE) &&
 	    (xfeatures_in_use() & XFEATURE_MASK_XTILE)) {
 		tile_release();
-		fpregs_deactivate(&current->thread.fpu);
+		__this_cpu_write(fpu_fpregs_owner_ctx, NULL);
 	}
 }
-- 
2.39.2



