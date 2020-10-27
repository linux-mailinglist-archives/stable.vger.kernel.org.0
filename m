Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 264E529B7DC
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:08:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S368726AbgJ0P1L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:27:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:39982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1797626AbgJ0PYk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:24:40 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 46A1D2064B;
        Tue, 27 Oct 2020 15:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812279;
        bh=YWjS08R2CUFRCQE6ZV5tRBo22c6qCWO6JTAwR8jqYjY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hn/VWwZPuRz+VNFTMJnGxWE+w+sJcoDXhC2jPXGmNiljGzkHSU/PBU0Euozvy/tt0
         ILnMKcNtindZHoz2b44cNlmGP/veY+B6FOh1at+apeVHMzrpZ99x95zMJImj+69taC
         xVNTkxvMyYnHBoJ7hFo6DYaxXRXonmLr22exq2M0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Kees Cook <keescook@chromium.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 154/757] selftests/seccomp: powerpc: Fix seccomp return value testing
Date:   Tue, 27 Oct 2020 14:46:44 +0100
Message-Id: <20201027135457.827743026@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

[ Upstream commit 46138329faeac3598f5a4dc991a174386b6de833 ]

On powerpc, the errno is not inverted, and depends on ccr.so being
set. Add this to a powerpc definition of SYSCALL_RET_SET().

Co-developed-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Link: https://lore.kernel.org/linux-kselftest/20200911181012.171027-1-cascardo@canonical.com/
Fixes: 5d83c2b37d43 ("selftests/seccomp: Add powerpc support")
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/lkml/20200912110820.597135-13-keescook@chromium.org
Reviewed-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/seccomp/seccomp_bpf.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/tools/testing/selftests/seccomp/seccomp_bpf.c b/tools/testing/selftests/seccomp/seccomp_bpf.c
index e2f38507a0621..9a9eb02539fb4 100644
--- a/tools/testing/selftests/seccomp/seccomp_bpf.c
+++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
@@ -1702,6 +1702,21 @@ TEST_F(TRACE_poke, getpid_runs_normally)
 # define ARCH_REGS		struct pt_regs
 # define SYSCALL_NUM(_regs)	(_regs).gpr[0]
 # define SYSCALL_RET(_regs)	(_regs).gpr[3]
+# define SYSCALL_RET_SET(_regs, _val)				\
+	do {							\
+		typeof(_val) _result = (_val);			\
+		/*						\
+		 * A syscall error is signaled by CR0 SO bit	\
+		 * and the code is stored as a positive value.	\
+		 */						\
+		if (_result < 0) {				\
+			SYSCALL_RET(_regs) = -result;		\
+			(_regs).ccr |= 0x10000000;		\
+		} else {					\
+			SYSCALL_RET(_regs) = result;		\
+			(_regs).ccr &= ~0x10000000;		\
+		}						\
+	} while (0)
 #elif defined(__s390__)
 # define ARCH_REGS		s390_regs
 # define SYSCALL_NUM(_regs)	(_regs).gprs[2]
-- 
2.25.1



