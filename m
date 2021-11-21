Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 105A0458277
	for <lists+stable@lfdr.de>; Sun, 21 Nov 2021 08:49:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234827AbhKUHww (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Nov 2021 02:52:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:59428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229850AbhKUHwv (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 21 Nov 2021 02:52:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9951660C3F;
        Sun, 21 Nov 2021 07:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637480987;
        bh=9uE0Bmzb+mYzYGR1h8Kjyk4O89jDGLuwPNTzFteWHK4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wS5OyvEqRPqGMy29d1K5nXuAhE4VWk6EGO+HB41G6iK5OzzUvIyvscxWaWmiKe3SW
         AlWvQg5ZpxJhPCFtfgj4F5yhdNeCFvehS25wabCn8TODZ0tQ0EgaV+vvAHgZ6DEGQI
         c37SnYeYmt4K6NXTfS0b8LrbLMpuRi7bVxknXK/A=
Date:   Sun, 21 Nov 2021 08:49:44 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@suse.de>, linux-kernel@vger.kernel.org,
        f.fainelli@gmail.com, torvalds@linux-foundation.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        jonathanh@nvidia.com, stable@vger.kernel.org, pavel@denx.de,
        akpm@linux-foundation.org, shuah@kernel.org, linux@roeck-us.net,
        Daniel =?iso-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>,
        Ondrej Zary <linux@zary.sk>
Subject: Re: [PATCH 5.10 00/21] 5.10.81-rc1 review
Message-ID: <YZn6GAsSzxUDWUv6@kroah.com>
References: <20211119171443.892729043@linuxfoundation.org>
 <106740f9-4efc-f1ac-fd42-bf8afc994333@linaro.org>
 <CA+G9fYv4s0oE4w5ushnLwYrC4=fWh6uK2_umnU15o2bEZWZt2g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYv4s0oE4w5ushnLwYrC4=fWh6uK2_umnU15o2bEZWZt2g@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Nov 20, 2021 at 09:36:55PM +0530, Naresh Kamboju wrote:
> + Peter Zijlstra
> + Thomas Gleixner
> + Borislav Petkov
> + Ondrej Zary
> 
> 
> On Sat, 20 Nov 2021 at 20:57, Daniel Díaz <daniel.diaz@linaro.org> wrote:
> >
> > Hello!
> >
> > On 11/19/21 11:37 AM, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 5.10.81 release.
> > > There are 21 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Sun, 21 Nov 2021 17:14:35 +0000.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > >       https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.81-rc1.gz
> > > or in the git tree and branch at:
> > >       git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> > > and the diffstat can be found below.
> > >
> > > thanks,
> > >
> > > greg k-h
> > >
> > > -------------
> > > Pseudo-Shortlog of commits:
> > >
> > > Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > >      Linux 5.10.81-rc1
> > [...]> Peter Zijlstra <peterz@infradead.org>
> > >      x86/iopl: Fake iopl(3) CLI/STI usage
> 
> This is due to  ^ new kernel code + old test case (Test case needs to
> be updated)
> 
> > [...]
> >
> > Results from Linaro's test farm.
> > Regressions found on x86_64 and i386, on iopl. Here's an excerpt of the selftest:
> >
> >    [    0.000000] Linux version 5.10.81-rc1 (oe-user@oe-host) (x86_64-linaro-linux-gcc (GCC) 7.3.0, GNU ld (GNU Binutils) 2.30.0.20180208) #1 SMP Fri Nov 19 19:48:55 UTC 2021
> > [...]
> >    [  170.351838] traps: iopl_64[2769] attempts to use CLI/STI, pretending it's a NOP, ip:400dde in iopl_64[400000+2000]
> > [...]
> >    # selftests: x86: iopl_64
> >    # [FAIL]     CLI worked
> >    # [FAIL]     STI worked
> 
> This failure was detected on linux next and the later test case has been fixed.
> The Following patch could fix this problem across 5.10, 5.14 and 5.15.
> 
> Patch details,
> ---
> selftests/x86/iopl: Adjust to the faked iopl CLI/STI usage
> 
> Commit in Fixes changed the iopl emulation to not #GP on CLI and STI
> because it would break some insane luserspace tools which would toggle
> interrupts.
> 
> The corresponding selftest would rely on the fact that executing CLI/STI
> would trigger a #GP and thus detect it this way but since that #GP is
> not happening anymore, the detection is now wrong too.
> 
> Extend the test to actually look at the IF flag and whether executing
> those insns had any effect on it. The STI detection needs to have the
> fact that interrupts were previously disabled, passed in so do that from
> the previous CLI test, i.e., STI test needs to follow a previous CLI one
> for it to make sense.
> 
> Fixes: b968e84b509d ("x86/iopl: Fake iopl(3) CLI/STI usage")
> Suggested-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Borislav Petkov <bp@suse.de>
> Acked-by: Thomas Gleixner <tglx@linutronix.de>
> Link: https://lore.kernel.org/r/20211030083939.13073-1-bp@alien8.de

Now queued up, thanks,

greg k-h
