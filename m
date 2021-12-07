Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2325446B8B9
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 11:21:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233416AbhLGKZM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Dec 2021 05:25:12 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59722 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232748AbhLGKZM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Dec 2021 05:25:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 47E75B81742;
        Tue,  7 Dec 2021 10:21:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9126DC341C3;
        Tue,  7 Dec 2021 10:21:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638872499;
        bh=B7PoJNQcRgmqnokMlCXwji2pqiavAd+MPxhxPnHjEOg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GJiyzjHRo7qjSpQIuFaIuisc45W3GLm6WDc149fd25vGipRUocuBzdYZeXF9+DMSq
         lalxiV75G1H0ulTdSRxIQsc/r+flLV7JaVKpuAyQbZeKxY1eyFxzVy5J1CQIyEGhfV
         nbBNJvgrn3SVpRnipK/+yqtGXkCHSUTULGyq2quXgYzsIXIxqUzCE/KBSxnAFqhkbo
         rxtUjiIT8KVz434DLIxKxwTFJTZ8INaaEZoSY0V3+1kLgELrVpeLrh7DjrSIBVK3SE
         8cXgJrRr0chqhwiUFEcaSZc5DCClGeApzf8Zz9x6f2Yr3guWWs/CiSu/4x6IRDO6QV
         oQ15j86JHLkOw==
Date:   Tue, 7 Dec 2021 02:21:38 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Benjamin LaHaise <bcrl@kvack.org>, linux-aio@kvack.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ramji Jiyani <ramjiyani@google.com>,
        Christoph Hellwig <hch@lst.de>,
        Oleg Nesterov <oleg@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH 2/2] aio: fix use-after-free due to missing POLLFREE
 handling
Message-ID: <Ya81svYkRLvRCfL+@sol.localdomain>
References: <20211204002301.116139-1-ebiggers@kernel.org>
 <20211204002301.116139-3-ebiggers@kernel.org>
 <CAHk-=wgJ+6qgbB+WCDosxOgDp34ybncUwPJ5Evo8gcXptfzF+Q@mail.gmail.com>
 <Ya5qWLLv3i4szS4N@gmail.com>
 <CAHk-=wgvt7PH+AU_29H95tJQZ9FnhS8vVmymbhpZ6NZ7yaAigw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHk-=wgvt7PH+AU_29H95tJQZ9FnhS8vVmymbhpZ6NZ7yaAigw@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 06, 2021 at 01:48:04PM -0800, Linus Torvalds wrote:
> On Mon, Dec 6, 2021 at 11:54 AM Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > It could be fixed by converting signalfd and binder to use something like this,
> > right?
> >
> >         #define wake_up_pollfree(x)  \
> >                __wake_up(x, TASK_NORMAL, 0, poll_to_key(EPOLLHUP | POLLFREE))
> 
> Yeah, that looks better to me.
> 
> That said, maybe it would be even better to then make it more explicit
> about what it does, and not make it look like just another wakeup with
> an odd parameter.
> 
> IOW, maybe that "pollfree()" function itself could very much do the
> waitqueue entry removal on each entry using list_del_init(), and not
> expect the wakeup code for the entry to do so.
> 
> I think that kind of explicit "this removes all entries from the wait
> list head" is better than "let's do a wakeup and expect all entries to
> magically implicitly remove themselves".
> 
> After all, that "implicitly remove themselves" was what didn't happen,
> and caused the bug in the first place.
> 
> And all the normal cases, that don't care about POLLFREE at all,
> because their waitqueues don't go away from under them, wouldn't care,
> because "list_del_init()" still  leaves a valid self-pointing list in
> place, so if they do list_del() afterwards, nothing happens.
> 
> I dunno. But yes, that wake_up_pollfree() of yours certainly looks
> better than what we have now.

In v2 (https://lore.kernel.org/r/20211207095726.169766-1-ebiggers@kernel.org/),
I did end up making wake_up_pollfree() into a function, which calls __wake_up()
and also checks that the queue became empty.

However, I didn't make wake_up_pollfree() remove the queue entries itself.  I
don't think that would be better, given that the purpose of POLLFREE is to
provide a notification that the queue is going away, not simply to remove the
queue entries.  In particular, we might want to cancel the poll request(s);
that's what aio poll does.  Also, we need to synchronize with other places where
the waitqueue is accessed, e.g. to remove an entry which requires taking the
waitqueue lock (see either aio poll or epoll).

> > As for eliminating POLLFREE entirely, that would require that the waitqueue
> > heads be moved to a location which has a longer lifetime.
> 
> Yeah, the problem with aio and epoll is exactly that they end up using
> waitqueue heads without knowing what they are.
> 
> I'm not at all convinced that there aren't other situations where the
> thing the waitqueue head is embedded might not have other lifetimes.
> 
> The *common* situation is obviously that it's associated with a file,
> and the file pointer ends up holding the reference to whatever device
> or something (global list in a loadable module, or whatever) it is.
> 
> Hmm. The poll_wait() callback function actually does get the 'struct
> file *' that the wait is associated with. I wonder if epoll queueing
> could actually increment the file ref when it creates its own wait
> entry, and release it at ep_remove_wait_queue()?
> 
> Maybe epoll could avoid having to remove entries entirely that way -
> simply by virtue of having a ref to the files - and remove the need
> for having the ->whead pointer entirely (and remove the need for
> POLLFREE handling)?

Well, the documented user-visible behavior of epoll is that when a file is
closed, it is automatically removed from all epoll instances.  That precludes
epoll instances from holding references to the files which they are polling.

And the reason that POLLFREE needs to exist is that holding a file reference
isn't enough anyway, since in the case of signalfd and binder the waitqueue may
have a shorter lifetime.  If the file reference was enough, then aio poll
wouldn't need to handle POLLFREE.

> 
> And maybe the signalfd case can do the same - instead of expecting
> exit() to clean up the list when sighand->count goes to zero, maybe
> the signalfd filp can just hold a ref to that 'struct sighand_struct',
> and it gets free'd whenever there are no signalfd users left?
> 
> That would involve making signalfd_ctx actually tied to one particular
> 'struct signal', but that might be the right thing to do regardless
> (instead of making it always act on 'current' like it does now).
> 
> So maybe with some re-organization, we could get rid of the need for
> POLLFREE entirely.. Anybody?
> 
> But your patches are certainly simpler in that they just fix the status quo.

That would be really nice, but unfortunately the current behavior is documented
in signalfd(2), for example:

"""
   fork(2) semantics
       After  a  fork(2),  the  child inherits a copy of the signalfd file de‐
       scriptor.  A read(2) from the file descriptor in the child will  return
       information about signals queued to the child.
"""

With your proposed change to signalfd, the child would receive its parent's
signals via the signalfd, rather than its own signals.

It's maybe how signalfd should have worked originally.  I don't know whether it
is actually safe to change or not, but the fact that the current behavior is
specifically documented in the man page isn't too promising.

Also, changing signalfd by itself wouldn't allow removal of POLLFREE; binder
would have to be changed too.  I'm not a binder expert, but fixing binder
doesn't look super promising.  It looks pretty intentional that binder_poll()
operates on per-thread state, while the binder file description itself is a
per-process thing.

- Eric
