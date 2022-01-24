Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D5CE498880
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 19:42:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239661AbiAXSmW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 13:42:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235886AbiAXSmV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 13:42:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AD0DC06173B
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 10:42:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4AC11B81215
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 18:42:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 524B3C340E7;
        Mon, 24 Jan 2022 18:42:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643049739;
        bh=FChLJuEdZiVrRPLpJhYptDYIJ9y3yA/t9jFgIlCn7Is=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hEudl06vywebqied8jMGMgXXZqJaldppb4uUSCaLCt9cLHQPWdUaWDTZ7UwQqi8E6
         La2GPfPn/30qIc++QhCf1x67oNXT3LOzfYQCne5AQoSbIITy5yGQceTvH2JgUsjJOJ
         5G4DNwp0dYKj/yadyNiBMEZaNRG/Mx5cuYI46MtU=
Date:   Mon, 24 Jan 2022 19:16:38 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Guillaume Morin <guillaume@morinfr.org>
Cc:     "Paul E. McKenney" <paulmck@kernel.org>, stable@vger.kernel.org,
        neelx@redhat.com
Subject: Re: [PATCH for stable 5.x] rcu: Tighten rcu_advance_cbs_nowake()
 checks
Message-ID: <Ye7tBsN3s+mm3eT4@kroah.com>
References: <YemwBdpmBeC03JeT@bender.morinfr.org>
 <20220120191600.GP947480@paulmck-ThinkPad-P17-Gen-1>
 <Yem3fsHWahJEvjsk@bender.morinfr.org>
 <20220120205705.GQ947480@paulmck-ThinkPad-P17-Gen-1>
 <YengcErT48sYK0yL@bender.morinfr.org>
 <20220120233331.GS947480@paulmck-ThinkPad-P17-Gen-1>
 <Ye7sJ+7szTW0mKYd@bender.morinfr.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ye7sJ+7szTW0mKYd@bender.morinfr.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 24, 2022 at 07:12:55PM +0100, Guillaume Morin wrote:
> On 20 Jan 15:33, Paul E. McKenney wrote:
> > > ---- TREE01 8: Kernel present. Thu 20 Jan 2022 05:03:55 PM EST
> > > ---- TREE04 8: Kernel present. Thu 20 Jan 2022 05:03:55 PM EST
> > > ---- Starting kernels. Thu 20 Jan 2022 05:03:55 PM EST
> > > ---- All kernel runs complete. Thu 20 Jan 2022 05:14:05 PM EST
> > > ---- TREE01 8: Build/run results:
> > >  --- Thu 20 Jan 2022 05:02:37 PM EST: Starting build
> > >  --- Thu 20 Jan 2022 05:03:55 PM EST: Starting kernel
> > > CPU-hotplug kernel, adding rcutorture onoff.
> > > Monitoring qemu job at pid 46081
> > > Grace period for qemu job at pid 46081
> > > ---- TREE04 8: Build/run results:
> > >  --- Thu 20 Jan 2022 05:03:16 PM EST: Starting build
> > > :CONFIG_HOTPLUG_CPU: improperly set
> > >  --- Thu 20 Jan 2022 05:03:55 PM EST: Starting kernel
> > > CPU-hotplug kernel, adding rcutorture onoff.
> > > Monitoring qemu job at pid 45847
> > > Grace period for qemu job at pid 45847
> > > 
> > > 
> > >  --- Thu 20 Jan 2022 05:02:37 PM EST Test summary:
> > > Results directory: /usr/scratch/kernel/tools/testing/selftests/rcutorture/res/2022.01.20-17:02:37
> > > tools/testing/selftests/rcutorture/bin/kvm.sh --cpus 60 --duration 10 --configs TREE01 TREE04
> > > TREE01 ------- 12719 GPs (21.1983/s) [rcu: g94609 f0x0 ]
> > > TREE04 ------- 3128 GPs (5.21333/s) [rcu: g23621 f0x0 ]
> > > :CONFIG_HOTPLUG_CPU: improperly set
> > 
> > This run was successful, so good!
> 
> Greg, so could you please queue up
> 614ddad17f22a22e035e2ea37a04815f50362017 for 5.4+ stable branches?

Will do after this next round is out, thanks.

greg k-h
