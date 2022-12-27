Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1C39656A4F
	for <lists+stable@lfdr.de>; Tue, 27 Dec 2022 13:00:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231819AbiL0MAT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Dec 2022 07:00:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231789AbiL0L7a (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Dec 2022 06:59:30 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA5ABB877;
        Tue, 27 Dec 2022 03:59:17 -0800 (PST)
Date:   Tue, 27 Dec 2022 11:59:16 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1672142356;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cylJvI8osvyqey7DWdSttpYewiFgqulFKxAGNRWbU9Q=;
        b=RJ3s7HOdzQ73h6p2/salRUkx2HJnvgmuzIErHDVXhL13xXLTFij/cnA0CfAOzsrpLIlfoF
        tYOre6M+/kl4ZXsorbqlYbKNruguEuK3M6GHK/TFEMZSnO/E9u5WwWQixp/58/PQyDMF9T
        JdG23Ze3UYvp0MSF6R7za+5j2wsgb37i6W4WSc+BLlVinKFm6I3agkc67VRd0o4056931h
        px/pdQDtsV6Dq6Dcd2gws5IBbeODoP7tSvRN5MrhIQiW+tIOrugeERllOr+Kyu9LSpqpfw
        rfhtIRw6YjeMJEJrz+d92WSxNanho6Ar8bgOICC8g8I2cIGaeXzqubcvxItP2A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1672142356;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cylJvI8osvyqey7DWdSttpYewiFgqulFKxAGNRWbU9Q=;
        b=DnL5x7QW4rRij6OpHW+MLTgFmUGMPzbtPtDPw9gRIfUeISWRC5jX0Z7EFRXjMdvzx9LdzC
        g9E2t1wMonDUyyBA==
From:   "tip-bot2 for Masami Hiramatsu (Google)" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/kprobes: Fix kprobes instruction boudary check
 with CONFIG_RETHUNK
Cc:     Peter Zijlstra <peterz@infradead.org>,
        "Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
        stable@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <167146051026.1374301.392728975473572291.stgit@devnote3>
References: <167146051026.1374301.392728975473572291.stgit@devnote3>
MIME-Version: 1.0
Message-ID: <167214235617.4906.15076844034764823176.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     1993bf97992df2d560287f3c4120eda57426843d
Gitweb:        https://git.kernel.org/tip/1993bf97992df2d560287f3c4120eda57426843d
Author:        Masami Hiramatsu (Google) <mhiramat@kernel.org>
AuthorDate:    Mon, 19 Dec 2022 23:35:10 +09:00
Committer:     Peter Zijlstra <peterz@infradead.org>
CommitterDate: Tue, 27 Dec 2022 12:51:58 +01:00

x86/kprobes: Fix kprobes instruction boudary check with CONFIG_RETHUNK

Since the CONFIG_RETHUNK and CONFIG_SLS will use INT3 for stopping
speculative execution after RET instruction, kprobes always failes to
check the probed instruction boundary by decoding the function body if
the probed address is after such sequence. (Note that some conditional
code blocks will be placed after function return, if compiler decides
it is not on the hot path.)

This is because kprobes expects kgdb puts the INT3 as a software
breakpoint and it will replace the original instruction.
But these INT3 are not such purpose, it doesn't need to recover the
original instruction.

To avoid this issue, kprobes checks whether the INT3 is owned by
kgdb or not, and if so, stop decoding and make it fail. The other
INT3 will come from CONFIG_RETHUNK/CONFIG_SLS and those can be
treated as a one-byte instruction.

Fixes: e463a09af2f0 ("x86: Add straight-line-speculation mitigation")
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/167146051026.1374301.392728975473572291.stgit@devnote3
---
 arch/x86/kernel/kprobes/core.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/kprobes/core.c b/arch/x86/kernel/kprobes/core.c
index 6629968..b36f3c3 100644
--- a/arch/x86/kernel/kprobes/core.c
+++ b/arch/x86/kernel/kprobes/core.c
@@ -37,6 +37,7 @@
 #include <linux/extable.h>
 #include <linux/kdebug.h>
 #include <linux/kallsyms.h>
+#include <linux/kgdb.h>
 #include <linux/ftrace.h>
 #include <linux/kasan.h>
 #include <linux/moduleloader.h>
@@ -281,12 +282,15 @@ static int can_probe(unsigned long paddr)
 		if (ret < 0)
 			return 0;
 
+#ifdef CONFIG_KGDB
 		/*
-		 * Another debugging subsystem might insert this breakpoint.
-		 * In that case, we can't recover it.
+		 * If there is a dynamically installed kgdb sw breakpoint,
+		 * this function should not be probed.
 		 */
-		if (insn.opcode.bytes[0] == INT3_INSN_OPCODE)
+		if (insn.opcode.bytes[0] == INT3_INSN_OPCODE &&
+		    kgdb_has_hit_break(addr))
 			return 0;
+#endif
 		addr += insn.length;
 	}
 
