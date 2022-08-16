Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91908595863
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 12:33:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234551AbiHPKdU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 06:33:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234709AbiHPKcv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 06:32:51 -0400
Received: from smtp-relay-canonical-0.canonical.com (smtp-relay-canonical-0.canonical.com [185.125.188.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27BD11232F0
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 01:28:24 -0700 (PDT)
Received: from localhost.localdomain (1.general.cascardo.us.vpn [10.172.70.58])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id B1C5E3F0DE;
        Tue, 16 Aug 2022 08:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1660638503;
        bh=OadckB7rpBH8YdJBf2CB1pksXH/Ya84w5OS9Cv/KGYg=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=qaIbutOkdSganT8gxv0sEwxYLh4apW739ffxBgYYcjIyGfzdo3WVCxMJS+jAEpGJJ
         zYKraJWz3O7Qr7bfd+1ZquQdIYig4mqcYTmK2uNfbS7Xhw7BtdJtZq1kxvETFxbBmu
         +gy4Ktj19Q0jw6UBROtYsuUfRg818N5VQKKUeS6hKyG1LQR4BvqcVs0V3cyhMJEnkO
         83jaqNr3/02csYdS3B1NqRBfdqKP1W+iT09SM8xfdR7gFtsSjbWMMhQRncZtH+owMB
         O6b0fwsc7/7eCBktY8eTIGF7SPPsgUGkJwmP4kSYuNPit0zoCdPpefQa7xRgMOe5ov
         sOtK9JswKQoNg==
From:   Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
To:     stable@vger.kernel.org
Cc:     paul.gortmaker@windriver.com, gregkh@linuxfoundation.org,
        peterz@infradead.org, bp@suse.de, jpoimboe@kernel.org,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 2/3] x86/ibt,ftrace: Make function-graph play nice
Date:   Tue, 16 Aug 2022 05:26:57 -0300
Message-Id: <20220816082658.172387-2-cascardo@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220816082658.172387-1-cascardo@canonical.com>
References: <20220816041224.GE73154@windriver.com>
 <20220816082658.172387-1-cascardo@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

commit e52fc2cf3f662828cc0d51c4b73bed73ad275fce upstream.

Return trampoline must not use indirect branch to return; while this
preserves the RSB, it is fundamentally incompatible with IBT. Instead
use a retpoline like ROP gadget that defeats IBT while not unbalancing
the RSB.

And since ftrace_stub is no longer a plain RET, don't use it to copy
from. Since RET is a trivial instruction, poke it directly.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Josh Poimboeuf <jpoimboe@redhat.com>
Link: https://lore.kernel.org/r/20220308154318.347296408@infradead.org
[cascardo: remove ENDBR]
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
---
 arch/x86/kernel/ftrace.c    |  9 ++-------
 arch/x86/kernel/ftrace_64.S | 19 +++++++++++++++----
 2 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 5080f578236a..8160d1dc6ed3 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -322,12 +322,12 @@ create_trampoline(struct ftrace_ops *ops, unsigned int *tramp_size)
 	unsigned long offset;
 	unsigned long npages;
 	unsigned long size;
-	unsigned long retq;
 	unsigned long *ptr;
 	void *trampoline;
 	void *ip;
 	/* 48 8b 15 <offset> is movq <offset>(%rip), %rdx */
 	unsigned const char op_ref[] = { 0x48, 0x8b, 0x15 };
+	unsigned const char retq[] = { RET_INSN_OPCODE, INT3_INSN_OPCODE };
 	union ftrace_op_code_union op_ptr;
 	int ret;
 
@@ -365,12 +365,7 @@ create_trampoline(struct ftrace_ops *ops, unsigned int *tramp_size)
 		goto fail;
 
 	ip = trampoline + size;
-
-	/* The trampoline ends with ret(q) */
-	retq = (unsigned long)ftrace_stub;
-	ret = copy_from_kernel_nofault(ip, (void *)retq, RET_SIZE);
-	if (WARN_ON(ret < 0))
-		goto fail;
+	memcpy(ip, retq, RET_SIZE);
 
 	/* No need to test direct calls on created trampolines */
 	if (ops->flags & FTRACE_OPS_FL_SAVE_REGS) {
diff --git a/arch/x86/kernel/ftrace_64.S b/arch/x86/kernel/ftrace_64.S
index d6af81d1b788..6cc14a835991 100644
--- a/arch/x86/kernel/ftrace_64.S
+++ b/arch/x86/kernel/ftrace_64.S
@@ -181,7 +181,6 @@ SYM_INNER_LABEL(ftrace_graph_call, SYM_L_GLOBAL)
 
 /*
  * This is weak to keep gas from relaxing the jumps.
- * It is also used to copy the RET for trampolines.
  */
 SYM_INNER_LABEL_ALIGN(ftrace_stub, SYM_L_WEAK)
 	UNWIND_HINT_FUNC
@@ -335,7 +334,7 @@ SYM_FUNC_START(ftrace_graph_caller)
 SYM_FUNC_END(ftrace_graph_caller)
 
 SYM_FUNC_START(return_to_handler)
-	subq  $24, %rsp
+	subq  $16, %rsp
 
 	/* Save the return values */
 	movq %rax, (%rsp)
@@ -347,7 +346,19 @@ SYM_FUNC_START(return_to_handler)
 	movq %rax, %rdi
 	movq 8(%rsp), %rdx
 	movq (%rsp), %rax
-	addq $24, %rsp
-	JMP_NOSPEC rdi
+
+	addq $16, %rsp
+	/*
+	 * Jump back to the old return address. This cannot be JMP_NOSPEC rdi
+	 * since IBT would demand that contain ENDBR, which simply isn't so for
+	 * return addresses. Use a retpoline here to keep the RSB balanced.
+	 */
+	ANNOTATE_INTRA_FUNCTION_CALL
+	call .Ldo_rop
+	int3
+.Ldo_rop:
+	mov %rdi, (%rsp)
+	UNWIND_HINT_FUNC
+	RET
 SYM_FUNC_END(return_to_handler)
 #endif
-- 
2.34.1

