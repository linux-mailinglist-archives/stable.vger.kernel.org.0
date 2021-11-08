Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7952444A295
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 02:17:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243234AbhKIBTf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 20:19:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:40980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243382AbhKIBPr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 20:15:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 12DFF61AE4;
        Tue,  9 Nov 2021 01:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636420003;
        bh=/o8rmn2R0cPjyvnhh+SXEnJPg9vRIPkvzndQ8Xv5ydg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=reAmBW2Uj31INC9g7rNs6gWwZXKCklvoewvPtGjD43Fi66WjOCoCUbnjDCIiOv0mr
         hBpHxjy1XSm1+ZmKsaB3aq4fkZzd9dq6hhLUVspfczMCdt29F/ziUj5QnsswKr2reX
         pFR8uYUK7NcVXsEysRrFk/9E4u9vcHLVKKJKgQcqiZ5GuenJDsjEPYfSGYWQ3g6swM
         kwA2x9iNJ2OIlTyQFWApWmzl0hd2yjfWD5ZECaHKnVYb62AGfDd4mvjN6XlRoPlsuC
         neRcp04Ym2ppt/ECv0qYfoG6ycTMTSSh/HY/X+DVqd+kHF2e7n50zauh7M+IPAQE0N
         ryg/4gGI/Hrvw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 45/47] task_stack: Fix end_of_stack() for architectures with upwards-growing stack
Date:   Mon,  8 Nov 2021 12:50:29 -0500
Message-Id: <20211108175031.1190422-45-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211108175031.1190422-1-sashal@kernel.org>
References: <20211108175031.1190422-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Helge Deller <deller@gmx.de>

[ Upstream commit 9cc2fa4f4a92ccc6760d764e7341be46ee8aaaa1 ]

The function end_of_stack() returns a pointer to the last entry of a
stack. For architectures like parisc where the stack grows upwards
return the pointer to the highest address in the stack.

Without this change I faced a crash on parisc, because the stackleak
functionality wrote STACKLEAK_POISON to the lowest address and thus
overwrote the first 4 bytes of the task_struct which included the
TIF_FLAGS.

Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sched/task_stack.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/sched/task_stack.h b/include/linux/sched/task_stack.h
index 6a841929073f9..4f099d3fed3a9 100644
--- a/include/linux/sched/task_stack.h
+++ b/include/linux/sched/task_stack.h
@@ -25,7 +25,11 @@ static inline void *task_stack_page(const struct task_struct *task)
 
 static inline unsigned long *end_of_stack(const struct task_struct *task)
 {
+#ifdef CONFIG_STACK_GROWSUP
+	return (unsigned long *)((unsigned long)task->stack + THREAD_SIZE) - 1;
+#else
 	return task->stack;
+#endif
 }
 
 #elif !defined(__HAVE_THREAD_FUNCTIONS)
-- 
2.33.0

