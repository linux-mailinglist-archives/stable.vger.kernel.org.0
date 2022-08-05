Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E3EA58B103
	for <lists+stable@lfdr.de>; Fri,  5 Aug 2022 23:13:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240977AbiHEVNo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Aug 2022 17:13:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233731AbiHEVNn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Aug 2022 17:13:43 -0400
Received: from smtp-relay-canonical-0.canonical.com (smtp-relay-canonical-0.canonical.com [185.125.188.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 790AF61D57
        for <stable@vger.kernel.org>; Fri,  5 Aug 2022 14:13:42 -0700 (PDT)
Received: from quatroqueijos (unknown [179.93.213.100])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id 6AF613F044;
        Fri,  5 Aug 2022 21:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1659734020;
        bh=NYzSBs33zWEgk5fdR2Ti9Ht+US7NLJuaR3QAp/lO7NM=;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
         Content-Type:In-Reply-To;
        b=iUnsnzBZy8JCyrobqiwzlXQcff5SkFuKkMPDS2ypnVdi0aO1zc/vNhH0nrvqH0uzD
         5Y6aa7yATG8GLwjqC4aCyykZNZ/zIR2y6IAHCOJv7L4w3/i57DTaueR3qPt1YU1Nhi
         hdntPwMOje02bYvA6yGEv62bNdnvMtIZ+w4QtYDjVDvrpx1x9SKWrHTtWxDzoh4JPa
         1bk5B1wa5z2pYHqs4D/EVSigSywp9BqYt66XmWFKT3qOF5W9HDkiSj5HMXnBriFVFu
         kz2I7qVO3ERsV0ROfK0Jo4ZnkLkAL5KF+iuxoHr6yH2l+kDTj08+sjM0yMP5bW1yHB
         fIVt/D9Lmd+xA==
Date:   Fri, 5 Aug 2022 18:13:33 -0300
From:   Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
To:     Paul Gortmaker <paul.gortmaker@windriver.com>
Cc:     stable@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: v5.15.57 regression - boot panic after retbleed backports with
 CONFIG_KPROBES_SANITY_TEST=y
Message-ID: <Yu2H/Rdg/U4bHWaY@quatroqueijos>
References: <20220805200438.GC42579@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220805200438.GC42579@windriver.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 05, 2022 at 04:04:38PM -0400, Paul Gortmaker wrote:
> The panic comes from the sanity test code, but after trying to boil down the
> .config differences between the kitchen sink our test team uses, and a
> "defconfig", it seems there are at least a couple extra dependencies for
> creating a reproducer:
> 
>   make defconfig
>   echo CONFIG_FUNCTION_TRACER=y >> .config
>   echo CONFIG_KPROBES_SANITY_TEST=y >> .config
>   echo CONFIG_UNWINDER_FRAME_POINTER=y >> .config
>   yes "" | make oldconfig
> 
> Note that ftrace is probably just opening the door to CONFIG_KPROBES_ON_FTRACE=y
> 
> The report I got was with gcc-11 on an Atom; I was able to reproduce it
> with the default gcc-7 found on Ubuntu 18.04 and booting on a Xeon v2 -
> so it seems to not be specific to gcc options or processor features.
> 
> I don't know if the v5.15 backports were specifically tested to be fully
> bisectable, but if we assume they are, a bisect between 56 and 57 says:
> 
>    commit 1d61a2988612ac0632134454d5407c63ae0b9d42 (refs/bisect/bad)
>    Author: Peter Zijlstra <peterz@infradead.org>
>    Date:   Tue Jun 14 23:15:45 2022 +0200
>    
>        x86: Use return-thunk in asm code
>        
>        commit aa3d480315ba6c3025a60958e1981072ea37c3df upstream.
>        
>        Use the return thunk in asm code. If the thunk isn't needed, it will
>        get patched into a RET instruction during boot by apply_returns().
> 
> Splat follows:
> 
>    rcu: Hierarchical SRCU implementation.
>    Kprobe smoke test: started
>    BUG: unable to handle page fault for address: ffffffffc110f3e7
>    #PF: supervisor instruction fetch in kernel mode
>    #PF: error_code(0x0010) - not-present page
>    PGD b2c60f067 P4D b2c60f067 PUD b2c611067 PMD 0
>    Oops: 0010 [#1] SMP NOPTI
>    CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.15.57 #33
>    Hardware name: Intel Corporation S2600CP/S2600CP, BIOS SE5C600.86B.02.06.E006.013120181511 01/31/2018
>    RIP: 0010:0xffffffffc110f3e7
>    Code: Unable to access opcode bytes at RIP 0xffffffffc110f3bd.
>    RSP: 0000:ffffae4bc006be38 EFLAGS: 00010246
>    RAX: ffffffffb973f310 RBX: 0000000000000000 RCX: 0000000000000000
>    RDX: 0000000000000000 RSI: 0000000000000000 RDI: 000000005856e7bd
>    RBP: ffffae4bc006be60 R08: 0000000000000000 R09: 0000000000000001
>    R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000001
>    R13: ffffffffbae38560 R14: 0000000000000000 R15: 0000000000000000
>    FS:  0000000000000000(0000) GS:ffff8c92df800000(0000) knlGS:0000000000000000
>    CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>    CR2: ffffffffc110f3bd CR3: 0000000b2c60c001 CR4: 00000000001706f0
>    Call Trace:
>     <TASK>
>     ? kprobe_target+0x5/0x20
>     ? init_test_probes+0x78/0x420
>     init_kprobes+0x16c/0x18e
>     ? init_optprobes+0x27/0x27
>     do_one_initcall+0x43/0x1d0
>     kernel_init_freeable+0xf1/0x240
>     ? rest_init+0xd0/0xd0
>     kernel_init+0x1a/0x120
>     ret_from_fork+0x1f/0x30
>     </TASK>
>    Modules linked in:
>    CR2: ffffffffc110f3e7
>    ---[ end trace 759f040622219261 ]---

Can you try the patch below?

Thanks.
Cascardo.

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 74c2f88a43d0..6bb479ce1ae4 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -321,12 +321,12 @@ create_trampoline(struct ftrace_ops *ops, unsigned int *tramp_size)
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
 
@@ -364,15 +364,10 @@ create_trampoline(struct ftrace_ops *ops, unsigned int *tramp_size)
 		goto fail;
 
 	ip = trampoline + size;
-
-	/* The trampoline ends with ret(q) */
-	retq = (unsigned long)ftrace_stub;
 	if (cpu_feature_enabled(X86_FEATURE_RETHUNK))
 		memcpy(ip, text_gen_insn(JMP32_INSN_OPCODE, ip, &__x86_return_thunk), JMP32_INSN_SIZE);
 	else
-		ret = copy_from_kernel_nofault(ip, (void *)retq, RET_SIZE);
-	if (WARN_ON(ret < 0))
-		goto fail;
+		memcpy(ip, retq, sizeof(retq));
 
 	/* No need to test direct calls on created trampolines */
 	if (ops->flags & FTRACE_OPS_FL_SAVE_REGS) {
