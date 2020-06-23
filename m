Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA655206492
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:31:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390589AbgFWVXq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 17:23:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:38180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388816AbgFWUUp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:20:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3085A206C3;
        Tue, 23 Jun 2020 20:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943644;
        bh=SKI79dOQN90epLvsQ6Zdyat8W6mxPWJpwwX8b1e1pRQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ldqB+WIkjAKacurCHBd/TXP3N0oRBmjD1zdoaG90JcSzrDodOFwkIzMm1sB6lqwOo
         nk8vKW3P4vAQhq10pNZktKkwYfrIez3tkCtBUF15QJM1AADsyetiwh6u77uSGovanA
         oBTXtSR7sQDsy82VLrZ001BdZSo7Oif8sni7+PYE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Elvira Khabirova <lineprinter@altlinux.org>,
        "Dmitry V. Levin" <ldv@altlinux.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 5.7 441/477] s390: fix syscall_get_error for compat processes
Date:   Tue, 23 Jun 2020 21:57:18 +0200
Message-Id: <20200623195428.379807417@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
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

diff --git a/arch/s390/include/asm/syscall.h b/arch/s390/include/asm/syscall.h
index f073292e9fdb..d9d5de0f67ff 100644
--- a/arch/s390/include/asm/syscall.h
+++ b/arch/s390/include/asm/syscall.h
@@ -33,7 +33,17 @@ static inline void syscall_rollback(struct task_struct *task,
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


