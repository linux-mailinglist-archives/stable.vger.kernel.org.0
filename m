Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 978F311CC42
	for <lists+stable@lfdr.de>; Thu, 12 Dec 2019 12:32:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728860AbfLLLcL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Dec 2019 06:32:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:36824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728501AbfLLLcK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 12 Dec 2019 06:32:10 -0500
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C7D1D22B48
        for <stable@vger.kernel.org>; Thu, 12 Dec 2019 11:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576150330;
        bh=5+kyBUw1HR38MRgRSc0bINfX+JFY2SGZsG5niWUjPFM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Jiw7fA+lBGiCxA+6N6oBaYYZ8rvj//5ih4pWRtB4sVw8hnKElX0EEWOY4zLul4EFR
         aw6x9OswNJ1zm9aD4oL/++8b3iI1wchCrpTTg1JTXBSIaxHkiX0ACCYYaiuXHJm6je
         bSOH7dgfwruZGm/1oQZR/Idd/ZATkDEOlfjRSMNg=
Received: by mail-wr1-f51.google.com with SMTP id c9so2333685wrw.8
        for <stable@vger.kernel.org>; Thu, 12 Dec 2019 03:32:09 -0800 (PST)
X-Gm-Message-State: APjAAAVXGAumQiNIyGD5MLOLfj2RCshM1YFQDuCFzDVTMnKeUiZGbt4d
        PZsa5Wx6hjUYplHuUNyitOshjtQ9dqEkXKrrWP8=
X-Google-Smtp-Source: APXvYqwrGGtw8imTxuFzUBydkTdqIZ2q4ZkPszx+6lFsWuTDiJT/kTu3AUBJvmdoIa0TNjK+bR+/kqtI0gZl9nlGyKA=
X-Received: by 2002:adf:81e3:: with SMTP id 90mr5697376wra.23.1576150328231;
 Thu, 12 Dec 2019 03:32:08 -0800 (PST)
MIME-Version: 1.0
References: <CAGb2v656iHP+6X12gT+Kfc3BkM2w=rU6yfHTk03JgaXrUy02TA@mail.gmail.com>
 <20191212111917.GA1535381@kroah.com>
In-Reply-To: <20191212111917.GA1535381@kroah.com>
From:   Chen-Yu Tsai <wens@kernel.org>
Date:   Thu, 12 Dec 2019 19:31:54 +0800
X-Gmail-Original-Message-ID: <CAGb2v65mNP8g_nBUyjTFLAhP_b3Csb5pq8b2WkE0-OqTDWDyUQ@mail.gmail.com>
Message-ID: <CAGb2v65mNP8g_nBUyjTFLAhP_b3Csb5pq8b2WkE0-OqTDWDyUQ@mail.gmail.com>
Subject: Re: Regression from "mm/vmalloc: Sync unmappings in
 __purge_vmap_area_lazy()" in stable kernels
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Chen-Yu Tsai <wens@kernel.org>, Joerg Roedel <jroedel@suse.de>,
        stable <stable@vger.kernel.org>, Pavel Machek <pavel@denx.de>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 12, 2019 at 7:19 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Thu, Dec 12, 2019 at 06:54:12PM +0800, Chen-Yu Tsai wrote:
> > Hi,
> >
> > I'd like to report a very severe performance regression due to
> >
> >     mm/vmalloc: Sync unmappings in __purge_vmap_area_lazy() in stable kernels
> >
> > in v4.19.88. I believe this was included since v4.19.67. It is also
> > in all the other LTS kernels, except 3.16.
> >
> > So today I switched an x86_64 production server from v5.1.21 to
> > v4.19.88, because we kept hitting runaway kcompactd and kswapd.
> > Plus there was a significant increase in memory usage compared to
> > v5.1.5. I'm still bisecting that on another production server.
> >
> > The service we run is one of the largest forums in Taiwan [1].
> > It is a terminal-based bulletin board system running over telnet,
> > SSH or a custom WebSocket bridge. The service itself is the
> > one-process-per-user type of design from the old days. This
> > means a lot of forks when there are user spikes or reconnections.
> >
> > (Reconnections happen because a lot of people use mobile apps that
> >  wrap the service, but they get disconnected as soon as they are
> >  backgrounded.)
> >
> > With v4.19.88 we saw a lot of contention on pgd_lock in the process
> > fork path with CONFIG_VMAP_STACK=y:
> >
> > Samples: 937K of event 'cycles:ppp', Event count (approx.): 499112453614
> >   Children      Self  Command          Shared Object                 Symbol
> > +   31.15%     0.03%  mbbsd            [kernel.kallsyms]
> > [k] entry_SYSCALL_64_after_hwframe
> > +   31.12%     0.02%  mbbsd            [kernel.kallsyms]
> > [k] do_syscall_64
> > +   28.12%     0.42%  mbbsd            [kernel.kallsyms]
> > [k] do_raw_spin_lock
> > -   27.70%    27.62%  mbbsd            [kernel.kallsyms]
> > [k] queued_spin_lock_slowpath
> >    - 18.73% __libc_fork
> >       - 18.33% entry_SYSCALL_64_after_hwframe
> >            do_syscall_64
> >          - _do_fork
> >             - 18.33% copy_process.part.64
> >                - 11.00% __vmalloc_node_range
> >                   - 10.93% sync_global_pgds_l4
> >                        do_raw_spin_lock
> >                        queued_spin_lock_slowpath
> >                - 7.27% mm_init.isra.59
> >                     pgd_alloc
> >                     do_raw_spin_lock
> >                     queued_spin_lock_slowpath
> >    - 8.68% 0x41fd89415541f689
> >       - __libc_start_main
> >          + 7.49% main
> >          + 0.90% main
> >
> > This hit us pretty hard, with the service dropping below one-third
> > of its original capacity.
> >
> > With CONFIG_VMAP_STACK=n, the fork code path skips this, but other
> > vmalloc users are still affected. One other area is the tty layer.
> > This also causes problems for us since there can be as many as 15k
> > users over SSH, some coming and going. So we got a lot of hung sshd
> > processes as well. Unfortunately I don't have any perf reports or
> > kernel logs to go with.
> >
> > Now I understand that there is already a fix in -next:
> >
> >     https://lore.kernel.org/patchwork/patch/1137341/
> >
> > However the code has changed a lot in mainline and I'm not sure how
> > to backport this. For now I just reverted the commit by hand by
> > removing the offending code. Seems to work OK, and based on the commit
> > logs I guess it's safe to do so, as we're not running X86-32 or PTI.
>
> The above commit should resolve the issue for you, can you try it out on
> 5.4?  And any reason you have to stick with the old 4.19 kernel?

We typically run new kernels on the other server (the one I'm currently
doing git bisect on) for a couple weeks before running it on our main
server. That one doesn't see nearly as much load though. Also because
of the increased memory usage I was seeing in 5.1.21, I wasn't
particularly comfortable going directly to 5.4.

I suppose the reason for being overly cautious is that the server is a
pain to reboot. The service is monolithic, running on just the one server.
And any significant downtime _always_ hits the local newspapers. Combined
with the upcoming election, conspiracy theories start flying around. :(
Now that it looks stable, we probably won't be testing anything new until
mid-January.


ChenYu
