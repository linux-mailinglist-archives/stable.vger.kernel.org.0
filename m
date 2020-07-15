Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FABF2208B5
	for <lists+stable@lfdr.de>; Wed, 15 Jul 2020 11:27:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729869AbgGOJ1J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jul 2020 05:27:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:41844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729850AbgGOJ1J (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Jul 2020 05:27:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EED1D206E9;
        Wed, 15 Jul 2020 09:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594805228;
        bh=pRB4+btXkRMLsZyybK6bfL9gZC4uGzSBaBVkJFk+GyM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dc6bmwh08/G0OnQ0fWFY9KmOP4Zn5vkCzMguMV+WVQSprFgkfywZtDX0UiX0rcpz0
         0H6x4tHieRvfYOM572e2rJOqiNfhcl+c1PfEuMWts3dXLgUI8BJUC6GkOtcnrrdYAo
         IrlIVYNqMsBGIzQjpzqg148mDH87w3h3QsucSkXM=
Date:   Wed, 15 Jul 2020 11:27:04 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        linux- stable <stable@vger.kernel.org>,
        lkft-triage@lists.linaro.org, Sasha Levin <sashal@kernel.org>,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Marc Zyngier <maz@kernel.org>
Subject: Re: stable-rc 5.4: arm64 build =?utf-8?Q?f?=
 =?utf-8?Q?ailed_-_error=3A_=E2=80=98const_struct_arch=5Ftimer=5Ferratum?=
 =?utf-8?Q?=5Fworkaround=E2=80=99_has_no_member_named_=E2=80=98disable=5Fc?=
 =?utf-8?B?b21wYXRfdmRzb+KAmQ==?=
Message-ID: <20200715092704.GE2722864@kroah.com>
References: <CA+G9fYsLBOVVjxO2DAUgjXskxEXyMpBxYG1PRKwe7BTHJfzfZw@mail.gmail.com>
 <20200714184013.GA2174489@kroah.com>
 <CAK8P3a2B6xO-PEOEsseajBvJCvF0d269XHvOzqzdfhyssZ6wrw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAK8P3a2B6xO-PEOEsseajBvJCvF0d269XHvOzqzdfhyssZ6wrw@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 15, 2020 at 08:54:33AM +0200, Arnd Bergmann wrote:
> On Tue, Jul 14, 2020 at 8:40 PM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Tue, Jul 14, 2020 at 10:48:14PM +0530, Naresh Kamboju wrote:
> > > arm64 build failed on 5.4
> > >
> > > make -sk KBUILD_BUILD_USER=TuxBuild -C/linux -j16 ARCH=arm64
> > > CROSS_COMPILE=aarch64-linux-gnu- HOSTCC=gcc CC="sccache
> > > aarch64-linux-gnu-gcc" O=build Image
> > > #
> > > ../drivers/clocksource/arm_arch_timer.c:484:4: error: ‘const struct
> > > arch_timer_erratum_workaround’ has no member named
> > > ‘disable_compat_vdso’
> > >   484 |   .disable_compat_vdso = true,
> > >       |    ^~~~~~~~~~~~~~~~~~~
> > > ../drivers/clocksource/arm_arch_timer.c:484:26: warning:
> > > initialization of ‘u32 (*)(void)’ {aka ‘unsigned int (*)(void)’} from
> > > ‘int’ makes pointer from integer without a cast [-Wint-conversion]
> > >   484 |   .disable_compat_vdso = true,
> > >       |                          ^~~~
> > > ../drivers/clocksource/arm_arch_timer.c:484:26: note: (near
> > > initialization for ‘ool_workarounds[5].read_cntp_tval_el0’)
> > >
> > > Could be this patch,
> > > arm64: arch_timer: Disable the compat vdso for cores affected by
> > > ARM64_WORKAROUND_1418040
> > > commit 4b661d6133c5d3a7c9aca0b4ee5a78c7766eff3f upstream.
> > >
> > > ARM64_WORKAROUND_1418040 requires that AArch32 EL0 accesses to
> > > the virtual counter register are trapped and emulated by the kernel.
> > > This makes the vdso pretty pointless, and in some cases livelock
> > > prone.
> > >
> > > Provide a workaround entry that limits the vdso to 64bit tasks.
> > >
> > > ref:
> > > https://gitlab.com/Linaro/lkft/kernel-runs/-/jobs/638094006
> >
> > Thanks, I've now dropped this patch.
> 
> I think we do want to have it back eventually. It appears that the patch
> upstream depends on the two immediately before it:
> 
> 4b661d6133c5 arm64: arch_timer: Disable the compat vdso for cores
> affected by ARM64_WORKAROUND_1418040
> c1fbec4ac0d7 arm64: arch_timer: Allow an workaround descriptor to
> disable compat vdso
> 97884ca8c292 arm64: Introduce a way to disable the 32bit vdso
> 
> AFAICT, the second one was missing, causing the build failure.
> Do you know if that one needed a manual backport, or could you
> try applying all three in sequence again?

The "first one", 97884ca8c292 ("arm64: Introduce a way to disable the
32bit vdso"), does not apply to 5.4.y, and neither does c1fbec4ac0d7
("arm64: arch_timer: Allow an workaround descriptor to disable compat
vdso").

So backports for all 3 would be appreciated.

thanks,

greg k-h
