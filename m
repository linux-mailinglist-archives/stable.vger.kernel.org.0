Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF4B558090D
	for <lists+stable@lfdr.de>; Tue, 26 Jul 2022 03:36:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230503AbiGZBgr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jul 2022 21:36:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbiGZBgr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Jul 2022 21:36:47 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC0CA1F2F8;
        Mon, 25 Jul 2022 18:36:45 -0700 (PDT)
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4LsKD30Q7BzWf9r;
        Tue, 26 Jul 2022 09:32:51 +0800 (CST)
Received: from kwepemm600003.china.huawei.com (7.193.23.202) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 26 Jul 2022 09:36:37 +0800
Received: from ubuntu1804.huawei.com (10.67.174.61) by
 kwepemm600003.china.huawei.com (7.193.23.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 26 Jul 2022 09:36:36 +0800
From:   Yang Jihong <yangjihong1@huawei.com>
To:     <peterz@infradead.org>, <mingo@redhat.com>, <acme@kernel.org>,
        <alexander.shishkin@linux.intel.com>, <jolsa@redhat.com>,
        <namhyung@kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <yangjihong1@huawei.com>, <stable@vger.kernel.org>
Subject: [PATCH 4.19] perf/core: Fix data race between perf_event_set_output() and perf_mmap_close()
Date:   Tue, 26 Jul 2022 09:33:56 +0800
Message-ID: <20220726013356.88395-1-yangjihong1@huawei.com>
X-Mailer: git-send-email 2.30.GIT
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.174.61]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm600003.china.huawei.com (7.193.23.202)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 68e3c69803dada336893640110cb87221bb01dcf upstream.

Yang Jihing reported a race between perf_event_set_output() and
perf_mmap_close():

        CPU1                                    CPU2

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
[YJH: backport to 4.19: adjusted context]
Signed-off-by: Yang Jihong <yangjihong1@huawei.com>
---
 kernel/events/core.c | 45 ++++++++++++++++++++++++++++++--------------
 1 file changed, 31 insertions(+), 14 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 88dd1398ae88..ba66ea3ca705 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5719,10 +5719,10 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 
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
@@ -10396,14 +10396,25 @@ static int perf_copy_attr(struct perf_event_attr __user *uattr,
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
 	struct ring_buffer *rb = NULL;
 	int ret = -EINVAL;
 
-	if (!output_event)
+	if (!output_event) {
+		mutex_lock(&event->mmap_mutex);
 		goto set;
+	}
 
 	/* don't allow circular references */
 	if (event == output_event)
@@ -10441,8 +10452,15 @@ perf_event_set_output(struct perf_event *event, struct perf_event *output_event)
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
@@ -10452,6 +10470,12 @@ perf_event_set_output(struct perf_event *event, struct perf_event *output_event)
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
@@ -10459,20 +10483,13 @@ perf_event_set_output(struct perf_event *event, struct perf_event *output_event)
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
2.30.GIT

