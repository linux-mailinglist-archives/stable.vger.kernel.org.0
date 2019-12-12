Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4567C11CCE9
	for <lists+stable@lfdr.de>; Thu, 12 Dec 2019 13:19:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729004AbfLLMTN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Dec 2019 07:19:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:33616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728996AbfLLMTN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 12 Dec 2019 07:19:13 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2910D21655;
        Thu, 12 Dec 2019 12:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576153151;
        bh=p2qf2WxMCZ80r4IlvkX/c9qFoi4RW2/vmp+4+l+VMsQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xjElXc3J9L/dqZ1G0YEw7aeTo/aK0g5R3ojmLDp6dGtIzRZrGX0QWYwC6FXUsm409
         3m246qXfsxJHkLzpC97NqIyEn+Ely+NRsYVER45zYZmRnLDwXdHLTMH4xm1sp9hYCw
         Xp0DoQwEyM5ueBNOXl36Oxa7BzzJOBpkFILEN6mw=
Date:   Thu, 12 Dec 2019 13:19:09 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Chen-Yu Tsai <wens@kernel.org>
Cc:     Joerg Roedel <jroedel@suse.de>, stable <stable@vger.kernel.org>,
        Pavel Machek <pavel@denx.de>
Subject: Re: Regression from "mm/vmalloc: Sync unmappings in
 __purge_vmap_area_lazy()" in stable kernels
Message-ID: <20191212121909.GA1541027@kroah.com>
References: <CAGb2v656iHP+6X12gT+Kfc3BkM2w=rU6yfHTk03JgaXrUy02TA@mail.gmail.com>
 <20191212111917.GA1535381@kroah.com>
 <CAGb2v65mNP8g_nBUyjTFLAhP_b3Csb5pq8b2WkE0-OqTDWDyUQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGb2v65mNP8g_nBUyjTFLAhP_b3Csb5pq8b2WkE0-OqTDWDyUQ@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 12, 2019 at 07:31:54PM +0800, Chen-Yu Tsai wrote:
> On Thu, Dec 12, 2019 at 7:19 PM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Thu, Dec 12, 2019 at 06:54:12PM +0800, Chen-Yu Tsai wrote:
> > > Hi,
> > >
> > > I'd like to report a very severe performance regression due to
> > >
> > >     mm/vmalloc: Sync unmappings in __purge_vmap_area_lazy() in stable kernels
> > >
> > > in v4.19.88. I believe this was included since v4.19.67. It is also
> > > in all the other LTS kernels, except 3.16.
> > >
> > > So today I switched an x86_64 production server from v5.1.21 to
> > > v4.19.88, because we kept hitting runaway kcompactd and kswapd.
> > > Plus there was a significant increase in memory usage compared to
> > > v5.1.5. I'm still bisecting that on another production server.
> > >
> > > The service we run is one of the largest forums in Taiwan [1].
> > > It is a terminal-based bulletin board system running over telnet,
> > > SSH or a custom WebSocket bridge. The service itself is the
> > > one-process-per-user type of design from the old days. This
> > > means a lot of forks when there are user spikes or reconnections.
> > >
> > > (Reconnections happen because a lot of people use mobile apps that
> > >  wrap the service, but they get disconnected as soon as they are
> > >  backgrounded.)
> > >
> > > With v4.19.88 we saw a lot of contention on pgd_lock in the process
> > > fork path with CONFIG_VMAP_STACK=y:
> > >
> > > Samples: 937K of event 'cycles:ppp', Event count (approx.): 499112453614
> > >   Children      Self  Command          Shared Object                 Symbol
> > > +   31.15%     0.03%  mbbsd            [kernel.kallsyms]
> > > [k] entry_SYSCALL_64_after_hwframe
> > > +   31.12%     0.02%  mbbsd            [kernel.kallsyms]
> > > [k] do_syscall_64
> > > +   28.12%     0.42%  mbbsd            [kernel.kallsyms]
> > > [k] do_raw_spin_lock
> > > -   27.70%    27.62%  mbbsd            [kernel.kallsyms]
> > > [k] queued_spin_lock_slowpath
> > >    - 18.73% __libc_fork
> > >       - 18.33% entry_SYSCALL_64_after_hwframe
> > >            do_syscall_64
> > >          - _do_fork
> > >             - 18.33% copy_process.part.64
> > >                - 11.00% __vmalloc_node_range
> > >                   - 10.93% sync_global_pgds_l4
> > >                        do_raw_spin_lock
> > >                        queued_spin_lock_slowpath
> > >                - 7.27% mm_init.isra.59
> > >                     pgd_alloc
> > >                     do_raw_spin_lock
> > >                     queued_spin_lock_slowpath
> > >    - 8.68% 0x41fd89415541f689
> > >       - __libc_start_main
> > >          + 7.49% main
> > >          + 0.90% main
> > >
> > > This hit us pretty hard, with the service dropping below one-third
> > > of its original capacity.
> > >
> > > With CONFIG_VMAP_STACK=n, the fork code path skips this, but other
> > > vmalloc users are still affected. One other area is the tty layer.
> > > This also causes problems for us since there can be as many as 15k
> > > users over SSH, some coming and going. So we got a lot of hung sshd
> > > processes as well. Unfortunately I don't have any perf reports or
> > > kernel logs to go with.
> > >
> > > Now I understand that there is already a fix in -next:
> > >
> > >     https://lore.kernel.org/patchwork/patch/1137341/
> > >
> > > However the code has changed a lot in mainline and I'm not sure how
> > > to backport this. For now I just reverted the commit by hand by
> > > removing the offending code. Seems to work OK, and based on the commit
> > > logs I guess it's safe to do so, as we're not running X86-32 or PTI.
> >
> > The above commit should resolve the issue for you, can you try it out on
> > 5.4?  And any reason you have to stick with the old 4.19 kernel?
> 
> We typically run new kernels on the other server (the one I'm currently
> doing git bisect on) for a couple weeks before running it on our main
> server. That one doesn't see nearly as much load though. Also because
> of the increased memory usage I was seeing in 5.1.21, I wasn't
> particularly comfortable going directly to 5.4.
> 
> I suppose the reason for being overly cautious is that the server is a
> pain to reboot. The service is monolithic, running on just the one server.
> And any significant downtime _always_ hits the local newspapers. Combined
> with the upcoming election, conspiracy theories start flying around. :(
> Now that it looks stable, we probably won't be testing anything new until
> mid-January.

Fair enough, good luck!

greg k-h
