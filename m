Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 797934520D0
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:54:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349868AbhKPA4j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:56:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:44602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343595AbhKOTVX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:21:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6AA6A635CD;
        Mon, 15 Nov 2021 18:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001771;
        bh=THe/nioCgVCQvo/WlreBJb3rdIBvO7XNaQf2Ui04Ou8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D1b/Y/Y9Aq0Rw2Ix0W2SRtXZUqC1zs0jw1R8C6y4CH2voG6IxqORCi20/jOD5k5zy
         wg2MWujgOlykLjNHzFro2pZ3s7Mv6dalroCzrz9DZXOxFpVbo8Lriu8RfkanU3dmHs
         /sUR6zj14qV0mBsOVsgK4I1ZSA8DpQOfSVKVWuyE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Helge Deller <deller@gmx.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 315/917] task_stack: Fix end_of_stack() for architectures with upwards-growing stack
Date:   Mon, 15 Nov 2021 17:56:50 +0100
Message-Id: <20211115165439.427956615@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
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



