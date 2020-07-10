Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EE6F21B5D8
	for <lists+stable@lfdr.de>; Fri, 10 Jul 2020 15:07:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727915AbgGJNHQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jul 2020 09:07:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:47532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727003AbgGJNHP (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Jul 2020 09:07:15 -0400
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F7B52078D;
        Fri, 10 Jul 2020 13:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594386435;
        bh=6TKIGlVUk8aiJ/udG+4VmarKyP6moY7SjuO2lC9xD7c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AhLwVXv7DIHX5Xc7VDxldQ9j+b/97RuX+p7trA/2gD4P98dLGJyoY6lhNPlPe+XHk
         DpDgOcSEJlFEDZB4M1zyGOBobNWGj8tVdjJNswXJ9NQJBWPA7hio/PKWEOeZzmywR/
         eSF7H+k2I9YGz+G5lcAIb8By/VTm4sXM9CHhcswI=
From:   Will Deacon <will@kernel.org>
To:     linux-arm-kernel@lists.infradead.org
Cc:     catalin.marinas@arm.com, Will Deacon <will@kernel.org>,
        kernel-team@android.com, Mark Rutland <mark.rutland@arm.com>,
        Luis Machado <luis.machado@linaro.org>,
        Keno Fischer <keno@juliacomputing.com>,
        Kees Cook <keescook@chromium.org>, stable@vger.kernel.org
Subject: [PATCH v3 3/7] arm64: compat: Ensure upper 32 bits of x0 are zero on syscall return
Date:   Fri, 10 Jul 2020 14:06:58 +0100
Message-Id: <20200710130702.30658-4-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200710130702.30658-1-will@kernel.org>
References: <20200710130702.30658-1-will@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Although we zero the upper bits of x0 on entry to the kernel from an
AArch32 task, we do not clear them on the exception return path and can
therefore expose 64-bit sign extended syscall return values to userspace
via interfaces such as the 'perf_regs' ABI, which deal exclusively with
64-bit registers.

Explicitly clear the upper 32 bits of x0 on return from a compat system
call.

Cc: <stable@vger.kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Keno Fischer <keno@juliacomputing.com>
Cc: Luis Machado <luis.machado@linaro.org>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/syscall.h | 12 +++++++++++-
 arch/arm64/kernel/syscall.c      |  3 +++
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/syscall.h b/arch/arm64/include/asm/syscall.h
index 65299a2dcf9c..cfc0672013f6 100644
--- a/arch/arm64/include/asm/syscall.h
+++ b/arch/arm64/include/asm/syscall.h
@@ -34,6 +34,10 @@ static inline long syscall_get_error(struct task_struct *task,
 				     struct pt_regs *regs)
 {
 	unsigned long error = regs->regs[0];
+
+	if (is_compat_thread(task_thread_info(task)))
+		error = sign_extend64(error, 31);
+
 	return IS_ERR_VALUE(error) ? error : 0;
 }
 
@@ -47,7 +51,13 @@ static inline void syscall_set_return_value(struct task_struct *task,
 					    struct pt_regs *regs,
 					    int error, long val)
 {
-	regs->regs[0] = (long) error ? error : val;
+	if (error)
+		val = error;
+
+	if (is_compat_thread(task_thread_info(task)))
+		val = lower_32_bits(val);
+
+	regs->regs[0] = val;
 }
 
 #define SYSCALL_MAX_ARGS 6
diff --git a/arch/arm64/kernel/syscall.c b/arch/arm64/kernel/syscall.c
index 7c14466a12af..98a26d4e7b0c 100644
--- a/arch/arm64/kernel/syscall.c
+++ b/arch/arm64/kernel/syscall.c
@@ -50,6 +50,9 @@ static void invoke_syscall(struct pt_regs *regs, unsigned int scno,
 		ret = do_ni_syscall(regs, scno);
 	}
 
+	if (is_compat_task())
+		ret = lower_32_bits(ret);
+
 	regs->regs[0] = ret;
 }
 
-- 
2.27.0.383.g050319c2ae-goog

