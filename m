Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9EF0450B86
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:22:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236874AbhKORZ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:25:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:50840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237778AbhKORYD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:24:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C7E6960F22;
        Mon, 15 Nov 2021 17:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636996632;
        bh=THe/nioCgVCQvo/WlreBJb3rdIBvO7XNaQf2Ui04Ou8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z+9QGMMhqmBHbM43SG9DBj/yDp6EoD8yCAvvp0G7qEmxva3y2A4/VlszWVo0U5/gI
         GhZy661ASFjgPfP40F65KsAcsfX/r7qjr0zq7ANGpAp2FMlpzqDg7mUMIuDYvYDxGa
         0VX3hcbbc2jHPdKwZNv78EKrIlWrvM96QSIapY8k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Helge Deller <deller@gmx.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 177/355] task_stack: Fix end_of_stack() for architectures with upwards-growing stack
Date:   Mon, 15 Nov 2021 18:01:41 +0100
Message-Id: <20211115165319.511324574@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165313.549179499@linuxfoundation.org>
References: <20211115165313.549179499@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 2413427e439c7..d10150587d819 100644
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



