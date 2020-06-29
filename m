Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 829FB20DBAB
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:16:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732890AbgF2UI2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 16:08:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:40586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732932AbgF2TaX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:30:23 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 05CF8252B1;
        Mon, 29 Jun 2020 15:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593445022;
        bh=FbsyZAhJvfUOWhPPwBgeTSgcr/m6g4f3eecPANG7AKE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HVsGgKRS2rkiRQ2rBxyBIeji1dhXO5gY19hlWQ48WZRfno6428iX72+ykXvWHKk4Y
         qduoVUS6G8fX3W5C7R+dI5OoISQ9G0vjdl8ctsRaMBM2fyIWeA5Sq8gw84kVY730eN
         LGe6g2MpJTdpXWbcqyO7eJBcAfeX1hQu/FPHjs0k=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tom Zanussi <zanussi@kernel.org>,
        Julia Lawall <julia.lawall@inria.fr>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.19 120/131] ring-buffer: Zero out time extend if it is nested and not absolute
Date:   Mon, 29 Jun 2020 11:34:51 -0400
Message-Id: <20200629153502.2494656-121-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629153502.2494656-1-sashal@kernel.org>
References: <20200629153502.2494656-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.131-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.131-rc1
X-KernelTest-Deadline: 2020-07-01T15:34+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

commit 097350d1c6e1f5808cae142006f18a0bbc57018d upstream.

Currently the ring buffer makes events that happen in interrupts that preempt
another event have a delta of zero. (Hopefully we can change this soon). But
this is to deal with the races of updating a global counter with lockless
and nesting functions updating deltas.

With the addition of absolute time stamps, the time extend didn't follow
this rule. A time extend can happen if two events happen longer than 2^27
nanoseconds appart, as the delta time field in each event is only 27 bits.
If that happens, then a time extend is injected with 2^59 bits of
nanoseconds to use (18 years). But if the 2^27 nanoseconds happen between
two events, and as it is writing the event, an interrupt triggers, it will
see the 2^27 difference as well and inject a time extend of its own. But a
recent change made the time extend logic not take into account the nesting,
and this can cause two time extend deltas to happen moving the time stamp
much further ahead than the current time. This gets all reset when the ring
buffer moves to the next page, but that can cause time to appear to go
backwards.

This was observed in a trace-cmd recording, and since the data is saved in a
file, with trace-cmd report --debug, it was possible to see that this indeed
did happen!

  bash-52501   110d... 81778.908247: sched_switch:         bash:52501 [120] S ==> swapper/110:0 [120] [12770284:0x2e8:64]
  <idle>-0     110d... 81778.908757: sched_switch:         swapper/110:0 [120] R ==> bash:52501 [120] [509947:0x32c:64]
 TIME EXTEND: delta:306454770 length:0
  bash-52501   110.... 81779.215212: sched_swap_numa:      src_pid=52501 src_tgid=52388 src_ngid=52501 src_cpu=110 src_nid=2 dst_pid=52509 dst_tgid=52388 dst_ngid=52501 dst_cpu=49 dst_nid=1 [0:0x378:48]
 TIME EXTEND: delta:306458165 length:0
  bash-52501   110dNh. 81779.521670: sched_wakeup:         migration/110:565 [0] success=1 CPU:110 [0:0x3b4:40]

and at the next page, caused the time to go backwards:

  bash-52504   110d... 81779.685411: sched_switch:         bash:52504 [120] S ==> swapper/110:0 [120] [8347057:0xfb4:64]
CPU:110 [SUBBUFFER START] [81779379165886:0x1320000]
  <idle>-0     110dN.. 81779.379166: sched_wakeup:         bash:52504 [120] success=1 CPU:110 [0:0x10:40]
  <idle>-0     110d... 81779.379167: sched_switch:         swapper/110:0 [120] R ==> bash:52504 [120] [1168:0x3c:64]

Link: https://lkml.kernel.org/r/20200622151815.345d1bf5@oasis.local.home

Cc: Ingo Molnar <mingo@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Tom Zanussi <zanussi@kernel.org>
Cc: stable@vger.kernel.org
Fixes: dc4e2801d400b ("ring-buffer: Redefine the unimplemented RINGBUF_TYPE_TIME_STAMP")
Reported-by: Julia Lawall <julia.lawall@inria.fr>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ring_buffer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 805aef83b5cf5..564d22691dd73 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2333,7 +2333,7 @@ rb_update_event(struct ring_buffer_per_cpu *cpu_buffer,
 	if (unlikely(info->add_timestamp)) {
 		bool abs = ring_buffer_time_stamp_abs(cpu_buffer->buffer);
 
-		event = rb_add_time_stamp(event, info->delta, abs);
+		event = rb_add_time_stamp(event, abs ? info->delta : delta, abs);
 		length -= RB_LEN_TIME_EXTEND;
 		delta = 0;
 	}
-- 
2.25.1

