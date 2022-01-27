Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88D2749E618
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 16:31:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234952AbiA0PbN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 10:31:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229985AbiA0PbM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 10:31:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A77C1C061714
        for <stable@vger.kernel.org>; Thu, 27 Jan 2022 07:31:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4555961651
        for <stable@vger.kernel.org>; Thu, 27 Jan 2022 15:31:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D456C340E4;
        Thu, 27 Jan 2022 15:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643297471;
        bh=T8zYoyi5Yz0ZFL0ZoyyFWxFboZwXGjU2QcAO91L3Re8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qn1xoVk57VSoxjR4/NLqo0drz3n8bpRVUKhMA0IQjtb945wFTvDQCyK/aeQe4/FG9
         1UwKfXUWfqCPFs7ZE0XI/L/LAFgI6ZhN6+Hs54JqsUtlXbGNKkX7GgLW1QtwnqII4L
         FQWSSYUz0Ntc5pXlG1/4zS2U0Dcu8wco879d1jHA=
Date:   Thu, 27 Jan 2022 16:31:08 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Guillaume Morin <guillaume@morinfr.org>
Cc:     "Paul E. McKenney" <paulmck@kernel.org>, stable@vger.kernel.org,
        neelx@redhat.com
Subject: Re: [PATCH for stable 5.x] rcu: Tighten rcu_advance_cbs_nowake()
 checks
Message-ID: <YfK6vMMc3ncb3ECC@kroah.com>
References: <YemwBdpmBeC03JeT@bender.morinfr.org>
 <20220120191600.GP947480@paulmck-ThinkPad-P17-Gen-1>
 <Yem3fsHWahJEvjsk@bender.morinfr.org>
 <20220120205705.GQ947480@paulmck-ThinkPad-P17-Gen-1>
 <YengcErT48sYK0yL@bender.morinfr.org>
 <20220120233331.GS947480@paulmck-ThinkPad-P17-Gen-1>
 <Ye7sJ+7szTW0mKYd@bender.morinfr.org>
 <Ye7tBsN3s+mm3eT4@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ye7tBsN3s+mm3eT4@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 24, 2022 at 07:16:38PM +0100, Greg KH wrote:
> On Mon, Jan 24, 2022 at 07:12:55PM +0100, Guillaume Morin wrote:
> > On 20 Jan 15:33, Paul E. McKenney wrote:
> > > > ---- TREE01 8: Kernel present. Thu 20 Jan 2022 05:03:55 PM EST
> > > > ---- TREE04 8: Kernel present. Thu 20 Jan 2022 05:03:55 PM EST
> > > > ---- Starting kernels. Thu 20 Jan 2022 05:03:55 PM EST
> > > > ---- All kernel runs complete. Thu 20 Jan 2022 05:14:05 PM EST
> > > > ---- TREE01 8: Build/run results:
> > > >  --- Thu 20 Jan 2022 05:02:37 PM EST: Starting build
> > > >  --- Thu 20 Jan 2022 05:03:55 PM EST: Starting kernel
> > > > CPU-hotplug kernel, adding rcutorture onoff.
> > > > Monitoring qemu job at pid 46081
> > > > Grace period for qemu job at pid 46081
> > > > ---- TREE04 8: Build/run results:
> > > >  --- Thu 20 Jan 2022 05:03:16 PM EST: Starting build
> > > > :CONFIG_HOTPLUG_CPU: improperly set
> > > >  --- Thu 20 Jan 2022 05:03:55 PM EST: Starting kernel
> > > > CPU-hotplug kernel, adding rcutorture onoff.
> > > > Monitoring qemu job at pid 45847
> > > > Grace period for qemu job at pid 45847
> > > > 
> > > > 
> > > >  --- Thu 20 Jan 2022 05:02:37 PM EST Test summary:
> > > > Results directory: /usr/scratch/kernel/tools/testing/selftests/rcutorture/res/2022.01.20-17:02:37
> > > > tools/testing/selftests/rcutorture/bin/kvm.sh --cpus 60 --duration 10 --configs TREE01 TREE04
> > > > TREE01 ------- 12719 GPs (21.1983/s) [rcu: g94609 f0x0 ]
> > > > TREE04 ------- 3128 GPs (5.21333/s) [rcu: g23621 f0x0 ]
> > > > :CONFIG_HOTPLUG_CPU: improperly set
> > > 
> > > This run was successful, so good!
> > 
> > Greg, so could you please queue up
> > 614ddad17f22a22e035e2ea37a04815f50362017 for 5.4+ stable branches?
> 
> Will do after this next round is out, thanks.

Now queued up,t hanks.

gre gk-h
