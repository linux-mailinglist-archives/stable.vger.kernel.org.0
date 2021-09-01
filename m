Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BDA43FDB0A
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:17:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344217AbhIAMhV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:37:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:60574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344042AbhIAMfX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:35:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 58782610CE;
        Wed,  1 Sep 2021 12:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499601;
        bh=/Vbtolf7Wtj+zZa8OIMa+MTe96rh0C/4eW+B4g47CHI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HYZsftF8690CG7TTSO7lELp5207jaDieFUV9nfP/qEDdWMm5lRILrRivbqBNoABh5
         8ZoHotfT8kR4PM91LXjEhaijdH0H0wGU3Aub3W1JAT58NZ4yHsGKxi/zradoeMLS+7
         OIjjjYtVdHR6UEDEF5oBQwmwyrkEOp9hZHyHcWKs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vincent Chen <vincent.chen@sifive.com>,
        Jisheng Zhang <jszhang@kernel.org>,
        Palmer Dabbelt <palmerdabbelt@google.com>
Subject: [PATCH 5.10 014/103] riscv: Ensure the value of FP registers in the core dump file is up to date
Date:   Wed,  1 Sep 2021 14:27:24 +0200
Message-Id: <20210901122301.006330592@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122300.503008474@linuxfoundation.org>
References: <20210901122300.503008474@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincent Chen <vincent.chen@sifive.com>

commit 379eb01c21795edb4ca8d342503bd2183a19ec3a upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kernel/ptrace.c |    4 ++++
 1 file changed, 4 insertions(+)

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
@@ -56,6 +57,9 @@ static int riscv_fpr_get(struct task_str
 {
 	struct __riscv_d_ext_state *fstate = &target->thread.fstate;
 
+	if (target == current)
+		fstate_save(current, task_pt_regs(current));
+
 	membuf_write(&to, fstate, offsetof(struct __riscv_d_ext_state, fcsr));
 	membuf_store(&to, fstate->fcsr);
 	return membuf_zero(&to, 4);	// explicitly pad


