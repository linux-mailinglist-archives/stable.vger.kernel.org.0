Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFB0438EED8
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:54:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234267AbhEXPz1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:55:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:39394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235274AbhEXPzE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:55:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E6BE161926;
        Mon, 24 May 2021 15:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621870851;
        bh=zikGe0gfOoKmYyTHHPQ1mc8TL64JMBEfZkConVgDtTg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WhhM3qTzf1+7k9bsNrhYajEKV4x1M2TjBmrW3BJXuS/jHIVODcthaaBq3ZYZgGson
         4jzbnr9AEAVev01VQ9D+QXwaDoDZQ/vNOqPTrmYFFeyWCNwpkYTdDz/lNQ96sKRrtV
         m3j75jD85Wnr/nYPQzQNkpdaObUusDvD+Mx4nixA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Dmitry V. Levin" <ldv@altlinux.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.10 064/104] powerpc/64s/syscall: Use pt_regs.trap to distinguish syscall ABI difference between sc and scv syscalls
Date:   Mon, 24 May 2021 17:25:59 +0200
Message-Id: <20210524152334.971284393@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152332.844251980@linuxfoundation.org>
References: <20210524152332.844251980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Piggin <npiggin@gmail.com>

commit 5665bc35c1ed917ac8fd06cb651317bb47a65b10 upstream.

The sc and scv 0 system calls have different ABI conventions, and
ptracers need to know which system call type is being used if they want
to look at the syscall registers.

Document that pt_regs.trap can be used for this, and fix one in-tree user
to work with scv 0 syscalls.

Fixes: 7fa95f9adaee ("powerpc/64s: system call support for scv/rfscv instructions")
Cc: stable@vger.kernel.org # v5.9+
Reported-by: "Dmitry V. Levin" <ldv@altlinux.org>
Suggested-by: "Dmitry V. Levin" <ldv@altlinux.org>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210520111931.2597127-1-npiggin@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/powerpc/syscall64-abi.rst       |   10 +++++++++
 tools/testing/selftests/seccomp/seccomp_bpf.c |   27 +++++++++++++++++---------
 2 files changed, 28 insertions(+), 9 deletions(-)

--- a/Documentation/powerpc/syscall64-abi.rst
+++ b/Documentation/powerpc/syscall64-abi.rst
@@ -96,6 +96,16 @@ auxiliary vector.
 
 scv 0 syscalls will always behave as PPC_FEATURE2_HTM_NOSC.
 
+ptrace
+------
+When ptracing system calls (PTRACE_SYSCALL), the pt_regs.trap value contains
+the system call type that can be used to distinguish between sc and scv 0
+system calls, and the different register conventions can be accounted for.
+
+If the value of (pt_regs.trap & 0xfff0) is 0xc00 then the system call was
+performed with the sc instruction, if it is 0x3000 then the system call was
+performed with the scv 0 instruction.
+
 vsyscall
 ========
 
--- a/tools/testing/selftests/seccomp/seccomp_bpf.c
+++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
@@ -1753,16 +1753,25 @@ TEST_F(TRACE_poke, getpid_runs_normally)
 # define SYSCALL_RET_SET(_regs, _val)				\
 	do {							\
 		typeof(_val) _result = (_val);			\
-		/*						\
-		 * A syscall error is signaled by CR0 SO bit	\
-		 * and the code is stored as a positive value.	\
-		 */						\
-		if (_result < 0) {				\
-			SYSCALL_RET(_regs) = -_result;		\
-			(_regs).ccr |= 0x10000000;		\
-		} else {					\
+		if ((_regs.trap & 0xfff0) == 0x3000) {		\
+			/*					\
+			 * scv 0 system call uses -ve result	\
+			 * for error, so no need to adjust.	\
+			 */					\
 			SYSCALL_RET(_regs) = _result;		\
-			(_regs).ccr &= ~0x10000000;		\
+		} else {					\
+			/*					\
+			 * A syscall error is signaled by the	\
+			 * CR0 SO bit and the code is stored as	\
+			 * a positive value.			\
+			 */					\
+			if (_result < 0) {			\
+				SYSCALL_RET(_regs) = -_result;	\
+				(_regs).ccr |= 0x10000000;	\
+			} else {				\
+				SYSCALL_RET(_regs) = _result;	\
+				(_regs).ccr &= ~0x10000000;	\
+			}					\
 		}						\
 	} while (0)
 # define SYSCALL_RET_SET_ON_PTRACE_EXIT


