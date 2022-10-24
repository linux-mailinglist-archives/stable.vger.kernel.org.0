Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3444160ACDD
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 16:16:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233815AbiJXOQg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 10:16:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235047AbiJXOO1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 10:14:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF6353054C;
        Mon, 24 Oct 2022 05:54:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 831DC612CE;
        Mon, 24 Oct 2022 12:36:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91860C433B5;
        Mon, 24 Oct 2022 12:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615012;
        bh=bEmBgl0GT+2D0DUgIZWHRCQpwTRsSlgOSVEiO/oYD9k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OcsS2iVdwDzoyp4tbYs7qJLjlIxy+OHh08sA7cohR3OEpjHQpNRmhntofg9A2ecVF
         HnW/vj0OL23vLU9ejTMSwZnZu7bw1kNJFBxQDUW81TcEDkHhgQzgo6pQpMu6yU70AU
         b6YVDb1ecuF0GynMxLZNnX2ktL9RuhkFblHwgd1M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Alexey Lyashkov <alexey.lyashkov@gmail.com>,
        "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.15 088/530] jbd2: wake up journal waiters in FIFO order, not LIFO
Date:   Mon, 24 Oct 2022 13:27:12 +0200
Message-Id: <20221024113048.989359615@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrew Perepechko <anserper@ya.ru>

commit 34fc8768ec6089565d6d73bad26724083cecf7bd upstream.

LIFO wakeup order is unfair and sometimes leads to a journal
user not being able to get a journal handle for hundreds of
transactions in a row.

FIFO wakeup can make things more fair.

Cc: stable@kernel.org
Signed-off-by: Alexey Lyashkov <alexey.lyashkov@gmail.com>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Link: https://lore.kernel.org/r/20220907165959.1137482-1-alexey.lyashkov@gmail.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/jbd2/commit.c      |    2 +-
 fs/jbd2/transaction.c |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -581,7 +581,7 @@ void jbd2_journal_commit_transaction(jou
 	journal->j_running_transaction = NULL;
 	start_time = ktime_get();
 	commit_transaction->t_log_start = journal->j_head;
-	wake_up(&journal->j_wait_transaction_locked);
+	wake_up_all(&journal->j_wait_transaction_locked);
 	write_unlock(&journal->j_state_lock);
 
 	jbd_debug(3, "JBD2: commit phase 2a\n");
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -173,7 +173,7 @@ static void wait_transaction_locked(jour
 	int need_to_start;
 	tid_t tid = journal->j_running_transaction->t_tid;
 
-	prepare_to_wait(&journal->j_wait_transaction_locked, &wait,
+	prepare_to_wait_exclusive(&journal->j_wait_transaction_locked, &wait,
 			TASK_UNINTERRUPTIBLE);
 	need_to_start = !tid_geq(journal->j_commit_request, tid);
 	read_unlock(&journal->j_state_lock);
@@ -199,7 +199,7 @@ static void wait_transaction_switching(j
 		read_unlock(&journal->j_state_lock);
 		return;
 	}
-	prepare_to_wait(&journal->j_wait_transaction_locked, &wait,
+	prepare_to_wait_exclusive(&journal->j_wait_transaction_locked, &wait,
 			TASK_UNINTERRUPTIBLE);
 	read_unlock(&journal->j_state_lock);
 	/*
@@ -911,7 +911,7 @@ void jbd2_journal_unlock_updates (journa
 	write_lock(&journal->j_state_lock);
 	--journal->j_barrier_count;
 	write_unlock(&journal->j_state_lock);
-	wake_up(&journal->j_wait_transaction_locked);
+	wake_up_all(&journal->j_wait_transaction_locked);
 }
 
 static void warn_dirty_buffer(struct buffer_head *bh)


