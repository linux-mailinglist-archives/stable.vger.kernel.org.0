Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 124434955B1
	for <lists+stable@lfdr.de>; Thu, 20 Jan 2022 21:57:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347398AbiATU5I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jan 2022 15:57:08 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:47466 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347149AbiATU5I (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Jan 2022 15:57:08 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EBBE1B81D71
        for <stable@vger.kernel.org>; Thu, 20 Jan 2022 20:57:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8F00C340E0;
        Thu, 20 Jan 2022 20:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642712225;
        bh=O0dlZk30EXXcZC1gCB8mAnrg2iwiX1zmHwPJ7BIjISk=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=pWZT43kFLxsaf/yKkg/3mJT9fUOsJuJqNMMSIcWWHdCt8XO053xpi24Wr8AXKKCGl
         cfWR/N3j6yfUri18MzuVuExW19idW/4QY4nnf0aS/Yl+GAOUoO91Hq3OKYNuxl68fR
         OQa3Ou/1ePvzJu1cZRNtzOTqsEe0UG0a82SU1TfqOXdLsp38AvjrbkuXCrqyGaAKdv
         k6LwI9xv6H0mss6BN+5IB0mctCLUxGwGsDuui3gMoycIc5zlLaEuiK6Hz0W8ldkf0q
         TBLpqc+Eer9wfUcuS4knUIBlTKvK2W8mIIqlwmnplh3NCPj+xvjFoN8XOkcV/04k57
         6KvmJvuBIHMHA==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id 6908C5C0367; Thu, 20 Jan 2022 12:57:05 -0800 (PST)
Date:   Thu, 20 Jan 2022 12:57:05 -0800
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Guillaume Morin <guillaume@morinfr.org>
Cc:     gregkh@linuxfoundation.org, stable@vger.kernel.org,
        neelx@redhat.com
Subject: Re: [PATCH for stable 5.x] rcu: Tighten rcu_advance_cbs_nowake()
 checks
Message-ID: <20220120205705.GQ947480@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <YemwBdpmBeC03JeT@bender.morinfr.org>
 <20220120191600.GP947480@paulmck-ThinkPad-P17-Gen-1>
 <Yem3fsHWahJEvjsk@bender.morinfr.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yem3fsHWahJEvjsk@bender.morinfr.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 20, 2022 at 08:26:54PM +0100, Guillaume Morin wrote:
> On 20 Jan 11:16, Paul E. McKenney wrote:
> > On Thu, Jan 20, 2022 at 07:55:01PM +0100, Guillaume Morin wrote:
> > > I believe commit 614ddad17f22a22e035e2ea37a04815f50362017 (slated for
> > > 5.17) should be queued for all 5.4+ stable branches as it fixes a
> > > serious lockup bug. FWIW I have verified it applies cleanly on all 4
> > > branches.
> > > 
> > > Does that make sense to you?
> > 
> > From a quick glance at v5.4, it looks quite plausible to me.
> > 
> > I do suggest that you try building and testing, given that the hardware's
> > idea of what is plausible overrides that of either of us.  ;-)
> 
> We've had a few dozens lockups on 5.4 and 5.10 due to this bug (what
> lead me to write to you back in Sep). The original bugzilla report is on
> 5.4 as well, see https://bugzilla.kernel.org/show_bug.cgi?id=208685. So
> I am positive that the issue is reachable in both kernels.
> 
> Also I do know for sure it fixes the problem for 5.10. I don't have a
> test rig anymore for 5.4. But considering we know it's reachable with
> 5.4, I think the patch should be applied for 5.4+. Obviously, you're the
> expert here though.

Au contraire!  I do not claim much expertise on -stable validation.

If it was me, I would run a quick touch-test like this from the top-level
directory of the Linux-kernel source tree on a qemu/KVM-capable system:

	tools/testing/selftests/rcutorture/bin/kvm.sh --cpus N --duration 10 --configs "TREE01 TREE04"

Where "N" is replaced by the number of CPUs on your system, which should
preferably be at least eight.

This will take somewhere between 15 minutes and an hour to run, depending
on your system.

Sadly, v5.4 isn't quite as good at analyzing results as are current
versions, but please feel free to send me the output.

Does that help?

							Thanx, Paul
