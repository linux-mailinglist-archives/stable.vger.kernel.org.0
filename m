Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E99839DF3
	for <lists+stable@lfdr.de>; Sat,  8 Jun 2019 13:45:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728068AbfFHLpV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Jun 2019 07:45:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:60666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728114AbfFHLnV (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 8 Jun 2019 07:43:21 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A3762168B;
        Sat,  8 Jun 2019 11:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559994200;
        bh=OwCmgkkgVHwbMkcZtlSkOW75C8nLCqtITaqQy3Y+Dhc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HN7AUlDBQVdIZFYbHQka0yA5eEplRzaA5JR6drvYWDFHQMwQzrE+TW+RMAiAoGqLZ
         75s4Hr2en3UmVsmzMEHeDJP1V2cruApRnDMYJ6wy+RCHBXLcOltIyj9aUVX8qrPpV1
         d/GFXkV3ZesyIxnnXLXJJ0njfMonyHYeho8tR6WY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Yabin Cui <yabinc@google.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vince Weaver <vincent.weaver@maine.edu>, acme@kernel.org,
        mark.rutland@arm.com, namhyung@kernel.org,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 15/49] perf/ring-buffer: Always use {READ,WRITE}_ONCE() for rb->user_page data
Date:   Sat,  8 Jun 2019 07:41:56 -0400
Message-Id: <20190608114232.8731-15-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190608114232.8731-1-sashal@kernel.org>
References: <20190608114232.8731-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 4d839dd9e4356bbacf3eb0ab13a549b83b008c21 ]

We must use {READ,WRITE}_ONCE() on rb->user_page data such that
concurrent usage will see whole values. A few key sites were missing
this.

Suggested-by: Yabin Cui <yabinc@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vince Weaver <vincent.weaver@maine.edu>
Cc: acme@kernel.org
Cc: mark.rutland@arm.com
Cc: namhyung@kernel.org
Fixes: 7b732a750477 ("perf_counter: new output ABI - part 1")
Link: http://lkml.kernel.org/r/20190517115418.394192145@infradead.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/ring_buffer.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/events/ring_buffer.c b/kernel/events/ring_buffer.c
index d32b9375ec0e..12f351b253bb 100644
--- a/kernel/events/ring_buffer.c
+++ b/kernel/events/ring_buffer.c
@@ -101,7 +101,7 @@ static void perf_output_put_handle(struct perf_output_handle *handle)
 	 * See perf_output_begin().
 	 */
 	smp_wmb(); /* B, matches C */
-	rb->user_page->data_head = head;
+	WRITE_ONCE(rb->user_page->data_head, head);
 
 	/*
 	 * We must publish the head before decrementing the nest count,
@@ -490,7 +490,7 @@ void perf_aux_output_end(struct perf_output_handle *handle, unsigned long size)
 		                     handle->aux_flags);
 	}
 
-	rb->user_page->aux_head = rb->aux_head;
+	WRITE_ONCE(rb->user_page->aux_head, rb->aux_head);
 	if (rb_need_aux_wakeup(rb))
 		wakeup = true;
 
@@ -522,7 +522,7 @@ int perf_aux_output_skip(struct perf_output_handle *handle, unsigned long size)
 
 	rb->aux_head += size;
 
-	rb->user_page->aux_head = rb->aux_head;
+	WRITE_ONCE(rb->user_page->aux_head, rb->aux_head);
 	if (rb_need_aux_wakeup(rb)) {
 		perf_output_wakeup(handle);
 		handle->wakeup = rb->aux_wakeup + rb->aux_watermark;
-- 
2.20.1

