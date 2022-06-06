Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF06C53EB11
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 19:09:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238204AbiFFNC4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 09:02:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238209AbiFFNC4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 09:02:56 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15FFC27156
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 06:02:55 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id C13B321A9C;
        Mon,  6 Jun 2022 13:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1654520573; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7tl/l4O2ScYbyCluYUtUmbifwWPLcXFJkfC/RarYT7U=;
        b=LB/nK32J648ySkYp56YjCjTZe1tp7w5j1CkF1vh1wWIiFAYwreYRTa6Nnvk11Ys8YugB0r
        2rf/b+M7zTYUYo/drGf4VbcwccvJbtqHwwXEUWWCMq5uP1tjW2mtfxQa5hXs9+qVp6tdZh
        i5mv+wKQ6b0zOGqNOw7KJvaJJYMtyjg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1654520573;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7tl/l4O2ScYbyCluYUtUmbifwWPLcXFJkfC/RarYT7U=;
        b=ndJyK/tegadcKK/DhzFoJWVt9wtK+46UnP3x5OhTQX2oRlwI0DjWPwv0uaakAr/dXnTpF5
        JXJYaBGIgknlzoAw==
Received: from quack3.suse.cz (unknown [10.163.28.18])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id AB1802C141;
        Mon,  6 Jun 2022 13:02:53 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 1C92CA0633; Mon,  6 Jun 2022 15:02:53 +0200 (CEST)
Date:   Mon, 6 Jun 2022 15:02:53 +0200
From:   Jan Kara <jack@suse.cz>
To:     gregkh@linuxfoundation.org
Cc:     jack@suse.cz, axboe@kernel.dk, hch@lst.de, yukuai3@huawei.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] bfq: Split shared queues on move between
 cgroups" failed to apply to 4.19-stable tree
Message-ID: <20220606130253.h2khtboi3nka7d3c@quack3.lan>
References: <16545166495292@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <16545166495292@kroah.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Greg!

I've seen this patch failed to apply to 4.19 and 4.14 stable trees but
you've still merged (some) of the patches following this one from the same
series. Honestly, I would not consider the result very trustworthy. The
code involved is rather complex with subtle interactions across subsystems.
So please remove also upstream commits:

ea591cd4eb27 ("bfq: Update cgroup information before merging bio")
fc84e1f941b9 ("bfq: Drop pointless unlock-lock pair")
5f550ede5edf ("bfq: Remove pointless bfq_init_rq() calls")
09f871868080 ("bfq: Track whether bfq_group is still online")
4e54a2493e58 ("bfq: Get rid of __bio_blkcg() usage")
075a53b78b81 ("bfq: Make sure bfqg for which we are queueing requests is online")

from 4.14 and 4.19 stable queues. If someone will need these fixes there,
he'll need to do proper backport with targetted testing etc... Thanks!

								Honza

On Mon 06-06-22 13:57:29, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.19-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,
> 
> greg k-h
> 
> ------------------ original commit in Linus's tree ------------------
> 
> From 3bc5e683c67d94bd839a1da2e796c15847b51b69 Mon Sep 17 00:00:00 2001
> From: Jan Kara <jack@suse.cz>
> Date: Fri, 1 Apr 2022 12:27:44 +0200
> Subject: [PATCH] bfq: Split shared queues on move between cgroups
> 
> When bfqq is shared by multiple processes it can happen that one of the
> processes gets moved to a different cgroup (or just starts submitting IO
> for different cgroup). In case that happens we need to split the merged
> bfqq as otherwise we will have IO for multiple cgroups in one bfqq and
> we will just account IO time to wrong entities etc.
> 
> Similarly if the bfqq is scheduled to merge with another bfqq but the
> merge didn't happen yet, cancel the merge as it need not be valid
> anymore.
> 
> CC: stable@vger.kernel.org
> Fixes: e21b7a0b9887 ("block, bfq: add full hierarchical scheduling and cgroups support")
> Tested-by: "yukuai (C)" <yukuai3@huawei.com>
> Signed-off-by: Jan Kara <jack@suse.cz>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Link: https://lore.kernel.org/r/20220401102752.8599-3-jack@suse.cz
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> 
> diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
> index 420eda2589c0..9352f3cc2377 100644
> --- a/block/bfq-cgroup.c
> +++ b/block/bfq-cgroup.c
> @@ -743,9 +743,39 @@ static struct bfq_group *__bfq_bic_change_cgroup(struct bfq_data *bfqd,
>  	}
>  
>  	if (sync_bfqq) {
> -		entity = &sync_bfqq->entity;
> -		if (entity->sched_data != &bfqg->sched_data)
> -			bfq_bfqq_move(bfqd, sync_bfqq, bfqg);
> +		if (!sync_bfqq->new_bfqq && !bfq_bfqq_coop(sync_bfqq)) {
> +			/* We are the only user of this bfqq, just move it */
> +			if (sync_bfqq->entity.sched_data != &bfqg->sched_data)
> +				bfq_bfqq_move(bfqd, sync_bfqq, bfqg);
> +		} else {
> +			struct bfq_queue *bfqq;
> +
> +			/*
> +			 * The queue was merged to a different queue. Check
> +			 * that the merge chain still belongs to the same
> +			 * cgroup.
> +			 */
> +			for (bfqq = sync_bfqq; bfqq; bfqq = bfqq->new_bfqq)
> +				if (bfqq->entity.sched_data !=
> +				    &bfqg->sched_data)
> +					break;
> +			if (bfqq) {
> +				/*
> +				 * Some queue changed cgroup so the merge is
> +				 * not valid anymore. We cannot easily just
> +				 * cancel the merge (by clearing new_bfqq) as
> +				 * there may be other processes using this
> +				 * queue and holding refs to all queues below
> +				 * sync_bfqq->new_bfqq. Similarly if the merge
> +				 * already happened, we need to detach from
> +				 * bfqq now so that we cannot merge bio to a
> +				 * request from the old cgroup.
> +				 */
> +				bfq_put_cooperator(sync_bfqq);
> +				bfq_release_process_ref(bfqd, sync_bfqq);
> +				bic_set_bfqq(bic, NULL, 1);
> +			}
> +		}
>  	}
>  
>  	return bfqg;
> diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
> index 7d00b21ebe5d..89fe3f85eb3c 100644
> --- a/block/bfq-iosched.c
> +++ b/block/bfq-iosched.c
> @@ -5315,7 +5315,7 @@ static void bfq_put_stable_ref(struct bfq_queue *bfqq)
>  	bfq_put_queue(bfqq);
>  }
>  
> -static void bfq_put_cooperator(struct bfq_queue *bfqq)
> +void bfq_put_cooperator(struct bfq_queue *bfqq)
>  {
>  	struct bfq_queue *__bfqq, *next;
>  
> diff --git a/block/bfq-iosched.h b/block/bfq-iosched.h
> index 3b83e3d1c2e5..a56763045d19 100644
> --- a/block/bfq-iosched.h
> +++ b/block/bfq-iosched.h
> @@ -979,6 +979,7 @@ void bfq_weights_tree_remove(struct bfq_data *bfqd,
>  void bfq_bfqq_expire(struct bfq_data *bfqd, struct bfq_queue *bfqq,
>  		     bool compensate, enum bfqq_expiration reason);
>  void bfq_put_queue(struct bfq_queue *bfqq);
> +void bfq_put_cooperator(struct bfq_queue *bfqq);
>  void bfq_end_wr_async_queues(struct bfq_data *bfqd, struct bfq_group *bfqg);
>  void bfq_release_process_ref(struct bfq_data *bfqd, struct bfq_queue *bfqq);
>  void bfq_schedule_dispatch(struct bfq_data *bfqd);
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
