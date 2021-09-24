Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 375F44173E1
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 15:02:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345330AbhIXNA0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 09:00:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:54096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345698AbhIXM6y (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 08:58:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3C7646124C;
        Fri, 24 Sep 2021 12:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632487979;
        bh=lzQihB27GxCMmzSAKau/cLCVpEvz9dNOCgK+RXPuZSg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nPWzLyxYxZALjRQW658GTYR1itWt9jPjwTT48dhE3oj3z4dW7FeZ0hALiE51jLTyn
         bIiuD9nq9ijRxGDtdL+xRVDdmszkOX3S4yxmEa4Z/yLGbORbl81fHsR6Jz13MFt/hM
         unSbWbnMLGZI13B7p6qVBsYtFrU+hqEnOHaUUTuk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, subashab@codeaurora.org,
        Johannes Berg <johannes.berg@intel.com>,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 5.14 005/100] um: fix stub location calculation
Date:   Fri, 24 Sep 2021 14:43:14 +0200
Message-Id: <20210924124341.651413025@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124341.214446495@linuxfoundation.org>
References: <20210924124341.214446495@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

commit adf9ae0d159d3dc94f58d788fc4757c8749ac0df upstream.

In commit 9f0b4807a44f ("um: rework userspace stubs to not hard-code
stub location") I changed stub_segv_handler() to do a calculation with
a pointer to a stack variable to find the data page that we're using
for the stack and the rest of the data. This same commit was meant to
do it as well for stub_clone_handler(), but the change inadvertently
went into commit 84b2789d6115 ("um: separate child and parent errors
in clone stub") instead.

This was reported to not be compiled correctly by gcc 5, causing the
code to crash here. I'm not sure why, perhaps it's UB because the var
isn't initialized? In any case, this trick always seemed bad, so just
create a new inline function that does the calculation in assembly.

Reported-by: subashab@codeaurora.org
Fixes: 9f0b4807a44f ("um: rework userspace stubs to not hard-code stub location")
Fixes: 84b2789d6115 ("um: separate child and parent errors in clone stub")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/um/kernel/skas/clone.c         |    3 +--
 arch/x86/um/shared/sysdep/stub_32.h |   12 ++++++++++++
 arch/x86/um/shared/sysdep/stub_64.h |   12 ++++++++++++
 arch/x86/um/stub_segv.c             |    3 +--
 4 files changed, 26 insertions(+), 4 deletions(-)

--- a/arch/um/kernel/skas/clone.c
+++ b/arch/um/kernel/skas/clone.c
@@ -24,8 +24,7 @@
 void __attribute__ ((__section__ (".__syscall_stub")))
 stub_clone_handler(void)
 {
-	int stack;
-	struct stub_data *data = (void *) ((unsigned long)&stack & ~(UM_KERN_PAGE_SIZE - 1));
+	struct stub_data *data = get_stub_page();
 	long err;
 
 	err = stub_syscall2(__NR_clone, CLONE_PARENT | CLONE_FILES | SIGCHLD,
--- a/arch/x86/um/shared/sysdep/stub_32.h
+++ b/arch/x86/um/shared/sysdep/stub_32.h
@@ -101,4 +101,16 @@ static inline void remap_stack_and_trap(
 		"memory");
 }
 
+static __always_inline void *get_stub_page(void)
+{
+	unsigned long ret;
+
+	asm volatile (
+		"movl %%esp,%0 ;"
+		"andl %1,%0"
+		: "=a" (ret)
+		: "g" (~(UM_KERN_PAGE_SIZE - 1)));
+
+	return (void *)ret;
+}
 #endif
--- a/arch/x86/um/shared/sysdep/stub_64.h
+++ b/arch/x86/um/shared/sysdep/stub_64.h
@@ -108,4 +108,16 @@ static inline void remap_stack_and_trap(
 		__syscall_clobber, "r10", "r8", "r9");
 }
 
+static __always_inline void *get_stub_page(void)
+{
+	unsigned long ret;
+
+	asm volatile (
+		"movq %%rsp,%0 ;"
+		"andq %1,%0"
+		: "=a" (ret)
+		: "g" (~(UM_KERN_PAGE_SIZE - 1)));
+
+	return (void *)ret;
+}
 #endif
--- a/arch/x86/um/stub_segv.c
+++ b/arch/x86/um/stub_segv.c
@@ -11,9 +11,8 @@
 void __attribute__ ((__section__ (".__syscall_stub")))
 stub_segv_handler(int sig, siginfo_t *info, void *p)
 {
-	int stack;
+	struct faultinfo *f = get_stub_page();
 	ucontext_t *uc = p;
-	struct faultinfo *f = (void *)(((unsigned long)&stack) & ~(UM_KERN_PAGE_SIZE - 1));
 
 	GET_FAULTINFO_FROM_MC(*f, &uc->uc_mcontext);
 	trap_myself();


