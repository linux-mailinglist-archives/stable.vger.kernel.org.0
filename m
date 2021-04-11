Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D8F435B53F
	for <lists+stable@lfdr.de>; Sun, 11 Apr 2021 15:49:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235768AbhDKNqT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Apr 2021 09:46:19 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:33440 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236078AbhDKNpK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Apr 2021 09:45:10 -0400
Date:   Sun, 11 Apr 2021 13:43:55 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1618148636;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:  content-transfer-encoding:content-transfer-encoding;
        bh=7BBWC45xidcq52O21P3lQ481Xp1J55JZ1a0T0l57AHE=;
        b=2mV0vpVFChtduUlP5kyudMfUW5gufJq75Te4JU4k/gjC3mcDhXHvllZCJfSXnNrlIhxoTE
        ffsDd+6EkYisRuPWjyhbgpo39KocPNfDJlqNzKcmFkw2VnMawx+K7/id8Hv+MDlETgNMpU
        JIU376/H0BlnPDoFKucKDAwJcu4EVhVgXOaVvXhkSwsmrHE1e4kaxsq4AQJt8S2dBtX739
        01S2n4swwNy6xCE/+CQ+q4fZsLpU/EhtQc+qaY9/juKRawxtQeLmtOPIcMx9tiAs0VOnmc
        E0+iGu3Sav2RaDZ47/21PsPa8hs2PNtUqjDMtJM1o6PbDuRmbIRCvAoaoEYC4w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1618148636;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:  content-transfer-encoding:content-transfer-encoding;
        bh=7BBWC45xidcq52O21P3lQ481Xp1J55JZ1a0T0l57AHE=;
        b=+KT1Ny3hU6/4R33HJCktCpYIyYzDb8L0PtLJa8zNJrrmFWb16ZM2R5XhvP9602vX+nDyqG
        /Uf/810uRPct2VDg==
From:   "tip-bot2 for Marco Elver" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: locking/core] kcsan, debugfs: Move debugfs file creation out of
 early init
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        stable <stable@vger.kernel.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Marco Elver <elver@google.com>,
        "Paul E. McKenney" <paulmck@kernel.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org
MIME-Version: 1.0
Message-ID: <161814863544.29796.1503667978431244040.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the locking/core branch of tip:

Commit-ID:     e36299efe7d749976fbdaaf756dee6ef32543c2c
Gitweb:        https://git.kernel.org/tip/e36299efe7d749976fbdaaf756dee6ef32543c2c
Author:        Marco Elver <elver@google.com>
AuthorDate:    Wed, 03 Mar 2021 10:38:45 +01:00
Committer:     Paul E. McKenney <paulmck@kernel.org>
CommitterDate: Mon, 08 Mar 2021 14:27:43 -08:00

kcsan, debugfs: Move debugfs file creation out of early init

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
