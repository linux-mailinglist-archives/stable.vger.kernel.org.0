Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A5285148B8
	for <lists+stable@lfdr.de>; Fri, 29 Apr 2022 14:02:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354960AbiD2MFR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Apr 2022 08:05:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235150AbiD2MFQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Apr 2022 08:05:16 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8571483BF;
        Fri, 29 Apr 2022 05:01:54 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 900311F891;
        Fri, 29 Apr 2022 12:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1651233713; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=E4v0J7E7TIHLnhe4FA9TirvyYrl7Jt4fCW8B/8OF+Yg=;
        b=YatVXBU0Ln0fYAWeEC4C+9MDbnW73SALU1/KHMg6VYTowiLWgr+2icn5jSy9L8CmpnvIP6
        0SSrKsr9BkP+JtvAJmfZhx3JPtspLDdvi0v+jxWRQNnGN0JfGKJMZLEFL3k3M0k3J4tS7u
        JlL+6Uom/HX98RRa768k7Fj4ohwBjoE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1651233713;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=E4v0J7E7TIHLnhe4FA9TirvyYrl7Jt4fCW8B/8OF+Yg=;
        b=tDW/+ovYrQU5rvIe9X3ygr4epYrmg2WPyV+fj7EgsTH40ntyD53UTIAq7ApSNK3Nw4MJp9
        o1NzFT1Spv3nnFAQ==
Received: from quack3.suse.cz (unknown [10.100.224.230])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 315862C141;
        Fri, 29 Apr 2022 12:01:53 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id D8669A061D; Fri, 29 Apr 2022 14:01:52 +0200 (CEST)
Date:   Fri, 29 Apr 2022 14:01:52 +0200
From:   Jan Kara <jack@suse.cz>
To:     Paolo Valente <paolo.valente@linaro.org>
Cc:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Chris Murphy <lists@colorremedies.com>,
        "yukuai (C)" <yukuai3@huawei.com>, Jan Kara <jack@suse.cz>,
        stable@vger.kernel.org
Subject: Re: [PATCH] bfq: Fix warning in bfqq_request_over_limit()
Message-ID: <20220429120152.w6stp5nfedwoyzp3@quack3.lan>
References: <20220407140738.9723-1-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220407140738.9723-1-jack@suse.cz>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu 07-04-22 16:07:38, Jan Kara wrote:
> People are occasionally reporting a warning bfqq_request_over_limit()
> triggering reporting that BFQ's idea of cgroup hierarchy (and its depth)
> does not match what generic blkcg code thinks. This can actually happen
> when bfqq gets moved between BFQ groups while bfqq_request_over_limit()
> is running. Make sure the code is safe against BFQ queue being moved to
> a different BFQ group.
> 
> Fixes: 76f1df88bbc2 ("bfq: Limit number of requests consumed by each cgroup")
> CC: stable@vger.kernel.org
> Link: https://lore.kernel.org/all/CAJCQCtTw_2C7ZSz7as5Gvq=OmnDiio=HRkQekqWpKot84sQhFA@mail.gmail.com/
> Reported-by: Chris Murphy <lists@colorremedies.com>
> Reported-by: "yukuai (C)" <yukuai3@huawei.com>
> Signed-off-by: Jan Kara <jack@suse.cz>

Ping guys? Can we get the fix in please? It is pretty trivial...

								Honza

> ---
>  block/bfq-iosched.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
> index e47c75f1fa0f..272d48d8f326 100644
> --- a/block/bfq-iosched.c
> +++ b/block/bfq-iosched.c
> @@ -569,7 +569,7 @@ static bool bfqq_request_over_limit(struct bfq_queue *bfqq, int limit)
>  	struct bfq_entity *entity = &bfqq->entity;
>  	struct bfq_entity *inline_entities[BFQ_LIMIT_INLINE_DEPTH];
>  	struct bfq_entity **entities = inline_entities;
> -	int depth, level;
> +	int depth, level, alloc_depth = BFQ_LIMIT_INLINE_DEPTH;
>  	int class_idx = bfqq->ioprio_class - 1;
>  	struct bfq_sched_data *sched_data;
>  	unsigned long wsum;
> @@ -578,15 +578,21 @@ static bool bfqq_request_over_limit(struct bfq_queue *bfqq, int limit)
>  	if (!entity->on_st_or_in_serv)
>  		return false;
>  
> +retry:
> +	spin_lock_irq(&bfqd->lock);
>  	/* +1 for bfqq entity, root cgroup not included */
>  	depth = bfqg_to_blkg(bfqq_group(bfqq))->blkcg->css.cgroup->level + 1;
> -	if (depth > BFQ_LIMIT_INLINE_DEPTH) {
> +	if (depth > alloc_depth) {
> +		spin_unlock_irq(&bfqd->lock);
> +		if (entities != inline_entities)
> +			kfree(entities);
>  		entities = kmalloc_array(depth, sizeof(*entities), GFP_NOIO);
>  		if (!entities)
>  			return false;
> +		alloc_depth = depth;
> +		goto retry;
>  	}
>  
> -	spin_lock_irq(&bfqd->lock);
>  	sched_data = entity->sched_data;
>  	/* Gather our ancestors as we need to traverse them in reverse order */
>  	level = 0;
> -- 
> 2.34.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
