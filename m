Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D27232BC37
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 22:48:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383268AbhCCNpi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Mar 2021 08:45:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1843044AbhCCKYy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Mar 2021 05:24:54 -0500
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52932C08EB23
        for <stable@vger.kernel.org>; Wed,  3 Mar 2021 01:38:58 -0800 (PST)
Received: by mail-qk1-x74a.google.com with SMTP id a1so7643111qkn.11
        for <stable@vger.kernel.org>; Wed, 03 Mar 2021 01:38:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=06CCmBMLbXxMNmm2C3sV6HK1skcr37rdo4zP3bjD240=;
        b=BABNwRFoNRuKVO2/1k0kWsWMaH2Ytj69DQM6xrDt/c7pq3j1Ztj1kYgx71JEZn3LYW
         w1zjHH7r5a1eWfCL2+l1Hzl8xftOlRSRA1rYchzUrv36cdLGx5i8YwKvbMon9JZYROSZ
         mDseW26BwqOr7wulffylfQykQ5V3swv3FHkrXSFMQLp8hIQ7pm+X3Un+XN+3/eV/kaEy
         WnhSZyDT+o2gWP2YJgwmEt0iDTtR18QrjlkBk4leqHlZq+mXICVBvZAKmGwU+MHGOCty
         HlO+Bie8Tpk/boSW2zMGDLn9QwddR00Vnfm7L2QSkQGTjcP8Bb1549s2YUnXQKVVI9fs
         2ApQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=06CCmBMLbXxMNmm2C3sV6HK1skcr37rdo4zP3bjD240=;
        b=e2RnZC45fbP9GV6UYri0esfXlI+uLnmsFW/cN4EhANs4g5+g4qLFbAbaGUsFJDCKCh
         STkETGJxjepR3JPO4wzVCqztChhvRAD2j3wsK3gRC6rDeUGEGW6iiYihsnDE0cuW90gD
         jz5E4IJ3XqC+4ZeDvOgF5swOayBPToxg0DQs3MmfYTfNW37z/zRhdqsp6v5BhynPHvmb
         cHBSF24JySvg3x768gPZKT+ptig/CXBrtfI8j4o6Aval9Oo5G6xeL4xImRffUG5OcTke
         cTaVP7oWI0jbtXvovUIxJOQ3+sG0Wn2B1+NQoNmWBdOWelRw4I6W4YV/RKKmE/G695T7
         wuhw==
X-Gm-Message-State: AOAM533uKlvKTUNVeX/DmnmJxx7XWI7J+B368E1XnSSDht6vEnF2HBVN
        gr1o4IqJ5fGPv3sp/+aH9quwI2Nz7A==
X-Google-Smtp-Source: ABdhPJzVPT7JrZ0AyCVKEOFLcjB3h7Pf4NzZlDrY2O8FNi/lvc8WslssJU2+PArRaY+iS7JKbVidY/gySw==
Sender: "elver via sendgmr" <elver@elver.muc.corp.google.com>
X-Received: from elver.muc.corp.google.com ([2a00:79e0:15:13:811:228c:e84:3381])
 (user=elver job=sendgmr) by 2002:a05:6214:6f1:: with SMTP id
 bk17mr7605939qvb.53.1614764337502; Wed, 03 Mar 2021 01:38:57 -0800 (PST)
Date:   Wed,  3 Mar 2021 10:38:45 +0100
Message-Id: <20210303093845.2743309-1-elver@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH] kcsan, debugfs: Move debugfs file creation out of early init
From:   Marco Elver <elver@google.com>
To:     gregkh@linuxfoundation.org, rafael@kernel.org
Cc:     paulmck@kernel.org, dvyukov@google.com, glider@google.com,
        andreyknvl@google.com, kasan-dev@googlegroups.com,
        linux-kernel@vger.kernel.org, Marco Elver <elver@google.com>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 56348560d495 ("debugfs: do not attempt to create a new file
before the filesystem is initalized") forbids creating new debugfs files
until debugfs is fully initialized. This breaks KCSAN's debugfs file
creation, which happened at the end of __init().

There is no reason to create the debugfs file during early
initialization. Therefore, move it into a late_initcall() callback.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: stable <stable@vger.kernel.org>
Fixes: 56348560d495 ("debugfs: do not attempt to create a new file before the filesystem is initalized")
Signed-off-by: Marco Elver <elver@google.com>
---
I've marked this for 'stable', since 56348560d495 is also intended for
stable, and would subsequently break KCSAN in all stable kernels where
KCSAN is available (since 5.8).
---
 kernel/kcsan/core.c    | 2 --
 kernel/kcsan/debugfs.c | 4 +++-
 kernel/kcsan/kcsan.h   | 5 -----
 3 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/kernel/kcsan/core.c b/kernel/kcsan/core.c
index 8c3867640c21..45c821d4e8bd 100644
--- a/kernel/kcsan/core.c
+++ b/kernel/kcsan/core.c
@@ -644,8 +644,6 @@ void __init kcsan_init(void)
 
 	BUG_ON(!in_task());
 
-	kcsan_debugfs_init();
-
 	for_each_possible_cpu(cpu)
 		per_cpu(kcsan_rand_state, cpu) = (u32)get_cycles();
 
diff --git a/kernel/kcsan/debugfs.c b/kernel/kcsan/debugfs.c
index c837ce6c52e6..c1dd02f3be8b 100644
--- a/kernel/kcsan/debugfs.c
+++ b/kernel/kcsan/debugfs.c
@@ -266,7 +266,9 @@ static const struct file_operations debugfs_ops =
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
index 594a5dd4842a..9881099d4179 100644
--- a/kernel/kcsan/kcsan.h
+++ b/kernel/kcsan/kcsan.h
@@ -31,11 +31,6 @@ extern bool kcsan_enabled;
 void kcsan_save_irqtrace(struct task_struct *task);
 void kcsan_restore_irqtrace(struct task_struct *task);
 
-/*
- * Initialize debugfs file.
- */
-void kcsan_debugfs_init(void);
-
 /*
  * Statistics counters displayed via debugfs; should only be modified in
  * slow-paths.
-- 
2.30.1.766.gb4fecdf3b7-goog

