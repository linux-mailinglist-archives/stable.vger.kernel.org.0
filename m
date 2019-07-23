Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E10D770E5F
	for <lists+stable@lfdr.de>; Tue, 23 Jul 2019 03:01:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731296AbfGWBBX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jul 2019 21:01:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59286 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730868AbfGWBBX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Jul 2019 21:01:23 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D8DDD4E92A;
        Tue, 23 Jul 2019 01:01:22 +0000 (UTC)
Received: from ming.t460p (ovpn-8-21.pek2.redhat.com [10.72.8.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 511BD5B685;
        Tue, 23 Jul 2019 01:01:02 +0000 (UTC)
Date:   Tue, 23 Jul 2019 09:00:55 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, "Ewan D . Milne" <emilne@redhat.com>,
        Hannes Reinecke <hare@suse.com>,
        Christoph Hellwig <hch@lst.de>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        stable@vger.kernel.org
Subject: Re: [PATCH V2 1/2] blk-mq: add callback of .cleanup_rq
Message-ID: <20190723010053.GA30776@ming.t460p>
References: <20190720030637.14447-1-ming.lei@redhat.com>
 <20190720030637.14447-2-ming.lei@redhat.com>
 <4ffe9dd8-9e86-fd93-828e-78c1e5931c5f@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ffe9dd8-9e86-fd93-828e-78c1e5931c5f@acm.org>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Tue, 23 Jul 2019 01:01:23 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 22, 2019 at 09:51:27AM -0700, Bart Van Assche wrote:
> On 7/19/19 8:06 PM, Ming Lei wrote:
> > diff --git a/block/blk-mq.c b/block/blk-mq.c
> > index b038ec680e84..fc38d95c557f 100644
> > --- a/block/blk-mq.c
> > +++ b/block/blk-mq.c
> > @@ -502,6 +502,9 @@ void blk_mq_free_request(struct request *rq)
> >   	struct blk_mq_ctx *ctx = rq->mq_ctx;
> >   	struct blk_mq_hw_ctx *hctx = rq->mq_hctx;
> > +	if (q->mq_ops->cleanup_rq)
> > +		q->mq_ops->cleanup_rq(rq);
> > +
> >   	if (rq->rq_flags & RQF_ELVPRIV) {
> >   		if (e && e->type->ops.finish_request)
> >   			e->type->ops.finish_request(rq);
> 
> I'm concerned about the performance impact of this change. How about not

Not see any performance impact in my test, and q->mq_ops should be in
data cache at that time.

> introducing .cleanup_rq() and adding a call to
> scsi_mq_uninit_cmd() in scsi_queue_rq() just before that function returns
> BLK_STS_RESOURCE or BLK_STS_DEV_RESOURCE?

The problem is that only dm-rq needs to free the request private data
when BLK_STS_RESOURCE or BLK_STS_DEV_RESOURCE is returned. If we do that
unconditionally, performance impact might be visible.


Thanks,
Ming
