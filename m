Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6283559A3A3
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 20:04:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353577AbiHSQm1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:42:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353569AbiHSQkC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:40:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7FC8107DA7;
        Fri, 19 Aug 2022 09:08:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0BECCB8281A;
        Fri, 19 Aug 2022 16:07:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 428DDC43470;
        Fri, 19 Aug 2022 16:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660925261;
        bh=edBzfxKF2CtnaaPIFtuLy8Zc8zyI8zFq4FhY4N0gyYo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XmDq2mUGN2irhKIixPBSwXa/FeXO6pqVOuL/fEzcgJiKDZUZIQRh2IZ6f8m2GPpRj
         Xyd+R9a17HVuco/s4cLbhHMPqCrCMP8A8V9yly1zBIc0yjJ5Vbxq8JBAnzUpzelDbR
         x8sjwjm4Hbwq7fCIOtfm7zpgrjzrS0alLH4ZFESw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrea Righi <andrea.righi@canonical.com>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 435/545] x86/entry: Build thunk_$(BITS) only if CONFIG_PREEMPTION=y
Date:   Fri, 19 Aug 2022 17:43:25 +0200
Message-Id: <20220819153848.879857019@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
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

From: Andrea Righi <andrea.righi@canonical.com>

[ Upstream commit de979c83574abf6e78f3fa65b716515c91b2613d ]

With CONFIG_PREEMPTION disabled, arch/x86/entry/thunk_$(BITS).o becomes
an empty object file.

With some old versions of binutils (i.e., 2.35.90.20210113-1ubuntu1) the
GNU assembler doesn't generate a symbol table for empty object files and
objtool fails with the following error when a valid symbol table cannot
be found:

  arch/x86/entry/thunk_64.o: warning: objtool: missing symbol table

To prevent this from happening, build thunk_$(BITS).o only if
CONFIG_PREEMPTION is enabled.

BugLink: https://bugs.launchpad.net/bugs/1911359

Fixes: 320100a5ffe5 ("x86/entry: Remove the TRACE_IRQS cruft")
Signed-off-by: Andrea Righi <andrea.righi@canonical.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/Ys/Ke7EWjcX+ZlXO@arighi-desktop
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/entry/Makefile   | 3 ++-
 arch/x86/entry/thunk_32.S | 2 --
 arch/x86/entry/thunk_64.S | 4 ----
 arch/x86/um/Makefile      | 3 ++-
 4 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/arch/x86/entry/Makefile b/arch/x86/entry/Makefile
index 58533752efab..63dc4b1dfc92 100644
--- a/arch/x86/entry/Makefile
+++ b/arch/x86/entry/Makefile
@@ -21,12 +21,13 @@ CFLAGS_syscall_64.o		+= $(call cc-option,-Wno-override-init,)
 CFLAGS_syscall_32.o		+= $(call cc-option,-Wno-override-init,)
 CFLAGS_syscall_x32.o		+= $(call cc-option,-Wno-override-init,)
 
-obj-y				:= entry.o entry_$(BITS).o thunk_$(BITS).o syscall_$(BITS).o
+obj-y				:= entry.o entry_$(BITS).o syscall_$(BITS).o
 obj-y				+= common.o
 
 obj-y				+= vdso/
 obj-y				+= vsyscall/
 
+obj-$(CONFIG_PREEMPTION)	+= thunk_$(BITS).o
 obj-$(CONFIG_IA32_EMULATION)	+= entry_64_compat.o syscall_32.o
 obj-$(CONFIG_X86_X32_ABI)	+= syscall_x32.o
 
diff --git a/arch/x86/entry/thunk_32.S b/arch/x86/entry/thunk_32.S
index 7591bab060f7..ff6e7003da97 100644
--- a/arch/x86/entry/thunk_32.S
+++ b/arch/x86/entry/thunk_32.S
@@ -29,10 +29,8 @@ SYM_CODE_START_NOALIGN(\name)
 SYM_CODE_END(\name)
 	.endm
 
-#ifdef CONFIG_PREEMPTION
 	THUNK preempt_schedule_thunk, preempt_schedule
 	THUNK preempt_schedule_notrace_thunk, preempt_schedule_notrace
 	EXPORT_SYMBOL(preempt_schedule_thunk)
 	EXPORT_SYMBOL(preempt_schedule_notrace_thunk)
-#endif
 
diff --git a/arch/x86/entry/thunk_64.S b/arch/x86/entry/thunk_64.S
index 1b5044ad8cd0..14776163fbff 100644
--- a/arch/x86/entry/thunk_64.S
+++ b/arch/x86/entry/thunk_64.S
@@ -36,14 +36,11 @@ SYM_FUNC_END(\name)
 	_ASM_NOKPROBE(\name)
 	.endm
 
-#ifdef CONFIG_PREEMPTION
 	THUNK preempt_schedule_thunk, preempt_schedule
 	THUNK preempt_schedule_notrace_thunk, preempt_schedule_notrace
 	EXPORT_SYMBOL(preempt_schedule_thunk)
 	EXPORT_SYMBOL(preempt_schedule_notrace_thunk)
-#endif
 
-#ifdef CONFIG_PREEMPTION
 SYM_CODE_START_LOCAL_NOALIGN(__thunk_restore)
 	popq %r11
 	popq %r10
@@ -58,4 +55,3 @@ SYM_CODE_START_LOCAL_NOALIGN(__thunk_restore)
 	RET
 	_ASM_NOKPROBE(__thunk_restore)
 SYM_CODE_END(__thunk_restore)
-#endif
diff --git a/arch/x86/um/Makefile b/arch/x86/um/Makefile
index 77f70b969d14..3113800da63a 100644
--- a/arch/x86/um/Makefile
+++ b/arch/x86/um/Makefile
@@ -27,7 +27,8 @@ else
 
 obj-y += syscalls_64.o vdso/
 
-subarch-y = ../lib/csum-partial_64.o ../lib/memcpy_64.o ../entry/thunk_64.o
+subarch-y = ../lib/csum-partial_64.o ../lib/memcpy_64.o
+subarch-$(CONFIG_PREEMPTION) += ../entry/thunk_64.o
 
 endif
 
-- 
2.35.1



