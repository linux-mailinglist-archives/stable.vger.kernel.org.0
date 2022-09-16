Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 371595BAA5F
	for <lists+stable@lfdr.de>; Fri, 16 Sep 2022 12:32:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231655AbiIPKT5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Sep 2022 06:19:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231972AbiIPKTR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Sep 2022 06:19:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F6A3B07D1;
        Fri, 16 Sep 2022 03:13:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 102EFB82547;
        Fri, 16 Sep 2022 10:12:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FB3FC433D6;
        Fri, 16 Sep 2022 10:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663323135;
        bh=l7ifI2D61ypQD6Xd9t895tJj406Be87y8pTmmgihQz8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PeSucU/qqRSaNJjsLT8vJrhZfv7Aiunww6TyGIZfpMFcxM2it2pPx37dd19R1K0d1
         9a+zSgiLUygVMluPyF0Plr0bfpKKp8z68v5/87g6alKxe+j0qFSL0k3P7JK+Ls1Taf
         bGJ12kivpPr/9diwU5pQSXsAYhvz+qXNe6/m3CsM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 09/35] task_stack, x86/cea: Force-inline stack helpers
Date:   Fri, 16 Sep 2022 12:08:32 +0200
Message-Id: <20220916100447.330584007@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220916100446.916515275@linuxfoundation.org>
References: <20220916100446.916515275@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

[ Upstream commit e87f4152e542610d0b4c6c8548964a68a59d2040 ]

Force-inline two stack helpers to fix the following objtool warnings:

  vmlinux.o: warning: objtool: in_task_stack()+0xc: call to task_stack_page() leaves .noinstr.text section
  vmlinux.o: warning: objtool: in_entry_stack()+0x10: call to cpu_entry_stack() leaves .noinstr.text section

Signed-off-by: Borislav Petkov <bp@suse.de>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lore.kernel.org/r/20220324183607.31717-2-bp@alien8.de
Stable-dep-of: 54c3931957f6 ("tracing: hold caller_addr to hardirq_{enable,disable}_ip")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/cpu_entry_area.h | 2 +-
 include/linux/sched/task_stack.h      | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/cpu_entry_area.h b/arch/x86/include/asm/cpu_entry_area.h
index dd5ea1bdf04c5..75efc4c6f0766 100644
--- a/arch/x86/include/asm/cpu_entry_area.h
+++ b/arch/x86/include/asm/cpu_entry_area.h
@@ -143,7 +143,7 @@ extern void cea_set_pte(void *cea_vaddr, phys_addr_t pa, pgprot_t flags);
 
 extern struct cpu_entry_area *get_cpu_entry_area(int cpu);
 
-static inline struct entry_stack *cpu_entry_stack(int cpu)
+static __always_inline struct entry_stack *cpu_entry_stack(int cpu)
 {
 	return &get_cpu_entry_area(cpu)->entry_stack_page.stack;
 }
diff --git a/include/linux/sched/task_stack.h b/include/linux/sched/task_stack.h
index d10150587d819..1009b6b5ce403 100644
--- a/include/linux/sched/task_stack.h
+++ b/include/linux/sched/task_stack.h
@@ -16,7 +16,7 @@
  * try_get_task_stack() instead.  task_stack_page will return a pointer
  * that could get freed out from under you.
  */
-static inline void *task_stack_page(const struct task_struct *task)
+static __always_inline void *task_stack_page(const struct task_struct *task)
 {
 	return task->stack;
 }
-- 
2.35.1



