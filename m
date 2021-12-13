Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE1FB472FCF
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 15:52:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234562AbhLMOwd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 09:52:33 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:54354 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231349AbhLMOwc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 09:52:32 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 652251F3BA;
        Mon, 13 Dec 2021 14:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1639407151; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=43M2it8+IRN7ztvN3MVNcuqsPzC82xu3mXqH42vHp/w=;
        b=Bha888jUF49BJg0Yx/Q2f/dGOpxdG07cUjW1uJEJAbPnAhE5vYIuAMYgFDrCLxrUFVgn5k
        2m0DLn6v0cYFG+CBwFFnAxOnkQ5BkSuRMuZHfgymNj2+XcGIGBpiWwQlZOHOeSh6bjzYjb
        mioZYYjS/7OFMlp6W0oRsML6QT48u5Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1639407151;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=43M2it8+IRN7ztvN3MVNcuqsPzC82xu3mXqH42vHp/w=;
        b=7a+4nkwTbIc+ynCyI7UiIhiu18ei2lYqSvxWypfGadh8I+0X1w4tkbpz4vsa0cVIkLIYuT
        jzUxR55YuV4L5uBg==
Received: from quack2.suse.cz (unknown [10.163.28.18])
        by relay2.suse.de (Postfix) with ESMTP id 53D7DA3B8C;
        Mon, 13 Dec 2021 14:52:31 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 2E3431E11F3; Mon, 13 Dec 2021 15:52:31 +0100 (CET)
Date:   Mon, 13 Dec 2021 15:52:31 +0100
From:   Jan Kara <jack@suse.cz>
To:     Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Cc:     Jan Kara <jack@suse.cz>, Paolo Valente <paolo.valente@linaro.org>,
        Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        fvogt@suse.de, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org,
        stable@vger.kernel.org, Fabian Vogt <fvogt@suse.com>
Subject: Re: [PATCH] bfq: Fix use-after-free with cgroups
Message-ID: <20211213145231.GD14044@quack2.suse.cz>
References: <20211201133439.3309-1-jack@suse.cz>
 <20211207190843.GA40898@blackbody.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211207190843.GA40898@blackbody.suse.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue 07-12-21 20:08:43, Michal Koutný wrote:
> On Wed, Dec 01, 2021 at 02:34:39PM +0100, Jan Kara <jack@suse.cz> wrote:
> > After some analysis we've found out that the culprit of the problem is
> > that some task is reparented from cgroup G to the root cgroup and G is
> > offlined.
> 
> Just sharing my interpretation for context -- (I saw this was a system
> using the unified cgroup hierarchy, io_cgrp_subsys_on_dfl_key was
> enabled) and what was observed could also have been disabling the io
> controller on given level -- that would also manifest similarly -- the
> task is migrated to parent and the former blkcg is offlined.

Yes, that's another possibility.

> > +static void bfq_reparent_children(struct bfq_data *bfqd, struct bfq_group *bfqg)
> > [...]
> > -	bfq_bfqq_move(bfqd, bfqq, bfqd->root_group);
> > [...]
> > +	hlist_for_each_entry_safe(bfqq, next, &bfqg->children, children_node)
> > +		bfq_bfqq_move(bfqd, bfqq, bfqd->root_group);
> 
> Here I assume root_group is (representing) the global blkcg root and
> this reparenting thus skips all ancestors between the removed leaf and
> the root. IIUC the associated io_context would then be treated as if it
> was running in the root blkcg.
> (Admittedly, this isn't a change from this patch but it may cause some
> surprises if the given process runs after the operation.)

Yes, this is what happens in bfq_reparent_children() and basically
preserves what BFQ was already doing for a subset of bfq queues.

> Reparenting to the immediate ancestors should be safe as cgroup core
> should ensure children are offlined before parents. Would it make sense
> to you?

I suppose yes, it makes more sense to reparent just to immediate parents
instead of the root of the blkcg hierarchy. Initially when developing the
patch I was not sure whether parent has to be still alive but as you write
it should be safe. I'll modify the patch to:

static void bfq_reparent_children(struct bfq_data *bfqd, struct bfq_group *bfqg)
{
        struct bfq_queue *bfqq;
        struct hlist_node *next;
        struct bfq_group *parent;

        parent = bfqg_parent(bfqg);
        if (!parent)
                parent = bfqd->root_group;

        hlist_for_each_entry_safe(bfqq, next, &bfqg->children, children_node)
                bfq_bfqq_move(bfqd, bfqq, parent);
}

 
> > @@ -897,38 +844,17 @@ static void bfq_pd_offline(struct blkg_policy_data *pd)
> > [...]
> > -		 * It may happen that some queues are still active
> > -		 * (busy) upon group destruction (if the corresponding
> > -		 * processes have been forced to terminate). We move
> > -		 * all the leaf entities corresponding to these queues
> > -		 * to the root_group.
> 
> This comment is removed but it seems to me it assumed that the
> reparented entities are only some transitional remainings of terminated
> tasks but they may be the processes migrated upwards with a long (IO
> active) life ahead.

Yes, this seemed to be a misconception of the old code...

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
