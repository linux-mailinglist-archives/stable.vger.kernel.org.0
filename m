Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2689E6A0973
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 14:06:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233362AbjBWNGF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 08:06:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234303AbjBWNGD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 08:06:03 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 853F653ED4
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 05:05:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id CD56ECE2014
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 13:05:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE42AC433D2;
        Thu, 23 Feb 2023 13:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677157556;
        bh=KrTt9QhOIcbcRnS83993I6OOQGfhGmItmJHtzpWm2no=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2d0OYNBLR2VSnil0FmO3DgrJjoX7ikJWrt+mFCzOH4nVy96mTHxO2nQh+7I/aHHKA
         PsdhSCJgx5MKLomOXnRmxjsiDj3rbTXFHso+AVQ0Pq2A14yCojCrxL4AWK+guJO/z1
         NSJWb4EHF5PM2XhqQG91Td43GXaFK0KVhIPbKlhA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, "Erhard F." <erhard_f@mailbox.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        "Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 6.2 04/11] x86/static_call: Add support for Jcc tail-calls
Date:   Thu, 23 Feb 2023 14:04:58 +0100
Message-Id: <20230223130426.369192580@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230223130426.170746546@linuxfoundation.org>
References: <20230223130426.170746546@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

commit 923510c88d2b7d947c4217835fd9ca6bd65cc56c upstream.

Clang likes to create conditional tail calls like:

  0000000000000350 <amd_pmu_add_event>:
  350:       0f 1f 44 00 00          nopl   0x0(%rax,%rax,1) 351: R_X86_64_NONE      __fentry__-0x4
  355:       48 83 bf 20 01 00 00 00         cmpq   $0x0,0x120(%rdi)
  35d:       0f 85 00 00 00 00       jne    363 <amd_pmu_add_event+0x13>     35f: R_X86_64_PLT32     __SCT__amd_pmu_branch_add-0x4
  363:       e9 00 00 00 00          jmp    368 <amd_pmu_add_event+0x18>     364: R_X86_64_PLT32     __x86_return_thunk-0x4

Where 0x35d is a static call site that's turned into a conditional
tail-call using the Jcc class of instructions.

Teach the in-line static call text patching about this.

Notably, since there is no conditional-ret, in that case patch the Jcc
to point at an empty stub function that does the ret -- or the return
thunk when needed.

Reported-by: "Erhard F." <erhard_f@mailbox.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Link: https://lore.kernel.org/r/Y9Kdg9QjHkr9G5b5@hirez.programming.kicks-ass.net
Cc: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/static_call.c |   50 +++++++++++++++++++++++++++++++++++++++---
 1 file changed, 47 insertions(+), 3 deletions(-)

--- a/arch/x86/kernel/static_call.c
+++ b/arch/x86/kernel/static_call.c
@@ -9,6 +9,7 @@ enum insn_type {
 	NOP = 1,  /* site cond-call */
 	JMP = 2,  /* tramp / site tail-call */
 	RET = 3,  /* tramp / site cond-tail-call */
+	JCC = 4,
 };
 
 /*
@@ -25,12 +26,40 @@ static const u8 xor5rax[] = { 0x2e, 0x2e
 
 static const u8 retinsn[] = { RET_INSN_OPCODE, 0xcc, 0xcc, 0xcc, 0xcc };
 
+static u8 __is_Jcc(u8 *insn) /* Jcc.d32 */
+{
+	u8 ret = 0;
+
+	if (insn[0] == 0x0f) {
+		u8 tmp = insn[1];
+		if ((tmp & 0xf0) == 0x80)
+			ret = tmp;
+	}
+
+	return ret;
+}
+
+extern void __static_call_return(void);
+
+asm (".global __static_call_return\n\t"
+     ".type __static_call_return, @function\n\t"
+     ASM_FUNC_ALIGN "\n\t"
+     "__static_call_return:\n\t"
+     ANNOTATE_NOENDBR
+     ANNOTATE_RETPOLINE_SAFE
+     "ret; int3\n\t"
+     ".size __static_call_return, . - __static_call_return \n\t");
+
 static void __ref __static_call_transform(void *insn, enum insn_type type,
 					  void *func, bool modinit)
 {
 	const void *emulate = NULL;
 	int size = CALL_INSN_SIZE;
 	const void *code;
+	u8 op, buf[6];
+
+	if ((type == JMP || type == RET) && (op = __is_Jcc(insn)))
+		type = JCC;
 
 	switch (type) {
 	case CALL:
@@ -57,6 +86,20 @@ static void __ref __static_call_transfor
 		else
 			code = &retinsn;
 		break;
+
+	case JCC:
+		if (!func) {
+			func = __static_call_return;
+			if (cpu_feature_enabled(X86_FEATURE_RETHUNK))
+				func = x86_return_thunk;
+		}
+
+		buf[0] = 0x0f;
+		__text_gen_insn(buf+1, op, insn+1, func, 5);
+		code = buf;
+		size = 6;
+
+		break;
 	}
 
 	if (memcmp(insn, code, size) == 0)
@@ -68,9 +111,9 @@ static void __ref __static_call_transfor
 	text_poke_bp(insn, code, size, emulate);
 }
 
-static void __static_call_validate(void *insn, bool tail, bool tramp)
+static void __static_call_validate(u8 *insn, bool tail, bool tramp)
 {
-	u8 opcode = *(u8 *)insn;
+	u8 opcode = insn[0];
 
 	if (tramp && memcmp(insn+5, tramp_ud, 3)) {
 		pr_err("trampoline signature fail");
@@ -79,7 +122,8 @@ static void __static_call_validate(void
 
 	if (tail) {
 		if (opcode == JMP32_INSN_OPCODE ||
-		    opcode == RET_INSN_OPCODE)
+		    opcode == RET_INSN_OPCODE ||
+		    __is_Jcc(insn))
 			return;
 	} else {
 		if (opcode == CALL_INSN_OPCODE ||


