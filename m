Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FFDB251EF9
	for <lists+stable@lfdr.de>; Tue, 25 Aug 2020 20:24:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726158AbgHYSYY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Aug 2020 14:24:24 -0400
Received: from netrider.rowland.org ([192.131.102.5]:50593 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1726119AbgHYSYY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Aug 2020 14:24:24 -0400
Received: (qmail 376896 invoked by uid 1000); 25 Aug 2020 14:24:23 -0400
Date:   Tue, 25 Aug 2020 14:24:23 -0400
From:   Alan Stern <stern@rowland.harvard.edu>
To:     Stanley Chu <stanley.chu@mediatek.com>
Cc:     Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>,
        linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Ming Lei <ming.lei@redhat.com>,
        stable <stable@vger.kernel.org>, Can Guo <cang@codeaurora.org>
Subject: Re: [PATCH] block: Fix a race in the runtime power management code
Message-ID: <20200825182423.GB375466@rowland.harvard.edu>
References: <20200824030607.19357-1-bvanassche@acm.org>
 <1598346681.10649.8.camel@mtkswgap22>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1598346681.10649.8.camel@mtkswgap22>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 25, 2020 at 05:11:21PM +0800, Stanley Chu wrote:
> Sorry, resend to fix typo.
> 
> Hi Bart,
> 
> On Sun, 2020-08-23 at 20:06 -0700, Bart Van Assche wrote:
> > With the current implementation the following race can happen:
> > * blk_pre_runtime_suspend() calls blk_freeze_queue_start() and
> >   blk_mq_unfreeze_queue().
> > * blk_queue_enter() calls blk_queue_pm_only() and that function returns
> >   true.
> > * blk_queue_enter() calls blk_pm_request_resume() and that function does
> >   not call pm_request_resume() because the queue runtime status is
> >   RPM_ACTIVE.
> > * blk_pre_runtime_suspend() changes the queue status into RPM_SUSPENDING.
> > 
> > Fix this race by changing the queue runtime status into RPM_SUSPENDING
> > before switching q_usage_counter to atomic mode.
> > 
> > Cc: Alan Stern <stern@rowland.harvard.edu>
> > Cc: Stanley Chu <stanley.chu@mediatek.com>
> > Cc: Ming Lei <ming.lei@redhat.com>
> > Cc: stable <stable@vger.kernel.org>
> > Fixes: 986d413b7c15 ("blk-mq: Enable support for runtime power management")
> > Signed-off-by: Can Guo <cang@codeaurora.org>
> > Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> > ---
> >  block/blk-pm.c | 15 +++++++++------
> >  1 file changed, 9 insertions(+), 6 deletions(-)
> > 
> > diff --git a/block/blk-pm.c b/block/blk-pm.c
> > index b85234d758f7..17bd020268d4 100644
> > --- a/block/blk-pm.c
> > +++ b/block/blk-pm.c
> > @@ -67,6 +67,10 @@ int blk_pre_runtime_suspend(struct request_queue *q)
> >  
> >  	WARN_ON_ONCE(q->rpm_status != RPM_ACTIVE);
> >  
> > +	spin_lock_irq(&q->queue_lock);
> > +	q->rpm_status = RPM_SUSPENDING;
> > +	spin_unlock_irq(&q->queue_lock);
> > +
> 
> Has below alternative way been considered that RPM_SUSPENDING is set
> after blk_freeze_queue_start()?
> 
> 	blk_freeze_queue_start(q);
> 
> +	spin_lock_irq(&q->queue_lock);
> +	q->rpm_status = RPM_SUSPENDING;
> +	spin_unlock_irq(&q->queue_lock);
> 
> 
> Otherwise requests can enter queue while rpm_status is RPM_SUSPENDING
> during a small window, i.e., before blk_set_pm_only() is invoked. This
> would make the definition of rpm_status ambiguous.
> 
> In this way, the racing could be also solved:
> 
> - Before blk_freeze_queue_start(), any requests shall be allowed to
> enter queue
> - blk_freeze_queue_start() freezes the queue and blocks all upcoming
> requests (make them wait_event(q->mq_freeze_wq))
> - rpm_status is set as RPM_SUSPENDING
> - blk_mq_unfreeze_queue() wakes up q->mq_freeze_wq and then
> blk_pm_request_resume() can be executed

A very similar question arises concerning the transition from 
RPM_SUSPENDING to RPM_SUSPENDED.  I am not convinced that the existing 
synchronization is sufficient.  However, this may not matter because...

A related question concerns the BLK_MQ_REQ_PREEMPT flag.  If it is set 
then the request is allowed whilel rpm_status is RPM_SUSPENDING.  But in 
fact, the only requests which should be allowed at that time are those 
created by the lower-layer driver as part of its runtime-suspend 
handling; all other requests should be deferred.  The BLK_MQ_REQ_PREEMPT 
flag doesn't seem like the right way to achieve this.  Should we be 
using a different flag?

Alan Stern
