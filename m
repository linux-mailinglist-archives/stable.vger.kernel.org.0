Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 888076896C8
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 11:36:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233049AbjBCKdg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 05:33:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233346AbjBCKdC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 05:33:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1F1AA429D
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 02:31:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1C6EA61E93
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 10:31:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D127BC433EF;
        Fri,  3 Feb 2023 10:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675420286;
        bh=80EA5XDWw49pqWbW9IyD/pBb5C7mSCaxCZzNh3UQ1wI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nx+wSElBwl8Le9k/AQaaOGURe3G7BQWZ6Ja14QECBLGQtCYVw6Wamtt7plmFLGs2Y
         T8/uT/6E5IonHxSfgm5/uz2gWLLrIk0XnLqN1jckb41z/t7lGD26bXuu3VGfFSydR6
         +qM8JmcP0WRKnR+Y+AA/vpS3WGdcDU3zfo7x1Jq8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Peter Zijlstra <peterz@infradead.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Jann Horn <jannh@google.com>, Arnd Bergmann <arnd@arndb.de>,
        Petr Mladek <pmladek@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Marco Elver <elver@google.com>,
        tangmeng <tangmeng@uniontech.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Tiezhu Yang <yangtiezhu@loongson.cn>,
        Kees Cook <keescook@chromium.org>,
        Eric Biggers <ebiggers@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 130/134] exit: Use READ_ONCE() for all oops/warn limit reads
Date:   Fri,  3 Feb 2023 11:13:55 +0100
Message-Id: <20230203101029.670751446@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101023.832083974@linuxfoundation.org>
References: <20230203101023.832083974@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/exit.c  | 6 ++++--
 kernel/panic.c | 7 +++++--
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index 381282fb756c..563bdaa76694 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -917,6 +917,7 @@ void __noreturn make_task_dead(int signr)
 	 * Take the task off the cpu after something catastrophic has
 	 * happened.
 	 */
+	unsigned int limit;
 
 	/*
 	 * Every time the system oopses, if the oops happens while a reference
@@ -928,8 +929,9 @@ void __noreturn make_task_dead(int signr)
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
index 2c118645e740..cef79466f941 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -199,12 +199,15 @@ static void panic_print_sys_info(void)
 
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
2.39.0



