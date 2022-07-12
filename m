Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 734B857250E
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 21:11:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235641AbiGLTIl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 15:08:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235550AbiGLTHz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 15:07:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEC42E43D1;
        Tue, 12 Jul 2022 11:51:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A94B861491;
        Tue, 12 Jul 2022 18:51:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF782C3411C;
        Tue, 12 Jul 2022 18:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657651898;
        bh=MXrrOTrkk/RGgoaIHAExHDTa3cUXx3Dyxn8DhpPAaWI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ipHmrddWCTTacHSmkOtwR8SWm0lTgdBIuXm30dvmK9RMy/wYCpWtkfA/DMz0CXz5v
         xT2CVwaM7cE8hB0n/zE53IQIRdl7NJotz6L2u2x5ZZnqzZHstSoVO5BCAkHydoDOzQ
         FqL3VogMvwe6jqMYw1ZEcinhU+q/jsC7es+K3qsw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 5.18 16/61] x86/bpf: Use alternative RET encoding
Date:   Tue, 12 Jul 2022 20:39:13 +0200
Message-Id: <20220712183237.596015580@linuxfoundation.org>
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
@@ -420,6 +420,21 @@ static void emit_indirect_jump(u8 **ppro
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
@@ -1680,7 +1695,7 @@ emit_jmp:
 			ctx->cleanup_addr = proglen;
 			pop_callee_regs(&prog, callee_regs_used);
 			EMIT1(0xC9);         /* leave */
-			EMIT1(0xC3);         /* ret */
+			emit_return(&prog, image + addrs[i - 1] + (prog - temp));
 			break;
 
 		default:
@@ -2157,7 +2172,7 @@ int arch_prepare_bpf_trampoline(struct b
 	if (flags & BPF_TRAMP_F_SKIP_FRAME)
 		/* skip our return address and return to parent */
 		EMIT4(0x48, 0x83, 0xC4, 8); /* add rsp, 8 */
-	EMIT1(0xC3); /* ret */
+	emit_return(&prog, prog);
 	/* Make sure the trampoline generation logic doesn't overflow */
 	if (WARN_ON_ONCE(prog > (u8 *)image_end - BPF_INSN_SAFETY)) {
 		ret = -EFAULT;


