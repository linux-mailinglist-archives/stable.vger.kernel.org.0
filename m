Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6794C45140E
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 21:04:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348933AbhKOUBA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 15:01:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:45126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344202AbhKOTYG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:24:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CD6986363E;
        Mon, 15 Nov 2021 18:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002424;
        bh=hQC/tPsuiKxKWLs0oPZJ0cAQWOa9ot7MTebF7yuPSD4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z+vm0hlW+IyglsGbdIyUGtauw+QtCMfL2JmGCVEsLBYkzu9t3GGpoG3wFPrJ7CGLH
         vPzesn5jLjpxwI/hWPQGN3OjJpkDfGTd9yVrMVTIscSJLlGtPnLWZDU9kSMjmdTPG3
         NiGu3thNIFnOs+mSP64muyAGXgQHhvIErdW00U+8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Kees Cook <keescook@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 528/917] x86: Fix __get_wchan() for !STACKTRACE
Date:   Mon, 15 Nov 2021 18:00:23 +0100
Message-Id: <20211115165446.664604795@linuxfoundation.org>
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

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 5d1ceb3969b6b2e47e2df6d17790a7c5a20fcbb4 ]

Use asm/unwind.h to implement wchan, since we cannot always rely on
STACKTRACE=y.

Fixes: bc9bbb81730e ("x86: Fix get_wchan() to support the ORC unwinder")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Link: https://lkml.kernel.org/r/20211022152104.137058575@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/process.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 266962547b58c..2fe1810e922a9 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -43,6 +43,7 @@
 #include <asm/io_bitmap.h>
 #include <asm/proto.h>
 #include <asm/frame.h>
+#include <asm/unwind.h>
 
 #include "process.h"
 
@@ -945,10 +946,20 @@ unsigned long arch_randomize_brk(struct mm_struct *mm)
  */
 unsigned long __get_wchan(struct task_struct *p)
 {
-	unsigned long entry = 0;
+	struct unwind_state state;
+	unsigned long addr = 0;
 
-	stack_trace_save_tsk(p, &entry, 1, 0);
-	return entry;
+	for (unwind_start(&state, p, NULL, NULL); !unwind_done(&state);
+	     unwind_next_frame(&state)) {
+		addr = unwind_get_return_address(&state);
+		if (!addr)
+			break;
+		if (in_sched_functions(addr))
+			continue;
+		break;
+	}
+
+	return addr;
 }
 
 long do_arch_prctl_common(struct task_struct *task, int option,
-- 
2.33.0



