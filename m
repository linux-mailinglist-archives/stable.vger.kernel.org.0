Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCB439EA7B
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 16:11:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726170AbfH0OLk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 10:11:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57856 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725920AbfH0OLk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 10:11:40 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 63E8118C892F;
        Tue, 27 Aug 2019 14:11:40 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4D9555D712;
        Tue, 27 Aug 2019 14:11:40 +0000 (UTC)
Received: from zmail17.collab.prod.int.phx2.redhat.com (zmail17.collab.prod.int.phx2.redhat.com [10.5.83.19])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 2AFAE18089C8;
        Tue, 27 Aug 2019 14:11:40 +0000 (UTC)
Date:   Tue, 27 Aug 2019 10:11:39 -0400 (EDT)
From:   Jan Stancek <jstancek@redhat.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     peterz@infradead.org, will@kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, Waiman Long <longman@redhat.com>,
        dbueso@suse.de, Ingo Molnar <mingo@kernel.org>,
        Jan Stancek <jstancek@redhat.com>
Message-ID: <396661303.8419298.1566915099958.JavaMail.zimbra@redhat.com>
In-Reply-To: <20190826143114.23471-1-sashal@kernel.org>
References: <20190826143114.23471-1-sashal@kernel.org>
Subject: Re: [PATCH v5.2 1/2] locking/rwsem: Add missing ACQUIRE to
 read_slowpath exit when queue is empty
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.40.204.166, 10.4.195.12]
Thread-Topic: locking/rwsem: Add missing ACQUIRE to read_slowpath exit when queue is empty
Thread-Index: pM7Z1VrNvE4gMqpOiVyEBizAqOeMqQ==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.70]); Tue, 27 Aug 2019 14:11:40 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


----- Original Message -----
> From: Jan Stancek <jstancek@redhat.com>
> 
> [ Upstream commit e1b98fa316648420d0434d9ff5b92ad6609ba6c3 ]
> 
> LTP mtest06 has been observed to occasionally hit "still mapped when
> deleted" and following BUG_ON on arm64.
> 
> The extra mapcount originated from pagefault handler, which handled
> pagefault for vma that has already been detached. vma is detached
> under mmap_sem write lock by detach_vmas_to_be_unmapped(), which
> also invalidates vmacache.
> 
> When the pagefault handler (under mmap_sem read lock) calls
> find_vma(), vmacache_valid() wrongly reports vmacache as valid.
> 
> After rwsem down_read() returns via 'queue empty' path (as of v5.2),
> it does so without an ACQUIRE on sem->count:
> 
>   down_read()
>     __down_read()
>       rwsem_down_read_failed()
>         __rwsem_down_read_failed_common()
>           raw_spin_lock_irq(&sem->wait_lock);
>           if (list_empty(&sem->wait_list)) {
>             if (atomic_long_read(&sem->count) >= 0) {
>               raw_spin_unlock_irq(&sem->wait_lock);
>               return sem;
> 
> The problem can be reproduced by running LTP mtest06 in a loop and
> building the kernel (-j $NCPUS) in parallel. It does reproduces since
> v4.20 on arm64 HPE Apollo 70 (224 CPUs, 256GB RAM, 2 nodes). It
> triggers reliably in about an hour.
> 
> The patched kernel ran fine for 10+ hours.
> 
> Signed-off-by: Jan Stancek <jstancek@redhat.com>
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Reviewed-by: Will Deacon <will@kernel.org>
> Acked-by: Waiman Long <longman@redhat.com>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: dbueso@suse.de
> Fixes: 4b486b535c33 ("locking/rwsem: Exit read lock slowpath if queue empty &
> no writer")
> Link:
> https://lkml.kernel.org/r/50b8914e20d1d62bb2dee42d342836c2c16ebee7.1563438048.git.jstancek@redhat.com
> Signed-off-by: Ingo Molnar <mingo@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
> 
> This is a backport for the v5.2 stable tree. There were multiple reports
> of this issue being hit.
> 
> Given that there were a few changes to the code around this, I'd
> appreciate an ack before pulling it in.

ACK, both look good to me.
I also re-ran reproducer with this series applied on top of 5.2.10, it PASS-ed.

Thanks,
Jan
