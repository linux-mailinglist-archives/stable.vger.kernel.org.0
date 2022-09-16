Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF05D5BAB4D
	for <lists+stable@lfdr.de>; Fri, 16 Sep 2022 12:35:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231551AbiIPKP5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Sep 2022 06:15:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231557AbiIPKPU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Sep 2022 06:15:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BD26AC27B;
        Fri, 16 Sep 2022 03:11:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A7A4862A0E;
        Fri, 16 Sep 2022 10:10:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE493C433D6;
        Fri, 16 Sep 2022 10:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663323047;
        bh=D9ZTblQTWswgtNqdFT7zwI8hMW+MQ7IUPqy74KAz8Bc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RRLrqipCQ4zv7Q5gzfUM5zRutembA9lX4lH9duJVTZ3ObvRwCE5kE4XSjK+INbfty
         edEASnCD2Bdn99769POUPYEgjTS0vigp7BTAruXAcxyrolaKKV/xHm3KB+WtCAZ4Ou
         iAIDRg7gLR4bpF06l/kkZ5TvtCIFz7poSK46wC4o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 5.10 21/24] x86/ibt,ftrace: Make function-graph play nice
Date:   Fri, 16 Sep 2022 12:08:46 +0200
Message-Id: <20220916100446.304580185@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220916100445.354452396@linuxfoundation.org>
References: <20220916100445.354452396@linuxfoundation.org>
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
[OP: adjusted context for 5.10-stable]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/ftrace.c    |    9 ++-------
 arch/x86/kernel/ftrace_64.S |   19 +++++++++++++++----
 2 files changed, 17 insertions(+), 11 deletions(-)

--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -322,12 +322,12 @@ create_trampoline(struct ftrace_ops *ops
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
 
@@ -365,12 +365,7 @@ create_trampoline(struct ftrace_ops *ops
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
--- a/arch/x86/kernel/ftrace_64.S
+++ b/arch/x86/kernel/ftrace_64.S
@@ -170,7 +170,6 @@ SYM_INNER_LABEL(ftrace_graph_call, SYM_L
 
 /*
  * This is weak to keep gas from relaxing the jumps.
- * It is also used to copy the RET for trampolines.
  */
 SYM_INNER_LABEL_ALIGN(ftrace_stub, SYM_L_WEAK)
 	UNWIND_HINT_FUNC
@@ -325,7 +324,7 @@ SYM_FUNC_END(ftrace_graph_caller)
 
 SYM_CODE_START(return_to_handler)
 	UNWIND_HINT_EMPTY
-	subq  $24, %rsp
+	subq  $16, %rsp
 
 	/* Save the return values */
 	movq %rax, (%rsp)
@@ -337,7 +336,19 @@ SYM_CODE_START(return_to_handler)
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
 SYM_CODE_END(return_to_handler)
 #endif


