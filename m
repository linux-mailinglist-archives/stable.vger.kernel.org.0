Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DB8E4855D4
	for <lists+stable@lfdr.de>; Wed,  5 Jan 2022 16:26:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241466AbiAEP0p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Jan 2022 10:26:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241463AbiAEP0o (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Jan 2022 10:26:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F752C061201;
        Wed,  5 Jan 2022 07:26:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4AE70B81C24;
        Wed,  5 Jan 2022 15:26:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7327C36AE3;
        Wed,  5 Jan 2022 15:26:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641396402;
        bh=/kIO3ov2EIiv4ceQ+gOEo2oanco3kfN0IMJh4EueD58=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=P/mPkB6dJniMR1KJlUohEHTR1scMt4q8AlbzdHIlE8UQnIKyFpWALM2ElUfxVHoQE
         4i+HSVLQtrMPR+WKOTFOuvLZIXW2MY13HT+TlVdTywtVQL4990uT7aH8v1/6KKhJp/
         B2B7gTlG0dB0YZolUl/DG1i9HGTnanDT0YaruoXHLYWXRN5ZXV5YfVOHjHBWDrIaCB
         0lIYQtAwSJNWrLn1ByQ6vWdahhB/L9Pe6pfkWc/cpUB+CJVHOn5u5d889MVVJwQYRI
         5pVbZC7s1DA5l+mdxfjWtHYDR0ecI3AjIMNSID52tpeM+Cg5A/9igc38siL1qe4f5K
         xPJemL3alTwSw==
Date:   Wed, 5 Jan 2022 07:26:40 -0800
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
Message-ID: <YdW4sApUUBi/5UHh@sol.localdomain>
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

Jens, any update on fixing the io_uring version of the bug?  Note, syzbot has
managed to use io_uring poll to hit the WARN_ON_ONCE() that I added in
__wake_up_pollfree(), which proves that it is broken.

- Eric
