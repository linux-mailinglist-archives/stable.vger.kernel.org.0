Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 506AF44A2DA
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 02:23:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241965AbhKIBWX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 20:22:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:46548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241599AbhKIBTy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 20:19:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E7C461A07;
        Tue,  9 Nov 2021 01:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636420084;
        bh=uAh8D7HSVUN4rFXA/roKaYfVLyeStFPOWFynj1PVR+4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CZPzFGGvG0nKFTqsT0vEwZGk3mDw3Y3NZ5QVI0UbERMvdQzrjnDzkeRRyVbsz6C8r
         VRriyvkbaFGPwXoCUVQuNCpiYeYC2zRwqSMILHrXQhoC9kYnPUzCk8DyCGTXiccU2S
         QRTPFx0N6HGVd8VnOpP+jpCtp04Kn5JomP70eE0QkWs24TK75Vq5k11tTm1rG/0asA
         bLu4F9yyh4CpZXzzNlJLcuoEbDJM2DK4224IHgXYpjtMVgwWY9XLr7jTU5pFoHQUS3
         OVrDrDCvdPN8gEJwlLDouHoZWZe/jUEm0287ZDZbq+tATSm4suLEUXta5vXKEbhpaL
         ZbTBGf7bKjS4Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 38/39] task_stack: Fix end_of_stack() for architectures with upwards-growing stack
Date:   Mon,  8 Nov 2021 20:06:48 -0500
Message-Id: <20211109010649.1191041-38-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109010649.1191041-1-sashal@kernel.org>
References: <20211109010649.1191041-1-sashal@kernel.org>
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
index cb4828aaa34fd..3461beb89b040 100644
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

