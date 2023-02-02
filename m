Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DED36687533
	for <lists+stable@lfdr.de>; Thu,  2 Feb 2023 06:29:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231924AbjBBF3L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Feb 2023 00:29:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231970AbjBBF20 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Feb 2023 00:28:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD39827998;
        Wed,  1 Feb 2023 21:28:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8EA94615EF;
        Thu,  2 Feb 2023 05:28:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A436C433A1;
        Thu,  2 Feb 2023 05:28:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675315691;
        bh=lcs6AXLIFbqkFs6UrWf0Ln1qRWrFsNHR0PXy8tOjKNA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NjC6HerwNYZpDQWHNMEAMOutZtfItpkk143ioeMYmoqxhu5m9RxsfveJYd/9divWh
         UH1XXeS0GcumS5+3MeUPWE8d7Db4xX1OT0WvLTfXkHMiX3BV92mW9H3upzxduZEEM1
         5dmleyl/4f0zT0C2WUinAVirG4+tKVnfWDEVkR9CNKwPeeqY/48sDwPno66qEplyOU
         4KcCTTJmup/jgGr6P2U3PXtWnKmL0crqJ+xDqn9KZ9Glogzq7NIUN0iEfSzqwqA9Ak
         VGBIFaqph4V6WR5JffrXP2Ii1HHVozu15LGGi659U/e+etSoGfvRccQP334dNzKPMf
         cfN/e1iF17j6g==
From:   Eric Biggers <ebiggers@kernel.org>
To:     stable@vger.kernel.org
Cc:     Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
        Kees Cook <keescook@chromium.org>,
        SeongJae Park <sj@kernel.org>,
        Seth Jenkins <sethjenkins@google.com>,
        Jann Horn <jannh@google.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Petr Mladek <pmladek@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Marco Elver <elver@google.com>,
        tangmeng <tangmeng@uniontech.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Tiezhu Yang <yangtiezhu@loongson.cn>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 4.19 16/16] exit: Use READ_ONCE() for all oops/warn limit reads
Date:   Wed,  1 Feb 2023 21:26:04 -0800
Message-Id: <20230202052604.179184-17-ebiggers@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230202052604.179184-1-ebiggers@kernel.org>
References: <20230202052604.179184-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

commit 7535b832c6399b5ebfc5b53af5c51dd915ee2538 upstream.

Use a temporary variable to take full advantage of READ_ONCE() behavior.
Without this, the report (and even the test) might be out of sync with
the initial test.

Reported-by: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/lkml/Y5x7GXeluFmZ8E0E@hirez.programming.kicks-ass.net
Fixes: 9fc9e278a5c0 ("panic: Introduce warn_limit")
Fixes: d4ccd54d28d3 ("exit: Put an upper limit on how often we can oops")
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Jann Horn <jannh@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Marco Elver <elver@google.com>
Cc: tangmeng <tangmeng@uniontech.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 kernel/exit.c  | 6 ++++--
 kernel/panic.c | 7 +++++--
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index b2f0aaf6bee78..02360ec3b1225 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -975,6 +975,7 @@ void __noreturn make_task_dead(int signr)
 	 * Take the task off the cpu after something catastrophic has
 	 * happened.
 	 */
+	unsigned int limit;
 
 	/*
 	 * Every time the system oopses, if the oops happens while a reference
@@ -986,8 +987,9 @@ void __noreturn make_task_dead(int signr)
 	 * To make sure this can't happen, place an upper bound on how often the
 	 * kernel may oops without panic().
 	 */
-	if (atomic_inc_return(&oops_count) >= READ_ONCE(oops_limit) && oops_limit)
-		panic("Oopsed too often (kernel.oops_limit is %d)", oops_limit);
+	limit = READ_ONCE(oops_limit);
+	if (atomic_inc_return(&oops_count) >= limit && limit)
+		panic("Oopsed too often (kernel.oops_limit is %d)", limit);
 
 	do_exit(signr);
 }
diff --git a/kernel/panic.c b/kernel/panic.c
index dbb6e27d33e10..982ecba286c08 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -168,12 +168,15 @@ EXPORT_SYMBOL(nmi_panic);
 
 void check_panic_on_warn(const char *origin)
 {
+	unsigned int limit;
+
 	if (panic_on_warn)
 		panic("%s: panic_on_warn set ...\n", origin);
 
-	if (atomic_inc_return(&warn_count) >= READ_ONCE(warn_limit) && warn_limit)
+	limit = READ_ONCE(warn_limit);
+	if (atomic_inc_return(&warn_count) >= limit && limit)
 		panic("%s: system warned too often (kernel.warn_limit is %d)",
-		      origin, warn_limit);
+		      origin, limit);
 }
 
 /**
-- 
2.39.1

