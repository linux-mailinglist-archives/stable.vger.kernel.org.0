Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A9A64D730
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 20:18:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729353AbfFTSQY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 14:16:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:45526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729766AbfFTSQX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 14:16:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC33121537;
        Thu, 20 Jun 2019 18:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561054582;
        bh=cdbMbd2xPMxy28IF8dLqeKRuQYbE9LCL365zB0QDSCA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QIbK1j/O1qD+CTAjni3VFBg1iNRVNtPWUwExdaykqgioLYko7ynuFFtmovKbJdqxv
         EaC962AkkNNRgFdhzVlcnEtWERhFXw/sGy3NZzQhRWA7znelhNQelfEw0LSkfaw9JC
         MhEkXemAaBObgNco9+kZuPVgJwavzvJpWKCDVn58=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yabin Cui <yabinc@google.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vince Weaver <vincent.weaver@maine.edu>, acme@kernel.org,
        mark.rutland@arm.com, namhyung@kernel.org,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 50/98] perf/ring-buffer: Always use {READ,WRITE}_ONCE() for rb->user_page data
Date:   Thu, 20 Jun 2019 19:57:17 +0200
Message-Id: <20190620174351.533977697@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190620174349.443386789@linuxfoundation.org>
References: <20190620174349.443386789@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index 4b5f8d932400..7a0c73e4b3eb 100644
--- a/kernel/events/ring_buffer.c
+++ b/kernel/events/ring_buffer.c
@@ -100,7 +100,7 @@ static void perf_output_put_handle(struct perf_output_handle *handle)
 	 * See perf_output_begin().
 	 */
 	smp_wmb(); /* B, matches C */
-	rb->user_page->data_head = head;
+	WRITE_ONCE(rb->user_page->data_head, head);
 
 	/*
 	 * We must publish the head before decrementing the nest count,
@@ -496,7 +496,7 @@ void perf_aux_output_end(struct perf_output_handle *handle, unsigned long size)
 		perf_event_aux_event(handle->event, aux_head, size,
 				     handle->aux_flags);
 
-	rb->user_page->aux_head = rb->aux_head;
+	WRITE_ONCE(rb->user_page->aux_head, rb->aux_head);
 	if (rb_need_aux_wakeup(rb))
 		wakeup = true;
 
@@ -528,7 +528,7 @@ int perf_aux_output_skip(struct perf_output_handle *handle, unsigned long size)
 
 	rb->aux_head += size;
 
-	rb->user_page->aux_head = rb->aux_head;
+	WRITE_ONCE(rb->user_page->aux_head, rb->aux_head);
 	if (rb_need_aux_wakeup(rb)) {
 		perf_output_wakeup(handle);
 		handle->wakeup = rb->aux_wakeup + rb->aux_watermark;
-- 
2.20.1



