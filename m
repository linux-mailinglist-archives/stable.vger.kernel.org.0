Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 440DE2D624A
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 17:43:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391114AbgLJOhy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 09:37:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:44780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391117AbgLJOhs (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 09:37:48 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 5.9 19/75] ring-buffer: Always check to put back before stamp when crossing pages
Date:   Thu, 10 Dec 2020 15:26:44 +0100
Message-Id: <20201210142607.001525071@linuxfoundation.org>
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

From: Steven Rostedt (VMware) <rostedt@goodmis.org>

commit 68e10d5ff512b503dcba1246ad5620f32035e135 upstream.

The current ring buffer logic checks to see if the updating of the event
buffer was interrupted, and if it is, it will try to fix up the before stamp
with the write stamp to make them equal again. This logic is flawed, because
if it is not interrupted, the two are guaranteed to be different, as the
current event just updated the before stamp before allocation. This
guarantees that the next event (this one or another interrupting one) will
think it interrupted the time updates of a previous event and inject an
absolute time stamp to compensate.

The correct logic is to always update the timestamps when traversing to a
new sub buffer.

Cc: stable@vger.kernel.org
Fixes: a389d86f7fd09 ("ring-buffer: Have nested events still record running time stamp")
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/ring_buffer.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -3234,14 +3234,12 @@ __rb_reserve_next(struct ring_buffer_per
 
 	/* See if we shot pass the end of this buffer page */
 	if (unlikely(write > BUF_PAGE_SIZE)) {
-		if (tail != w) {
-			/* before and after may now different, fix it up*/
-			b_ok = rb_time_read(&cpu_buffer->before_stamp, &info->before);
-			a_ok = rb_time_read(&cpu_buffer->write_stamp, &info->after);
-			if (a_ok && b_ok && info->before != info->after)
-				(void)rb_time_cmpxchg(&cpu_buffer->before_stamp,
-						      info->before, info->after);
-		}
+		/* before and after may now different, fix it up*/
+		b_ok = rb_time_read(&cpu_buffer->before_stamp, &info->before);
+		a_ok = rb_time_read(&cpu_buffer->write_stamp, &info->after);
+		if (a_ok && b_ok && info->before != info->after)
+			(void)rb_time_cmpxchg(&cpu_buffer->before_stamp,
+					      info->before, info->after);
 		return rb_move_tail(cpu_buffer, tail, info);
 	}
 


