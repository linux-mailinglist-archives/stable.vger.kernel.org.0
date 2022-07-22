Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31B9557DDDF
	for <lists+stable@lfdr.de>; Fri, 22 Jul 2022 11:35:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235983AbiGVJUT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jul 2022 05:20:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236151AbiGVJTY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Jul 2022 05:19:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E10D7BB228;
        Fri, 22 Jul 2022 02:13:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0BD2261F4F;
        Fri, 22 Jul 2022 09:13:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E208C341C7;
        Fri, 22 Jul 2022 09:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658481211;
        bh=t9OjSjSmFBOXBMMrmj1viWCftNw3XoVmdHmp2Dv1q/s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DuVh9vbQlS9oQXgxtIyg8l8HwXBwJJSeqeMJK8rF6rNQ4PbZXBA1K4zQDjRxvr5rY
         kO2gB7bKCJjeMsu7sBGGPzatJaV7VbulpscBDsgI3Cg6IxuM2gOoQCXA0quWZ9KT4b
         GbX0lFL54Jy+huJIhae6f22IoiR8AWJ5wkHIvd7Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 5.15 33/89] x86/ftrace: Use alternative RET encoding
Date:   Fri, 22 Jul 2022 11:11:07 +0200
Message-Id: <20220722091135.217443379@linuxfoundation.org>
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

commit 1f001e9da6bbf482311e45e48f53c2bd2179e59c upstream.

Use the return thunk in ftrace trampolines, if needed.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
[cascardo: still copy return from ftrace_stub]
[cascardo: use memcpy(text_gen_insn) as there is no __text_gen_insn]
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/ftrace.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -308,7 +308,7 @@ union ftrace_op_code_union {
 	} __attribute__((packed));
 };
 
-#define RET_SIZE		1 + IS_ENABLED(CONFIG_SLS)
+#define RET_SIZE		(IS_ENABLED(CONFIG_RETPOLINE) ? 5 : 1 + IS_ENABLED(CONFIG_SLS))
 
 static unsigned long
 create_trampoline(struct ftrace_ops *ops, unsigned int *tramp_size)
@@ -367,7 +367,10 @@ create_trampoline(struct ftrace_ops *ops
 
 	/* The trampoline ends with ret(q) */
 	retq = (unsigned long)ftrace_stub;
-	ret = copy_from_kernel_nofault(ip, (void *)retq, RET_SIZE);
+	if (cpu_feature_enabled(X86_FEATURE_RETHUNK))
+		memcpy(ip, text_gen_insn(JMP32_INSN_OPCODE, ip, &__x86_return_thunk), JMP32_INSN_SIZE);
+	else
+		ret = copy_from_kernel_nofault(ip, (void *)retq, RET_SIZE);
 	if (WARN_ON(ret < 0))
 		goto fail;
 


