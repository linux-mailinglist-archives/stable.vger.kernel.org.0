Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E01957AB65
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 03:11:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240434AbiGTBLY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 21:11:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239996AbiGTBLI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 21:11:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEB5965547;
        Tue, 19 Jul 2022 18:10:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C093BB81DE5;
        Wed, 20 Jul 2022 01:10:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ADF1C341CA;
        Wed, 20 Jul 2022 01:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658279456;
        bh=U/20YFqLlMrRrkc22gSkRRPl4lFXe6nf5l7fumi5Vww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QfYT3JLYBQnrFZ4SKIaMUHE7Qg7r/BWGpmOE3a+5QmP43YxW/7HjC9LUNlZONvo0q
         soqrIkVhmIkp3JMKBkU4i1YZeVkjor6yWzVHOsCxgg1odDJ3e6PFOK13AiDfVjXY4H
         wmOwXShWuh4aDv/efodnHQUKnBlDnuM3vK2L/GnhWNAT15X5h5gcaKMPUuCIdGx1I5
         ffwGjZG1b+EnwMuOEOmdDqQltupEihjp9Vy5u3ENm2bpixAS2PmR/CYYa+eXtWWCMn
         4emss/gfTmmfYqHoQuNlJxghIQwN5xInxHHuSPO8SSvf6pJWVlD6MRlMIl27Rss5WV
         vcU+8cuJJ6epQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, nathan@kernel.org,
        pawan.kumar.gupta@linux.intel.com, llvm@lists.linux.dev
Subject: [PATCH AUTOSEL 5.18 07/54] x86/retpoline: Use -mfunction-return
Date:   Tue, 19 Jul 2022 21:09:44 -0400
Message-Id: <20220720011031.1023305-7-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220720011031.1023305-1-sashal@kernel.org>
References: <20220720011031.1023305-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 0b53c374b9eff2255a386f1f1cfb9a928e52a5ae ]

Utilize -mfunction-return=thunk-extern when available to have the
compiler replace RET instructions with direct JMPs to the symbol
__x86_return_thunk. This does not affect assembler (.S) sources, only C
sources.

-mfunction-return=thunk-extern has been available since gcc 7.3 and
clang 15.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Josh Poimboeuf <jpoimboe@kernel.org>
Tested-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/Makefile                    |  2 ++
 arch/x86/include/asm/nospec-branch.h |  2 ++
 arch/x86/lib/retpoline.S             | 13 +++++++++++++
 3 files changed, 17 insertions(+)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 63d50f65b828..ca3c0de24bc3 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -15,11 +15,13 @@ endif
 ifdef CONFIG_CC_IS_GCC
 RETPOLINE_CFLAGS	:= $(call cc-option,-mindirect-branch=thunk-extern -mindirect-branch-register)
 RETPOLINE_CFLAGS	+= $(call cc-option,-mindirect-branch-cs-prefix)
+RETPOLINE_CFLAGS	+= $(call cc-option,-mfunction-return=thunk-extern)
 RETPOLINE_VDSO_CFLAGS	:= $(call cc-option,-mindirect-branch=thunk-inline -mindirect-branch-register)
 endif
 ifdef CONFIG_CC_IS_CLANG
 RETPOLINE_CFLAGS	:= -mretpoline-external-thunk
 RETPOLINE_VDSO_CFLAGS	:= -mretpoline
+RETPOLINE_CFLAGS	+= $(call cc-option,-mfunction-return=thunk-extern)
 endif
 export RETPOLINE_CFLAGS
 export RETPOLINE_VDSO_CFLAGS
diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
index 5728539a3e77..829c9f827a96 100644
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -123,6 +123,8 @@
 typedef u8 retpoline_thunk_t[RETPOLINE_THUNK_SIZE];
 extern retpoline_thunk_t __x86_indirect_thunk_array[];
 
+extern void __x86_return_thunk(void);
+
 #ifdef CONFIG_RETPOLINE
 
 #define GEN(reg) \
diff --git a/arch/x86/lib/retpoline.S b/arch/x86/lib/retpoline.S
index 2cdd62499d54..4467c21215f4 100644
--- a/arch/x86/lib/retpoline.S
+++ b/arch/x86/lib/retpoline.S
@@ -67,3 +67,16 @@ SYM_CODE_END(__x86_indirect_thunk_array)
 #define GEN(reg) EXPORT_THUNK(reg)
 #include <asm/GEN-for-each-reg.h>
 #undef GEN
+
+/*
+ * This function name is magical and is used by -mfunction-return=thunk-extern
+ * for the compiler to generate JMPs to it.
+ */
+SYM_CODE_START(__x86_return_thunk)
+	UNWIND_HINT_EMPTY
+	ANNOTATE_NOENDBR
+	ret
+	int3
+SYM_CODE_END(__x86_return_thunk)
+
+__EXPORT_THUNK(__x86_return_thunk)
-- 
2.35.1

