Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38FAB514707
	for <lists+stable@lfdr.de>; Fri, 29 Apr 2022 12:44:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357691AbiD2KpG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Apr 2022 06:45:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357586AbiD2KpF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Apr 2022 06:45:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A06C4C6ED7;
        Fri, 29 Apr 2022 03:41:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2D2D8B8344F;
        Fri, 29 Apr 2022 10:41:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D888C385A4;
        Fri, 29 Apr 2022 10:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651228901;
        bh=bpq7XH8KqcoY0LbK7M7v1M575hE7glHNC4hi5Cns6o4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lkAJD3OaZHLrkFi4wpenvDt0ZNWQ9m/EqhEZrnlVxAQFV2g6506G7IgSLntMlcgRV
         Ag4njXunGd5Bcao4VZKHnt/HyhMxfdWSBolp2T4h19MvOUz2w1RMBEZSoYQU/vZ+Ux
         8PH94khyINOYTPzSCAZ/v18TcG63uN1IOyVm1jSY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josh Poimboeuf <jpoimboe@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, X86 ML <x86@kernel.org>,
        Daniel Xu <dxu@dxuuu.xyz>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Abhishek Sagar <sagar.abhishek@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Paul McKenney <paulmck@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 4.19 10/12] ia64: kprobes: Fix to pass correct trampoline address to the handler
Date:   Fri, 29 Apr 2022 12:41:27 +0200
Message-Id: <20220429104048.762619339@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220429104048.459089941@linuxfoundation.org>
References: <20220429104048.459089941@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu <mhiramat@kernel.org>

commit a7fe2378454cf46cd5e2776d05e72bbe8f0a468c upstream.

The following commit:

   Commit e792ff804f49 ("ia64: kprobes: Use generic kretprobe trampoline handler")

Passed the wrong trampoline address to __kretprobe_trampoline_handler(): it
passes the descriptor address instead of function entry address.

Pass the right parameter.

Also use correct symbol dereference function to get the function address
from 'kretprobe_trampoline' - an IA64 special.

Link: https://lkml.kernel.org/r/163163042696.489837.12551102356265354730.stgit@devnote2

Fixes: e792ff804f49 ("ia64: kprobes: Use generic kretprobe trampoline handler")
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: X86 ML <x86@kernel.org>
Cc: Daniel Xu <dxu@dxuuu.xyz>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Abhishek Sagar <sagar.abhishek@gmail.com>
Cc: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc: Paul McKenney <paulmck@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/ia64/kernel/kprobes.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/arch/ia64/kernel/kprobes.c
+++ b/arch/ia64/kernel/kprobes.c
@@ -424,7 +424,7 @@ int __kprobes trampoline_probe_handler(s
 	struct hlist_node *tmp;
 	unsigned long flags, orig_ret_address = 0;
 	unsigned long trampoline_address =
-		((struct fnptr *)kretprobe_trampoline)->ip;
+		(unsigned long)dereference_function_descriptor(kretprobe_trampoline);
 
 	INIT_HLIST_HEAD(&empty_rp);
 	kretprobe_hash_lock(current, &head, &flags);
@@ -500,7 +500,7 @@ void __kprobes arch_prepare_kretprobe(st
 	ri->ret_addr = (kprobe_opcode_t *)regs->b0;
 
 	/* Replace the return addr with trampoline addr */
-	regs->b0 = ((struct fnptr *)kretprobe_trampoline)->ip;
+	regs->b0 = (unsigned long)dereference_function_descriptor(kretprobe_trampoline);
 }
 
 /* Check the instruction in the slot is break */
@@ -1030,14 +1030,14 @@ static struct kprobe trampoline_p = {
 int __init arch_init_kprobes(void)
 {
 	trampoline_p.addr =
-		(kprobe_opcode_t *)((struct fnptr *)kretprobe_trampoline)->ip;
+		dereference_function_descriptor(kretprobe_trampoline);
 	return register_kprobe(&trampoline_p);
 }
 
 int __kprobes arch_trampoline_kprobe(struct kprobe *p)
 {
 	if (p->addr ==
-		(kprobe_opcode_t *)((struct fnptr *)kretprobe_trampoline)->ip)
+		dereference_function_descriptor(kretprobe_trampoline))
 		return 1;
 
 	return 0;


