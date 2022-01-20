Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39B5C495704
	for <lists+stable@lfdr.de>; Fri, 21 Jan 2022 00:34:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348050AbiATXdd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jan 2022 18:33:33 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:38460 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348169AbiATXdc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Jan 2022 18:33:32 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 57E7961937
        for <stable@vger.kernel.org>; Thu, 20 Jan 2022 23:33:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE240C340E0;
        Thu, 20 Jan 2022 23:33:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642721611;
        bh=qcOZp94pnjfy/amSf0zEkdu3JCweDsIHEm8Qyl8GcIg=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=FSH0IQcXhtwL+6GO1Q90+h9ZpOW1vOPcSttuYwmSZM2UDyiGcx3WfchgEm3l66Vph
         D3kfMD3XDilevhHDEYlpIXPdPChE/oHj8WQ9s/7RF3DmTzH4kfcOW5gtCjPQtLFVIk
         A6kKwtpwha5widJqbulsNUr77XfKt6UCn2WnfFtpwSa+pJ6m+U43coAYv0WA5fR07F
         4cM3TVRTV8d5tofrlBP93ddom0WuLC5FcokVeMsd4hkPuZg2Zs02DLAo7qZCLJ8Kl1
         VfNS6cVd9kzhjbapTlw2N2CqwtVIDMiAAdcpQjsCzBaW3YEFZ+boRakF3UcqeAxpov
         jhrQXwx79No5A==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id 706125C0367; Thu, 20 Jan 2022 15:33:31 -0800 (PST)
Date:   Thu, 20 Jan 2022 15:33:31 -0800
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Guillaume Morin <guillaume@morinfr.org>
Cc:     gregkh@linuxfoundation.org, stable@vger.kernel.org,
        neelx@redhat.com
Subject: Re: [PATCH for stable 5.x] rcu: Tighten rcu_advance_cbs_nowake()
 checks
Message-ID: <20220120233331.GS947480@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <YemwBdpmBeC03JeT@bender.morinfr.org>
 <20220120191600.GP947480@paulmck-ThinkPad-P17-Gen-1>
 <Yem3fsHWahJEvjsk@bender.morinfr.org>
 <20220120205705.GQ947480@paulmck-ThinkPad-P17-Gen-1>
 <YengcErT48sYK0yL@bender.morinfr.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YengcErT48sYK0yL@bender.morinfr.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 20, 2022 at 11:21:36PM +0100, Guillaume Morin wrote:
> On 20 Jan 12:57, Paul E. McKenney wrote:
> >
> > On Thu, Jan 20, 2022 at 08:26:54PM +0100, Guillaume Morin wrote:
> > > On 20 Jan 11:16, Paul E. McKenney wrote:
> > > > On Thu, Jan 20, 2022 at 07:55:01PM +0100, Guillaume Morin wrote:
> > > > > I believe commit 614ddad17f22a22e035e2ea37a04815f50362017 (slated for
> > > > > 5.17) should be queued for all 5.4+ stable branches as it fixes a
> > > > > serious lockup bug. FWIW I have verified it applies cleanly on all 4
> > > > > branches.
> > > > > 
> > > > > Does that make sense to you?
> > > > 
> > > > From a quick glance at v5.4, it looks quite plausible to me.
> > > > 
> > > > I do suggest that you try building and testing, given that the hardware's
> > > > idea of what is plausible overrides that of either of us.  ;-)
> > > 
> > > We've had a few dozens lockups on 5.4 and 5.10 due to this bug (what
> > > lead me to write to you back in Sep). The original bugzilla report is on
> > > 5.4 as well, see https://bugzilla.kernel.org/show_bug.cgi?id=208685. So
> > > I am positive that the issue is reachable in both kernels.
> > > 
> > > Also I do know for sure it fixes the problem for 5.10. I don't have a
> > > test rig anymore for 5.4. But considering we know it's reachable with
> > > 5.4, I think the patch should be applied for 5.4+. Obviously, you're the
> > > expert here though.
> > 
> > Au contraire!  I do not claim much expertise on -stable validation.
> > 
> > If it was me, I would run a quick touch-test like this from the top-level
> > directory of the Linux-kernel source tree on a qemu/KVM-capable system:
> > 
> > 	tools/testing/selftests/rcutorture/bin/kvm.sh --cpus N --duration 10 --configs "TREE01 TREE04"
> > 
> > Where "N" is replaced by the number of CPUs on your system, which should
> > preferably be at least eight.
> > 
> > This will take somewhere between 15 minutes and an hour to run, depending
> > on your system.
> > 
> > Sadly, v5.4 isn't quite as good at analyzing results as are current
> > versions, but please feel free to send me the output.
> > 
> > Does that help?
> 
> Ok I did a quick run with 614ddad17f22a22e035e2ea37a04815f50362017
> applied on top of the 5.4 stable branch. Not quite sure how I got
> suckered into running a test on a kernel I don't even run, but hey I
> guess everybody must do their part :-)

That is indeed what I keep telling myself.  ;-)

> Not sure about CONFIG_HOTPLUG_CPU thing at the end.
> 
> tools/testing/selftests/rcutorture/initrd/init already exists, no need to create it
> Results directory: /usr/scratch/kernel/tools/testing/selftests/rcutorture/res/2022.01.20-17:02:37
> tools/testing/selftests/rcutorture/bin/kvm.sh --cpus 60 --duration 10 --configs TREE01 TREE04
> ----Start batch 1: Thu 20 Jan 2022 05:02:37 PM EST
> TREE01 8: Starting build. Thu 20 Jan 2022 05:02:37 PM EST
> TREE01 8: Waiting for build to complete. Thu 20 Jan 2022 05:02:37 PM EST
> TREE01 8: Build complete. Thu 20 Jan 2022 05:03:16 PM EST
> TREE04 8: Starting build. Thu 20 Jan 2022 05:03:16 PM EST
> TREE04 8: Waiting for build to complete. Thu 20 Jan 2022 05:03:16 PM EST
> TREE04 8: Build complete. Thu 20 Jan 2022 05:03:55 PM EST

39 seconds to build each kernel.  Not bad!  ;-)

> ---- TREE01 8: Kernel present. Thu 20 Jan 2022 05:03:55 PM EST
> ---- TREE04 8: Kernel present. Thu 20 Jan 2022 05:03:55 PM EST
> ---- Starting kernels. Thu 20 Jan 2022 05:03:55 PM EST
> ---- All kernel runs complete. Thu 20 Jan 2022 05:14:05 PM EST
> ---- TREE01 8: Build/run results:
>  --- Thu 20 Jan 2022 05:02:37 PM EST: Starting build
>  --- Thu 20 Jan 2022 05:03:55 PM EST: Starting kernel
> CPU-hotplug kernel, adding rcutorture onoff.
> Monitoring qemu job at pid 46081
> Grace period for qemu job at pid 46081
> ---- TREE04 8: Build/run results:
>  --- Thu 20 Jan 2022 05:03:16 PM EST: Starting build
> :CONFIG_HOTPLUG_CPU: improperly set
>  --- Thu 20 Jan 2022 05:03:55 PM EST: Starting kernel
> CPU-hotplug kernel, adding rcutorture onoff.
> Monitoring qemu job at pid 45847
> Grace period for qemu job at pid 45847
> 
> 
>  --- Thu 20 Jan 2022 05:02:37 PM EST Test summary:
> Results directory: /usr/scratch/kernel/tools/testing/selftests/rcutorture/res/2022.01.20-17:02:37
> tools/testing/selftests/rcutorture/bin/kvm.sh --cpus 60 --duration 10 --configs TREE01 TREE04
> TREE01 ------- 12719 GPs (21.1983/s) [rcu: g94609 f0x0 ]
> TREE04 ------- 3128 GPs (5.21333/s) [rcu: g23621 f0x0 ]
> :CONFIG_HOTPLUG_CPU: improperly set

This run was successful, so good!

But you are quite correct to be suspicious of the "improperly set"
message.  But is is OK in this particular case.

This message appears because security-related changes made it quite
difficult to disable CPU hotplug on x86.  The rcutorture test suite is
therefore complaining that even though it tried disabling CPU hotplug for
the TREE04 test scenario, it found that the kernel nevertheless built
with CONFIG_HOTPLUG_CPU=y.  And later versions of rcutorture resigned
themselves to always testing with CONFIG_HOTPLUG_CPU=y.

So again, this run was successful.  And thank you for checking it!

							Thanx, Paul
