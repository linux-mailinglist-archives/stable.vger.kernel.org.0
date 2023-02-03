Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFCD8688BE4
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 01:35:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232240AbjBCAfi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Feb 2023 19:35:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232168AbjBCAfd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Feb 2023 19:35:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3C3767783;
        Thu,  2 Feb 2023 16:35:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4E8BC61D4C;
        Fri,  3 Feb 2023 00:35:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCEC0C433A0;
        Fri,  3 Feb 2023 00:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675384525;
        bh=w2+gKam0hgvqls1hiqaw8OhtqAs87LqFnf26zQZbz5Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ve8JpqbKAA++gANijkDSDXTx0Kr5qVkhYzIlAJuCRUwgFaX2Ttmpzxgix5ZlbUY4A
         UA8YdB2JTl0FnhDiaRNavlC7XMzRdbp+dYX2c8IAaHVfRtzvDbRR8nki7glziQq4nF
         UcXg2uGpJiIfXahXJBQmKENkvrtDdyzWhqOEErBxV4UDFzYLALQPkacLVfyvFuGNLS
         mH7EACjmffwDtlLgGnXPIrXOrUVFFqIyNXbikF5yng5rQKJaeL/rouSyKAHrZHDncX
         SBwGx6XMLL1ogah35QEX+x9/JkFUNXZzMh0pRwqdJQcPrC2DXc8iXmzOIomCRUT0Ri
         q7kUJbmnjXrxA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     stable@vger.kernel.org
Cc:     Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
        Kees Cook <keescook@chromium.org>,
        SeongJae Park <sj@kernel.org>,
        Seth Jenkins <sethjenkins@google.com>,
        Jann Horn <jannh@google.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 4.14 v2 06/15] h8300: Fix build errors from do_exit() to make_task_dead() transition
Date:   Thu,  2 Feb 2023 16:33:45 -0800
Message-Id: <20230203003354.85691-7-ebiggers@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203003354.85691-1-ebiggers@kernel.org>
References: <20230203003354.85691-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>

commit ab4ababdf77ccc56c7301c751dff49c79709c51c upstream.

When building ARCH=h8300 defconfig:

arch/h8300/kernel/traps.c: In function 'die':
arch/h8300/kernel/traps.c:109:2: error: implicit declaration of function
'make_dead_task' [-Werror=implicit-function-declaration]
  109 |  make_dead_task(SIGSEGV);
      |  ^~~~~~~~~~~~~~

arch/h8300/mm/fault.c: In function 'do_page_fault':
arch/h8300/mm/fault.c:54:2: error: implicit declaration of function
'make_dead_task' [-Werror=implicit-function-declaration]
   54 |  make_dead_task(SIGKILL);
      |  ^~~~~~~~~~~~~~

The function's name is make_task_dead(), change it so there is no more
build error.

Additionally, include linux/sched/task.h in arch/h8300/kernel/traps.c
to avoid the same error because do_exit()'s declaration is in kernel.h
but make_task_dead()'s is in task.h, which is not included in traps.c.

Fixes: 0e25498f8cd4 ("exit: Add and use make_task_dead.")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Link: https://lkml.kernel.org/r/20211227184851.2297759-3-nathan@kernel.org
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/h8300/kernel/traps.c | 3 ++-
 arch/h8300/mm/fault.c     | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/h8300/kernel/traps.c b/arch/h8300/kernel/traps.c
index a284c126f07a6..090adaee4b84c 100644
--- a/arch/h8300/kernel/traps.c
+++ b/arch/h8300/kernel/traps.c
@@ -17,6 +17,7 @@
 #include <linux/types.h>
 #include <linux/sched.h>
 #include <linux/sched/debug.h>
+#include <linux/sched/task.h>
 #include <linux/mm_types.h>
 #include <linux/kernel.h>
 #include <linux/errno.h>
@@ -110,7 +111,7 @@ void die(const char *str, struct pt_regs *fp, unsigned long err)
 	dump(fp);
 
 	spin_unlock_irq(&die_lock);
-	make_dead_task(SIGSEGV);
+	make_task_dead(SIGSEGV);
 }
 
 static int kstack_depth_to_print = 24;
diff --git a/arch/h8300/mm/fault.c b/arch/h8300/mm/fault.c
index a8d8fc63780e4..573825c3cb708 100644
--- a/arch/h8300/mm/fault.c
+++ b/arch/h8300/mm/fault.c
@@ -52,7 +52,7 @@ asmlinkage int do_page_fault(struct pt_regs *regs, unsigned long address,
 	printk(" at virtual address %08lx\n", address);
 	if (!user_mode(regs))
 		die("Oops", regs, error_code);
-	make_dead_task(SIGKILL);
+	make_task_dead(SIGKILL);
 
 	return 1;
 }
-- 
2.39.1

