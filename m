Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C3502535A1
	for <lists+stable@lfdr.de>; Wed, 26 Aug 2020 19:00:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727099AbgHZRAw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Aug 2020 13:00:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:56538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727069AbgHZRAv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Aug 2020 13:00:51 -0400
Received: from localhost (c-67-180-165-146.hsd1.ca.comcast.net [67.180.165.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3AE5D20738;
        Wed, 26 Aug 2020 17:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598461250;
        bh=cTd2VJ/kFLsBgXZtZiYIMwczja87CvcwlW7JDSKrnF8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gIfG9SVjhQP3e+XQz8dfWZzXytfK3V7vuiduCBWaSSE+iNK8vlTleppuRlnSCSiJ8
         +1qFvNvoTgH3Mf4yxPbpsWc2H/JBJZWOpL1/3hbgdhfbdd4v5TFjv0DLs9PXDaZrV1
         axD5eL/z7VwSxFbvzhCfo+PVe9gDHBgBh2Dz+3bg=
From:   Andy Lutomirski <luto@kernel.org>
To:     x86@kernel.org
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@kernel.org>, stable@vger.kernel.org
Subject: [PATCH 2/2] selftests/x86/fsgsbase: Test PTRACE_PEEKUSER for GSBASE with invalid LDT GS
Date:   Wed, 26 Aug 2020 10:00:46 -0700
Message-Id: <c618ae86d1f757e01b1a8e79869f553cb88acf9a.1598461151.git.luto@kernel.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <cover.1598461151.git.luto@kernel.org>
References: <cover.1598461151.git.luto@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This tesst commit 8ab49526b53d ("x86/fsgsbase/64: Fix NULL deref in
86_fsgsbase_read_task").  Unpatched kernels will OOPS.

Cc: stable@vger.kernel.org
Signed-off-by: Andy Lutomirski <luto@kernel.org>
---
 tools/testing/selftests/x86/fsgsbase.c | 65 ++++++++++++++++++++++++++
 1 file changed, 65 insertions(+)

diff --git a/tools/testing/selftests/x86/fsgsbase.c b/tools/testing/selftests/x86/fsgsbase.c
index 0056e2597f53..7161cfc2e60b 100644
--- a/tools/testing/selftests/x86/fsgsbase.c
+++ b/tools/testing/selftests/x86/fsgsbase.c
@@ -443,6 +443,68 @@ static void test_unexpected_base(void)
 
 #define USER_REGS_OFFSET(r) offsetof(struct user_regs_struct, r)
 
+static void test_ptrace_write_gs_read_base(void)
+{
+	int status;
+	pid_t child = fork();
+
+	if (child < 0)
+		err(1, "fork");
+
+	if (child == 0) {
+		printf("[RUN]\tPTRACE_POKE GS, read GSBASE back\n");
+
+		printf("[RUN]\tARCH_SET_GS to 1\n");
+		if (syscall(SYS_arch_prctl, ARCH_SET_GS, 1) != 0)
+			err(1, "ARCH_SET_GS");
+
+		if (ptrace(PTRACE_TRACEME, 0, NULL, NULL) != 0)
+			err(1, "PTRACE_TRACEME");
+
+		raise(SIGTRAP);
+		_exit(0);
+	}
+
+	wait(&status);
+
+	if (WSTOPSIG(status) == SIGTRAP) {
+		unsigned long base;
+		unsigned long gs_offset = USER_REGS_OFFSET(gs);
+		unsigned long base_offset = USER_REGS_OFFSET(gs_base);
+
+		/* Read the initial base.  It should be 1. */
+		base = ptrace(PTRACE_PEEKUSER, child, base_offset, NULL);
+		if (base == 1) {
+			printf("[OK]\tGSBASE started at 1\n");
+		} else {
+			nerrs++;
+			printf("[FAIL]\tGSBASE started at 0x%lx\n", base);
+		}
+
+		printf("[RUN]\tSet GS = 0x7, read GSBASE\n");
+
+		/* Poke an LDT selector into GS. */
+		if (ptrace(PTRACE_POKEUSER, child, gs_offset, 0x7) != 0)
+			err(1, "PTRACE_POKEUSER");
+
+		/* And read the base. */
+		base = ptrace(PTRACE_PEEKUSER, child, base_offset, NULL);
+
+		if (base == 0 || base == 1) {
+			printf("[OK]\tGSBASE reads as 0x%lx with invalid GS\n", base);
+		} else {
+			nerrs++;
+			printf("[FAIL]\tGSBASE=0x%lx (should be 0 or 1)\n", base);
+		}
+	}
+
+	ptrace(PTRACE_CONT, child, NULL, NULL);
+
+	wait(&status);
+	if (!WIFEXITED(status))
+		printf("[WARN]\tChild didn't exit cleanly.\n");
+}
+
 static void test_ptrace_write_gsbase(void)
 {
 	int status;
@@ -529,6 +591,9 @@ int main()
 	shared_scratch = mmap(NULL, 4096, PROT_READ | PROT_WRITE,
 			      MAP_ANONYMOUS | MAP_SHARED, -1, 0);
 
+	/* Do these tests before we have an LDT. */
+	test_ptrace_write_gs_read_base();
+
 	/* Probe FSGSBASE */
 	sethandler(SIGILL, sigill, 0);
 	if (sigsetjmp(jmpbuf, 1) == 0) {
-- 
2.25.4

