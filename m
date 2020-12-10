Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 791172D6262
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 17:48:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388162AbgLJQob (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 11:44:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:44704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391115AbgLJOhp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 09:37:45 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Andrea Righi <andrea.righi@canonical.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 5.9 18/75] ring-buffer: Set the right timestamp in the slow path of __rb_reserve_next()
Date:   Thu, 10 Dec 2020 15:26:43 +0100
Message-Id: <20201210142606.955620564@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201210142606.074509102@linuxfoundation.org>
References: <20201210142606.074509102@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrea Righi <andrea.righi@canonical.com>

commit 8785f51a17083eee7c37606079c6447afc6ba102 upstream.

In the slow path of __rb_reserve_next() a nested event(s) can happen
between evaluating the timestamp delta of the current event and updating
write_stamp via local_cmpxchg(); in this case the delta is not valid
anymore and it should be set to 0 (same timestamp as the interrupting
event), since the event that we are currently processing is not the last
event in the buffer.

Link: https://lkml.kernel.org/r/X8IVJcp1gRE+FJCJ@xps-13-7390

Cc: Ingo Molnar <mingo@redhat.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lwn.net/Articles/831207
Fixes: a389d86f7fd0 ("ring-buffer: Have nested events still record running time stamp")
Signed-off-by: Andrea Righi <andrea.righi@canonical.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/ring_buffer.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -3287,11 +3287,11 @@ __rb_reserve_next(struct ring_buffer_per
 		ts = rb_time_stamp(cpu_buffer->buffer);
 		barrier();
  /*E*/		if (write == (local_read(&tail_page->write) & RB_WRITE_MASK) &&
-		    info->after < ts) {
+		    info->after < ts &&
+		    rb_time_cmpxchg(&cpu_buffer->write_stamp,
+				    info->after, ts)) {
 			/* Nothing came after this event between C and E */
 			info->delta = ts - info->after;
-			(void)rb_time_cmpxchg(&cpu_buffer->write_stamp,
-					      info->after, ts);
 			info->ts = ts;
 		} else {
 			/*


