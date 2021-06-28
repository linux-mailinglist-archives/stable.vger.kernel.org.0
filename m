Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8E8B3B5FEB
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:19:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232777AbhF1OVZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:21:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:54392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232697AbhF1OVJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:21:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4635261C7E;
        Mon, 28 Jun 2021 14:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624889923;
        bh=crOGXuKXwaRQFu0XN370L0X2uBTEypSclEuky3oQ+kc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j44m3aderhLxy7ia7w6jpsEOUrAQwTXAONHU1rvXWFZ4Ctvt66GJmF7IVdPGmBwv7
         TnkZm3sOZp8wLhhGrrNT5ArMf995fgr/PK3S9BeemjDZLwJPnrkk7aumDkZhwN8d1Y
         SNqaTSEzqLbVVDkgJg3H2FOvgEs/ZZ9iW8JOZSNvKs/psKouyyW73Oie1UKs7qVbBA
         Z5n0oObQTvtt/9ZMR8UPelW815vz9cNfeBWfMCyd0ALuRGjIpxo+1cgcnAZ8AuHOTY
         tDUYq/sYdK+CRjPz8Edw3pEIRCGvOWAMuESv+W/Q2/8mpp3rP+K/C0FJ8GfYUZAXXR
         ciyzFYU4dp+SQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 015/110] x86/entry: Fix noinstr fail in __do_fast_syscall_32()
Date:   Mon, 28 Jun 2021 10:16:53 -0400
Message-Id: <20210628141828.31757-16-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628141828.31757-1-sashal@kernel.org>
References: <20210628141828.31757-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.14-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.12.14-rc1
X-KernelTest-Deadline: 2021-06-30T14:18+00:00
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
index 4efd39aacb9f..cbe19c87e6be 100644
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

