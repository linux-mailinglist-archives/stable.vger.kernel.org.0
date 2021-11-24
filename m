Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 927EE45C033
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:03:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346367AbhKXNFg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:05:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:41104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347996AbhKXNDr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:03:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8F48061A3F;
        Wed, 24 Nov 2021 12:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757407;
        bh=/o8rmn2R0cPjyvnhh+SXEnJPg9vRIPkvzndQ8Xv5ydg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N8S9eHQk4CtMnrvnRGSy1M39hiJ/2YaiVworsJJ09ImoWPMF5FTjz4XKNn0MKwkaN
         0SCgG/PYXO4nEO9/uKv7BPPEmq8EXgpfc+pm+3WaLB2cyrbQToP9XDVZ25pzMEz7oi
         MyHEuAah15UB7onZsNJ9N8pikajEObxl2PKaCNuk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Helge Deller <deller@gmx.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 124/323] task_stack: Fix end_of_stack() for architectures with upwards-growing stack
Date:   Wed, 24 Nov 2021 12:55:14 +0100
Message-Id: <20211124115723.128578826@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
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



