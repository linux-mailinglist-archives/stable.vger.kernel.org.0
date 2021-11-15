Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99DF6450B88
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:22:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236354AbhKORZ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:25:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:53144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237780AbhKORYD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:24:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 628D960296;
        Mon, 15 Nov 2021 17:17:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636996635;
        bh=DJMPfQoXRoiOyA+t3rEzE0WALsCFOn3cFVcNeqwd9pw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IWi8oKKE0tD//eMlPkQTQ/2fVvZXqk5ZOPbecYnVRIbCBnoA4RpzPQO7OkoDg0sXX
         m7ksX3q5eZHAFQkkKzAqca4VzOkOii2xetcyEOoxU3hw+ayBQ8F/Vng63w6beDFFzN
         gzF4b0R5xdTE4pZmbb35sl2dmPsgSrIMyV/j/G2s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sven Schnelle <svens@stackframe.org>,
        Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 178/355] parisc/unwind: fix unwinder when CONFIG_64BIT is enabled
Date:   Mon, 15 Nov 2021 18:01:42 +0100
Message-Id: <20211115165319.541638162@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165313.549179499@linuxfoundation.org>
References: <20211115165313.549179499@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Schnelle <svens@stackframe.org>

[ Upstream commit 8e0ba125c2bf1030af3267058019ba86da96863f ]

With 64 bit kernels unwind_special() is not working because
it compares the pc to the address of the function descriptor.
Add a helper function that compares pc with the dereferenced
address. This fixes all of the backtraces on my c8000. Without
this changes, a lot of backtraces are missing in kdb or the
show-all-tasks command from /proc/sysrq-trigger.

Signed-off-by: Sven Schnelle <svens@stackframe.org>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/parisc/kernel/unwind.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/arch/parisc/kernel/unwind.c b/arch/parisc/kernel/unwind.c
index 87ae476d1c4f5..86a57fb0e6fae 100644
--- a/arch/parisc/kernel/unwind.c
+++ b/arch/parisc/kernel/unwind.c
@@ -21,6 +21,8 @@
 #include <asm/ptrace.h>
 
 #include <asm/unwind.h>
+#include <asm/switch_to.h>
+#include <asm/sections.h>
 
 /* #define DEBUG 1 */
 #ifdef DEBUG
@@ -203,6 +205,11 @@ int __init unwind_init(void)
 	return 0;
 }
 
+static bool pc_is_kernel_fn(unsigned long pc, void *fn)
+{
+	return (unsigned long)dereference_kernel_function_descriptor(fn) == pc;
+}
+
 static int unwind_special(struct unwind_frame_info *info, unsigned long pc, int frame_size)
 {
 	/*
@@ -221,7 +228,7 @@ static int unwind_special(struct unwind_frame_info *info, unsigned long pc, int
 	extern void * const _call_on_stack;
 #endif /* CONFIG_IRQSTACKS */
 
-	if (pc == (unsigned long) &handle_interruption) {
+	if (pc_is_kernel_fn(pc, handle_interruption)) {
 		struct pt_regs *regs = (struct pt_regs *)(info->sp - frame_size - PT_SZ_ALGN);
 		dbg("Unwinding through handle_interruption()\n");
 		info->prev_sp = regs->gr[30];
@@ -229,13 +236,13 @@ static int unwind_special(struct unwind_frame_info *info, unsigned long pc, int
 		return 1;
 	}
 
-	if (pc == (unsigned long) &ret_from_kernel_thread ||
-	    pc == (unsigned long) &syscall_exit) {
+	if (pc_is_kernel_fn(pc, ret_from_kernel_thread) ||
+	    pc_is_kernel_fn(pc, syscall_exit)) {
 		info->prev_sp = info->prev_ip = 0;
 		return 1;
 	}
 
-	if (pc == (unsigned long) &intr_return) {
+	if (pc_is_kernel_fn(pc, intr_return)) {
 		struct pt_regs *regs;
 
 		dbg("Found intr_return()\n");
@@ -246,20 +253,20 @@ static int unwind_special(struct unwind_frame_info *info, unsigned long pc, int
 		return 1;
 	}
 
-	if (pc == (unsigned long) &_switch_to_ret) {
+	if (pc_is_kernel_fn(pc, _switch_to) ||
+	    pc_is_kernel_fn(pc, _switch_to_ret)) {
 		info->prev_sp = info->sp - CALLEE_SAVE_FRAME_SIZE;
 		info->prev_ip = *(unsigned long *)(info->prev_sp - RP_OFFSET);
 		return 1;
 	}
 
 #ifdef CONFIG_IRQSTACKS
-	if (pc == (unsigned long) &_call_on_stack) {
+	if (pc_is_kernel_fn(pc, _call_on_stack)) {
 		info->prev_sp = *(unsigned long *)(info->sp - FRAME_SIZE - REG_SZ);
 		info->prev_ip = *(unsigned long *)(info->sp - FRAME_SIZE - RP_OFFSET);
 		return 1;
 	}
 #endif
-
 	return 0;
 }
 
-- 
2.33.0



