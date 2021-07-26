Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 692EB3D6236
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:16:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232842AbhGZPfI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:35:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:51044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235255AbhGZPeH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:34:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 88E58604AC;
        Mon, 26 Jul 2021 16:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627316075;
        bh=+fFt4JsLeQNfMSkHX0CdEAWddMq+P3LrEnqNfBlo64o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GmclFV0biZcvQHctLIf5j0b7n7jIBBzZh7BlsCN24hxV1bvi5b8MLbM5Oh5W8HWkV
         IN6daXZRGWF7Aftpz53lFBpJRLhn2lY7hMQaK5APGKkI492c9U/itJOCQG7w2aSBsp
         iaABo6lqB+1sHap2Lt/LtELaSW5zPTkXoySjQysw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Metzmacher <metze@samba.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 5.13 177/223] tracepoints: Update static_call before tp_funcs when adding a tracepoint
Date:   Mon, 26 Jul 2021 17:39:29 +0200
Message-Id: <20210726153851.990838783@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt (VMware) <rostedt@goodmis.org>

commit 352384d5c84ebe40fa77098cc234fe173247d8ef upstream.

Because of the significant overhead that retpolines pose on indirect
calls, the tracepoint code was updated to use the new "static_calls" that
can modify the running code to directly call a function instead of using
an indirect caller, and this function can be changed at runtime.

In the tracepoint code that calls all the registered callbacks that are
attached to a tracepoint, the following is done:

	it_func_ptr = rcu_dereference_raw((&__tracepoint_##name)->funcs);
	if (it_func_ptr) {
		__data = (it_func_ptr)->data;
		static_call(tp_func_##name)(__data, args);
	}

If there's just a single callback, the static_call is updated to just call
that callback directly. Once another handler is added, then the static
caller is updated to call the iterator, that simply loops over all the
funcs in the array and calls each of the callbacks like the old method
using indirect calling.

The issue was discovered with a race between updating the funcs array and
updating the static_call. The funcs array was updated first and then the
static_call was updated. This is not an issue as long as the first element
in the old array is the same as the first element in the new array. But
that assumption is incorrect, because callbacks also have a priority
field, and if there's a callback added that has a higher priority than the
callback on the old array, then it will become the first callback in the
new array. This means that it is possible to call the old callback with
the new callback data element, which can cause a kernel panic.

	static_call = callback1()
	funcs[] = {callback1,data1};
	callback2 has higher priority than callback1

	CPU 1				CPU 2
	-----				-----

   new_funcs = {callback2,data2},
               {callback1,data1}

   rcu_assign_pointer(tp->funcs, new_funcs);

  /*
   * Now tp->funcs has the new array
   * but the static_call still calls callback1
   */

				it_func_ptr = tp->funcs [ new_funcs ]
				data = it_func_ptr->data [ data2 ]
				static_call(callback1, data);

				/* Now callback1 is called with
				 * callback2's data */

				[ KERNEL PANIC ]

   update_static_call(iterator);

To prevent this from happening, always switch the static_call to the
iterator before assigning the tp->funcs to the new array. The iterator will
always properly match the callback with its data.

To trigger this bug:

  In one terminal:

    while :; do hackbench 50; done

  In another terminal

    echo 1 > /sys/kernel/tracing/events/sched/sched_waking/enable
    while :; do
        echo 1 > /sys/kernel/tracing/set_event_pid;
        sleep 0.5
        echo 0 > /sys/kernel/tracing/set_event_pid;
        sleep 0.5
   done

And it doesn't take long to crash. This is because the set_event_pid adds
a callback to the sched_waking tracepoint with a high priority, which will
be called before the sched_waking trace event callback is called.

Note, the removal to a single callback updates the array first, before
changing the static_call to single callback, which is the proper order as
the first element in the array is the same as what the static_call is
being changed to.

Link: https://lore.kernel.org/io-uring/4ebea8f0-58c9-e571-fd30-0ce4f6f09c70@samba.org/

Cc: stable@vger.kernel.org
Fixes: d25e37d89dd2f ("tracepoint: Optimize using static_call()")
Reported-by: Stefan Metzmacher <metze@samba.org>
tested-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/tracepoint.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -299,8 +299,8 @@ static int tracepoint_add_func(struct tr
 	 * a pointer to it.  This array is referenced by __DO_TRACE from
 	 * include/linux/tracepoint.h using rcu_dereference_sched().
 	 */
-	rcu_assign_pointer(tp->funcs, tp_funcs);
 	tracepoint_update_call(tp, tp_funcs, false);
+	rcu_assign_pointer(tp->funcs, tp_funcs);
 	static_key_enable(&tp->key);
 
 	release_probes(old);


