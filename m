Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4213A5743C5
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 06:39:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232216AbiGNEjn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 00:39:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237711AbiGNEig (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 00:38:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC6483ED4F;
        Wed, 13 Jul 2022 21:27:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1B44FB8237B;
        Thu, 14 Jul 2022 04:27:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78B52C34114;
        Thu, 14 Jul 2022 04:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657772840;
        bh=GrpiY04TRssppqR1dIMePz1Wt0TmdIADoyIxY+yyqyI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aiuDsxUyuBd6LFkb+bVpPbVOZ8DPbiOTKBVJ2I1o44kOBC2QwIlRTidpLollPulWi
         5DJHoX9sZvptPX1aeD674UzKWNSQUUS+upuZ6HfWWPL+/u8rjz2rDJ9RUosvUx1RDT
         eKxZo5A76RqE5KbG3IiGtKlQFtThxVUr3GOhaqpx4uhj6B445EUlFRu+MauCl5AVNy
         n3Ue6gvL46g+EvIeMYAc3X+al1/n6vCTfWjDdqnZJv8M80WXAza31W19b1vFBdMkDz
         XJjZq5H28WPKVfoqnEOCvMpWaZWxjCIySQHinvUhUme0oB0iRduglxntf7ohs2FzE7
         naZFqvXxi27Qg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, ebiederm@xmission.com,
        keescook@chromium.org, oleg@redhat.com, tglx@linutronix.de,
        peterz@infradead.org
Subject: [PATCH AUTOSEL 4.9 4/4] signal handling: don't use BUG_ON() for debugging
Date:   Thu, 14 Jul 2022 00:27:07 -0400
Message-Id: <20220714042707.282675-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220714042707.282675-1-sashal@kernel.org>
References: <20220714042707.282675-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit a382f8fee42ca10c9bfce0d2352d4153f931f5dc ]

These are indeed "should not happen" situations, but it turns out recent
changes made the 'task_is_stopped_or_trace()' case trigger (fix for that
exists, is pending more testing), and the BUG_ON() makes it
unnecessarily hard to actually debug for no good reason.

It's been that way for a long time, but let's make it clear: BUG_ON() is
not good for debugging, and should never be used in situations where you
could just say "this shouldn't happen, but we can continue".

Use WARN_ON_ONCE() instead to make sure it gets logged, and then just
continue running.  Instead of making the system basically unusuable
because you crashed the machine while potentially holding some very core
locks (eg this function is commonly called while holding 'tasklist_lock'
for writing).

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/signal.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 2c26af848e68..670755212d35 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1647,12 +1647,12 @@ bool do_notify_parent(struct task_struct *tsk, int sig)
 	bool autoreap = false;
 	cputime_t utime, stime;
 
-	BUG_ON(sig == -1);
+	WARN_ON_ONCE(sig == -1);
 
- 	/* do_notify_parent_cldstop should have been called instead.  */
- 	BUG_ON(task_is_stopped_or_traced(tsk));
+	/* do_notify_parent_cldstop should have been called instead.  */
+	WARN_ON_ONCE(task_is_stopped_or_traced(tsk));
 
-	BUG_ON(!tsk->ptrace &&
+	WARN_ON_ONCE(!tsk->ptrace &&
 	       (tsk->group_leader != tsk || !thread_group_empty(tsk)));
 
 	if (sig != SIGCHLD) {
-- 
2.35.1

