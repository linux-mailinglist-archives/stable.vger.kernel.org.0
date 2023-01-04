Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB34765D526
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 15:09:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239610AbjADOJw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 09:09:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239613AbjADOJ3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 09:09:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 056CF3AA87
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 06:09:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ACBECB81677
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 14:09:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05E26C433EF;
        Wed,  4 Jan 2023 14:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672841346;
        bh=ewxrGeYnVJ2j+ITx0tsSSmlkSAWP6bhabcqRfmJ7vpw=;
        h=Subject:To:Cc:From:Date:From;
        b=lge4iw9TembEaTuTK0fyureeALu632uqUUn34VshEf6rk7tUrObhO5DW5+WY4W0rh
         w9kSwOqYehxFbegy3oaRw9rjr28ajYQzdnW12x/dRlUrLx6XqDdug8OrVB02ffKcbI
         ZcgRLFsayLtA0SahcHBM6DqfaufqQXPyt53cDvb8=
Subject: FAILED: patch "[PATCH] x86/kprobes: Fix optprobe optimization check with" failed to apply to 5.10-stable tree
To:     mhiramat@kernel.org, peterz@infradead.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 04 Jan 2023 15:09:03 +0100
Message-ID: <167284134324455@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

63dc6325ff41 ("x86/kprobes: Fix optprobe optimization check with CONFIG_RETHUNK")
77e768ec1391 ("x86/kprobes: Convert to insn_decode()")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 63dc6325ff41ee9e570bde705ac34a39c5dbeb44 Mon Sep 17 00:00:00 2001
From: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Date: Mon, 19 Dec 2022 23:35:19 +0900
Subject: [PATCH] x86/kprobes: Fix optprobe optimization check with
 CONFIG_RETHUNK

Since the CONFIG_RETHUNK and CONFIG_SLS will use INT3 for stopping
speculative execution after function return, kprobe jump optimization
always fails on the functions with such INT3 inside the function body.
(It already checks the INT3 padding between functions, but not inside
 the function)

To avoid this issue, as same as kprobes, check whether the INT3 comes
from kgdb or not, and if so, stop decoding and make it fail. The other
INT3 will come from CONFIG_RETHUNK/CONFIG_SLS and those can be
treated as a one-byte instruction.

Fixes: e463a09af2f0 ("x86: Add straight-line-speculation mitigation")
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/167146051929.1374301.7419382929328081706.stgit@devnote3

diff --git a/arch/x86/kernel/kprobes/opt.c b/arch/x86/kernel/kprobes/opt.c
index e6b8c5362b94..e57e07b0edb6 100644
--- a/arch/x86/kernel/kprobes/opt.c
+++ b/arch/x86/kernel/kprobes/opt.c
@@ -15,6 +15,7 @@
 #include <linux/extable.h>
 #include <linux/kdebug.h>
 #include <linux/kallsyms.h>
+#include <linux/kgdb.h>
 #include <linux/ftrace.h>
 #include <linux/objtool.h>
 #include <linux/pgtable.h>
@@ -279,19 +280,6 @@ static int insn_is_indirect_jump(struct insn *insn)
 	return ret;
 }
 
-static bool is_padding_int3(unsigned long addr, unsigned long eaddr)
-{
-	unsigned char ops;
-
-	for (; addr < eaddr; addr++) {
-		if (get_kernel_nofault(ops, (void *)addr) < 0 ||
-		    ops != INT3_INSN_OPCODE)
-			return false;
-	}
-
-	return true;
-}
-
 /* Decode whole function to ensure any instructions don't jump into target */
 static int can_optimize(unsigned long paddr)
 {
@@ -334,15 +322,15 @@ static int can_optimize(unsigned long paddr)
 		ret = insn_decode_kernel(&insn, (void *)recovered_insn);
 		if (ret < 0)
 			return 0;
-
+#ifdef CONFIG_KGDB
 		/*
-		 * In the case of detecting unknown breakpoint, this could be
-		 * a padding INT3 between functions. Let's check that all the
-		 * rest of the bytes are also INT3.
+		 * If there is a dynamically installed kgdb sw breakpoint,
+		 * this function should not be probed.
 		 */
-		if (insn.opcode.bytes[0] == INT3_INSN_OPCODE)
-			return is_padding_int3(addr, paddr - offset + size) ? 1 : 0;
-
+		if (insn.opcode.bytes[0] == INT3_INSN_OPCODE &&
+		    kgdb_has_hit_break(addr))
+			return 0;
+#endif
 		/* Recover address */
 		insn.kaddr = (void *)addr;
 		insn.next_byte = (void *)(addr + insn.length);

