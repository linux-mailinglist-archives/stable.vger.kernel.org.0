Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 837E26687BD
	for <lists+stable@lfdr.de>; Fri, 13 Jan 2023 00:08:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232390AbjALXIZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 18:08:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230385AbjALXIT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 18:08:19 -0500
X-Greylist: delayed 1999 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 12 Jan 2023 15:08:17 PST
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0752BD91;
        Thu, 12 Jan 2023 15:08:16 -0800 (PST)
Received: by kanga.kvack.org (Postfix, from userid 63042)
        id 798C58E0001; Thu, 12 Jan 2023 17:09:39 -0500 (EST)
Date:   Thu, 12 Jan 2023 17:09:39 -0500
From:   Benjamin LaHaise <bcrl@kvack.org>
To:     Jeff Moyer <jmoyer@redhat.com>
Cc:     Seth Jenkins <sethjenkins@google.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
        linux-kernel@vger.kernel.org, Jann Horn <jannh@google.com>,
        Pavel Emelyanov <xemul@parallels.com>, stable@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] aio: fix mremap after fork null-deref
Message-ID: <20230112220939.GO19133@kvack.org>
References: <20221104212519.538108-1-sethjenkins@google.com> <x49tu0wlv0c.fsf@segfault.boston.devel.redhat.com> <CALxfFW5d05H-nFuDdUDS4xVDKMgkV1vvEBAmw10h3-jMVb-PZw@mail.gmail.com> <x49ilhbl9qd.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49ilhbl9qd.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.4.2.2i
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 12, 2023 at 04:32:42PM -0500, Jeff Moyer wrote:
> The way things stand today, if you setup an io context in a process and
> then fork a child, the child will be unable to use the aio system calls
> to submit and reap I/Os.  This is because the ioctx_table was cleared
> during fork, which means that lookup_ioctx() will not find the io
> context.  However, the child still has access to the ring through the
> memory mapping.  As a result, the child can reap I/O completions
> directly from the ring.  That wasn't always the case.  The aio ring used
> to be a MAP_PRIVATE mapping.  Commit 36bc08cc0170 ("fs/aio: Add support
> to aio ring pages migration") changed it from a private to a shared
> mapping, and I'm not sure why.  (That patch was included in v3.12, so
> it's been this way for quite some time.)

It is necessary to make migration work.  The pages have to be owned by
the backing file and to map the backing file pages into the process
without COW requires the mapping to be marked shared.  If they're COWed,
events can be lost.  Migration is rare and ugly.

> With the patch I proposed (flagging the ring buffer with VM_DONTCOPY),
> the child process would still be unable to submit and reap I/Os via the
> aio system calls.  What changes is that the child process would now be
> unable to reap completions via the shared ring buffer.  In fact, because
> the ring is no longer mapped in the child process, any attempt to access
> that memory would result in a segmentation fault.  However, I would be
> very surprised if the interface was being used in this way.
> 
> > If we're okay with this change though, I think it makes sense.
> 
> My preference is to make the interface consistent.  I think setting
> VM_DONTCOPY on the mapping is the right way forward.  I'd welcome other
> opinions on whether the potential risk is worth it.

VM_DONTCOPY makes sense, but a SEGV is a pretty bad failure mode.  Any
process reaping events in the child after fork() isn't going to be
consistent in behaviour, and is able to see partial completion of an I/O
and other inconsistencies, so they're going to be subtly broken at best.

Unfortunately, we have no way of knowing if this behaviour is exercised
anywhere without changing it and waiting for someone to holler.

		-ben

> Cheers,
> Jeff
> 
> >
> >
> > On Wed, Jan 11, 2023 at 2:37 PM Jeff Moyer <jmoyer@redhat.com> wrote:
> >>
> >> Hi, Seth,
> >>
> >> Seth Jenkins <sethjenkins@google.com> writes:
> >>
> >> > Commit e4a0d3e720e7 ("aio: Make it possible to remap aio ring") introduced
> >> > a null-deref if mremap is called on an old aio mapping after fork as
> >> > mm->ioctx_table will be set to NULL.
> >> >
> >> > Fixes: e4a0d3e720e7 ("aio: Make it possible to remap aio ring")
> >> > Cc: stable@vger.kernel.org
> >> > Signed-off-by: Seth Jenkins <sethjenkins@google.com>
> >> > ---
> >> >  fs/aio.c | 20 +++++++++++---------
> >> >  1 file changed, 11 insertions(+), 9 deletions(-)
> >> >
> >> > diff --git a/fs/aio.c b/fs/aio.c
> >> > index 5b2ff20ad322..74eae7de7323 100644
> >> > --- a/fs/aio.c
> >> > +++ b/fs/aio.c
> >> > @@ -361,16 +361,18 @@ static int aio_ring_mremap(struct vm_area_struct *vma)
> >> >       spin_lock(&mm->ioctx_lock);
> >> >       rcu_read_lock();
> >> >       table = rcu_dereference(mm->ioctx_table);
> >> > -     for (i = 0; i < table->nr; i++) {
> >> > -             struct kioctx *ctx;
> >> > -
> >> > -             ctx = rcu_dereference(table->table[i]);
> >> > -             if (ctx && ctx->aio_ring_file == file) {
> >> > -                     if (!atomic_read(&ctx->dead)) {
> >> > -                             ctx->user_id = ctx->mmap_base = vma->vm_start;
> >> > -                             res = 0;
> >> > +     if (table) {
> >> > +             for (i = 0; i < table->nr; i++) {
> >> > +                     struct kioctx *ctx;
> >> > +
> >> > +                     ctx = rcu_dereference(table->table[i]);
> >> > +                     if (ctx && ctx->aio_ring_file == file) {
> >> > +                             if (!atomic_read(&ctx->dead)) {
> >> > +                                     ctx->user_id = ctx->mmap_base = vma->vm_start;
> >> > +                                     res = 0;
> >> > +                             }
> >> > +                             break;
> >> >                       }
> >> > -                     break;
> >> >               }
> >> >       }
> >>
> >> I wonder if it would be better to not copy the ring mapping on fork.
> >> Something like the below?  I think that would be more in line with
> >> expectations (the ring isn't available in the child process).
> >>
> >> -Jeff
> >>
> >> diff --git a/fs/aio.c b/fs/aio.c
> >> index 562916d85cba..dbf3b0749cb4 100644
> >> --- a/fs/aio.c
> >> +++ b/fs/aio.c
> >> @@ -390,7 +390,7 @@ static const struct vm_operations_struct aio_ring_vm_ops = {
> >>
> >>  static int aio_ring_mmap(struct file *file, struct vm_area_struct *vma)
> >>  {
> >> -       vma->vm_flags |= VM_DONTEXPAND;
> >> +       vma->vm_flags |= VM_DONTEXPAND|VM_DONTCOPY;
> >>         vma->vm_ops = &aio_ring_vm_ops;
> >>         return 0;
> >>  }
> >>
> 
> 

-- 
"Thought is the essence of where you are now."
