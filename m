Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE03611CC0F
	for <lists+stable@lfdr.de>; Thu, 12 Dec 2019 12:19:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728725AbfLLLTQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Dec 2019 06:19:16 -0500
Received: from mx2.suse.de ([195.135.220.15]:46256 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728722AbfLLLTQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 12 Dec 2019 06:19:16 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6B5CCAD6C;
        Thu, 12 Dec 2019 11:19:13 +0000 (UTC)
Date:   Thu, 12 Dec 2019 12:19:11 +0100
From:   Joerg Roedel <jroedel@suse.de>
To:     Chen-Yu Tsai <wens@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>, Pavel Machek <pavel@denx.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Regression from "mm/vmalloc: Sync unmappings in
 __purge_vmap_area_lazy()" in stable kernels
Message-ID: <20191212111911.GH4477@suse.de>
References: <CAGb2v656iHP+6X12gT+Kfc3BkM2w=rU6yfHTk03JgaXrUy02TA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGb2v656iHP+6X12gT+Kfc3BkM2w=rU6yfHTk03JgaXrUy02TA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Thu, Dec 12, 2019 at 06:54:12PM +0800, Chen-Yu Tsai wrote:
> I'd like to report a very severe performance regression due to
> 
>     mm/vmalloc: Sync unmappings in __purge_vmap_area_lazy() in stable kernels

Yes, that is a known problem, with a couple of reports already in the
past months. And I posted a fix from which I thought it is on its way
upstream, but apparently its not:

	https://lore.kernel.org/lkml/20191009124418.8286-1-joro@8bytes.org/

Adding Andrew and the x86 maintainers to Cc.

Regards,

	Joerg

> 
> in v4.19.88. I believe this was included since v4.19.67. It is also
> in all the other LTS kernels, except 3.16.
> 
> So today I switched an x86_64 production server from v5.1.21 to
> v4.19.88, because we kept hitting runaway kcompactd and kswapd.
> Plus there was a significant increase in memory usage compared to
> v5.1.5. I'm still bisecting that on another production server.
> 
> The service we run is one of the largest forums in Taiwan [1].
> It is a terminal-based bulletin board system running over telnet,
> SSH or a custom WebSocket bridge. The service itself is the
> one-process-per-user type of design from the old days. This
> means a lot of forks when there are user spikes or reconnections.
> 
> (Reconnections happen because a lot of people use mobile apps that
>  wrap the service, but they get disconnected as soon as they are
>  backgrounded.)
> 
> With v4.19.88 we saw a lot of contention on pgd_lock in the process
> fork path with CONFIG_VMAP_STACK=y:
> 
> Samples: 937K of event 'cycles:ppp', Event count (approx.): 499112453614
>   Children      Self  Command          Shared Object                 Symbol
> +   31.15%     0.03%  mbbsd            [kernel.kallsyms]
> [k] entry_SYSCALL_64_after_hwframe
> +   31.12%     0.02%  mbbsd            [kernel.kallsyms]
> [k] do_syscall_64
> +   28.12%     0.42%  mbbsd            [kernel.kallsyms]
> [k] do_raw_spin_lock
> -   27.70%    27.62%  mbbsd            [kernel.kallsyms]
> [k] queued_spin_lock_slowpath
>    - 18.73% __libc_fork
>       - 18.33% entry_SYSCALL_64_after_hwframe
>            do_syscall_64
>          - _do_fork
>             - 18.33% copy_process.part.64
>                - 11.00% __vmalloc_node_range
>                   - 10.93% sync_global_pgds_l4
>                        do_raw_spin_lock
>                        queued_spin_lock_slowpath
>                - 7.27% mm_init.isra.59
>                     pgd_alloc
>                     do_raw_spin_lock
>                     queued_spin_lock_slowpath
>    - 8.68% 0x41fd89415541f689
>       - __libc_start_main
>          + 7.49% main
>          + 0.90% main
> 
> This hit us pretty hard, with the service dropping below one-third
> of its original capacity.
> 
> With CONFIG_VMAP_STACK=n, the fork code path skips this, but other
> vmalloc users are still affected. One other area is the tty layer.
> This also causes problems for us since there can be as many as 15k
> users over SSH, some coming and going. So we got a lot of hung sshd
> processes as well. Unfortunately I don't have any perf reports or
> kernel logs to go with.
> 
> Now I understand that there is already a fix in -next:
> 
>     https://lore.kernel.org/patchwork/patch/1137341/
> 
> However the code has changed a lot in mainline and I'm not sure how
> to backport this. For now I just reverted the commit by hand by
> removing the offending code. Seems to work OK, and based on the commit
> logs I guess it's safe to do so, as we're not running X86-32 or PTI.
> 
> 
> Regards
> ChenYu
> 
> [1] https://en.wikipedia.org/wiki/PTT_Bulletin_Board_System
