Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51D333B60E0
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:28:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233924AbhF1ObD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:31:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:37130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234513AbhF1OaB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:30:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C0AB61C9E;
        Mon, 28 Jun 2021 14:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890384;
        bh=5Qg8XVRB2iQSCQoRe92a2f889VP0cHb+Y32Qa1RyZ8Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZVSgX8v5m0AP5uajTzxdnuuawbo30DGligVGWYqjW7yqcEwObeuhPvtVuszpetWgv
         ih19ATM/4M56KNMywTqfpI5Pwe9q8dGCkN5pn2sfrp8FqBEVU6Tnk1wJIIBi7V0J1Y
         YDgDJrekCi8eW6Cnwb6GKpYl1d1r7Plxb4NRaHOQJx2eSIr5FcptVrsZsS2alI0Ryq
         A3FUf0xVOo9tfyVgroB5PiSBW/pj40kQOtyoQ+v3NV3ev0lZ28PaY99m1Y5ONV+Xbn
         p4gKg906lfFVowVq1YUScTeC5f9a7CmqBzFxxEMQ6qz4xljjBUDlweRrppYSx5ChYG
         Hp0UY4tJp8X7g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 017/101] x86/entry: Fix noinstr fail in __do_fast_syscall_32()
Date:   Mon, 28 Jun 2021 10:24:43 -0400
Message-Id: <20210628142607.32218-18-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628142607.32218-1-sashal@kernel.org>
References: <20210628142607.32218-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.47-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.47-rc1
X-KernelTest-Deadline: 2021-06-30T14:25+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 240001d4e3041832e8a2654adc3ccf1683132b92 ]

Fix:

  vmlinux.o: warning: objtool: __do_fast_syscall_32()+0xf5: call to trace_hardirqs_off() leaves .noinstr.text section

Fixes: 5d5675df792f ("x86/entry: Fix entry/exit mismatch on failed fast 32-bit syscalls")
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/20210621120120.467898710@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/entry/common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/entry/common.c b/arch/x86/entry/common.c
index 2e4d91f3feea..93a3122cd15f 100644
--- a/arch/x86/entry/common.c
+++ b/arch/x86/entry/common.c
@@ -127,8 +127,8 @@ static noinstr bool __do_fast_syscall_32(struct pt_regs *regs)
 		/* User code screwed up. */
 		regs->ax = -EFAULT;
 
-		instrumentation_end();
 		local_irq_disable();
+		instrumentation_end();
 		irqentry_exit_to_user_mode(regs);
 		return false;
 	}
-- 
2.30.2

