Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D1592C085B
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:16:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732560AbgKWMtP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:49:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:33622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732853AbgKWMsp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:48:45 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A1440204EF;
        Mon, 23 Nov 2020 12:48:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135725;
        bh=1gHeG2YoVi44cfOM9wpOXmrgGLwBZx5fgGj0/eZWEmg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dAlJfE5FzHNEztwlBN+iL48VIGSo7KQX7/m6UU7Z0TJeR4oFdrvxfB+yg1RoB2tqL
         pPBmnKIOEJXYyZz/Rn+3S0ULled7NKfGywHUcBuvnxbzkvJ971MD/+t7QanN73q2dC
         6I+4whrndNJ/0ijNPEjGieVoKg38S97KrXUPs5ko=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        Kees Cook <keescook@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 172/252] selftests/seccomp: sh: Fix register names
Date:   Mon, 23 Nov 2020 13:22:02 +0100
Message-Id: <20201123121843.891912494@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

[ Upstream commit 4c222f31fb1db4d590503a181a6268ced9252379 ]

It looks like the seccomp selftests was never actually built for sh.
This fixes it, though I don't have an environment to do a runtime test
of it yet.

Fixes: 0bb605c2c7f2b4b3 ("sh: Add SECCOMP_FILTER")
Tested-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Link: https://lore.kernel.org/lkml/a36d7b48-6598-1642-e403-0c77a86f416d@physik.fu-berlin.de
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/seccomp/seccomp_bpf.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/seccomp/seccomp_bpf.c b/tools/testing/selftests/seccomp/seccomp_bpf.c
index 6a27b12e9b3c2..687ca8afe0e83 100644
--- a/tools/testing/selftests/seccomp/seccomp_bpf.c
+++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
@@ -1738,8 +1738,8 @@ TEST_F(TRACE_poke, getpid_runs_normally)
 #define SYSCALL_RET(_regs)	(_regs).a[(_regs).windowbase * 4 + 2]
 #elif defined(__sh__)
 # define ARCH_REGS		struct pt_regs
-# define SYSCALL_NUM(_regs)	(_regs).gpr[3]
-# define SYSCALL_RET(_regs)	(_regs).gpr[0]
+# define SYSCALL_NUM(_regs)	(_regs).regs[3]
+# define SYSCALL_RET(_regs)	(_regs).regs[0]
 #else
 # error "Do not know how to find your architecture's registers and syscalls"
 #endif
-- 
2.27.0



