Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5433F39E93
	for <lists+stable@lfdr.de>; Sat,  8 Jun 2019 13:51:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727805AbfFHLsS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Jun 2019 07:48:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:36992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729556AbfFHLsS (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 8 Jun 2019 07:48:18 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D423921530;
        Sat,  8 Jun 2019 11:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559994497;
        bh=KcED9CsH0R4O5+gQ5OIU7w3wA7CyJq+13uR3JUu51jQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qlRfxybTLDTkAevmVOpI2u81OUZwSrDLqRMV5gFtAgLbqruCNUUuW1R9xciOSEWfb
         gHY9ARXQsYPSdJzGgyOqJoBFJjK6U8J6gqPBcq7+Oq2/I1Dli13uLKXkPta7lVKPvX
         OtIrqXMTU4kJ/pqg1MccWeeARWn6Ey2BF77/TKGM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yabin Cui <yabinc@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vince Weaver <vincent.weaver@maine.edu>, mark.rutland@arm.com,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 05/20] perf/ring_buffer: Fix exposing a temporarily decreased data_head
Date:   Sat,  8 Jun 2019 07:47:41 -0400
Message-Id: <20190608114756.9742-5-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190608114756.9742-1-sashal@kernel.org>
References: <20190608114756.9742-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yabin Cui <yabinc@google.com>

[ Upstream commit 1b038c6e05ff70a1e66e3e571c2e6106bdb75f53 ]

In perf_output_put_handle(), an IRQ/NMI can happen in below location and
write records to the same ring buffer:

	...
	local_dec_and_test(&rb->nest)
	...                          <-- an IRQ/NMI can happen here
	rb->user_page->data_head = head;
	...

In this case, a value A is written to data_head in the IRQ, then a value
B is written to data_head after the IRQ. And A > B. As a result,
data_head is temporarily decreased from A to B. And a reader may see
data_head < data_tail if it read the buffer frequently enough, which
creates unexpected behaviors.

This can be fixed by moving dec(&rb->nest) to after updating data_head,
which prevents the IRQ/NMI above from updating data_head.

[ Split up by peterz. ]

Signed-off-by: Yabin Cui <yabinc@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vince Weaver <vincent.weaver@maine.edu>
Cc: mark.rutland@arm.com
Fixes: ef60777c9abd ("perf: Optimize the perf_output() path by removing IRQ-disables")
Link: http://lkml.kernel.org/r/20190517115418.224478157@infradead.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/ring_buffer.c | 24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/kernel/events/ring_buffer.c b/kernel/events/ring_buffer.c
index 99becab2c1ce..524744a38d61 100644
--- a/kernel/events/ring_buffer.c
+++ b/kernel/events/ring_buffer.c
@@ -52,11 +52,18 @@ static void perf_output_put_handle(struct perf_output_handle *handle)
 	head = local_read(&rb->head);
 
 	/*
-	 * IRQ/NMI can happen here, which means we can miss a head update.
+	 * IRQ/NMI can happen here and advance @rb->head, causing our
+	 * load above to be stale.
 	 */
 
-	if (!local_dec_and_test(&rb->nest))
+	/*
+	 * If this isn't the outermost nesting, we don't have to update
+	 * @rb->user_page->data_head.
+	 */
+	if (local_read(&rb->nest) > 1) {
+		local_dec(&rb->nest);
 		goto out;
+	}
 
 	/*
 	 * Since the mmap() consumer (userspace) can run on a different CPU:
@@ -88,9 +95,18 @@ static void perf_output_put_handle(struct perf_output_handle *handle)
 	rb->user_page->data_head = head;
 
 	/*
-	 * Now check if we missed an update -- rely on previous implied
-	 * compiler barriers to force a re-read.
+	 * We must publish the head before decrementing the nest count,
+	 * otherwise an IRQ/NMI can publish a more recent head value and our
+	 * write will (temporarily) publish a stale value.
+	 */
+	barrier();
+	local_set(&rb->nest, 0);
+
+	/*
+	 * Ensure we decrement @rb->nest before we validate the @rb->head.
+	 * Otherwise we cannot be sure we caught the 'last' nested update.
 	 */
+	barrier();
 	if (unlikely(head != local_read(&rb->head))) {
 		local_inc(&rb->nest);
 		goto again;
-- 
2.20.1

