Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA33715F050
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:54:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729446AbgBNRxy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 12:53:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:41868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388511AbgBNP6M (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:58:12 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7767824654;
        Fri, 14 Feb 2020 15:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695891;
        bh=NnihoHZO7gG4+vQsjdpCtoIC62QSyg5BA43hTajBID8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T3I9tW8cFPw5qqAzKO2sZBaCrlasquFx9VEkSPco4LOVUqeofEAnCgYAsfwufBZMn
         auNTV4pwqAG2npnh5cLax1fBdw0C+bPPH+3qurFZsT/FaGwhpZzsHcs6OazA9/kCin
         AjHKPir7ITNF6ZGYCNzfq2Z8cNJytxSXYz6jkrI4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vasily Gorbik <gor@linux.ibm.com>,
        Sven Schnelle <sven.schnelle@ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 434/542] s390/ftrace: generate traced function stack frame
Date:   Fri, 14 Feb 2020 10:47:06 -0500
Message-Id: <20200214154854.6746-434-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasily Gorbik <gor@linux.ibm.com>

[ Upstream commit 45f7a0da600d3c409b5ad8d5ddddacd98ddc8840 ]

Currently backtrace from ftraced function does not contain ftraced
function itself. e.g. for "path_openat":

arch_stack_walk+0x15c/0x2d8
stack_trace_save+0x50/0x68
stack_trace_call+0x15e/0x3d8
ftrace_graph_caller+0x0/0x1c <-- ftrace code
do_filp_open+0x7c/0xe8 <-- ftraced function caller
do_open_execat+0x76/0x1b8
open_exec+0x52/0x78
load_elf_binary+0x180/0x1160
search_binary_handler+0x8e/0x288
load_script+0x2a8/0x2b8
search_binary_handler+0x8e/0x288
__do_execve_file.isra.39+0x6fa/0xb40
__s390x_sys_execve+0x56/0x68
system_call+0xdc/0x2d8

Ftraced function is expected in the backtrace by ftrace kselftests, which
are now failing. It would also be nice to have it for clarity reasons.

"ftrace_caller" itself is called without stack frame allocated for it
and does not store its caller (ftraced function). Instead it simply
allocates a stack frame for "ftrace_trace_function" and sets backchain
to point to ftraced function stack frame (which contains ftraced function
caller in saved r14).

To fix this issue make "ftrace_caller" allocate a stack frame
for itself just to store ftraced function for the stack unwinder.
As a result backtrace looks like the following:

arch_stack_walk+0x15c/0x2d8
stack_trace_save+0x50/0x68
stack_trace_call+0x15e/0x3d8
ftrace_graph_caller+0x0/0x1c <-- ftrace code
path_openat+0x6/0xd60  <-- ftraced function
do_filp_open+0x7c/0xe8 <-- ftraced function caller
do_open_execat+0x76/0x1b8
open_exec+0x52/0x78
load_elf_binary+0x180/0x1160
search_binary_handler+0x8e/0x288
load_script+0x2a8/0x2b8
search_binary_handler+0x8e/0x288
__do_execve_file.isra.39+0x6fa/0xb40
__s390x_sys_execve+0x56/0x68
system_call+0xdc/0x2d8

Reported-by: Sven Schnelle <sven.schnelle@ibm.com>
Tested-by: Sven Schnelle <sven.schnelle@ibm.com>
Reviewed-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/mcount.S | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/arch/s390/kernel/mcount.S b/arch/s390/kernel/mcount.S
index c3597d2e2ae0e..f942341429b1c 100644
--- a/arch/s390/kernel/mcount.S
+++ b/arch/s390/kernel/mcount.S
@@ -26,6 +26,12 @@ ENDPROC(ftrace_stub)
 #define STACK_PTREGS	  (STACK_FRAME_OVERHEAD)
 #define STACK_PTREGS_GPRS (STACK_PTREGS + __PT_GPRS)
 #define STACK_PTREGS_PSW  (STACK_PTREGS + __PT_PSW)
+#ifdef __PACK_STACK
+/* allocate just enough for r14, r15 and backchain */
+#define TRACED_FUNC_FRAME_SIZE	24
+#else
+#define TRACED_FUNC_FRAME_SIZE	STACK_FRAME_OVERHEAD
+#endif
 
 ENTRY(_mcount)
 	BR_EX	%r14
@@ -40,9 +46,16 @@ ENTRY(ftrace_caller)
 #if !(defined(CC_USING_HOTPATCH) || defined(CC_USING_NOP_MCOUNT))
 	aghi	%r0,MCOUNT_RETURN_FIXUP
 #endif
-	aghi	%r15,-STACK_FRAME_SIZE
+	# allocate stack frame for ftrace_caller to contain traced function
+	aghi	%r15,-TRACED_FUNC_FRAME_SIZE
 	stg	%r1,__SF_BACKCHAIN(%r15)
+	stg	%r0,(__SF_GPRS+8*8)(%r15)
+	stg	%r15,(__SF_GPRS+9*8)(%r15)
+	# allocate pt_regs and stack frame for ftrace_trace_function
+	aghi	%r15,-STACK_FRAME_SIZE
 	stg	%r1,(STACK_PTREGS_GPRS+15*8)(%r15)
+	aghi	%r1,-TRACED_FUNC_FRAME_SIZE
+	stg	%r1,__SF_BACKCHAIN(%r15)
 	stg	%r0,(STACK_PTREGS_PSW+8)(%r15)
 	stmg	%r2,%r14,(STACK_PTREGS_GPRS+2*8)(%r15)
 #ifdef CONFIG_HAVE_MARCH_Z196_FEATURES
-- 
2.20.1

