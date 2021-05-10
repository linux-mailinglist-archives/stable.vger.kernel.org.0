Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3CAE3788D3
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:49:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235189AbhEJLYK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:24:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:46208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231712AbhEJLLv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:11:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6364461926;
        Mon, 10 May 2021 11:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644951;
        bh=vyc+nJ14+lnmbhVlGuewjiHY/sqNuE9+DBlk5Cv7qy4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FAmzthEONGFa29oVMdRhH3xq8mqGu+ZvPzbg2jfvFguYxLatSkYp8TQfa1TurzfTr
         kKmE6D00+JesK5EJfnSAvJCmIEzWrF1wmEpZB2mCz3xI+k0YWq/CEgkBWhDtTIfiXV
         ov2/WyPvN3ndsb+5PxbKB4G8L/kKfyyYpG8fbeaA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Rafael J. Wysocki" <rafael@kernel.org>,
        Marco Elver <elver@google.com>,
        "Paul E. McKenney" <paulmck@kernel.org>
Subject: [PATCH 5.12 290/384] kcsan, debugfs: Move debugfs file creation out of early init
Date:   Mon, 10 May 2021 12:21:19 +0200
Message-Id: <20210510102024.371707888@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marco Elver <elver@google.com>

commit e36299efe7d749976fbdaaf756dee6ef32543c2c upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/kcsan/core.c    |    2 --
 kernel/kcsan/debugfs.c |    4 +++-
 kernel/kcsan/kcsan.h   |    5 -----
 3 files changed, 3 insertions(+), 8 deletions(-)

--- a/kernel/kcsan/core.c
+++ b/kernel/kcsan/core.c
@@ -639,8 +639,6 @@ void __init kcsan_init(void)
 
 	BUG_ON(!in_task());
 
-	kcsan_debugfs_init();
-
 	for_each_possible_cpu(cpu)
 		per_cpu(kcsan_rand_state, cpu) = (u32)get_cycles();
 
--- a/kernel/kcsan/debugfs.c
+++ b/kernel/kcsan/debugfs.c
@@ -261,7 +261,9 @@ static const struct file_operations debu
 	.release = single_release
 };
 
-void __init kcsan_debugfs_init(void)
+static void __init kcsan_debugfs_init(void)
 {
 	debugfs_create_file("kcsan", 0644, NULL, NULL, &debugfs_ops);
 }
+
+late_initcall(kcsan_debugfs_init);
--- a/kernel/kcsan/kcsan.h
+++ b/kernel/kcsan/kcsan.h
@@ -31,11 +31,6 @@ void kcsan_save_irqtrace(struct task_str
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


