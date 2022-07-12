Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06CB7572512
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 21:11:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235704AbiGLTKg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 15:10:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235980AbiGLTKC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 15:10:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B71BCFFE36;
        Tue, 12 Jul 2022 11:52:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B6707B81BBF;
        Tue, 12 Jul 2022 18:52:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 072A0C3411C;
        Tue, 12 Jul 2022 18:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657651956;
        bh=hoHz08tC6oiQQAdYnqJuaTV4rl7eX2oX/fx/GpRDRro=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q4+EW2EXLY88Ovxni1/14b3ECqZG9mejp0m7iEV8wQeZ5q2vvHpb+2AfJf1Mnvclr
         BRrT3jkQg8C2fS3mQ3OZMHylJKLCVXcAfcHYHNH30zGnZ7M+oLO9H/Sdx53AodxC2U
         +AiV5PTe6ctyf11gExyjXQ2JyMwqJSHYZN8GPv50=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 5.18 34/61] objtool: Update Retpoline validation
Date:   Tue, 12 Jul 2022 20:39:31 +0200
Message-Id: <20220712183238.342232911@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220712183236.931648980@linuxfoundation.org>
References: <20220712183236.931648980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

commit 9bb2ec608a209018080ca262f771e6a9ff203b6f upstream.

Update retpoline validation with the new CONFIG_RETPOLINE requirement of
not having bare naked RET instructions.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/nospec-branch.h |    6 ++++++
 arch/x86/mm/mem_encrypt_boot.S       |    2 ++
 arch/x86/xen/xen-head.S              |    1 +
 tools/objtool/check.c                |   19 +++++++++++++------
 4 files changed, 22 insertions(+), 6 deletions(-)

--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -76,6 +76,12 @@
 .endm
 
 /*
+ * (ab)use RETPOLINE_SAFE on RET to annotate away 'bare' RET instructions
+ * vs RETBleed validation.
+ */
+#define ANNOTATE_UNRET_SAFE ANNOTATE_RETPOLINE_SAFE
+
+/*
  * JMP_NOSPEC and CALL_NOSPEC macros can be used instead of a simple
  * indirect jmp/call which may be susceptible to the Spectre variant 2
  * attack.
--- a/arch/x86/mm/mem_encrypt_boot.S
+++ b/arch/x86/mm/mem_encrypt_boot.S
@@ -66,6 +66,7 @@ SYM_FUNC_START(sme_encrypt_execute)
 	pop	%rbp
 
 	/* Offset to __x86_return_thunk would be wrong here */
+	ANNOTATE_UNRET_SAFE
 	ret
 	int3
 SYM_FUNC_END(sme_encrypt_execute)
@@ -154,6 +155,7 @@ SYM_FUNC_START(__enc_copy)
 	pop	%r15
 
 	/* Offset to __x86_return_thunk would be wrong here */
+	ANNOTATE_UNRET_SAFE
 	ret
 	int3
 .L__enc_copy_end:
--- a/arch/x86/xen/xen-head.S
+++ b/arch/x86/xen/xen-head.S
@@ -26,6 +26,7 @@ SYM_CODE_START(hypercall_page)
 	.rept (PAGE_SIZE / 32)
 		UNWIND_HINT_FUNC
 		ANNOTATE_NOENDBR
+		ANNOTATE_UNRET_SAFE
 		ret
 		/*
 		 * Xen will write the hypercall page, and sort out ENDBR.
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -2114,8 +2114,9 @@ static int read_retpoline_hints(struct o
 		}
 
 		if (insn->type != INSN_JUMP_DYNAMIC &&
-		    insn->type != INSN_CALL_DYNAMIC) {
-			WARN_FUNC("retpoline_safe hint not an indirect jump/call",
+		    insn->type != INSN_CALL_DYNAMIC &&
+		    insn->type != INSN_RETURN) {
+			WARN_FUNC("retpoline_safe hint not an indirect jump/call/ret",
 				  insn->sec, insn->offset);
 			return -1;
 		}
@@ -3648,7 +3649,8 @@ static int validate_retpoline(struct obj
 
 	for_each_insn(file, insn) {
 		if (insn->type != INSN_JUMP_DYNAMIC &&
-		    insn->type != INSN_CALL_DYNAMIC)
+		    insn->type != INSN_CALL_DYNAMIC &&
+		    insn->type != INSN_RETURN)
 			continue;
 
 		if (insn->retpoline_safe)
@@ -3663,9 +3665,14 @@ static int validate_retpoline(struct obj
 		if (!strcmp(insn->sec->name, ".init.text") && !module)
 			continue;
 
-		WARN_FUNC("indirect %s found in RETPOLINE build",
-			  insn->sec, insn->offset,
-			  insn->type == INSN_JUMP_DYNAMIC ? "jump" : "call");
+		if (insn->type == INSN_RETURN) {
+			WARN_FUNC("'naked' return found in RETPOLINE build",
+				  insn->sec, insn->offset);
+		} else {
+			WARN_FUNC("indirect %s found in RETPOLINE build",
+				  insn->sec, insn->offset,
+				  insn->type == INSN_JUMP_DYNAMIC ? "jump" : "call");
+		}
 
 		warnings++;
 	}


