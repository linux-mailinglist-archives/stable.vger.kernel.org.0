Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26699646CBE
	for <lists+stable@lfdr.de>; Thu,  8 Dec 2022 11:30:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbiLHKai (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Dec 2022 05:30:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiLHKah (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Dec 2022 05:30:37 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 093C47BC30;
        Thu,  8 Dec 2022 02:30:32 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 706DE20887;
        Thu,  8 Dec 2022 10:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1670495431; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=M+bAb0574eGy8HD5RdUbfzdvVPdRwbdf16Yr8+WOH0U=;
        b=0jOrjMaHdTXh8BSxcjrXqlAL8iy56svl+pRuefc/Ge/WaFb4jVVFGQjYS+WsnmFk7VXqMw
        a/IljK2Z26YX6ivzySjZFoIY7tZNOeG1KmVfCShEOmihiJ9B0eQv3jkMPwuPySQ1Jdyqvx
        f2uum26mM2BKDjJwBxE3GHeLD6tlBmU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1670495431;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=M+bAb0574eGy8HD5RdUbfzdvVPdRwbdf16Yr8+WOH0U=;
        b=MZ1fJUeZxG3Rd7s5vW+cm6N4eINDVXc0EdGvJtJ220xYBr5GT/2dBGy8UCs9pRErMZHunP
        jKIY9aLEAWcbn1Cw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 5155F13416;
        Thu,  8 Dec 2022 10:30:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id OPbSE8e8kWP5FAAAMHmgww
        (envelope-from <jack@suse.cz>); Thu, 08 Dec 2022 10:30:31 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 169ADA0728; Thu,  8 Dec 2022 10:37:33 +0100 (CET)
Date:   Thu, 8 Dec 2022 10:37:33 +0100
From:   Jan Kara <jack@suse.cz>
To:     Yu Kuai <yukuai1@huaweicloud.com>
Cc:     Jan Kara <jack@suse.cz>, linux-block@vger.kernel.org,
        Paolo Valente <paolo.valente@linaro.org>,
        Jens Axboe <axboe@kernel.dk>, stable@vger.kernel.org,
        "yukuai (C)" <yukuai3@huawei.com>
Subject: Re: [PATCH 3/9] bfq: Split shared queues on move between cgroups
Message-ID: <20221208093733.izj7irhzspmvpxxc@quack3>
References: <20220330123438.32719-1-jack@suse.cz>
 <20220330124255.24581-3-jack@suse.cz>
 <89941655-baeb-9696-dc89-0a1f4bc9e8d6@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <89941655-baeb-9696-dc89-0a1f4bc9e8d6@huaweicloud.com>
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_SOFTFAIL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu 08-12-22 11:52:38, Yu Kuai wrote:
> Hi, Jan!
> 
> 在 2022/03/30 20:42, Jan Kara 写道:
> > When bfqq is shared by multiple processes it can happen that one of the
> > processes gets moved to a different cgroup (or just starts submitting IO
> > for different cgroup). In case that happens we need to split the merged
> > bfqq as otherwise we will have IO for multiple cgroups in one bfqq and
> > we will just account IO time to wrong entities etc.
> > 
> > Similarly if the bfqq is scheduled to merge with another bfqq but the
> > merge didn't happen yet, cancel the merge as it need not be valid
> > anymore.
> > 
> > CC: stable@vger.kernel.org
> > Fixes: e21b7a0b9887 ("block, bfq: add full hierarchical scheduling and cgroups support")
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >   block/bfq-cgroup.c  | 36 +++++++++++++++++++++++++++++++++---
> >   block/bfq-iosched.c |  2 +-
> >   block/bfq-iosched.h |  1 +
> >   3 files changed, 35 insertions(+), 4 deletions(-)
> > 
> > diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
> > index 420eda2589c0..9352f3cc2377 100644
> > --- a/block/bfq-cgroup.c
> > +++ b/block/bfq-cgroup.c
> > @@ -743,9 +743,39 @@ static struct bfq_group *__bfq_bic_change_cgroup(struct bfq_data *bfqd,
> >   	}
> >   	if (sync_bfqq) {
> > -		entity = &sync_bfqq->entity;
> > -		if (entity->sched_data != &bfqg->sched_data)
> > -			bfq_bfqq_move(bfqd, sync_bfqq, bfqg);
> > +		if (!sync_bfqq->new_bfqq && !bfq_bfqq_coop(sync_bfqq)) {
> > +			/* We are the only user of this bfqq, just move it */
> > +			if (sync_bfqq->entity.sched_data != &bfqg->sched_data)
> > +				bfq_bfqq_move(bfqd, sync_bfqq, bfqg);
> > +		} else {
> > +			struct bfq_queue *bfqq;
> > +
> > +			/*
> > +			 * The queue was merged to a different queue. Check
> > +			 * that the merge chain still belongs to the same
> > +			 * cgroup.
> > +			 */
> > +			for (bfqq = sync_bfqq; bfqq; bfqq = bfqq->new_bfqq)
> > +				if (bfqq->entity.sched_data !=
> > +				    &bfqg->sched_data)
> > +					break;
> > +			if (bfqq) {
> > +				/*
> > +				 * Some queue changed cgroup so the merge is
> > +				 * not valid anymore. We cannot easily just
> > +				 * cancel the merge (by clearing new_bfqq) as
> > +				 * there may be other processes using this
> > +				 * queue and holding refs to all queues below
> > +				 * sync_bfqq->new_bfqq. Similarly if the merge
> > +				 * already happened, we need to detach from
> > +				 * bfqq now so that we cannot merge bio to a
> > +				 * request from the old cgroup.
> > +				 */
> > +				bfq_put_cooperator(sync_bfqq);
> > +				bfq_release_process_ref(bfqd, sync_bfqq);
> > +				bic_set_bfqq(bic, NULL, 1);
> > +			}
> > +		}
> >   	}
> Our test found a use-after-free while accessing bfqq->bic->bfqq[] ([1]),
> and I really suspect the above change.

OK, so bfqq points to bfq_io_cq that is already freed. Nasty.

> 1) init state, 2 thread, 2 bic, and 2 bfqq
> 
> bic1->bfqq = bfqq1
> bfqq1->bic = bic1
> bic2->bfqq = bfqq2
> bfqq2->bic = bic2
> 
> 2) bfqq1 and bfqq2 is merged
> bic1->bfqq = bfqq2
> bfqq1->bic = NULL
> bic2->bfqq = bfqq2
> bfqq2->bic = NULL
> 
> 3) bfqq1 issue a io, before such io reaches bfq, move t1 to a new
> cgroup, and issues a new io. If the new io reaches bfq first:

What do you mean by 'bfqq1 issues IO'? Do you mean t1?

> bic1->bfqq = NULL
> bfqq1->bic = NULL
> bic2->bfqq = bfqq2
> bfqq2->bic = NULL
> 
> 4) while handling the new io, a new bfqq is created
> bic1->bfqq = bfqq3
> bfqq3->bic = bic1
> bic2->bfqq = bfqq2
> bfqq2->bic = NULL
> 
> 5) the old io reaches bfq, corresponding bic is got from rq:
> bic1->bfqq = bfqq3
> bfqq3->bic = bic1
> bic2->bfqq = bfqq2
> bfqq2->bic = bic1

So if this state happens, it would be indeed a problem. But I don't see how
it could happen. bics are associated with the process. So t1 will always
use bic1, t2 will always use bic2. In bfq_init_rq() we get bfqq either from
bic (so it would return bfqq3 for bic1) or we allocate a new queue (that
would be some bfqq4). So I see no way how bfqq2 could start pointing to
bic1...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
