Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D213846FA0E
	for <lists+stable@lfdr.de>; Fri, 10 Dec 2021 06:10:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbhLJFNt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Dec 2021 00:13:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbhLJFNt (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Dec 2021 00:13:49 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A73BC061746;
        Thu,  9 Dec 2021 21:10:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C9CDDCE286A;
        Fri, 10 Dec 2021 05:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BE98C00446;
        Fri, 10 Dec 2021 05:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639113009;
        bh=IgjHdU+h7nd8/berFuQhpL+cs2oDMn2YcL/bPfyzWok=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=B2TG9kmab4DZlJ2MF5L2WKYdVF6RM8bfEBOCg4YxOB+r7JrxOFLz7G7vAZ0pI70SN
         hptxu+I94Vh3XAYd08epfaMm/Ejbhc+2kKaIBVQi4VMjTfc2o7hP15rVk71TWuFY30
         XLjVWnWbmlHUn5PKy8TdevkO3dQYdZYBGIKp9F4CTRZtAJ09RD7OQWqbto0yKmW3uy
         2orNoe83QdM/VEcf1mgvQpSkFobI6OdXJQ3oqKx9ViHthY5pjMIANAxmsOfb+6drgz
         OqkF85itWlEy8hRgr7O2hZek94RC3ymseFyzBSGrG603Zw9bCCQ3Ef2HLuLqGGXeD5
         H6xKPdc8M3Fjw==
Date:   Thu, 9 Dec 2021 21:10:07 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Benjamin LaHaise <bcrl@kvack.org>, linux-aio@kvack.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ramji Jiyani <ramjiyani@google.com>,
        Christoph Hellwig <hch@lst.de>,
        Oleg Nesterov <oleg@redhat.com>,
        Martijn Coenen <maco@android.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH v3 0/5] aio: fix use-after-free and missing wakeups
Message-ID: <YbLhL8y/TR5H0MLe@sol.localdomain>
References: <20211209010455.42744-1-ebiggers@kernel.org>
 <CAHk-=wjkXez+ugCbF3YpODQQS-g=-4poCwXaisLW4p2ZN_=hxw@mail.gmail.com>
 <4a472e72-d527-db79-d46e-efa9d4cad5bb@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4a472e72-d527-db79-d46e-efa9d4cad5bb@kernel.dk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 09, 2021 at 02:46:45PM -0700, Jens Axboe wrote:
> On 12/9/21 11:00 AM, Linus Torvalds wrote:
> > On Wed, Dec 8, 2021 at 5:06 PM Eric Biggers <ebiggers@kernel.org> wrote:
> >>
> >> Careful review is appreciated; the aio poll code is very hard to work
> >> with, and it doesn't appear to have many tests.  I've verified that it
> >> passes the libaio test suite, which provides some coverage of poll.
> >>
> >> Note, it looks like io_uring has the same bugs as aio poll.  I haven't
> >> tried to fix io_uring.
> > 
> > I'm hoping Jens is looking at the io_ring case, but I'm also assuming
> > that I'll just get a pull request for this at some point.
> 
> Yes, when I saw this original posting I did discuss it with Pavel as
> well, and we agree that the same issue exists there. Which isn't too
> surprising, as that's where the io_uring poll code from originally.
> 
> Eric, do you have a test case for this? aio is fine, we can convert it
> to io_uring as well. Would be nice for both verifying the fix, but also
> to carry in the io_uring regression tests for the future.

Well, the use-after-free bug is pretty hard to test for.  It only affects
polling a binder fd or signalfd, so one of those has to be used.  Also, I
haven't found a way to detect it other than the use-after-free itself, so
effectively a kernel with KASAN enabled is needed.  But KASAN doesn't work with
signalfd because the signalfd waitqueues are in an SLAB_TYPESAFE_BY_RCU slab, so
binder is the only way to detect it without working around SLAB_TYPESAFE_BY_RCU,
or patching the kernel to add log messages.  Also, aio supports inline
completion which avoids the bug, so that needs to be worked around.

So the best I can do is provide a program that's pretty specific to aio, which
causes KASAN to report a use-after-free if the kernel has CONFIG_KASAN and
CONFIG_ANDROID_BINDER_IPC enabled.  Note, "normal" Linux distros don't have
either option enabled.  I'm not sure that would be useful for you.

If you're also asking about the other bug (missed wakeups), i.e. the one that
patch 4 in this series fixes, in theory that would be detectable without those
dependencies.  It's still a race condition that depends on kernel implementation
details, so it will be hard to test for too.  But I might have a go at writing a
test for it anyway.

- Eric
