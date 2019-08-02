Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50F0A7F2A1
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 11:50:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405214AbfHBJpZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:45:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:49150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405429AbfHBJpY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:45:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9978920880;
        Fri,  2 Aug 2019 09:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564739124;
        bh=SEWFmYr3x+z3nRgyaUGMWfh3wd0O5TyLhAeLY2PKxhM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iqXBLz9d7J3ut2CBH2xkjlaAKCW6KVQnPf834MHbPCgXm/KqRmq1lUQdobPyUXVd4
         b7eT6LbdekAJZGa4NAqUAdbvPcBHefYnZmummVO8Az8RuyXzX4K3Bj4+6nIGNHUeND
         Gqoo47dmXSn7MJz8471XvYCENt8IMA9IBK8xD2so=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Richard Weinberger <richard@nod.at>,
        Alessio Balsini <balsini@android.com>
Subject: [PATCH 4.9 114/223] um: Allow building and running on older hosts
Date:   Fri,  2 Aug 2019 11:35:39 +0200
Message-Id: <20190802092246.611574930@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092238.692035242@linuxfoundation.org>
References: <20190802092238.692035242@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

commit 0a987645672ebde7844a9c0732a5a25f3d4bb6c6 upstream.

Commit a78ff1112263 ("um: add extended processor state save/restore
support") and b6024b21fec8 ("um: extend fpstate to _xstate to support
YMM registers") forced the use of the x86 FP _xstate and
PTRACE_GETREGSET/SETREGSET. On older hosts, we would neither be able to
build UML nor run it anymore with these two commits applied because we
don't have definitions for struct _xstate nor these two ptrace requests.

We can determine at build time which fp context structure to check
against, just like we can keep using the old i387 fp save/restore if
PTRACE_GETRESET/SETREGSET are not defined.

Fixes: a78ff1112263 ("um: add extended processor state save/restore support")
Fixes: b6024b21fec8 ("um: extend fpstate to _xstate to support YMM registers")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Alessio Balsini <balsini@android.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/um/os-Linux/registers.c |   12 ++++++++----
 arch/x86/um/user-offsets.c       |    4 ++++
 2 files changed, 12 insertions(+), 4 deletions(-)

--- a/arch/x86/um/os-Linux/registers.c
+++ b/arch/x86/um/os-Linux/registers.c
@@ -26,6 +26,7 @@ int save_i387_registers(int pid, unsigne
 
 int save_fp_registers(int pid, unsigned long *fp_regs)
 {
+#ifdef PTRACE_GETREGSET
 	struct iovec iov;
 
 	if (have_xstate_support) {
@@ -34,9 +35,9 @@ int save_fp_registers(int pid, unsigned
 		if (ptrace(PTRACE_GETREGSET, pid, NT_X86_XSTATE, &iov) < 0)
 			return -errno;
 		return 0;
-	} else {
+	} else
+#endif
 		return save_i387_registers(pid, fp_regs);
-	}
 }
 
 int restore_i387_registers(int pid, unsigned long *fp_regs)
@@ -48,6 +49,7 @@ int restore_i387_registers(int pid, unsi
 
 int restore_fp_registers(int pid, unsigned long *fp_regs)
 {
+#ifdef PTRACE_SETREGSET
 	struct iovec iov;
 
 	if (have_xstate_support) {
@@ -56,9 +58,9 @@ int restore_fp_registers(int pid, unsign
 		if (ptrace(PTRACE_SETREGSET, pid, NT_X86_XSTATE, &iov) < 0)
 			return -errno;
 		return 0;
-	} else {
+	} else
+#endif
 		return restore_i387_registers(pid, fp_regs);
-	}
 }
 
 #ifdef __i386__
@@ -122,6 +124,7 @@ int put_fp_registers(int pid, unsigned l
 
 void arch_init_registers(int pid)
 {
+#ifdef PTRACE_GETREGSET
 	struct _xstate fp_regs;
 	struct iovec iov;
 
@@ -129,6 +132,7 @@ void arch_init_registers(int pid)
 	iov.iov_len = sizeof(struct _xstate);
 	if (ptrace(PTRACE_GETREGSET, pid, NT_X86_XSTATE, &iov) == 0)
 		have_xstate_support = 1;
+#endif
 }
 #endif
 
--- a/arch/x86/um/user-offsets.c
+++ b/arch/x86/um/user-offsets.c
@@ -50,7 +50,11 @@ void foo(void)
 	DEFINE(HOST_GS, GS);
 	DEFINE(HOST_ORIG_AX, ORIG_EAX);
 #else
+#if defined(PTRACE_GETREGSET) && defined(PTRACE_SETREGSET)
 	DEFINE(HOST_FP_SIZE, sizeof(struct _xstate) / sizeof(unsigned long));
+#else
+	DEFINE(HOST_FP_SIZE, sizeof(struct _fpstate) / sizeof(unsigned long));
+#endif
 	DEFINE_LONGS(HOST_BX, RBX);
 	DEFINE_LONGS(HOST_CX, RCX);
 	DEFINE_LONGS(HOST_DI, RDI);


