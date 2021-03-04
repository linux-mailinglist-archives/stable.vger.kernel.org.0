Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4492032C9B6
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 02:19:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242422AbhCDBLo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Mar 2021 20:11:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:40748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1453018AbhCDAlW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Mar 2021 19:41:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F8AC64E56;
        Thu,  4 Mar 2021 00:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614818442;
        bh=U67KGML75N8By1bz3LMOVDbokz5d92SCVIMh9rk/fYk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=batTImm8qQfQ/Muqx0SWCUQ0aPSpug82E1GpBqcwSdW8KtJ5Dt3GznwkNPmPmwsHL
         QKVZDYjkxBVSLJy5fqgvu4S7PrR9Bj1xK71kwNDknXp/uJ2uHMEOg8KxjHVv1wAunJ
         dx9ovojRgkeNIpm/PCiZRw10xsnBrvi99cJ+AZKWsgA9lwsARDc2GJs2RWXx3hFXcI
         1p/0J3e+6Xey23VnmrWePIEBElRyABNcd7Z6FYXSeCG9UoDT7zzcMnqCOoDQd6CQx1
         IyAR/fqE47fshSAijgsZeHIKNrlZxMqpLFd4ajGWKb6i+JEEtGy5Vcux8B0fDiZWwJ
         UAEKOwy5Xjj7w==
From:   paulmck@kernel.org
To:     linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com,
        kernel-team@fb.com, mingo@kernel.org
Cc:     elver@google.com, andreyknvl@google.com, glider@google.com,
        dvyukov@google.com, cai@lca.pw, boqun.feng@gmail.com,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        stable <stable@vger.kernel.org>,
        "Paul E . McKenney" <paulmck@kernel.org>
Subject: [PATCH kcsan 1/4] kcsan, debugfs: Move debugfs file creation out of early init
Date:   Wed,  3 Mar 2021 16:40:37 -0800
Message-Id: <20210304004040.25074-1-paulmck@kernel.org>
X-Mailer: git-send-email 2.9.5
In-Reply-To: <20210304003750.GA24696@paulmck-ThinkPad-P72>
References: <20210304003750.GA24696@paulmck-ThinkPad-P72>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marco Elver <elver@google.com>

Commit 56348560d495 ("debugfs: do not attempt to create a new file
before the filesystem is initalized") forbids creating new debugfs files
until debugfs is fully initialized.  This means that KCSAN's debugfs
file creation, which happened at the end of __init(), no longer works.
And was apparently never supposed to work!

However, there is no reason to create KCSAN's debugfs file so early.
This commit therefore moves its creation to a late_initcall() callback.

Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: stable <stable@vger.kernel.org>
Fixes: 56348560d495 ("debugfs: do not attempt to create a new file before the filesystem is initalized")
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Marco Elver <elver@google.com>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
---
 kernel/kcsan/core.c    | 2 --
 kernel/kcsan/debugfs.c | 4 +++-
 kernel/kcsan/kcsan.h   | 5 -----
 3 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/kernel/kcsan/core.c b/kernel/kcsan/core.c
index 3bf98db..23e7acb 100644
--- a/kernel/kcsan/core.c
+++ b/kernel/kcsan/core.c
@@ -639,8 +639,6 @@ void __init kcsan_init(void)
 
 	BUG_ON(!in_task());
 
-	kcsan_debugfs_init();
-
 	for_each_possible_cpu(cpu)
 		per_cpu(kcsan_rand_state, cpu) = (u32)get_cycles();
 
diff --git a/kernel/kcsan/debugfs.c b/kernel/kcsan/debugfs.c
index 3c8093a..209ad8d 100644
--- a/kernel/kcsan/debugfs.c
+++ b/kernel/kcsan/debugfs.c
@@ -261,7 +261,9 @@ static const struct file_operations debugfs_ops =
 	.release = single_release
 };
 
-void __init kcsan_debugfs_init(void)
+static void __init kcsan_debugfs_init(void)
 {
 	debugfs_create_file("kcsan", 0644, NULL, NULL, &debugfs_ops);
 }
+
+late_initcall(kcsan_debugfs_init);
diff --git a/kernel/kcsan/kcsan.h b/kernel/kcsan/kcsan.h
index 8d4bf34..87ccdb3 100644
--- a/kernel/kcsan/kcsan.h
+++ b/kernel/kcsan/kcsan.h
@@ -31,11 +31,6 @@ void kcsan_save_irqtrace(struct task_struct *task);
 void kcsan_restore_irqtrace(struct task_struct *task);
 
 /*
- * Initialize debugfs file.
- */
-void kcsan_debugfs_init(void);
-
-/*
  * Statistics counters displayed via debugfs; should only be modified in
  * slow-paths.
  */
-- 
2.9.5

