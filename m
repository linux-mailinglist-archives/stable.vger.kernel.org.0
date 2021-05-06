Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 815CC375A75
	for <lists+stable@lfdr.de>; Thu,  6 May 2021 20:55:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233770AbhEFS4M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 May 2021 14:56:12 -0400
Received: from mx2.suse.de ([195.135.220.15]:45940 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229622AbhEFS4M (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 6 May 2021 14:56:12 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id E65A8AE4D;
        Thu,  6 May 2021 18:55:11 +0000 (UTC)
MIME-Version: 1.0
Date:   Thu, 06 May 2021 11:55:11 -0700
From:   Davidlohr Bueso <dbueso@suse.de>
To:     Varad Gautam <varad.gautam@suse.com>
Cc:     linux-kernel@vger.kernel.org,
        Matthias von Faber <matthias.vonfaber@aox-tech.de>,
        stable@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Manfred Spraul <manfred@colorfullife.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Serge Hallyn <serge@hallyn.com>,
        James Morris <jamorris@linux.microsoft.com>
Subject: Re: [PATCH v2] ipc/mqueue: Avoid relying on a stack reference past
 its expiry
In-Reply-To: <20210506065621.9292-1-varad.gautam@suse.com>
References: <20210506065621.9292-1-varad.gautam@suse.com>
User-Agent: Roundcube Webmail
Message-ID: <a4584027a60ef6e2d3e6d1006dea9a10@suse.de>
X-Sender: dbueso@suse.de
Organization: SUSE Labs
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021-05-05 23:56, Varad Gautam wrote:
> do_mq_timedreceive calls wq_sleep with a stack local address. The
> sender (do_mq_timedsend) uses this address to later call
> pipelined_send.
> 
> This leads to a very hard to trigger race where a do_mq_timedreceive 
> call
> might return and leave do_mq_timedsend to rely on an invalid address,
> causing the following crash:
> 
> [  240.739977] RIP: 0010:wake_q_add_safe+0x13/0x60
> [  240.739991] Call Trace:
> [  240.739999]  __x64_sys_mq_timedsend+0x2a9/0x490
> [  240.740003]  ? auditd_test_task+0x38/0x40
> [  240.740007]  ? auditd_test_task+0x38/0x40
> [  240.740011]  do_syscall_64+0x80/0x680
> [  240.740017]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [  240.740019] RIP: 0033:0x7f5928e40343
> 
> The race occurs as:
> 
> 1. do_mq_timedreceive calls wq_sleep with the address of
> `struct ext_wait_queue` on function stack (aliased as `ewq_addr` here)
> - it holds a valid `struct ext_wait_queue *` as long as the stack has
> not been overwritten.
> 
> 2. `ewq_addr` gets added to info->e_wait_q[RECV].list in wq_add, and
> do_mq_timedsend receives it via wq_get_first_waiter(info, RECV) to call
> __pipelined_op.
> 
> 3. Sender calls __pipelined_op::smp_store_release(&this->state, 
> STATE_READY).
> Here is where the race window begins. (`this` is `ewq_addr`.)
> 
> 4. If the receiver wakes up now in do_mq_timedreceive::wq_sleep, it
> will see `state == STATE_READY` and break. `ewq_addr` gets removed from
> info->e_wait_q[RECV].list.

So when the blocked task sees the lockless STATE_READY and returns it
won't remove the list entry, instead the waker is in charge of doing so.

> 
> 5. do_mq_timedreceive returns, and `ewq_addr` is no longer guaranteed
> to be a `struct ext_wait_queue *` since it was on do_mq_timedreceive's
> stack. (Although the address may not get overwritten until another
> function happens to touch it, which means it can persist around for an
> indefinite time.)
> 
> 6. do_mq_timedsend::__pipelined_op() still believes `ewq_addr` is a
> `struct ext_wait_queue *`, and uses it to find a task_struct to pass
> to the wake_q_add_safe call. In the lucky case where nothing has
> overwritten `ewq_addr` yet, `ewq_addr->task` is the right task_struct.
> In the unlucky case, __pipelined_op::wake_q_add_safe gets handed a
> bogus address as the receiver's task_struct causing the crash.
> 
> do_mq_timedsend::__pipelined_op() should not dereference `this` after
> setting STATE_READY, as the receiver counterpart is now free to return.
> Change __pipelined_op to call wake_q_add before setting STATE_READY
> which ensures that the receiver's task_struct can still be found via
> `this`.
> 
> Fixes: c5b2cbdbdac563 ("ipc/mqueue.c: update/document memory barriers")
> Signed-off-by: Varad Gautam <varad.gautam@suse.com>
> Reported-by: Matthias von Faber <matthias.vonfaber@aox-tech.de>
> Cc: <stable@vger.kernel.org> # 5.6
> Cc: Christian Brauner <christian.brauner@ubuntu.com>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: "Eric W. Biederman" <ebiederm@xmission.com>
> Cc: Manfred Spraul <manfred@colorfullife.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Davidlohr Bueso <dbueso@suse.de>
> ---
> v2: Call wake_q_add before smp_store_release, instead of using a
>     get_task_struct/wake_q_add_safe combination across
>     smp_store_release. (Davidlohr Bueso)

LGTM, with some additional nits below:

Acked-by: Davidlohr Bueso <dbueso@suse.de>

> + * 2) With wake_q_add(), the receiver task could have returned from 
> the
                                 ^^^^^^
                                 s/receiver/blocked
> + *    syscall and had its stack-allocated waiter overwritten before 
> the
> + *    sender could add it to the wake_q
          ^^^^^
          s/sender/waker

> + * Thread A
> + *				Thread B
> + * WRITE_ONCE(wait.state, STATE_NONE);
> + * schedule_hrtimeout()
> + *				->state = STATE_READY
> + * <timeout returns>

While this comment is fine, for completeness we should document and 
expand
the scope of such races, because it's not only timeouts, but can also 
happen
upon a signal or spurious wakeup. Perhaps replacing (in a separate 
patch):

<timeout returns>

with

<returns: timeout/signal/spurious wakeup>

Thanks,
Davidlohr
