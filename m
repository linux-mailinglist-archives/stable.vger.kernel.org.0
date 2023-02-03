Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 467336896D0
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 11:36:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232870AbjBCKdA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 05:33:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233630AbjBCKcW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 05:32:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEB8D16AC6
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 02:30:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9DBD1B82A68
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 10:30:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C118C433EF;
        Fri,  3 Feb 2023 10:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675420225;
        bh=/uPzVAcDzadW3h6SeQ+KRh7R/TIpIcxjqrn2W1EG+OI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WAPQRVa2L6jvqyyM1FLJHh/rJXJNNBLKKfLIaORnK1wJSobrmdBLAEl+ykF7zx6ZR
         a7/VJf1I8lkauWxlwLQjtG1j8Bf/OTR4546CEMoXrq/Q0CF8R4Pc+qi7sTboo9pa1Z
         fL6yvgkwaFZYFfsfAIQxLHsZKR8TaKzVqVzXeN00=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Eric Biggers <ebiggers@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 120/134] h8300: Fix build errors from do_exit() to make_task_dead() transition
Date:   Fri,  3 Feb 2023 11:13:45 +0100
Message-Id: <20230203101029.212204565@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101023.832083974@linuxfoundation.org>
References: <20230203101023.832083974@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/h8300/kernel/traps.c | 3 ++-
 arch/h8300/mm/fault.c     | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/h8300/kernel/traps.c b/arch/h8300/kernel/traps.c
index a284c126f07a..090adaee4b84 100644
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
index a8d8fc63780e..573825c3cb70 100644
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
2.39.0



