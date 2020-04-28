Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2C731BC791
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728688AbgD1SKb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:10:31 -0400
Received: from mx2.suse.de ([195.135.220.15]:50714 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728672AbgD1SKb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:10:31 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 1368FAED8;
        Tue, 28 Apr 2020 18:10:28 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 28 Apr 2020 20:10:28 +0200
From:   Roman Penyaev <rpenyaev@suse.de>
To:     Jason Baron <jbaron@akamai.com>
Cc:     Khazhismel Kumykov <khazhy@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Heiher <r@hev.cc>,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] eventpoll: fix missing wakeup for ovflist in
 ep_poll_callback
In-Reply-To: <a2f22c3c-c25a-4bda-8339-a7bdaf17849e@akamai.com>
References: <20200424025057.118641-1-khazhy@google.com>
 <20200424190039.192373-1-khazhy@google.com>
 <66f26e74-6c7b-28c2-8b3f-faf8ea5229d4@akamai.com>
 <CACGdZYLD9ZqJNVktHUVe6N4t28VKy-Z76ZcCdsAOJHZRXaYGSA@mail.gmail.com>
 <a2f22c3c-c25a-4bda-8339-a7bdaf17849e@akamai.com>
Message-ID: <c365a245574d4a4ed8a922018bcf4f45@suse.de>
X-Sender: rpenyaev@suse.de
User-Agent: Roundcube Webmail
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020-04-27 22:38, Jason Baron wrote:
> On 4/25/20 4:59 PM, Khazhismel Kumykov wrote:
>> On Sat, Apr 25, 2020 at 9:17 AM Jason Baron <jbaron@akamai.com> wrote:
>>> 
>>> 
>>> 
>>> On 4/24/20 3:00 PM, Khazhismel Kumykov wrote:
>>>> In the event that we add to ovflist, before 339ddb53d373 we would be
>>>> woken up by ep_scan_ready_list, and did no wakeup in 
>>>> ep_poll_callback.
>>>> With that wakeup removed, if we add to ovflist here, we may never 
>>>> wake
>>>> up. Rather than adding back the ep_scan_ready_list wakeup - which 
>>>> was
>>>> resulting in unnecessary wakeups, trigger a wake-up in 
>>>> ep_poll_callback.
>>> 
>>> I'm just curious which 'wakeup' we are talking about here? There is:
>>> wake_up(&ep->wq) for the 'ep' and then there is the nested one via:
>>> ep_poll_safewake(ep, epi). It seems to me that its only about the 
>>> later
>>> one being missing not both? Is your workload using nested epoll?
>>> 
>>> If so, it might make sense to just do the later, since the point of
>>> the original patch was to minimize unnecessary wakeups.
>> 
>> The missing wake-ups were when we added to ovflist instead of rdllist.
>> Both are "the ready list" together - so I'd think we'd want the same
>> wakeups regardless of which specific list we added to.
>> ep_poll_callback isn't nested specific?
>> 
> 
> So I was thinking that ep_poll() would see these events on the
> ovflist without an explicit wakeup, b/c the overflow list being active
> implies that the ep_poll() path would add them to the rdllist in
> ep_scan_read_list(). Thus, it will see the events either in the
> current ep_poll() context or via a subsequent syscall to epoll_wait().
> 
> However, there are other paths that can call ep_scan_ready_list() thus
> I agree with you that both wakeups here are necessary.
> 
> I do think are are still (smaller) potential races in 
> ep_scan_ready_list()
> where we have:
> 
>         write_lock_irq(&ep->lock);
>         list_splice_init(&ep->rdllist, &txlist);
>         WRITE_ONCE(ep->ovflist, NULL);
>         write_unlock_irq(&ep->lock);
> 
> And in the ep_poll path we have:
> 
> static inline int ep_events_available(struct eventpoll *ep)
> {
>         return !list_empty_careful(&ep->rdllist) ||
>                 READ_ONCE(ep->ovflist) != EP_UNACTIVE_PTR;
> }
> 
> 
> Seems to me that first bit needs to be the following, since
> ep_events_available() is now checked in a lockless way:
> 
> 
>         write_lock_irq(&ep->lock);
> 	WRITE_ONCE(ep->ovflist, NULL);
> 	smp_wmb();
>         list_splice_init(&ep->rdllist, &txlist);
>         write_unlock_irq(&ep->lock);


Hi Jason,

For the first chunk you refer the order seems irrelevant.
Either you see something not empty, you go take the lock
and then check lists under the lock, either you see all
lists are empty.

> 
> And also this bit:
> 
>         WRITE_ONCE(ep->ovflist, EP_UNACTIVE_PTR);
> 
>         /*
>          * Quickly re-inject items left on "txlist".
>          */
>         list_splice(&txlist, &ep->rdllist);
> 
> Should I think better be reversed as well to:
> 
> list_splice(&txlist, &ep->rdllist);
> smp_wmb();
> WRITE_ONCE(ep->ovflist, EP_UNACTIVE_PTR);

But this one is much more interesting.  I understand what you
are trying to achieve: we can't leave both lists empty for the
short period of time, if there is something left the caller
of ep_events_available() should be able to see one of the lists
is not empty, otherwise it can be too late.

But the problem you've spotted is much worse. Some remains
can be in the txlist (this can happen if caller of epoll_wait
wants to harvest only 1 event, but there are more in the ->rdlist).
And we again get the lost wakeup.

Problem is reproduced by the test below.  The idea is simple:
we have 10 threads and 10 event fds. Each thread can harvest
only 1 event. 1 producer fires all 10 events at once and waits
that all 10 events will be observed by 10 threads.

The fix is basically a revert of 339ddb53d373 with 1 major
exception: we do wakeups from ep_scan_ready_list() but
if txlist is not empty && if ep_scan_ready_list() is called
from the routine, which sends events, not reads it
(thus we protect ourselves from repeated wake ups)

I will send the code a bit later.

--
Roman

---- test -------

enum {
	EPOLL60_EVENTS_NR = 10,
};

struct epoll60_ctx {
	volatile int stopped;
	int ready;
	int waiters;
	int epfd;
	int evfd[EPOLL60_EVENTS_NR];
};

static inline int count_waiters(struct epoll60_ctx *ctx)
{
	return __atomic_load_n(&ctx->waiters, __ATOMIC_ACQUIRE);
}

static void *epoll60_wait_thread(void *ctx_)
{
	struct epoll60_ctx *ctx = ctx_;
	struct epoll_event e;
	uint64_t v;
	int ret;

	while (!ctx->stopped) {
		/* Mark we are ready */
		__atomic_fetch_add(&ctx->ready, 1, __ATOMIC_ACQUIRE);

		/* Start when all are ready */
		while (__atomic_load_n(&ctx->ready, __ATOMIC_ACQUIRE) &&
		       !ctx->stopped);

		/* Account this waiter */
		__atomic_fetch_add(&ctx->waiters, 1, __ATOMIC_ACQUIRE);
again_wait:
		ret = epoll_wait(ctx->epfd, &e, 1, 1000);
		if (ret != 1) {
			/* Should be stopped, otherwise we lost wakeup */
			assert(ctx->stopped);
			return NULL;
		}

		ret = read(e.data.fd, &v, sizeof(v));
		if (ret != sizeof(v)) {
			/* Event was stollen by other thread */
			goto again_wait;
		}
		__atomic_fetch_sub(&ctx->waiters, 1, __ATOMIC_RELEASE);
	}

	return NULL;
}

static inline unsigned long long msecs(void)
{
	struct timespec ts;
	unsigned long long msecs;

	clock_gettime(CLOCK_REALTIME, &ts);
	msecs = ts.tv_sec * 1000ull;
	msecs += ts.tv_nsec / 1000000ull;

	return msecs;
}

TEST(epoll60)
{
	struct epoll60_ctx ctx = { 0 };
	pthread_t waiters[ARRAY_SIZE(ctx.evfd)];
	struct epoll_event e;
	int i, n, ret;

	signal(SIGUSR1, signal_handler);

	ctx.epfd = epoll_create1(0);
	ASSERT_GE(ctx.epfd, 0);

	/* Create event fds */
	for (i = 0; i < ARRAY_SIZE(ctx.evfd); i++) {
		ctx.evfd[i] = eventfd(0, EFD_NONBLOCK);
		ASSERT_GE(ctx.evfd[i], 0);

		e.events = EPOLLIN | EPOLLERR;
		e.data.fd = ctx.evfd[i];
		ASSERT_EQ(epoll_ctl(ctx.epfd, EPOLL_CTL_ADD, ctx.evfd[i], &e), 0);
	}

	/* Create waiter threads */
	for (i = 0; i < ARRAY_SIZE(waiters); i++)
		ASSERT_EQ(pthread_create(&waiters[i], NULL,
					 epoll60_wait_thread, &ctx), 0);

	for (i = 0; i < 300; i++) {
		uint64_t v = 1, ms;

		/* Wait for all to be ready */
		while (__atomic_load_n(&ctx.ready, __ATOMIC_ACQUIRE) !=
		       ARRAY_SIZE(ctx.evfd))
			;

		/* Steady, go */
		__atomic_fetch_sub(&ctx.ready, ARRAY_SIZE(ctx.evfd),
				   __ATOMIC_ACQUIRE);

		/* Wait all have gone to kernel */
		while (count_waiters(&ctx) != ARRAY_SIZE(ctx.evfd))
			;

		/* 1ms should be enough to schedule out */
		usleep(1000);

		/* Quickly signal all handles at once */
		for (n = 0; n < ARRAY_SIZE(ctx.evfd); n++) {
			ret = write(ctx.evfd[n], &v, sizeof(v));
			ASSERT_EQ(ret, sizeof(v));
		}

		/* Busy loop for 1s and wait for all waiters to wake up */
		ms = msecs();
		while (count_waiters(&ctx) && msecs() < ms + 3000)
			;

		ASSERT_EQ(count_waiters(&ctx), 0);
	}
	ctx.stopped = 1;
	/* Stop waiters */
	for (i = 0; i < ARRAY_SIZE(waiters); i++) {
		pthread_kill(waiters[i], SIGUSR1);
		pthread_join(waiters[i], NULL);
	}

	for (i = 0; i < ARRAY_SIZE(waiters); i++)
		close(ctx.evfd[i]);
	close(ctx.epfd);
}


