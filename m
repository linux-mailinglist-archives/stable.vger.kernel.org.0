Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58A6037B071
	for <lists+stable@lfdr.de>; Tue, 11 May 2021 23:04:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229917AbhEKVFN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 May 2021 17:05:13 -0400
Received: from mx2.suse.de ([195.135.220.15]:50672 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229637AbhEKVFM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 11 May 2021 17:05:12 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id B63A8AEE7;
        Tue, 11 May 2021 21:04:04 +0000 (UTC)
MIME-Version: 1.0
Date:   Tue, 11 May 2021 14:04:04 -0700
From:   Davidlohr Bueso <dbueso@suse.de>
To:     akpm@linux-foundation.org
Cc:     christian.brauner@ubuntu.com, ebiederm@xmission.com,
        manfred@colorfullife.com, matthias.vonfaber@aox-tech.de,
        mm-commits@vger.kernel.org, oleg@redhat.com,
        stable@vger.kernel.org, varad.gautam@suse.com
Subject: Re: +
 ipc-mqueue-msg-sem-avoid-relying-on-a-stack-reference-past-its-expiry.patch
 added to -mm tree
In-Reply-To: <20210511014124.mT4-_WhMQ%akpm@linux-foundation.org>
References: <20210511014124.mT4-_WhMQ%akpm@linux-foundation.org>
User-Agent: Roundcube Webmail
Message-ID: <25914fcd8bd2586a6b12e2847d5aa7dc@suse.de>
X-Sender: dbueso@suse.de
Organization: SUSE Labs
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021-05-10 18:41, akpm@linux-foundation.org wrote:
> The patch titled
>      Subject: ipc/mqueue, msg, sem: Avoid relying on a stack reference
> past its expiry
> has been added to the -mm tree.  Its filename is
>      
> ipc-mqueue-msg-sem-avoid-relying-on-a-stack-reference-past-its-expiry.patch
> 
> This patch should soon appear at
> 
> https://ozlabs.org/~akpm/mmots/broken-out/ipc-mqueue-msg-sem-avoid-relying-on-a-stack-reference-past-its-expiry.patch
> and later at
> 
> https://ozlabs.org/~akpm/mmotm/broken-out/ipc-mqueue-msg-sem-avoid-relying-on-a-stack-reference-past-its-expiry.patch
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/process/submit-checklist.rst when
> testing your code ***
> 
> The -mm tree is included into linux-next and is updated
> there every 3-4 working days
> 
> ------------------------------------------------------
> From: Varad Gautam <varad.gautam@suse.com>
> Subject: ipc/mqueue, msg, sem: Avoid relying on a stack reference past
> its expiry
> 
> do_mq_timedreceive calls wq_sleep with a stack local address.  The 
> sender
> (do_mq_timedsend) uses this address to later call pipelined_send.
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
> 1. do_mq_timedreceive calls wq_sleep with the address of `struct
>    ext_wait_queue` on function stack (aliased as `ewq_addr` here) - it
>    holds a valid `struct ext_wait_queue *` as long as the stack has not
>    been overwritten.
> 
> 2. `ewq_addr` gets added to info->e_wait_q[RECV].list in wq_add, and
>    do_mq_timedsend receives it via wq_get_first_waiter(info, RECV) to 
> call
>    __pipelined_op.
> 
> 3. Sender calls __pipelined_op::smp_store_release(&this->state,
>    STATE_READY).  Here is where the race window begins.  (`this` is
>    `ewq_addr`.)
> 
> 4. If the receiver wakes up now in do_mq_timedreceive::wq_sleep, it
>    will see `state == STATE_READY` and break.
> 
> 5. do_mq_timedreceive returns, and `ewq_addr` is no longer guaranteed
>    to be a `struct ext_wait_queue *` since it was on 
> do_mq_timedreceive's
>    stack.  (Although the address may not get overwritten until another
>    function happens to touch it, which means it can persist around for 
> an
>    indefinite time.)
> 
> 6. do_mq_timedsend::__pipelined_op() still believes `ewq_addr` is a
>    `struct ext_wait_queue *`, and uses it to find a task_struct to pass 
> to
>    the wake_q_add_safe call.  In the lucky case where nothing has
>    overwritten `ewq_addr` yet, `ewq_addr->task` is the right 
> task_struct.
>    In the unlucky case, __pipelined_op::wake_q_add_safe gets handed a
>    bogus address as the receiver's task_struct causing the crash.
> 
> do_mq_timedsend::__pipelined_op() should not dereference `this` after
> setting STATE_READY, as the receiver counterpart is now free to return.
> Change __pipelined_op to call wake_q_add_safe on the receiver's
> task_struct returned by get_task_struct, instead of dereferencing 
> `this`
> which sits on the receiver's stack.
> 
> As Manfred pointed out, the race potentially also exists in
> ipc/msg.c::expunge_all and ipc/sem.c::wake_up_sem_queue_prepare.  Fix
> those in the same way.
> 
> Link: 
> https://lkml.kernel.org/r/20210510102950.12551-1-varad.gautam@suse.com
> Fixes: c5b2cbdbdac563 ("ipc/mqueue.c: update/document memory barriers")
> Fixes: 8116b54e7e23ef ("ipc/sem.c: document and update memory 
> barriers")
> Fixes: 0d97a82ba830d8 ("ipc/msg.c: update and document memory 
> barriers")
> Signed-off-by: Varad Gautam <varad.gautam@suse.com>
> Reported-by: Matthias von Faber <matthias.vonfaber@aox-tech.de>
> Cc: Christian Brauner <christian.brauner@ubuntu.com>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: "Eric W. Biederman" <ebiederm@xmission.com>
> Cc: Manfred Spraul <manfred@colorfullife.com>
> Cc: Davidlohr Bueso <dbueso@suse.de>
> Cc: Manfred Spraul <manfred@colorfullife.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Acked-by: Davidlohr Bueso <dbueso@suse.de>
