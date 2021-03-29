Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 897EF34C77B
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:16:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232026AbhC2IPm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:15:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:58584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232829AbhC2IO3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:14:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF42F61959;
        Mon, 29 Mar 2021 08:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617005662;
        bh=IbK9jyQI8KiJR0IZteICTrmpT+15gQ4hoLVWkZBduP4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aO+ymY9dZTQdgI420Vzp6+AUDuqB2amoHlcBTQY+SJ5fce9QufA9PkLNzczLtPLoz
         Y0+U9e/R3eaqb5OPd+LVDOETsstUCnUx925+xet5vMtMUuPkrwdXzAPZkWAQyuGTI6
         cYW+BUW+QTfiYMmdd5CDKQ0ibl6w7NssQen+qu+0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergei Trofimovich <slyfox@gentoo.org>,
        "Dmitry V. Levin" <ldv@altlinux.org>,
        John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 038/111] ia64: fix ptrace(PTRACE_SYSCALL_INFO_EXIT) sign
Date:   Mon, 29 Mar 2021 09:57:46 +0200
Message-Id: <20210329075616.441743332@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075615.186199980@linuxfoundation.org>
References: <20210329075615.186199980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 6c6f16e409a8..0d23c0049301 100644
--- a/arch/ia64/include/asm/syscall.h
+++ b/arch/ia64/include/asm/syscall.h
@@ -32,7 +32,7 @@ static inline void syscall_rollback(struct task_struct *task,
 static inline long syscall_get_error(struct task_struct *task,
 				     struct pt_regs *regs)
 {
-	return regs->r10 == -1 ? regs->r8:0;
+	return regs->r10 == -1 ? -regs->r8:0;
 }
 
 static inline long syscall_get_return_value(struct task_struct *task,
-- 
2.30.1



