Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32F2657EE19
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 12:07:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238344AbiGWKHI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jul 2022 06:07:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238475AbiGWKGy (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jul 2022 06:06:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFED377546;
        Sat, 23 Jul 2022 03:01:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 027F4B82C21;
        Sat, 23 Jul 2022 10:00:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B7B9C341C0;
        Sat, 23 Jul 2022 10:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658570444;
        bh=QtnsdZLxc5e//iy3s2gLvf5/wn1Pnwcij+P+Wg6G5ag=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1ZYzrpfZRDLnwLz4epgHmUuqyEgbtu4ecHLrb4yrSdUKT47jOnJwwKmKgQYKNNV5M
         wjXujk19fAEiaQo8C5T5fMh2YD+mRLEaeTnUpjmFf9yVRLaqg4xfzimMq5DGWQxe/I
         3+rSyFapyoYVHUB+sPKzz2yKjJYZmz9aB4VzJQcE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.10 089/148] x86/bpf: Use alternative RET encoding
Date:   Sat, 23 Jul 2022 11:55:01 +0200
Message-Id: <20220723095249.358079262@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220723095224.302504400@linuxfoundation.org>
References: <20220723095224.302504400@linuxfoundation.org>
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
[bwh: Backported to 5.10: add the necessary cnt variable to emit_return()]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/net/bpf_jit_comp.c |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -399,6 +399,22 @@ static void emit_indirect_jump(u8 **ppro
 	*pprog = prog;
 }
 
+static void emit_return(u8 **pprog, u8 *ip)
+{
+	u8 *prog = *pprog;
+	int cnt = 0;
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
@@ -1443,7 +1459,7 @@ emit_jmp:
 			ctx->cleanup_addr = proglen;
 			pop_callee_regs(&prog, callee_regs_used);
 			EMIT1(0xC9);         /* leave */
-			EMIT1(0xC3);         /* ret */
+			emit_return(&prog, image + addrs[i - 1] + (prog - temp));
 			break;
 
 		default:
@@ -1884,7 +1900,7 @@ int arch_prepare_bpf_trampoline(struct b
 	if (flags & BPF_TRAMP_F_SKIP_FRAME)
 		/* skip our return address and return to parent */
 		EMIT4(0x48, 0x83, 0xC4, 8); /* add rsp, 8 */
-	EMIT1(0xC3); /* ret */
+	emit_return(&prog, prog);
 	/* Make sure the trampoline generation logic doesn't overflow */
 	if (WARN_ON_ONCE(prog > (u8 *)image_end - BPF_INSN_SAFETY)) {
 		ret = -EFAULT;


