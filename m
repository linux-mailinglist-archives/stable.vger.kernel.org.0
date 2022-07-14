Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61FE55743B9
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 06:38:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237709AbiGNEif (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 00:38:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236686AbiGNEhl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 00:37:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D27AF27B07;
        Wed, 13 Jul 2022 21:27:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6E909B82371;
        Thu, 14 Jul 2022 04:27:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07DC1C34114;
        Thu, 14 Jul 2022 04:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657772827;
        bh=Bm9v9px20qjhnfPeUXRRvzIaEVzRnS3kuvbqmkLM0rU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J89DqVXbZ41QWZLtnqstg96F0/MBNuQID0xiqs8BnJG8qkhRKTavaCPbbp0iF+RY1
         D7v0j8SUkjc3I9Ll6tFQ0pcDf0JaBLCzlLMykPKihmu5KZwVODy36SNeBSLoQjGWIy
         Ot2KqZgZjnn9kO0JkHDtkdjREZ1y+jaJXifllLyaTN9RzeflMcjx9EIORjoJM/VtIs
         eoUp+WhVMi+6lhQqCAjHHKLd555EJEZFH2outW6GbKYCNQKbjglY/SdWejI048tRm+
         Pd/55NB5/iMd6nHmuYOsG7vGBgWyr/weWmqUin55ZBWMc2YyJMIDAQpGv/L6gp3t4p
         K0doLwvS/SroQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, ebiederm@xmission.com,
        keescook@chromium.org, oleg@redhat.com, tglx@linutronix.de,
        peterz@infradead.org
Subject: [PATCH AUTOSEL 4.14 5/5] signal handling: don't use BUG_ON() for debugging
Date:   Thu, 14 Jul 2022 00:26:52 -0400
Message-Id: <20220714042653.282599-5-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220714042653.282599-1-sashal@kernel.org>
References: <20220714042653.282599-1-sashal@kernel.org>
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
index 3619ab24644f..7c3fe8e0230a 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1662,12 +1662,12 @@ bool do_notify_parent(struct task_struct *tsk, int sig)
 	bool autoreap = false;
 	u64 utime, stime;
 
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

