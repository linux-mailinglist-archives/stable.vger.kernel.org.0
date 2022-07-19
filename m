Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43BBC579969
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:02:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238002AbiGSMC2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:02:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237683AbiGSMBl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:01:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F001E4331C;
        Tue, 19 Jul 2022 04:58:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E78161654;
        Tue, 19 Jul 2022 11:58:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ECA4C341C6;
        Tue, 19 Jul 2022 11:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658231924;
        bh=Bm9v9px20qjhnfPeUXRRvzIaEVzRnS3kuvbqmkLM0rU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i+5riCLc1fSo3ZSbLS1+TUrJ0Sv70VqyQf401rjOmgbjmRPHOTUajfdN4djOO4DaH
         2fEBa4fb5mZuVgvILpRgNZD/GV6s86F+b/YrARrDLYn3mvIWz7PIfUikwyLNd3CqHJ
         mTpUtfLc4aE3Wv1O2KoBmRExZDcICQ3fli9BsXdM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 37/43] signal handling: dont use BUG_ON() for debugging
Date:   Tue, 19 Jul 2022 13:54:08 +0200
Message-Id: <20220719114525.140079922@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114521.868169025@linuxfoundation.org>
References: <20220719114521.868169025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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



