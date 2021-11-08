Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6113044A298
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 02:17:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241874AbhKIBTi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 20:19:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:44340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242160AbhKIBRD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 20:17:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0CFA9619EE;
        Tue,  9 Nov 2021 01:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636420005;
        bh=BxmmrVIRePr4MucsBozMFpB1XoznpnJ8Nc9ewJH28Nc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eUsyV0RhWXoP/2glEqa+ZP6p19xB6JAvy1UjOZn6/j5zNDjH5MqxS6ZYEChZmAjOi
         8uedLg1VMSg89rvLAl5gUs09mZGczJH0F8fFf5756EpKhxB/h8BL61+8C1iWlUN7mi
         XjAsV8uCkUK+RQWPSFr15LJQTHAmN+4/4DPVyrTdhkk0La7eoLrwDpcLc+WVBqxc68
         ikQNT6X386RSqvmTm+lXasJDAa4PYKRVtzoqXlxM2cUj4w9z0wwSfzw2HkZDq/avee
         gDRpdowHGXWBYjKRfwWaHZD6q6JPjG727vLpqIQiF+4z8X67+dcuCVySbCnWRJX77J
         vrN4H/9xejtPg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sven Schnelle <svens@stackframe.org>, Helge Deller <deller@gmx.de>,
        Sasha Levin <sashal@kernel.org>,
        James.Bottomley@HansenPartnership.com, linux-parisc@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 46/47] parisc/unwind: fix unwinder when CONFIG_64BIT is enabled
Date:   Mon,  8 Nov 2021 12:50:30 -0500
Message-Id: <20211108175031.1190422-46-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211108175031.1190422-1-sashal@kernel.org>
References: <20211108175031.1190422-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 2d14f17838d23..fa52c939e8a3b 100644
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

