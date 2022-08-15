Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 617B25937B4
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:29:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243279AbiHOSnk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:43:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244139AbiHOSmP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:42:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 333722B266;
        Mon, 15 Aug 2022 11:26:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C8DFCB81071;
        Mon, 15 Aug 2022 18:26:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C6D2C433D6;
        Mon, 15 Aug 2022 18:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660587962;
        bh=LGF9dF+fKB1PZkg6wP0g76Gr6e1+9+y03v69kg/R34Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZzT+CStbnhzlDib3mDZ+dP2TSVFqE2nBo6KI/8wBN4QzsA6oliE021LbsBnuAhirJ
         NznBHHX9jD3eRen/jU6Fn7nUxy8/xuiDk9muU40nrpWfHHDvUuOpp/JLEwPT4IRcw4
         TI/nE/4fbs0KqLS3vcX+5Rzdu+m2uS7V9K7l02Qk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephane Eranian <eranian@google.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 224/779] x86/extable: Fix ex_handler_msr() print condition
Date:   Mon, 15 Aug 2022 19:57:48 +0200
Message-Id: <20220815180346.862423820@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit a1a5482a2c6e38a3ebed32e571625c56a8cc41a6 ]

On Fri, Jun 17, 2022 at 02:08:52PM +0300, Stephane Eranian wrote:
> Some changes to the way invalid MSR accesses are reported by the
> kernel is causing some problems with messages printed on the
> console.
>
> We have seen several cases of ex_handler_msr() printing invalid MSR
> accesses once but the callstack multiple times causing confusion on
> the console.

> The problem here is that another earlier commit (5.13):
>
> a358f40600b3 ("once: implement DO_ONCE_LITE for non-fast-path "do once" functionality")
>
> Modifies all the pr_*_once() calls to always return true claiming
> that no caller is ever checking the return value of the functions.
>
> This is why we are seeing the callstack printed without the
> associated printk() msg.

Extract the ONCE_IF(cond) part into __ONCE_LTE_IF() and use that to
implement DO_ONCE_LITE_IF() and fix the extable code.

Fixes: a358f40600b3 ("once: implement DO_ONCE_LITE for non-fast-path "do once" functionality")
Reported-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: Stephane Eranian <eranian@google.com>
Link: https://lkml.kernel.org/r/YqyVFsbviKjVGGZ9@worktop.programming.kicks-ass.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/mm/extable.c     | 16 +++++++++-------
 include/linux/once_lite.h | 20 ++++++++++++++++----
 2 files changed, 25 insertions(+), 11 deletions(-)

diff --git a/arch/x86/mm/extable.c b/arch/x86/mm/extable.c
index 13d838e6030b..a9c7efd4b794 100644
--- a/arch/x86/mm/extable.c
+++ b/arch/x86/mm/extable.c
@@ -86,16 +86,18 @@ static bool ex_handler_copy(const struct exception_table_entry *fixup,
 static bool ex_handler_msr(const struct exception_table_entry *fixup,
 			   struct pt_regs *regs, bool wrmsr, bool safe, int reg)
 {
-	if (!safe && wrmsr &&
-	    pr_warn_once("unchecked MSR access error: WRMSR to 0x%x (tried to write 0x%08x%08x) at rIP: 0x%lx (%pS)\n",
-			 (unsigned int)regs->cx, (unsigned int)regs->dx,
-			 (unsigned int)regs->ax,  regs->ip, (void *)regs->ip))
+	if (__ONCE_LITE_IF(!safe && wrmsr)) {
+		pr_warn("unchecked MSR access error: WRMSR to 0x%x (tried to write 0x%08x%08x) at rIP: 0x%lx (%pS)\n",
+			(unsigned int)regs->cx, (unsigned int)regs->dx,
+			(unsigned int)regs->ax,  regs->ip, (void *)regs->ip);
 		show_stack_regs(regs);
+	}
 
-	if (!safe && !wrmsr &&
-	    pr_warn_once("unchecked MSR access error: RDMSR from 0x%x at rIP: 0x%lx (%pS)\n",
-			 (unsigned int)regs->cx, regs->ip, (void *)regs->ip))
+	if (__ONCE_LITE_IF(!safe && !wrmsr)) {
+		pr_warn("unchecked MSR access error: RDMSR from 0x%x at rIP: 0x%lx (%pS)\n",
+			(unsigned int)regs->cx, regs->ip, (void *)regs->ip);
 		show_stack_regs(regs);
+	}
 
 	if (!wrmsr) {
 		/* Pretend that the read succeeded and returned 0. */
diff --git a/include/linux/once_lite.h b/include/linux/once_lite.h
index 861e606b820f..b7bce4983638 100644
--- a/include/linux/once_lite.h
+++ b/include/linux/once_lite.h
@@ -9,15 +9,27 @@
  */
 #define DO_ONCE_LITE(func, ...)						\
 	DO_ONCE_LITE_IF(true, func, ##__VA_ARGS__)
-#define DO_ONCE_LITE_IF(condition, func, ...)				\
+
+#define __ONCE_LITE_IF(condition)					\
 	({								\
 		static bool __section(".data.once") __already_done;	\
-		bool __ret_do_once = !!(condition);			\
+		bool __ret_cond = !!(condition);			\
+		bool __ret_once = false;				\
 									\
-		if (unlikely(__ret_do_once && !__already_done)) {	\
+		if (unlikely(__ret_cond && !__already_done)) {		\
 			__already_done = true;				\
-			func(__VA_ARGS__);				\
+			__ret_once = true;				\
 		}							\
+		unlikely(__ret_once);					\
+	})
+
+#define DO_ONCE_LITE_IF(condition, func, ...)				\
+	({								\
+		bool __ret_do_once = !!(condition);			\
+									\
+		if (__ONCE_LITE_IF(__ret_do_once))			\
+			func(__VA_ARGS__);				\
+									\
 		unlikely(__ret_do_once);				\
 	})
 
-- 
2.35.1



