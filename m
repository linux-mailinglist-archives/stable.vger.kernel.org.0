Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3B963FA98A
	for <lists+stable@lfdr.de>; Sun, 29 Aug 2021 08:49:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234585AbhH2Gup (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Aug 2021 02:50:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:47588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229889AbhH2Gup (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Aug 2021 02:50:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC44660F36;
        Sun, 29 Aug 2021 06:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630219793;
        bh=If4YYfye5nruuf1U6hCUyFyc8I3aM+BoBTmUQCieEIA=;
        h=Subject:To:Cc:From:Date:From;
        b=UuG7EooYqLsasYM8qwlLjJSTn48uw1uZ4bYERFSavV2kWqv8tYX5w1KyPIGtHB9OV
         kgbTgnKIxGYQAqlDXkUIkphscD3LG/+MnAbcmwVEYPLK2I3LZU52PViTRXsIhJ38BR
         AIYyYhOfzX9hjqddMKr30BYAnwCPzWQT5qmfWcu8=
Subject: FAILED: patch "[PATCH] riscv: Ensure the value of FP registers in the core dump file" failed to apply to 5.4-stable tree
To:     vincent.chen@sifive.com, jszhang@kernel.org,
        palmerdabbelt@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 29 Aug 2021 08:49:47 +0200
Message-ID: <16302197877251@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 379eb01c21795edb4ca8d342503bd2183a19ec3a Mon Sep 17 00:00:00 2001
From: Vincent Chen <vincent.chen@sifive.com>
Date: Tue, 3 Aug 2021 17:27:51 +0800
Subject: [PATCH] riscv: Ensure the value of FP registers in the core dump file
 is up to date

The value of FP registers in the core dump file comes from the
thread.fstate. However, kernel saves the FP registers to the thread.fstate
only before scheduling out the process. If no process switch happens
during the exception handling process, kernel will not have a chance to
save the latest value of FP registers to thread.fstate. It will cause the
value of FP registers in the core dump file may be incorrect. To solve this
problem, this patch force lets kernel save the FP register into the
thread.fstate if the target task_struct equals the current.

Signed-off-by: Vincent Chen <vincent.chen@sifive.com>
Reviewed-by: Jisheng Zhang <jszhang@kernel.org>
Fixes: b8c8a9590e4f ("RISC-V: Add FP register ptrace support for gdb.")
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>

diff --git a/arch/riscv/kernel/ptrace.c b/arch/riscv/kernel/ptrace.c
index 1a85305720e8..9c0511119bad 100644
--- a/arch/riscv/kernel/ptrace.c
+++ b/arch/riscv/kernel/ptrace.c
@@ -10,6 +10,7 @@
 #include <asm/ptrace.h>
 #include <asm/syscall.h>
 #include <asm/thread_info.h>
+#include <asm/switch_to.h>
 #include <linux/audit.h>
 #include <linux/ptrace.h>
 #include <linux/elf.h>
@@ -56,6 +57,9 @@ static int riscv_fpr_get(struct task_struct *target,
 {
 	struct __riscv_d_ext_state *fstate = &target->thread.fstate;
 
+	if (target == current)
+		fstate_save(current, task_pt_regs(current));
+
 	membuf_write(&to, fstate, offsetof(struct __riscv_d_ext_state, fcsr));
 	membuf_store(&to, fstate->fcsr);
 	return membuf_zero(&to, 4);	// explicitly pad

