Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E62146F340
	for <lists+stable@lfdr.de>; Thu,  9 Dec 2021 19:37:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229448AbhLISlG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Dec 2021 13:41:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbhLISlG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Dec 2021 13:41:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 780CCC061746;
        Thu,  9 Dec 2021 10:37:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3C233B82607;
        Thu,  9 Dec 2021 18:37:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A19FEC004DD;
        Thu,  9 Dec 2021 18:37:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639075050;
        bh=2UNkZfOZO/hps+lR5b+uLNIBRoxpEFlXNCYdJtGiOuk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=P5DtsLtPtfF8V/gONbTf4QcOIHPkA2msw7KfYTRQ+d0EObGrZmh9dp1F7brcT+nR2
         3xc7ioHgkwErS8T4poiEAduDKrEjvfSdkNFBVbdyQjwKgzVJTWeHMv/ypqzc7VBGyQ
         VbZGZw/KQlmaNNbGOz7I/ufp5GjL+LEuF4VjbUKeyM7oyAQqAvQB1wRivOeCIEHV4F
         XC/rAAjv0K2Cqvh9CDHdqpQtADBZLcZy9Cur9Vtu0MuVUSn3PZxEhu1UGqxxkCi0Io
         GAazQLIxVDUWF9xr/Ajdeh5hd7+a5Q/CuMa9pp7rkRyh64TZI3NQgypaPbfdy6c+PB
         uyJ+8eBqTC7cg==
Date:   Thu, 9 Dec 2021 10:37:28 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Benjamin LaHaise <bcrl@kvack.org>, linux-aio@kvack.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ramji Jiyani <ramjiyani@google.com>,
        Christoph Hellwig <hch@lst.de>,
        Oleg Nesterov <oleg@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Martijn Coenen <maco@android.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH v3 0/5] aio: fix use-after-free and missing wakeups
Message-ID: <YbJM6H2wOisBY6gU@sol.localdomain>
References: <20211209010455.42744-1-ebiggers@kernel.org>
 <CAHk-=wjkXez+ugCbF3YpODQQS-g=-4poCwXaisLW4p2ZN_=hxw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wjkXez+ugCbF3YpODQQS-g=-4poCwXaisLW4p2ZN_=hxw@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 09, 2021 at 10:00:50AM -0800, Linus Torvalds wrote:
> On Wed, Dec 8, 2021 at 5:06 PM Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > Careful review is appreciated; the aio poll code is very hard to work
> > with, and it doesn't appear to have many tests.  I've verified that it
> > passes the libaio test suite, which provides some coverage of poll.
> >
> > Note, it looks like io_uring has the same bugs as aio poll.  I haven't
> > tried to fix io_uring.
> 
> I'm hoping Jens is looking at the io_ring case, but I'm also assuming
> that I'll just get a pull request for this at some point.
> 
> It looks sane to me - my only internal cursing has been about epoll
> and aio in general, not about these patches in particular.

I was hoping that Al would review and apply these, given that he's listed as the
maintainer for this file, and he's worked on this code before.  I was also
hoping for review from Christoph, since he added IOCB_CMD_POLL originally.  But
yes, if I don't hear anything I'll just send you a pull request.  I might
include https://lore.kernel.org/r/20210913111928.98-1-xieyongji@bytedance.com
too, since it's an obviously correct aio fix which has been ignored for months.

- Eric
