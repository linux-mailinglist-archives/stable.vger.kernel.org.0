Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF99C51006E
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 16:26:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351618AbiDZO3j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 10:29:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351430AbiDZO3i (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 10:29:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B7E65EDEC;
        Tue, 26 Apr 2022 07:26:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C217FB82048;
        Tue, 26 Apr 2022 14:26:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 024D9C385A0;
        Tue, 26 Apr 2022 14:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650983188;
        bh=0ea5hGTk0TwU3R/tjGkehgQxlYdP8U3LnMt1hpRQvZw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aSJqhlqdjCOstRQhUpvxUoryYNSA5dt5jyjBwA4E+glj3V3QTtVddlIVU+c3Qg0VZ
         8165XnhymAqFHOr2wMo4O4LGDLGXA6PyKsmONODO0M89cRqG0gV1guu6y7evhtAEzf
         0x4bUFgDC2LDEiQMQoksvHqq+ml5qYvCyT+TYVGF1zl3y2zKd9alhQJOOFgcs8CcIt
         wIyFpqhjqUErvc8oHvjIOZ5sd8HIuaTOl15qAIaWc2aA0fkUbGz4vyhDCIKo/yhGWE
         ookoZ1AsD5X/oZtx7b19ZK4Lbw+9U+ocyqxZg7fN1B2iSg/AuA9CjQCpLbzGjELn1l
         CMMGOvBXtvnfg==
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     mhiramat@kernel.org, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19.y 3/3] ia64: kprobes: Fix to pass correct trampoline address to the handler
Date:   Tue, 26 Apr 2022 23:26:24 +0900
Message-Id: <165098318419.1366179.670272113133163758.stgit@devnote2>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <165098315444.1366179.5950180330185498273.stgit@devnote2>
References: <165098315444.1366179.5950180330185498273.stgit@devnote2>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 arch/ia64/kernel/kprobes.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/ia64/kernel/kprobes.c b/arch/ia64/kernel/kprobes.c
index aa41bd5cf9b7..7fc0806bbdc9 100644
--- a/arch/ia64/kernel/kprobes.c
+++ b/arch/ia64/kernel/kprobes.c
@@ -424,7 +424,7 @@ int __kprobes trampoline_probe_handler(struct kprobe *p, struct pt_regs *regs)
 	struct hlist_node *tmp;
 	unsigned long flags, orig_ret_address = 0;
 	unsigned long trampoline_address =
-		((struct fnptr *)kretprobe_trampoline)->ip;
+		(unsigned long)dereference_function_descriptor(kretprobe_trampoline);
 
 	INIT_HLIST_HEAD(&empty_rp);
 	kretprobe_hash_lock(current, &head, &flags);
@@ -500,7 +500,7 @@ void __kprobes arch_prepare_kretprobe(struct kretprobe_instance *ri,
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

