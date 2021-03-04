Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B84F632D52C
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 15:22:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233704AbhCDOVj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 09:21:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:44870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240710AbhCDOVM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Mar 2021 09:21:12 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 61AC664F47;
        Thu,  4 Mar 2021 14:20:32 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1lHoq7-001nwg-Bp; Thu, 04 Mar 2021 09:20:31 -0500
Message-ID: <20210304142031.249509189@goodmis.org>
User-Agent: quilt/0.66
Date:   Thu, 04 Mar 2021 09:19:56 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org
Subject: [for-linus][PATCH 4/5] ring-buffer: Force before_stamp and write_stamp to be different on
 discard
References: <20210304141952.446924335@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Part of the logic of the new time stamp code depends on the before_stamp and
the write_stamp to be different if the write_stamp does not match the last
event on the buffer, as it will be used to calculate the delta of the next
event written on the buffer.

The discard logic depends on this, as the next event to come in needs to
inject a full timestamp as it can not rely on the last event timestamp in
the buffer because it is unknown due to events after it being discarded. But
by changing the write_stamp back to the time before it, it forces the next
event to use a full time stamp, instead of relying on it.

The issue came when a full time stamp was used for the event, and
rb_time_delta() returns zero in that case. The update to the write_stamp
(which subtracts delta) made it not change. Then when the event is removed
from the buffer, because the before_stamp and write_stamp still match, the
next event written would calculate its delta from the write_stamp, but that
would be wrong as the write_stamp is of the time of the event that was
discarded.

In the case that the delta change being made to write_stamp is zero, set the
before_stamp to zero as well, and this will force the next event to inject a
full timestamp and not use the current write_stamp.

Cc: stable@vger.kernel.org
Fixes: a389d86f7fd09 ("ring-buffer: Have nested events still record running time stamp")
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index b9dad3500041..342f49c3ccc5 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2814,6 +2814,17 @@ rb_try_to_discard(struct ring_buffer_per_cpu *cpu_buffer,
 				       write_stamp, write_stamp - delta))
 			return 0;
 
+		/*
+		 * It's possible that the event time delta is zero
+		 * (has the same time stamp as the previous event)
+		 * in which case write_stamp and before_stamp could
+		 * be the same. In such a case, force before_stamp
+		 * to be different than write_stamp. It doesn't
+		 * matter what it is, as long as its different.
+		 */
+		if (!delta)
+			rb_time_set(&cpu_buffer->before_stamp, 0);
+
 		/*
 		 * If an event were to come in now, it would see that the
 		 * write_stamp and the before_stamp are different, and assume
-- 
2.30.0


