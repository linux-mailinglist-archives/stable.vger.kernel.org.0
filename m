Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 562D748DC05
	for <lists+stable@lfdr.de>; Thu, 13 Jan 2022 17:39:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbiAMQj4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jan 2022 11:39:56 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:52546 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232248AbiAMQj4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jan 2022 11:39:56 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 53E891F387;
        Thu, 13 Jan 2022 16:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1642091995; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zLi43417r/Ydda0q+KZJ20+RoX1pVLaWxxQg2+ndhNw=;
        b=RuT8jRNZFb7jUUrctX7Azpwy+7P/jm3IwAjPN2y8J43tdYUy+S4RqaEKGc9vEIodHLjxsa
        SR62L12z/d/2Z3tUxNk9DpwgtBvBiQgAtPFDiJVGDW7C76tyZuMzkA/l07020yXrrHJHQG
        HznKAmosN+HI5q7QHtbF/pMT16L//lI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1642091995;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zLi43417r/Ydda0q+KZJ20+RoX1pVLaWxxQg2+ndhNw=;
        b=pA8xlPR72Z55oc+JOYBbBEvI4xNFSXDXUhzLDHdj+kFgqherMQdHPx0s2Mr11/yZ1Tm7iF
        19nxxVFa2gJ7MRCg==
Received: from quack3.suse.cz (unknown [10.163.28.18])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 3390CA3B8D;
        Thu, 13 Jan 2022 16:39:55 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 9D51CA05E2; Thu, 13 Jan 2022 17:39:51 +0100 (CET)
Date:   Thu, 13 Jan 2022 17:39:51 +0100
From:   Jan Kara <jack@suse.cz>
To:     "yukuai (C)" <yukuai3@huawei.com>
Cc:     Jan Kara <jack@suse.cz>, linux-block@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>,
        Paolo Valente <paolo.valente@linaro.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH 3/4] bfq: Split shared queues on move between cgroups
Message-ID: <20220113163951.tahsb2st4bqzqoco@quack3.lan>
References: <20220112113529.6355-1-jack@suse.cz>
 <20220112113928.32349-3-jack@suse.cz>
 <3d831e07-61d5-b28b-9886-05f01ede7745@huawei.com>
 <29ab0879-b0d3-f235-bd1e-a8af71e8974f@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <29ab0879-b0d3-f235-bd1e-a8af71e8974f@huawei.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu 13-01-22 15:08:50, yukuai (C) wrote:
> 在 2022/01/13 11:57, yukuai (C) 写道:
> > 在 2022/01/12 19:39, Jan Kara 写道:
> > > When bfqq is shared by multiple processes it can happen that one of the
> > > processes gets moved to a different cgroup (or just starts submitting IO
> > > for different cgroup). In case that happens we need to split the merged
> > > bfqq as otherwise we will have IO for multiple cgroups in one bfqq and
> > > we will just account IO time to wrong entities etc.
> > > 
> > > Similarly if the bfqq is scheduled to merge with another bfqq but the
> > > merge didn't happen yet, cancel the merge as it need not be valid
> > > anymore.
> > > 
> > > CC: stable@vger.kernel.org
> > > Fixes: e21b7a0b9887 ("block, bfq: add full hierarchical scheduling
> > > and cgroups support")
> > > Signed-off-by: Jan Kara <jack@suse.cz>
> > > ---
> > >   block/bfq-cgroup.c  | 25 ++++++++++++++++++++++++-
> > >   block/bfq-iosched.c |  2 +-
> > >   block/bfq-iosched.h |  1 +
> > >   3 files changed, 26 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
> > > index 24a5c5329bcd..dbc117e00783 100644
> > > --- a/block/bfq-cgroup.c
> > > +++ b/block/bfq-cgroup.c
> > > @@ -730,8 +730,31 @@ static struct bfq_group
> > > *__bfq_bic_change_cgroup(struct bfq_data *bfqd,
> > >       if (sync_bfqq) {
> > >           entity = &sync_bfqq->entity;
> > > -        if (entity->sched_data != &bfqg->sched_data)
> > > +        if (entity->sched_data != &bfqg->sched_data) {
> > > +            /*
> > > +             * Was the queue we use merged to a different queue?
> > > +             * Detach process from the queue as merge need not be
> > > +             * valid anymore. We cannot easily cancel the merge as
> > > +             * there may be other processes scheduled to this
> > > +             * queue.
> > > +             */
> > > +            if (sync_bfqq->new_bfqq) {
> > > +                bfq_put_cooperator(sync_bfqq);
> > Hi,
> > 
> > The patch " bfq: Simplify bfq_put_cooperator()" in last version is not
> > in this patch set, thus bfq_put_cooperator() won't set
> > sync_bfqq->new_bfqq to NULL. So I guess the problem still exist?
> > 
> > Thanks,
> > Kuai
> > > +                bfq_release_process_ref(bfqd, sync_bfqq);
> > > +                bic_set_bfqq(bic, NULL, 1);
> Hi,
> 
> I understand now that you set NULL here,

Yes.

> however I still can repoduce
> the problem with this patch set applied.

OK.

> Here I add some debug message:
> 
> diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
> index dbc117e00783..2d3da8e73ec0 100644
> --- a/block/bfq-cgroup.c
> +++ b/block/bfq-cgroup.c
> @@ -754,6 +754,7 @@ static struct bfq_group *__bfq_bic_change_cgroup(struct
> bfq_data *bfqd,
>                                 bfq_mark_bfqq_split_coop(sync_bfqq);
>                         }
>                         bfq_bfqq_move(bfqd, sync_bfqq, bfqg);
> +                       printk("%s: bfqq %px move to %px\n", __func__,
> sync_bfqq, bfqg);
>                 }
>         }
> 
> diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
> index 07be51bc229b..74d5b575626f 100644
> --- a/block/bfq-iosched.c
> +++ b/block/bfq-iosched.c
> @@ -2797,6 +2797,7 @@ bfq_setup_merge(struct bfq_queue *bfqq, struct
> bfq_queue *new_bfqq)
>          * are likely to increase the throughput.
>          */
>         bfqq->new_bfqq = new_bfqq;
> +       printk("%s: bfqq %px new_bfqq %px bfqg %px\n", __func__, bfqq,
> new_bfqq, bfqq_group(bfqq));
>         new_bfqq->ref += process_refs;
>         return new_bfqq;
>  }
> @@ -2963,8 +2964,14 @@ bfq_setup_cooperator(struct bfq_data *bfqd, struct
> bfq_queue *bfqq,
>         if (bfq_too_late_for_merging(bfqq))
>                 return NULL;
> 
> -       if (bfqq->new_bfqq)
> +       if (bfqq->new_bfqq) {
> +               if (bfqq->entity.parent != bfqq->new_bfqq->entity.parent) {
> +                       printk("%s: bfqq %px (%px), new_bfqq %px (%px)\n",
> __func__,
> +                                       bfqq, bfqq_group(bfqq),
> bfqq->new_bfqq, bfqq_group(bfqq->new_bfqq));
> +                       BUG_ON(1);
> +               }
>                 return bfqq->new_bfqq;
> +       }
> 
>         if (!io_struct || unlikely(bfqq == &bfqd->oom_bfqq))
>                 return NULL;
> 
> And here is the messages when BUG_ON is triggered（much easier than the
> uaf problem):
> 
> [  157.237821] bfq_setup_merge: bfqq ffff888140654dc0 new_bfqq
> ffff888174122100 bfqg ffff88817abc6000
> [  157.238739] __bfq_bic_change_cgroup: bfqq ffff888174122100 move to
> ffff888104b7c000
> [  157.239675] bfq_setup_cooperator: bfqq ffff888140654dc0
> (ffff88817abc6000), new_bfqq ffff888174122100 (ffff888104b7c000)

Thanks for the debugging! So this shows that it is not 'bfqq' that changed
parent but rather bfqq->new_bfqq that changed parent. And presumably it can
even happen that the bfqq->new_bfqq parent gets offlined and UAF eventually
triggered. Indeed, I didn't think about that possibility. I have to think
how to handle this in the best way...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
