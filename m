Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D23D2209A9
	for <lists+stable@lfdr.de>; Wed, 15 Jul 2020 12:16:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728110AbgGOKQT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jul 2020 06:16:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:57750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731040AbgGOKQT (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Jul 2020 06:16:19 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3216220720;
        Wed, 15 Jul 2020 10:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594808178;
        bh=MLE6slukUJCbU4Lp9wAIRaIGRB77Hb5WdLKM3BaDRZg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Z/hBgYAUtMb3ykHVV9GI88hnXyICEjxpuiy5xGErl1SVFMKVix7P/c5R1UTh0Xsdd
         i4Xs61OJnTZpMRpW552peDPpgieXAV5jOBLuHuvEoS+zwEToJSDxr2gVAN8hkKpZSd
         V+OrJUIt5Rwh7FU1QFY2cJb5K+BpWNidyEWovIRQ=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jveSV-00BxRw-WC; Wed, 15 Jul 2020 11:16:16 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Wed, 15 Jul 2020 11:16:15 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        linux- stable <stable@vger.kernel.org>,
        lkft-triage@lists.linaro.org, Sasha Levin <sashal@kernel.org>,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
Subject: =?UTF-8?Q?Re=3A_stable-rc_5=2E4=3A_arm64_build_failed_-_error=3A?=
 =?UTF-8?Q?_=E2=80=98const_struct_arch=5Ftimer=5Ferratum=5Fworkaround?=
 =?UTF-8?Q?=E2=80=99_has_no_member_named_=E2=80=98disable=5Fcompat=5Fvdso?=
 =?UTF-8?Q?=E2=80=99?=
In-Reply-To: <20200715092704.GE2722864@kroah.com>
References: <CA+G9fYsLBOVVjxO2DAUgjXskxEXyMpBxYG1PRKwe7BTHJfzfZw@mail.gmail.com>
 <20200714184013.GA2174489@kroah.com>
 <CAK8P3a2B6xO-PEOEsseajBvJCvF0d269XHvOzqzdfhyssZ6wrw@mail.gmail.com>
 <20200715092704.GE2722864@kroah.com>
User-Agent: Roundcube Webmail/1.4.5
Message-ID: <0367b2521cc678cb858c5af64c085506@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: gregkh@linuxfoundation.org, arnd@arndb.de, naresh.kamboju@linaro.org, stable@vger.kernel.org, lkft-triage@lists.linaro.org, sashal@kernel.org, will@kernel.org, mark.rutland@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020-07-15 10:27, Greg Kroah-Hartman wrote:
> On Wed, Jul 15, 2020 at 08:54:33AM +0200, Arnd Bergmann wrote:
>> On Tue, Jul 14, 2020 at 8:40 PM Greg Kroah-Hartman
>> <gregkh@linuxfoundation.org> wrote:
>> >
>> > On Tue, Jul 14, 2020 at 10:48:14PM +0530, Naresh Kamboju wrote:
>> > > arm64 build failed on 5.4
>> > >
>> > > make -sk KBUILD_BUILD_USER=TuxBuild -C/linux -j16 ARCH=arm64
>> > > CROSS_COMPILE=aarch64-linux-gnu- HOSTCC=gcc CC="sccache
>> > > aarch64-linux-gnu-gcc" O=build Image
>> > > #
>> > > ../drivers/clocksource/arm_arch_timer.c:484:4: error: ‘const struct
>> > > arch_timer_erratum_workaround’ has no member named
>> > > ‘disable_compat_vdso’
>> > >   484 |   .disable_compat_vdso = true,
>> > >       |    ^~~~~~~~~~~~~~~~~~~
>> > > ../drivers/clocksource/arm_arch_timer.c:484:26: warning:
>> > > initialization of ‘u32 (*)(void)’ {aka ‘unsigned int (*)(void)’} from
>> > > ‘int’ makes pointer from integer without a cast [-Wint-conversion]
>> > >   484 |   .disable_compat_vdso = true,
>> > >       |                          ^~~~
>> > > ../drivers/clocksource/arm_arch_timer.c:484:26: note: (near
>> > > initialization for ‘ool_workarounds[5].read_cntp_tval_el0’)
>> > >
>> > > Could be this patch,
>> > > arm64: arch_timer: Disable the compat vdso for cores affected by
>> > > ARM64_WORKAROUND_1418040
>> > > commit 4b661d6133c5d3a7c9aca0b4ee5a78c7766eff3f upstream.
>> > >
>> > > ARM64_WORKAROUND_1418040 requires that AArch32 EL0 accesses to
>> > > the virtual counter register are trapped and emulated by the kernel.
>> > > This makes the vdso pretty pointless, and in some cases livelock
>> > > prone.
>> > >
>> > > Provide a workaround entry that limits the vdso to 64bit tasks.
>> > >
>> > > ref:
>> > > https://gitlab.com/Linaro/lkft/kernel-runs/-/jobs/638094006
>> >
>> > Thanks, I've now dropped this patch.
>> 
>> I think we do want to have it back eventually. It appears that the 
>> patch
>> upstream depends on the two immediately before it:
>> 
>> 4b661d6133c5 arm64: arch_timer: Disable the compat vdso for cores
>> affected by ARM64_WORKAROUND_1418040
>> c1fbec4ac0d7 arm64: arch_timer: Allow an workaround descriptor to
>> disable compat vdso
>> 97884ca8c292 arm64: Introduce a way to disable the 32bit vdso
>> 
>> AFAICT, the second one was missing, causing the build failure.
>> Do you know if that one needed a manual backport, or could you
>> try applying all three in sequence again?
> 
> The "first one", 97884ca8c292 ("arm64: Introduce a way to disable the
> 32bit vdso"), does not apply to 5.4.y, and neither does c1fbec4ac0d7
> ("arm64: arch_timer: Allow an workaround descriptor to disable compat
> vdso").
> 
> So backports for all 3 would be appreciated.

These patches cannot just be backported, as 5.4 uses very different
data structures and abstractions. I'll try and come up with something
semantically equivalent by the end of the day...

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
