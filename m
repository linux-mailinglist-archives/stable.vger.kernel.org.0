Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EB2133E3B4
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 01:58:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231609AbhCQA5V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 20:57:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:34666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231302AbhCQA4x (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Mar 2021 20:56:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E387364FA7;
        Wed, 17 Mar 2021 00:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942612;
        bh=IbK9jyQI8KiJR0IZteICTrmpT+15gQ4hoLVWkZBduP4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j6xfjN5N8kFVctwc6JAaETNCJ0svLUCq224GQXd9vCJSWZ9Cv05WMOOpDFIcpEvTt
         RaVvf/tx7idu5DM7A7AekbB/E3cFyKvYcHj2fCNkptHw3B/cnMgXQrH7aQG+wNP/dJ
         PtLXliqfhlD1ZRsBPTOnvstOJW08Qfwmvpd3IkU1YUAuoIxwNf38zngayF8fPMnqpA
         8rKwDdD9ULLHrWy9AiBDjMI2SakAyPvjsVVrIE9PdR6/TA5AJAKaJT7RgjZ9GvwfjK
         CCv0aOtRzNhxqhTpTUOILIEeZYf/PMESj7/wuZTOkJAijN04iDL/PriCAlt3vvSr0P
         ZYQTYMgoW9ebA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sergei Trofimovich <slyfox@gentoo.org>,
        "Dmitry V . Levin" <ldv@altlinux.org>,
        John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-ia64@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 61/61] ia64: fix ptrace(PTRACE_SYSCALL_INFO_EXIT) sign
Date:   Tue, 16 Mar 2021 20:55:35 -0400
Message-Id: <20210317005536.724046-61-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317005536.724046-1-sashal@kernel.org>
References: <20210317005536.724046-1-sashal@kernel.org>
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

