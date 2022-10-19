Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0699603ED6
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:21:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233430AbiJSJVj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:21:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233715AbiJSJT6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:19:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22A70CFB;
        Wed, 19 Oct 2022 02:09:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 948F6617DE;
        Wed, 19 Oct 2022 09:01:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A69ACC433D6;
        Wed, 19 Oct 2022 09:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170078;
        bh=Gor8ma1Y1JlT4Q8d2TK31fIyEysqMQqMhBeWnc8gzp8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Do2Yej9Go8Yb9vetJKhI6o078LI6hq+OcMKip6+CSeJqMJRc5MR0nIVPT66hfBHP3
         eDw6Hs3JuSgavQ0UzMZpbpMHIwuxzypg4JDjO0iWbqc8P0TvQUOmYm/QfL/N6zDoWk
         1uz50f6FIjynpxK9y7DtA740vqRFDpU2A/yEv5gg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Keith Busch <kbusch@kernel.org>,
        Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 517/862] sbitmap: Avoid leaving waitqueue in invalid state in __sbq_wake_up()
Date:   Wed, 19 Oct 2022 10:30:04 +0200
Message-Id: <20221019083312.840347737@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

[ Upstream commit 48c033314f372478548203c583529f53080fd078 ]

When __sbq_wake_up() decrements wait_cnt to 0 but races with someone
else waking the waiter on the waitqueue (so the waitqueue becomes
empty), it exits without reseting wait_cnt to wake_batch number. Once
wait_cnt is 0, nobody will ever reset the wait_cnt or wake the new
waiters resulting in possible deadlocks or busyloops. Fix the problem by
making sure we reset wait_cnt even if we didn't wake up anybody in the
end.

Fixes: 040b83fcecfb ("sbitmap: fix possible io hung due to lost wakeup")
Reported-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20220908130937.2795-1-jack@suse.cz
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/sbitmap.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/lib/sbitmap.c b/lib/sbitmap.c
index 1f31147872e6..bb1970ad4875 100644
--- a/lib/sbitmap.c
+++ b/lib/sbitmap.c
@@ -605,6 +605,7 @@ static bool __sbq_wake_up(struct sbitmap_queue *sbq)
 	struct sbq_wait_state *ws;
 	unsigned int wake_batch;
 	int wait_cnt;
+	bool ret;
 
 	ws = sbq_wake_ptr(sbq);
 	if (!ws)
@@ -615,12 +616,23 @@ static bool __sbq_wake_up(struct sbitmap_queue *sbq)
 	 * For concurrent callers of this, callers should call this function
 	 * again to wakeup a new batch on a different 'ws'.
 	 */
-	if (wait_cnt < 0 || !waitqueue_active(&ws->wait))
+	if (wait_cnt < 0)
 		return true;
 
+	/*
+	 * If we decremented queue without waiters, retry to avoid lost
+	 * wakeups.
+	 */
 	if (wait_cnt > 0)
-		return false;
+		return !waitqueue_active(&ws->wait);
 
+	/*
+	 * When wait_cnt == 0, we have to be particularly careful as we are
+	 * responsible to reset wait_cnt regardless whether we've actually
+	 * woken up anybody. But in case we didn't wakeup anybody, we still
+	 * need to retry.
+	 */
+	ret = !waitqueue_active(&ws->wait);
 	wake_batch = READ_ONCE(sbq->wake_batch);
 
 	/*
@@ -649,7 +661,7 @@ static bool __sbq_wake_up(struct sbitmap_queue *sbq)
 	sbq_index_atomic_inc(&sbq->wake_index);
 	atomic_set(&ws->wait_cnt, wake_batch);
 
-	return false;
+	return ret;
 }
 
 void sbitmap_queue_wake_up(struct sbitmap_queue *sbq)
-- 
2.35.1



