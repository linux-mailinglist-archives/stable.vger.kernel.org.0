Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 878284866F0
	for <lists+stable@lfdr.de>; Thu,  6 Jan 2022 16:45:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240584AbiAFPpt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jan 2022 10:45:49 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:47190 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240593AbiAFPpq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Jan 2022 10:45:46 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 5107B1F39E;
        Thu,  6 Jan 2022 15:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1641483945; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=14vcaJeWLzoYqMo5aNvjxM3LWBDBywLknqQjafAzAYM=;
        b=cFoRphpgYg//vPAzdSTOh3YkeqW1VW9Ud3QiF7H8+hWiiav9zLi697nEswlr54VGjWZ0ZD
        vxmDYffrEs3T65DBACISN8yrw8flGVZ8EUGD6XT5LXLk2oZrYjC7pi0cU733jaoQ6uaGiE
        Hb0nZDYVjXjPgJL5JvChW7mNr4ugfOM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1641483945;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=14vcaJeWLzoYqMo5aNvjxM3LWBDBywLknqQjafAzAYM=;
        b=sy2Pa5IDn5YbF4t38FsIv1zMqC4iH0HAGzjAkeYN2nUtuLR21/mgY6CPLtIFJ3RBMA8E4f
        Dzm6mvQzNhW7bbAg==
Received: from quack3.suse.cz (unknown [10.163.43.118])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 455D9A3B88;
        Thu,  6 Jan 2022 15:45:45 +0000 (UTC)
Received: by localhost (Postfix, from userid 1000)
        id 04AAAA05A4; Mon,  3 Jan 2022 14:16:55 +0100 (CET)
Date:   Mon, 3 Jan 2022 14:16:54 +0100
From:   Jan Kara <jack@suse.cz>
To:     "yukuai (C)" <yukuai3@huawei.com>
Cc:     Jan Kara <jack@suse.cz>, linux-block@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>,
        Paolo Valente <paolo.valente@linaro.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH 2/3] bfq: Avoid merging queues with different parents
Message-ID: <20220103131654.7seobu6gqhigjv2m@quack3>
References: <20211223171425.3551-1-jack@suse.cz>
 <20211223173207.15388-2-jack@suse.cz>
 <fec7558a-1559-dae0-fe21-d11876dc7473@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fec7558a-1559-dae0-fe21-d11876dc7473@huawei.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri 24-12-21 09:45:02, yukuai (C) wrote:
> 在 2021/12/24 1:31, Jan Kara 写道:
> > diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
> > index 056399185c2f..0da47f2ca781 100644
> > --- a/block/bfq-iosched.c
> > +++ b/block/bfq-iosched.c
> > @@ -2638,6 +2638,14 @@ bfq_setup_merge(struct bfq_queue *bfqq, struct bfq_queue *new_bfqq)
> >   	if (process_refs == 0 || new_process_refs == 0)
> >   		return NULL;
> > +	/*
> > +	 * Make sure merged queues belong to the same parent. Parents could
> > +	 * have changed since the time we decided the two queues are suitable
> > +	 * for merging.
> > +	 */
> > +	if (new_bfqq->entity.parent != bfqq->entity.parent)
> > +		return NULL;
> > +
> Hi,
> 
> This seems unnecessary, the caller of bfq_setup_merge() aready make sure
> bfqq and new_bfqq are under the same bfqg. Am I missing something?

Not all the callers of bfq_setup_merge() check that queues belong to the
same cgroup (e.g. bfq_setup_cooperator() does not seem to check).

								Honza

> 
> Thanks,
> Kuai
> >   	bfq_log_bfqq(bfqq->bfqd, bfqq, "scheduling merge with queue %d",
> >   		new_bfqq->pid);
> > 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
