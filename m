Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7CD620DF46
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 23:54:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388957AbgF2Udy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 16:33:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:37024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732293AbgF2TZQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:25:16 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F193253E4;
        Mon, 29 Jun 2020 15:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593445323;
        bh=0TIgXh0UJBp6NZVUlhYfT7EIO63h8jLGw0n+lEZnSD8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ENbNF3ZVOXFhPnNTN5KKHqP7j3bc/USJxzSGJztKMaJ1vYwJWHMStFgheP1ftPq7R
         VF+qJ7PshSfHODGDX5774jF10xscracrdc6xF7XbavyA5/gaPle2D9Kob9K4sowYMu
         YywiP6kIQTW5TAshg2TMeVBPiRlEet63Vp/H1ils=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Dmitry V. Levin" <ldv@altlinux.org>,
        Elvira Khabirova <lineprinter@altlinux.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.9 089/191] s390: fix syscall_get_error for compat processes
Date:   Mon, 29 Jun 2020 11:38:25 -0400
Message-Id: <20200629154007.2495120-90-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629154007.2495120-1-sashal@kernel.org>
References: <20200629154007.2495120-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.229-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.229-rc1
X-KernelTest-Deadline: 2020-07-01T15:39+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Dmitry V. Levin" <ldv@altlinux.org>

commit b3583fca5fb654af2cfc1c08259abb9728272538 upstream.

If both the tracer and the tracee are compat processes, and gprs[2]
is assigned a value by __poke_user_compat, then the higher 32 bits
of gprs[2] are cleared, IS_ERR_VALUE() always returns false, and
syscall_get_error() always returns 0.

Fix the implementation by sign-extending the value for compat processes
the same way as x86 implementation does.

The bug was exposed to user space by commit 201766a20e30f ("ptrace: add
PTRACE_GET_SYSCALL_INFO request") and detected by strace test suite.

This change fixes strace syscall tampering on s390.

Link: https://lkml.kernel.org/r/20200602180051.GA2427@altlinux.org
Fixes: 753c4dd6a2fa2 ("[S390] ptrace changes")
Cc: Elvira Khabirova <lineprinter@altlinux.org>
Cc: stable@vger.kernel.org # v2.6.28+
Signed-off-by: Dmitry V. Levin <ldv@altlinux.org>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/include/asm/syscall.h | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/s390/include/asm/syscall.h b/arch/s390/include/asm/syscall.h
index 6bc941be69217..166fbd74e316c 100644
--- a/arch/s390/include/asm/syscall.h
+++ b/arch/s390/include/asm/syscall.h
@@ -41,7 +41,17 @@ static inline void syscall_rollback(struct task_struct *task,
 static inline long syscall_get_error(struct task_struct *task,
 				     struct pt_regs *regs)
 {
-	return IS_ERR_VALUE(regs->gprs[2]) ? regs->gprs[2] : 0;
+	unsigned long error = regs->gprs[2];
+#ifdef CONFIG_COMPAT
+	if (test_tsk_thread_flag(task, TIF_31BIT)) {
+		/*
+		 * Sign-extend the value so (int)-EFOO becomes (long)-EFOO
+		 * and will match correctly in comparisons.
+		 */
+		error = (long)(int)error;
+	}
+#endif
+	return IS_ERR_VALUE(error) ? error : 0;
 }
 
 static inline long syscall_get_return_value(struct task_struct *task,
-- 
2.25.1

