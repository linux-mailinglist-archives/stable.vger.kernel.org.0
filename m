Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FF0E33E544
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 02:03:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231963AbhCQBCo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 21:02:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:41900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232097AbhCQBAJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Mar 2021 21:00:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 279A764FB6;
        Wed, 17 Mar 2021 01:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942808;
        bh=6doY695fcNFJgCQPeD37/bzJKzw8f4iXkCzcMtRpyCU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ftpOQBjK+dbfDqNGB7npsF5kdBDS8G+5YEGy4A5pZCy9nkYmtwWk0PkrJM2uaMzB6
         NPfiYcBg9kIo1RBzFf6ya/GZ6ev/Kj0Sse37aEqRx05MFl2tH0whaBrDEeqfCQ9tnT
         aR4O4stVHYDQRZEDfL4B9BNi42ZO0iLF8Uw7PTD3qH2Ta39fEBe0qhaj5vzEdonoCT
         JU1WYcXu9/+pUHGb/dDA3UGq+TnCq2jq4xGzm99wxAe650JeUG+s/JxmgzZTWdYyq8
         /IRj/0tVg0HT7U3PPqlX4UdsQCXhWULjOuh0CQZc2TLBrOuYet6GACsYd2IZW8V6cn
         a0POPAhHHjITw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sergei Trofimovich <slyfox@gentoo.org>,
        "Dmitry V . Levin" <ldv@altlinux.org>,
        John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-ia64@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 16/16] ia64: fix ptrace(PTRACE_SYSCALL_INFO_EXIT) sign
Date:   Tue, 16 Mar 2021 20:59:47 -0400
Message-Id: <20210317005948.727250-16-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317005948.727250-1-sashal@kernel.org>
References: <20210317005948.727250-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergei Trofimovich <slyfox@gentoo.org>

[ Upstream commit 61bf318eac2c13356f7bd1c6a05421ef504ccc8a ]

In https://bugs.gentoo.org/769614 Dmitry noticed that
`ptrace(PTRACE_GET_SYSCALL_INFO)` does not return error sign properly.

The bug is in mismatch between get/set errors:

static inline long syscall_get_error(struct task_struct *task,
                                     struct pt_regs *regs)
{
        return regs->r10 == -1 ? regs->r8:0;
}

static inline long syscall_get_return_value(struct task_struct *task,
                                            struct pt_regs *regs)
{
        return regs->r8;
}

static inline void syscall_set_return_value(struct task_struct *task,
                                            struct pt_regs *regs,
                                            int error, long val)
{
        if (error) {
                /* error < 0, but ia64 uses > 0 return value */
                regs->r8 = -error;
                regs->r10 = -1;
        } else {
                regs->r8 = val;
                regs->r10 = 0;
        }
}

Tested on v5.10 on rx3600 machine (ia64 9040 CPU).

Link: https://lkml.kernel.org/r/20210221002554.333076-2-slyfox@gentoo.org
Link: https://bugs.gentoo.org/769614
Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
Reported-by: Dmitry V. Levin <ldv@altlinux.org>
Reviewed-by: Dmitry V. Levin <ldv@altlinux.org>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/ia64/include/asm/syscall.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/ia64/include/asm/syscall.h b/arch/ia64/include/asm/syscall.h
index 1d0b875fec44..ec909eec0b4c 100644
--- a/arch/ia64/include/asm/syscall.h
+++ b/arch/ia64/include/asm/syscall.h
@@ -35,7 +35,7 @@ static inline void syscall_rollback(struct task_struct *task,
 static inline long syscall_get_error(struct task_struct *task,
 				     struct pt_regs *regs)
 {
-	return regs->r10 == -1 ? regs->r8:0;
+	return regs->r10 == -1 ? -regs->r8:0;
 }
 
 static inline long syscall_get_return_value(struct task_struct *task,
-- 
2.30.1

