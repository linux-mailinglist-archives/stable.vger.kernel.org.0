Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C32FA2A51E5
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:45:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730641AbgKCUpA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:45:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:60846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730970AbgKCUo7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:44:59 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5FE80223C6;
        Tue,  3 Nov 2020 20:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436298;
        bh=9v4zpMQhZU57GbnMAGHxc6f7onzLt6d9E9+TJ5LhrAM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bm8IehGutx/JCXI8s+UzWbVvrlDAvEjiLKc8AKKA6Lq9p4fZRoceFFNQikD/v38vR
         CqFFdkcNsEJ3L7vZgoAhE7Mce+3iZE7uGWRJy9TYGgA52ZljrkOHxfitrcH7eyqc0t
         VW6cx7C1DV/mr0L+ybbvwsBzWOyfvasseAnB99ls=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andy Lutomirski <luto@kernel.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 5.9 190/391] selftests/x86/fsgsbase: Test PTRACE_PEEKUSER for GSBASE with invalid LDT GS
Date:   Tue,  3 Nov 2020 21:34:01 +0100
Message-Id: <20201103203359.709330186@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Lutomirski <luto@kernel.org>

commit 1b9abd1755ad947d7c9913e92e7837b533124c90 upstream.

This tests commit:

  8ab49526b53d ("x86/fsgsbase/64: Fix NULL deref in 86_fsgsbase_read_task")

Unpatched kernels will OOPS.

Signed-off-by: Andy Lutomirski <luto@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/c618ae86d1f757e01b1a8e79869f553cb88acf9a.1598461151.git.luto@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/testing/selftests/x86/fsgsbase.c |   65 +++++++++++++++++++++++++++++++++
 1 file changed, 65 insertions(+)

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


