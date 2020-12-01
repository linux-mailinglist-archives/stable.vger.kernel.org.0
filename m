Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6358F2CA7A2
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 17:05:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403943AbgLAQB2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 11:01:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:42710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391653AbgLAQB2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 11:01:28 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 97B512223F;
        Tue,  1 Dec 2020 16:00:07 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1kk84T-002R6U-Su; Tue, 01 Dec 2020 11:00:05 -0500
Message-ID: <20201201160005.780999537@goodmis.org>
User-Agent: quilt/0.66
Date:   Tue, 01 Dec 2020 10:58:40 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org, "J. Avila" <elavila@google.com>,
        Daniel Mentz <danielmentz@google.com>,
        Will McVicker <willmcvicker@google.com>
Subject: [for-linus][PATCH 05/12] ring-buffer: Update write stamp with the correct ts
References: <20201201155835.647858317@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

The write stamp, used to calculate deltas between events, was updated with
the stale "ts" value in the "info" structure, and not with the updated "ts"
variable. This caused the deltas between events to be inaccurate, and when
crossing into a new sub buffer, had time go backwards.

Link: https://lkml.kernel.org/r/20201124223917.795844-1-elavila@google.com

Cc: stable@vger.kernel.org
Fixes: a389d86f7fd09 ("ring-buffer: Have nested events still record running time stamp")
Reported-by: "J. Avila" <elavila@google.com>
Tested-by: Daniel Mentz <danielmentz@google.com>
Tested-by: Will McVicker <willmcvicker@google.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index dc83b3fa9fe7..bccaf88d3706 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -3291,7 +3291,7 @@ __rb_reserve_next(struct ring_buffer_per_cpu *cpu_buffer,
 			/* Nothing came after this event between C and E */
 			info->delta = ts - info->after;
 			(void)rb_time_cmpxchg(&cpu_buffer->write_stamp,
-					      info->after, info->ts);
+					      info->after, ts);
 			info->ts = ts;
 		} else {
 			/*
-- 
2.28.0


