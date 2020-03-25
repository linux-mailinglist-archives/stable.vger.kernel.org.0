Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52AE8192521
	for <lists+stable@lfdr.de>; Wed, 25 Mar 2020 11:07:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726103AbgCYKHl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Mar 2020 06:07:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:37686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726043AbgCYKHl (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 25 Mar 2020 06:07:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 622082077D;
        Wed, 25 Mar 2020 10:07:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585130860;
        bh=LlBkz1Uz0Po1b07BApsFzd2kMROaDUHTi2EMx+A2LFc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hEFQD3NlvWZHEqcpf6kr2/JRP+mYs2HhfBrSsJ/FcDmtl6c5WVfg+gPZDGkisSNNG
         Jd27AFBmay/KyAG2PCSf4OgPc5knaF9/WBh+aJz8G3GSyvjVc5lbeM6VfzxGWsQltE
         uUGMYw2bXc7eZ9+dV9eFwY4toPdtHnwQwRXJLkaY=
Date:   Wed, 25 Mar 2020 11:07:36 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Rantala, Tommi T. (Nokia - FI/Espoo)" <tommi.t.rantala@nokia.com>
Cc:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "osandov@fb.com" <osandov@fb.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Subject: Re: 4.19 LTS high /proc/diskstats io_ticks
Message-ID: <20200325100736.GA3083079@kroah.com>
References: <564f7f3718cdc85f841d27a358a43aee4ca239d6.camel@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <564f7f3718cdc85f841d27a358a43aee4ca239d6.camel@nokia.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 25, 2020 at 10:02:41AM +0000, Rantala, Tommi T. (Nokia - FI/Espoo) wrote:
> Hi,
> 
> Tools like sar and iostat are reporting abnormally high %util with 4.19.y
> running in VM (the disk is almost idle):
> 
>   $ sar -dp
>   Linux 4.19.107-1.x86_64   03/25/20    _x86_64_   (6 CPU)
> 
>   00:00:00        DEV       tps      ...     %util
>   00:10:00        vda      0.55      ...     98.07
>   ...
>   10:00:00        vda      0.44      ...     99.74
>   Average:        vda      0.48      ...     98.98
> 
> The numbers look reasonable for the partition:
> 
>   # iostat -x -p ALL 1 1
>   Linux 4.19.107-1.x86_64   03/25/20    _x86_64_  (6 CPU)
> 
>   avg-cpu:  %user   %nice %system %iowait  %steal   %idle
>             10.51    0.00    8.58    0.05    0.11   80.75
> 
>   Device            r/s     ...  %util
>   vda              0.02     ...  98.25
>   vda1             0.01     ...   0.09
> 
> 
> Lots of io_ticks in /proc/diskstats:
> 
> # cat /proc/uptime
> 45787.03 229321.29
> 
> # grep vda /proc/diskstats
>  253      0 vda 760 0 38498 731 28165 43212 1462928 157514 0 44690263
> 44812032 0 0 0 0
>  253      1 vda1 350 0 19074 293 26169 43212 1462912 154931 0 41560 150998
> 0 0 0 0
> 
> 
> Other people are apparently seeing this too with 4.19:
> https://kudzia.eu/b/2019/09/iostat-x-1-reporting-100-utilization-of-nearly-idle-nvme-drives/
> 
> 
> I also see this only in 4.19.y and bisected to this (based on the Fixes
> tag, this should have been taken to 4.14 too...):
> 
> commit 6131837b1de66116459ef4413e26fdbc70d066dc
> Author: Omar Sandoval <osandov@fb.com>
> Date:   Thu Apr 26 00:21:58 2018 -0700
> 
>   blk-mq: count allocated but not started requests in iostats inflight
> 
>   In the legacy block case, we increment the counter right after we
>   allocate the request, not when the driver handles it. In both the legacy
>   and blk-mq cases, part_inc_in_flight() is called from
>   blk_account_io_start() right after we've allocated the request. blk-mq
>   only considers requests started requests as inflight, but this is
>   inconsistent with the legacy definition and the intention in the code.
>   This removes the started condition and instead counts all allocated
>   requests.
> 
>   Fixes: f299b7c7a9de ("blk-mq: provide internal in-flight variant")
>   Signed-off-by: Omar Sandoval <osandov@fb.com>
>   Signed-off-by: Jens Axboe <axboe@kernel.dk>
> 
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index c3621453ad87..5450cbc61f8d 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -95,18 +95,15 @@ static void blk_mq_check_inflight(struct blk_mq_hw_ctx
> *hctx,
>  {
>         struct mq_inflight *mi = priv;
>  
> -       if (blk_mq_rq_state(rq) == MQ_RQ_IN_FLIGHT) {
> -               /*
> -                * index[0] counts the specific partition that was asked
> -                * for. index[1] counts the ones that are active on the
> -                * whole device, so increment that if mi->part is indeed
> -                * a partition, and not a whole device.
> -                */
> -               if (rq->part == mi->part)
> -                       mi->inflight[0]++;
> -               if (mi->part->partno)
> -                       mi->inflight[1]++;
> -       }
> +       /*
> +        * index[0] counts the specific partition that was asked for.
> index[1]
> +        * counts the ones that are active on the whole device, so
> increment
> +        * that if mi->part is indeed a partition, and not a whole device.
> +        */
> +       if (rq->part == mi->part)
> +               mi->inflight[0]++;
> +       if (mi->part->partno)
> +               mi->inflight[1]++;
>  }
>  
>  void blk_mq_in_flight(struct request_queue *q, struct hd_struct *part,
> 
> 
> 
> If I get it right, when the disk is idle, and some request is allocated,
> part_round_stats() with this commit will now add all ticks between
> previous I/O and current time (now - part->stamp) to io_ticks.
> 
> Before the commit, part_round_stats() would only update part->stamp when
> called after request allocation.

So this is a "false" reporting?  there's really no load?

> Any thoughts how to best fix this in 4.19?
> I see the io_ticks accounting has been reworked in 5.0, do we need to
> backport those to 4.19, or any ill effects if this commit is reverted in
> 4.19?

Do you see this issue in 5.4?  What's keeping you from moving to 5.4.y?

And if this isn't a real issue, is that a problem too?

As you can test this, if you have a set of patches backported that could
resolve it, can you send them to us?

thanks,

greg k-h
