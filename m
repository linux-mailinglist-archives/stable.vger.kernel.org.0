Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FF4A582DDF
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:04:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241277AbiG0REE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:04:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236432AbiG0RDc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:03:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 261DA6D9DC;
        Wed, 27 Jul 2022 09:38:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4D10960BA0;
        Wed, 27 Jul 2022 16:38:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A873C433C1;
        Wed, 27 Jul 2022 16:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939922;
        bh=6J4syHcTuHSgwitrU92rEQ+oRjZ/UBbuCf8zt0tUKaI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dqjMjZ+a+aZHZGK/MlrrfyLaAS63OXg1h0gtJbVxDwRvoGDNLmamAd+SNJ1+JVnmX
         vXpIWEphhWkegKVnjD7X7NTwI8vRPV19Yf23TIYpHFNim/rtJT71HxEQ1EvEhMoFAD
         jsPm8kQp5BqXe/KUQOzLnNhhAIQ3mZiihTRqK4x4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Jihong <yangjihong1@huawei.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 036/201] perf/core: Fix data race between perf_event_set_output() and perf_mmap_close()
Date:   Wed, 27 Jul 2022 18:09:00 +0200
Message-Id: <20220727161028.367591172@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161026.977588183@linuxfoundation.org>
References: <20220727161026.977588183@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 68e3c69803dada336893640110cb87221bb01dcf ]

Yang Jihing reported a race between perf_event_set_output() and
perf_mmap_close():

	CPU1					CPU2

	perf_mmap_close(e2)
	  if (atomic_dec_and_test(&e2->rb->mmap_count)) // 1 - > 0
	    detach_rest = true

						ioctl(e1, IOC_SET_OUTPUT, e2)
						  perf_event_set_output(e1, e2)

	  ...
	  list_for_each_entry_rcu(e, &e2->rb->event_list, rb_entry)
	    ring_buffer_attach(e, NULL);
	    // e1 isn't yet added and
	    // therefore not detached

						    ring_buffer_attach(e1, e2->rb)
						      list_add_rcu(&e1->rb_entry,
								   &e2->rb->event_list)

After this; e1 is attached to an unmapped rb and a subsequent
perf_mmap() will loop forever more:

	again:
		mutex_lock(&e->mmap_mutex);
		if (event->rb) {
			...
			if (!atomic_inc_not_zero(&e->rb->mmap_count)) {
				...
				mutex_unlock(&e->mmap_mutex);
				goto again;
			}
		}

The loop in perf_mmap_close() holds e2->mmap_mutex, while the attach
in perf_event_set_output() holds e1->mmap_mutex. As such there is no
serialization to avoid this race.

Change perf_event_set_output() to take both e1->mmap_mutex and
e2->mmap_mutex to alleviate that problem. Additionally, have the loop
in perf_mmap() detach the rb directly, this avoids having to wait for
the concurrent perf_mmap_close() to get around to doing it to make
progress.

Fixes: 9bb5d40cd93c ("perf: Fix mmap() accounting hole")
Reported-by: Yang Jihong <yangjihong1@huawei.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: Yang Jihong <yangjihong1@huawei.com>
Link: https://lkml.kernel.org/r/YsQ3jm2GR38SW7uD@worktop.programming.kicks-ass.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 45 ++++++++++++++++++++++++++++++--------------
 1 file changed, 31 insertions(+), 14 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index d7e05d937560..c6c7a4d80573 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6355,10 +6355,10 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 
 		if (!atomic_inc_not_zero(&event->rb->mmap_count)) {
 			/*
-			 * Raced against perf_mmap_close() through
-			 * perf_event_set_output(). Try again, hope for better
-			 * luck.
+			 * Raced against perf_mmap_close(); remove the
+			 * event and try again.
 			 */
+			ring_buffer_attach(event, NULL);
 			mutex_unlock(&event->mmap_mutex);
 			goto again;
 		}
@@ -11892,14 +11892,25 @@ static int perf_copy_attr(struct perf_event_attr __user *uattr,
 	goto out;
 }
 
+static void mutex_lock_double(struct mutex *a, struct mutex *b)
+{
+	if (b < a)
+		swap(a, b);
+
+	mutex_lock(a);
+	mutex_lock_nested(b, SINGLE_DEPTH_NESTING);
+}
+
 static int
 perf_event_set_output(struct perf_event *event, struct perf_event *output_event)
 {
 	struct perf_buffer *rb = NULL;
 	int ret = -EINVAL;
 
-	if (!output_event)
+	if (!output_event) {
+		mutex_lock(&event->mmap_mutex);
 		goto set;
+	}
 
 	/* don't allow circular references */
 	if (event == output_event)
@@ -11937,8 +11948,15 @@ perf_event_set_output(struct perf_event *event, struct perf_event *output_event)
 	    event->pmu != output_event->pmu)
 		goto out;
 
+	/*
+	 * Hold both mmap_mutex to serialize against perf_mmap_close().  Since
+	 * output_event is already on rb->event_list, and the list iteration
+	 * restarts after every removal, it is guaranteed this new event is
+	 * observed *OR* if output_event is already removed, it's guaranteed we
+	 * observe !rb->mmap_count.
+	 */
+	mutex_lock_double(&event->mmap_mutex, &output_event->mmap_mutex);
 set:
-	mutex_lock(&event->mmap_mutex);
 	/* Can't redirect output if we've got an active mmap() */
 	if (atomic_read(&event->mmap_count))
 		goto unlock;
@@ -11948,6 +11966,12 @@ perf_event_set_output(struct perf_event *event, struct perf_event *output_event)
 		rb = ring_buffer_get(output_event);
 		if (!rb)
 			goto unlock;
+
+		/* did we race against perf_mmap_close() */
+		if (!atomic_read(&rb->mmap_count)) {
+			ring_buffer_put(rb);
+			goto unlock;
+		}
 	}
 
 	ring_buffer_attach(event, rb);
@@ -11955,20 +11979,13 @@ perf_event_set_output(struct perf_event *event, struct perf_event *output_event)
 	ret = 0;
 unlock:
 	mutex_unlock(&event->mmap_mutex);
+	if (output_event)
+		mutex_unlock(&output_event->mmap_mutex);
 
 out:
 	return ret;
 }
 
-static void mutex_lock_double(struct mutex *a, struct mutex *b)
-{
-	if (b < a)
-		swap(a, b);
-
-	mutex_lock(a);
-	mutex_lock_nested(b, SINGLE_DEPTH_NESTING);
-}
-
 static int perf_event_set_clock(struct perf_event *event, clockid_t clk_id)
 {
 	bool nmi_safe = false;
-- 
2.35.1



