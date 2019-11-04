Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C605EED74
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:07:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390006AbfKDWGy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:06:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:39040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390004AbfKDWGw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 17:06:52 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7EAA2214D8;
        Mon,  4 Nov 2019 22:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572905212;
        bh=chGnoAshHGqqo+wladlxJN3tEO3v9wGjv9U7ySwG4kM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=klTUdEesm5qQqKfQMuZxY9tjFAIZMDpJsJsle+Or/bPQzpIqWeuG8ae2TYzj3IXlZ
         NvafV1V1D65MOy05kxip8yULl+O0Z9Oz+DgHG1tN68QdAqvKiTs3OMzzWpTOLU17Tw
         VAuyaFvXAKwFcG3mDAJZJy13Zsn4UEAOFAh8GhSE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hechao Li <hechaol@fb.com>,
        Song Liu <songliubraving@fb.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        kernel-team@fb.com, Jie Meng <jmeng@fb.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 067/163] perf/core: Rework memory accounting in perf_mmap()
Date:   Mon,  4 Nov 2019 22:44:17 +0100
Message-Id: <20191104212144.819859713@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212140.046021995@linuxfoundation.org>
References: <20191104212140.046021995@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Song Liu <songliubraving@fb.com>

[ Upstream commit d44248a41337731a111374822d7d4451b64e73e4 ]

perf_mmap() always increases user->locked_vm. As a result, "extra" could
grow bigger than "user_extra", which doesn't make sense. Here is an
example case:

(Note: Assume "user_lock_limit" is very small.)

  | # of perf_mmap calls |vma->vm_mm->pinned_vm|user->locked_vm|
  | 0                    | 0                   | 0             |
  | 1                    | user_extra          | user_extra    |
  | 2                    | 3 * user_extra      | 2 * user_extra|
  | 3                    | 6 * user_extra      | 3 * user_extra|
  | 4                    | 10 * user_extra     | 4 * user_extra|

Fix this by maintaining proper user_extra and extra.

Reviewed-By: Hechao Li <hechaol@fb.com>
Reported-by: Hechao Li <hechaol@fb.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: <kernel-team@fb.com>
Cc: Jie Meng <jmeng@fb.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: https://lkml.kernel.org/r/20190904214618.3795672-1-songliubraving@fb.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index a2a50b668ef32..c0a6a50e01af6 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5585,7 +5585,8 @@ again:
 	 * undo the VM accounting.
 	 */
 
-	atomic_long_sub((size >> PAGE_SHIFT) + 1, &mmap_user->locked_vm);
+	atomic_long_sub((size >> PAGE_SHIFT) + 1 - mmap_locked,
+			&mmap_user->locked_vm);
 	atomic64_sub(mmap_locked, &vma->vm_mm->pinned_vm);
 	free_uid(mmap_user);
 
@@ -5729,8 +5730,20 @@ accounting:
 
 	user_locked = atomic_long_read(&user->locked_vm) + user_extra;
 
-	if (user_locked > user_lock_limit)
+	if (user_locked <= user_lock_limit) {
+		/* charge all to locked_vm */
+	} else if (atomic_long_read(&user->locked_vm) >= user_lock_limit) {
+		/* charge all to pinned_vm */
+		extra = user_extra;
+		user_extra = 0;
+	} else {
+		/*
+		 * charge locked_vm until it hits user_lock_limit;
+		 * charge the rest from pinned_vm
+		 */
 		extra = user_locked - user_lock_limit;
+		user_extra -= extra;
+	}
 
 	lock_limit = rlimit(RLIMIT_MEMLOCK);
 	lock_limit >>= PAGE_SHIFT;
-- 
2.20.1



