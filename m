Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DF21541A78
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:33:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379878AbiFGVd1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:33:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381188AbiFGVbo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:31:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 719D922CEC4;
        Tue,  7 Jun 2022 12:04:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0571D6184B;
        Tue,  7 Jun 2022 19:04:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11BCEC385A2;
        Tue,  7 Jun 2022 19:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628645;
        bh=mmgUOoWsvmyCloJOJysj77fpGdpLejOlNk4+m0u4eXA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NiNZ2ceDGGPtn6RU7znjtUkH1aU24+8evayYWB2ZVr+6k+fvRwxcxBd/OEvycqa3K
         dm/pc0g5CyU1RYZLAtBNZ70N51ZOe6Ig81ldd4m/lYm+1pQc32C3GHMV7mdirC587b
         YNc/9vafk0hfvB8Ko1aIi0eDtXWF3bFsrYhf+5ng=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Alexander Popov <alex.popov@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Kees Cook <keescook@chromium.org>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 403/879] arm64: stackleak: fix current_top_of_stack()
Date:   Tue,  7 Jun 2022 18:58:41 +0200
Message-Id: <20220607165014.560134923@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Rutland <mark.rutland@arm.com>

[ Upstream commit e85094c31ddb794ac41c299a5a7a68243148f829 ]

Due to some historical confusion, arm64's current_top_of_stack() isn't
what the stackleak code expects. This could in theory result in a number
of problems, and practically results in an unnecessary performance hit.
We can avoid this by aligning the arm64 implementation with the x86
implementation.

The arm64 implementation of current_top_of_stack() was added
specifically for stackleak in commit:

  0b3e336601b82c6a ("arm64: Add support for STACKLEAK gcc plugin")

This was intended to be equivalent to the x86 implementation, but the
implementation, semantics, and performance characteristics differ
wildly:

* On x86, current_top_of_stack() returns the top of the current task's
  task stack, regardless of which stack is in active use.

  The implementation accesses a percpu variable which the x86 entry code
  maintains, and returns the location immediately above the pt_regs on
  the task stack (above which x86 has some padding).

* On arm64 current_top_of_stack() returns the top of the stack in active
  use (i.e. the one which is currently being used).

  The implementation checks the SP against a number of
  potentially-accessible stacks, and will BUG() if no stack is found.

The core stackleak_erase() code determines the upper bound of stack to
erase with:

| if (on_thread_stack())
|         boundary = current_stack_pointer;
| else
|         boundary = current_top_of_stack();

On arm64 stackleak_erase() is always called on a task stack, and
on_thread_stack() should always be true. On x86, stackleak_erase() is
mostly called on a trampoline stack, and is sometimes called on a task
stack.

Currently, this results in a lot of unnecessary code being generated for
arm64 for the impossible !on_thread_stack() case. Some of this is
inlined, bloating stackleak_erase(), while portions of this are left
out-of-line and permitted to be instrumented (which would be a
functional problem if that code were reachable).

As a first step towards improving this, this patch aligns arm64's
implementation of current_top_of_stack() with x86's, always returning
the top of the current task's stack. With GCC 11.1.0 this results in the
bulk of the unnecessary code being removed, including all of the
out-of-line instrumentable code.

While I don't believe there's a functional problem in practice I've
marked this as a fix since the semantic was clearly wrong, the fix
itself is simple, and other code might rely upon this in future.

Fixes: 0b3e336601b82c6a ("arm64: Add support for STACKLEAK gcc plugin")
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Alexander Popov <alex.popov@linux.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Will Deacon <will@kernel.org>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20220427173128.2603085-2-mark.rutland@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/processor.h | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/processor.h b/arch/arm64/include/asm/processor.h
index 73e38d9a540c..6b1a12c23fe7 100644
--- a/arch/arm64/include/asm/processor.h
+++ b/arch/arm64/include/asm/processor.h
@@ -381,12 +381,10 @@ long get_tagged_addr_ctrl(struct task_struct *task);
  * of header definitions for the use of task_stack_page.
  */
 
-#define current_top_of_stack()								\
-({											\
-	struct stack_info _info;							\
-	BUG_ON(!on_accessible_stack(current, current_stack_pointer, 1, &_info));	\
-	_info.high;									\
-})
+/*
+ * The top of the current task's task stack
+ */
+#define current_top_of_stack()	((unsigned long)current->stack + THREAD_SIZE)
 #define on_thread_stack()	(on_task_stack(current, current_stack_pointer, 1, NULL))
 
 #endif /* __ASSEMBLY__ */
-- 
2.35.1



