Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C904A67A330
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 20:36:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234221AbjAXTgm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 14:36:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234799AbjAXTfw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 14:35:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D8A611EAB;
        Tue, 24 Jan 2023 11:35:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5E8BDB816CE;
        Tue, 24 Jan 2023 19:35:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88C05C433A7;
        Tue, 24 Jan 2023 19:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674588927;
        bh=Zy1RraKZmq/HXrRYDNwCyTD3uNkSwVS4rzLVDGA9LyA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NptYpFp+r0IIRw5L3bTrzx4thCHBIZEUr94IzxUKdbR6V5p1dY2lYGeI9EvUBV5iZ
         sstD9CduqEFNz5RTWt4n/lZM89BEn5898/4uVxud+7SVC9+oL4smuC5NRHgSqo8jNj
         K4NhxEkky7zq7Bjt72wgZ9wTATPaDb8g8Hw/JAhntMcMqgqc3lNqpVKmJYzITia3k1
         hORE0CaSJ4SR+0DvvuJ+UPszMsnYwCm9buzjnuDiY6uRIWvL0jnnFntMzvxNNIRb0c
         ZXtYlXiRNtr1bQ7ayX6pUjJimfRzAEwYjYzqX+XvJQ4iRGceP+76oB+HuVFZnQb8Kp
         ZLWh4Rslhe41g==
From:   Eric Biggers <ebiggers@kernel.org>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Kees Cook <keescook@chromium.org>, SeongJae Park <sj@kernel.org>,
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
Subject: [PATCH 5.10 20/20] exit: Use READ_ONCE() for all oops/warn limit reads
Date:   Tue, 24 Jan 2023 11:30:04 -0800
Message-Id: <20230124193004.206841-21-ebiggers@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230124193004.206841-1-ebiggers@kernel.org>
References: <20230124193004.206841-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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
index 8c820aa7b9c5d..bacdaf980933b 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -916,6 +916,7 @@ void __noreturn make_task_dead(int signr)
 	 * Take the task off the cpu after something catastrophic has
 	 * happened.
 	 */
+	unsigned int limit;
 
 	/*
 	 * Every time the system oopses, if the oops happens while a reference
@@ -927,8 +928,9 @@ void __noreturn make_task_dead(int signr)
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
index 6e30455eb2e7c..bc39e2b27d315 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -222,12 +222,15 @@ static void panic_print_sys_info(void)
 
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

