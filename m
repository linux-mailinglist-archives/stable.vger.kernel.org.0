Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9925359B325
	for <lists+stable@lfdr.de>; Sun, 21 Aug 2022 12:33:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229836AbiHUKdI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Aug 2022 06:33:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbiHUKdI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Aug 2022 06:33:08 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DD936555;
        Sun, 21 Aug 2022 03:33:07 -0700 (PDT)
Date:   Sun, 21 Aug 2022 10:33:03 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1661077984;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AkL+xh74pmzfFytjn67BBr102XsZF2Xfe6HRVXtM7so=;
        b=S3+AqkFsSz9JiuyMZnqyj0O02pAN9aFw7VNWtvICbxelndRaaAzbKau73xlkmRfagORR78
        QLTFWsjMOAl0hjHlBI+MXEM3JoFI2UETkIVEPH4nvsT1b18ZN63d6Jaub13rsCksL6DEDi
        XzfMOCQb9UHC0HNJ2lSkmOhc3e342neMV1Dm3sr/rGHoUZpNQ4tGoGKrCj16a0ncXqHpJd
        Tm1rokMwBrTVqTiaYr/AaSV3GAn6YmaujiRh9vvysBTy8KuuU8zVIg7fNOLZL6uv2FzkiZ
        d1n0C8K3izB/vM2ekA+w7EME5nwCCYf4t8zAI2SbdyOOq+/rZI04xGMIDeHtCg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1661077984;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AkL+xh74pmzfFytjn67BBr102XsZF2Xfe6HRVXtM7so=;
        b=e3knuuocJacqoYUGNiIfZUa1eySg5TzieEZzQh9ETHOcWtxGaBIxudQ6338oQKoSheCNY7
        FRMD5GHAfqU3xyBg==
From:   "tip-bot2 for Chen Zhongjin" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/unwind/orc: Unwind ftrace trampolines with
 correct ORC entry
Cc:     Chen Zhongjin <chenzhongjin@huawei.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>,
        <stable@vger.kernel.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20220819084334.244016-1-chenzhongjin@huawei.com>
References: <20220819084334.244016-1-chenzhongjin@huawei.com>
MIME-Version: 1.0
Message-ID: <166107798320.401.17179497604353962909.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     fc2e426b1161761561624ebd43ce8c8d2fa058da
Gitweb:        https://git.kernel.org/tip/fc2e426b1161761561624ebd43ce8c8d2fa058da
Author:        Chen Zhongjin <chenzhongjin@huawei.com>
AuthorDate:    Fri, 19 Aug 2022 16:43:34 +08:00
Committer:     Ingo Molnar <mingo@kernel.org>
CommitterDate: Sun, 21 Aug 2022 12:19:32 +02:00

x86/unwind/orc: Unwind ftrace trampolines with correct ORC entry

When meeting ftrace trampolines in ORC unwinding, unwinder uses address
of ftrace_{regs_}call address to find the ORC entry, which gets next frame at
sp+176.

If there is an IRQ hitting at sub $0xa8,%rsp, the next frame should be
sp+8 instead of 176. It makes unwinder skip correct frame and throw
warnings such as "wrong direction" or "can't access registers", etc,
depending on the content of the incorrect frame address.

By adding the base address ftrace_{regs_}caller with the offset
*ip - ops->trampoline*, we can get the correct address to find the ORC entry.

Also change "caller" to "tramp_addr" to make variable name conform to
its content.

[ mingo: Clarified the changelog a bit. ]

Fixes: 6be7fa3c74d1 ("ftrace, orc, x86: Handle ftrace dynamically allocated trampolines")
Signed-off-by: Chen Zhongjin <chenzhongjin@huawei.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220819084334.244016-1-chenzhongjin@huawei.com
---
 arch/x86/kernel/unwind_orc.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/unwind_orc.c b/arch/x86/kernel/unwind_orc.c
index 38185ae..0ea57da 100644
--- a/arch/x86/kernel/unwind_orc.c
+++ b/arch/x86/kernel/unwind_orc.c
@@ -93,22 +93,27 @@ static struct orc_entry *orc_find(unsigned long ip);
 static struct orc_entry *orc_ftrace_find(unsigned long ip)
 {
 	struct ftrace_ops *ops;
-	unsigned long caller;
+	unsigned long tramp_addr, offset;
 
 	ops = ftrace_ops_trampoline(ip);
 	if (!ops)
 		return NULL;
 
+	/* Set tramp_addr to the start of the code copied by the trampoline */
 	if (ops->flags & FTRACE_OPS_FL_SAVE_REGS)
-		caller = (unsigned long)ftrace_regs_call;
+		tramp_addr = (unsigned long)ftrace_regs_caller;
 	else
-		caller = (unsigned long)ftrace_call;
+		tramp_addr = (unsigned long)ftrace_caller;
+
+	/* Now place tramp_addr to the location within the trampoline ip is at */
+	offset = ip - ops->trampoline;
+	tramp_addr += offset;
 
 	/* Prevent unlikely recursion */
-	if (ip == caller)
+	if (ip == tramp_addr)
 		return NULL;
 
-	return orc_find(caller);
+	return orc_find(tramp_addr);
 }
 #else
 static struct orc_entry *orc_ftrace_find(unsigned long ip)
