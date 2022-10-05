Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E1865F5355
	for <lists+stable@lfdr.de>; Wed,  5 Oct 2022 13:32:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbiJELc5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Oct 2022 07:32:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbiJELc4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Oct 2022 07:32:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6B4D72EF2;
        Wed,  5 Oct 2022 04:32:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4904461644;
        Wed,  5 Oct 2022 11:32:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B5F4C433D6;
        Wed,  5 Oct 2022 11:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664969574;
        bh=fwgReMXDdknhWnQB/FEkL8D+3b6eFuhMNw36AAKop58=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WNYjqK7Q9vjgr1MjtHRpp2YaIZprD2bbjc1Qfn9AwD+f36QHqjQZTcuUh9rEbUcAI
         AJRf+zJuseiIpPVrQfQnD6cF12jDotx/7H63cEiIohDMDjuVnTg5436gQsQSKO6Xus
         V3URVkezyWk2iIvuS3M/U4Lv2wHK/qmza3pA72Vc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 5.4 10/51] x86/bugs: Keep a per-CPU IA32_SPEC_CTRL value
Date:   Wed,  5 Oct 2022 13:31:58 +0200
Message-Id: <20221005113210.743950869@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221005113210.255710920@linuxfoundation.org>
References: <20221005113210.255710920@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

commit caa0ff24d5d0e02abce5e65c3d2b7f20a6617be5 upstream.

Due to TIF_SSBD and TIF_SPEC_IB the actual IA32_SPEC_CTRL value can
differ from x86_spec_ctrl_base. As such, keep a per-CPU value
reflecting the current task's MSR content.

  [jpoimboe: rename]

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/nospec-branch.h |    1 +
 arch/x86/kernel/cpu/bugs.c           |   28 +++++++++++++++++++++++-----
 arch/x86/kernel/process.c            |    2 +-
 3 files changed, 25 insertions(+), 6 deletions(-)

--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -297,6 +297,7 @@ static inline void indirect_branch_predi
 
 /* The Intel SPEC CTRL MSR base value cache */
 extern u64 x86_spec_ctrl_base;
+extern void write_spec_ctrl_current(u64 val);
 
 /*
  * With retpoline, we must use IBRS to restrict branch prediction
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -47,12 +47,30 @@ static void __init taa_select_mitigation
 static void __init mmio_select_mitigation(void);
 static void __init srbds_select_mitigation(void);
 
-/* The base value of the SPEC_CTRL MSR that always has to be preserved. */
+/* The base value of the SPEC_CTRL MSR without task-specific bits set */
 u64 x86_spec_ctrl_base;
 EXPORT_SYMBOL_GPL(x86_spec_ctrl_base);
+
+/* The current value of the SPEC_CTRL MSR with task-specific bits set */
+DEFINE_PER_CPU(u64, x86_spec_ctrl_current);
+EXPORT_SYMBOL_GPL(x86_spec_ctrl_current);
+
 static DEFINE_MUTEX(spec_ctrl_mutex);
 
 /*
+ * Keep track of the SPEC_CTRL MSR value for the current task, which may differ
+ * from x86_spec_ctrl_base due to STIBP/SSB in __speculation_ctrl_update().
+ */
+void write_spec_ctrl_current(u64 val)
+{
+	if (this_cpu_read(x86_spec_ctrl_current) == val)
+		return;
+
+	this_cpu_write(x86_spec_ctrl_current, val);
+	wrmsrl(MSR_IA32_SPEC_CTRL, val);
+}
+
+/*
  * The vendor and possibly platform specific bits which can be modified in
  * x86_spec_ctrl_base.
  */
@@ -1177,7 +1195,7 @@ static void __init spectre_v2_select_mit
 	if (spectre_v2_in_eibrs_mode(mode)) {
 		/* Force it so VMEXIT will restore correctly */
 		x86_spec_ctrl_base |= SPEC_CTRL_IBRS;
-		wrmsrl(MSR_IA32_SPEC_CTRL, x86_spec_ctrl_base);
+		write_spec_ctrl_current(x86_spec_ctrl_base);
 	}
 
 	switch (mode) {
@@ -1232,7 +1250,7 @@ static void __init spectre_v2_select_mit
 
 static void update_stibp_msr(void * __unused)
 {
-	wrmsrl(MSR_IA32_SPEC_CTRL, x86_spec_ctrl_base);
+	write_spec_ctrl_current(x86_spec_ctrl_base);
 }
 
 /* Update x86_spec_ctrl_base in case SMT state changed. */
@@ -1475,7 +1493,7 @@ static enum ssb_mitigation __init __ssb_
 			x86_amd_ssb_disable();
 		} else {
 			x86_spec_ctrl_base |= SPEC_CTRL_SSBD;
-			wrmsrl(MSR_IA32_SPEC_CTRL, x86_spec_ctrl_base);
+			write_spec_ctrl_current(x86_spec_ctrl_base);
 		}
 	}
 
@@ -1692,7 +1710,7 @@ int arch_prctl_spec_ctrl_get(struct task
 void x86_spec_ctrl_setup_ap(void)
 {
 	if (boot_cpu_has(X86_FEATURE_MSR_SPEC_CTRL))
-		wrmsrl(MSR_IA32_SPEC_CTRL, x86_spec_ctrl_base);
+		write_spec_ctrl_current(x86_spec_ctrl_base);
 
 	if (ssb_mode == SPEC_STORE_BYPASS_DISABLE)
 		x86_amd_ssb_disable();
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -449,7 +449,7 @@ static __always_inline void __speculatio
 	}
 
 	if (updmsr)
-		wrmsrl(MSR_IA32_SPEC_CTRL, msr);
+		write_spec_ctrl_current(msr);
 }
 
 static unsigned long speculation_ctrl_update_tif(struct task_struct *tsk)


