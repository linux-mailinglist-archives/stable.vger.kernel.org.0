Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE9B9D2583
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 11:02:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387871AbfJJImb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:42:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:47052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388553AbfJJIm2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:42:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0AB0021A4C;
        Thu, 10 Oct 2019 08:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570696947;
        bh=KeGk7ekKKZHY2R8nLwGcjBusx9sdG8nRc9xvnHtfSGM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cWJUcn6P+X/f7KNGk6XnEWSD/k2/Ag/5pyLumXm0NSC4j9+q6RdtzM20YBAJhLouE
         SBg1uNtl2asCRMczi+B+y8OYL52FI7UydhWuL5xVEz8poEaMltBSn+MIUSxabONezJ
         oBHI9as7ctzwDWOJiBlthE4YckSFpwTrd5PT7I3k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tycho Andersen <tycho@tycho.ws>,
        Kees Cook <keescook@chromium.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 110/148] selftests/seccomp: fix build on older kernels
Date:   Thu, 10 Oct 2019 10:36:11 +0200
Message-Id: <20191010083617.811699368@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083609.660878383@linuxfoundation.org>
References: <20191010083609.660878383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tycho Andersen <tycho@tycho.ws>

[ Upstream commit 88282297fff00796e81f5e67734a6afdfb31fbc4 ]

The seccomp selftest goes to some length to build against older kernel
headers, viz. all the #ifdefs at the beginning of the file.

Commit 201766a20e30 ("ptrace: add PTRACE_GET_SYSCALL_INFO request")
introduces some additional macros, but doesn't do the #ifdef dance.
Let's add that dance here to avoid:

gcc -Wl,-no-as-needed -Wall  seccomp_bpf.c -lpthread -o seccomp_bpf
In file included from seccomp_bpf.c:51:
seccomp_bpf.c: In function ‘tracer_ptrace’:
seccomp_bpf.c:1787:20: error: ‘PTRACE_EVENTMSG_SYSCALL_ENTRY’ undeclared (first use in this function); did you mean ‘PTRACE_EVENT_CLONE’?
  EXPECT_EQ(entry ? PTRACE_EVENTMSG_SYSCALL_ENTRY
                    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
../kselftest_harness.h:608:13: note: in definition of macro ‘__EXPECT’
  __typeof__(_expected) __exp = (_expected); \
             ^~~~~~~~~
seccomp_bpf.c:1787:2: note: in expansion of macro ‘EXPECT_EQ’
  EXPECT_EQ(entry ? PTRACE_EVENTMSG_SYSCALL_ENTRY
  ^~~~~~~~~
seccomp_bpf.c:1787:20: note: each undeclared identifier is reported only once for each function it appears in
  EXPECT_EQ(entry ? PTRACE_EVENTMSG_SYSCALL_ENTRY
                    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
../kselftest_harness.h:608:13: note: in definition of macro ‘__EXPECT’
  __typeof__(_expected) __exp = (_expected); \
             ^~~~~~~~~
seccomp_bpf.c:1787:2: note: in expansion of macro ‘EXPECT_EQ’
  EXPECT_EQ(entry ? PTRACE_EVENTMSG_SYSCALL_ENTRY
  ^~~~~~~~~
seccomp_bpf.c:1788:6: error: ‘PTRACE_EVENTMSG_SYSCALL_EXIT’ undeclared (first use in this function); did you mean ‘PTRACE_EVENT_EXIT’?
    : PTRACE_EVENTMSG_SYSCALL_EXIT, msg);
      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
../kselftest_harness.h:608:13: note: in definition of macro ‘__EXPECT’
  __typeof__(_expected) __exp = (_expected); \
             ^~~~~~~~~
seccomp_bpf.c:1787:2: note: in expansion of macro ‘EXPECT_EQ’
  EXPECT_EQ(entry ? PTRACE_EVENTMSG_SYSCALL_ENTRY
  ^~~~~~~~~
make: *** [Makefile:12: seccomp_bpf] Error 1

[skhan@linuxfoundation.org: Fix checkpatch error in commit log]
Signed-off-by: Tycho Andersen <tycho@tycho.ws>
Fixes: 201766a20e30 ("ptrace: add PTRACE_GET_SYSCALL_INFO request")
Acked-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/seccomp/seccomp_bpf.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/testing/selftests/seccomp/seccomp_bpf.c b/tools/testing/selftests/seccomp/seccomp_bpf.c
index 6ef7f16c4cf52..7f8b5c8982e3b 100644
--- a/tools/testing/selftests/seccomp/seccomp_bpf.c
+++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
@@ -199,6 +199,11 @@ struct seccomp_notif_sizes {
 };
 #endif
 
+#ifndef PTRACE_EVENTMSG_SYSCALL_ENTRY
+#define PTRACE_EVENTMSG_SYSCALL_ENTRY	1
+#define PTRACE_EVENTMSG_SYSCALL_EXIT	2
+#endif
+
 #ifndef seccomp
 int seccomp(unsigned int op, unsigned int flags, void *args)
 {
-- 
2.20.1



