Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EE5657DE67
	for <lists+stable@lfdr.de>; Fri, 22 Jul 2022 11:36:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234950AbiGVJMB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jul 2022 05:12:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232572AbiGVJLW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Jul 2022 05:11:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3EDAA9B8B;
        Fri, 22 Jul 2022 02:09:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1811861D7E;
        Fri, 22 Jul 2022 09:09:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E7ABC341C6;
        Fri, 22 Jul 2022 09:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658480978;
        bh=MXrrOTrkk/RGgoaIHAExHDTa3cUXx3Dyxn8DhpPAaWI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I8GELO2rZqVgPZ7K43lSxFxcj7eOx5MT7b/yRbVIUwSHKFGv8BtQKwz28VwZES9FL
         whpROAnFabtm2KyQYupRbW+wFfZFdghD/pZW3EROdDCx4NAuqYWZgDO7YDw4+Jx5M+
         ddB4YpZUBMYUryUpKi0MQRetzqsWftp6J5Gg7V98=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 5.18 16/70] x86/bpf: Use alternative RET encoding
Date:   Fri, 22 Jul 2022 11:07:11 +0200
Message-Id: <20220722090651.632392382@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220722090650.665513668@linuxfoundation.org>
References: <20220722090650.665513668@linuxfoundation.org>
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


