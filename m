Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9C0E49E6FD
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 17:04:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243250AbiA0QE3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 11:04:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243409AbiA0QE3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 11:04:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F4CCC061747;
        Thu, 27 Jan 2022 08:04:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 05977B8018B;
        Thu, 27 Jan 2022 16:04:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE9BBC340E4;
        Thu, 27 Jan 2022 16:04:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643299466;
        bh=A26n99d5Wtd1NNhPRFPwJDla+vG34lP24GZzlDVtSQQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cDOBHmKtittIkeN8hu6eIksobjn/g8EDb+s1zUSU8O/VOcfEUQEnUjKjLNjA7FHu+
         RL0TQqVZLl/O4Hx1quKwBNJNwGO5YsL71Q7nb4ZlaJt+r2sVCoxo50eero/lDIgTch
         mnUgFr3Ff/BtwAVkCWfQYkNoCUHstkOqakMwSh1w=
Date:   Thu, 27 Jan 2022 17:04:18 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Alan Maguire <alan.maguire@oracle.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        Daniel =?iso-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>,
        pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, stable@vger.kernel.org,
        Russell King <russell.king@oracle.com>
Subject: Re: [PATCH 5.15 000/846] 5.15.17-rc1 review
Message-ID: <YfLCgrg1SI3M7E6v@kroah.com>
References: <20220124184100.867127425@linuxfoundation.org>
 <374e9357-35eb-3555-3fe5-7b72c3a77a39@linaro.org>
 <ef6a4bcf-832b-3a5d-9643-827239293772@linaro.org>
 <CA+G9fYtTU_7DVaxwbLWnKBfqwbW51ebEoP=+vah7f6cWYSrKkQ@mail.gmail.com>
 <alpine.LRH.2.23.451.2201261532050.15350@MyRouter>
 <CA+G9fYt35cFuTWEP5-+Dq5K9ZzMQTd0OG679vQs+0+92EhHvmg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYt35cFuTWEP5-+Dq5K9ZzMQTd0OG679vQs+0+92EhHvmg@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 27, 2022 at 06:01:53PM +0530, Naresh Kamboju wrote:
> On Wed, 26 Jan 2022 at 21:05, Alan Maguire <alan.maguire@oracle.com> wrote:
> >
> > > Regressions detected on arm, arm64, i386, x86 on 5.15 and 5.10
> > >
> > > > >
> > > > > This is one from arm64:
> > > > >    /builds/linux/arch/arm64/mm/extable.c: In function 'fixup_exception':
> > > > >    /builds/linux/arch/arm64/mm/extable.c:17:13: error: implicit declaration of function 'in_bpf_jit' [-Werror=implicit-function-declaration]
> > > > >       17 |         if (in_bpf_jit(regs))
> > > > >          |             ^~~~~~~~~~
> > > > >    cc1: some warnings being treated as errors
> > > > >    make[3]: *** [/builds/linux/scripts/Makefile.build:277: arch/arm64/mm/extable.o] Error 1
> > > >
> > > > Bisection here pointed to "arm64/bpf: Remove 128MB limit for BPF JIT programs". Reverting made the build succeed.
> > >
> > > arm64/bpf: Remove 128MB limit for BPF JIT programs
> > > commit b89ddf4cca43f1269093942cf5c4e457fd45c335 upstream.
> > >
> > > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> > >
> >
> > Thanks for the report!
> >
> > This one needs slightly different handling on 5.15. Russell had a 5.15
> > patch for this (where BPF exception handling was still handled separately)
> > and I've included it below. I verified it applies cleanly to the
> > linux-5.15.y branch and builds.  I'd suggest either skipping backport of
> > this fix to stable completely, or just applying the below to 5.15 and
> > skipping further backports.
> 
> Build test pass with this patch on stable/linux-5.15.y.

Great, thanks!

I'll queue this up now.

greg k-h
