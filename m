Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1ECA157DE13
	for <lists+stable@lfdr.de>; Fri, 22 Jul 2022 11:35:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236024AbiGVJUb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jul 2022 05:20:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236187AbiGVJT1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Jul 2022 05:19:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC291BB23F;
        Fri, 22 Jul 2022 02:13:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0794161F6A;
        Fri, 22 Jul 2022 09:13:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 102C4C341C7;
        Fri, 22 Jul 2022 09:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658481214;
        bh=mF/NTo3jFPn5PYFhpdCOvlbKcfW1wEd+E7B0WinnZkY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ERZpNM7jBKsKHkD6j50YTVrm1ZiDHJlcbu7YxeiNucW4JYfTp6IcfqhDz3xM1nQ5V
         rrOqxGS6IsIgHKUiiFOwIjTdG2ermppKn1zAJ5j5u+Lvj2zRAYWzLUjoeg9lMF8Z51
         767/Fq2L97xcUUMgfJuQlOckhhQLg0YHSaMHYwHg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 5.15 34/89] x86/bpf: Use alternative RET encoding
Date:   Fri, 22 Jul 2022 11:11:08 +0200
Message-Id: <20220722091135.272342062@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220722091133.320803732@linuxfoundation.org>
References: <20220722091133.320803732@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

commit d77cfe594ad50e0bf95d457e02ccd578791b2a15 upstream.

Use the return thunk in eBPF generated code, if needed.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/net/bpf_jit_comp.c |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -406,6 +406,21 @@ static void emit_indirect_jump(u8 **ppro
 	*pprog = prog;
 }
 
+static void emit_return(u8 **pprog, u8 *ip)
+{
+	u8 *prog = *pprog;
+
+	if (cpu_feature_enabled(X86_FEATURE_RETHUNK)) {
+		emit_jump(&prog, &__x86_return_thunk, ip);
+	} else {
+		EMIT1(0xC3);		/* ret */
+		if (IS_ENABLED(CONFIG_SLS))
+			EMIT1(0xCC);	/* int3 */
+	}
+
+	*pprog = prog;
+}
+
 /*
  * Generate the following code:
  *
@@ -1681,7 +1696,7 @@ emit_jmp:
 			ctx->cleanup_addr = proglen;
 			pop_callee_regs(&prog, callee_regs_used);
 			EMIT1(0xC9);         /* leave */
-			EMIT1(0xC3);         /* ret */
+			emit_return(&prog, image + addrs[i - 1] + (prog - temp));
 			break;
 
 		default:
@@ -2127,7 +2142,7 @@ int arch_prepare_bpf_trampoline(struct b
 	if (flags & BPF_TRAMP_F_SKIP_FRAME)
 		/* skip our return address and return to parent */
 		EMIT4(0x48, 0x83, 0xC4, 8); /* add rsp, 8 */
-	EMIT1(0xC3); /* ret */
+	emit_return(&prog, prog);
 	/* Make sure the trampoline generation logic doesn't overflow */
 	if (WARN_ON_ONCE(prog > (u8 *)image_end - BPF_INSN_SAFETY)) {
 		ret = -EFAULT;


