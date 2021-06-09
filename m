Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A68253A1E50
	for <lists+stable@lfdr.de>; Wed,  9 Jun 2021 22:51:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbhFIUxw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Jun 2021 16:53:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:42542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229757AbhFIUxw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Jun 2021 16:53:52 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 616A1613C7;
        Wed,  9 Jun 2021 20:51:56 +0000 (UTC)
Date:   Wed, 9 Jun 2021 16:51:54 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     James Wang <jnwang@linux.alibaba.com>,
        Liangyan <liangyan.peng@linux.alibaba.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Xunlei Pang <xlpang@linux.alibaba.com>,
        yinbinbin@alibabacloud.com, wetp <wetp.zy@linux.alibaba.com>,
        stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] tracing: Correct the length check which causes memory
 corruption
Message-ID: <20210609165154.3eab1749@oasis.local.home>
In-Reply-To: <CAHk-=whKbJkuVmzb0hD3N6q7veprUrSpiBHRxVY=AffWZPtxmg@mail.gmail.com>
References: <20210607125734.1770447-1-liangyan.peng@linux.alibaba.com>
        <71fa2e69-a60b-0795-5fef-31658f89591a@linux.alibaba.com>
        <CAHk-=whKbJkuVmzb0hD3N6q7veprUrSpiBHRxVY=AffWZPtxmg@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 9 Jun 2021 13:08:34 -0700
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> > > --- a/kernel/trace/trace.c
> > > +++ b/kernel/trace/trace.c
> > > @@ -2736,7 +2736,7 @@ trace_event_buffer_lock_reserve(struct trace_buffer **current_rb,
> > >           (entry = this_cpu_read(trace_buffered_event))) {
> > >               /* Try to use the per cpu buffer first */
> > >               val = this_cpu_inc_return(trace_buffered_event_cnt);
> > > -             if ((len < (PAGE_SIZE - sizeof(*entry))) && val == 1) {
> > > +             if ((len < (PAGE_SIZE - sizeof(*entry) - sizeof(entry->array[0]))) && val == 1) {
> > >                       trace_event_setup(entry, type, trace_ctx);
> > >                       entry->array[0] = len;
> > >                       return entry;  
> 
> I have to say that I don't love that code. Not before, and not with the fix.

That's OK, neither do I.

> 
> That "sizeof(*entry)" is clearly wrong, because it doesn't take the
> unsized array into account.

Correct. That's because I forgot that the structure has that empty array :-(

> 
> But adding the sizeof() for a single array entry doesn't make that
> already unreadable and buggy code much more readable.

I wont argue that.

> 
> It would probably be better to use "struct_size(entry, buffer, 1)"
> instead, and I think it would be good to just split things up a bit to
> be more legibe:

I keep forgetting about that struct_size() macro. It would definitely
be an improvement.

> 
>         unsigned long max_len = PAGE_SIZE - struct_size(entry, array, 1);
> 
>         if (val == 1 && len < max_len && val == 1) {
>                 trace_event_setup(entry, type, trace_ctx);
>                 ..
> 
> instead.

Again, no arguments from me.

> 
> However, I have a few questions:
> 
>  - why "len < max_offset" rather than "<="?

Probably because I sided on the error of being off by one with extra
remaining.

> 
>  - why don't we check the length before we even try to reserve that
> percpu buffer with the expensive atomic this_cpu_inc_return()?

because it seldom hits that length (if ever), and the val != 1 is more
likely to be true than the overflow. I thought about doing the len
compare first, but that failing basically only happens on extreme
anomalies (you have to try hard to make the event bigger than a page).
Not to mention, if it is that big, it will fail to record anyway,
because the ring buffer currently only allows events less than a page
in size. The reason this doesn't fail outright when it is that big, is
because there's nothing in the design of the ring buffer that doesn't
let you make the chunks be bigger than a page, and I didn't want to
couple this code with that current requirement. That requirement is
only because the chunks of the ring buffer are currently defined as
PAGE_SIZE and that also means it wont accept anything bigger than a
page.

> 
>  - is the size of that array guaranteed to always be 1? If so, why is
> it unsized? Why is it an array at all?

It's the way the ring buffer event works:

(documented at the top of include/linux/ring_buffer.h)

That structure has a type_len field that is 5 bits (for compaction).

If that is 29, 30, or 31, then it is a special event (padding, time
extend or time stamp respectively). But if it has 1-28 in it, it
represents the size (in 4 byte increments). If the data on the event is
112 bytes (4*28 = 112) or less (which most events are). then the size
of the data load starts right at the array field.

struct ring_buffer_event {
	u32 type_len:5 time_delta:27;
	u32 array[0] <- data load starts here.
};

But if the data load is bigger than 112 bytes, then type_len is zero
and the array[0] holds that length, and the data starts after it:

struct ring_buffer_event {
	u32 type_len:5 time_delta:27;
	u32 array[0] <- holds the length of data
	data[]; < data starts here.
};


> 
>  - clearly the array{} size must not be guaranteed to be 1, but why a
> size of 1 then always sufficient here? Clearly a size of 1 is the
> minimum required since we do that
> 
>         entry->array[0] = len;
> 
>    and thus use one entry, but what is it that makes it ok that it
> really is just one entry?

This is called when filtering is on, and that we are likely to discard
events instead of keeping them. In this case, it is more expensive to
allocate on the ring buffer directly to only discard it from the ring
buffer, as discarding requires several atomic operations and creates a
visible overhead. Since filtering events is suppose to make it faster,
this discard actually slows down the trace.

To counter that, I create a per cpu PAGE_SIZE temp buffer to write the
event to, such that the event from the trace_event code will write to
this instead of directly into the buffer. On the commit of the event,
the filtering takes place to test the fields that were written to, and
if they don't match, then the buffer is simply discarded (no overhead).
If the filter does match, then it will then copy this into the ring
buffer properly.

This was added years after the tracing code was written, and to make it
work, the temp buffer had to simulate a ring_buffer_event. To do so,
the temp buffer wrote zero into the type_len field, and used array[0]
for the length, even if the size of the event is 112 bytes or less.
That's because the logic to read the size only checked that type_len
field to know if it should read the array[] field or not.

Thus, for this temp buffer, the array[0] is always going to hold the
length of the event.

Note, if the len is too big, or an interrupt came in while another
event was using the per cpu temp buffer, it just goes back to using the
ring buffer directly, and discarding if it fails the filter. Yes, it is
slower, but that case doesn't happen often.

> 
> Steven, please excuse the above stupid questions of mine, but that
> code looks really odd.

Not stupid questions at all. It is odd due to how it grew.

But I hope I explained it better.

That said, even though I'm almost done with my tests on this patch, and
was going to send you a pull request later today, I can hold off and
have Liangyan send a v2 using struct_size and with the clean ups you
suggested.

-- Steve

