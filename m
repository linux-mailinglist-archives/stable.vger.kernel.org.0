Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D12B220622D
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:09:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392376AbgFWU4v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:56:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:40180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392510AbgFWUnU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:43:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 78E9F2070E;
        Tue, 23 Jun 2020 20:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592945001;
        bh=hCGzX3Xu/Hpancbw3z3g4E5LxuqQw193GktQeyXp204=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dA+GQvqAUzzp3d4VCN1KOC3cNq9yzJiRRDDLVypZmoK7TipFaUXiYxGIO1cETtLQ8
         ZlKtFWd64joda25VocVhtiIC/qpJGxYKzQuYpZs05u/ZQgd9qIbeeKXAURHZ1nPofI
         hf4IWSYcgzFK5EChmq6pvjhFNRGXVNKbHv+iXycw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Elvira Khabirova <lineprinter@altlinux.org>,
        "Dmitry V. Levin" <ldv@altlinux.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 4.19 195/206] s390: fix syscall_get_error for compat processes
Date:   Tue, 23 Jun 2020 21:58:43 +0200
Message-Id: <20200623195326.629457027@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195316.864547658@linuxfoundation.org>
References: <20200623195316.864547658@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry V. Levin <ldv@altlinux.org>

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
 arch/s390/include/asm/syscall.h |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/arch/s390/include/asm/syscall.h
+++ b/arch/s390/include/asm/syscall.h
@@ -38,7 +38,17 @@ static inline void syscall_rollback(stru
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


