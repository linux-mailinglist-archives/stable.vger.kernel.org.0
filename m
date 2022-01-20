Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 743A149564F
	for <lists+stable@lfdr.de>; Thu, 20 Jan 2022 23:22:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347722AbiATWVi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jan 2022 17:21:38 -0500
Received: from smtp1-g21.free.fr ([212.27.42.1]:42468 "EHLO smtp1-g21.free.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238984AbiATWVi (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jan 2022 17:21:38 -0500
Received: from bender.morinfr.org (unknown [82.65.130.196])
        by smtp1-g21.free.fr (Postfix) with ESMTPS id 0FFE5B00539;
        Thu, 20 Jan 2022 23:21:37 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=morinfr.org
        ; s=20170427; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Y6AZXM2HmO9Wqp35wkA3dXawoGGVNWiWfxLbLDSqYWE=; b=k4QM37R/8Z7Ymd53nSqNoQk0dB
        ISu8T3BkQIgPrl/TGonaIB41ZixJb16d9a0Puu9VPf1U+elXiBXLL7FknBbNl6sUVVUBbQ/shrZMW
        54X15rKyOs0mpRW7cDSPExK373n9Rbg+Fr1ZVmdPbJ/QNzJIYjGA8v5rUhLCBZHgbWJs=;
Received: from guillaum by bender.morinfr.org with local (Exim 4.94.2)
        (envelope-from <guillaume@morinfr.org>)
        id 1nAfoG-0005IN-Ia; Thu, 20 Jan 2022 23:21:36 +0100
Date:   Thu, 20 Jan 2022 23:21:36 +0100
From:   Guillaume Morin <guillaume@morinfr.org>
To:     "Paul E. McKenney" <paulmck@kernel.org>
Cc:     gregkh@linuxfoundation.org, stable@vger.kernel.org,
        neelx@redhat.com
Subject: Re: [PATCH for stable 5.x] rcu: Tighten rcu_advance_cbs_nowake()
 checks
Message-ID: <YengcErT48sYK0yL@bender.morinfr.org>
References: <YemwBdpmBeC03JeT@bender.morinfr.org>
 <20220120191600.GP947480@paulmck-ThinkPad-P17-Gen-1>
 <Yem3fsHWahJEvjsk@bender.morinfr.org>
 <20220120205705.GQ947480@paulmck-ThinkPad-P17-Gen-1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220120205705.GQ947480@paulmck-ThinkPad-P17-Gen-1>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 20 Jan 12:57, Paul E. McKenney wrote:
>
> On Thu, Jan 20, 2022 at 08:26:54PM +0100, Guillaume Morin wrote:
> > On 20 Jan 11:16, Paul E. McKenney wrote:
> > > On Thu, Jan 20, 2022 at 07:55:01PM +0100, Guillaume Morin wrote:
> > > > I believe commit 614ddad17f22a22e035e2ea37a04815f50362017 (slated for
> > > > 5.17) should be queued for all 5.4+ stable branches as it fixes a
> > > > serious lockup bug. FWIW I have verified it applies cleanly on all 4
> > > > branches.
> > > > 
> > > > Does that make sense to you?
> > > 
> > > From a quick glance at v5.4, it looks quite plausible to me.
> > > 
> > > I do suggest that you try building and testing, given that the hardware's
> > > idea of what is plausible overrides that of either of us.  ;-)
> > 
> > We've had a few dozens lockups on 5.4 and 5.10 due to this bug (what
> > lead me to write to you back in Sep). The original bugzilla report is on
> > 5.4 as well, see https://bugzilla.kernel.org/show_bug.cgi?id=208685. So
> > I am positive that the issue is reachable in both kernels.
> > 
> > Also I do know for sure it fixes the problem for 5.10. I don't have a
> > test rig anymore for 5.4. But considering we know it's reachable with
> > 5.4, I think the patch should be applied for 5.4+. Obviously, you're the
> > expert here though.
> 
> Au contraire!  I do not claim much expertise on -stable validation.
> 
> If it was me, I would run a quick touch-test like this from the top-level
> directory of the Linux-kernel source tree on a qemu/KVM-capable system:
> 
> 	tools/testing/selftests/rcutorture/bin/kvm.sh --cpus N --duration 10 --configs "TREE01 TREE04"
> 
> Where "N" is replaced by the number of CPUs on your system, which should
> preferably be at least eight.
> 
> This will take somewhere between 15 minutes and an hour to run, depending
> on your system.
> 
> Sadly, v5.4 isn't quite as good at analyzing results as are current
> versions, but please feel free to send me the output.
> 
> Does that help?

Ok I did a quick run with 614ddad17f22a22e035e2ea37a04815f50362017
applied on top of the 5.4 stable branch. Not quite sure how I got
suckered into running a test on a kernel I don't even run, but hey I
guess everybody must do their part :-)

Not sure about CONFIG_HOTPLUG_CPU thing at the end.

tools/testing/selftests/rcutorture/initrd/init already exists, no need to create it
Results directory: /usr/scratch/kernel/tools/testing/selftests/rcutorture/res/2022.01.20-17:02:37
tools/testing/selftests/rcutorture/bin/kvm.sh --cpus 60 --duration 10 --configs TREE01 TREE04
----Start batch 1: Thu 20 Jan 2022 05:02:37 PM EST
TREE01 8: Starting build. Thu 20 Jan 2022 05:02:37 PM EST
TREE01 8: Waiting for build to complete. Thu 20 Jan 2022 05:02:37 PM EST
TREE01 8: Build complete. Thu 20 Jan 2022 05:03:16 PM EST
TREE04 8: Starting build. Thu 20 Jan 2022 05:03:16 PM EST
TREE04 8: Waiting for build to complete. Thu 20 Jan 2022 05:03:16 PM EST
TREE04 8: Build complete. Thu 20 Jan 2022 05:03:55 PM EST
---- TREE01 8: Kernel present. Thu 20 Jan 2022 05:03:55 PM EST
---- TREE04 8: Kernel present. Thu 20 Jan 2022 05:03:55 PM EST
---- Starting kernels. Thu 20 Jan 2022 05:03:55 PM EST
---- All kernel runs complete. Thu 20 Jan 2022 05:14:05 PM EST
---- TREE01 8: Build/run results:
 --- Thu 20 Jan 2022 05:02:37 PM EST: Starting build
 --- Thu 20 Jan 2022 05:03:55 PM EST: Starting kernel
CPU-hotplug kernel, adding rcutorture onoff.
Monitoring qemu job at pid 46081
Grace period for qemu job at pid 46081
---- TREE04 8: Build/run results:
 --- Thu 20 Jan 2022 05:03:16 PM EST: Starting build
:CONFIG_HOTPLUG_CPU: improperly set
 --- Thu 20 Jan 2022 05:03:55 PM EST: Starting kernel
CPU-hotplug kernel, adding rcutorture onoff.
Monitoring qemu job at pid 45847
Grace period for qemu job at pid 45847


 --- Thu 20 Jan 2022 05:02:37 PM EST Test summary:
Results directory: /usr/scratch/kernel/tools/testing/selftests/rcutorture/res/2022.01.20-17:02:37
tools/testing/selftests/rcutorture/bin/kvm.sh --cpus 60 --duration 10 --configs TREE01 TREE04
TREE01 ------- 12719 GPs (21.1983/s) [rcu: g94609 f0x0 ]
TREE04 ------- 3128 GPs (5.21333/s) [rcu: g23621 f0x0 ]
:CONFIG_HOTPLUG_CPU: improperly set


-- 
Guillaume Morin <guillaume@morinfr.org>
