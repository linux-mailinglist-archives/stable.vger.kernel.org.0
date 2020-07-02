Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A41B4212ECC
	for <lists+stable@lfdr.de>; Thu,  2 Jul 2020 23:26:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725954AbgGBV03 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jul 2020 17:26:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:38212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725937AbgGBV02 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jul 2020 17:26:28 -0400
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E3B92145D;
        Thu,  2 Jul 2020 21:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593725188;
        bh=JbF9JoWlbwFwhlTRNzEBP51iy91boBal5fWPnQxbXLc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jkXgNV8Vgia/fe13YExLq+8kdN2h0jNrSRWfd9uy2MsgOQ8V5XCPcnW+KG3Cez9O/
         q4XGk6MrGPEnWhxAdjszVjKnyTSwDvhZ07ClX+OF3DX6CKdgMAMjxXS8y4IRpEFLT4
         eJK163PLBsNhAeCtd169GQWtnb2i6FDW3GyXh6d8=
From:   Will Deacon <will@kernel.org>
To:     linux-arm-kernel@lists.infradead.org
Cc:     Will Deacon <will@kernel.org>, kernel-team@android.com,
        Mark Rutland <mark.rutland@arm.com>,
        Luis Machado <luis.machado@linaro.org>,
        Keno Fischer <keno@juliacomputing.com>, stable@vger.kernel.org
Subject: [PATCH v2 1/4] arm64: ptrace: Add a comment describing our syscall entry/exit trap ABI
Date:   Thu,  2 Jul 2020 22:26:15 +0100
Message-Id: <20200702212618.17800-2-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200702212618.17800-1-will@kernel.org>
References: <20200702212618.17800-1-will@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Our tracehook logic for syscall entry/exit raises a SIGTRAP back to the
tracer following a ptrace request such as PTRACE_SYSCALL. As part of this
procedure, we clobber the reported value of one of the tracee's general
purpose registers (x7 for native tasks, r12 for compat) to indicate
whether the stop occurred on syscall entry or exit. This is a slightly
unfortunate ABI, as it prevents the tracer from accessing the real
register value and is at odds with other similar stops such as seccomp
traps.

Since we're stuck with this ABI, expand the comment in our tracehook
logic to acknowledge the issue and descibe the behaviour in more detail.

Cc: <stable@vger.kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Luis Machado <luis.machado@linaro.org>
Reported-by: Keno Fischer <keno@juliacomputing.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kernel/ptrace.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
index 68b7f34a08f5..d71795dc3dbd 100644
--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -1811,8 +1811,20 @@ static void tracehook_report_syscall(struct pt_regs *regs,
 	unsigned long saved_reg;
 
 	/*
-	 * A scratch register (ip(r12) on AArch32, x7 on AArch64) is
-	 * used to denote syscall entry/exit:
+	 * We have some ABI weirdness here in the way that we handle syscall
+	 * exit stops because we indicate whether or not the stop has been
+	 * signalled from syscall entry or syscall exit by clobbering a general
+	 * purpose register (ip/r12 for AArch32, x7 for AArch64) in the tracee
+	 * and restoring its old value after the stop. This means that:
+	 *
+	 * - Any writes by the tracer to this register during the stop are
+	 *   ignored/discarded.
+	 *
+	 * - The actual value of the register is not available during the stop,
+	 *   so the tracer cannot save it and restore it later.
+	 *
+	 * - Syscall stops behave differently to seccomp and pseudo-step traps
+	 *   (the latter do not nobble any registers).
 	 */
 	regno = (is_compat_task() ? 12 : 7);
 	saved_reg = regs->regs[regno];
-- 
2.27.0.212.ge8ba1cc988-goog

