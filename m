Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9729346A616
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 20:54:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348813AbhLFT5f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 14:57:35 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:55828 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238223AbhLFT5e (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 14:57:34 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 30781CE1808;
        Mon,  6 Dec 2021 19:54:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E40BC341C1;
        Mon,  6 Dec 2021 19:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638820442;
        bh=mSNNrHFW06kVUlsvvOG0PrM6HIBh5L6fNgoeMiBszOY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pyHduUTekqrW8AtMOaAdyVSavHNViK+V6os9x01PUTrpsJFSnqaIRBcfo2HHIZkeV
         Hh6nzljlLROtFXCxVvNHTnyvYjMn0Pg5IwDvZUors9R65fXovIqWNiB2a4r2UhfQ6H
         0kxiZ9p4/DBgE7J4OgXxyK5vZS4d6SJG2fBHsUBQft0mCGD70mLeuoBHQUKlKHhByP
         m2dPhHXShRfF4PH4SrBdbp1qzsyc+4JEFNw9KpQc/1PPedyXw15jdkYll+1bf9yXGu
         4w3Vc63oxEgtwvN9zziCM/nNbW8qEs2gHdQIniVwZbAktn29zzJbchEdGUseSv/b77
         sIMDRSayqC/Fw==
Date:   Mon, 6 Dec 2021 11:54:00 -0800
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
Message-ID: <Ya5qWLLv3i4szS4N@gmail.com>
References: <20211204002301.116139-1-ebiggers@kernel.org>
 <20211204002301.116139-3-ebiggers@kernel.org>
 <CAHk-=wgJ+6qgbB+WCDosxOgDp34ybncUwPJ5Evo8gcXptfzF+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wgJ+6qgbB+WCDosxOgDp34ybncUwPJ5Evo8gcXptfzF+Q@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 06, 2021 at 11:28:13AM -0800, Linus Torvalds wrote:
> On Fri, Dec 3, 2021 at 4:23 PM Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > require another solution.  This solution is for the queue to be cleared
> > before it is freed, using 'wake_up_poll(wq, EPOLLHUP | POLLFREE);'.
> 
> Ugh.
> 
> I hate POLLFREE, and the more I look at this, the more I think it's broken.
> 
> And that
> 
>         wake_up_poll(wq, EPOLLHUP | POLLFREE);
> 
> in particular looks broken - the intent is that it should remove all
> the wait queue entries (because the wait queue head is going away),
> but wake_up_poll() iself actually does
> 
>         __wake_up(x, TASK_NORMAL, 1, poll_to_key(m))
> 
> where that '1' is the number of exclusive entries it will wake up.
> 
> So if there are two exclusive waiters, wake_up_poll() will simply stop
> waking things up after the first one.
> 
> Which defeats the whole POLLFREE thing too.
> 
> Maybe I'm missing something, but POLLFREE really is broken.
> 
> I'd argue that all of epoll() is broken, but I guess we're stuck with it.
> 
> Now, it's very possible that nobody actually uses exclusive waits for
> those wait queues, and my "nr_exclusive" argument is about something
> that isn't actually a bug in reality. But I think it's a sign of
> confusion, and it's just another issue with POLLFREE.
> 
> I really wish we could have some way to not have epoll and aio mess
> with the wait-queue lists and cache the wait queue head pointers that
> they don't own.
> 
> In the meantime, I don't think these patches make things worse, and
> they may fix things. But see above about "nr_exclusive" and how I
> think wait queue entries might end up avoiding POLLFREE handling..
> 
>                   Linus

epoll supports exclusive waits, via the EPOLLEXCLUSIVE flag.  So this looks like
a real problem.

It could be fixed by converting signalfd and binder to use something like this,
right?

	#define wake_up_pollfree(x)  \
	       __wake_up(x, TASK_NORMAL, 0, poll_to_key(EPOLLHUP | POLLFREE))

As for eliminating POLLFREE entirely, that would require that the waitqueue
heads be moved to a location which has a longer lifetime.  I'm not sure if
that's possible.  In the case of signalfd, maybe the waitqueue head could be
moved to the file private data (signalfd_ctx), and then sighand_struct would
contain a list of signalfd_ctx's which are receiving signals directed to that
sighand_struct, rather than the waitqueue head itself.  I'm not sure how well
that would work.  This would probably change user-visible behavior; if a
signalfd is inherited by fork(), the child process would be notified about
signals sent to the parent process, rather than itself as is currently the case.

- Eric
