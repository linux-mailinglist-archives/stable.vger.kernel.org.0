Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A69C1B6ADD
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 03:35:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726158AbgDXBfl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 21:35:41 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:27180 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725913AbgDXBfl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 21:35:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587692139;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mE9Xh8mrcpOk6T4hIIq35lM4lacrhC50tnRMlWlgS+c=;
        b=ii2FQ9kjj7bt7gdiWhEuPSUDJKdLbn6iXWr9UtsWpvYPpLW5vbdhKP4cPKgv+uSfxbIV2M
        5OxNbD2KM0HEztNvBQUDVK2Eo6eBPedjaLN+3HuvSMweYABjUa09QnrKdysboQzjsOAatr
        DfA6fBP1cc1S5XUnF7z+yu4WiOmh79c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-297-ArNzbblSNFSNTtHtyJheKw-1; Thu, 23 Apr 2020 21:35:35 -0400
X-MC-Unique: ArNzbblSNFSNTtHtyJheKw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 85AB280B70B;
        Fri, 24 Apr 2020 01:35:33 +0000 (UTC)
Received: from T590 (ovpn-8-25.pek2.redhat.com [10.72.8.25])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 42BF060C81;
        Fri, 24 Apr 2020 01:35:23 +0000 (UTC)
Date:   Fri, 24 Apr 2020 09:35:19 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Doug Anderson <dianders@chromium.org>
Cc:     John Garry <john.garry@huawei.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Jens Axboe <axboe@kernel.dk>,
        linux-block <linux-block@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Guenter Roeck <groeck@chromium.org>
Subject: Re: [PATCH] blk-mq: Put driver tag in blk_mq_dispatch_rq_list() when
 no budget
Message-ID: <20200424013519.GA355437@T590>
References: <1587035931-125028-1-git-send-email-john.garry@huawei.com>
 <e5416179-2ba0-c9a8-1b86-d52eae29e146@acm.org>
 <663d472a-5bde-4b89-3137-c7bfdf4d7b97@huawei.com>
 <CAD=FV=XBrKgng+vYzJx+qsOEZ-cZ10A0t+pRh=FcbQMop2ht4Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAD=FV=XBrKgng+vYzJx+qsOEZ-cZ10A0t+pRh=FcbQMop2ht4Q@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 23, 2020 at 03:42:37PM -0700, Doug Anderson wrote:
> Hi,
> 
> On Mon, Apr 20, 2020 at 1:23 AM John Garry <john.garry@huawei.com> wrote:
> >
> > On 18/04/2020 03:43, Bart Van Assche wrote:
> > > On 2020-04-16 04:18, John Garry wrote:
> > >> If in blk_mq_dispatch_rq_list() we find no budget, then we break of the
> > >> dispatch loop, but the request may keep the driver tag, evaulated
> > >> in 'nxt' in the previous loop iteration.
> > >>
> > >> Fix by putting the driver tag for that request.
> > >>
> > >> Signed-off-by: John Garry <john.garry@huawei.com>
> > >>
> > >> diff --git a/block/blk-mq.c b/block/blk-mq.c
> > >> index 8e56884fd2e9..a7785df2c944 100644
> > >> --- a/block/blk-mq.c
> > >> +++ b/block/blk-mq.c
> > >> @@ -1222,8 +1222,10 @@ bool blk_mq_dispatch_rq_list(struct request_queue *q, struct list_head *list,
> > >>              rq = list_first_entry(list, struct request, queuelist);
> > >>
> > >>              hctx = rq->mq_hctx;
> > >> -            if (!got_budget && !blk_mq_get_dispatch_budget(hctx))
> > >> +            if (!got_budget && !blk_mq_get_dispatch_budget(hctx)) {
> > >> +                    blk_mq_put_driver_tag(rq);
> > >>                      break;
> > >> +            }
> > >>
> > >>              if (!blk_mq_get_driver_tag(rq)) {
> > >>                      /*
> > >
> > > Is this something that can only happen if q->mq_ops->queue_rq(hctx, &bd)
> > > returns another value than BLK_STS_OK, BLK_STS_RESOURCE and
> > > BLK_STS_DEV_RESOURCE?
> >
> > Right, as that case is handled in blk_mq_handle_dev_resource()
> >
> > If so, please add a comment in the source code
> > > that explains this.
> >
> > So important that we should now do this in an extra patch?
> >
> > >
> > > Is this perhaps a bug fix for 0bca799b9280 ("blk-mq: order getting
> > > budget and driver tag")? If so, please mention this and add Cc tags for
> > > the people who were Cc-ed on that patch.
> >
> > So it looks like 0bca799b9280 had a flaw, but I am not sure if anything
> > got broken there and worthy of stable backport.
> >
> > I found this issue while debugging Ming's blk-mq cpu hotplug patchset,
> > which I feel is ready to merge.
> >
> > Having said that, this nasty issue did take > 1 day for me to debug...
> > so let me know.
> 
> As per the above conversation, presumably this should go to stable
> then for any kernel that has commit 0bca799b9280 ("blk-mq: order
> getting budget and driver tag")?  For instance, I think 4.19 would be
> affected?  When I picked it there I got a conflict due to not having
> commit ea4f995ee8b8 ("blk-mq: cache request hardware queue mapping")
> but I think it's just a context collision and easy to resolve.
> 
> I'm no expert in the block code, but I posted my backport to 4.19 at
> <https://crrev.com/c/2163313>.  I'm happy to send an email as a patch
> to the list too or double-check that someone else's conflict
> resolution matches mine.

The thing is that there may not user visible effect by this issue,
when one tag isn't freed, this request will be re-dispatched soon.
That said it just makes the tag lifetime longer.

It could only be an issue in case of request dependency, meantime
the tag space is quite limited. However, not sure if there is such
case in reality.


Thanks,
Ming

