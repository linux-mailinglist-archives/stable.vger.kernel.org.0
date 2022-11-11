Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA41C625639
	for <lists+stable@lfdr.de>; Fri, 11 Nov 2022 10:08:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232841AbiKKJIM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Nov 2022 04:08:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233524AbiKKJIK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Nov 2022 04:08:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 420786455
        for <stable@vger.kernel.org>; Fri, 11 Nov 2022 01:08:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EF6FDB8247C
        for <stable@vger.kernel.org>; Fri, 11 Nov 2022 09:08:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E17CC433D6;
        Fri, 11 Nov 2022 09:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668157686;
        bh=2B02mxmH0n8WgxG76+VOVqfLuvlGVF0A3/5YIhDp9Tw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0DFsB5NGFXHcjpCXYuw7Hev3KMIjCUiSYFQ7n6w4sNjmSY5ZdvZKer5+udezqyQfu
         2VX6gykJZ1cAtbOsICD9iScSH3TL1ZeXzRPDHJwQnioxe4RotAVPKXxH7SWW+tTG4P
         u3bpGr+J1v1JjcRL/erYVcxsh/EfvyrLuIGbtk/0=
Date:   Fri, 11 Nov 2022 10:08:04 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mikulas Patocka <mpatocka@redhat.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 5.15 2/2] provide arch_test_bit_acquire for architectures
 that define test_bit
Message-ID: <Y24Q9I+/HFJyZx3T@kroah.com>
References: <alpine.LRH.2.21.2210270841040.22202@file01.intranet.prod.int.rdu2.redhat.com>
 <Y2kiGNpHW8pYBVk6@kroah.com>
 <alpine.LRH.2.21.2211071541450.2058@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.21.2211071541450.2058@file01.intranet.prod.int.rdu2.redhat.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 07, 2022 at 04:10:30PM -0500, Mikulas Patocka wrote:
> 
> 
> On Mon, 7 Nov 2022, Greg KH wrote:
> 
> > On Thu, Oct 27, 2022 at 08:41:45AM -0400, Mikulas Patocka wrote:
> > > commit d6ffe6067a54972564552ea45d320fb98db1ac5e upstream.
> > > 
> > > Some architectures define their own arch_test_bit and they also need
> > > arch_test_bit_acquire, otherwise they won't compile.  We also clean up
> > > the code by using the generic test_bit if that is equivalent to the
> > > arch-specific version.
> > > 
> > > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> > > Cc: stable@vger.kernel.org
> > > Fixes: 8238b4579866 ("wait_on_bit: add an acquire memory barrier")
> > > Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> > > 
> > > ---
> > >  arch/alpha/include/asm/bitops.h   |    7 +++++++
> > >  arch/h8300/include/asm/bitops.h   |    3 ++-
> > >  arch/hexagon/include/asm/bitops.h |   15 +++++++++++++++
> > >  arch/ia64/include/asm/bitops.h    |    7 +++++++
> > >  arch/m68k/include/asm/bitops.h    |    6 ++++++
> > >  arch/s390/include/asm/bitops.h    |    7 +++++++
> > >  arch/sh/include/asm/bitops-op32.h |    7 +++++++
> > >  7 files changed, 51 insertions(+), 1 deletion(-)
> > 
> > This is _very_ different from the upstream change that you are trying to
> > backport here.
> > 
> > Are you sure it is correct?
> 
> I compile-tested it with all the cross-compilers downloaded from 
> https://mirrors.edge.kernel.org/pub/tools/crosstool/ (I tried to compile 
> the file kernel/sched/build_utility.o that includes wait_bit.c)

That's not what I am asking here.

> > You are adding real functions for these
> > arches, while the original backport was _REMOVING_ them and having the
> > arch code call the generic functions.
> 
> The kernels 5.19 and older don't contain the function generic_test_bit - 
> and they don't contain the file 
> "include/asm-generic/bitops/generic-non-atomic.h" where this function is 
> defined. The test_bit code was refactored in 6.0 - see the commits
> 
> 21bb8af513d35c005c401706030f4eb469538d1d
> 0e862838f290147ea9c16db852d8d494b552d38d
> bb7379bfa680bd48b468e856475778db2ad866c1
> e69eb9c460f128b71c6b995d75a05244e4b6cc3e
> b03fc1173c0c2bb8fad61902a862985cecdc4b1b
> 
> So, the upstream patch doesn't apply to the older kernels.

I agree, so then please backport the needed commits.  Do not create a
commit that says it is one thing, but really looks very very different
from the original.  That's going to make it almost impossible to
maintain over time, right?

> > So why is this the same?
> 
> Functionally, it is equivalent if you define a function test_bit_acquire 
> or refer to an existing generic_test_bit_acquire that has the same 
> content.

No, it's not the same, you are putting logic in each arch that in
mainline is not there.  In Linus's tree there is a reference to the
generic asm function.  Here you are adding arch-specific functions.

Please redo this series and resubmit them, properly threaded (hint, your
latest one is not threaded at all and is impossible to use our tools
on), so that we can review them again.

thanks,

greg k-h
