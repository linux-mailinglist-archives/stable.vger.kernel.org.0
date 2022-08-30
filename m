Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5123D5A69DA
	for <lists+stable@lfdr.de>; Tue, 30 Aug 2022 19:24:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230242AbiH3RXv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Aug 2022 13:23:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231416AbiH3RXN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Aug 2022 13:23:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0009DF7B0D;
        Tue, 30 Aug 2022 10:21:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2005E61798;
        Tue, 30 Aug 2022 17:21:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E0CAC43140;
        Tue, 30 Aug 2022 17:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661880075;
        bh=ZkrTeypSmERrNFe/JiRyKHiLqOClFRiNWGCIBvDj6WQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K0Y/7I1fW3lzL1OMnAL9MWosdw4ub5ANUd7sq0RRd4QQTML33ovO9iOq6IcC6xXeb
         2XIVj7InCcA5dV4vRXEwtqZ+ZVHpruaaAVOIRdPz3myILHtQKI8uc9W8LssZhbgLvI
         gP0ZMSM0m5Mzqb9PTlTRHkWCPqpjE5X8thYqZ5AhWmA343rZbremPW6k9eSFuEGThL
         vvFpKnS78389ESGltKhMMlJ9xlEzWngH0e1v3reKQfwViz0/HGmQTfl9p/rZq8TdpH
         HKUoSTm9sXs0P7UgGmJCL7bcUMO0vhlObJiHikCCpxqQv3U722yNr3n1dM6rHOmi+S
         tmdN6k+swtt+Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Borislav Petkov <bp@suse.de>, Michael Matz <matz@suse.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, jpoimboe@kernel.org, brijesh.singh@amd.com,
        michael.roth@amd.com, venu.busireddy@oracle.com,
        thomas.lendacky@amd.com, Tianyu.Lan@microsoft.com,
        kirill@shutemov.name, sterritt@google.com
Subject: [PATCH AUTOSEL 5.19 31/33] x86/sev: Mark snp_abort() noreturn
Date:   Tue, 30 Aug 2022 13:18:22 -0400
Message-Id: <20220830171825.580603-31-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220830171825.580603-1-sashal@kernel.org>
References: <20220830171825.580603-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Borislav Petkov <bp@suse.de>

[ Upstream commit c93c296fff6b369a7115916145047c8a3db6e27f ]

Mark both the function prototype and definition as noreturn in order to
prevent the compiler from doing transformations which confuse objtool
like so:

  vmlinux.o: warning: objtool: sme_enable+0x71: unreachable instruction

This triggers with gcc-12.

Add it and sev_es_terminate() to the objtool noreturn tracking array
too. Sort it while at it.

Suggested-by: Michael Matz <matz@suse.de>
Signed-off-by: Borislav Petkov <bp@suse.de>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20220824152420.20547-1-bp@alien8.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/sev.h |  2 +-
 arch/x86/kernel/sev.c      |  2 +-
 tools/objtool/check.c      | 34 ++++++++++++++++++----------------
 3 files changed, 20 insertions(+), 18 deletions(-)

diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 4a23e52fe0ee1..ebc271bb6d8ed 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -195,7 +195,7 @@ void snp_set_memory_shared(unsigned long vaddr, unsigned int npages);
 void snp_set_memory_private(unsigned long vaddr, unsigned int npages);
 void snp_set_wakeup_secondary_cpu(void);
 bool snp_init(struct boot_params *bp);
-void snp_abort(void);
+void __init __noreturn snp_abort(void);
 int snp_issue_guest_request(u64 exit_code, struct snp_req_data *input, unsigned long *fw_err);
 #else
 static inline void sev_es_ist_enter(struct pt_regs *regs) { }
diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index 63dc626627a03..ca4a94c7f7f76 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -2100,7 +2100,7 @@ bool __init snp_init(struct boot_params *bp)
 	return true;
 }
 
-void __init snp_abort(void)
+void __init __noreturn snp_abort(void)
 {
 	sev_es_terminate(SEV_TERM_SET_GEN, GHCB_SNP_UNSUPPORTED);
 }
diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 31c719f99f66e..5d87e0b0d85f9 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -162,32 +162,34 @@ static bool __dead_end_function(struct objtool_file *file, struct symbol *func,
 
 	/*
 	 * Unfortunately these have to be hard coded because the noreturn
-	 * attribute isn't provided in ELF data.
+	 * attribute isn't provided in ELF data. Keep 'em sorted.
 	 */
 	static const char * const global_noreturns[] = {
+		"__invalid_creds",
+		"__module_put_and_kthread_exit",
+		"__reiserfs_panic",
 		"__stack_chk_fail",
-		"panic",
+		"__ubsan_handle_builtin_unreachable",
+		"cpu_bringup_and_idle",
+		"cpu_startup_entry",
 		"do_exit",
+		"do_group_exit",
 		"do_task_dead",
-		"kthread_exit",
-		"make_task_dead",
-		"__module_put_and_kthread_exit",
+		"ex_handler_msr_mce",
+		"fortify_panic",
 		"kthread_complete_and_exit",
-		"__reiserfs_panic",
+		"kthread_exit",
+		"kunit_try_catch_throw",
 		"lbug_with_loc",
-		"fortify_panic",
-		"usercopy_abort",
 		"machine_real_restart",
+		"make_task_dead",
+		"panic",
 		"rewind_stack_and_make_dead",
-		"kunit_try_catch_throw",
-		"xen_start_kernel",
-		"cpu_bringup_and_idle",
-		"do_group_exit",
+		"sev_es_terminate",
+		"snp_abort",
 		"stop_this_cpu",
-		"__invalid_creds",
-		"cpu_startup_entry",
-		"__ubsan_handle_builtin_unreachable",
-		"ex_handler_msr_mce",
+		"usercopy_abort",
+		"xen_start_kernel",
 	};
 
 	if (!func)
-- 
2.35.1

